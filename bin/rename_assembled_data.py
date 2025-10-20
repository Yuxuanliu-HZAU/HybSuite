#!/usr/bin/env python3
import os
import argparse
import sys

def print_banner():
    banner = r"""
    ........>>>> One Single Run
     _     _                 _          ________               _     
    | |   | |               | |        / _______|             |_|     _  
    | |   | |               | |        | |_         _     _    _    _| |_    ______        
    | |___| |  __      __   | |____     \_ \_      | |   | |  | |  |_   _|  /  ____|    
    |  ___  |  \ \    / /   |  ___ \      \_ \_    | |   | |  | |    | |    | |____    
    | |   | |   \ \  / /    | |   \ \       \_ \   | |   | |  | |    | |    |  ____|
    | |   | |    \ \/ /     | |___/ /   ______| |  | |___| |  | |    | |_   | |____  
    |_|   |_|     \  /      |______/   |________/   \_____/   |_|    |__/   \______|              
                  / /                                     
                 / /           
                /_/            HybSuite Renaming Assembled Data Tool
    """
    print(banner)

def replace_content_in_files(directory, old_name, new_name):
    """Replace the specified string in the file content"""
    success = True
    modified_files = []  # Store
    
    try:
        for root, _, files in os.walk(directory):
            for file in files:
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r') as f:
                        content = f.read()
                    
                    if old_name in content:  # Only process files containing the old name
                        modified_files.append(file_path)
                        content = content.replace(old_name, new_name)
                        with open(file_path, 'w') as f:
                            f.write(content)
                        
                        # Verify if the content of this specific file is correctly replaced
                        with open(file_path, 'r') as f:
                            new_content = f.read()
                            if old_name in new_content:
                                success = False
                                break
                except Exception:
                    continue  # Skip files that cannot be read/written
                    
    except Exception:
        success = False
    
    return success

def rename_files(directory, old_name, new_name):
    """Rename the specified string in the file name"""
    success = True
    rename_operations = []  # Store the file information to be renamed
    
    try:
        # First collect all the files to be renamed
        for root, _, files in os.walk(directory):
            for file in files:
                if old_name in file:
                    old_path = os.path.join(root, file)
                    new_file = file.replace(old_name, new_name)
                    new_path = os.path.join(root, new_file)
                    rename_operations.append((old_path, new_path))
        
        # Execute the renaming operation
        for old_path, new_path in rename_operations:
            os.rename(old_path, new_path)
            # Verify if this specific renaming operation is successful
            if os.path.exists(old_path) or not os.path.exists(new_path):
                success = False
                break
                
    except Exception as e:
        success = False
    return success

def rename_dirs(directory, old_name, new_name):
    """Rename the specified string in the directory name"""
    success = True
    rename_operations = []  # Store the directory information to be renamed
    
    try:
        # First collect all the directories to be renamed
        for root, dirs, _ in os.walk(directory, topdown=False):
            for dir_name in dirs:
                if old_name in dir_name:
                    old_path = os.path.join(root, dir_name)
                    new_dir = dir_name.replace(old_name, new_name)
                    new_path = os.path.join(root, new_dir)
                    rename_operations.append((old_path, new_path))
        
        # Execute the renaming operation
        for old_path, new_path in rename_operations:
            if not os.path.exists(new_path):  # Ensure the target path does not exist
                os.rename(old_path, new_path)
                # Verify if this specific renaming operation is successful
                if os.path.exists(old_path) or not os.path.exists(new_path):
                    success = False
                    break
                    
    except Exception as e:
        success = False
    return success

def rename_root_dir(directory_path, old_name, new_name):
    """Rename the root directory"""
    success = True
    try:
        parent_dir = os.path.dirname(os.path.abspath(directory_path))
        os.chdir(parent_dir)
        os.rename(old_name, new_name)
        # Verify if the root directory renaming is successful
        if not os.path.exists(new_name) or os.path.exists(old_name):
            success = False
    except Exception:
        success = False
    return success

