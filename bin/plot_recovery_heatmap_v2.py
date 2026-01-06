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
Part of HybSuite
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
import numpy as np

try:
    import plotly.graph_objects as go
    from plotly.subplots import make_subplots
except ImportError:
    sys.exit("Required Python package 'plotly' not found. Is it installed?")

from hybpiper.version import __version__

# Import non-standard-library modules:
try:
    import pandas as pd
except ImportError:
    sys.exit("Required Python package 'pandas' not found. Is it installed?")

# ANSI color codes
class ColoredFormatter(logging.Formatter):
    """Custom formatter with colors for different log levels"""
    
    # ANSI escape codes for colors
    COLORS = {
        'DEBUG': '\033[36m',       # Cyan
        'INFO': '\033[0m',         # Default (no color)
        'WARNING': '\033[1;93m',   # Bold Bright Yellow (more visible)
        'ERROR': '\033[1;91m',     # Bold Bright Red
        'CRITICAL': '\033[1;91m',  # Bold Bright Red
    }
    RESET = '\033[0m'  # Reset to default
    
    def format(self, record):
        # For WARNING and ERROR, color the entire message
        if record.levelno >= logging.WARNING:
            color = self.COLORS.get(record.levelname, self.RESET)
            formatted = super().format(record)
            # Apply color to the entire line
            return f"{color}{formatted}{self.RESET}"
        
        return super().format(record)

