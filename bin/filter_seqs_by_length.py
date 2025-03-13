#!/usr/bin/env python

"""
Filter sequences by length using various criteria.
Part of HybSuite.
"""

import os
import sys
import argparse
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqUtils import molecular_weight
import pandas as pd
from collections import defaultdict
import multiprocessing as mp
from pathlib import Path
import logging

def is_protein_sequence(sequence):
    """
    Detect if the sequence is protein
    Check if the sequence contains amino acids beyond typical DNA bases
    """
    dna_bases = set('ATCGNatcgn-')
    seq_chars = set(str(sequence))
    return not seq_chars.issubset(dna_bases)

def get_reference_lengths(ref_file):
    """
    Get sequence length information for each locus from reference sequences
    Returns a dictionary containing mean and max lengths for each locus
    """
    locus_lengths = defaultdict(list)
    is_protein = None
    
    try:
        # Read reference sequences
        records = list(SeqIO.parse(ref_file, "fasta"))
        if not records:
            logging.error(f"Reference file {ref_file} is empty or not in FASTA format")
            sys.exit(1)
            
        for record in records:
            # Get locus ID (content after the last '-')
            try:
                locus = record.id.split('-')[-1]
            except IndexError:
                logging.error(f"Invalid sequence ID format in reference file: {record.id}")
                sys.exit(1)
                
            seq_len = len(record.seq)
            
            # Check sequence type for first sequence
            if is_protein is None:
                is_protein = is_protein_sequence(record.seq)
            
            # Multiply length by 3 if protein sequence
            if is_protein:
                seq_len *= 3
                
            locus_lengths[locus].append(seq_len)
    except Exception as e:
        logging.error(f"Error processing reference file: {str(e)}")
        sys.exit(1)
    
    # Calculate mean and max values for each locus
    locus_stats = {}
    for locus, lengths in locus_lengths.items():
        locus_stats[locus] = {
            'mean': sum(lengths) / len(lengths),
            'max': max(lengths)
        }
    
    return locus_stats

def process_fasta_file(args):
    """
    Process a single fasta file
    """
    fasta_file, ref_stats, min_length, mean_length_ratio, max_length_ratio, output_dir = args
    
    try:
        # Extract locus ID from filename
        filename = Path(fasta_file).stem
        if '_paralogs_all' in filename:
            locus = filename.split('_paralogs_all')[0]
        else:
            locus = filename
        
        filtered_records = []
        removed_info = []
        
        # Get reference sequence statistics
        ref_locus_stats = ref_stats.get(locus, {'mean': 0, 'max': 0})
        
        # Read sequences
        with open(fasta_file, 'r') as f:
            sequences = []
            current_seq = {'id': '', 'seq': ''}
            for line in f:
                line = line.strip()
                if line.startswith('>'):
                    if current_seq['id']:
                        sequences.append(current_seq)
                        current_seq = {'id': '', 'seq': ''}
                    current_seq['id'] = line[1:]
                else:
                    current_seq['seq'] += line
            if current_seq['id']:
                sequences.append(current_seq)
        
        if not sequences:
            logging.error(f"No valid sequences found in {fasta_file}")
            return []
            
        # Process sequences
        for seq in sequences:
            seq_len = len(seq['seq'])
            keep_seq = True
            mean_length_ratio = 0.0
            max_length_ratio = 0.0
            
            # Calculate ratios (if reference sequences exist)
            if ref_locus_stats['mean'] > 0:
                mean_length_ratio = seq_len / ref_locus_stats['mean']
            if ref_locus_stats['max'] > 0:
                max_length_ratio = seq_len / ref_locus_stats['max']
            
            # Check conditions
            if min_length > 0 and seq_len < min_length:
                keep_seq = False
            if mean_length_ratio > 0 and seq_len / ref_locus_stats['mean'] < mean_length_ratio:
                keep_seq = False
            if max_length_ratio > 0 and seq_len / ref_locus_stats['max'] < max_length_ratio:
                keep_seq = False
                
            if not keep_seq:
                removed_info.append([
                    os.path.basename(fasta_file),
                    seq['id'],
                    seq_len,
                    round(seq_len / ref_locus_stats['mean'], 3),
                    round(seq_len / ref_locus_stats['max'], 3)
                ])
            else:
                filtered_records.append(f">{seq['id']}\n{seq['seq']}\n")
        
        # Write filtered sequences
        if filtered_records:
            if output_dir:
                # Write to new location if output directory is specified
                output_file = os.path.join(output_dir, os.path.basename(fasta_file))
                with open(output_file, 'w') as f:
                    f.write(''.join(filtered_records))
            else:
                # Overwrite original file if no output directory specified
                with open(fasta_file, 'w') as f:
                    f.write(''.join(filtered_records))
        elif not output_dir and os.path.exists(fasta_file):
            # Remove original file if no output directory specified
            os.remove(fasta_file)
        
        return removed_info
        
    except Exception as e:
        logging.error(f"Error processing file {fasta_file}: {str(e)}")
        return []

