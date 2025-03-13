#!/usr/bin/env python

"""
plot_recovery_heatmap.py - A visualization tool in HybSuite

This script is a component of the HybSuite toolkit, designed for visualizing sequence recovery 
rates across different taxa and loci. It generates heatmaps that display the percentage of 
sequence length recovered for each gene in each taxon, relative to either the average or 
maximum length of reference sequences.

Key features:
1. Calculates sequence lengths and generates a seq_lengths.tsv file
2. Calculates the percentage length recovered relative to reference sequences
3. Generates customizable heatmaps showing recovery rates
4. Supports both average and maximum reference length comparisons
5. Offers flexible visualization options including value display and grid customization

Both the seq_lengths.tsv file and heatmap generation are optional outputs.
"""

import sys
import argparse
import os
import logging
import textwrap
import re
from collections import defaultdict
import concurrent.futures
from Bio import SeqIO
from matplotlib.colors import LinearSegmentedColormap
import numpy as np

from hybpiper.version import __version__

# Import non-standard-library modules:
try:
    import pandas as pd
except ImportError:
    sys.exit("Required Python package 'pandas' not found. Is it installed?")

try:
    import seaborn as sns
except ImportError:
    sys.exit("Required Python package 'seaborn' not found. Is it installed?")

try:
    import matplotlib.pyplot as plt
except ImportError:
    sys.exit("Required Python package 'matplotlib' not found. Is it installed?")

# Setup logging
logger = logging.getLogger(f'hybpiper.{__name__}')
logger.handlers = []  # Clear all existing handlers
handler = logging.StreamHandler(sys.stdout)
handler.setFormatter(logging.Formatter(
    '[%(asctime)s] [%(levelname)s] %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
))
logger.addHandler(handler)
logger.setLevel(logging.INFO)

def natural_sort_key(s):
    """Provide a natural sort key for filenames"""
    return [int(text) if text.isdigit() else text.lower()
            for text in re.split('([0-9]+)', s)]

def detect_sequence_type(sequence):
    """Automatically detect sequence type (nucleotide or protein)"""
    seq = sequence.upper().replace(" ", "")
    nucleotide_count = sum(1 for base in seq if base in 'ATCGN')
    nucleotide_ratio = nucleotide_count / len(seq)
    return 'nucleotide' if nucleotide_ratio > 0.85 else 'protein'

def get_reference_lengths(ref_file, use_max=False):
    """Calculate average/maximum length of each locus in reference sequences"""
    if not os.path.isfile(ref_file):
        logger.error(f"Reference file not found: {ref_file}")
        return {}, {}
        
    locus_lengths = defaultdict(list)
    seq_type = None
    
    try:
        with open(ref_file, 'r') as f:
            for record in SeqIO.parse(f, "fasta"):
                if seq_type is None:
                    seq_type = detect_sequence_type(str(record.seq))
                    logger.info(f"Detected reference sequence type: {seq_type}")
                
                locus = record.id.split('-')[-1]
                length = len(record.seq)
                
                if seq_type == 'protein':
                    length *= 3
                
                locus_lengths[locus].append(length)
                
    except Exception as e:
        logger.error(f"Error processing reference file: {str(e)}")
        return {}, {}
    
    # Calculate average and maximum values
    avg_lengths = {locus: int(sum(lengths)/len(lengths)) 
                  for locus, lengths in locus_lengths.items()}
    max_lengths = {locus: max(lengths) 
                  for locus, lengths in locus_lengths.items()}
    
    return avg_lengths, max_lengths

def get_sequence_length(file_path):
    """Get lengths of all sequences in a single file"""
    lengths = {}
    try:
        for record in SeqIO.parse(file_path, "fasta"):
            species = record.id.split()[0]
            lengths[species] = len(record.seq)
    except Exception as e:
        logger.error(f"Error processing {file_path}: {str(e)}")
    return os.path.splitext(os.path.basename(file_path))[0], lengths

