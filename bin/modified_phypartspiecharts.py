#!/usr/bin/env python
"""
modified_phypartspiecharts.py

A modified version of the original PhyParts visualization script "phypartspiecharts.py", designed to generate
enhanced pie chart representations of gene tree conflicts. This script is part of the
HybSuite package and extends the functionality of the original "phypartspiecharts.py"

Key Features:
- Generates pie chart visualizations showing gene tree conflict patterns
- Supports multi-threading for improved performance
- Provides flexible output formats (SVG, PDF)
- Offers customizable display options for tree visualization
- Includes statistical analysis of gene tree conflicts
- Exports detailed conflict statistics in TSV format

Original concept from:
Smith et al. 2015. Resolving the phylogeny of lizards and snakes (Squamata) 
with extensive sampling of genes and species. Biology Letters 11: 20150062.

Requirements:
- Python 3
- ete3
- matplotlib
"""

import matplotlib
import sys
import argparse
import re
import json
import logging
from pathlib import Path
from typing import Dict, Tuple, List, Optional
from dataclasses import dataclass
from ete3 import Tree, TreeStyle, TextFace, NodeStyle, faces, COLOR_SCHEMES
import concurrent.futures
import threading
from concurrent.futures import ThreadPoolExecutor

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

class PhyPartsError(Exception):
    """Base exception class for PhyParts errors"""
    pass

class InputFileError(PhyPartsError):
    """Exception raised for input file related errors"""
    pass

class ColorError(PhyPartsError):
    """Exception raised for color related errors"""
    pass

def validate_color(color: str) -> bool:
    """Validate if the color string is a valid matplotlib color"""
    try:
        matplotlib.colors.to_rgb(color)
        return True
    except ValueError:
        return False

@dataclass
class PhyPartsConfig:
    """Configuration class for storing all runtime parameters"""
    species_tree: str
    phyparts_root: str
    num_genes: int
    taxon_subst: Optional[str] = None
    output: str = "pies.svg"
    output_node_tree: bool = False
    colors: Dict[str, str] = None
    no_ladderize: bool = False
    to_csv: bool = False
    vt_line_width: int = 0
    italic_names: bool = True
    dpi: int = 300
    tree_type: str = "cladogram"
    show_numbers: bool = True
    tip_size_factor: float = 1.0
    number_size_factor: float = 1.0
    pie_size_factor: float = 1.0
    show_num_mode: str = "12"
    stat_output: Optional[str] = None
    threads: int = 1

    def __post_init__(self):
        # Validate output file format
        valid_formats = [".svg", ".pdf"]
        file_ext = Path(self.output).suffix.lower()
        if not file_ext:
            raise ValueError("Output file must have an extension (.svg or .pdf)")
        if file_ext not in valid_formats:
            raise ValueError(f"Unsupported output format: {file_ext}. Supported formats: {', '.join(valid_formats)}")
        
        # Validate tree type
        valid_tree_types = ["circle", "cladogram", "phylo"]
        if self.tree_type not in valid_tree_types:
            raise ValueError(f"Invalid tree type: {self.tree_type}. Supported types: {', '.join(valid_tree_types)}")

        # Default color scheme
        if self.colors is None:
            self.colors = {
                "concordance": "blue",
                "top_conflict": "green",
                "other_conflict": "red",
                "no_signal": "darkgray"
            }
        
        # Validate color keys
        required_colors = {"concordance", "top_conflict", "other_conflict", "no_signal"}
        if not all(key in self.colors for key in required_colors):
            raise ValueError(f"Missing color definitions. Required colors: {required_colors}")
        
        # Validate colors
        for color_name, color_value in self.colors.items():
            if not validate_color(color_value):
                raise ColorError(f"Invalid color value for {color_name}: {color_value}")

        # Validate size factors
        if self.tip_size_factor <= 0:
            raise ValueError("Tip size factor must be positive")
        if self.number_size_factor <= 0:
            raise ValueError("Number size factor must be positive")
        if self.pie_size_factor <= 0:
            raise ValueError("Pie size factor must be positive")

        # Validate show number mode
        if self.show_num_mode is not None:
            try:
                # Convert string to number list
                mode_list = [int(d) for d in str(self.show_num_mode)]
                if len(mode_list) > 2:
                    raise ValueError("Show number mode must be 0-2 digits")
                valid_modes = set(range(9))  # Valid digits 0-8
                if not all(mode in valid_modes for mode in mode_list):
                    raise ValueError("Show number modes must be digits between 0 and 8")
                # If only one digit is input
                if len(mode_list) == 1:
                    if mode_list[0] == 0:
                        self.show_numbers = False  # Hide all numbers when input is 0
                    else:
                        self.show_num_mode = [mode_list[0], None]  # Show only one value
                else:
                    self.show_num_mode = mode_list  # Show two values
            except ValueError as e:
                raise ValueError(f"Invalid show number mode: {e}")

        # Validate thread count
        if self.threads < 1:
            raise ValueError("Number of threads must be positive")

