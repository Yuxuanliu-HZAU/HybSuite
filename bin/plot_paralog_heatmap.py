#!/usr/bin/env python
"""
Script for generating paralog statistics and visualization.
Can generate TSV format table with paralog counts and/or create heatmap visualization.
Supports multi-threading for faster processing.
Part of HybSuite
"""

import argparse
import textwrap
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import logging
import os
import re
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor
from typing import Dict, List, Tuple
import numpy as np
import matplotlib.colors as mcolors
import matplotlib
matplotlib.use('Agg')  # Set backend to Agg to support multi-threading

# Configure logging
logging.basicConfig(
    format='[%(asctime)s] [%(levelname)s] %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
    level=logging.INFO
)
logger = logging.getLogger(__name__)

def get_figure_dimensions(df, figure_length, figure_height, sample_text_size, gene_text_size):
    """
    Takes a dataframe and returns figure dimensions based on data size.
    """
    num_samples = len(df.index)
    num_genes = len(df.columns)

    logger.info(f'Number of samples in input lengths file is: {num_samples}')
    logger.info(f'Number of genes in input lengths file is: {num_genes}')

    # Set default text label size (in points) unless specified at the command line:
    sample_text_size = sample_text_size if sample_text_size else 10
    gene_id_text_size = gene_text_size if gene_text_size else 10

    # Set figure height dimensions for a given number of samples:
    figure_height = figure_height if figure_height else num_samples / 3

    # Set figure length dimensions for a given number of genes:
    fig_length = figure_length if figure_length else num_genes / 3

    logger.info(f'figure_length: {fig_length:.2f} inches, figure_height: {figure_height:.2f} inches, '
                f'sample_text_size: {sample_text_size} points, gene_id_text_size: {gene_id_text_size} points')

    return fig_length, figure_height, sample_text_size, gene_id_text_size