def calculate_seq_lengths(input_dir, species_list_file, output_species_list, output_file, ref_file, threads=1, use_max=False):
    """Calculate sequence lengths for each species and locus"""
    # If no species list is provided, automatically extract it
    if species_list_file is None:
        species = extract_species_names(input_dir)
        if output_species_list:
            os.makedirs(os.path.dirname(os.path.abspath(output_species_list)), exist_ok=True)
            with open(output_species_list, 'w') as f:
                for sp in species:
                    f.write(f"{sp}\n")
            logger.info(f"Species list has been written to {output_species_list}")
    else:
        # Read species list from file
        with open(species_list_file, 'r') as f:
            species = [line.strip() for line in f]
    
    fasta_files = [f for f in os.listdir(input_dir) 
                   if os.path.isfile(os.path.join(input_dir, f)) and 
                   any(f.lower().endswith(ext) for ext in ['.fna', '.fasta', '.fa'])]
    fasta_files.sort(key=natural_sort_key)
    
    avg_lengths, max_lengths = get_reference_lengths(ref_file)
    ref_lengths = max_lengths if use_max else avg_lengths
    
    results = defaultdict(dict)
    with concurrent.futures.ThreadPoolExecutor(max_workers=threads) as executor:
        future_to_file = {
            executor.submit(get_sequence_length, os.path.join(input_dir, f)): f 
            for f in fasta_files
        }
        
        for future in concurrent.futures.as_completed(future_to_file):
            locus, lengths = future.result()
            results[locus] = lengths
    
    df = pd.DataFrame(0, index=species, columns=sorted(results.keys(), key=natural_sort_key))
    
    for locus in df.columns:
        for sp in species:
            df.loc[sp, locus] = results[locus].get(sp, 0)
    
    ref_lengths_list = [avg_lengths.get(locus, 0) for locus in df.columns]
    max_lengths_list = [max_lengths.get(locus, 0) for locus in df.columns]
    
    # Modify here: always include max length row
    final_df = pd.concat([
        pd.DataFrame({'Sample/Locus': ['MeanLength(Targetfile)', 'MaxLength(Targetfile)'] + species}),
        pd.DataFrame([ref_lengths_list, max_lengths_list] + df.values.tolist(), 
                    columns=df.columns)
    ], axis=1)
    
    numeric_columns = final_df.columns.difference(['Sample/Locus'])
    final_df[numeric_columns] = final_df[numeric_columns].astype(int)
    
    # Save results
    if output_file:
        os.makedirs(os.path.dirname(os.path.abspath(output_file)), exist_ok=True)
        final_df.to_csv(output_file, sep='\t', index=False)
        logger.info(f"Sequence lengths have been written to {output_file}")
    
    # If not using max mode, return DataFrame without max row for plotting
    if not use_max:
        return pd.concat([
            pd.DataFrame({'Sample/Locus': ['MeanLength(Targetfile)'] + species}),
            pd.DataFrame([ref_lengths_list] + df.values.tolist(), 
                        columns=df.columns)
        ], axis=1)
    
    return final_df

def get_figure_dimensions(df, figure_length, figure_height, sample_text_size, gene_text_size):
    """Calculate figure dimensions based on data size"""
    num_samples = len(df.index)
    num_genes = len(df.columns)
    
    sample_text_size = sample_text_size if sample_text_size else 10
    gene_id_text_size = gene_text_size if gene_text_size else 10
    
    figure_height = figure_height if figure_height else num_samples / 3
    fig_length = figure_length if figure_length else num_genes / 3
    
    logger.info(f'figure_length: {fig_length:.2f} inches, figure_height: {figure_height:.2f} inches')
    
    return fig_length, figure_height, sample_text_size, gene_id_text_size

