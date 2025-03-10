#!/usr/bin/env python

"""
Filter sequences by taxon and locus coverage.
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

def get_taxon_name(header):
    """
    Extract taxon name from sequence header.
    Remove '.number' or '.main' suffix if present.
    
    Examples:
        'Rosa_chinensis.0' -> 'Rosa_chinensis'
        'Rosa_chinensis.main' -> 'Rosa_chinensis'
        'Rosa_chinensis' -> 'Rosa_chinensis'
        'Rosa_chinensis other_info' -> 'Rosa_chinensis'
    """
    # Remove '>' and get the first part if space exists
    taxon = header.strip('>').split()[0]
    
    # Remove '.number' or '.main' suffix if present
    taxon = re.sub(r'\.(?:main|\d+)$', '', taxon)
    
    return taxon

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
    Calculate taxon and locus coverage statistics.
    """
    # Get all fasta files with any extension
    fasta_files = [f for f in os.listdir(input_dir) 
                   if any(f.lower().endswith(ext) for ext in ('.fa', '.fasta', '.fna'))]
    
    taxon_locus_presence = defaultdict(set)
    locus_taxon_presence = defaultdict(set)
    
    # Process each fasta file
    for fasta_file in fasta_files:
        file_path = os.path.join(input_dir, fasta_file)
        locus = get_locus_name(fasta_file)
        
        # Get unique taxa in this locus
        taxa_in_locus = set()
        for record in SeqIO.parse(file_path, "fasta"):
            taxon = get_taxon_name(record.description)
            taxa_in_locus.add(taxon)
            taxon_locus_presence[taxon].add(locus)
        
        locus_taxon_presence[locus] = taxa_in_locus
    
    total_loci = len(fasta_files)
    total_taxa = len(taxon_locus_presence)
    
    logging.info(f"Found {total_taxa} taxa across {total_loci} loci")
    
    # Calculate coverage ratios
    taxon_coverage = {
        taxon: len(loci) / total_loci 
        for taxon, loci in taxon_locus_presence.items()
    }
    
    locus_coverage = {
        locus: len(taxa) / total_taxa 
        for locus, taxa in locus_taxon_presence.items()
    }
    
    return taxon_coverage, locus_coverage, total_taxa, total_loci

def process_fasta_file(args):
    """
    Process a single fasta file
    """
    input_dir, fasta_file, taxa_to_keep, output_dir = args
    file_path = os.path.join(input_dir, fasta_file)
    locus_name = get_locus_name(fasta_file)
    
    try:
        # Read and filter sequences
        filtered_records = []
        for record in SeqIO.parse(file_path, "fasta"):
            taxon = get_taxon_name(record.description)
            if taxon in taxa_to_keep:
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
        description="Filter sequences by taxon and locus coverage. Part of HybSuite.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    
    parser.add_argument("-i", "--input", required=True,
                        help="Directory containing fasta files")
    parser.add_argument("-o", "--output_dir",
                        help="Directory for filtered sequences (if not specified, original files will be modified)")
    parser.add_argument("--min_taxon_coverage", type=float, default=0.0,
                        help="Minimum taxon coverage ratio (0-1) for each locus")
    parser.add_argument("--min_locus_coverage", type=float, default=0.0,
                        help="Minimum locus coverage ratio (0-1) for each taxon")
    parser.add_argument("-t", "--threads", type=int, default=1,
                        help="Number of threads to use")
    parser.add_argument("--removed_taxa_info",
                        help="Output TSV file for removed taxa coverage information")
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
    if args.min_taxon_coverage > 0:
        filter_modes.append(f"minimum taxon coverage: {args.min_taxon_coverage}")
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
    taxon_coverage, locus_coverage, total_taxa, total_loci = calculate_coverage_stats(args.input)
    
    # Filter taxa and loci based on coverage
    taxa_to_keep = {
        taxon for taxon, coverage in taxon_coverage.items()
        if coverage >= args.min_locus_coverage
    }
    
    loci_to_keep = {
        locus for locus, coverage in locus_coverage.items()
        if coverage >= args.min_taxon_coverage
    }
    
    # Output removed taxa information
    if args.removed_taxa_info:
        removed_taxa = {
            taxon: coverage 
            for taxon, coverage in taxon_coverage.items()
            if coverage < args.min_locus_coverage
        }
        if removed_taxa:
            df_taxa = pd.DataFrame([
                {'Taxon': taxon, 'Locus_Coverage': coverage}
                for taxon, coverage in removed_taxa.items()
            ])
            df_taxa.to_csv(args.removed_taxa_info, sep='\t', index=False)
            logging.info(f"Removed taxa information written to {args.removed_taxa_info}")
    
    # Output removed loci information
    if args.removed_loci_info:
        removed_loci = {
            locus: coverage 
            for locus, coverage in locus_coverage.items()
            if coverage < args.min_taxon_coverage
        }
        if removed_loci:
            df_loci = pd.DataFrame([
                {'Locus': locus, 'Taxon_Coverage': coverage}
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
    process_args = [(args.input, f, taxa_to_keep, args.output_dir)
                    for f in files_to_process]
    
    with mp.Pool(args.threads) as pool:
        results = pool.map(process_fasta_file, process_args)
    
    # For loci that should be removed, remove their files
    for locus in locus_files:
        if locus not in loci_to_keep:
            remove_locus_files(args.input, locus)
    
    # Report results
    retained_seqs = sum(results)
    logging.info(f"Retained {len(taxa_to_keep)} taxa out of {total_taxa}")
    logging.info(f"Retained {len(loci_to_keep)} loci out of {total_loci}")
    logging.info(f"Retained {retained_seqs} sequences")
    logging.info("Processing complete!")

if __name__ == "__main__":
    main()