# Setup logging
logger = logging.getLogger(f'hybpiper.{__name__}')
logger.handlers = []  # Clear all existing handlers
handler = logging.StreamHandler(sys.stdout)
handler.setFormatter(ColoredFormatter(
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

def get_sequence_length(file_path, filename_suffix=None, species_filter=None):
    """Get lengths of all sequences in a single file
    
    Args:
        file_path: Path to the FASTA file
        filename_suffix: Suffix to remove from filename to get locus name
        species_filter: Set of species names to include (if None, include all)
    """
    lengths = {}
    try:
        for record in SeqIO.parse(file_path, "fasta"):
            species_raw = record.id.split()[0]
            # Remove suffix like .digits or .main to get base sample name
            species = re.sub(r'\.(main|\d+)$', '', species_raw)
            
            # Skip this species if it's not in the filter list
            if species_filter is not None and species not in species_filter:
                continue
            
            seq_length = len(record.seq)
            # Keep only the longest sequence for each sample
            if species not in lengths or seq_length > lengths[species]:
                lengths[species] = seq_length
    except Exception as e:
        logger.error(f"Error processing {file_path}: {str(e)}")
    
    # Extract locus name from filename
    locus_raw = os.path.splitext(os.path.basename(file_path))[0]
    
    # Remove suffix from filename if specified
    if filename_suffix:
        # Support multiple suffixes separated by comma
        suffixes = [s.strip() for s in filename_suffix.split(',')]
        # Escape special regex characters and create pattern
        escaped_suffixes = [re.escape(s) for s in suffixes]
        pattern = r'(' + '|'.join(escaped_suffixes) + r')$'
        locus = re.sub(pattern, '', locus_raw)
    else:
        # If no suffix specified, use the filename as is
        locus = locus_raw
    
    return locus, lengths

def calculate_seq_lengths(input_dir, species_list_file, output_species_list, output_file, ref_file, threads=1, use_max=False, filename_suffix=None):
    """Calculate sequence lengths for each species and locus"""
    # If no species list is provided, automatically extract it
    if species_list_file is None:
        species = extract_species_names(input_dir)
        species_filter = None  # No filtering needed
        if output_species_list:
            os.makedirs(os.path.dirname(os.path.abspath(output_species_list)), exist_ok=True)
            with open(output_species_list, 'w') as f:
                for sp in species:
                    f.write(f"{sp}\n")
            logger.info(f"Species list has been written to {output_species_list}")
    else:
        # Read species list from file
        with open(species_list_file, 'r') as f:
            species = [line.strip() for line in f if line.strip()]  # Filter out empty lines
        # Create a set for efficient filtering
        species_filter = set(species)
        logger.info(f"Loaded {len(species)} species from species list file")
    
    fasta_files = [f for f in os.listdir(input_dir) 
                   if os.path.isfile(os.path.join(input_dir, f)) and 
                   any(f.lower().endswith(ext) for ext in ['.fna', '.fasta', '.fa'])]
    fasta_files.sort(key=natural_sort_key)
    
    avg_lengths, max_lengths = get_reference_lengths(ref_file)
    ref_lengths = max_lengths if use_max else avg_lengths
    
    results = defaultdict(dict)
    all_found_species = set()  # Track all species found in FASTA files
    
    with concurrent.futures.ThreadPoolExecutor(max_workers=threads) as executor:
        future_to_file = {
            executor.submit(get_sequence_length, os.path.join(input_dir, f), filename_suffix, species_filter): f 
            for f in fasta_files
        }
        
        for future in concurrent.futures.as_completed(future_to_file):
            locus, lengths = future.result()
            results[locus] = lengths
            all_found_species.update(lengths.keys())
    
    # Check for mismatches if species list was provided
    if species_filter is not None:
        missing_species = set(species) - all_found_species
        extra_species = all_found_species - set(species)
        
        if missing_species:
            logger.warning(f"WARNING: {len(missing_species)} species in the list were NOT found in FASTA files:")
            for sp in sorted(list(missing_species))[:10]:  # Show first 10
                logger.warning(f"  - {sp}")
            if len(missing_species) > 10:
                logger.warning(f"  ... and {len(missing_species) - 10} more")
        
        if extra_species:
            logger.warning(f"INFO: {len(extra_species)} species found in FASTA files but NOT in the list (filtered out):")
            for sp in sorted(list(extra_species))[:10]:  # Show first 10
                logger.warning(f"  - {sp}")
            if len(extra_species) > 10:
                logger.warning(f"  ... and {len(extra_species) - 10} more")
    
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

def get_plotly_colorscale(style='viridis'):
    """Return a Plotly colorscale for the given style.

    Styles mirror the monochrome schemes used in stage2_report:
      - 'viridis': use Plotly's built-in Viridis
      - 'purple', 'blue', 'green', 'red', 'yellow', 'black':
        custom monochrome gradients from white to a dark tone.
    """
    if style == 'purple':
        return [
            [0.0, "rgb(255,255,255)"],
            [0.5, "rgb(128,125,186)"],
            [1.0, "rgb(84,39,143)"],
        ]
    if style == 'blue':
        return [
            [0.0, "rgb(255,255,255)"],
            [0.5, "rgb(66,146,198)"],
            [1.0, "rgb(8,48,107)"],
        ]
    if style == 'green':
        return [
            [0.0, "rgb(255,255,255)"],
            [0.5, "rgb(161,217,155)"],
            [1.0, "rgb(0,87,35)"],
        ]
    if style == 'black':
        return [
            [0.0, "rgb(255,255,255)"],
            [1.0, "rgb(0,0,0)"],
        ]

    if style == 'magma':
        return "Magma"
    if style == 'inferno':
        return "Inferno"
    if style == 'plasma':
        return "Plasma"
    if style == 'cividis':
        return "Cividis"
    if style == 'turbo':
        return "Turbo"   # Google turbo colormap
    if style == 'viridis':
        return "Viridis"
    
    # Default: use Plotly's built-in Viridis.
    return "Viridis"

def create_plotly_html_heatmap(df, args):
    """Create an interactive Plotly heatmap and save as HTML.

    This uses the same recovery-rate calculation as the static heatmap,
    and writes an HTML file whose base name is given by --output_heatmap.
    """
    df = df.copy()

    # Convert numeric columns
    numeric_columns = df.columns.difference(['Sample/Locus'])
    df[numeric_columns] = df[numeric_columns].astype(float)

    # Remove summary rows and keep only real samples
    if 'Sample/Locus' in df.columns:
        df = df[~df['Sample/Locus'].isin(['MeanLength(Targetfile)', 'MaxLength(Targetfile)'])]

    # Get reference lengths directly from reference FASTA (stage2_report style)
    avg_lengths, max_lengths = get_reference_lengths(args.reference)
    ref_dict = max_lengths if args.use_max else avg_lengths

    # Compute recovery rates (0-1) relative to reference lengths
    recovery_rates = pd.DataFrame(index=df.index, columns=df.columns)
    recovery_rates['Sample/Locus'] = df['Sample/Locus']

    for col in df.columns[1:]:
        ref = float(ref_dict.get(col, 0))
        if ref == 0:
            recovery_rates[col] = 0.0
        else:
            recovery_rates[col] = df[col].astype(float) / ref

    # For hover, keep the absolute lengths for real samples
    length_values = df.copy()

    samples = recovery_rates['Sample/Locus'].tolist()
    loci = list(recovery_rates.columns[1:])
    
    # Check if dataset is large and apply hover text optimization
    num_samples = len(samples)
    num_loci = len(loci)
    is_large_dataset = num_loci > 500 or num_samples > 300
    
    if is_large_dataset:
        if num_loci > 500:
            logger.warning(f"Large dataset detected ({num_loci} loci > threshold 500). Using simplified hover text to reduce file size.")
        if num_samples > 300:
            logger.warning(f"Large dataset detected ({num_samples} samples > threshold 300). Using simplified hover text to reduce file size.")
    
    # Convert ratios to percentage for display
    z_matrix = (recovery_rates[loci].astype(float) * 100.0).values.tolist()

    # Pre-compute totals for samples (rows) and loci (columns), similar to stage2_report
    sample_totals = [sum(v for v in row if v > 0) for row in z_matrix]
    locus_totals = []
    if loci:
        num_rows = len(z_matrix)
        num_cols = len(loci)
        for j in range(num_cols):
            col_vals = [z_matrix[i][j] for i in range(num_rows)]
            pos_vals = [v for v in col_vals if v > 0]
            locus_totals.append(sum(pos_vals) if pos_vals else 0)
    else:
        locus_totals = []

    # Build hover text with length and coverage
    # Simplify hover text for large datasets to reduce file size
    def build_hover_matrix(current_samples, current_loci, current_z, row_index_map=None, col_index_map=None):
        hover = []
        for new_i, sample in enumerate(current_samples):
            orig_i = row_index_map[new_i] if row_index_map is not None else new_i
            row_hover = []
            for new_j, locus in enumerate(current_loci):
                orig_j = col_index_map[new_j] if col_index_map is not None else new_j
                length_val = 0.0
                if locus in length_values.columns and orig_i < len(length_values.index):
                    length_val = float(length_values.loc[length_values.index[orig_i], locus])
                cov_val = float(current_z[new_i][new_j])
                
                if is_large_dataset:
                    # Simplified hover text for large datasets
                    row_hover.append(
                        f"{sample}<br>{locus}<br>{length_val:.0f}bp<br>{cov_val:.1f}%"
                    )
                else:
                    # Full hover text for smaller datasets
                    row_hover.append(
                        f"<b>{sample}</b><br>Locus: <b>{locus}</b><br>Length: <b>{length_val:.0f} bp</b><br>Length coverage: <b>{cov_val:.2f}%</b>"
                    )
            hover.append(row_hover)
        return hover

    # Initial order: as provided in the TSV
    hover_matrix = build_hover_matrix(samples, loci, z_matrix)

    # Compute bar data (fixed order, not affected by sorting buttons in this step)
    # Top bars: per-locus sample counts with coverage > 0
    bar_top_counts = []
    for j in range(len(loci)):
        col_vals = [z_matrix[i][j] for i in range(len(samples))]
        bar_top_counts.append(sum(1 for v in col_vals if v > 0))

    # Right bars: per-sample locus counts with coverage > 0
    bar_right_counts = []
    for i in range(len(samples)):
        row_vals = z_matrix[i]
        bar_right_counts.append(sum(1 for v in row_vals if v > 0))

    # Percentages for coloring (0-100), using same Viridis colorscale as heatmap.
    # These are defined ONCE and never recomputed under sorting; sorting only permutes their order.
    total_samples = len(samples) if len(samples) > 0 else 1
    total_loci = len(loci) if len(loci) > 0 else 1
    bar_top_percents = [count / total_samples * 100.0 for count in bar_top_counts]
    bar_right_percents = [count / total_loci * 100.0 for count in bar_right_counts]

    # Choose Plotly colorscale based on --color option
    colorscale = get_plotly_colorscale(getattr(args, "color", "viridis"))

    # Create subplots: top bar (row=1,col=1), heatmap (row=2,col=1), right bar (row=2,col=2)
    fig = make_subplots(
        rows=2,
        cols=2,
        row_heights=[0.25, 0.75],
        column_widths=[0.85, 0.15],
        specs=[[{"type": "bar", "colspan": 2}, None],
               [{"type": "heatmap"}, {"type": "bar"}]],
        vertical_spacing=0.03,
        horizontal_spacing=0.03,
    )

    # Top bar: number of samples with non-zero coverage per locus
    fig.add_trace(
        go.Bar(
            x=loci,
            y=bar_top_counts,
            marker=dict(
                color=bar_top_percents,
                colorscale=colorscale,
                cmin=0,
                cmax=100,
                showscale=False,
                line=dict(color="rgb(8,8,8)", width=0),
            ),
            showlegend=False,
            name="Samples per locus",
            hovertemplate=(
                "Locus: <b>%{x}</b><br>"
                "Samples recovered: <b>%{y}</b><extra></extra>"
            ),
        ),
        row=1,
        col=1,
    )

    # Main heatmap
    fig.add_trace(
        go.Heatmap(
            x=loci,
            y=samples,
            z=z_matrix,
            text=hover_matrix,
            colorscale=colorscale,
            zmin=0,
            zmax=95,
            colorbar=dict(title='<b>Coverage (%)</b>', ticksuffix='<b>%</b>', ticks="outside"),
            hovertemplate="%{text}<extra></extra>",
            hoverongaps=False,
            xgap=args.grid_width,
            ygap=args.grid_width,
        ),
        row=2,
        col=1,
    )

    # Right bar: number of loci with non-zero coverage per sample
    fig.add_trace(
        go.Bar(
            x=bar_right_counts,
            y=samples,
            orientation='h',
            marker=dict(
                color=bar_right_percents,
                colorscale=colorscale,
                cmin=0,
                cmax=100,
                showscale=False,
                line=dict(color="rgb(8,8,8)", width=0),
            ),
            showlegend=False,
            name="Loci per sample",
            hovertemplate=(
                "Sample: <b>%{y}</b><br>"
                "Loci recovered: <b>%{x}</b><extra></extra>"
            ),
        ),
        row=2,
        col=2,
    )
    fig.update_layout(bargap=0.1)

    # Buttons for sorting by total recovery of each sample and each locus (similar idea to stage2_report)
    buttons = []
    for label, mode in [("Locus name", None), ("Descending", 'descending'), ("Ascending", 'ascending')]:
        if mode is None:
            row_idx = list(range(len(samples)))
            col_idx = list(range(len(loci)))
        else:
            descending = (mode == 'descending')
            # Row (sample) order
            row_idx = list(range(len(samples)))
            row_idx.sort(key=lambda i: sample_totals[i], reverse=descending)
            # Column (locus) order
            col_idx = list(range(len(loci)))
            col_idx.sort(key=lambda j: locus_totals[j], reverse=descending)

        # Apply ordering to all components
        new_samples = [samples[i] for i in row_idx]
        new_loci = [loci[j] for j in col_idx]
        new_z = [[z_matrix[i][j] for j in col_idx] for i in row_idx]
        new_hover = build_hover_matrix(new_samples, new_loci, new_z, row_idx, col_idx)

        # Bars: keep counts and percentage colors, but permute to stay aligned with heatmap after sorting.
        # Each locus/sample keeps its own percentage and thus its own color; only position changes.
        new_bar_top = [bar_top_counts[j] for j in col_idx]
        new_bar_right = [bar_right_counts[i] for i in row_idx]
        new_bar_top_perc = [bar_top_percents[j] for j in col_idx]
        new_bar_right_perc = [bar_right_percents[i] for i in row_idx]

        # Update all three traces together: [top_bar, heatmap, right_bar]
        buttons.append(
            dict(
                label=label,
                method='update',
                args=[
                    {
                        "x": [new_loci, new_loci, new_bar_right],
                        "y": [new_bar_top, new_samples, new_samples],
                        "z": [None, new_z, None],
                        "text": [None, new_hover, None],
                        # Update per-trace marker colors explicitly using marker.color
                        "marker.color": [new_bar_top_perc, None, new_bar_right_perc],
                    },
                    {},
                ],
            )
        )

    if args.title:
        html_title = args.title
    else:
        html_title = "Length recovery heatmap (generated via HybSuite)"

    # Make title bold in HTML
    html_title = f"<b>{html_title}</b>"

    # Control relative heights similar to stage2_report: fixed top bar height
    TOP_BAR_HEIGHT = 88
    GAP_between_top_bar_heatmap = 6
    no_use_max_height = True
    
    if is_large_dataset:
        total_height = max(400, 180 + 18 * num_samples)
    else:
        if num_samples > 300:
            total_height = max(400, 180 + 15 * num_samples)
            if total_height > 3000:
                total_height = 3000
                no_use_max_height = False
        else:
            total_height = max(400, 180 + 20 * num_samples)

    top_bar_domain_start = 1 - (TOP_BAR_HEIGHT / total_height)
    main_heatmap_domain_end = top_bar_domain_start - (GAP_between_top_bar_heatmap / total_height)
    fig.update_layout(
        font_family="Arial",
        plot_bgcolor="white",
        title=dict(
            text=html_title,
            x=0.5,
            xanchor="center",
            font=dict(
            size=20,
            family="Arial",
            color="black"
            )
        ),
        # Top bar axes (row=1, col=1) - align horizontally with heatmap
        xaxis=dict(
            title="",
            showticklabels=False,
            showgrid=False,
            linecolor="black",
            linewidth=1.2,
            showline=True,
            mirror=False,
            gridcolor="white",
            ticks="",
            domain=[0, 0.95],
        ),
        yaxis=dict(
            title="<b>Total samples</b>",
            linecolor="black",
            linewidth=1.2,
            showline=True,
            showgrid=False,
            mirror=False,
            gridcolor="white",
            ticks="outside",
            domain=[top_bar_domain_start, 1],
        ),
        # Heatmap axes (row=2, col=1)
        xaxis2=dict(
            title=args.xlabel if args.xlabel else "<b>Locus</b>",
            linecolor="black",
            linewidth=1.2,
            showline=True,
            mirror=True,
            ticks="outside",
            showgrid=False,
            domain=[0, 0.95],
            tickangle=270,
            tickfont=dict(size=9),
            automargin=True,
        ),
        yaxis2=dict(
            title=args.ylabel if args.ylabel else "<b>Sample</b>",
            autorange="reversed",
            linecolor="black",
            linewidth=1.2,
            showline=True,
            mirror=True,
            ticks="outside",
            tickson="labels",
            showgrid=False,
            domain=[0, main_heatmap_domain_end],
            **({"dtick": 1} if no_use_max_height else {})
        ),
        # Right bar axes (row=2, col=2)
        xaxis3=dict(
            title="<b>Total loci</b>",
            linecolor="black",
            linewidth=1.2,
            showline=True,
            showgrid=False,
            mirror=False,
            gridcolor="white",
            ticks="outside",
            domain=[0.955, 1],
        ),
        yaxis3=dict(
            title="",
            showticklabels=False,
            showgrid=False,
            linecolor="black",
            linewidth=1.2,
            showline=True,
            mirror=False,
            gridcolor="white",
            ticks="",
            domain=[0, main_heatmap_domain_end],
            # Reverse the right bar y-axis so its visual order matches the
            # heatmap (which uses autorange="reversed" on yaxis2).
            autorange="reversed",
        ),
        hoverlabel=dict(
            font_color="#FFFFFF",
            bordercolor="#FFFFFF",
            bgcolor="#444444",
        ),
        updatemenus=[
            dict(
                buttons=buttons,
                type="dropdown",
                direction="down",
                pad={"t": 10, "b": 10},
                showactive=True,
                x=0.95,
                xanchor="right",
                y=1.0,
                yanchor="bottom",
            )
        ],
        annotations=[
            # Annotation for Sort by (left of dropdown)
            dict(
                text="<b>Sort by:</b>",
                x=0.95,
                xref="paper",
                xanchor="right",
                xshift=-105,
                y=1,
                yref="paper",
                yanchor="top",
                yshift=36,
                align="right",
                showarrow=False,
            ),
        ],
        height=total_height,
    )

    html_path = f"{args.output_heatmap}"
    try:
        fig.write_html(
            html_path,
            include_plotlyjs='cdn',
            full_html=True,
            config={
                "scrollZoom": True,
                "displaylogo": True,
                "toImageButtonOptions": {
                    "format": "png",
                },
                "modeBarButtonsToAdd": [
                    "v1hovermode",
                    "hoverclosest",
                    "hovercompare",
                    "togglehover",
                    "togglespikelines",
                    "drawline",
                    "drawopenpath",
                    "drawclosedpath",
                    "drawcircle",
                    "drawrect",
                    "eraseshape",
                ],
            },
        )
        logger.info(f"Successfully saved interactive Plotly heatmap to: {html_path}")
    except Exception as e:
        logger.error(f"Failed to write Plotly HTML heatmap: {e}")

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
                    species_raw = line[1:].strip().split()[0]
                    # Remove suffix like .digits or .main to get base sample name
                    species = re.sub(r'\.(main|\d+)$', '', species_raw)
                    species_set.add(species)
    
    return sorted(list(species_set))

def main(args):
    """Main function"""
    
    # Calculate sequence lengths
    heatmap_cwd = os.path.dirname(args.output_heatmap)
    if not args.output_seq_lengths:
        args.output_seq_lengths = os.path.join(heatmap_cwd, "seq_lengths.tsv")
        logger.info(f"No output path specified for sequence lengths, using default: {args.output_seq_lengths}")
    
    df = calculate_seq_lengths(args.input_dir, args.species_list, 
                             args.output_species_list, 
                             args.output_seq_lengths, 
                             args.reference, args.threads, args.use_max,
                             args.filename_suffix)
    
    # Only create interactive HTML heatmap
    create_plotly_html_heatmap(df, args)

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
    
    # File naming parameters
    parser.add_argument('--filename_suffix',
                        help='Suffix(es) to remove from input FASTA filenames to get locus names. '
                             'Multiple suffixes can be separated by commas. '
                             'Example: "_paralogs_all". '
                             'If not specified, the input filenames will be recognized as loci names.')
    
    # Output related parameters (grouped together)
    parser.add_argument('--output_species_list', '-osp', 
                        help='Output file for extracted species list (when species_list is not provided)')
    parser.add_argument('--output_heatmap', '-oh', 
                        default='recovery_heatmap.html',
                        help='Output path and filename for the heatmap (default: recovery_heatmap.html). '
                             'Should end with .html extension.')
    parser.add_argument('--output_seq_lengths', '-osl', 
                        help='Output file for sequence lengths (TSV format). If not provided, '
                             'sequence lengths will be written to seq_lengths.tsv in current directory')
    
    # Performance related parameters
    parser.add_argument('-t', '--threads', type=int, default=1,
                        help='Number of threads to use (default: 1)')
    
    # Heatmap appearance settings (for HTML heatmap)
    parser.add_argument('--color', 
                        choices=['viridis', 'magma', 'inferno', 'plasma', 'cividis', 'turbo', 'purple', 'blue', 'green', 'black'],
                        default='blue',
                        help='Color scheme for the HTML heatmap (default: blue). '
                             'Available options: viridis, magma, inferno, plasma, cividis, turbo, purple, blue, green, black')
    parser.add_argument('--title',
                        help='Main title of the heatmap (default: "Percentage length recovery for each gene")')
    parser.add_argument('--use_max', action='store_true',
                        help='Use maximum length instead of average length from reference sequences')
    parser.add_argument('--xlabel',
                        help='X-axis label (default: "Locus")')
    parser.add_argument('--ylabel',
                        help='Y-axis label (default: "Sample")')
    parser.add_argument('-gw', '--grid_width', default="0.38", type=float,
                        help='The value of grid width of the heatmap, recommended to set as "0" when the locus number is huge (default: 0.5)')
    
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
    # Always ensure HTML output directory exists
    os.makedirs(os.path.dirname(os.path.abspath(args.output_heatmap)), exist_ok=True)
    if args.output_species_list:
        os.makedirs(os.path.dirname(os.path.abspath(args.output_species_list)), exist_ok=True)
    
    main(args)

if __name__ == '__main__':
    standalone()