def create_paralog_heatmap(df, output_base, filetype, dpi, fig_length, fig_height, 
                          sample_text_size, gene_text_size, no_xlabels, no_ylabels,
                          no_grid=False, color='black', grid_color='grey', show_values=False,
                          num_threads=1, add_markers=False):
    """
    Creates a heatmap showing the number of sequences recovered for each gene, for each sample.
    Uses multiple threads for processing.
    
    Parameters:
        ...
        add_markers: bool, optional (default=False)
            If True, adds visual markers (dots for 1s, diagonal lines for 0s)
    """
    # Keep complete species names when reading data, no splitting
    if isinstance(df, str):
        df = pd.read_csv(df, sep='\t', index_col='Species')
    
    # Ensure data is numeric type
    df = df.apply(pd.to_numeric, errors='coerce')
    
    # Get figure dimensions and text sizes
    fig_length, figure_height, sample_text_size, gene_text_size = get_figure_dimensions(
        df, fig_length, fig_height, sample_text_size, gene_text_size)

    # Check that figure won't be greater than the maximum pixels allowed
    figure_length_pixels = fig_length * dpi
    figure_height_pixels = figure_height * dpi

    if figure_length_pixels >= 65536:
        fig_length = 400
        dpi = 100
        logger.info('The large number of loci means that the figure length has been adjusted to '
                   f'{fig_length} inches and DPI to {dpi}')

    if figure_height_pixels >= 65536:
        figure_height = 400
        dpi = 100
        logger.info('The large number of samples means that the figure height has been adjusted to '
                   f'{figure_height} inches and DPI to {dpi}')

    # Set color scheme
    base_palettes = {
        'black': "Greys",
        'blue': "Blues",
        'red': "Reds",
        'green': "Greens",
        'purple': "Purples",
        'orange': "Oranges",
        'yellow': "YlOrBr",
        'brown': "YlOrBr",
        'pink': "RdPu"
    }
    
    base_palette = base_palettes.get(color, "Greys")

    # Create figure
    plt.figure(figsize=(fig_length, figure_height))
    sns.set_style('ticks')

    # Create custom color mapping
    base_colors = sns.color_palette(base_palette, n_colors=256)
    
    # Create starting color based on user selection
    if color == 'black':
        start_color = (0.88, 0.88, 0.88)  # Light gray
    elif color == 'blue':
        start_color = (0.95, 0.95, 0.99)  # Light blue
    elif color == 'red':
        start_color = (0.99, 0.95, 0.95)  # Light red
    elif color == 'green':
        start_color = (0.95, 0.99, 0.95)  # Light green
    elif color == 'purple':
        start_color = (0.97, 0.95, 0.97)  # Light purple
    elif color == 'orange':
        start_color = (0.99, 0.96, 0.95)  # Light orange
    elif color == 'yellow':
        start_color = (0.99, 0.99, 0.95)  # Light yellow
    elif color == 'brown':
        start_color = (0.97, 0.96, 0.95)  # Light brown
    elif color == 'pink':
        start_color = (0.99, 0.95, 0.97)  # Light pink
    else:
        start_color = (0.97, 0.97, 0.97)  # Default light gray

    # Create color mapping function
    def custom_color_func(val):
        if val == 0:
            return (1, 1, 1)  # Pure white
        elif val == 1:
            return start_color  # Light version of user-selected color
        else:
            # For values greater than 1, use linear gradient
            progress = (val - 1) / (df.values.max() - 1)  # Calculate relative position between 1 and max value
            return tuple(start + (end - start) * progress 
                       for start, end in zip(start_color, base_colors[-1]))

    # Create custom colormap
    max_val = df.values.max()
    values = np.linspace(0, max_val, 256)
    colors = [custom_color_func(val) for val in values]
    cmap = mcolors.LinearSegmentedColormap.from_list("custom", colors)

    # Create heatmap
    heatmap = sns.heatmap(df, 
                         cmap=cmap,
                         xticklabels=True, 
                         yticklabels=True,
                         cbar_kws={"orientation": "vertical", 
                                  "pad": 0.01,
                                  "ticks": np.arange(0, df.values.max() + 1, 1.0)},
                         linewidths=0 if no_grid else 0.3,
                         linecolor=grid_color,
                         square=True)
    
    # Add markers if enabled
    if add_markers:
        for i in range(len(df.index)):
            for j in range(len(df.columns)):
                if df.iloc[i, j] == 1:
                    heatmap.plot(j + 0.5, i + 0.5, 'o', color='black', markersize=2, alpha=0.5)
                elif df.iloc[i, j] == 0:
                    # Add light diagonal lines for cells with value 0
                    heatmap.plot([j, j+1], [i, i+1], '-', color='lightgray', linewidth=1, alpha=0.3)
                    heatmap.plot([j+1, j], [i, i+1], '-', color='lightgray', linewidth=1, alpha=0.3)

    # Add outer border
    if not no_grid:
        for _, spine in heatmap.spines.items():
            spine.set_visible(True)
            spine.set_linewidth(2)
            spine.set_color('black')  # Keep border black

    # Show values
    if show_values:
        for i in range(len(df.index)):
            for j in range(len(df.columns)):
                value = df.iloc[i, j]
                if value >= 2:  # Only show values >= 2
                    heatmap.text(j + 0.5, i + 0.5, int(value),
                               ha="center", va="center",
                               color="black" if value < df.values.max()/2 else "white",
                               fontsize=sample_text_size)  # Use same font size as sample names

    # Configure axis labels and ticks
    heatmap.tick_params(axis='x', labelsize=gene_text_size)
    heatmap.tick_params(axis='y', labelsize=sample_text_size)
    heatmap.set_yticklabels(heatmap.get_yticklabels(), rotation=0)
    heatmap.set_xlabel("Locus name", fontsize=14, fontweight='bold', labelpad=20)
    heatmap.set_ylabel("Sample name", fontsize=14, fontweight='bold', labelpad=20)
    plt.title("Number of paralog sequences for each locus, for each sample", 
             fontsize=14, fontweight='bold', y=1.05)

    # Remove axis labels if requested
    if no_xlabels:
        heatmap.set(xticks=[])
    if no_ylabels:
        heatmap.set(yticks=[])

    # Save heatmap
    output_file = f"{output_base}.{filetype}"
    logger.info(f'Saving heatmap as file "{output_file}" at {dpi} DPI')
    plt.savefig(output_file, dpi=dpi, bbox_inches='tight')
    plt.close()