def create_heatmap(df, args):
    """Create and save recovery heatmap"""
    df = df.copy()
    
    # Convert data to float type
    numeric_columns = df.columns.difference(['Sample/Locus'])
    df[numeric_columns] = df[numeric_columns].astype(float)
    
    # Get reference lengths based on mode
    if args.use_max:
        ref_lengths = df.iloc[1][df.columns[1:]]  # max length
        df = df.iloc[2:]  # remove mean and max rows
    else:
        ref_lengths = df.iloc[0][df.columns[1:]]  # mean length
        df = df.iloc[1:]  # remove mean row
    
    # Create separate dataframes for display values and coloring
    recovery_rates = pd.DataFrame(index=df.index, columns=df.columns)
    recovery_rates['Sample/Locus'] = df['Sample/Locus']
    
    color_rates = pd.DataFrame(index=df.index, columns=df.columns)
    color_rates['Sample/Locus'] = df['Sample/Locus']
    
    # Calculate recovery rates for each column
    for col in df.columns[1:]:
        ref = float(ref_lengths[col])
        if ref == 0:
            recovery_rates[col] = 0.0
            color_rates[col] = 0.0
        else:
            # Actual ratios for display
            recovery_rates[col] = df[col].astype(float) / ref
            # Capped ratios (0-1) for coloring
            color_rates[col] = (df[col].astype(float) / ref).clip(upper=1.0)
    
    plot_data = color_rates.set_index('Sample/Locus')
    
    # Set figure dimensions
    num_samples = len(df)
    num_genes = len(df.columns) - 1
    
    figure_length = args.figure_length if args.figure_length else num_genes / 3
    figure_height = args.figure_height if args.figure_height else max(4, num_samples / 3)
    
    logger.info(f"Number of samples: {num_samples}")
    logger.info(f"Number of genes: {num_genes}")
    logger.info(f"figure_length: {figure_length:.2f} inches, figure_height: {figure_height:.2f} inches")
    
    plt.figure(figsize=(figure_length, figure_height))
    
    # Prepare annotations if needed
    if args.show_values:
        annot = recovery_rates.set_index('Sample/Locus')
        for col in annot.columns:
            annot[col] = annot[col].map(lambda x: '' if x == 0 else f'{x:.2f}')
        
        n_rows, n_cols = plot_data.shape
        base_fontsize = 8
        
        # Scale font size based on data dimensions
        if n_cols <= 50:
            col_factor = 1.0
        elif n_cols <= 100:
            col_factor = 0.85
        elif n_cols <= 200:
            col_factor = 0.75
        else:
            col_factor = 0.65 * (100 / np.log(n_cols))
        
        if n_rows <= 10:
            row_factor = 1.0
        elif n_rows <= 20:
            row_factor = 0.95
        else:
            row_factor = 0.9 * (20 / n_rows)
        
        fontsize = base_fontsize * min(row_factor, col_factor)
        fontsize = max(min(fontsize, 8), 4)
    else:
        annot = False
        fontsize = None
    
    # Create custom colormap
    colors = get_color_gradient(args.color)
    custom_cmap = LinearSegmentedColormap.from_list(f"custom_{args.color}", colors, N=256)
    
    # Draw heatmap
    ax = sns.heatmap(plot_data, 
                vmin=0, 
                vmax=1,
                cmap=custom_cmap,
                xticklabels=not args.no_xlabels,
                yticklabels=not args.no_ylabels,
                cbar_kws={"orientation": "vertical", 
                         "pad": 0.01,
                         "ticks": np.arange(0, 1.1, 0.1)},  # Set ticks every 0.1
                linewidths=0.5,
                linecolor='#D3D3D3' if not args.no_grid else None,
                annot=annot,
                fmt='',
                annot_kws={'size': fontsize} if args.show_values else None)
    
    # Set title
    default_title = ("Percentage length recovery for each gene, relative to the maximum value of the target sequences"
                    if args.use_max else
                    "Percentage length recovery for each gene, relative to the mean value of the target sequences")
    plt.title(args.title if args.title else default_title,
             pad=20, fontsize=14, fontweight='bold')
    
    # Set axis labels
    plt.xlabel(args.xlabel if args.xlabel else "Locus name", fontsize=12, labelpad=10)
    plt.ylabel(args.ylabel if args.ylabel else "Sample name", fontsize=12, labelpad=10)
    
    # Adjust label sizes
    if not args.no_xlabels:
        plt.xticks(rotation=90, 
                  size=args.gene_text_size if args.gene_text_size else 10)
    if not args.no_ylabels:
        plt.yticks(rotation=0, 
                  size=args.sample_text_size if args.sample_text_size else 10)
    
    # Add border
    if not args.no_grid:
        for spine in ['left', 'right', 'top', 'bottom']:
            ax.spines[spine].set_visible(True)
            ax.spines[spine].set_color('black')
            ax.spines[spine].set_linewidth(1.0)
    
    # Save plot
    output_file = f"{args.output_heatmap}.{args.heatmap_filetype}"
    plt.savefig(output_file, 
                dpi=args.heatmap_dpi, 
                bbox_inches='tight')
    plt.close()
    
    logger.info(f"Successfully saved heatmap to: {output_file}")

