#!/usr/bin/env python3
import os
import re
import sys
import argparse
import pandas as pd
from pathlib import Path
from Bio import SeqIO
import shutil
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime

def get_timestamp():
    """Get current timestamp in required format"""
    return datetime.now().strftime('%Y-%m-%d %H:%M:%S')

def print_log(level, message):
    """Print log message in standard format"""
    print(f"[{get_timestamp()}] [{level}] {message}")

def get_taxon_name(header):
    """
    Extract taxon name from sequence header.
    Remove '.number' or '.main' suffix if present.
    
    Args:
        header (str): Sequence header line
        
    Returns:
        str: Clean taxon name
    """
    # Remove '>' and get the first part if space exists
    taxon = header.strip('>').split()[0]
    
    # Remove '.number' or '.main' suffix if present
    taxon = re.sub(r'\.(?:main|\d+)$', '', taxon)
    
    return taxon

def process_locus(args, locus_name, paralog_df):
    """
    Process a single locus file to check for paralogs.
    
    Args:
        args: Command line arguments
        locus_name (str): Name of the locus
        paralog_df (pd.DataFrame): Paralog statistics dataframe
        
    Returns:
        tuple or None: (locus_name, paralog_count) if locus should be deleted, None otherwise
    """
    paralog_species = sum(paralog_df[locus_name] >= 2)
    
    if paralog_species >= args.samples_threshold:
        if args.output_dir:
            # If output directory specified, remove file from output directory
            output_file = Path(args.output_dir) / f"{locus_name}.FNA"
            if output_file.exists():
                output_file.unlink()
        else:
            # Otherwise remove from input directory
            for ext in ['.FNA', '.fasta', '.FASTA']:
                file_path = Path(args.input_dir) / f"{locus_name}{ext}"
                if file_path.exists():
                    file_path.unlink()
                    break
        return [locus_name, paralog_species]
    return None

def main():
    parser = argparse.ArgumentParser(description="Remove loci with excessive paralogs based on species count threshold")
    parser.add_argument("-i", "--input_dir", required=True, help="Input directory containing sequence files")
    parser.add_argument("-p", "--paralog_heatmap", required=True, help="Path to paralog statistics file (.tsv)")
    parser.add_argument("-s", "--samples_threshold", type=int, required=True, help="Species count threshold for paralog filtering")
    parser.add_argument("-o", "--output_dir", help="Output directory path (optional)")
    parser.add_argument("-or", "--output_report", required=True, help="Path to deletion report output (.tsv)")
    parser.add_argument("-t", "--threads", type=int, default=1, help="Number of threads (default: 1)")
    
    args = parser.parse_args()
    
    print_log("INFO", "RLWP.py (a python script for HybSuite): removing loci with paralogs")
    
    # Check input paths
    if not os.path.exists(args.input_dir):
        print_log("ERROR", f"Input directory does not exist: {args.input_dir}")
        sys.exit(1)
    
    if not os.path.exists(args.paralog_heatmap):
        print_log("ERROR", f"Paralog statistics file does not exist: {args.paralog_heatmap}")
        sys.exit(1)
    
    # Create output directory if specified
    if args.output_dir:
        os.makedirs(args.output_dir, exist_ok=True)
    
    # Read paralog data
    try:
        print_log("INFO", "Reading paralog statistics file")
        paralog_df = pd.read_csv(args.paralog_heatmap, sep='\t', index_col=0)
    except Exception as e:
        print_log("ERROR", f"Error reading paralog file: {str(e)}")
        sys.exit(1)
    
    # Get all sequence files with case-insensitive extensions
    sequence_files = []
    extensions = ['.fa', '.fasta', '.fna', '.fas', '.FNA', '.FASTA']
    for ext in extensions:
        sequence_files.extend(list(Path(args.input_dir).glob(f"*{ext}")))
        # Also try uppercase version
        sequence_files.extend(list(Path(args.input_dir).glob(f"*{ext.upper()}")))
    
    if not sequence_files:
        print_log("ERROR", f"No sequence files found in input directory: {args.input_dir}")
        sys.exit(1)
    
    print_log("INFO", f"Found {len(sequence_files)} sequence files")
    
    # If output directory specified, copy all files first
    if args.output_dir:
        print_log("INFO", "Copying files to output directory")
        for file in sequence_files:
            shutil.copy2(file, args.output_dir)
    
    # Process files using thread pool
    print_log("INFO", "Processing loci")
    deleted_loci = []
    with ThreadPoolExecutor(max_workers=args.threads) as executor:
        futures = []
        for file in sequence_files:
            locus_name = file.stem
            if locus_name in paralog_df.columns:
                future = executor.submit(process_locus, args, locus_name, paralog_df)
                futures.append(future)
        
        # Collect results
        for future in futures:
            result = future.result()
            if result:
                deleted_loci.append(result)
    
    # Write deletion report
    if deleted_loci:
        report_df = pd.DataFrame(deleted_loci, columns=['Locus', 'Samples with paralogs'])
        report_df.to_csv(args.output_report, sep='\t', index=False)
        print_log("INFO", f"Deletion report saved to: {args.output_report}")
        print_log("INFO", f"Total loci deleted: {len(deleted_loci)}")
    else:
        print_log("INFO", "No loci needed to be deleted")
    
    print_log("INFO", "Finished")

if __name__ == "__main__":
    main()
