#!/usr/bin/env python

"""
Filter sequences by sample and locus coverage.
Part of HybSuite.
"""

import os
import sys
import argparse
from Bio import SeqIO
from pathlib import Path
import pandas as pd
from collections import defaultdict
import multiprocessing as mp
import logging
import re

def get_sample_name(header):
    """
    Extract sample name from sequence header.
    Remove '.number' or '.main' suffix if present.
    
    Examples:
        'Rosa_chinensis.0' -> 'Rosa_chinensis'
        'Rosa_chinensis.main' -> 'Rosa_chinensis'
        'Rosa_chinensis' -> 'Rosa_chinensis'
        'Rosa_chinensis other_info' -> 'Rosa_chinensis'
    """
    # Remove '>' and get the first part if space exists
    sample = header.strip('>').split()[0]
    
    # Remove '.number' or '.main' suffix if present
    sample = re.sub(r'\.(?:main|\d+)$', '', sample)
    
    return sample

def get_locus_name(filename):
    """
    Extract locus name from filename.
    Handle both formats:
    1. "locus_paralogs_all.fasta"
    2. "locus.fasta"
    """
    # Remove file extension first
    base_name = Path(filename).stem
    # If contains _paralogs_all, remove it
    if '_paralogs_all' in base_name:
        return base_name.split('_paralogs_all')[0]
    return base_name

def remove_locus_files(input_dir, locus_name):
    """
    Remove all files related to a specific locus
    """
    base_path = Path(input_dir)
    removed = False
    # Try both normal and _paralogs_all versions with different extensions
    for ext in ['.fa', '.fasta', '.fna', '.FNA', '.FASTA']:
        # Try normal version
        normal_file = base_path / f"{locus_name}{ext}"
        if normal_file.exists():
            normal_file.unlink()
            removed = True
        
        # Try _paralogs_all version
        paralogs_file = base_path / f"{locus_name}_paralogs_all{ext}"
        if paralogs_file.exists():
            paralogs_file.unlink()
            removed = True
    
    return removed

def calculate_coverage_stats(input_dir):
    """
    Calculate sample and locus coverage statistics.
    """
    # Get all fasta files with any extension
    fasta_files = [f for f in os.listdir(input_dir) 
                   if any(f.lower().endswith(ext) for ext in ('.fa', '.fasta', '.fna'))]
    
    sample_locus_presence = defaultdict(set)
    locus_sample_presence = defaultdict(set)
    
    # Process each fasta file
    for fasta_file in fasta_files:
        file_path = os.path.join(input_dir, fasta_file)
        locus = get_locus_name(fasta_file)
        
        # Get unique samples in this locus
        samples_in_locus = set()
        for record in SeqIO.parse(file_path, "fasta"):
            sample = get_sample_name(record.description)
            samples_in_locus.add(sample)
            sample_locus_presence[sample].add(locus)
        
        locus_sample_presence[locus] = samples_in_locus
    
    total_loci = len(fasta_files)
    total_samples = len(sample_locus_presence)
    
    logging.info(f"Found {total_samples} samples across {total_loci} loci")
    
    # Calculate coverage ratios
    sample_coverage = {
        sample: len(loci) / total_loci 
        for sample, loci in sample_locus_presence.items()
    }
    
    locus_coverage = {
        locus: len(samples) / total_samples 
        for locus, samples in locus_sample_presence.items()
    }
    
    return sample_coverage, locus_coverage, total_samples, total_loci

def process_fasta_file(args):
    """
    Process a single fasta file
    """
    input_dir, fasta_file, samples_to_keep, output_dir = args
    file_path = os.path.join(input_dir, fasta_file)
    locus_name = get_locus_name(fasta_file)
    
    try:
        # Read and filter sequences
        filtered_records = []
        for record in SeqIO.parse(file_path, "fasta"):
            sample = get_sample_name(record.description)
            if sample in samples_to_keep:
                filtered_records.append(record)
        
        if filtered_records:
            if output_dir:
                # Write to new location
                output_file = os.path.join(output_dir, os.path.basename(fasta_file))
                SeqIO.write(filtered_records, output_file, "fasta")
            else:
                # Overwrite original file
                SeqIO.write(filtered_records, file_path, "fasta")
        elif not output_dir:
            # Remove all files related to this locus
            remove_locus_files(input_dir, locus_name)
        
        return len(filtered_records)
        
    except Exception as e:
        logging.error(f"Error processing file {fasta_file}: {str(e)}")
        return 0

