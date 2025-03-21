#!/usr/bin/env python
"""
modified_phypartspiecharts.py
PhyPartsPieCharts - Generate pie chart representation of gene tree conflict.

This script generates the "Pie Chart" representation of gene tree conflict from
Smith et al. 2015 using the output of phyparts.

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
    output_file: str = "pies.svg"
    output_format: str = "svg"
    show_nodes: bool = False
    colors: Dict[str, str] = None
    no_ladderize: bool = False
    to_csv: bool = False
    vt_line_width: float = 0
    italic_names: bool = True

    def __post_init__(self):
        # Default color scheme
        if self.colors is None:
            self.colors = {
                "concordance": "blue",
                "top_conflict": "green",
                "other_conflict": "red",
                "no_signal": "dark gray"
            }
        
        # Validate output format
        valid_formats = ["svg", "png", "pdf"]
        if self.output_format.lower() not in valid_formats:
            raise ValueError(f"Unsupported output format: {self.output_format}. Supported formats: {', '.join(valid_formats)}")
        
        # Validate color keys
        required_colors = {"concordance", "top_conflict", "other_conflict", "no_signal"}
        if not all(key in self.colors for key in required_colors):
            raise ValueError(f"Missing color definitions. Required colors: {required_colors}")
        
        # Validate colors
        for color_name, color_value in self.colors.items():
            if not validate_color(color_value):
                raise ColorError(f"Invalid color value for {color_name}: {color_value}")

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

    def _get_pie_chart_data(self) -> None:
        """Generate pie chart data"""
        try:
            with open(f"{self.config.phyparts_root}.hist") as f:
                phyparts_hist = f.readlines()

            for line in phyparts_hist:
                data = line.split(",")
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

                self.phyparts_pies[node_name] = [adj_concord, adj_most_conflict, other_conflict, the_rest]
                self.phyparts_dist[node_name] = [int(round(concord, 0)), int(round(tot_genes-concord, 0))]
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

    def render_tree(self) -> None:
        """Render tree visualization"""
        try:
            logging.info("Creating tree visualization...")
            ts = self._create_tree_style()
            self.plot_tree.convert_to_ultrametric()
            
            if not self.config.no_ladderize:
                self.plot_tree.ladderize(direction=1)
                
            # Render tree with specified format
            self.plot_tree.render(self.config.output_file, 
                                tree_style=ts, 
                                w=595, 
                                dpi=300,
                                units="px")

            if self.config.show_nodes:
                node_style = TreeStyle()
                node_style.show_leaf_name = False
                node_style.layout_fn = self._node_text_layout
                nodes_output = f"tree_nodes.{self.config.output_format}"
                self.plot_tree.render(nodes_output, tree_style=node_style)
                logging.info(f"Node tree saved as: {nodes_output}")

            logging.info(f"Tree successfully saved as: {self.config.output_file}")
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

        nstyle = NodeStyle()
        nstyle["size"] = 0
        for n in self.plot_tree.traverse():
            n.set_style(nstyle)
            # Use custom line width if specified, otherwise keep default (0)
            n.img_style["vt_line_width"] = self.config.vt_line_width

        return ts

    def _phyparts_pie_layout(self, node):
        """Node pie chart layout"""
        if node.name in self.phyparts_pies:
            pie = faces.PieChartFace(
                self.phyparts_pies[node.name],
                colors=[
                    self.config.colors["concordance"],
                    self.config.colors["top_conflict"],
                    self.config.colors["other_conflict"],
                    self.config.colors["no_signal"]
                ],
                width=50, height=50
            )
            pie.border.width = None
            pie.opacity = 1
            faces.add_face_to_node(pie, node, 0, position="branch-right")

            concord_text = faces.TextFace(f"{int(self.concord_dict[node.name])}   ", fsize=20)
            conflict_text = faces.TextFace(f"{int(self.conflict_dict[node.name])}   ", fsize=20)

            faces.add_face_to_node(concord_text, node, 0, position="branch-top")
            faces.add_face_to_node(conflict_text, node, 0, position="branch-bottom")
        else:
            F = faces.TextFace(node.name, fsize=20, fstyle='italic' if self.config.italic_names else 'normal')
            faces.add_face_to_node(F, node, 0, position="aligned")

    @staticmethod
    def _node_text_layout(node):
        """Node text layout"""
        F = faces.TextFace(node.name, fsize=20)
        faces.add_face_to_node(F, node, 0, position="branch-right")

def main():
    """Main function"""
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument('species_tree', help="Newick formatted species tree topology.")
    parser.add_argument('phyparts_root', help="File root name used for Phyparts.")
    parser.add_argument('num_genes', type=int, help="Number of total gene trees.")
    parser.add_argument('--taxon_subst', help="Comma-delimited file to translate tip names.")
    parser.add_argument("--output_file", help="Output filename with extension", default="pies.svg")
    parser.add_argument("--output_format", help="Output format (svg, png, or pdf)", default="svg")
    parser.add_argument("--show_nodes", action="store_true", help="Show tree with labeled nodes")
    parser.add_argument("--no_ladderize", action="store_true", help="Don't ladderize tree")
    parser.add_argument("--to_csv", action="store_true", help="Export data to CSV")
    
    # Color customization arguments
    parser.add_argument("--concordance_color", help="Color for concordance sections (default: blue)")
    parser.add_argument("--top_conflict_color", help="Color for top conflict sections (default: green)")
    parser.add_argument("--other_conflict_color", help="Color for other conflict sections (default: red)")
    parser.add_argument("--no_signal_color", help="Color for no signal sections (default: dark gray)")
    
    # Add line width argument with user-friendly name
    parser.add_argument("--line_width", type=float, default=0,
                       help="Width of tree branches (default: 0)",
                       dest="vt_line_width")

    # Add italic names control
    parser.add_argument("--no_italic", action="store_false",
                       help="Display species names in normal font style (default: italic)",
                       dest="italic_names")

    args = parser.parse_args()
    
    # Process file format
    if not args.output_file.lower().endswith(tuple(['.' + fmt for fmt in ['svg', 'png', 'pdf']])):
        args.output_file = f"{args.output_file}.{args.output_format}"
    else:
        args.output_format = args.output_file.split('.')[-1].lower()

    # Process custom colors
    colors = {}
    if args.concordance_color:
        colors["concordance"] = args.concordance_color
    if args.top_conflict_color:
        colors["top_conflict"] = args.top_conflict_color
    if args.other_conflict_color:
        colors["other_conflict"] = args.other_conflict_color
    if args.no_signal_color:
        colors["no_signal"] = args.no_signal_color

    # Only update args.colors if custom colors were provided
    if colors:
        args = vars(args)
        args["colors"] = colors
        args = argparse.Namespace(**args)

    try:
        config = PhyPartsConfig(**vars(args))
        processor = PhyPartsPieCharts(config)
        processor.get_phyparts_nodes()
        processor.process_data()
        
        if config.to_csv:
            processor.export_to_csv()
            
        processor.render_tree()
        
    except Exception as e:
        logging.error(f"Program execution failed: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
