#!/usr/bin/env python3

import argparse
import os
import sys
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
from typing import Tuple, List
import threading
import logging
from datetime import datetime

# Configure logging
logging.basicConfig(
    format='[%(asctime)s] [%(levelname)s] %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
    level=logging.INFO
)
logger = logging.getLogger(__name__)

def show_help():
    """Display help message"""
    return """
HybSuite: FASTA Sequence Formatter

Description:
    This script reformats FASTA sequences into either interleaved (60 characters per line)
    or single-line format. Supports multi-threading for faster processing.
    """

def parse_arguments():
    """Parse command line arguments"""
    parser = argparse.ArgumentParser(
        description=show_help(),
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument('-i', '--input', 
                        required=True,
                        help='Input FASTA file')
    parser.add_argument('-o', '--output',
                        required=True,
                        help='Output file path')
    parser.add_argument('-nt', '--threads',
                        type=int,
                        default=1,
                        help='Number of threads (default: 1)')
    format_group = parser.add_mutually_exclusive_group(required=True)
    format_group.add_argument('--inter', 
                             action='store_true',
                             help='Output in interleaved format (60 characters per line)')
    format_group.add_argument('--single',
                             action='store_true',
                             help='Output in single-line format')
    
    return parser.parse_args()

def check_files(input_file, output_file):
    """Check if input file exists and output directory is writable"""
    # Check input file
    if not os.path.exists(input_file):
        logger.error(f"Input file '{input_file}' does not exist")
        sys.exit(1)
    if not os.access(input_file, os.R_OK):
        logger.error(f"Input file '{input_file}' is not readable")
        sys.exit(1)

    # Check output directory
    output_dir = os.path.dirname(output_file)
    if output_dir:
        if not os.path.exists(output_dir):
            try:
                os.makedirs(output_dir)
            except OSError:
                logger.error(f"Cannot create output directory '{output_dir}'")
                sys.exit(1)
        if not os.access(output_dir, os.W_OK):
            logger.error(f"Output directory '{output_dir}' is not writable")
            sys.exit(1)

def read_fasta_chunks(input_file: str, chunk_size: int = 1000) -> List[Tuple[str, str]]:
    """Read FASTA file and return chunks of sequences"""
    sequences = []
    current_header = ""
    current_sequence = ""
    
    with open(input_file, 'r') as f:
        for line in f:
            line = line.strip()
            if line.startswith('>'):
                if current_header:
                    sequences.append((current_header, current_sequence))
                current_header = line
                current_sequence = ""
            else:
                current_sequence += line.replace(" ", "")
                
    if current_header:  # Add the last sequence
        sequences.append((current_header, current_sequence))
    
    # Split into chunks
    return [sequences[i:i + chunk_size] for i in range(0, len(sequences), chunk_size)]

def format_sequence(header: str, sequence: str, interleaved: bool) -> str:
    """Format a single sequence according to the specified format"""
    if interleaved:
        formatted = header + '\n'
        for i in range(0, len(sequence), 60):
            formatted += sequence[i:i+60] + '\n'
        return formatted
    else:
        return f"{header}\n{sequence}\n"

def process_chunk(chunk: List[Tuple[str, str]], interleaved: bool) -> str:
    """Process a chunk of sequences"""
    return ''.join(format_sequence(header, seq, interleaved) 
                  for header, seq in chunk)

def process_fasta(input_file: str, output_file: str, interleaved: bool, num_threads: int):
    """Process FASTA file using multiple threads"""
    try:
        # Read sequences in chunks
        chunks = read_fasta_chunks(input_file)
        
        # Process chunks using thread pool
        with ThreadPoolExecutor(max_workers=num_threads) as executor:
            # Create a list of futures
            futures = [executor.submit(process_chunk, chunk, interleaved) 
                      for chunk in chunks]
            
            # Write results as they complete
            with open(output_file, 'w') as outfile:
                for future in futures:
                    outfile.write(future.result())
                    
    except Exception as e:
        logger.error(f"Failed to process file: {str(e)}")
        sys.exit(1)

def main():
    """Main function"""
    args = parse_arguments()
    check_files(args.input, args.output)
    
    # Ensure number of threads is valid
    num_threads = max(1, min(args.threads, os.cpu_count() or 1))
    
    # Process file with specified format
    process_fasta(args.input, args.output, args.inter, num_threads)
    
    logger.info(f"Successfully processed {args.input}")
    logger.info(f"Output written to {args.output}")
    logger.info(f"Used {num_threads} thread{'s' if num_threads > 1 else ''}")

if __name__ == "__main__":
    main()