#!/usr/bin/env python

"""
stage2_report.py - Generate comparison report for original vs filtered sequences

This script compares sequences before and after filtering, calculating length coverage
and paralog counts for each sample at each locus based on reference sequences.

Output files:
1. length_stats.tsv (5 columns):
   - sample_name: Name of the sample
   - type: 'original' or 'filtered'
   - locus: Locus name
   - length: Actual sequence length
   - length_coverage: Percentage of reference sequence length recovered

2. paralog_stats.tsv (4 columns):
   - sample_name: Name of the sample
   - type: 'original' or 'filtered'
   - locus: Locus name
   - paralog_sequences: Number of sequences for this sample at this locus

3. hybsuite_stage2_report.html:
   - Interactive HTML report with plotly heatmaps
   - Displays length recovery for original and filtered sequences
   - Includes bar charts showing recovery counts per locus and per sample
   - Supports dynamic sorting and interactive exploration
   - Customizable color schemes via --color_style argument:
     * viridis: Colorblind-friendly warm gradient (default)
     * purple:  Purple monochrome gradient
     * blue:    Blue monochrome gradient
     * green:   Green monochrome gradient
"""

import sys
import argparse
import os
import re
from collections import defaultdict
import concurrent.futures
from Bio import SeqIO
import logging

# Import pandas
try:
    import pandas as pd
except ImportError:
    sys.exit("Required Python package 'pandas' not found. Is it installed?")

# Import plotly
try:
    import plotly.graph_objects as go
    from plotly.subplots import make_subplots
except ImportError:
    sys.exit("Required Python package 'plotly' not found. Is it installed?")

# Import numpy
try:
    import numpy as np
except ImportError:
    sys.exit("Required Python package 'numpy' not found. Is it installed?")

# ANSI color codes for logging
class ColoredFormatter(logging.Formatter):
    """Custom formatter with colors for different log levels"""
    
    COLORS = {
        'DEBUG': '\033[36m',       # Cyan
        'INFO': '\033[0m',         # Default (no color)
        'WARNING': '\033[1;93m',   # Bold Bright Yellow
        'ERROR': '\033[1;91m',     # Bold Bright Red
        'CRITICAL': '\033[1;91m',  # Bold Bright Red
    }
    RESET = '\033[0m'
    
    def format(self, record):
        if record.levelno >= logging.WARNING:
            color = self.COLORS.get(record.levelname, self.RESET)
            formatted = super().format(record)
            return f"{color}{formatted}{self.RESET}"
        return super().format(record)

# Setup logging
logger = logging.getLogger(__name__)
logger.handlers = []
handler = logging.StreamHandler(sys.stdout)
handler.setFormatter(ColoredFormatter(
    '[%(asctime)s] [%(levelname)s] %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
))
logger.addHandler(handler)
logger.setLevel(logging.INFO)
logger.info(f"Generating reports for HybSuite stage2 output ...")
def natural_sort_key(s):
    """Provide a natural sort key for filenames"""
    # Convert to string if it's bytes or other type
    s = str(s) if not isinstance(s, str) else s
    return [int(text) if text.isdigit() else text.lower()
            for text in re.split('([0-9]+)', s)]

def detect_sequence_type(sequence):
    """Automatically detect sequence type (nucleotide or protein)"""
    seq = sequence.upper().replace(" ", "")
    nucleotide_count = sum(1 for base in seq if base in 'ATCGN')
    nucleotide_ratio = nucleotide_count / len(seq)
    return 'nucleotide' if nucleotide_ratio > 0.85 else 'protein'

def get_reference_lengths(ref_file):
    """Calculate average length of each locus in reference sequences"""
    if not os.path.isfile(ref_file):
        logger.error(f"Reference file not found: {ref_file}")
        return {}
    
    locus_lengths = defaultdict(list)
    seq_type = None
    
    try:
        with open(ref_file, 'r') as f:
            for record in SeqIO.parse(f, "fasta"):
                if seq_type is None:
                    seq_type = detect_sequence_type(str(record.seq))
                    logger.info(f"[1] Detected reference sequence type: {seq_type}")
                
                locus = record.id.split('-')[-1]
                length = len(record.seq)
                
                if seq_type == 'protein':
                    length *= 3
                
                locus_lengths[locus].append(length)
    except Exception as e:
        logger.error(f"Error processing reference file: {str(e)}")
        return {}
    
    # Calculate average values
    avg_lengths = {locus: int(sum(lengths)/len(lengths)) 
                  for locus, lengths in locus_lengths.items()}
    
    return avg_lengths

def get_sequence_lengths_from_file(file_path, filename_suffix=None):
    """Get lengths of all sequences in a single file
    
    Returns:
        tuple: (locus_name, dict of {species: length}, dict of {species: paralog_count})
    """
    lengths = {}
    paralog_counts = {}
    
    try:
        for record in SeqIO.parse(file_path, "fasta"):
            species_raw = record.id.split()[0]
            # Remove suffix like .digits or .main to get base sample name
            species = re.sub(r'\.(main|\d+)$', '', species_raw)
            seq_length = len(record.seq)
            
            # Count paralogs for each species
            paralog_counts[species] = paralog_counts.get(species, 0) + 1
            
            # Keep only the longest sequence for each sample
            if species not in lengths or seq_length > lengths[species]:
                lengths[species] = seq_length
    except Exception as e:
        logger.error(f"Error processing {file_path}: {str(e)}")
    
    # Extract locus name from filename
    locus_raw = os.path.splitext(os.path.basename(file_path))[0]
    
    # Remove suffix from filename if specified
    if filename_suffix:
        suffixes = [s.strip() for s in filename_suffix.split(',')]
        escaped_suffixes = [re.escape(s) for s in suffixes]
        pattern = r'(' + '|'.join(escaped_suffixes) + r')$'
        locus = re.sub(pattern, '', locus_raw)
    else:
        locus = locus_raw
    
    return locus, lengths, paralog_counts

def process_directory(input_dir, ref_lengths, seq_type, filename_suffix=None, threads=1):
    """Process all FASTA files in a directory and calculate length coverage
    
    Returns:
        tuple: (locus_data, paralog_data, all_samples_set, all_loci_set)
    """
    fasta_files = [f for f in os.listdir(input_dir) 
                   if os.path.isfile(os.path.join(input_dir, f)) and 
                   any(f.lower().endswith(ext) for ext in ['.fna', '.fasta', '.fa'])]
    fasta_files.sort(key=natural_sort_key)
    
    # Store results by locus and sample
    locus_data = {}  # {locus: {sample: length}}
    paralog_data = {}  # {locus: {sample: paralog_count}}
    all_samples = set()
    all_loci = set()
    
    with concurrent.futures.ThreadPoolExecutor(max_workers=threads) as executor:
        future_to_file = {
            executor.submit(get_sequence_lengths_from_file, 
                          os.path.join(input_dir, f), 
                          filename_suffix): f 
            for f in fasta_files
        }
        
        for future in concurrent.futures.as_completed(future_to_file):
            locus, sample_lengths, sample_paralogs = future.result()
            
            # Get reference length for this locus
            ref_length = ref_lengths.get(locus, 0)
            
            if ref_length == 0:
                logger.warning(f"No reference length found for locus: {locus}")
                continue
            
            all_loci.add(locus)
            locus_data[locus] = sample_lengths
            paralog_data[locus] = sample_paralogs
            all_samples.update(sample_lengths.keys())
    
    return locus_data, paralog_data, all_samples, all_loci

def get_bar_colors(style='viridis'):
    """
    Get bar chart colors for Original and Filtered based on color style.
    
    Args:
        style: Color style name ('viridis', 'purple', 'blue', 'green')
    
    Returns:
        tuple: (color_original, color_filtered) - two colors for bar charts
    """
    if style == 'viridis':
        # Red scheme: bright red and light red/pink
        return "#E63946", "#FFA8B4"  # Bright red, Light pink-red
    elif style == 'purple':
        # Purple scheme: bright purple and light lavender
        return "#8B4FC1", "#D4B5F0"  # Bright purple, Light lavender
    elif style == 'blue':
        # Blue scheme: bright blue and light blue
        return "#4A90E2", "#A8D8EA"  # Bright blue, Light blue
    elif style == 'green':
        # Green scheme: bright green and light mint
        return "#2ECC71", "#7DCEA0"  # Bright green, Light mint green
    else:
        # Default to viridis (red)
        return "#E63946", "#FFA8B4"

def get_color_palette(style='viridis'):
    """
    Get color palette based on user-selected style.
    
    Args:
        style: Color style name ('viridis', 'purple', 'blue', 'green')
    
    Returns:
        tuple: (colorscale, colorscale2) for 0-100% and 0-150% ranges
    """
    if style == 'viridis':
        # Red monochrome gradient (colorblind-friendly)
        # White → very pale peach → bright red → medium dark red (high contrast)
        colorscale = [
            [0.00, "rgb(255,255,255)"],   # 0% 白色
            [0.001, "rgb(255,250,248)"],  # 极极浅桃色（调浅）
            [0.1, "rgb(255,240,235)"],    # 极浅桃色（调浅）
            [0.2, "rgb(255,220,210)"],    # 很浅桃色（调浅）
            [0.3, "rgb(254,190,170)"],    # 浅桃橙（调浅）
            [0.4, "rgb(252,140,110)"],    # 浅红橙
            [0.5, "rgb(245,90,70)"],      # 红橙
            [0.6, "rgb(230,50,40)"],      # 鲜红
            [0.7, "rgb(210,30,25)"],      # 深鲜红
            [0.8, "rgb(185,20,20)"],      # 深红（调浅）
            [0.9, "rgb(160,15,15)"],      # 暗红（调浅）
            [1.0, "rgb(135,10,12)"],      # 深红棕（调浅）
        ]
        colorscale2 = [
            [0.00, "rgb(255,255,255)"],   # 0% 白色
            [0.001, "rgb(255,250,248)"],  # 极极浅桃色（调浅）
            [0.067, "rgb(255,240,235)"],  # 极浅桃色 (~10%，调浅)
            [0.133, "rgb(255,220,210)"],  # 很浅桃色 (~20%，调浅)
            [0.2, "rgb(254,190,170)"],    # 浅桃橙 (~30%，调浅)
            [0.267, "rgb(252,140,110)"],  # 浅红橙 (~40%)
            [0.333, "rgb(245,90,70)"],    # 红橙 (~50%)
            [0.4, "rgb(230,50,40)"],      # 鲜红 (~60%)
            [0.467, "rgb(210,30,25)"],    # 深鲜红 (~70%)
            [0.533, "rgb(185,20,20)"],    # 深红 (~80%，调浅)
            [0.6, "rgb(160,15,15)"],      # 暗红 (~90%，调浅)
            [0.667, "rgb(135,10,12)"],    # 深红棕 (100%，调浅)
            [0.8, "rgb(115,8,10)"],       # 更深红棕 (>100%，调浅)
            [1.0, "rgb(95,6,8)"],         # 很深红棕 (>130%，调浅)
        ]
    
    elif style == 'purple':
        # Purple monochrome: pale lavender → deep purple (darker as value increases)
        colorscale = [
            [0.0, "rgb(255,255,255)"],      # White for 0%
            [0.001, "rgb(252,251,253)"],    # Almost white
            [0.1, "rgb(242,240,247)"],      # Very pale lavender
            [0.2, "rgb(218,218,235)"],      # Pale lavender
            [0.3, "rgb(188,189,220)"],      # Light purple
            [0.4, "rgb(158,154,200)"],      # Medium light purple
            [0.5, "rgb(128,125,186)"],      # Medium purple
            [0.6, "rgb(106,81,163)"],       # Purple
            [0.7, "rgb(84,39,143)"],        # Deep purple
            [0.8, "rgb(63,0,125)"],         # Very deep purple
            [0.9, "rgb(50,0,100)"],         # Dark purple
            [1.0, "rgb(39,0,78)"],          # Nearly black purple
        ]
        colorscale2 = [
            [0.0, "rgb(255,255,255)"],
            [0.001, "rgb(252,251,253)"],
            [0.067, "rgb(242,240,247)"],
            [0.133, "rgb(218,218,235)"],
            [0.2, "rgb(188,189,220)"],
            [0.267, "rgb(158,154,200)"],
            [0.333, "rgb(128,125,186)"],
            [0.4, "rgb(106,81,163)"],
            [0.467, "rgb(84,39,143)"],
            [0.533, "rgb(63,0,125)"],
            [0.6, "rgb(50,0,100)"],
            [0.667, "rgb(39,0,78)"],        # Nearly black purple at 100%
            [0.8, "rgb(25,0,50)"],          # Even darker purple for >100%
            [1.0, "rgb(12,0,25)"],          # Almost pure black for >130%
        ]
    
    elif style == 'blue':
        # Blue monochrome: pale sky blue → deep navy (darker as value increases)
        colorscale = [
            [0.0, "rgb(255,255,255)"],      # White for 0%
            [0.001, "rgb(247,251,255)"],    # Almost white
            [0.1, "rgb(222,235,247)"],      # Very pale blue
            [0.2, "rgb(198,219,239)"],      # Pale blue
            [0.3, "rgb(158,202,225)"],      # Light blue
            [0.4, "rgb(107,174,214)"],      # Medium light blue
            [0.5, "rgb(66,146,198)"],       # Sky blue
            [0.6, "rgb(33,113,181)"],       # Blue
            [0.7, "rgb(8,81,156)"],         # Deep blue
            [0.8, "rgb(8,48,107)"],         # Navy blue
            [0.9, "rgb(5,32,80)"],          # Dark navy
            [1.0, "rgb(3,19,50)"],          # Nearly black blue
        ]
        colorscale2 = [
            [0.0, "rgb(255,255,255)"],
            [0.001, "rgb(247,251,255)"],
            [0.067, "rgb(222,235,247)"],
            [0.133, "rgb(198,219,239)"],
            [0.2, "rgb(158,202,225)"],
            [0.267, "rgb(107,174,214)"],
            [0.333, "rgb(66,146,198)"],
            [0.4, "rgb(33,113,181)"],
            [0.467, "rgb(8,81,156)"],
            [0.533, "rgb(8,48,107)"],
            [0.6, "rgb(5,32,80)"],
            [0.667, "rgb(3,19,50)"],        # Nearly black blue at 100%
            [0.8, "rgb(2,12,30)"],          # Even darker blue for >100%
            [1.0, "rgb(1,6,15)"],           # Almost pure black for >130%
        ]
    
    elif style == 'green':
        # Green monochrome: pale mint → deep forest green (darker as value increases)
        colorscale = [
            [0.0, "rgb(255,255,255)"],      # White for 0%
            [0.001, "rgb(247,252,245)"],    # Almost white
            [0.1, "rgb(229,245,224)"],      # Very pale green
            [0.2, "rgb(199,233,192)"],      # Pale green
            [0.3, "rgb(161,217,155)"],      # Light green
            [0.4, "rgb(116,196,118)"],      # Medium light green
            [0.5, "rgb(65,171,93)"],        # Green
            [0.6, "rgb(35,139,69)"],        # Forest green
            [0.7, "rgb(0,109,44)"],         # Deep green
            [0.8, "rgb(0,87,35)"],          # Dark forest green
            [0.9, "rgb(0,60,24)"],          # Very dark green
            [1.0, "rgb(0,40,16)"],          # Nearly black green
        ]
        colorscale2 = [
            [0.0, "rgb(255,255,255)"],
            [0.001, "rgb(247,252,245)"],
            [0.067, "rgb(229,245,224)"],
            [0.133, "rgb(199,233,192)"],
            [0.2, "rgb(161,217,155)"],
            [0.267, "rgb(116,196,118)"],
            [0.333, "rgb(65,171,93)"],
            [0.4, "rgb(35,139,69)"],
            [0.467, "rgb(0,109,44)"],
            [0.533, "rgb(0,87,35)"],
            [0.6, "rgb(0,60,24)"],
            [0.667, "rgb(0,40,16)"],        # Nearly black green at 100%
            [0.8, "rgb(0,25,10)"],          # Even darker green for >100%
            [1.0, "rgb(0,12,5)"],           # Almost pure black for >130%
        ]
    
    else:
        # Default to viridis if unknown style
        return get_color_palette('viridis')
    
    return colorscale, colorscale2