def process_fasta_file(file_path: str) -> Tuple[str, Dict[str, int]]:
    """Process a single FASTA file and return its paralog counts"""
    if '_paralogs' in file_path:
        locus = os.path.basename(file_path).split('_paralogs')[0]
    else:
        locus = os.path.basename(file_path).rsplit('.', 1)[0]
    
    species_counts = {}
    with open(file_path) as f:
        for line in f:
            if line.startswith('>'):
                if ' ' in line[1:]:
                    species = line[1:].split()[0]
                else:
                    species = line[1:].strip()
                
                species_counts[species] = species_counts.get(species, 0) + 1
    
    return locus, species_counts

def extract_paralog_counts(input_dir: str, num_threads: int) -> Tuple[List[str], List[str], Dict[str, Dict[str, int]]]:
    """Extract paralog count information from FASTA files using multiple threads"""
    species_set = set()
    locus_dict = {}
    counts_dict = {}
    
    # Get FASTA file list
    fasta_files = [os.path.join(input_dir, f) for f in os.listdir(input_dir) 
                   if f.endswith('.fasta')]
    
    logger.info(f"Processing {len(fasta_files)} FASTA files using {num_threads} threads")
    
    # Use thread pool to process files
    with ThreadPoolExecutor(max_workers=num_threads) as executor:
        results = executor.map(process_fasta_file, fasta_files)
        
        # Combine results
        for locus, species_counts in results:
            locus_dict[locus] = True
            species_set.update(species_counts.keys())
            
            for species, count in species_counts.items():
                if species not in counts_dict:
                    counts_dict[species] = {}
                counts_dict[species][locus] = count
    
    return sorted(list(species_set)), sorted(list(locus_dict.keys())), counts_dict

def normalize_species_name(name):
    """
    Normalize species names:
    - Keep complete names for varieties (var.), subspecies (subsp.), and forms (f.)
    - Remove .number and .main suffixes
    """
    if any(suffix in name for suffix in ['var.', 'subsp.', 'f.']):
        return name
    return re.sub(r'\.(?:main|\d+)$', '', name)

def count_paralog_seqs(input_dir, species_list_file, output_species_list, output_file, num_threads):
    """Count paralog sequences for each species and locus"""
    species, loci, counts = extract_paralog_counts(input_dir, num_threads)
    
    if species_list_file:
        with open(species_list_file) as f:
            species = [line.strip() for line in f if line.strip()]
    
    # Create a new dictionary to store merged species data
    merged_counts = {}
    
    # Merge paralog counts for different copies of the same species
    for sp, locus_counts in counts.items():
        base_species = normalize_species_name(sp)  # Use normalization function
        if base_species not in merged_counts:
            merged_counts[base_species] = {}
        
        for locus, count in locus_counts.items():
            # Accumulate counts for the same species at the same locus
            merged_counts[base_species][locus] = merged_counts[base_species].get(locus, 0) + count
    
    # Filter out variant names, keep only normalized species names
    filtered_counts = {}
    for sp, locus_counts in merged_counts.items():
        # Only filter out .number and .main variant names
        if re.search(r'\.(?:main|\d+)$', sp):
            continue
        filtered_counts[sp] = locus_counts
    
    # Create DataFrame using filtered species names
    df = pd.DataFrame(index=sorted(filtered_counts.keys()), columns=loci)
    
    # Fill data
    for sp in df.index:
        for locus in loci:
            df.loc[sp, locus] = filtered_counts.get(sp, {}).get(locus, 0)
    
    # Set index name to "Species"
    df.index.name = "Species"
    
    # Output species list
    if output_species_list:
        os.makedirs(os.path.dirname(os.path.abspath(output_species_list)), exist_ok=True)
        with open(output_species_list, 'w') as f:
            for sp in df.index:
                f.write(f"{sp}\n")
    
    # Output data table
    if output_file:
        os.makedirs(os.path.dirname(os.path.abspath(output_file)), exist_ok=True)
        df.to_csv(output_file, sep='\t')
        logger.info(f"Paralog counts have been saved to {output_file}")
    
    return df

