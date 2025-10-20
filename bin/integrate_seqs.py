#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Function: Integrate the fasta files of each species in the input directory into the output directory according to the locus.
"""

import os
import sys
import argparse
import re
from pathlib import Path
from datetime import datetime

current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
GREEN = "\033[0;32m"
RESET = "\033[0m"
RED = "\033[0;31m"

def read_locus_list(locus_list_file):
    """
    Read the locus list file, return the set of locus names
    """
    loci = set()
    with open(locus_list_file, 'r') as f:
        for line in f:
            line = line.strip()
            if line:  # Ignore empty lines
                loci.add(line)
    return loci


def read_sample_list(sample_list_file):
    """
    Read the sample list file, return the set of sample names
    """
    samples = set()
    with open(sample_list_file, 'r') as f:
        for line in f:
            line = line.strip()
            if line:  # Ignore empty lines
                samples.add(line)
    return samples


def detect_fasta_format(fasta_file):
    """
    Detect the format of the fasta file
    Return: 'old' represents the old format (>locus_name ...)
          'new' represents the new format (>... [gene=locus_name] ...)
    """
    with open(fasta_file, 'r') as f:
        for line in f:
            line = line.strip()
            if line.startswith('>'):
                # Check if it contains the [gene=...] label
                if '[gene=' in line:
                    return 'new'
                else:
                    return 'old'
    # Default return the old format
    return 'old'


def parse_fasta(fasta_file, locus_list=None):
    """
    Parse the fasta file, return the dictionary {locus_name: [sequence1, sequence2, ...]}
    Each locus maps to a list of sequences (to handle multi-copy genes)
    If the locus_list is provided, only return the loci in the list
    """
    # Detect the file format
    file_format = detect_fasta_format(fasta_file)
    
    loci = {}
    current_locus = None
    current_seq = []
    
    with open(fasta_file, 'r') as f:
        for line in f:
            line = line.strip()
            if line.startswith('>'):
                # Save the sequence of the previous locus
                if current_locus is not None and current_seq:
                    # If the locus list is provided, check if it is in the list
                    if locus_list is None or current_locus in locus_list:
                        sequence = ''.join(current_seq)
                        if current_locus not in loci:
                            loci[current_locus] = []
                        loci[current_locus].append(sequence)
                
                # Extract the locus name according to the format
                if file_format == 'new':
                    # New format: extract the locus name from [gene=locus_name]
                    match = re.search(r'\[gene=([^\]]+)\]', line)
                    if match:
                        current_locus = match.group(1)
                    else:
                        current_locus = None
                else:
                    # Old format: the first word after >
                    current_locus = line[1:].split()[0]
                
                current_seq = []
            else:
                # Accumulate the sequence (only accumulate when there is a valid locus)
                if current_locus is not None:
                    current_seq.append(line)
        
        # Save the last locus
        if current_locus is not None and current_seq:
            if locus_list is None or current_locus in locus_list:
                sequence = ''.join(current_seq)
                if current_locus not in loci:
                    loci[current_locus] = []
                loci[current_locus].append(sequence)
    
    return loci


def find_locus_file(output_dir, locus_name, output_suffix):
    """
    Find the corresponding locus file in the output directory
    Support .fasta, .fa, .FNA suffix
    """
    for ext in ['fasta', 'fa', 'FNA']:
        file_path = os.path.join(output_dir, f"{locus_name}{output_suffix}.{ext}")
        if os.path.exists(file_path):
            return file_path
    # If it does not exist, return the default .fasta file name
    return os.path.join(output_dir, f"{locus_name}{output_suffix}")


def integrate_sequences(input_dir, output_dir, output_suffix, locus_list=None, sample_list=None, log_file=None, single_copy=False):
    """
    Integrate all fasta files in the input directory into the output directory
    If the locus_list is provided, only process the loci in the list
    If the sample_list is provided, only process the samples in the list
    If single_copy is True, keep only the longest sequence for multi-copy genes
    If single_copy is False (default), keep all sequences with special naming
    """
    # Create the output directory
    os.makedirs(output_dir, exist_ok=True)
    
    message = f"[{current_time}] [INFO] Input directory: {input_dir}\n"
    print(message, end="")
    with open(log_file, "a") as f:
        f.write(message)
    
    message = f"[{current_time}] [INFO] Output directory: {output_dir}\n"
    print(message, end="")
    with open(log_file, "a") as f:
        f.write(message)
    
    if locus_list:
        message = f"[{current_time}] [INFO] Locus list: {len(locus_list)} loci specified\n"
        print(message, end="")
        with open(log_file, "a") as f:
            f.write(message)
    
    if sample_list:
        message = f"[{current_time}] [INFO] Sample list: {len(sample_list)} samples specified\n"
        print(message, end="")
        with open(log_file, "a") as f:
            f.write(message)
    
    if single_copy:
        message = f"[{current_time}] [INFO] Single-copy mode: Only the longest pre-assembled sequence of each locus will be integrated.\n"
        print(message, end="")
        with open(log_file, "a") as f:
            f.write(message)
    else:
        message = f"[{current_time}] [INFO] Multi-copy mode (default): All pre-assembled sequences including multi-copy genes will be integrated.\n"
        print(message, end="")
        with open(log_file, "a") as f:
            f.write(message)
    
    # Supported fasta file extensions
    extensions = ['*.fasta', '*.fa', '*.FNA']
    
    # Get all fasta files
    fasta_files = []
    for ext in extensions:
        fasta_files.extend(Path(input_dir).glob(ext))
    
    if not fasta_files:
        message = f"[{current_time}] [WARNING] No fasta files found in the input directory\n"
        print(f"{RED}{message}{RESET}", end="")
        with open(log_file, "a") as f:
            f.write(message)
        return
    
    # Process each fasta file
    for fasta_file in fasta_files:
        # Get the species name (file name without extension)
        species_name = fasta_file.stem
        
        # If sample list is provided, check if this sample is in the list
        if sample_list is not None and species_name not in sample_list:
            continue
        
        # Parse the fasta file (pass the locus list for filtering)
        loci = parse_fasta(fasta_file, locus_list)
        
        if not loci:
            message = f"[{current_time}] [WARNING] No matching locus found for {species_name}\n"
            print(f"{RED}{message}{RESET}", end="")
            with open(log_file, "a") as f:
                f.write(message)
            continue
        
        # Write the sequence of each locus to the corresponding output file
        for locus_name, sequences in loci.items():
            output_file = find_locus_file(output_dir, locus_name, output_suffix)
            
            # Sort sequences by length (longest first)
            sorted_seqs = sorted(sequences, key=len, reverse=True)
            
            if single_copy:
                # Single-copy mode: Only keep the longest sequence
                with open(output_file, 'a') as f:
                    f.write(f">{species_name} single_hit\n")
                    f.write(f"{sorted_seqs[0]}\n")
            else:
                # Multi-copy mode (default): Keep all sequences
                if len(sorted_seqs) == 1:
                    # Only one sequence for this locus: use simple naming
                    with open(output_file, 'a') as f:
                        f.write(f">{species_name} single_hit\n")
                        f.write(f"{sorted_seqs[0]}\n")
                else:
                    # Multiple sequences for this locus: use .main and NODE naming
                    # Write the longest sequence with ".main single_hit"
                    with open(output_file, 'a') as f:
                        f.write(f">{species_name}.main single_hit\n")
                        f.write(f"{sorted_seqs[0]}\n")
                    
                    # Write other sequences with NODE naming
                    for idx, seq in enumerate(sorted_seqs[1:]):
                        with open(output_file, 'a') as f:
                            node_num = idx + 1
                            f.write(f">{species_name}.{idx} NODE_{node_num}_length_{len(seq)}\n")
                            f.write(f"{seq}\n")
        
        # Count total sequences
        total_seqs = sum(len(seqs) for seqs in loci.values())
        message = f"[{current_time}] [INFO] Finished integrating species: {species_name} ({len(loci)} loci, {total_seqs} sequences)\n"
        print(f"{GREEN}{message}{RESET}", end="")
        with open(log_file, "a") as f:
            f.write(message)
    
    message = f"[{current_time}] [INFO] All pre-assembled sequences have been integrated into the output directory!\n"
    print(f"{GREEN}{message}{RESET}", end="")
    with open(log_file, "a") as f:
        f.write(message)

def main():
    parser = argparse.ArgumentParser(
        description='Integrate the fasta files of each species in the input directory into the output directory according to the locus. Part of HybSuite.',
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    
    parser.add_argument('-i', '--input', required=True,
                        help='Input directory, containing the pre-assembled sequences in fasta files of each species')
    parser.add_argument('-o', '--output', required=True,
                        help='Output directory, for storing the fasta files integrated according to the locus')
    parser.add_argument('-s', '--suffix',
                        help='Output file suffix (e.g., ".fasta" or "_aligned"). Default: ".fasta"', 
                        default='.fasta')
    parser.add_argument('--locus_list', required=False,
                        help='Locus list file (optional), one locus name per line. If provided, only the loci in this list will be processed')
    parser.add_argument('--sample_list', required=False,
                        help='Sample list file (optional), one sample name per line. If provided, only the samples in this list will be processed. Sample names should match the fasta file names (without extension)')
    parser.add_argument('-l', '--log', required=False,
                        help='Log file path. Default: ./Integrate_seqs.log', 
                        default='./Integrate_seqs.log')
    parser.add_argument('--single_copy', action='store_true',
                        help='Single-copy mode: Only keep the longest sequence for multi-copy genes. By default (multi-copy mode), all sequences will be kept with special naming - the longest sequence will be named as "species.main single_hit", and others as "species.0 NODE_1_length_XXX", "species.1 NODE_2_length_XXX", etc.')

    args = parser.parse_args()
    
    message = f'[{current_time}] [INFO] Running integrate_seqs.py...\n'
    print(message, end="")
    with open(args.log, "a") as f:
        f.write(message)
    
    # Check the input directory
    if not os.path.isdir(args.input):
        message = f"[{current_time}] [ERROR] Input directory does not exist: {args.input}\n"
        print(f"{RED}{message}{RESET}", end="")
        with open(args.log, "a") as f:
            f.write(message)
        sys.exit(1)
    
    # Read the locus list (if provided)
    locus_list = None
    if args.locus_list:
        if not os.path.isfile(args.locus_list):
            message = f"[{current_time}] [ERROR] Locus list file does not exist: {args.locus_list}\n"
            print(f"{RED}{message}{RESET}", end="")
            with open(args.log, "a") as f:
                f.write(message)
            sys.exit(1)
        locus_list = read_locus_list(args.locus_list)
    
    # Read the sample list (if provided)
    sample_list = None
    if args.sample_list:
        if not os.path.isfile(args.sample_list):
            message = f"[{current_time}] [ERROR] Sample list file does not exist: {args.sample_list}\n"
            print(f"{RED}{message}{RESET}", end="")
            with open(args.log, "a") as f:
                f.write(message)
            sys.exit(1)
        sample_list = read_sample_list(args.sample_list)
    
    # Execute the integration
    integrate_sequences(args.input, args.output, args.suffix, locus_list, sample_list, args.log, args.single_copy)


if __name__ == '__main__':
    main()