def build_stage2_html_report(length_stats_file, paralog_stats_file, output_dir, color_style='viridis'):
    """
    Build interactive HTML report using plotly
    
    Args:
        length_stats_file: Path to length_stats.tsv file
        output_dir: Output directory for HTML report
        color_style: Color palette style ('viridis', 'purple', 'blue', 'green')
    
    Note:
        Plotly rendering is single-threaded by design. The --threads parameter
        is used for data processing (file reading) but cannot accelerate plotly's
        figure creation, which is CPU-bound and single-threaded.
    """
    import time
    import numpy as np
    start = time.time()
    
    logger.info("[6] Generating interactive HTML report...")
    
    # Load data from length_stats.tsv
    df = pd.read_csv(length_stats_file, sep='\t')
    
    # Initialize figs list (skip original and filtered individual heatmaps)
    figs = []
    
    ### Sequence Length Distribution Heatmap ###
    # Create one heatmap with Original and Filtered rows for each sample
    df_len = df.copy()
    
    # Capitalize type for display
    df_len['type_display'] = df_len['type'].str.capitalize()
    
    # Get unique loci sorted
    loci_sorted = sorted(df_len['locus'].unique(), key=natural_sort_key)
    
    # Create pivot tables for fast lookup (PERFORMANCE OPTIMIZATION)
    pivot_coverage = df_len.pivot_table(
        index=['sample_name', 'type_display'], 
        columns='locus', 
        values='length_coverage',
        fill_value=0
    )
    pivot_length = df_len.pivot_table(
        index=['sample_name', 'type_display'], 
        columns='locus', 
        values='length',
        fill_value=0
    )
    
    # Ensure loci are in sorted order
    pivot_coverage = pivot_coverage.reindex(columns=loci_sorted, fill_value=0)
    pivot_length = pivot_length.reindex(columns=loci_sorted, fill_value=0)
    
    # Get sorted samples (default: alphabetical)
    samples_unique = sorted(df_len['sample_name'].unique())
    
    # Helper function to build heatmap data for a given sample order
    def build_heatmap_data(sample_order, group_by_type=False, filter_type=None):
        """
        Build heatmap data with flexible display modes.
        
        Args:
            sample_order: List of sample names in desired order
            group_by_type: If True, group all Original together, then all Filtered
            filter_type: None (show both), 'Original' (only Original), or 'Filtered' (only Filtered)
        """
        z_vals = []
        y_labels_samp = []
        y_labels_typ = []
        hover_txts = []
        reverse_hierarchy = False  # Flag to indicate if Y-axis hierarchy should be reversed
        
        # Determine which types to display
        if filter_type:
            types_to_show = [filter_type]
        else:
            types_to_show = ['Original', 'Filtered']
        
        if group_by_type:
            # Group by type: all Original first, then all Filtered
            # Y-axis hierarchy reversed: Type (outer) -> Sample (inner)
            reverse_hierarchy = True
            for data_type in types_to_show:  # Only show selected types
                for sample in sample_order:
                    # Direct lookup from pivot table (much faster than filtering)
                    if (sample, data_type) in pivot_coverage.index:
                        row_coverage = pivot_coverage.loc[(sample, data_type), :].values.tolist()
                        row_length = pivot_length.loc[(sample, data_type), :].values.tolist()
                    else:
                        # If combination doesn't exist, fill with zeros
                        row_coverage = [0] * len(loci_sorted)
                        row_length = [0] * len(loci_sorted)
                    
                    # Build hover text for this row
                    row_hover = []
                    for i, locus in enumerate(loci_sorted):
                        coverage_val = row_coverage[i]
                        length_val = row_length[i]
                        hover_text = f"<b>{sample}</b><br>Type: <b>{data_type}</b><br>Locus: <b>{locus}</b><br>Length: <b>{length_val:.0f} bp</b><br>Coverage: <b>{coverage_val:.2f}%</b>"
                        row_hover.append(hover_text)
                    
                    z_vals.append(row_coverage)
                    # For group_by_type: Type is outer, Sample is inner
                    y_labels_typ.append(data_type)
                    y_labels_samp.append(sample)
                    hover_txts.append(row_hover)
        else:
            # Normal: Original and Filtered paired for each sample
            # Y-axis hierarchy normal: Sample (outer) -> Type (inner)
            for sample in sample_order:
                for data_type in types_to_show:  # Only show selected types
                    # Direct lookup from pivot table (much faster than filtering)
                    if (sample, data_type) in pivot_coverage.index:
                        row_coverage = pivot_coverage.loc[(sample, data_type), :].values.tolist()
                        row_length = pivot_length.loc[(sample, data_type), :].values.tolist()
                    else:
                        # If combination doesn't exist, fill with zeros
                        row_coverage = [0] * len(loci_sorted)
                        row_length = [0] * len(loci_sorted)
                    
                    # Build hover text for this row
                    row_hover = []
                    for i, locus in enumerate(loci_sorted):
                        coverage_val = row_coverage[i]
                        length_val = row_length[i]
                        hover_text = f"<b>{sample}</b><br>Type: <b>{data_type}</b><br>Locus: <b>{locus}</b><br>Length: <b>{length_val:.0f} bp</b><br>Coverage: <b>{coverage_val:.2f}%</b>"
                        row_hover.append(hover_text)
                    
                    z_vals.append(row_coverage)
                    # For normal: Sample is outer, Type is inner
                    y_labels_samp.append(sample)
                    y_labels_typ.append(data_type)
                    hover_txts.append(row_hover)
        
        return z_vals, y_labels_samp, y_labels_typ, hover_txts, reverse_hierarchy
    
    # Build initial data (alphabetical order)
    z_values, y_labels_sample, y_labels_type, hover_texts, _ = build_heatmap_data(samples_unique)
    
    # Debug: Verify data structure
    logger.debug(f"Number of samples: {len(samples_unique)}")
    logger.debug(f"Number of rows in heatmap: {len(z_values)}")
    logger.debug(f"Length of y_labels_sample: {len(y_labels_sample)}")
    logger.debug(f"Length of y_labels_type: {len(y_labels_type)}")
    logger.debug(f"First 6 y_labels_sample: {y_labels_sample[:6]}")
    logger.debug(f"First 6 y_labels_type: {y_labels_type[:6]}")
    
    # Calculate sample-level statistics for sorting (only based on Filtered data)
    # For paired display, we sort samples based on Filtered data only
    sample_stats = {}
    for sample in samples_unique:
        # Only use Filtered data for sorting
        if (sample, 'Filtered') in pivot_coverage.index:
            row_vals = pivot_coverage.loc[(sample, 'Filtered'), :].values
            coverages = [v for v in row_vals if v > 0]  # Only non-zero values
        else:
            coverages = []
        
        # Calculate statistics based on Filtered data
        sample_stats[sample] = {
            'mean': np.mean(coverages) if coverages else 0,
            'count': len(coverages),
            'total': sum(coverages) if coverages else 0
        }
    
    # Pre-compute different sorting orders (for Sort by Value dropdown)
    sorted_orders = {
        'none': samples_unique,  # Alphabetical by default
    }
    
    # Pre-compute visual modes (for Visual Mode dropdown)
    visual_modes = {
        'both_paired': {'group_by_type': False, 'filter_type': None},       # Both (paired)
        'group_by_type': {'group_by_type': True, 'filter_type': None},      # Group by Type
        'only_original': {'group_by_type': False, 'filter_type': 'Original'}, # Only Original
        'only_filtered': {'group_by_type': False, 'filter_type': 'Filtered'}, # Only Filtered
    }
    
    # Get color palette
    colorscale, colorscale2 = get_color_palette(color_style)
    
    # Determine which colorscale to use
    max_coverage = max([max(row) for row in z_values])
    if max_coverage <= 100:
        cmap = colorscale
        zmax = 100
    else:
        cmap = colorscale2
        zmax = min(max_coverage, 150)
    
    # Create figure
    fig_len = go.Figure()
    
    # Add heatmap with hierarchical Y-axis
    fig_len.add_trace(
        go.Heatmap(
            x=loci_sorted,
            y=[y_labels_sample, y_labels_type],  # Hierarchical: [sample_name, type]
            z=z_values,
            text=hover_texts,
            colorscale=cmap,
            zmin=0,
            zmax=zmax,
            colorbar=dict(
                title="Coverage (%)",
                ticks="outside",
                ticksuffix="%",
                outlinecolor="rgb(8,8,8)",
                outlinewidth=1,
            ),
            hovertemplate="%{text}<extra></extra>",
            hoverongaps=False,
            xgap=0.5,
            ygap=0.5,
        )
    )
    
    # Calculate initial bar chart data (Both mode: separate Original and Filtered)
    # Top bars: recovery count per locus
    bar_top_orig = []
    bar_top_filt = []
    for locus in loci_sorted:
        if locus in pivot_coverage.columns:
            count_orig = sum(1 for idx in pivot_coverage.index 
                            if 'Original' in str(idx) and pivot_coverage.loc[idx, locus] > 0)
            count_filt = sum(1 for idx in pivot_coverage.index 
                            if 'Filtered' in str(idx) and pivot_coverage.loc[idx, locus] > 0)
        else:
            count_orig = count_filt = 0
        bar_top_orig.append(count_orig)
        bar_top_filt.append(count_filt)
    
    # Right bars: recovery count per sample-type row
    bar_right_orig = []
    bar_right_filt = []
    for sample, dtype in zip(y_labels_sample, y_labels_type):
        if (sample, dtype) in pivot_coverage.index:
            count = (pivot_coverage.loc[(sample, dtype), :] > 0).sum()
        else:
            count = 0
        
        if dtype == 'Original':
            bar_right_orig.append(count)
            bar_right_filt.append(0)
        else:
            bar_right_orig.append(0)
            bar_right_filt.append(count)
    
    # Custom hover text for top bars showing absolute values
    bar_top_filt_abs = bar_top_filt  # Store original values for hover
    hover_text_orig = [f"<b>Locus:</b> {locus}<br><b>Type:</b> Original<br><b>Samples recovered:</b> {count}" 
                       for locus, count in zip(loci_sorted, bar_top_orig)]
    hover_text_filt = [f"<b>Locus:</b> {locus}<br><b>Type:</b> Filtered<br><b>Samples recovered:</b> {count}" 
                       for locus, count in zip(loci_sorted, bar_top_filt_abs)]
    
    # Get color scheme based on user selection
    COLOR_ORIGINAL, COLOR_FILTERED = get_bar_colors(color_style)
    
    # Add top bar charts - Original (trace 1) - displayed in upper half
    fig_len.add_trace(
        go.Bar(
            x=loci_sorted,
            y=bar_top_orig,
            yaxis="y2",
            name="Original",
            marker=dict(color=COLOR_ORIGINAL, line=dict(color="rgb(8,8,8)", width=0.5)),
            showlegend=False,
            base=0,  # Start from baseline
            customdata=hover_text_orig,
            hovertemplate="%{customdata}<extra></extra>",
            textposition="none",  # Don't show text on bars
        )
    )
    
    # Add top bar charts - Filtered (trace 2) - displayed in lower half (negative direction)
    fig_len.add_trace(
        go.Bar(
            x=loci_sorted,
            y=[-y for y in bar_top_filt],  # Negative values to display below
            yaxis="y2",
            name="Filtered",
            marker=dict(color=COLOR_FILTERED, line=dict(color="rgb(8,8,8)", width=0.5)),
            showlegend=False,
            base=0,  # Start from baseline
            customdata=hover_text_filt,
            hovertemplate="%{customdata}<extra></extra>",
            textposition="none",  # Don't show text on bars
        )
    )
    
    # Add right bar charts - Original (trace 3)
    fig_len.add_trace(
        go.Bar(
            x=bar_right_orig,
            y=[y_labels_sample, y_labels_type],
            xaxis="x2",
            name="Original",
            orientation="h",
            marker=dict(color=COLOR_ORIGINAL, line=dict(color="rgb(8,8,8)", width=0.5)),
            showlegend=False,
            textposition="none",  # Don't show text on bars
        )
    )
    
    # Add right bar charts - Filtered (trace 4)
    fig_len.add_trace(
        go.Bar(
            x=bar_right_filt,
            y=[y_labels_sample, y_labels_type],
            xaxis="x2",
            name="Filtered",
            orientation="h",
            marker=dict(color=COLOR_FILTERED, line=dict(color="rgb(8,8,8)", width=0.5)),
            showlegend=False,
            textposition="none",  # Don't show text on bars
        )
    )
    
    # Helper function to create button data (optimized version)
    def create_button_data(sample_order, group_by_type_flag, filter_type_value, sort_order='category descending', bar_color_style='viridis'):
        """Create button args for a specific configuration.
        
        Args:
            sample_order: List of sample names in desired order
            group_by_type_flag: Whether to group by type
            filter_type_value: Filter to show only Original or Filtered
            sort_order: X-axis category order for loci sorting
            bar_color_style: Color style for bar charts
        """
        # Get bar colors based on color style
        color_orig, color_filt = get_bar_colors(bar_color_style)
        
        z_data, y_samp, y_type, hover, reverse_h = build_heatmap_data(
            sample_order, 
            group_by_type=group_by_type_flag, 
            filter_type=filter_type_value
        )
        
        # Calculate appropriate height based on mode
        # In Only mode, show half height to match row height of Both mode
        if filter_type_value:  # Only Original or Only Filtered
            num_rows = len(sample_order)  # One row per sample
            plot_height = max(400, 180 + 15 * num_rows)  # Half height per row
        elif group_by_type_flag:  # Group by Type
            num_rows = len(sample_order) * 2  # Two rows per sample
            plot_height = max(400, 180 + 15 * num_rows)
        else:  # Both (paired)
            num_rows = len(sample_order) * 2  # Two rows per sample
            plot_height = max(400, 180 + 15 * num_rows)
        
        # Determine Y-axis hierarchy
        if reverse_h:
            y_hierarchy = [y_type, y_samp]
            yaxis_title = "Type - Sample"
            num_samples = len(sample_order)
            divider_y = num_samples - 0.5
            shapes = [dict(type="line", xref="paper", yref="y", x0=0, y0=divider_y, 
                          x1=1, y1=divider_y, line=dict(color="red", width=3, dash="solid"))]
        else:
            y_hierarchy = [y_samp, y_type]
            yaxis_title = "Sample - Type"
            shapes = []
        
        # Calculate bar chart data (optimized)
        if filter_type_value:
            # Only Original or Only Filtered mode - use single color
            dtype = filter_type_value
            # Top bars
            bar_top_data = [sum(1 for s in sample_order 
                               if (s, dtype) in pivot_coverage.index 
                               and pivot_coverage.loc[(s, dtype), locus] > 0) 
                           for locus in loci_sorted]
            
            # Determine bar colors based on filter type
            if dtype == 'Filtered':
                # Use color for Filtered only - display upward like Original
                bar_top_orig = bar_top_data  # Positive values for upward display
                bar_top_filt = [0] * len(loci_sorted)
                top_color_orig = color_filt  # Use filtered color
                top_color_filt = color_filt  # Use filtered color
            else:
                # Use color for Original only
                bar_top_orig = bar_top_data
                bar_top_filt = [0] * len(loci_sorted)
                top_color_orig = color_orig  # Use original color
                top_color_filt = color_orig  # Not used but keep consistent
            
            # Right bars
            bar_right_orig = []
            bar_right_filt = []
            for s, t in zip(y_samp, y_type):
                count = sum(1 for locus in loci_sorted 
                           if (s, t) in pivot_coverage.index 
                           and pivot_coverage.loc[(s, t), locus] > 0)
                bar_right_orig.append(count if dtype == 'Original' else 0)
                bar_right_filt.append(count if dtype == 'Filtered' else 0)
        else:
            # Both modes - show both colors
            # Top bars
            bar_top_orig = [sum(1 for s in sample_order 
                               if (s, 'Original') in pivot_coverage.index 
                               and pivot_coverage.loc[(s, 'Original'), locus] > 0) 
                           for locus in loci_sorted]
            bar_top_filt_raw = [sum(1 for s in sample_order 
                               if (s, 'Filtered') in pivot_coverage.index 
                               and pivot_coverage.loc[(s, 'Filtered'), locus] > 0) 
                           for locus in loci_sorted]
            bar_top_filt = [-x for x in bar_top_filt_raw]  # Negative for display below
            
            top_color_orig = color_orig  # Use original color from color style
            top_color_filt = color_filt  # Use filtered color from color style
            
            # Right bars
            bar_right_orig = []
            bar_right_filt = []
            for s, t in zip(y_samp, y_type):
                count = sum(1 for locus in loci_sorted 
                           if (s, t) in pivot_coverage.index 
                           and pivot_coverage.loc[(s, t), locus] > 0)
                if t == 'Original':
                    bar_right_orig.append(count)
                    bar_right_filt.append(0)
                else:
                    bar_right_orig.append(0)
                    bar_right_filt.append(count)
        
        # Create hover text for bar charts
        hover_text_top_orig = [f"<b>Locus:</b> {locus}<br><b>Type:</b> Original<br><b>Samples recovered:</b> {count}" 
                               for locus, count in zip(loci_sorted, bar_top_orig)]
        # For filtered bars, get absolute values
        bar_top_filt_abs = [-y if y < 0 else y for y in bar_top_filt]
        hover_text_top_filt = [f"<b>Locus:</b> {locus}<br><b>Type:</b> Filtered<br><b>Samples recovered:</b> {abs(count)}" 
                               for locus, count in zip(loci_sorted, bar_top_filt)]
        
        # Calculate tick values for y-axis to show only 0 and max values
        max_bar_value = max(bar_top_orig) if bar_top_orig else 10
        min_bar_value = min(bar_top_filt) if bar_top_filt else -10
        
        # Only show 0 and max values
        tick_vals = [0]
        tick_texts = ['0']
        
        # Add max positive value (Original - upper half)
        if max_bar_value > 0:
            tick_vals.append(max_bar_value)
            tick_texts.append(str(max_bar_value))
        
        # Add max negative value (Filtered - lower half, but show as positive)
        if min_bar_value < 0:
            tick_vals.append(min_bar_value)
            tick_texts.append(str(abs(min_bar_value)))
        
        # Calculate fixed height for top bar chart
        TOP_BAR_HEIGHT = 100
        top_bar_domain_start = 1 - (TOP_BAR_HEIGHT / plot_height)
        main_heatmap_domain_end = top_bar_domain_start - 0.005  # Small gap
        
        # Return dict with trace indices matching: [0:heatmap, 1:top_orig, 2:top_filt, 3:right_orig, 4:right_filt]
        return {
            "trace_update": {
                "y": [y_hierarchy, bar_top_orig, bar_top_filt, y_hierarchy, y_hierarchy],
                "x": [loci_sorted, loci_sorted, loci_sorted, bar_right_orig, bar_right_filt],
                "z": [z_data],
                "text": [hover, hover_text_top_orig, hover_text_top_filt, None, None],
                "marker.color": [None, top_color_orig, top_color_filt, top_color_orig, top_color_filt],
            },
            "layout_update": {
                "xaxis": {"title": "Locus", "type": "category", "categoryorder": sort_order,
                         "linecolor": "black", "ticks": "outside", "gridcolor": "rgb(64,64,64)", 
                         "domain": [0, 0.95]},
                "yaxis": {"title": yaxis_title, "autorange": "reversed", "linecolor": "black",
                         "ticks": "outside", "dtick": 1, "tickson": "labels", "showdividers": False,
                         "gridcolor": "rgb(64,64,64)", "domain": [0, main_heatmap_domain_end]},
                "xaxis2": {"title": "Loci", "gridcolor": "rgb(64,64,64)", "ticks": "outside",
                          "zeroline": True, "domain": [0.95, 1]},
                "yaxis2": {"title": "Samples", "gridcolor": "rgb(64,64,64)", "ticks": "outside",
                          "zeroline": True, "domain": [top_bar_domain_start, 1], "showticklabels": True,
                          "tickmode": "array", "tickvals": tick_vals, "ticktext": tick_texts},
                "barmode": "relative",
                "shapes": shapes,
                "height": plot_height
            }
        }
    
    # Create Sort by Value buttons that work with all Visual Modes
    # We need to create buttons that can handle all visual mode combinations
    
    # Store current visual mode state (default: both_paired)
    # Since plotly buttons are static, we'll create buttons for each visual mode
    
    # Helper to create sort buttons for a specific visual mode
    def create_sort_buttons_for_mode(mode_config):
        """Create sort buttons that maintain the given visual mode"""
        buttons = []
        sort_configs = [
            ('none', 'None', 'category descending'),
            ('total_x', 'Total X', 'total descending'),
            ('total_y', 'Total Y', 'category descending'),
            ('total_both', 'Total Both', 'total descending'),
        ]
        
        for sort_name, sort_label, locus_order in sort_configs:
            # Determine sample order based on sort type
            if 'y' in sort_name.lower() or 'both' in sort_name.lower():
                # Sort samples by total of Filtered data (higher recovery first)
                if 'total' in sort_name:
                    sample_order = sorted(samples_unique, key=lambda s: sample_stats[s]['total'], reverse=True)
                else:
                    sample_order = samples_unique
            else:
                # Keep alphabetical order
                sample_order = samples_unique
            
            # Use the provided visual mode config
            button_data = create_button_data(
                sample_order, 
                mode_config['group_by_type'], 
                mode_config['filter_type'], 
                locus_order,
                color_style
            )
            
            buttons.append(
                dict(
                    label=sort_label,
                    method="update",
                    args=[button_data["trace_update"], button_data["layout_update"]],
                )
            )
        return buttons
    
    # Create default sort buttons for Both(paired) mode
    buttons_sort_value = create_sort_buttons_for_mode({'group_by_type': False, 'filter_type': None})
    
    # Pre-create sort buttons for each visual mode
    sort_buttons_by_mode = {}
    for mode_name, mode_config in visual_modes.items():
        sort_buttons_by_mode[mode_name] = create_sort_buttons_for_mode(mode_config)
    
    # Create Visual Mode buttons that also update the Sort by Value dropdown
    buttons_visual_mode = []
    for idx, (mode_name, mode_label) in enumerate([
        ('both_paired', 'Both (Paired)'),
        ('group_by_type', 'Group by Type'),
        ('only_original', 'Only Original'),
        ('only_filtered', 'Only Filtered'),
    ]):
        mode_config = visual_modes[mode_name]
        # Use current sample order (default: alphabetical) and default sort order
        button_data = create_button_data(
            samples_unique, 
            mode_config['group_by_type'], 
            mode_config['filter_type'],
            'category descending',
            color_style
        )
        
        # Update both the traces/layout AND the sort dropdown buttons
        layout_update = button_data["layout_update"].copy()
        layout_update["updatemenus[1].buttons"] = sort_buttons_by_mode[mode_name]
        
        buttons_visual_mode.append(
            dict(
                label=mode_label,
                method="update",
                args=[button_data["trace_update"], layout_update],
            )
        )
    
    # Create two separate dropdown menus with clear positioning
    updatemenus_len = [
        # Visual Mode dropdown (left)
        dict(
            buttons=buttons_visual_mode,
            type="dropdown",
            direction="down",
            pad={"t": 10, "b": 10},  # Minimal left padding
            showactive=True,
            x=0.75,  # Fixed position
            xanchor="right",
            y=1.0,  # Fixed vertical position
            yanchor="bottom",
        ),
        # Sort by Value dropdown (right)
        dict(
            buttons=buttons_sort_value,
            type="dropdown",
            direction="down",
            pad={"t": 10, "b": 10},
            showactive=True,
            x=0.95,  # Fixed position
            xanchor="right",
            y=1.0,  # Fixed vertical position
            yanchor="bottom",
        ),
    ]
    
    # Create annotations for both dropdowns (labels on the left side)
    annotations_len = [
        # Annotation for Visual Mode (left of dropdown)
        dict(
            text="<b>Visual Mode:</b>",
            x=0.75,  # Fixed position at left
            xref="paper",
            xanchor="right",
            xshift=-130,
            y=1.0,
            yref="paper",
            yanchor="top",
            yshift=36,  # Small vertical offset
            align="left",
            showarrow=False,
        ),
        # Annotation for Sort by Value (left of dropdown)
        dict(
            text="<b>Sort by Value:</b>",
            x=0.95,
            xref="paper",
            xanchor="right",
            xshift=-102,
            y=1,
            yref="paper",
            yanchor="top",
            yshift=36,
            align="right",
            showarrow=False,
        ),
    ]
    
    # Update layout
    title_text = "<b>1. Sequence Length Distribution (Original vs Filtered)</b><br><sup>Comparison of sequence length for each sample before and after filtering (colored by coverage %)</sup>"
    
    num_samples = len(samples_unique)
    
    # Fixed height for top bar chart (in pixels)
    TOP_BAR_HEIGHT = 100
    total_height = max(400, 180 + 30 * num_samples)
    # Calculate domain to ensure top bar has fixed pixel height
    top_bar_domain_start = 1 - (TOP_BAR_HEIGHT / total_height)
    main_heatmap_domain_end = top_bar_domain_start - 0.005  # Small gap between heatmap and bar
    
    fig_len.update_layout(
        font_family="Arial",
        plot_bgcolor="rgb(8,8,8)",
        title=title_text,
        xaxis=dict(
            title="Locus",
            type="category",
            categoryorder="category descending",
            linecolor="black",
            ticks="outside",
            gridcolor="rgb(64,64,64)",
            domain=[0, 0.95],  # Wider heatmap, consistent with figures 1 and 2
        ),
        yaxis=dict(
            title="Sample - Type",
            autorange="reversed",
            linecolor="black",
            ticks="outside",
            dtick=1,
            tickson="labels",
            showdividers=False,
            gridcolor="rgb(64,64,64)",
            domain=[0, main_heatmap_domain_end],  # Adjust based on fixed top bar height
        ),
        xaxis2=dict(
            title="Loci",
            gridcolor="rgb(64,64,64)",
            ticks="outside",
            zeroline=True,
            domain=[0.95, 1],  # Narrower right bar
        ),
        yaxis2=dict(
            title="Samples",
            gridcolor="rgb(64,64,64)",
            ticks="outside",
            zeroline=True,
            domain=[top_bar_domain_start, 1],  # Fixed height top bar
            # Show tick labels with absolute values
            showticklabels=True,
        ),
        hoverlabel=dict(
            font_color="#FFFFFF",
            bordercolor="#FFFFFF",
            bgcolor="#444444",
        ),
        barmode="relative",  # Relative mode to allow bars on both sides of zero
        bargap=0,
        height=total_height,
        updatemenus=updatemenus_len,
        annotations=annotations_len,
    )
    
    # Post-process to set y-axis ticks showing only 0 and max values
    # Calculate max value for bar chart to set appropriate tick range
    max_bar_value = max(bar_top_orig) if bar_top_orig else 10
    min_bar_value = min([-y for y in bar_top_filt]) if bar_top_filt else -10
    
    # Only show 0 and max values
    tick_vals = [0]
    tick_texts = ['0']
    
    # Add max positive value (Original - upper half)
    if max_bar_value > 0:
        tick_vals.append(max_bar_value)
        tick_texts.append(str(max_bar_value))
    
    # Add max negative value (Filtered - lower half, but show as positive)
    if min_bar_value < 0:
        tick_vals.append(min_bar_value)
        tick_texts.append(str(abs(min_bar_value)))
    
    fig_len.update_layout(
        yaxis2=dict(
            tickmode="array",
            tickvals=tick_vals,
            ticktext=tick_texts,
        )
    )
    
    figs.append(fig_len)
    
    ### Length Coverage Scatter Plots (Original vs Filtered) ###
    # Create subplot figure with two scatter plots side by side
    fig_scatter = make_subplots(
        rows=1, cols=2,
        subplot_titles=("<b>Original Sequences</b>", "<b>Filtered Sequences</b>"),
        horizontal_spacing=0.05  # Reduced spacing between subplots
    )
    
    # Get color palette
    colorscale, colorscale2 = get_color_palette(color_style)
    
    # Process data for both types
    for idx, data_type in enumerate(['original', 'filtered'], start=1):
        df_scatter = df[df['type'] == data_type].copy()
        
        # Remove zero coverage records for cleaner visualization
        df_scatter = df_scatter[df_scatter['length_coverage'] > 0]
        
        # Add jitter to x-axis for better visualization (use index as x)
        df_scatter = df_scatter.reset_index(drop=True)
        x_values = df_scatter.index
        y_values = df_scatter['length_coverage'].values
        
        # Determine colorscale
        max_coverage = y_values.max() if len(y_values) > 0 else 100
        if max_coverage <= 100:
            cmap = colorscale
        else:
            cmap = colorscale2
        
        # Create hover text
        hover_text = [
            f"<b>{row['sample_name']}</b><br>Locus: <b>{row['locus']}</b><br>Coverage: <b>{row['length_coverage']:.2f}%</b><br>Length: <b>{row['length']:.0f} bp</b>"
            for _, row in df_scatter.iterrows()
        ]
        
        # Add scatter trace
        fig_scatter.add_trace(
            go.Scatter(
                x=x_values,
                y=y_values,
                mode='markers',
                marker=dict(
                    size=5,  # Slightly larger for better visibility on white background
                    color=y_values,
                    colorscale=cmap,
                    cmin=0,
                    cmax=min(max_coverage, 150) if max_coverage > 100 else 100,
                    colorbar=dict(
                        title="Coverage (%)",
                        ticks="outside",
                        ticksuffix="%",
                        outlinecolor="rgb(150,150,150)",  # Lighter outline for white background
                        outlinewidth=1,
                        x=1.02 if idx == 2 else -0.02,
                        xanchor="left" if idx == 2 else "right",
                        len=0.9,
                    ) if idx == 2 else None,  # Only show colorbar on right plot
                    line=dict(width=0.3, color='rgba(100,100,100,0.3)'),  # Subtle gray border
                    opacity=0.8,  # Slightly more opaque for better visibility
                ),
                text=hover_text,
                hovertemplate="%{text}<extra></extra>",
                showlegend=False,
            ),
            row=1, col=idx
        )
        
        # Update axes for this subplot
        fig_scatter.update_xaxes(
            title="Sample (ranked by appearance)" if idx == 1 else "Sample (ranked by appearance)",
            gridcolor="rgb(220,220,220)",  # Light gray grid for white background
            ticks="outside",
            showticklabels=False,  # Hide tick labels as index numbers are not meaningful
            row=1, col=idx
        )
        fig_scatter.update_yaxes(
            title="Length Coverage (%)" if idx == 1 else "",
            gridcolor="rgb(220,220,220)",  # Light gray grid for white background
            ticks="outside",
            range=[0, min(max_coverage * 1.1, 160)],
            row=1, col=idx
        )
    
    # Update overall layout
    fig_scatter.update_layout(
        font_family="Arial",
        plot_bgcolor="white",  # White background for scatter plot
        paper_bgcolor="white",  # White background for entire figure
        title="<b>2. Length Coverage Distribution Scatter Plot</b><br><sup>Each point represents one sample-locus combination (only showing recovered sequences with coverage > 0%)</sup>",
        height=600,
        hoverlabel=dict(
            font_color="#000000",  # Black text for better readability on white background
            bordercolor="#333333",
            bgcolor="#FFFFFF",  # White background for hover labels
        ),
    )
    
    figs.append(fig_scatter)
    
    # Generate summary statistics table for each sample (both Original and Filtered)
    logger.info("[6.5] Generating sample statistics tables...")
    
    # Calculate statistics for Original data
    sample_stats_list_original = []
    for sample in sorted(samples_unique):
        # Get all original data for this sample
        sample_data = df[(df['sample_name'] == sample) & (df['type'] == 'original') & (df['length_coverage'] > 0)]
        
        if len(sample_data) > 0:
            recovered_loci_count = len(sample_data)
            avg_length = sample_data['length'].mean()
            median_length = sample_data['length'].median()
            avg_coverage = sample_data['length_coverage'].mean()
            median_coverage = sample_data['length_coverage'].median()
        else:
            recovered_loci_count = 0
            avg_length = 0
            median_length = 0
            avg_coverage = 0
            median_coverage = 0
        
        sample_stats_list_original.append({
            'Sample': sample,
            'Recovered_Loci': recovered_loci_count,
            'Avg_Length': avg_length,
            'Median_Length': median_length,
            'Avg_Coverage': avg_coverage,
            'Median_Coverage': median_coverage
        })
    
    # Calculate statistics for Filtered data
    sample_stats_list_filtered = []
    for sample in sorted(samples_unique):
        # Get all filtered data for this sample
        sample_data = df[(df['sample_name'] == sample) & (df['type'] == 'filtered') & (df['length_coverage'] > 0)]
        
        if len(sample_data) > 0:
            recovered_loci_count = len(sample_data)
            avg_length = sample_data['length'].mean()
            median_length = sample_data['length'].median()
            avg_coverage = sample_data['length_coverage'].mean()
            median_coverage = sample_data['length_coverage'].median()
        else:
            recovered_loci_count = 0
            avg_length = 0
            median_length = 0
            avg_coverage = 0
            median_coverage = 0
        
        sample_stats_list_filtered.append({
            'Sample': sample,
            'Recovered_Loci': recovered_loci_count,
            'Avg_Length': avg_length,
            'Median_Length': median_length,
            'Avg_Coverage': avg_coverage,
            'Median_Coverage': median_coverage
        })
    
    # Create DataFrames for statistics
    stats_df_original = pd.DataFrame(sample_stats_list_original)
    stats_df_filtered = pd.DataFrame(sample_stats_list_filtered)
    
    # Get header color based on color_style
    if color_style == 'viridis':
        header_color = "#E63946"  # Bright red
    elif color_style == 'purple':
        header_color = "#8B4FC1"  # Bright purple
    elif color_style == 'blue':
        header_color = "#4A90E2"  # Bright blue
    elif color_style == 'green':
        header_color = "rgb(116,196,118)"  # Bright green
    else:
        header_color = "rgb(116,196,118)"  # Default to green
    
    # Create plotly table for Original data
    fig_table_original = go.Figure()
    fig_table_original.add_trace(
        go.Table(
            header=dict(
                values=[
                    "<b>Sample</b>",
                    "<b>Recovered Loci</b>",
                    "<b>Mean Length (bp)</b>",
                    "<b>Median Length (bp)</b>",
                    "<b>Mean Coverage (%)</b>",
                    "<b>Median Coverage (%)</b>"
                ],
                fill_color=header_color,
                font=dict(color='white', size=12),
                align='left',
                height=30,
            ),
            cells=dict(
                values=[
                    stats_df_original['Sample'],
                    stats_df_original['Recovered_Loci'],
                    stats_df_original['Avg_Length'].round(2),
                    stats_df_original['Median_Length'].round(2),
                    stats_df_original['Avg_Coverage'].round(2),
                    stats_df_original['Median_Coverage'].round(2)
                ],
                fill_color='light grey',
                align='left',
                height=25,
                format=[None, None, ".2f", ".2f", ".2f", ".2f"],
            )
        )
    )
    
    fig_table_original.update_layout(
        font_family="Arial",
        title="<b>3. Sample Statistics Summary (Original Data)</b><br><sup>Statistics based on original sequences with coverage > 0%</sup>",
        height=max(400, 100 + 25 * len(stats_df_original)),
    )
    
    figs.append(fig_table_original)
    
    # Create plotly table for Filtered data
    fig_table_filtered = go.Figure()
    fig_table_filtered.add_trace(
        go.Table(
            header=dict(
                values=[
                    "<b>Sample</b>",
                    "<b>Recovered Loci</b>",
                    "<b>Mean Length (bp)</b>",
                    "<b>Median Length (bp)</b>",
                    "<b>Mean Coverage (%)</b>",
                    "<b>Median Coverage (%)</b>"
                ],
                fill_color=header_color,
                font=dict(color='white', size=12),
                align='left',
                height=30,
            ),
            cells=dict(
                values=[
                    stats_df_filtered['Sample'],
                    stats_df_filtered['Recovered_Loci'],
                    stats_df_filtered['Avg_Length'].round(2),
                    stats_df_filtered['Median_Length'].round(2),
                    stats_df_filtered['Avg_Coverage'].round(2),
                    stats_df_filtered['Median_Coverage'].round(2)
                ],
                fill_color='light grey',
                align='left',
                height=25,
                format=[None, None, ".2f", ".2f", ".2f", ".2f"],
            )
        )
    )
    
    fig_table_filtered.update_layout(
        font_family="Arial",
        title="<b>4. Sample Statistics Summary (Filtered Data)</b><br><sup>Statistics based on filtered sequences with coverage > 0%</sup>",
        height=max(400, 100 + 25 * len(stats_df_filtered)),
    )
    
    figs.append(fig_table_filtered)
    
    ### Paralog Statistics Section ###
    logger.info("[6.6] Generating paralog statistics figures...")
    
    # Load paralog data from paralog_stats.tsv
    df_paralog = pd.read_csv(paralog_stats_file, sep='\t')
    
    # Capitalize type for display
    df_paralog['type_display'] = df_paralog['type'].str.capitalize()
    
    # Get unique loci and samples sorted
    loci_sorted_paralog = sorted(df_paralog['locus'].unique(), key=natural_sort_key)
    samples_unique_paralog = sorted(df_paralog['sample_name'].unique())
    
    ### Paralog Count Heatmap ###
    # Create pivot tables for fast lookup
    pivot_paralog = df_paralog.pivot_table(
        index=['sample_name', 'type_display'], 
        columns='locus', 
        values='paralog_sequences',
        fill_value=0
    )
    
    # Ensure loci are in sorted order
    pivot_paralog = pivot_paralog.reindex(columns=loci_sorted_paralog, fill_value=0)
    
    # Helper function to build heatmap data for paralog
    def build_paralog_heatmap_data(sample_order):
        """Build heatmap data for paralog counts"""
        z_vals = []
        y_labels_samp = []
        y_labels_typ = []
        hover_txts = []
        
        types_to_show = ['Original', 'Filtered']
        
        for sample in sample_order:
            for data_type in types_to_show:
                # Direct lookup from pivot table
                if (sample, data_type) in pivot_paralog.index:
                    row_paralog = pivot_paralog.loc[(sample, data_type), :].values.tolist()
                else:
                    # If combination doesn't exist, fill with zeros
                    row_paralog = [0] * len(loci_sorted_paralog)
                
                # Build hover text for this row
                row_hover = []
                for i, locus in enumerate(loci_sorted_paralog):
                    paralog_val = row_paralog[i]
                    hover_text = f"<b>{sample}</b><br>Type: <b>{data_type}</b><br>Locus: <b>{locus}</b><br>Paralog Count: <b>{int(paralog_val)}</b>"
                    row_hover.append(hover_text)
                
                z_vals.append(row_paralog)
                y_labels_samp.append(sample)
                y_labels_typ.append(data_type)
                hover_txts.append(row_hover)
        
        return z_vals, y_labels_samp, y_labels_typ, hover_txts
    
    # Build initial data
    z_values_paralog, y_labels_sample_paralog, y_labels_type_paralog, hover_texts_paralog = build_paralog_heatmap_data(samples_unique_paralog)
    
    # Get color palette for paralog (use same as length coverage)
    colorscale_paralog, colorscale2_paralog = get_color_palette(color_style)
    
    # Determine colorscale for paralog
    max_paralog = max([max(row) if row else 0 for row in z_values_paralog])
    if max_paralog <= 10:
        cmap_paralog = colorscale_paralog
        zmax_paralog = 10
    else:
        cmap_paralog = colorscale2_paralog
        zmax_paralog = min(max_paralog, 15)
    
    # Calculate sample-level statistics for sorting (only based on Filtered data)
    sample_stats_paralog = {}
    for sample in samples_unique_paralog:
        # Only use Filtered data for sorting
        if (sample, 'Filtered') in pivot_paralog.index:
            row_vals = pivot_paralog.loc[(sample, 'Filtered'), :].values
            paralogs = [v for v in row_vals if v > 0]  # Only non-zero values
        else:
            paralogs = []
        
        # Calculate statistics based on Filtered data
        sample_stats_paralog[sample] = {
            'mean': np.mean(paralogs) if paralogs else 0,
            'count': len(paralogs),
            'total': sum(paralogs) if paralogs else 0
        }
    
    # Define visual modes for paralog heatmap
    visual_modes_paralog = {
        'both_paired': {'group_by_type': False, 'filter_type': None},  # Original and Filtered paired
        'group_by_type': {'group_by_type': True, 'filter_type': None},  # All Original, then all Filtered
        'only_original': {'group_by_type': False, 'filter_type': 'Original'},  # Show only Original
        'only_filtered': {'group_by_type': False, 'filter_type': 'Filtered'},  # Show only Filtered
    }
    
    # Function to create button data for paralog heatmap
    def create_button_data_paralog(sample_order, group_by_type, filter_type, sort_order, color_style):
        """Generate trace and layout updates for paralog heatmap visualization modes"""
        
        # Build data according to visual mode
        z_data = []
        y_hierarchy = [[], []]  # [sample_labels, type_labels]
        hover = []
        reverse_hierarchy = False  # Flag to indicate if Y-axis hierarchy should be reversed
        
        if group_by_type:
            # Group by Type: show all Original samples first, then all Filtered samples
            # Y-axis hierarchy reversed: Type (outer) -> Sample (inner)
            reverse_hierarchy = True
            for data_type in ['Original', 'Filtered']:
                for sample in sample_order:
                    if (sample, data_type) in pivot_paralog.index:
                        row_paralog = pivot_paralog.loc[(sample, data_type), :].values.tolist()
                    else:
                        row_paralog = [0] * len(loci_sorted_paralog)
                    
                    row_hover = []
                    for i, locus in enumerate(loci_sorted_paralog):
                        paralog_val = row_paralog[i]
                        hover_text = f"<b>{sample}</b><br>Type: <b>{data_type}</b><br>Locus: <b>{locus}</b><br>Paralog Count: <b>{int(paralog_val)}</b>"
                        row_hover.append(hover_text)
                    
                    z_data.append(row_paralog)
                    # For group_by_type: Type is outer (index 0), Sample is inner (index 1)
                    y_hierarchy[0].append(data_type)
                    y_hierarchy[1].append(sample)
                    hover.append(row_hover)
            yaxis_title = "Type - Sample"
        
        elif filter_type is not None:
            # Show only one type (Original or Filtered)
            for sample in sample_order:
                if (sample, filter_type) in pivot_paralog.index:
                    row_paralog = pivot_paralog.loc[(sample, filter_type), :].values.tolist()
                else:
                    row_paralog = [0] * len(loci_sorted_paralog)
                
                row_hover = []
                for i, locus in enumerate(loci_sorted_paralog):
                    paralog_val = row_paralog[i]
                    hover_text = f"<b>{sample}</b><br>Type: <b>{filter_type}</b><br>Locus: <b>{locus}</b><br>Paralog Count: <b>{int(paralog_val)}</b>"
                    row_hover.append(hover_text)
                
                z_data.append(row_paralog)
                y_hierarchy[0].append(sample)
                y_hierarchy[1].append(filter_type)
                hover.append(row_hover)
            yaxis_title = f"Sample ({filter_type})"
        
        else:
            # Both (Paired): Original and Filtered for each sample, paired together
            for sample in sample_order:
                for data_type in ['Original', 'Filtered']:
                    if (sample, data_type) in pivot_paralog.index:
                        row_paralog = pivot_paralog.loc[(sample, data_type), :].values.tolist()
                    else:
                        row_paralog = [0] * len(loci_sorted_paralog)
                    
                    row_hover = []
                    for i, locus in enumerate(loci_sorted_paralog):
                        paralog_val = row_paralog[i]
                        hover_text = f"<b>{sample}</b><br>Type: <b>{data_type}</b><br>Locus: <b>{locus}</b><br>Paralog Count: <b>{int(paralog_val)}</b>"
                        row_hover.append(hover_text)
                    
                    z_data.append(row_paralog)
                    y_hierarchy[0].append(sample)
                    y_hierarchy[1].append(data_type)
                    hover.append(row_hover)
            yaxis_title = "Sample - Type"
        
        # Get color scheme first (needed for bar colors)
        COLOR_ORIGINAL, COLOR_FILTERED = get_bar_colors(color_style)
        
        # Calculate bar chart data for paralog
        bar_top_orig_paralog = []
        bar_top_filt_paralog = []
        
        if filter_type is not None:
            # Only Original or Only Filtered mode - use single color
            dtype = filter_type
            # Top bars - only count samples of the selected type
            bar_top_data = [sum(1 for s in sample_order 
                               if (s, dtype) in pivot_paralog.index 
                               and pivot_paralog.loc[(s, dtype), locus] > 0) 
                           for locus in loci_sorted_paralog]
            
            # Determine bar assignment based on filter type
            if dtype == 'Filtered':
                # Use bar_top_orig for display (upward) with Filtered color
                bar_top_orig_paralog = bar_top_data
                bar_top_filt_paralog = [0] * len(loci_sorted_paralog)
                top_color_orig_paralog = COLOR_FILTERED  # Use filtered color
                top_color_filt_paralog = COLOR_FILTERED  # Use filtered color
            else:
                # Use bar_top_orig for display (upward) with Original color
                bar_top_orig_paralog = bar_top_data
                bar_top_filt_paralog = [0] * len(loci_sorted_paralog)
                top_color_orig_paralog = COLOR_ORIGINAL  # Use original color
                top_color_filt_paralog = COLOR_ORIGINAL  # Not used but keep consistent
        else:
            # Both modes - show both colors
            for locus in loci_sorted_paralog:
                if locus in pivot_paralog.columns:
                    count_orig = sum(1 for idx in pivot_paralog.index 
                                    if 'Original' in str(idx) and pivot_paralog.loc[idx, locus] > 0)
                    count_filt = sum(1 for idx in pivot_paralog.index 
                                    if 'Filtered' in str(idx) and pivot_paralog.loc[idx, locus] > 0)
                else:
                    count_orig = count_filt = 0
                bar_top_orig_paralog.append(count_orig)
                bar_top_filt_paralog.append(-count_filt)  # Negative for display below axis
            
            top_color_orig_paralog = COLOR_ORIGINAL
            top_color_filt_paralog = COLOR_FILTERED
        
        # Create hover text for top bars
        hover_text_top_orig_paralog = [f"<b>Locus:</b> {locus}<br><b>Type:</b> {filter_type if filter_type else 'Original'}<br><b>Samples with paralogs:</b> {count}" 
                                       for locus, count in zip(loci_sorted_paralog, bar_top_orig_paralog)]
        hover_text_top_filt_paralog = [f"<b>Locus:</b> {locus}<br><b>Type:</b> Filtered<br><b>Samples with paralogs:</b> {abs(count)}" 
                                       for locus, count in zip(loci_sorted_paralog, bar_top_filt_paralog)]
        
        # Right bars for paralog
        bar_right_orig_paralog = []
        bar_right_filt_paralog = []
        
        if filter_type is not None:
            # Only Original or Only Filtered mode
            dtype = filter_type
            # Handle both normal and reversed hierarchy
            if reverse_hierarchy:
                # In group_by_type mode: y_hierarchy[0] is Type, y_hierarchy[1] is Sample
                for t, s in zip(y_hierarchy[0], y_hierarchy[1]):
                    count = sum(1 for locus in loci_sorted_paralog 
                               if (s, t) in pivot_paralog.index 
                               and pivot_paralog.loc[(s, t), locus] > 0)
                    bar_right_orig_paralog.append(count if dtype == 'Original' else 0)
                    bar_right_filt_paralog.append(count if dtype == 'Filtered' else 0)
            else:
                # In normal mode: y_hierarchy[0] is Sample, y_hierarchy[1] is Type
                for s, t in zip(y_hierarchy[0], y_hierarchy[1]):
                    count = sum(1 for locus in loci_sorted_paralog 
                               if (s, t) in pivot_paralog.index 
                               and pivot_paralog.loc[(s, t), locus] > 0)
                    bar_right_orig_paralog.append(count if dtype == 'Original' else 0)
                    bar_right_filt_paralog.append(count if dtype == 'Filtered' else 0)
        else:
            # Both modes - show both colors
            # Handle both normal and reversed hierarchy
            if reverse_hierarchy:
                # In group_by_type mode: y_hierarchy[0] is Type, y_hierarchy[1] is Sample
                for dtype, sample in zip(y_hierarchy[0], y_hierarchy[1]):
                    if (sample, dtype) in pivot_paralog.index:
                        count = (pivot_paralog.loc[(sample, dtype), :] > 0).sum()
                    else:
                        count = 0
                    
                    if dtype == 'Original':
                        bar_right_orig_paralog.append(count)
                        bar_right_filt_paralog.append(0)
                    else:
                        bar_right_orig_paralog.append(0)
                        bar_right_filt_paralog.append(count)
            else:
                # In normal mode: y_hierarchy[0] is Sample, y_hierarchy[1] is Type
                for sample, dtype in zip(y_hierarchy[0], y_hierarchy[1]):
                    if (sample, dtype) in pivot_paralog.index:
                        count = (pivot_paralog.loc[(sample, dtype), :] > 0).sum()
                    else:
                        count = 0
                    
                    if dtype == 'Original':
                        bar_right_orig_paralog.append(count)
                        bar_right_filt_paralog.append(0)
                    else:
                        bar_right_orig_paralog.append(0)
                        bar_right_filt_paralog.append(count)
        
        # Calculate fixed height for top bar chart
        num_samples_display = len(y_hierarchy[0])
        TOP_BAR_HEIGHT = 100
        total_height_paralog = max(400, 180 + 30 * len(sample_order) * (1 if filter_type else 2))
        top_bar_domain_start_paralog = 1 - (TOP_BAR_HEIGHT / total_height_paralog)
        main_heatmap_domain_end_paralog = top_bar_domain_start_paralog - 0.005
        
        # Calculate tick values for y-axis
        max_bar_value_paralog = max(bar_top_orig_paralog) if bar_top_orig_paralog else 10
        min_bar_value_paralog = min(bar_top_filt_paralog) if bar_top_filt_paralog else -10
        
        tick_vals_paralog = [0]
        tick_texts_paralog = ['0']
        
        if max_bar_value_paralog > 0:
            tick_vals_paralog.append(max_bar_value_paralog)
            tick_texts_paralog.append(str(max_bar_value_paralog))
        
        if min_bar_value_paralog < 0:
            tick_vals_paralog.append(min_bar_value_paralog)
            tick_texts_paralog.append(str(abs(min_bar_value_paralog)))
        
        # Add divider line for group_by_type mode
        if reverse_hierarchy:
            # Add red divider line between Original and Filtered groups
            num_samples = len(sample_order)
            divider_y = num_samples - 0.5  # Position divider between the two groups
            shapes = [dict(type="line", xref="paper", yref="y", x0=0, y0=divider_y, 
                          x1=1, y1=divider_y, line=dict(color="red", width=3, dash="solid"))]
        else:
            shapes = []
        
        # Return dict with trace indices matching: [0:heatmap, 1:top_orig, 2:top_filt, 3:right_orig, 4:right_filt]
        return {
            "trace_update": {
                "y": [y_hierarchy, bar_top_orig_paralog, bar_top_filt_paralog, y_hierarchy, y_hierarchy],
                "x": [loci_sorted_paralog, loci_sorted_paralog, loci_sorted_paralog, bar_right_orig_paralog, bar_right_filt_paralog],
                "z": [z_data],
                "text": [hover, None, None, None, None],
                "customdata": [None, hover_text_top_orig_paralog, hover_text_top_filt_paralog, None, None],
                "marker.color": [None, top_color_orig_paralog, top_color_filt_paralog, top_color_orig_paralog, top_color_filt_paralog],
            },
            "layout_update": {
                "xaxis": {"title": "Locus", "type": "category", "categoryorder": sort_order,
                         "linecolor": "black", "ticks": "outside", "gridcolor": "rgb(64,64,64)", 
                         "domain": [0, 0.95]},
                "yaxis": {"title": yaxis_title, "autorange": "reversed", "linecolor": "black",
                         "ticks": "outside", "dtick": 1, "tickson": "labels", "showdividers": False,
                         "gridcolor": "rgb(64,64,64)", "domain": [0, main_heatmap_domain_end_paralog]},
                "xaxis2": {"title": "Loci", "gridcolor": "rgb(64,64,64)", "ticks": "outside",
                          "zeroline": True, "domain": [0.95, 1]},
                "yaxis2": {"title": "Samples", "gridcolor": "rgb(64,64,64)", "ticks": "outside",
                          "zeroline": True, "domain": [top_bar_domain_start_paralog, 1], "showticklabels": True,
                          "tickmode": "array", "tickvals": tick_vals_paralog, "ticktext": tick_texts_paralog},
                "barmode": "relative",
                "shapes": shapes,
                "height": total_height_paralog
            }
        }
    
    # Helper to create sort buttons for a specific visual mode
    def create_sort_buttons_for_mode_paralog(mode_config):
        """Create sort buttons that maintain the given visual mode"""
        buttons = []
        sort_configs = [
            ('none', 'None', 'category descending'),
            ('total_x', 'Total X', 'total descending'),
            ('total_y', 'Total Y', 'category descending'),
            ('total_both', 'Total Both', 'total descending'),
        ]
        
        for sort_name, sort_label, locus_order in sort_configs:
            # Determine sample order based on sort type
            if 'y' in sort_name.lower() or 'both' in sort_name.lower():
                # Sort samples by total of Filtered data (higher paralog first)
                if 'total' in sort_name:
                    sample_order = sorted(samples_unique_paralog, key=lambda s: sample_stats_paralog[s]['total'], reverse=True)
                else:
                    sample_order = samples_unique_paralog
            else:
                # Keep alphabetical order
                sample_order = samples_unique_paralog
            
            # Use the provided visual mode config
            button_data = create_button_data_paralog(
                sample_order, 
                mode_config['group_by_type'], 
                mode_config['filter_type'], 
                locus_order,
                color_style
            )
            
            buttons.append(
                dict(
                    label=sort_label,
                    method="update",
                    args=[button_data["trace_update"], button_data["layout_update"]],
                )
            )
        return buttons
    
    # Create default sort buttons for Both(paired) mode
    buttons_sort_value_paralog = create_sort_buttons_for_mode_paralog({'group_by_type': False, 'filter_type': None})
    
    # Pre-create sort buttons for each visual mode
    sort_buttons_by_mode_paralog = {}
    for mode_name, mode_config in visual_modes_paralog.items():
        sort_buttons_by_mode_paralog[mode_name] = create_sort_buttons_for_mode_paralog(mode_config)
    
    # Create Visual Mode buttons that also update the Sort by Value dropdown
    buttons_visual_mode_paralog = []
    for idx, (mode_name, mode_label) in enumerate([
        ('both_paired', 'Both (Paired)'),
        ('group_by_type', 'Group by Type'),
        ('only_original', 'Only Original'),
        ('only_filtered', 'Only Filtered'),
    ]):
        mode_config = visual_modes_paralog[mode_name]
        # Use current sample order (default: alphabetical) and default sort order
        button_data = create_button_data_paralog(
            samples_unique_paralog, 
            mode_config['group_by_type'], 
            mode_config['filter_type'],
            'category descending',
            color_style
        )
        
        # Update both the traces/layout AND the sort dropdown buttons
        layout_update = button_data["layout_update"].copy()
        layout_update["updatemenus[1].buttons"] = sort_buttons_by_mode_paralog[mode_name]
        
        buttons_visual_mode_paralog.append(
            dict(
                label=mode_label,
                method="update",
                args=[button_data["trace_update"], layout_update],
            )
        )
    
    # Create figure for paralog heatmap
    fig_paralog = go.Figure()
    
    # Add heatmap with hierarchical Y-axis
    fig_paralog.add_trace(
        go.Heatmap(
            x=loci_sorted_paralog,
            y=[y_labels_sample_paralog, y_labels_type_paralog],
            z=z_values_paralog,
            text=hover_texts_paralog,
            colorscale=cmap_paralog,
            zmin=0,
            zmax=zmax_paralog,
            colorbar=dict(
                title="Paralog<br>Count",
                ticks="outside",
                outlinecolor="rgb(8,8,8)",
                outlinewidth=1,
            ),
            hovertemplate="%{text}<extra></extra>",
            hoverongaps=False,
            xgap=0.5,
            ygap=0.5,
        )
    )
    
    # Calculate bar chart data for paralog
    bar_top_orig_paralog = []
    bar_top_filt_paralog = []
    for locus in loci_sorted_paralog:
        if locus in pivot_paralog.columns:
            count_orig = sum(1 for idx in pivot_paralog.index 
                            if 'Original' in str(idx) and pivot_paralog.loc[idx, locus] > 0)
            count_filt = sum(1 for idx in pivot_paralog.index 
                            if 'Filtered' in str(idx) and pivot_paralog.loc[idx, locus] > 0)
        else:
            count_orig = count_filt = 0
        bar_top_orig_paralog.append(count_orig)
        bar_top_filt_paralog.append(count_filt)
    
    # Right bars for paralog
    bar_right_orig_paralog = []
    bar_right_filt_paralog = []
    for sample, dtype in zip(y_labels_sample_paralog, y_labels_type_paralog):
        if (sample, dtype) in pivot_paralog.index:
            count = (pivot_paralog.loc[(sample, dtype), :] > 0).sum()
        else:
            count = 0
        
        if dtype == 'Original':
            bar_right_orig_paralog.append(count)
            bar_right_filt_paralog.append(0)
        else:
            bar_right_orig_paralog.append(0)
            bar_right_filt_paralog.append(count)
    
    # Custom hover text for top bars
    hover_text_orig_paralog = [f"<b>Locus:</b> {locus}<br><b>Type:</b> Original<br><b>Samples with paralogs:</b> {count}" 
                                for locus, count in zip(loci_sorted_paralog, bar_top_orig_paralog)]
    hover_text_filt_paralog = [f"<b>Locus:</b> {locus}<br><b>Type:</b> Filtered<br><b>Samples with paralogs:</b> {count}" 
                                for locus, count in zip(loci_sorted_paralog, bar_top_filt_paralog)]
    
    # Get color scheme
    COLOR_ORIGINAL, COLOR_FILTERED = get_bar_colors(color_style)
    
    # Add top bar charts for paralog - Original
    fig_paralog.add_trace(
        go.Bar(
            x=loci_sorted_paralog,
            y=bar_top_orig_paralog,
            yaxis="y2",
            name="Original",
            marker=dict(color=COLOR_ORIGINAL, line=dict(color="rgb(8,8,8)", width=0.5)),
            showlegend=False,
            base=0,
            customdata=hover_text_orig_paralog,
            hovertemplate="%{customdata}<extra></extra>",
            textposition="none",
        )
    )
    
    # Add top bar charts for paralog - Filtered
    fig_paralog.add_trace(
        go.Bar(
            x=loci_sorted_paralog,
            y=[-y for y in bar_top_filt_paralog],
            yaxis="y2",
            name="Filtered",
            marker=dict(color=COLOR_FILTERED, line=dict(color="rgb(8,8,8)", width=0.5)),
            showlegend=False,
            base=0,
            customdata=hover_text_filt_paralog,
            hovertemplate="%{customdata}<extra></extra>",
            textposition="none",
        )
    )
    
    # Add right bar charts for paralog - Original
    fig_paralog.add_trace(
        go.Bar(
            x=bar_right_orig_paralog,
            y=[y_labels_sample_paralog, y_labels_type_paralog],
            xaxis="x2",
            name="Original",
            orientation="h",
            marker=dict(color=COLOR_ORIGINAL, line=dict(color="rgb(8,8,8)", width=0.5)),
            showlegend=False,
            textposition="none",
        )
    )
    
    # Add right bar charts for paralog - Filtered
    fig_paralog.add_trace(
        go.Bar(
            x=bar_right_filt_paralog,
            y=[y_labels_sample_paralog, y_labels_type_paralog],
            xaxis="x2",
            name="Filtered",
            orientation="h",
            marker=dict(color=COLOR_FILTERED, line=dict(color="rgb(8,8,8)", width=0.5)),
            showlegend=False,
            textposition="none",
        )
    )
    
    # Update layout for paralog heatmap
    title_text_paralog = "<b>5. Paralog Count Distribution (Original vs Filtered)</b><br><sup>Comparison of paralog counts for each sample before and after filtering</sup>"
    
    num_samples_paralog = len(samples_unique_paralog)
    TOP_BAR_HEIGHT = 100
    total_height_paralog = max(400, 180 + 30 * num_samples_paralog * 2)  # *2 for both Original and Filtered
    top_bar_domain_start_paralog = 1 - (TOP_BAR_HEIGHT / total_height_paralog)
    main_heatmap_domain_end_paralog = top_bar_domain_start_paralog - 0.005
    
    # Calculate tick values for y-axis
    max_bar_value_paralog = max(bar_top_orig_paralog) if bar_top_orig_paralog else 10
    min_bar_value_paralog = min([-y for y in bar_top_filt_paralog]) if bar_top_filt_paralog else -10
    
    tick_vals_paralog = [0]
    tick_texts_paralog = ['0']
    
    if max_bar_value_paralog > 0:
        tick_vals_paralog.append(max_bar_value_paralog)
        tick_texts_paralog.append(str(max_bar_value_paralog))
    
    if min_bar_value_paralog < 0:
        tick_vals_paralog.append(min_bar_value_paralog)
        tick_texts_paralog.append(str(abs(min_bar_value_paralog)))
    
    # Create two separate dropdown menus with clear positioning
    updatemenus_paralog = [
        # Visual Mode dropdown (left)
        dict(
            buttons=buttons_visual_mode_paralog,
            type="dropdown",
            direction="down",
            pad={"t": 10, "b": 10},
            showactive=True,
            x=0.75,
            xanchor="right",
            y=1.0,
            yanchor="bottom",
        ),
        # Sort by Value dropdown (right)
        dict(
            buttons=buttons_sort_value_paralog,
            type="dropdown",
            direction="down",
            pad={"t": 10, "b": 10},
            showactive=True,
            x=0.95,
            xanchor="right",
            y=1.0,
            yanchor="bottom",
        )
    ]
    
    annotations_paralog = [
        # Visual Mode label
        dict(
            text="<b>Visual Mode:</b>",
            x=0.75,
            xref="paper",
            xanchor="right",
            xshift=-130,
            y=1.0,
            yref="paper",
            yanchor="top",
            yshift=36,
            align="left",
            showarrow=False,
        ),
        # Sort by Value label
        dict(
            text="<b>Sort by Value:</b>",
            x=0.95,
            xref="paper",
            xanchor="right",
            xshift=-102,
            y=1.0,
            yref="paper",
            yanchor="top",
            yshift=36,
            align="right",
            showarrow=False,
        )
    ]
    
    fig_paralog.update_layout(
        font_family="Arial",
        plot_bgcolor="rgb(8,8,8)",
        title=title_text_paralog,
        xaxis=dict(
            title="Locus",
            type="category",
            categoryorder="category descending",
            linecolor="black",
            ticks="outside",
            gridcolor="rgb(64,64,64)",
            domain=[0, 0.95],
        ),
        yaxis=dict(
            title="Sample - Type",
            autorange="reversed",
            linecolor="black",
            ticks="outside",
            dtick=1,
            tickson="labels",
            showdividers=False,
            gridcolor="rgb(64,64,64)",
            domain=[0, main_heatmap_domain_end_paralog],
        ),
        xaxis2=dict(
            title="Loci",
            gridcolor="rgb(64,64,64)",
            ticks="outside",
            zeroline=True,
            domain=[0.95, 1],
        ),
        yaxis2=dict(
            title="Samples",
            gridcolor="rgb(64,64,64)",
            ticks="outside",
            zeroline=True,
            domain=[top_bar_domain_start_paralog, 1],
            showticklabels=True,
            tickmode="array",
            tickvals=tick_vals_paralog,
            ticktext=tick_texts_paralog,
        ),
        hoverlabel=dict(
            font_color="#FFFFFF",
            bordercolor="#FFFFFF",
            bgcolor="#444444",
        ),
        barmode="relative",
        bargap=0,
        height=total_height_paralog,
        shapes=[],  # Initialize shapes for group_by_type divider line
        updatemenus=updatemenus_paralog,
        annotations=annotations_paralog,
    )
    
    figs.append(fig_paralog)
    
    ### Paralog Count Box Plots (Original vs Filtered) ###
    fig_box_paralog = make_subplots(
        rows=1, cols=2,
        subplot_titles=("<b>Original Sequences</b>", "<b>Filtered Sequences</b>"),
        horizontal_spacing=0.1
    )
    
    # Get color scheme for box plots
    COLOR_ORIGINAL_BOX, COLOR_FILTERED_BOX = get_bar_colors(color_style)
    
    # Process data for both types
    for idx, data_type in enumerate(['original', 'filtered'], start=1):
        df_box_paralog = df_paralog[df_paralog['type'] == data_type].copy()
        
        # Only show putative paralogs (paralog_sequences > 1)
        df_box_paralog = df_box_paralog[df_box_paralog['paralog_sequences'] > 1]
        
        # Group by sample
        for sample in sorted(samples_unique_paralog):
            sample_data = df_box_paralog[df_box_paralog['sample_name'] == sample]
            
            if len(sample_data) > 0:
                y_values_box = sample_data['paralog_sequences'].values
                
                # Add box trace for this sample
                fig_box_paralog.add_trace(
                    go.Box(
                        y=y_values_box,
                        name=sample,
                        marker_color=COLOR_ORIGINAL_BOX if data_type == 'original' else COLOR_FILTERED_BOX,
                        boxmean='sd',  # Show mean and standard deviation
                        showlegend=False,
                        hovertemplate="<b>%{fullData.name}</b><br>" +
                                    "Paralog Count: %{y}<br>" +
                                    "<extra></extra>",
                    ),
                    row=1, col=idx
                )
        
        # Update axes for this subplot
        fig_box_paralog.update_xaxes(
            title="Sample",
            gridcolor="rgb(220,220,220)",
            ticks="outside",
            tickangle=-45,
            row=1, col=idx
        )
        fig_box_paralog.update_yaxes(
            title="Paralog Count" if idx == 1 else "",
            gridcolor="rgb(220,220,220)",
            ticks="outside",
            row=1, col=idx
        )
    
    # Update overall layout
    fig_box_paralog.update_layout(
        font_family="Arial",
        plot_bgcolor="white",
        paper_bgcolor="white",
        title="<b>6. Paralog Count Distribution Box Plot</b><br><sup>Distribution of paralog counts per sample (only showing loci with putative paralogs, count > 1)</sup>",
        height=600,
        hoverlabel=dict(
            font_color="#000000",
            bordercolor="#333333",
            bgcolor="#FFFFFF",
        ),
    )
    
    figs.append(fig_box_paralog)
    
    ### Paralog Statistics Tables ###
    logger.info("[6.7] Generating paralog statistics tables...")
    
    # Calculate statistics for Original paralog data (only count paralog_sequences > 1)
    sample_paralog_stats_list_original = []
    for sample in sorted(samples_unique_paralog):
        sample_data = df_paralog[(df_paralog['sample_name'] == sample) & (df_paralog['type'] == 'original') & (df_paralog['paralog_sequences'] > 1)]
        
        if len(sample_data) > 0:
            loci_with_paralogs = len(sample_data)
            median_paralog = sample_data['paralog_sequences'].median()
            max_paralog = sample_data['paralog_sequences'].max()
            total_paralog = sample_data['paralog_sequences'].sum()
        else:
            loci_with_paralogs = 0
            median_paralog = 0
            max_paralog = 0
            total_paralog = 0
        
        sample_paralog_stats_list_original.append({
            'Sample': sample,
            'Loci_With_Paralogs': loci_with_paralogs,
            'Median_Paralog': median_paralog,
            'Max_Paralog': max_paralog,
            'Total_Paralog': total_paralog
        })
    
    # Calculate statistics for Filtered paralog data (only count paralog_sequences > 1)
    sample_paralog_stats_list_filtered = []
    for sample in sorted(samples_unique_paralog):
        sample_data = df_paralog[(df_paralog['sample_name'] == sample) & (df_paralog['type'] == 'filtered') & (df_paralog['paralog_sequences'] > 1)]
        
        if len(sample_data) > 0:
            loci_with_paralogs = len(sample_data)
            median_paralog = sample_data['paralog_sequences'].median()
            max_paralog = sample_data['paralog_sequences'].max()
            total_paralog = sample_data['paralog_sequences'].sum()
        else:
            loci_with_paralogs = 0
            median_paralog = 0
            max_paralog = 0
            total_paralog = 0
        
        sample_paralog_stats_list_filtered.append({
            'Sample': sample,
            'Loci_With_Paralogs': loci_with_paralogs,
            'Median_Paralog': median_paralog,
            'Max_Paralog': max_paralog,
            'Total_Paralog': total_paralog
        })
    
    # Create DataFrames
    stats_df_paralog_original = pd.DataFrame(sample_paralog_stats_list_original)
    stats_df_paralog_filtered = pd.DataFrame(sample_paralog_stats_list_filtered)
    
    # Create plotly table for Original paralog data
    fig_table_paralog_original = go.Figure()
    fig_table_paralog_original.add_trace(
        go.Table(
            header=dict(
                values=[
                    "<b>Sample</b>",
                    "<b>Loci with putative paralogs (>1)</b>",
                    "<b>Median Paralog Count</b>",
                    "<b>Max Paralog Count</b>",
                    "<b>Total Paralogs</b>"
                ],
                fill_color=header_color,
                font=dict(color='white', size=12),
                align='left',
                height=30,
            ),
            cells=dict(
                values=[
                    stats_df_paralog_original['Sample'],
                    stats_df_paralog_original['Loci_With_Paralogs'],
                    stats_df_paralog_original['Median_Paralog'].round(2),
                    stats_df_paralog_original['Max_Paralog'],
                    stats_df_paralog_original['Total_Paralog']
                ],
                fill_color='light grey',
                align='left',
                height=25,
                format=[None, None, ".2f", None, None],
            )
        )
    )
    
    fig_table_paralog_original.update_layout(
        font_family="Arial",
        title="<b>7. Sample Paralog Statistics Summary (Original Data)</b><br><sup>Statistics based on original sequences with paralog count > 1</sup>",
        height=max(400, 100 + 25 * len(stats_df_paralog_original)),
    )
    
    figs.append(fig_table_paralog_original)
    
    # Create plotly table for Filtered paralog data
    fig_table_paralog_filtered = go.Figure()
    fig_table_paralog_filtered.add_trace(
        go.Table(
            header=dict(
                values=[
                    "<b>Sample</b>",
                    "<b>Loci with putative paralogs (>1)</b>",
                    "<b>Median Paralog Count</b>",
                    "<b>Max Paralog Count</b>",
                    "<b>Total Paralogs</b>"
                ],
                fill_color=header_color,
                font=dict(color='white', size=12),
                align='left',
                height=30,
            ),
            cells=dict(
                values=[
                    stats_df_paralog_filtered['Sample'],
                    stats_df_paralog_filtered['Loci_With_Paralogs'],
                    stats_df_paralog_filtered['Median_Paralog'].round(2),
                    stats_df_paralog_filtered['Max_Paralog'],
                    stats_df_paralog_filtered['Total_Paralog']
                ],
                fill_color='light grey',
                align='left',
                height=25,
                format=[None, None, ".2f", None, None],
            )
        )
    )
    
    fig_table_paralog_filtered.update_layout(
        font_family="Arial",
        title="<b>8. Sample Paralog Statistics Summary (Filtered Data)</b><br><sup>Statistics based on filtered sequences with paralog count > 1</sup>",
        height=max(400, 100 + 25 * len(stats_df_paralog_filtered)),
    )
    
    figs.append(fig_table_paralog_filtered)
    
    # Save to HTML
    config = dict(
        scrollZoom=True,
        toImageButtonOptions=dict(
            format="svg",
        ),
        modeBarButtonsToAdd=[
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
        ]
    )
    
    report_title = "HybSuite Stage2: Sequence Length Recovery Report"
    html_header = f"""
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style>
                body {{
                    font-family: Arial, sans-serif;
                    margin: 50px;
                }}
                pre {{
                    background-color: #292929;
                    padding: 20px;
                    border: 1px solid #ddd;
                    border-radius: 10px;
                    overflow-x: auto;
                }}
                code {{
                    font-family: Menlo, Courier, monospace;
                    font-size: 10pt;
                    color: #FFF;
                }}
            </style>
        </head>
        <body>
            <h2>{report_title}</h2>
            <pre><code>Generated by: stage2_report.py (HybSuite)
Data source: {length_stats_file}
Number of samples: {df['sample_name'].nunique()}
Number of loci: {df['locus'].nunique()}</code></pre>
        </body>
    """
    
    html_output = os.path.join(output_dir, "hybsuite_stage2_report.html")
    with open(html_output, "w") as f:
        f.write(html_header)
        for i, fig in enumerate(figs):
            f.write(
                fig.to_html(
                    full_html=False,
                    include_plotlyjs="cdn" if i == 0 else False,
                    config=config,
                    validate=False,
                )
            )
    
    elapsed = time.time() - start
    logger.info(f"Interactive HTML report generated: {html_output} (in {elapsed:.2f}s)")
    
    return html_output