def read_rename_list(rename_list_file):
    """Read the rename list file"""
    rename_pairs = []
    try:
        with open(rename_list_file, 'r') as f:
            for line in f:
                if line.strip():  # Skip empty lines
                    parts = line.strip().split('\t')
                    if len(parts) == 2:
                        old_name, new_name = parts
                        rename_pairs.append((old_name.strip(), new_name.strip()))
                    else:
                        print(f"[HybSuite-WARNING]: Skipping invalid line in rename list: {line.strip()}")
    except Exception as e:
        print(f"[HybSuite-ERROR]: Failed to read rename list file: {str(e)}")
        sys.exit(1)
    return rename_pairs

def process_single_directory(input_dir, old_name, new_name):
    """Process the renaming operation for a single directory"""
    success = True
    
    # Execute the renaming operation
    content_success = replace_content_in_files(input_dir, old_name, new_name)
    files_success = rename_files(input_dir, old_name, new_name)
    dirs_success = rename_dirs(input_dir, old_name, new_name)
    
    # Rename the root directory
    parent_dir = os.path.dirname(os.path.abspath(input_dir))
    os.chdir(parent_dir)
    try:
        if os.path.exists(new_name):
            print(f"[HybSuite-WARNING]: Target directory {new_name} already exists, skipping root directory rename")
        else:
            os.rename(old_name, new_name)
            if os.path.exists(old_name) or not os.path.exists(new_name):
                success = False
    except Exception:
        success = False
    
    return all([content_success, files_success, dirs_success, success])

def main():
    print_banner()
    parser = argparse.ArgumentParser(description='Rename hybpiper assembled data')
    
    # Create mutually exclusive parameter groups
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('-i', '--input', help='Input directory path')
    group.add_argument('--rename_list', help='Path to tab-delimited file containing old_name and new_name pairs')
    
    # Other parameters
    parser.add_argument('-n', '--new_name', help='New name to replace with (required if -i is used)')
    parser.add_argument('-p', '--parent_dir', help='Parent directory containing the folders to be processed (required if --rename_list is used)')
    
    args = parser.parse_args()
    
    # Define color codes
    GREEN = '\033[32m'
    RED = '\033[31m'
    RESET = '\033[0m'
    
    # Process the single directory case
    if args.input:
        if not args.new_name:
            print("[HybSuite-ERROR]: --new_name is required when using --input")
            sys.exit(1)
            
        if not os.path.isdir(args.input):
            print(f"[HybSuite-ERROR]: Directory {args.input} does not exist!")
            sys.exit(1)
        
        success = process_single_directory(args.input, os.path.basename(args.input.rstrip('/')), args.new_name)
        
        if success:
            print(f"{GREEN}[HybSuite-SUCCESS]: Renaming operation completed successfully!{RESET}")
        else:
            print(f"{RED}[HybSuite-ERROR]: Some renaming operations failed.{RESET}")
            sys.exit(1)
    
    # Process the batch renaming case
    else:
        if not args.parent_dir:
            print("[HybSuite-ERROR]: --parent_dir is required when using --rename_list")
            sys.exit(1)
            
        if not os.path.isdir(args.parent_dir):
            print(f"[HybSuite-ERROR]: Parent directory {args.parent_dir} does not exist!")
            sys.exit(1)
        
        rename_pairs = read_rename_list(args.rename_list)
        if not rename_pairs:
            print("[HybSuite-ERROR]: No valid rename pairs found in the rename list file")
            sys.exit(1)
        
        all_success = True
        processed_count = 0
        failed_count = 0
        
        for old_name, new_name in rename_pairs:
            input_dir = os.path.join(args.parent_dir, old_name)
            
            if not os.path.isdir(input_dir):
                print(f"{RED}[HybSuite-ERROR]: Directory not found: {input_dir}{RESET}")
                failed_count += 1
                continue
            
            print(f"Processing: {old_name} -> {new_name}")
            success = process_single_directory(input_dir, old_name, new_name)
            
            if success:
                processed_count += 1
            else:
                failed_count += 1
                all_success = False
        
        # Output the final statistics
        print(f"\nSummary:")
        print(f"Total directories processed: {len(rename_pairs)}")
        print(f"Successfully processed: {processed_count}")
        print(f"Failed: {failed_count}")
        
        if all_success:
            print(f"{GREEN}[HybSuite-SUCCESS]: All renaming operations completed successfully!{RESET}")
        else:
            print(f"{RED}[HybSuite-ERROR]: Some renaming operations failed. Please check the output above.{RESET}")
            sys.exit(1)

if __name__ == "__main__":
    main()