class PhyPartsPieCharts:
    """Main class for processing PhyParts data and generating pie charts"""
    
    def __init__(self, config: PhyPartsConfig):
        self.config = config
        self.plot_tree = None
        self.subtrees_dict = {}
        self.subtrees_topids = {}
        self.concord_dict = {}
        self.conflict_dict = {}
        self.phyparts_dist = {}
        self.phyparts_pies = {}
        self.validate_input_files()
        self._lock = threading.Lock()  # Add thread lock

    def validate_input_files(self) -> None:
        """Validate existence of required input files"""
        required_files = [
            self.config.species_tree,
            f"{self.config.phyparts_root}.node.key",
            f"{self.config.phyparts_root}.concon.tre",
            f"{self.config.phyparts_root}.hist"
        ]
        for file_path in required_files:
            if not Path(file_path).exists():
                raise InputFileError(f"Required input file not found: {file_path}")

    def get_phyparts_nodes(self) -> None:
        """Read species tree and match phyparts nodes"""
        try:
            logging.info("Reading species tree...")
            sptree = Tree(self.config.species_tree)
            sptree.convert_to_ultrametric()

            logging.info("Processing node key file...")
            with open(f"{self.config.phyparts_root}.node.key") as f:
                phyparts_node_key = f.readlines()

            self.subtrees_dict = {n.split()[0]: Tree(n.split()[1]+";") for n in phyparts_node_key}
            self.subtrees_topids = {x: self.subtrees_dict[x].get_topology_id() for x in self.subtrees_dict}

            logging.info("Matching nodes...")
            for node in sptree.traverse():
                node_topid = node.get_topology_id()
                for subtree in self.subtrees_dict:
                    if node_topid == self.subtrees_topids[subtree]:
                        node.name = subtree

            self.plot_tree = sptree
            logging.info("Node matching completed")
        except Exception as e:
            logging.error(f"Error in get_phyparts_nodes: {e}")
            raise

    def process_data(self) -> None:
        """Process all PhyParts data"""
        logging.info("Starting data processing...")
        self._get_concord_and_conflict()
        logging.info("Concordance and conflict data processed")
        self._get_pie_chart_data()
        logging.info("Pie chart data generated")

    def _get_concord_and_conflict(self) -> None:
        """Get concordance and conflict data"""
        try:
            with open(f"{self.config.phyparts_root}.concon.tre") as f:
                concon_tree = Tree(f.readline())
                conflict_tree = Tree(f.readline())

            self.concord_dict = {
                subtree: node.support
                for node in concon_tree.traverse()
                for subtree in self.subtrees_dict
                if node.get_topology_id() == self.subtrees_topids[subtree]
            }

            self.conflict_dict = {
                subtree: node.support
                for node in conflict_tree.traverse()
                for subtree in self.subtrees_dict
                if node.get_topology_id() == self.subtrees_topids[subtree]
            }
        except Exception as e:
            logging.error(f"Error in get_concord_and_conflict: {e}")
            raise

    def _process_node_data(self, node_data):
        """Process data for a single node"""
        try:
            data = node_data.split(",")
            tot_genes = float(data[-1])
            node_name = data[0][4:]
            concord = self.concord_dict[node_name]
            all_conflict = self.conflict_dict[node_name]

            most_conflict = max([float(x) for x in data[2:-1]]) if len(data) > 3 else 0.0

            # Calculate percentages
            adj_concord = (concord / self.config.num_genes) * 100
            adj_most_conflict = (most_conflict / self.config.num_genes) * 100
            other_conflict = (all_conflict - most_conflict) / self.config.num_genes * 100
            the_rest = (self.config.num_genes - concord - all_conflict) / self.config.num_genes * 100

            return (node_name, 
                   [adj_concord, adj_most_conflict, other_conflict, the_rest],
                   [int(round(concord, 0)), int(round(tot_genes-concord, 0))])
        except Exception as e:
            logging.error(f"Error processing node data: {e}")
            raise

    def _get_pie_chart_data(self) -> None:
        """Generate pie chart data with multi-threading support"""
        try:
            with open(f"{self.config.phyparts_root}.hist") as f:
                phyparts_hist = f.readlines()

            # Use thread pool to process data
            with ThreadPoolExecutor(max_workers=self.config.threads) as executor:
                # Submit all tasks
                future_to_node = {executor.submit(self._process_node_data, line): line 
                                for line in phyparts_hist}
                
                # Collect results
                for future in concurrent.futures.as_completed(future_to_node):
                    try:
                        node_name, pie_data, dist_data = future.result()
                        with self._lock:
                            self.phyparts_pies[node_name] = pie_data
                            self.phyparts_dist[node_name] = dist_data
                    except Exception as e:
                        logging.error(f"Error processing node: {e}")
                        raise

        except Exception as e:
            logging.error(f"Error in get_pie_chart_data: {e}")
            raise

    def export_to_csv(self) -> None:
        """Export data to CSV files"""
        try:
            logging.info("Exporting data to CSV files...")
            # Export distribution data
            with open('phyparts_dist.csv', 'w') as f:
                f.write("node,concord,genes-concord\n")
                for node, (concord, genes_concord) in self.phyparts_dist.items():
                    f.write(f"{node},{concord},{genes_concord}\n")

            # Export pie chart data
            with open('phyparts_pies.csv', 'w') as f:
                f.write("node,adj_concord,adj_most_conflict,other_conflict,the_rest\n")
                for node, values in self.phyparts_pies.items():
                    f.write(f"{node},{','.join(map(str, values))}\n")
            logging.info("CSV export completed")
        except Exception as e:
            logging.error(f"Error exporting to CSV: {e}")
            raise

    def export_statistics(self) -> None:
        """Export node statistics to TSV file"""
        if not self.config.stat_output:
            return

        try:
            logging.info(f"Exporting statistics to {self.config.stat_output}")
            support_total_ratios = []  # Support/Total Ratio
            conflict_total_ratios = []  # Conflict/Total Ratio
            nosignal_total_ratios = []  # NoSignal/Total Ratio

            # Create a list to store all node data for sorting
            node_data = []
            
            for node_name, pie_data in self.phyparts_pies.items():
                # Get raw counts (not percentages)
                concordant = int(self.concord_dict[node_name])  # Blue part
                all_conflict = int(self.conflict_dict[node_name])  # Red + green part
                
                # Get main conflict proportion
                most_conflict_percent = pie_data[1]  # Green part percentage
                most_conflict = int(round(most_conflict_percent * self.config.num_genes / 100))  # Convert to count
                other_conflict = all_conflict - most_conflict  # Red part
                
                no_signal = self.config.num_genes - concordant - all_conflict  # Gray part
                
                # Calculate ratios
                support_ratio = concordant / self.config.num_genes
                conflict_ratio = all_conflict / self.config.num_genes
                nosignal_ratio = no_signal / self.config.num_genes
                
                # Record ratios for internal nodes
                node = next(n for n in self.plot_tree.traverse() if n.name == node_name)
                if not node.is_leaf():
                    support_total_ratios.append(support_ratio)
                    conflict_total_ratios.append(conflict_ratio)
                    nosignal_total_ratios.append(nosignal_ratio)
                
                # Add data to list
                node_data.append({
                    'node': int(node_name),  # Convert to integer for sorting
                    'data': (node_name, concordant, most_conflict, other_conflict, no_signal, 
                            support_ratio, conflict_ratio, nosignal_ratio)
                })

            # Sort by node number
            node_data.sort(key=lambda x: x['node'])

            with open(self.config.stat_output, 'w') as f:
                # Modify header to include new ratio columns
                f.write("Node\tSupport(blue)\tTopConflict(green)\tOtherConflict(red)\t"
                       "NoSignal(gray)\tSupport/Total_Ratio\tConflict/Total_Ratio\t"
                       "NoSignal/Total_Ratio\n")
                
                # Write data in sorted order
                for item in node_data:
                    node_name, concordant, most_conflict, other_conflict, no_signal, \
                    support_ratio, conflict_ratio, nosignal_ratio = item['data']
                    f.write(f"{node_name}\t{concordant}\t{most_conflict}\t{other_conflict}\t"
                           f"{no_signal}\t{support_ratio:.4f}\t{conflict_ratio:.4f}\t"
                           f"{nosignal_ratio:.4f}\n")
                
                # Calculate and write all average ratios
                if support_total_ratios:
                    avg_support_ratio = sum(support_total_ratios) / len(support_total_ratios)
                    avg_conflict_ratio = sum(conflict_total_ratios) / len(conflict_total_ratios)
                    avg_nosignal_ratio = sum(nosignal_total_ratios) / len(nosignal_total_ratios)
                    
                    f.write("\nAverage ratios for internal nodes only:")
                    f.write(f"\nSupport/Total Ratio: {avg_support_ratio:.4f}")
                    f.write(f"\nConflict/Total Ratio: {avg_conflict_ratio:.4f}")
                    f.write(f"\nNoSignal/Total Ratio: {avg_nosignal_ratio:.4f}")
                    # Add check to verify if the sum is 1
                    total = avg_support_ratio + avg_conflict_ratio + avg_nosignal_ratio
                    f.write(f"\nSum of all ratios: {total:.4f}")
            
            logging.info("Statistics export completed")
        except Exception as e:
            logging.error(f"Error exporting statistics: {e}")
            raise

    def render_tree(self) -> None:
        """Render tree visualization"""
        try:
            logging.info("Creating tree visualization...")
            ts = self._create_tree_style()
            self.plot_tree.convert_to_ultrametric()
            
            if not self.config.no_ladderize:
                self.plot_tree.ladderize(direction=1)
                
            # Get output format
            output_format = Path(self.config.output).suffix.lower()[1:]  # Remove dot
            
            # Set image size and DPI
            if output_format == "png":
                # For PNG format, use simple width calculation to avoid floating point operations
                if self.config.dpi == 300:
                    width = 2000  # Base width
                else:
                    # Use integer multiplication and division
                    width = 2000 * self.config.dpi // 300
                
                # Ensure width is integer
                width = int(width)
                height = width  # Equal width and height
                
                logging.info(f"Rendering PNG with width={width}, height={height}, dpi={self.config.dpi}")
                
                self.plot_tree.render(str(self.config.output),  
                                    tree_style=ts, 
                                    w=width,  
                                    h=height,  
                                    dpi=self.config.dpi,
                                    units="px")
            else:
                # Use default settings for SVG and PDF formats
                width = 595  # Ensure integer
                logging.info(f"Rendering {output_format.upper()} with width={width}")
                
                self.plot_tree.render(str(self.config.output),  
                                    tree_style=ts, 
                                    w=width,
                                    dpi=300,
                                    units="px")

            if self.config.output_node_tree:
                node_style = TreeStyle()
                node_style.show_leaf_name = False
                node_style.layout_fn = self._node_text_layout
                nodes_output = str(Path(self.config.output).parent / f"tree_nodes{Path(self.config.output).suffix}")
                self.plot_tree.render(nodes_output, tree_style=node_style)
                logging.info(f"Node tree visualization saved as: {nodes_output}")

            logging.info(f"Tree successfully saved as: {self.config.output}")
        except Exception as e:
            logging.error(f"Error rendering tree: {e}")
            raise

    def _create_tree_style(self) -> TreeStyle:
        """Create tree style configuration"""
        ts = TreeStyle()
        ts.show_leaf_name = False
        ts.layout_fn = self._phyparts_pie_layout
        ts.draw_guiding_lines = True
        ts.guiding_lines_color = "black"
        ts.guiding_lines_type = 0
        ts.scale = 30
        ts.branch_vertical_margin = 10

        # Set tree display type
        if self.config.tree_type == "circle":
            ts.mode = "c"  # Circle tree
            ts.arc_start = -180  # Start angle
            ts.arc_span = 360  # Span angle
        elif self.config.tree_type == "phylo":
            ts.show_branch_length = True  # Show branch length
        else:  # cladogram
            ts.show_branch_length = False  # Do not show branch length

        nstyle = NodeStyle()
        nstyle["size"] = 0
        
        # Set line width for all branches (including vertical and horizontal lines)
        for n in self.plot_tree.traverse():
            n.set_style(nstyle)
            n.img_style["vt_line_width"] = self.config.vt_line_width  # Vertical line width
            n.img_style["hz_line_width"] = self.config.vt_line_width  # Horizontal line width

        return ts

    def _get_display_value(self, node_name: str, mode: int) -> str:
        """Get display value for specified mode"""
        if mode == 8:
            # Get original support value from tree
            for node in self.plot_tree.traverse():
                if node.name == node_name:
                    # Return support value if it exists
                    if hasattr(node, 'support') and node.support:
                        return f"{node.support:.2f}   "
                    return "-   "
        
        # Get component data
        concordant = int(self.concord_dict[node_name])  # Blue part
        conflicting = int(self.conflict_dict[node_name])  # Red + green parts
        total = self.config.num_genes
        no_signal = total - concordant - conflicting  # Gray part
        
        if mode == 1:
            return f"{concordant}   "
        elif mode == 2:
            return f"{conflicting}   "
        elif mode == 3:
            return f"{no_signal}   "
        elif mode == 4:
            return f"{concordant/total:.2f}   "
        elif mode == 5:
            return f"{conflicting/total:.2f}   "
        elif mode == 6:
            return f"{no_signal/total:.2f}   "
        elif mode == 7:
            # Handle division by zero
            if conflicting == 0:
                return "∞   "
            return f"{concordant/conflicting:.2f}   "
        else:
            raise ValueError(f"Invalid display mode: {mode}")

    def _phyparts_pie_layout(self, node):
        """Node pie chart layout"""
        if node.name in self.phyparts_pies:
            # Adjust pie chart size using pie_size_factor
            base_size = 50  # Base size
            adjusted_size = int(base_size * self.config.pie_size_factor)
            
            pie = faces.PieChartFace(
                self.phyparts_pies[node.name],
                colors=[
                    self.config.colors["concordance"],
                    self.config.colors["top_conflict"],
                    self.config.colors["other_conflict"],
                    self.config.colors["no_signal"]
                ],
                width=adjusted_size, height=adjusted_size  # Use adjusted size
            )
            pie.border.width = None
            pie.opacity = 1
            faces.add_face_to_node(pie, node, 0, position="branch-right")

            # Modify number display logic
            if self.config.show_numbers:
                # Use adjusted font size
                adjusted_size = int(20 * self.config.number_size_factor)
                
                # Get values based on display mode
                if self.config.show_num_mode[0] is not None:
                    top_value = self._get_display_value(node.name, self.config.show_num_mode[0])
                    top_text = faces.TextFace(top_value, fsize=adjusted_size)
                    faces.add_face_to_node(top_text, node, 0, position="branch-top")
                
                if self.config.show_num_mode[1] is not None:
                    bottom_value = self._get_display_value(node.name, self.config.show_num_mode[1])
                    bottom_text = faces.TextFace(bottom_value, fsize=adjusted_size)
                    faces.add_face_to_node(bottom_text, node, 0, position="branch-bottom")
        else:
            # Use adjusted font size
            adjusted_size = int(20 * self.config.tip_size_factor)  # Base size is 20
            F = faces.TextFace(node.name, fsize=adjusted_size, 
                              fstyle='italic' if self.config.italic_names else 'normal')
            faces.add_face_to_node(F, node, 0, position="aligned")

    def _node_text_layout(self, node):
        """Node text layout"""
        # Use adjusted font size
        adjusted_size = int(20 * self.config.tip_size_factor)  # Base size is 20
        F = faces.TextFace(node.name, fsize=adjusted_size)
        faces.add_face_to_node(F, node, 0, position="branch-right")