def main():
    parser = argparse.ArgumentParser(
        description="Filter sequences by sample and locus coverage. Part of HybSuite.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    
    parser.add_argument("-i", "--input", required=True,
                        help="Directory containing fasta files")
    parser.add_argument("-o", "--output_dir",
                        help="Directory for filtered sequences (if not specified, original files will be modified)")
    parser.add_argument("--min_sample_coverage", type=float, default=0.0,
                        help="Minimum sample coverage ratio (0-1) for each locus")
    parser.add_argument("--min_locus_coverage", type=float, default=0.0,
                        help="Minimum locus coverage ratio (0-1) for each sample")
    parser.add_argument("-t", "--threads", type=int, default=1,
                        help="Number of threads to use")
    parser.add_argument("--removed_samples_info",
                        help="Output TSV file for removed samples coverage information")
    parser.add_argument("--removed_loci_info",
                        help="Output TSV file for removed loci coverage information")
    
    args = parser.parse_args()
    
    # Set logging format
    logging.basicConfig(
        level=logging.INFO,
        format='[%(asctime)s] [%(levelname)s] %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )
    
    # Initial information about the script and filtering criteria
    logging.info(f"Filtering sequences by coverage using {os.path.basename(__file__)}")
    
    # Display active filtering criteria
    filter_modes = []
    if args.min_sample_coverage > 0:
        filter_modes.append(f"minimum sample coverage: {args.min_sample_coverage}")
    if args.min_locus_coverage > 0:
        filter_modes.append(f"minimum locus coverage: {args.min_locus_coverage}")
    
    if filter_modes:
        logging.info("Active filtering criteria: " + "; ".join(filter_modes))
    else:
        logging.info("No filtering criteria specified. All sequences will be retained.")
    
    # Validate input directory
    if not os.path.isdir(args.input):
        logging.error(f"Input directory {args.input} does not exist")
        sys.exit(1)
    
    # Create output directory if specified
    if args.output_dir:
        os.makedirs(args.output_dir, exist_ok=True)
        logging.info(f"Filtered sequences will be written to directory: {args.output_dir}")
    else:
        logging.info("No output directory specified. Original files will be modified.")
    
    # Calculate coverage statistics
    logging.info("Calculating coverage statistics...")
    sample_coverage, locus_coverage, total_samples, total_loci = calculate_coverage_stats(args.input)
    
    # Filter samples and loci based on coverage
    samples_to_keep = {
        sample for sample, coverage in sample_coverage.items()
        if coverage >= args.min_locus_coverage
    }
    
    loci_to_keep = {
        locus for locus, coverage in locus_coverage.items()
        if coverage >= args.min_sample_coverage
    }
    
    # Output removed samples information
    if args.removed_samples_info:
        removed_samples = {
            sample: coverage 
            for sample, coverage in sample_coverage.items()
            if coverage < args.min_locus_coverage
        }
        if removed_samples:
            df_samples = pd.DataFrame([
                {'Sample': sample, 'Locus_Coverage': coverage}
                for sample, coverage in removed_samples.items()
            ])
            df_samples.to_csv(args.removed_samples_info, sep='\t', index=False)
            logging.info(f"Removed samples information written to {args.removed_samples_info}")
    
    # Output removed loci information
    if args.removed_loci_info:
        removed_loci = {
            locus: coverage 
            for locus, coverage in locus_coverage.items()
            if coverage < args.min_sample_coverage
        }
        if removed_loci:
            df_loci = pd.DataFrame([
                {'Locus': locus, 'Sample_Coverage': coverage}
                for locus, coverage in removed_loci.items()
            ])
            df_loci.to_csv(args.removed_loci_info, sep='\t', index=False)
            logging.info(f"Removed loci information written to {args.removed_loci_info}")
    
    # Get all sequence files and their locus names
    all_files = []
    locus_files = {}  # locus name -> list of files
    for f in os.listdir(args.input):
        if any(f.lower().endswith(ext) for ext in ('.fa', '.fasta', '.fna', '.FNA', '.FASTA')):
            locus_name = get_locus_name(f)
            if locus_name not in locus_files:
                locus_files[locus_name] = []
            locus_files[locus_name].append(f)
    
    # Only process files for loci we want to keep
    files_to_process = []
    for locus in loci_to_keep:
        if locus in locus_files:
            files_to_process.extend(locus_files[locus])
    
    if not files_to_process:
        logging.info("No files to process after applying coverage filters")
        sys.exit(0)
    
    # Process files with multiple threads
    logging.info(f"Processing {len(files_to_process)} files with {args.threads} threads...")
    process_args = [(args.input, f, samples_to_keep, args.output_dir)
                    for f in files_to_process]
    
    with mp.Pool(args.threads) as pool:
        results = pool.map(process_fasta_file, process_args)
    
    # For loci that should be removed, remove their files
    for locus in locus_files:
        if locus not in loci_to_keep:
            remove_locus_files(args.input, locus)
    
    # Report results
    retained_seqs = sum(results)
    logging.info(f"Retained {len(samples_to_keep)} samples out of {total_samples}")
    logging.info(f"Retained {len(loci_to_keep)} loci out of {total_loci}")
    logging.info(f"Retained {retained_seqs} sequences")
    logging.info("Processing complete!")

if __name__ == "__main__":
    main()