def main():
    parser = argparse.ArgumentParser(description=textwrap.dedent("""
        Script for generating paralog statistics and visualization.
        Can generate TSV format table with paralog counts and/or create heatmap visualization.
        Supports multi-threading for faster processing.
        
        Required output: At least one of -opr or -oph must be specified.
        """))
    
    # Required argument
    parser.add_argument('-i', '--input_dir', required=True,
                       help='Directory containing FASTA files with paralog sequences')
    
    # Optional general arguments
    parser.add_argument('-t', '--threads', type=int, default=1,
                       help='Number of threads to use for processing (default: 1)')
    
    # Output arguments
    parser.add_argument('-opr', '--output_paralog_report',
                       help='Output TSV file containing paralog counts for each species and locus. '
                            'If not specified, no TSV file will be generated')
    parser.add_argument('-oph', '--output_paralog_heatmap',
                       help='Output heatmap visualization (format determined by file extension, e.g., .png, .pdf). '
                            'If not specified, no heatmap will be generated')
    
    # Additional options
    parser.add_argument('--species_list',
                       help='File containing list of species to include in the analysis (one species per line)')
    parser.add_argument('--output_species_list',
                       help='Output file to save the list of processed species')
    
    # Heatmap customization options
    parser.add_argument('--dpi', type=int, default=300,
                       help='DPI (dots per inch) for output image (default: 300)')
    parser.add_argument('--fig_length', type=float,
                       help='Figure length in inches (default: auto-calculated based on number of loci)')
    parser.add_argument('--fig_height', type=float,
                       help='Figure height in inches (default: auto-calculated based on number of species)')
    parser.add_argument('--sample_font', type=int,
                       help='Font size for sample labels in points (default: 10)')
    parser.add_argument('--gene_font', type=int,
                       help='Font size for gene labels in points (default: 10)')
    parser.add_argument('--hide_xlabels', action='store_true',
                       help='Hide x-axis labels (locus names)')
    parser.add_argument('--hide_ylabels', action='store_true',
                       help='Hide y-axis labels (sample names)')
    parser.add_argument('--no_grid', action='store_true',
                       help='Do not show grid lines in heatmap')
    parser.add_argument('--color', default='black',
                       choices=['black', 'blue', 'red', 'green', 'purple', 
                               'orange', 'yellow', 'brown', 'pink'],
                       help='Color scheme for heatmap gradient (default: black)')
    parser.add_argument('--show_values', action='store_true',
                       help='Show numerical values in heatmap cells (only for values >= 2)')
    parser.add_argument('--grid_color', default='grey',
                       help='Color for grid lines in heatmap (default: grey)')
    parser.add_argument('--add_markers', action='store_true',
                       help='Add visual markers in cells (dots for 1s, diagonal lines for 0s)')
    
    args = parser.parse_args()
    
    # Validate that at least one output is specified
    if not (args.output_paralog_report or args.output_paralog_heatmap):
        parser.error("At least one output file must be specified (-opr and/or -oph)")
    
    # Process files and generate DataFrame
    df = count_paralog_seqs(
        args.input_dir,
        args.species_list,
        args.output_species_list,
        args.output_paralog_report,
        args.threads
    )
    
    # Create heatmap if output path is specified
    if args.output_paralog_heatmap:
        filetype = args.output_paralog_heatmap.split('.')[-1]
        output_base = args.output_paralog_heatmap.rsplit('.', 1)[0]
        create_paralog_heatmap(df, output_base, filetype, args.dpi,
                             args.fig_length, args.fig_height,
                             args.sample_font, args.gene_font,
                             args.hide_xlabels, args.hide_ylabels,
                             args.no_grid, args.color, args.grid_color, 
                             args.show_values, args.threads, args.add_markers)

if __name__ == "__main__":
    main()
