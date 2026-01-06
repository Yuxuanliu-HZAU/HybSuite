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
          'captus' represents the Captus format (>Species_name__locus_name__ ... or >Species_name__locus_name ...)
    """
    with open(fasta_file, 'r') as f:
        for line in f:
            line = line.strip()
            if line.startswith('>'):
                # Check if it contains the [gene=...] label
                if '[gene=' in line:
                    return 'new'
                # Check if it contains double underscores (Captus format)
                # Format: >Species_name__locus_name__ or >Species_name__locus_name
                elif '__' in line:
                    # Extract the first word after >
                    first_word = line[1:].split()[0]
                    # Check if it contains at least one double underscore
                    if '__' in first_word:
                        return 'captus'
                    else:
                        return 'old'
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
                elif file_format == 'captus':
                    # Captus format: >Species_name__locus_name__ or >Species_name__locus_name
                    # Extract the first word after >
                    first_word = line[1:].split()[0]
                    # Split by double underscores
                    parts = first_word.split('__')
                    if len(parts) >= 2:
                        # The second part is the locus name
                        # e.g., Spiraea_canescens__6016 -> 6016
                        # e.g., Spiraea_canescens__6026__00 -> 6026
                        current_locus = parts[1]
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
    # If it does not exist, determine a sensible default:
    # - If the suffix itself already looks like an extension (.fasta/.fa/.FNA),
    #   use <locus_name><suffix> (e.g. 6016.fasta).
    # - Otherwise, append a .fasta extension (e.g. 6016_paralogs_all.fasta).
    lower_suffix = output_suffix.lower()
    if lower_suffix.endswith(('.fasta', '.fa', '.fna')):
        return os.path.join(output_dir, f"{locus_name}{output_suffix}")
    else:
        return os.path.join(output_dir, f"{locus_name}{output_suffix}.fasta")


def integrate_sequences(input_dir, output_dir, output_suffix, locus_list=None, sample_list=None, log_file=None, single_copy=False, per_species_dir=None):
    """
    Integrate all fasta files in the input directory into the output directory
    If the locus_list is provided, only process the loci in the list
    If the sample_list is provided, only process the samples in the list
    If single_copy is True, keep only the longest sequence for multi-copy genes
    If single_copy is False (default), keep all sequences with special naming
    """
    # Create the output directory
    os.makedirs(output_dir, exist_ok=True)

    # Create the per-species output directory (if specified)
    if per_species_dir is not None:
        os.makedirs(per_species_dir, exist_ok=True)
    
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
        message = f"[{current_time}] [WARNING] No fasta files found in the input directory (specified by '-input_data' when running HybSuite main program)\n"
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

        # For per-species export, track the sequences that are actually written
        # for this species and each locus in the integrated (locus-based) output.
        species_locus_seqs_for_export = {}

        # Track whether we have detected any duplicate entries for this species
        # in the existing output files (same species present before integration).
        duplicate_detected_for_species = False

        # Write the sequence of each locus to the corresponding output file
        for locus_name, sequences in loci.items():
            output_file = find_locus_file(output_dir, locus_name, output_suffix)

            # Read existing records for this locus (if any)
            existing_records = []  # list of (header_line, seq_string)
            if os.path.exists(output_file):
                with open(output_file, 'r') as ef:
                    current_header = None
                    current_seq_lines = []
                    for line in ef:
                        line = line.rstrip('\n')
                        if line.startswith('>'):
                            if current_header is not None:
                                existing_records.append((current_header, ''.join(current_seq_lines)))
                            current_header = line
                            current_seq_lines = []
                        else:
                            if current_header is not None:
                                current_seq_lines.append(line)
                    if current_header is not None:
                        existing_records.append((current_header, ''.join(current_seq_lines)))

            # Helper to extract and normalize species name from an existing header line
            def extract_species_from_header(header_line):
                header_body = header_line[1:]
                # Take token up to first space (or whole string if no space)
                if ' ' in header_body:
                    token = header_body.split(' ')[0]
                else:
                    token = header_body

                # Normalize by stripping trailing '.main' or '.<digits>' if present
                if token.endswith('.main'):
                    base_name = token[:-5]
                else:
                    # Check for a trailing .<digits> pattern
                    m = re.match(r"^(.*)\.([0-9]+)$", token)
                    if m:
                        base_name = m.group(1)
                    else:
                        base_name = token

                return base_name

            # Separate existing records into those belonging to this species and others
            existing_species_seqs = []
            other_species_records = []
            for header_line, seq in existing_records:
                species_in_output = extract_species_from_header(header_line)
                if species_in_output == species_name:
                    existing_species_seqs.append(seq)
                else:
                    other_species_records.append((header_line, seq))

            # If we see any existing sequences for this species in the output, report once
            if existing_species_seqs and not duplicate_detected_for_species:
                duplicate_detected_for_species = True
                message = f"[{current_time}] [INFO] Duplicate species detected in output for species: {species_name} (existing sequences will be merged with input)\n"
                print(message, end="")
                with open(log_file, "a") as f:
                    f.write(message)

            # Combine existing sequences (for this species and locus) with new sequences
            combined_seqs = existing_species_seqs + sequences

            # If there are no existing records for this species and locus, keep original behaviour (append only)
            if not existing_species_seqs:
                # Sort sequences by length (longest first)
                sorted_seqs = sorted(sequences, key=len, reverse=True)

                if single_copy:
                    # Single-copy mode: Only keep the longest sequence
                    with open(output_file, 'a') as f:
                        f.write(f">{species_name} single_hit\n")
                        f.write(f"{sorted_seqs[0]}\n")
                    # For per-species export, only the longest sequence is written for this locus
                    species_locus_seqs_for_export[locus_name] = [sorted_seqs[0]]
                else:
                    # Multi-copy mode (default): Keep all sequences
                    if len(sorted_seqs) == 1:
                        # Only one sequence for this locus: use simple naming
                        with open(output_file, 'a') as f:
                            f.write(f">{species_name} single_hit\n")
                            f.write(f"{sorted_seqs[0]}\n")
                        species_locus_seqs_for_export[locus_name] = [sorted_seqs[0]]
                    else:
                        # Multiple sequences for this locus: use .main and NODE naming
                        # Write the longest sequence with ".main NODE naming"
                        with open(output_file, 'a') as f:
                            f.write(f">{species_name}.main NODE_0_length_{len(sorted_seqs[0])}\n")
                            f.write(f"{sorted_seqs[0]}\n")

                        # Write other sequences with NODE naming
                        for idx, seq in enumerate(sorted_seqs[1:]):
                            with open(output_file, 'a') as f:
                                node_num = idx + 1
                                f.write(f">{species_name}.{idx} NODE_{node_num}_length_{len(seq)}\n")
                                f.write(f"{seq}\n")
                        species_locus_seqs_for_export[locus_name] = sorted_seqs
            else:
                # There are existing sequences for this species and locus in the output file.
                # We need to merge them with the new sequences and rewrite the whole locus file.
                if single_copy:
                    # Single-copy mode: keep only the longest sequence across existing + new for this species
                    longest_seq = max(combined_seqs, key=len)

                    with open(output_file, 'w') as f:
                        # First write back all other species records as they were
                        for header_line, seq in other_species_records:
                            f.write(f"{header_line}\n")
                            f.write(f"{seq}\n")

                        # Then write the single-copy record for this species
                        f.write(f">{species_name} single_hit\n")
                        f.write(f"{longest_seq}\n")

                    # For per-species export, only the longest integrated sequence is kept for this locus
                    species_locus_seqs_for_export[locus_name] = [longest_seq]
                else:
                    # Multi-copy mode: keep all sequences (existing + new) for this species
                    sorted_combined = sorted(combined_seqs, key=len, reverse=True)

                    with open(output_file, 'w') as f:
                        # First write back all other species records as they were
                        for header_line, seq in other_species_records:
                            f.write(f"{header_line}\n")
                            f.write(f"{seq}\n")

                        # Then write all sequences for this species with updated naming
                        if len(sorted_combined) == 1:
                            f.write(f">{species_name} single_hit\n")
                            f.write(f"{sorted_combined[0]}\n")
                        else:
                            # Longest sequence as .main
                            f.write(f">{species_name}.main NODE_0_length_{len(sorted_combined[0])}\n")
                            f.write(f"{sorted_combined[0]}\n")

                            # Remaining sequences as NODE_1, NODE_2, ...
                            for idx, seq in enumerate(sorted_combined[1:]):
                                node_num = idx + 1
                                f.write(f">{species_name}.{idx} NODE_{node_num}_length_{len(seq)}\n")
                                f.write(f"{seq}\n")

                    # For per-species export, keep all integrated sequences for this locus
                    species_locus_seqs_for_export[locus_name] = sorted_combined
        
        # After writing all loci for this species, optionally export per-species FASTA
        if per_species_dir is not None and species_locus_seqs_for_export:
            species_output_file = os.path.join(per_species_dir, f"{species_name}.fasta")
            with open(species_output_file, 'w') as sf:
                for locus_name, seqs_for_locus in species_locus_seqs_for_export.items():
                    # seqs_for_locus is already the set of integrated sequences for this species and locus
                    # Sort again by length (longest first) to be explicit
                    sorted_seqs = sorted(seqs_for_locus, key=len, reverse=True)

                    if len(sorted_seqs) == 1:
                        # Single sequence for this locus
                        sf.write(f">{locus_name}\n")
                        sf.write(f"{sorted_seqs[0]}\n")
                    else:
                        # Multiple sequences for this locus
                        # Longest sequence marked as main
                        sf.write(f">{locus_name} main\n")
                        sf.write(f"{sorted_seqs[0]}\n")

                        # Remaining sequences with NODE_NODE_X_length_XXX naming
                        for idx, seq in enumerate(sorted_seqs[1:]):
                            node_num = idx + 1
                            sf.write(f">{locus_name} NODE_NODE_{node_num}_length_{len(seq)}\n")
                            sf.write(f"{seq}\n")

        # Count total sequences
        if single_copy:
            # In single-copy mode, only one sequence per locus is written
            total_seqs = len(loci)
        else:
            # In multi-copy mode, all sequences are written
            total_seqs = sum(len(seqs) for seqs in loci.values())
        
        message = f"[{current_time}] [INFO] Finished integrating species: {species_name} ({len(loci)} loci, {total_seqs} sequences)\n"
        print(f"{GREEN}{message}{RESET}", end="")
        with open(log_file, "a") as f:
            f.write(message)
    
    message = f"[{current_time}] [INFO] All pre-assembled sequences have been integrated into the output directory!\n"
    print(f"{GREEN}{message}{RESET}", end="")
    with open(log_file, "a") as f:
        f.write(message)

    if per_species_dir is not None:
        species_locus_map = {}

        extensions = ['*.fasta', '*.fa', '*.FNA']
        locus_files = []
        for ext in extensions:
            locus_files.extend(Path(output_dir).glob(ext))

        for locus_file in locus_files:
            base_name = locus_file.stem
            if output_suffix and base_name.endswith(output_suffix):
                locus_name = base_name[:-len(output_suffix)]
            else:
                locus_name = base_name

            with open(locus_file, 'r') as lf:
                current_header = None
                current_seq_lines = []
                for line in lf:
                    line = line.rstrip('\n')
                    if line.startswith('>'):
                        if current_header is not None:
                            header_body = current_header[1:]
                            if ' ' in header_body:
                                token = header_body.split(' ')[0]
                            else:
                                token = header_body

                            if token.endswith('.main'):
                                base_species = token[:-5]
                            else:
                                m = re.match(r"^(.*)\.([0-9]+)$", token)
                                if m:
                                    base_species = m.group(1)
                                else:
                                    base_species = token

                            seq = ''.join(current_seq_lines)
                            if seq:
                                if base_species not in species_locus_map:
                                    species_locus_map[base_species] = {}
                                if locus_name not in species_locus_map[base_species]:
                                    species_locus_map[base_species][locus_name] = []
                                species_locus_map[base_species][locus_name].append(seq)

                        current_header = line
                        current_seq_lines = []
                    else:
                        if current_header is not None:
                            current_seq_lines.append(line)

                if current_header is not None:
                    header_body = current_header[1:]
                    if ' ' in header_body:
                        token = header_body.split(' ')[0]
                    else:
                        token = header_body

                    if token.endswith('.main'):
                        base_species = token[:-5]
                    else:
                        m = re.match(r"^(.*)\.([0-9]+)$", token)
                        if m:
                            base_species = m.group(1)
                        else:
                            base_species = token

                    seq = ''.join(current_seq_lines)
                    if seq:
                        if base_species not in species_locus_map:
                            species_locus_map[base_species] = {}
                        if locus_name not in species_locus_map[base_species]:
                            species_locus_map[base_species][locus_name] = []
                        species_locus_map[base_species][locus_name].append(seq)

        for species_name, locus_dict in species_locus_map.items():
            species_output_file = os.path.join(per_species_dir, f"{species_name}.fasta")
            with open(species_output_file, 'w') as sf:
                for locus_name, seqs_for_locus in locus_dict.items():
                    sorted_seqs = sorted(seqs_for_locus, key=len, reverse=True)
                    if len(sorted_seqs) == 1:
                        sf.write(f">{locus_name}\n")
                        sf.write(f"{sorted_seqs[0]}\n")
                    else:
                        sf.write(f">{locus_name} main\n")
                        sf.write(f"{sorted_seqs[0]}\n")
                        for idx, seq in enumerate(sorted_seqs[1:]):
                            node_num = idx + 1
                            sf.write(f">{locus_name} NODE_NODE_{node_num}_length_{len(seq)}\n")
                            sf.write(f"{seq}\n")

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
    parser.add_argument('--per_species_dir', required=False,
                        help='Optional directory for per-species FASTA output. If provided, one file per species will be written as <species_name>.fasta, containing all loci for that species with headers formatted as >locus (single sequence) or >locus main / >locus NODE_NODE_X_length_XXX (for multiple sequences per locus).')

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
    integrate_sequences(args.input, args.output, args.suffix, locus_list, sample_list, args.log, args.single_copy, args.per_species_dir)


if __name__ == '__main__':
    main()