def main(args):
    """Main function"""
    
    # Load reference sequences
    ref_lengths = get_reference_lengths(args.reference)
    
    if not ref_lengths:
        logger.error("Failed to load reference sequences. Exiting.")
        sys.exit(1)
    
    logger.info(f"Loaded reference lengths for {len(ref_lengths)} loci")
    
    # Process original (pre-filter) directory
    logger.info("[2] Processing original (pre-filter) sequences...")
    original_locus_data, original_paralog_data, original_samples, original_loci = process_directory(
        args.original_dir, 
        ref_lengths, 
        'original',
        args.filename_suffix,
        args.threads
    )
    
    logger.info(f"Found {len(original_samples)} samples and {len(original_loci)} loci FASTA files in original directory")
    
    # Process filtered directory
    logger.info("[3] Processing filtered sequences...")
    filtered_locus_data, filtered_paralog_data, filtered_samples, filtered_loci = process_directory(
        args.filtered_dir, 
        ref_lengths, 
        'filtered',
        args.filename_suffix,
        args.threads
    )
    
    logger.info(f"Found {len(filtered_samples)} samples and {len(filtered_loci)} loci FASTA files in filtered directory")
    
    # Get union of all samples and loci from both directories
    all_samples = original_samples | filtered_samples
    all_loci = original_loci | filtered_loci
    
    logger.info(f"Total unique samples in both directories: {len(all_samples)}")
    logger.info(f"Total unique loci in both directories: {len(all_loci)}")
    
    # Build complete results with zeros for missing data
    all_results = []
    
    for sample in sorted(all_samples):
        for locus in sorted(all_loci, key=natural_sort_key):
            ref_length = ref_lengths.get(locus, 0)
            if ref_length == 0:
                continue
            
            # Original data
            orig_length = original_locus_data.get(locus, {}).get(sample, 0)
            orig_coverage = (orig_length / ref_length) * 100 if orig_length > 0 else 0.0
            all_results.append({
                'sample_name': sample,
                'type': 'original',
                'locus': locus,
                'length': orig_length,
                'length_coverage': orig_coverage
            })
            
            # Filtered data
            filt_length = filtered_locus_data.get(locus, {}).get(sample, 0)
            filt_coverage = (filt_length / ref_length) * 100 if filt_length > 0 else 0.0
            all_results.append({
                'sample_name': sample,
                'type': 'filtered',
                'locus': locus,
                'length': filt_length,
                'length_coverage': filt_coverage
            })
    
    if not all_results:
        logger.error("No results to write. Exiting.")
        sys.exit(1)
    
    # Create DataFrame (already sorted by sample and locus during generation)
    df = pd.DataFrame(all_results)
    
    # Reorder columns to match required format (5 columns)
    df = df[['sample_name', 'type', 'locus', 'length', 'length_coverage']]
    
    # Create output directory
    output_dir = args.output_dir
    os.makedirs(output_dir, exist_ok=True)
    
    # Define output file paths
    length_stats_file = os.path.join(output_dir, 'length_stats.tsv')
    
    # Ensure length column is integer type
    df['length'] = df['length'].astype(int)
    
    # Write length stats TSV file
    df.to_csv(length_stats_file, sep='\t', index=False, float_format='%.2f')
    
    # Print summary statistics
    logger.info("[4] Generating length_stats.tsv...")
    
    # Calculate average coverage (excluding zeros)
    orig_data = df[df['type'] == 'original']['length_coverage']
    filt_data = df[df['type'] == 'filtered']['length_coverage']
    
    orig_avg = orig_data.mean()
    filt_avg = filt_data.mean()
    orig_nonzero = orig_data[orig_data > 0]
    filt_nonzero = filt_data[filt_data > 0]
    
    logger.info(f"Average length coverage (original, all): {orig_avg:.2f}%")
    logger.info(f"Average length coverage (filtered, all): {filt_avg:.2f}%")
    
    if len(orig_nonzero) > 0:
        logger.info(f"Average length coverage (original, non-zero only): {orig_nonzero.mean():.2f}%")
    if len(filt_nonzero) > 0:
        logger.info(f"Average length coverage (filtered, non-zero only): {filt_nonzero.mean():.2f}%")
    
    logger.info(f"Number of records with zero length coverage (original): {len(orig_data[orig_data == 0])}")
    logger.info(f"Number of records with zero length coverage (filtered): {len(filt_data[filt_data == 0])}")
    
    # Generate paralog statistics file and print summary statistics
    logger.info("[5] Generating paralog_stats.tsv...")

    paralog_results = []
    
    for sample in sorted(all_samples):
        for locus in sorted(all_loci, key=natural_sort_key):
            # Original paralog count
            orig_paralog_count = original_paralog_data.get(locus, {}).get(sample, 0)
            paralog_results.append({
                'sample_name': sample,
                'type': 'original',
                'locus': locus,
                'paralog_sequences': orig_paralog_count
            })
            
            # Filtered paralog count
            filt_paralog_count = filtered_paralog_data.get(locus, {}).get(sample, 0)
            paralog_results.append({
                'sample_name': sample,
                'type': 'filtered',
                'locus': locus,
                'paralog_sequences': filt_paralog_count
            })
    
    # Create paralog DataFrame
    paralog_df = pd.DataFrame(paralog_results)
    paralog_df = paralog_df[['sample_name', 'type', 'locus', 'paralog_sequences']]
    paralog_df['paralog_sequences'] = paralog_df['paralog_sequences'].astype(int)
    
    # Define paralog stats output file path
    paralog_stats_file = os.path.join(output_dir, 'paralog_stats.tsv')
    
    paralog_df.to_csv(paralog_stats_file, sep='\t', index=False)
    
    orig_paralog_data_col = paralog_df[paralog_df['type'] == 'original']['paralog_sequences']
    filt_paralog_data_col = paralog_df[paralog_df['type'] == 'filtered']['paralog_sequences']
    
    orig_paralog_avg = orig_paralog_data_col.mean()
    filt_paralog_avg = filt_paralog_data_col.mean()
    orig_paralog_nonzero = orig_paralog_data_col[orig_paralog_data_col > 0]
    filt_paralog_nonzero = filt_paralog_data_col[filt_paralog_data_col > 0]
    
    logger.info(f"Average paralog count (original, all): {orig_paralog_avg:.2f}")
    logger.info(f"Average paralog count (filtered, all): {filt_paralog_avg:.2f}")
    
    if len(orig_paralog_nonzero) > 0:
        logger.info(f"Average paralog count (original, non-zero only): {orig_paralog_nonzero.mean():.2f}")
    if len(filt_paralog_nonzero) > 0:
        logger.info(f"Average paralog count (filtered, non-zero only): {filt_paralog_nonzero.mean():.2f}")
    
    logger.info(f"Records with zero paralogs (original): {len(orig_paralog_data_col[orig_paralog_data_col == 0])}")
    logger.info(f"Records with zero paralogs (filtered): {len(filt_paralog_data_col[filt_paralog_data_col == 0])}")
    logger.info(f"Records with 1 paralog (original): {len(orig_paralog_data_col[orig_paralog_data_col == 1])}")
    logger.info(f"Records with 1 paralog (filtered): {len(filt_paralog_data_col[filt_paralog_data_col == 1])}")
    logger.info(f"Records with >1 paralogs (original): {len(orig_paralog_data_col[orig_paralog_data_col > 1])}")
    logger.info(f"Records with >1 paralogs (filtered): {len(filt_paralog_data_col[filt_paralog_data_col > 1])}")
    
    # Generate HTML report
    html_report = build_stage2_html_report(length_stats_file, paralog_stats_file, output_dir, args.color_style)
    
    # Final summary
    logger.info("[7] COMPLETED SUCCESSFULLY")
    logger.info(f"Output directory: {output_dir}")
    logger.info(f"Generated files:")
    logger.info(f"length_stats.tsv -> {length_stats_file}")
    logger.info(f"paralog_stats.tsv -> {paralog_stats_file}")
    logger.info(f"hybsuite_stage2_report.html -> {html_report}")