def main():
    parser = argparse.ArgumentParser(
        description="Filter sequences by length using various criteria. Part of HybSuite.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    
    parser.add_argument("-i", "--input", required=True,
                        help="Directory containing fasta files")
    parser.add_argument("-r", "--ref", help="Reference sequences file")
    parser.add_argument("-or", "--output_report", help="Output TSV file for removed sequences info")
    parser.add_argument("--output_dir", 
                        help="Directory for filtered sequences (if not specified, original files will be modified)")
    parser.add_argument("--min_length", type=int, default=0,
                        help="Minimum absolute sequence length")
    parser.add_argument("--mean_length_ratio", type=float, default=0,
                        help="Minimum ratio relative to mean length of reference sequences")
    parser.add_argument("--max_length_ratio", type=float, default=0,
                        help="Minimum ratio relative to max length of reference sequences")
    parser.add_argument("-t", "--threads", type=int, default=1,
                        help="Number of threads to use")
    
    args = parser.parse_args()
    
    # Set logging format
    logging.basicConfig(
        level=logging.INFO,
        format='[%(asctime)s] [%(levelname)s] %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )
    
    # Initial information about the script and filtering criteria
    logging.info(f"Filtering sequences by length using {os.path.basename(__file__)}")
    
    # Display active filtering criteria
    filter_modes = []
    if args.min_length > 0:
        filter_modes.append(f"minimum length: {args.min_length} bp")
    if args.mean_length_ratio > 0:
        filter_modes.append(f"minimum mean length ratio: {args.mean_length_ratio}")
    if args.max_length_ratio > 0:
        filter_modes.append(f"minimum max length ratio: {args.max_length_ratio}")
    
    if filter_modes:
        logging.info("Active filtering criteria: " + "; ".join(filter_modes))
    else:
        logging.info("No filtering criteria specified. All sequences will be retained.")
    
    # Check input directory
    if not os.path.isdir(args.input):
        logging.error(f"Input directory {args.input} does not exist")
        sys.exit(1)
    
    # Create output directory if specified
    if args.output_dir:
        os.makedirs(args.output_dir, exist_ok=True)
        logging.info(f"Filtered sequences will be written to directory: {args.output_dir}")
    else:
        logging.info("No output directory specified. Original files will be modified.")
    
    # Get all fasta files with case-insensitive extensions
    fasta_files = [f for f in os.listdir(args.input) 
                   if any(f.lower().endswith(ext) for ext in 
                         ('.fa', '.fasta', '.fna', '.fas', '.FNA', '.FASTA'))]
    
    if not fasta_files:
        logging.error(f"No fasta files found in {args.input}")
        sys.exit(1)
    
    # Read reference sequence information if provided
    ref_stats = {}
    if args.ref:
        if not os.path.exists(args.ref):
            logging.error(f"Reference file {args.ref} does not exist")
            sys.exit(1)
        logging.info("Reading reference sequences...")
        ref_stats = get_reference_lengths(args.ref)
    
    # Prepare multiprocessing arguments
    process_args = [(os.path.join(args.input, f), 
                    ref_stats,
                    args.min_length,
                    args.mean_length_ratio,
                    args.max_length_ratio,
                    args.output_dir) for f in fasta_files]
    
    # Process files with multiple threads
    logging.info(f"Processing {len(fasta_files)} files with {args.threads} threads...")
    with mp.Pool(args.threads) as pool:
        results = pool.map(process_fasta_file, process_args)
    
    # Combine all removed sequence information
    all_removed = []
    for result in results:
        if result:
            all_removed.extend(result)
    
    # Write removed sequence information
    if all_removed and args.output_report:
        df = pd.DataFrame(all_removed, columns=[
            'File', 'Sequence_ID', 'Length', 
            'Mean_Length_Ratio', 'Max_Length_Ratio'
        ])
        df.to_csv(args.output_report, sep='\t', index=False)
        logging.info(f"Removed {len(all_removed)} sequences. Information written to {args.output_report}")
    else:
        logging.info("No sequences were removed.")
    
    logging.info("Processing complete!")

if __name__ == "__main__":
    main()