def get_color_gradient(color_name):
    """Return a list of color gradients based on the color name."""
    color_gradients = {
        'purple': [(1, 1, 1), (0.937, 0.914, 0.961), (0.807, 0.741, 0.890), 
                  (0.619, 0.514, 0.800), (0.384, 0.234, 0.600)],
        'red': [(1, 1, 1), (1, 0.9, 0.9), (1, 0.7, 0.7), 
                (0.8, 0.4, 0.4), (0.6, 0, 0)],
        'yellow': [(1, 1, 1), (1, 1, 0.9), (1, 1, 0.7), 
                   (0.95, 0.95, 0.4), (0.8, 0.8, 0)],
        'green': [(1, 1, 1), (0.9, 1, 0.9), (0.7, 0.9, 0.7), 
                  (0.4, 0.8, 0.4), (0, 0.6, 0)],
        'blue': [(1, 1, 1), (0.9, 0.9, 1), (0.7, 0.7, 1), 
                 (0.4, 0.4, 0.8), (0, 0, 0.6)],
        'black': [(1, 1, 1), (0.8, 0.8, 0.8), (0.6, 0.6, 0.6), 
                  (0.3, 0.3, 0.3), (0, 0, 0)]
    }
    return color_gradients.get(color_name, color_gradients['black'])

def extract_species_names(input_dir):
    """Extract unique species names from FASTA files."""
    species_set = set()
    fasta_files = [f for f in os.listdir(input_dir) 
                   if os.path.isfile(os.path.join(input_dir, f)) and 
                   any(f.lower().endswith(ext) for ext in ['.fna', '.fasta', '.fa'])]
    
    for fasta_file in fasta_files:
        with open(os.path.join(input_dir, fasta_file)) as f:
            for line in f:
                if line.startswith('>'):
                    # Remove '>' and split by space
                    species = line[1:].strip().split()[0]
                    species_set.add(species)
    
    return sorted(list(species_set))

def main(args):
    """Main function"""
    
    # Calculate sequence lengths
    if not args.output_seq_lengths:
        args.output_seq_lengths = os.path.join(os.getcwd(), "seq_lengths.tsv")
        logger.info(f"No output path specified for sequence lengths, using default: {args.output_seq_lengths}")
    
    df = calculate_seq_lengths(args.input_dir, args.species_list, 
                             args.output_species_list, 
                             args.output_seq_lengths, 
                             args.reference, args.threads, args.use_max)
    
    # Create heatmap unless --no_heatmap is specified
    if not args.no_heatmap:
        create_heatmap(df, args)