def standalone():
    """Parse command line arguments and run main function"""
    parser = argparse.ArgumentParser(
        description=__doc__, 
        formatter_class=argparse.RawTextHelpFormatter
    )
    
    # Required input parameters
    parser.add_argument('-o', '--original_dir', required=True,
                        help='Directory containing original (pre-filter) FASTA files')
    parser.add_argument('-f', '--filtered_dir', required=True,
                        help='Directory containing filtered FASTA files')
    parser.add_argument('-r', '--ref', required=True, dest='reference',
                        help='Reference sequences file (FASTA format)')
    
    # Output parameters
    parser.add_argument('--output', '-out', dest='output_dir',
                        default='stage2_report',
                        help='Output directory for results (default: stage2_report). '
                             'Will generate length_stats.tsv and paralog_stats.tsv in this directory')
    
    # Optional parameters
    parser.add_argument('--filename_suffix',
                        help='Suffix(es) to remove from input FASTA filenames to get locus names. '
                             'Multiple suffixes can be separated by commas. '
                             'Example: "_paralogs_all". '
                             'If not specified, the input filenames will be recognized as loci names.')
    
    parser.add_argument('-t', '--threads', type=int, default=1,
                        help='Number of threads to use (default: 1)')
    
    parser.add_argument('--color_style', '--color', dest='color_style',
                        choices=['viridis', 'purple', 'blue', 'green'],
                        default='blue',
                        help='Color scheme for heatmap visualization (default: viridis)\n'
                             '  viridis: Colorblind-friendly warm gradient (peach→red→purple)\n'
                             '  purple:  Purple monochrome (deep→pale lavender)\n'
                             '  blue:    Blue monochrome (navy→pale sky blue)\n'
                             '  green:   Green monochrome (forest→pale mint)')
    
    args = parser.parse_args()
    
    # Validate input
    if not os.path.isdir(args.original_dir):
        parser.error(f"Original directory does not exist: {args.original_dir}")
    if not os.path.isdir(args.filtered_dir):
        parser.error(f"Filtered directory does not exist: {args.filtered_dir}")
    if not os.path.isfile(args.reference):
        parser.error(f"Reference file does not exist: {args.reference}")
    
    main(args)

if __name__ == '__main__':
    standalone()
