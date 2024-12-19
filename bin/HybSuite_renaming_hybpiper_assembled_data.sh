#!/bin/bash
  echo "........>>>> One Single Run"
  echo " _     _                 _          ________               _     "
  echo "| |   | |               | |        / _______|             |_|     _  "
  echo "| |   | |               | |        | |_         _     _    _    _| |_    ______        "
  echo "| |___| |  __      __   | |____     \_ \_      | |   | |  | |  |_   _|  /  ____|    "
  echo "|  ___  |  \ \    / /   |  ___ \      \_ \_    | |   | |  | |    | |    | |____    "
  echo "| |   | |   \ \  / /    | |   \ \       \_ \   | |   | |  | |    | |    |  ____|"
  echo "| |   | |    \ \/ /     | |___/ /   ______| |  | |___| |  | |    | |_   | |____  "
  echo "|_|   |_|     \  /      |______/   |________/   \_____/   |_|    |__/   \______|              "
  echo "              / /                                     "
  echo "             / /           "
  echo "            /_/            HybSuite_renaming_hybpiper_assembled_data.sh"
  echo ""
if [ -z "$1" ]; then
  echo "bash HybSuite_renaming_hybpiper_assembled_data.sh <DIR> <previous_name> <new_name>"
  echo "[HybSuite-ERROR]:   Please provide the 'hybpiper assemble' resulting folder that you plan to rename."
  exit 1
fi
if [ "$1" = "-h" ]; then
  echo "This script is used to rename the folder produced by 'hybpiper assemble'"
  echo "General use:"
  echo "bash HybSuite_renaming_hybpiper_assembled_data.sh <DIR> <old_name> <new_name>"
  exit 1
fi
if [ -z "$2" ]; then
  echo "bash HybSuite_renaming_hybpiper_assembled_data.sh <DIR> <old_name> <new_name>"
  echo "[HybSuite-ERROR]:   Please provide the previous name."
  exit 1
else
  old_name="$2"
fi

if [ -z "$3" ]; then
  echo "bash HybSuite_renaming_hybpiper_assembled_data.sh <DIR> <old_name> <new_name>"
  echo "[HybSuite-ERROR]:   Please provide the new name."
  exit 1
else
  new_name="$3"
fi

TARGET_DIR="$1"

rename_files() {
    find "$1" -type f | while read entry; do
        dir=$(dirname "$entry")
        base=$(basename "$entry")
        new_base=$(echo "$base" | sed "s/$old_name/$new_name/g")
        if [ "$base" != "$new_base" ]; then
            mv "$entry" "$dir/$new_base"
            echo "[HybSuite-INFO]:    Renaming the filename: $entry -> $dir/$new_base"
        fi
    done
}

# Rename characters in contents of files
replace_content_in_files() {
    find "$1" -type f | while read file; do
        sed -i "s/$old_name/$new_name/g" "$file"
        echo "[HybSuite-INFO]:    Renaming contents of the file: $file"
    done
}

# Rename the characters in the specified folder step by step
rename_dirs() {
    # Use "-depth" options to handle subdirectories, and then handle parent directories
    find "$1" -depth -type d | while read entry; do
        dir=$(dirname "$entry")
        base=$(basename "$entry")

        # rename the characters
        new_base=$(echo "$base" | sed -e "s/$old_name/$new_name/g")

        # Rename files
        if [ "$base" != "$new_base" ]; then
            mv "$entry" "$dir/$new_base"
            echo "[HybSuite-INFO]:    Renaming the directory: $entry -> $dir/$new_base"
        fi
    done
}

replace_content_in_files "$TARGET_DIR"
rename_files "$TARGET_DIR"
rename_dirs "$TARGET_DIR"