def standalone():
    """Parse command line arguments and run main function"""
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawTextHelpFormatter)
    
    # Required input parameters
    parser.add_argument('-i', '--input_dir', required=True,
                        help='Directory containing FASTA files for each locus')
    parser.add_argument('-r', '--ref', required=True, dest='reference',
                        help='Reference sequences file (FASTA format)')
    
    # Sample list related parameters
    parser.add_argument('-s', '--species_list',
                        help='File containing list of species names (one per line). '
                             'If not provided, species names will be extracted from FASTA files')
    
    # Output related parameters (grouped together)
    parser.add_argument('--output_species_list', '-osp', 
                        help='Output file for extracted species list (when species_list is not provided)')
    parser.add_argument('--output_heatmap', '-oh', 
                        default='recovery_heatmap',
                        help='Output path and filename for the heatmap (default: recovery_heatmap)')
    parser.add_argument('--output_seq_lengths', '-osl', 
                        help='Output file for sequence lengths (TSV format). If not provided, '
                             'sequence lengths will be written to seq_lengths.tsv in current directory')
    
    # Performance related parameters
    parser.add_argument('-t', '--threads', type=int, default=1,
                        help='Number of threads to use (default: 1)')
    
    # Heatmap appearance settings (sorted alphabetically)
    parser.add_argument('--color', 
                        choices=['purple', 'red', 'yellow', 'green', 'blue', 'black'],
                        default='black',
                        help='Color scheme for the heatmap (default: black)')
    parser.add_argument('--figure_height', type=int,
                        help='Height dimension (inches) for the heatmap')
    parser.add_argument('--figure_length', type=int,
                        help='Length dimension (inches) for the heatmap')
    parser.add_argument('--gene_text_size', type=int,
                        help='Size (points) for gene text labels')
    parser.add_argument('--heatmap_dpi', type=int, default=300,
                        help='DPI for the heatmap (default: 300)')
    parser.add_argument('--heatmap_filetype', 
                        choices=['png', 'pdf', 'eps', 'tiff', 'svg'],
                        default='png',
                        help='File type for the heatmap (default: png)')
    parser.add_argument('--no_grid', action='store_true',
                        help='Do not show grid lines in the heatmap')
    parser.add_argument('--no_heatmap', action='store_true',
                        help='Do not create recovery heatmap, only output sequence lengths')
    parser.add_argument('--no_xlabels', action='store_true',
                        help='Do not show x-axis (loci) labels')
    parser.add_argument('--no_ylabels', action='store_true',
                        help='Do not show y-axis (samples) labels')
    parser.add_argument('--sample_text_size', type=int,
                        help='Size (points) for sample text labels')
    parser.add_argument('--show_values', action='store_true',
                        help='Show recovery rate values in heatmap cells (except for zero values)')
    parser.add_argument('--title',
                        help='Main title of the heatmap (default: "Percentage length recovery for each gene")')
    parser.add_argument('--use_max', action='store_true',
                        help='Use maximum length instead of average length from reference sequences')
    parser.add_argument('--xlabel',
                        help='X-axis label (default: "Locus")')
    parser.add_argument('--ylabel',
                        help='Y-axis label (default: "Sample")')
    
    args = parser.parse_args()
    
    logger.info("plot_recovery_heatmap.py was called with these arguments:")
    logger.info(" ".join(sys.argv[1:]))  # Use logger to output parameters
    
    # Validate input
    if not os.path.isdir(args.input_dir):
        parser.error(f"Input directory does not exist: {args.input_dir}")
    if args.species_list and not os.path.isfile(args.species_list):
        parser.error(f"Species list file does not exist: {args.species_list}")
    if not os.path.isfile(args.reference):
        parser.error(f"Reference file does not exist: {args.reference}")
    
    # Create output directories if needed
    if args.output_seq_lengths:
        os.makedirs(os.path.dirname(os.path.abspath(args.output_seq_lengths)), exist_ok=True)
    if not args.no_heatmap:  # Modify here, use no_heatmap instead of create_heatmap
        os.makedirs(os.path.dirname(os.path.abspath(args.output_heatmap)), exist_ok=True)
    if args.output_species_list:
        os.makedirs(os.path.dirname(os.path.abspath(args.output_species_list)), exist_ok=True)
    
    main(args)

if __name__ == '__main__':
    standalone()