def main():
    """Main function"""
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument('species_tree', help="Newick formatted species tree topology.")
    parser.add_argument('phyparts_root', help="File root name used for Phyparts.")
    parser.add_argument('num_genes', type=int, help="Number of total gene trees.")
    parser.add_argument('--taxon_subst', help="Comma-delimited file to translate tip names.")
    parser.add_argument("--output", help="Output filename with extension (.svg or .pdf)", default="pies.svg")
    parser.add_argument("--output_node_tree", 
                       action="store_true", 
                       help="""Generate an additional tree file with '_nodes' suffix showing:
- All node identifiers in the tree
- No pie charts
- No numerical annotations""",
                       dest="output_node_tree")
    parser.add_argument("--no_ladderize", action="store_true", help="Don't ladderize tree")
    parser.add_argument("--to_csv", action="store_true", help="Export data to CSV")
    parser.add_argument("--tree_type", choices=["circle", "cladogram", "phylo"], 
                       default="cladogram", help="Tree visualization type (default: cladogram)")
    
    # Add line width argument with user-friendly name
    parser.add_argument("--line_width", type=int, default=0,
                       help="Width of tree branches (default: 0)",
                       dest="vt_line_width")

    # Add italic names control
    parser.add_argument("--no_italic", action="store_false",
                       help="Display species names in normal font style (default: italic)",
                       dest="italic_names")
    
    # Add control tip label font size parameter
    parser.add_argument("--tip_size", type=float, default=1.0,
                       help="Scale factor for tip label font size (default: 1.0)",
                       dest="tip_size_factor")
    
    # Add control gene tree count font size parameter
    parser.add_argument("--number_size", type=float, default=1.0,
                       help="Scale factor for gene tree count font size (default: 1.0)",
                       dest="number_size_factor")

    # Modify display mode control parameter
    parser.add_argument("--show_num_mode",
                       default="12",
                       help="""Control what numbers to show on branches (specify 0-2 digits):
0: Hide all numbers
1: Number of genes supporting species tree (blue)
2: Number of genes conflicting with species tree (red+green)
3: Number of genes with no signal (gray)
4: Proportion of supporting genes (blue/total)
5: Proportion of conflicting genes ((red+green)/total)
6: Proportion of no signal genes (gray/total)
7: Ratio of supporting to conflicting genes (blue/(red+green))
8: Original node support values from the input tree
Example: --show_num_mode 0  (hide all numbers)
        --show_num_mode 1  (show only support number)
        --show_num_mode 12 (default, show support and conflict numbers)
        --show_num_mode 47 (show support number and support/conflict ratio)
        --show_num_mode 8  (show original node support values)""",
                       dest="show_num_mode")

    # Add pie chart size parameter
    parser.add_argument("--pie_size", type=float, default=1.0,
                       help="Scale factor for pie chart size (default: 1.0)",
                       dest="pie_size_factor")

    # Add statistics output parameter
    parser.add_argument("--stat",
                       help="Output file path for node statistics (TSV format)",
                       dest="stat_output")

    # Add thread count parameter
    parser.add_argument("-nt", "--threads", type=int, default=1,
                       help="Number of threads to use (default: 1)",
                       dest="threads")

    args = parser.parse_args()
    args_dict = vars(args)
    
    try:
        config = PhyPartsConfig(**args_dict)
        processor = PhyPartsPieCharts(config)
        processor.get_phyparts_nodes()
        processor.process_data()
        
        if config.to_csv:
            processor.export_to_csv()
        
        # Add statistics output
        processor.export_statistics()
            
        processor.render_tree()
        
    except Exception as e:
        logging.error(f"Program execution failed: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
