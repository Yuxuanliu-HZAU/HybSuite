#!/bin/sh
# Script Name: HybSuite.sh
# Author: Yuxuan Liu
#===> Preparation and HybSuite Checking <===#
#Options setting
###set the run name:
current_time=$(date +"%Y-%m-%d_%H:%M:%S")
# Read the variable list file and set the default values
# Obtain the script path
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config_dir="$script_dir/../config"
dependencies_dir="$script_dir/../dependencies"

print_welcome_phrases() {
  echo ""
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
  echo "            /_/            NGS raw data ATGCTACTGATCCAACCT......  >>>>  Trees  "
  echo ""
  echo "================================================================================="
  echo "HybSuite v. 1.1.0 released by the Sun Lab."
  echo "Latest version: https://github.com/Yuxuanliu-HZAU/HybSuite.git"
  echo "================================================================================="
  echo ""
}

# 子命令处理函数
run_subcommand() {
  local subcommand="$1"
  shift  # Remove subcommand argument, pass remaining args to subcommand

  case "$subcommand" in
    "filter_seqs_by_length")
      # Execute filter_seqs_by_length.py script
      "${script_dir}/filter_seqs_by_length.py" "$@"
      return $?
      ;;
    "filter_seqs_by_coverage")
      # Execute filter_seqs_by_sample_and_locus_coverage.py script
      "${script_dir}/filter_seqs_by_sample_and_locus_coverage.py" "$@"
      return $?
      ;;
    "plot_paralog_heatmap")
      # Execute plot_paralog_heatmap.py script
      "${script_dir}/plot_paralog_heatmap.py" "$@"
      return $?
      ;;
    "plot_recovery_heatmap")
      # Execute plot_recovery_heatmap.py script
      "${script_dir}/plot_recovery_heatmap.py" "$@"
      return $?
      ;;
    "rlwp")
      # Execute RLWP.py script
      "${script_dir}/RLWP.py" "$@"
      return $?
      ;;
    "fasta_formatter")
      # Execute Fasta_formatter.py script
      "${script_dir}/Fasta_formatter.py" "$@"
      return $?
      ;;
    "mpp")
      # Execute modified_phypartspiecharts.py script
      "${script_dir}/modified_phypartspiecharts.py" "$@"
      return $?
      ;;
    "full_pipeline")
      full_pipeline=true
      ;;
    "run_to_stage1")
      run_to_stage1=true
      ;;
    "run_to_stage2")
      run_to_stage2=true
      ;;
    "run_to_stage3")
      run_to_stage3=true
      ;;
    "run_to_stage4")
      run_to_stage4=true
      ;;
    "retrieve_results")
      retrieve_results=true
      ;;
  esac
}

display_help() {
  echo ""
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
  echo "             / /        "
  echo "            /_/         NGS raw data ATGCTACTGATCCAACCT......  >>>>  Trees  "
  echo ""
  sed -n '1,$p' $config_dir/HybSuite_help.txt
}

# Function to display the version number
display_version() {
  echo ""
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
  echo "             / /        "
  echo "            /_/            NGS raw data ATGCTACTGATCCAACCT......  >>>>  Trees  "
  echo ""
  echo "                           HybSuite Version: 1.1.0"
  echo ""
}

if [ "$#" -eq 0 ]; then
  echo ""
  echo "[HybSuite-ERROR]: You didn't set any subcommand ."
  echo "                  Please set necessary subcommand to run HybSuite. (use -h to check subcommands)"
  echo "                  HybSuite exits."
  echo ""
  exit 1
fi

# Parse command line arguments and set variables
# Set conditional statements so that options "-h" and "-v" are in play
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    display_help
    exit 1
fi
if [ "$1" = "-v" ] || [ "$1" = "--version" ]; then
    display_version
    exit 1
fi

# Check if the subcommand is used
full_pipeline=false
run_to_stage1=false
run_to_stage2=false
run_to_stage3=false
run_to_stage4=false
if [ "$#" -gt 0 ]; then
  case "$1" in
    "filter_seqs_by_length"|"filter_seqs_by_coverage"|"plot_paralog_heatmap"|"plot_recovery_heatmap"|"rlwp"|"fasta_formatter"|"mpp")
      print_welcome_phrases
      run_subcommand "$@"
      exit $?
      ;;
    "full_pipeline"|"run_to_stage1"|"run_to_stage2"|"run_to_stage3"|"run_to_stage4")
      run_subcommand "$@"
      ;;
    "retrieve_results")
      if [ "$2" = "-h" ]; then
        echo "Usage: HybSuite --retrieve_results"
        echo "Retrieve all tree files and figures generated by HybSuite."
        echo "Options:"
        echo "  -h, --help    Show this help message and exit"
        echo "  -i            Specify the directory containing the results generated by HybSuite."
        echo "  -o            Specify the output directory, all retrieved files will be saved in this directory."
        exit 1
      fi
      if [ "$2" != "-i" ] && [ "$2" != "-o" ]; then
        echo "[HybSuite-ERROR]:   You didn't specify the input directory (-i) or output directory (-o)."
        echo "                    HybSuite exits."
        echo ""
        exit 1 
      else
        if [ "$2" = "-i" ]; then
          eval "retrieve_input_dir=\"$3\""
          eval "retrieve_output_dir=\"$5\""
        fi
        if [ "$2" = "-o" ]; then
          eval "retrieve_output_dir=\"$3\""
          eval "retrieve_input_dir=\"$5\""
        fi
        if [ ! -d "${retrieve_input_dir}" ]; then
          echo "[HybSuite-ERROR]:   The input directory does not exist."
          echo "                    HybSuite exits."
          echo ""
          exit 1
        fi
        mkdir -p "${retrieve_output_dir}"
        retrieve_input_dir=${retrieve_input_dir%/}
        find "${retrieve_input_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/" -name "Filtered_paralog_heatmap.png" -exec cp {} "${retrieve_output_dir}" 2>/dev/null \; || true
        cp ${retrieve_input_dir}/05-Supermatrix/*/AMAS_reports_*_final.tsv "${retrieve_output_dir}" 2>/dev/null || true
        cp ${retrieve_input_dir}/07-Concatenation-based_trees/*/IQ-TREE/IQ-TREE_rr* "${retrieve_output_dir}" 2>/dev/null || true
        cp ${retrieve_input_dir}/07-Concatenation-based_trees/*/RAxML-NG/RAxML-NG_rr* "${retrieve_output_dir}" 2>/dev/null || true
        cp ${retrieve_input_dir}/07-Concatenation-based_trees/*/RAxML/RAxML_rr* "${retrieve_output_dir}" 2>/dev/null || true
        cp ${retrieve_input_dir}/08-Coalescent-based_trees/*/04-Species_tree_files/*_sorted_rr.tre "${retrieve_output_dir}" 2>/dev/null || true
        cp ${retrieve_input_dir}/08-Coalescent-based_trees/*/05-Recalculated_bl_species_tree/*_sorted_bl_rr.tre "${retrieve_output_dir}" 2>/dev/null || true
        cp ${retrieve_input_dir}/08-Coalescent-based_trees/*/06-PhyParts_PieCharts/*_phypartspiecharts_*.svg "${retrieve_output_dir}" 2>/dev/null || true
        cp ${retrieve_input_dir}/08-Coalescent-based_trees/*/06-PhyParts_PieCharts/*_phypartspiecharts_*.tsv "${retrieve_output_dir}" 2>/dev/null || true
        exit 0
      fi
      ;;
      *)
        echo "ERROR: Unknown HybSuite subcommand: $1."
        echo "Command mode 1 (for conda version):"
        echo "  hybsuite [subcommand] [options] ..."
        echo "Command mode 2 (for local version):"
        echo "  bash HybSuite.sh [subcommand] [options] ..."
        echo "Available subcommands for running HybSuite pipeline:"
        echo "  full_pipeline                       - Run all stages (stage1-5)"
        echo "  run_to_stage1                       - Run stage 1"
        echo "  run_to_stage2                       - Run stage 2"
        echo "  run_to_stage3                       - Run stage 3"
        echo "  run_to_stage4                       - Run stage 4"
        echo "  retrieve_results                    - Retrieve results"
        echo "Available subcommands for running HybSuite extension tools:"
        echo "  filter_seqs_by_length               - Filter sequences by length (filter_seqs_by_length.py)"
        echo "  filter_seqs_by_coverage             - Filter sequences by sample and locus coverage (filter_seqs_by_sample_and_locus_coverage.py)"
        echo "  plot_paralog_heatmap                - Plot paralog heatmap (plot_paralog_heatmap.py)"
        echo "  plot_recovery_heatmap               - Plot recovery heatmap (plot_recovery_heatmap.py)"
        echo "  rlwp                                - RLWP tool (RLWP.py)"
        echo "  fasta_formatter                     - FASTA formatting tool (Fasta_formatter.py)"
        exit 1
      ;;
  esac
fi

#Print welcome phrases
  print_welcome_phrases
  echo "================================================================================="
  echo "HybSuite User input command:"
  echo "$0 $@"
  echo "================================================================================="
  echo ""

# Switch to the script path
while IFS= read -r line || [ -n "$line" ]; do
  var=$(echo "${line}" | awk '{print $1}')
  default=$(echo "${line}" | awk '{print $2}')
  eval "${var}=''" > /dev/null 2>&1
  eval "Default_${var}='${default}'" > /dev/null 2>&1
  eval "found_${var}=false" > /dev/null 2>&1
done < "${config_dir}/HybSuite_options_list.txt"

if [ "$#" -eq 1 ]; then
  echo "[HybSuite-ERROR]: Except the subcommand, you didn't set any other required options."
  echo "                  Please set required options to run HybSuite. (use -h to check options)"
  echo "                  HybSuite exits."
  echo ""
  exit 1
fi

while [ "$#" -gt 1 ]; do
    case "$2" in
        -*)
            option="${2/-/}"
            vars=($(awk '{print $1}' ${config_dir}/HybSuite_options_list.txt))
            #echo "                    -$option: $3"
            case "$3" in
              -*)
                option3=$(echo "$3" | sed 's/^-//')
                for v in ${vars[@]}; do
                  if [ "$v" = "$option3" ]; then
                    echo ""
                    echo "[HybSuite-WARNING]: The argument for option $2 is not permitted to start with '-'"
                    echo "                    Please change your argument for the option $2."
                    echo "[HybSuite-WARNING]: Or you didn't specify any argument for the option $2."
                    echo "                    Please specify an argument for the option $2."
                    echo "                    HybSuite exits."
                    echo ""
                    exit 1
                  fi
                done
                ;;
            esac
            if [ -z "$3" ]; then
              echo ""
              echo "[HybSuite-ERROR]:   You didn't specify any argument for the option $2 "
              echo "                    Please specify an argument for the option $2."
              echo "                    HybSuite exits."
              echo ""
              exit 1
            fi
            found=0
            for v in ${vars[@]}; do
              if [ "$v" = "$option" ]; then
                found=1
                break
              fi
            done
            if [ $found -eq 1 ]; then
              if [ "$(echo "$3" | sed 's/.*\(.\)$/\1/')" = "/" ]; then
                eval "${option}=$(echo "$3" | sed 's/\/$//')"
              else
                eval "${option}=$3"
              fi
              eval "found_${option}=true"
              echo "$option" >> "$script_dir/../config/Option-list.txt"
              shift 2
            else
              echo ""
              echo "[HybSuite-ERROR]:   -$option is an invalid option."
              echo "                    Please check the help document and use right options."
              echo "                    HybSuite exits."
              echo ""
              exit 1
            fi
            ;;
        *)
            echo "[HybSuite-ERROR]:   Invalid option '$2'. Options should start with '-'."
            echo "                    HybSuite exits." 
            echo ""
            exit 1
            ;;
    esac
done
cut -f 1 $config_dir/HybSuite_options_list.txt > $config_dir/Option-all-list.txt
sort $config_dir/Option-all-list.txt $config_dir/Option-list.txt|uniq -u > $config_dir/Option-default-list.txt

while read -r line; do
    default_var="Default_${line}"
    default_value="${!default_var}"
    eval "default_value=${default_value}" > /dev/null 2>&1
    eval "${line}=\"${default_value}\"" > /dev/null 2>&1
    #echo "                    Default argument for -${line}: ${default_value}"
done < "$config_dir/Option-default-list.txt"
rm "$config_dir"/Option*

for var in input_data output_dir NGS_dir eas_dir t iqtree_constraint_tree raxml_constraint_tree rng_constraint_tree; do
  eval "val=\$$var"
  if [ ! -z "$val" ] && [ "$val" != "_____" ]; then
    case "$val" in
      /*) ;;
      *) abs_path=$(cd "$(dirname "$val")" && pwd)/$(basename "$val")
         eval "$var=$abs_path"
         ;;
    esac
  fi
done

#################===========================================================================
# Define OI and tree
HRS="FALSE"
RLWP="FALSE"
LS="FALSE"
MO="FALSE"
MI="FALSE"
RT="FALSE"
one_to_one="FALSE"

if echo "${OI}" | grep -q "1"; then
  HRS="TRUE"
fi
if echo "${OI}" | grep -q "2"; then
  RLWP="TRUE"
fi
if echo "${OI}" | grep -q "3"; then
  LS="TRUE"
fi
if echo "${OI}" | grep -q "4"; then
  MI="TRUE"
fi
if echo "${OI}" | grep -q "5"; then
  MO="TRUE"
fi
if echo "${OI}" | grep -q "6"; then
  RT="TRUE"
fi
if echo "${OI}" | grep -q "7"; then
  one_to_one="TRUE"
fi
if echo "${OI}" | grep -q "a"; then
  run_phylopypruner="TRUE"
  run_paragone="FALSE"
fi
if echo "${OI}" | grep -q "b"; then
  run_paragone="TRUE"
  run_phylopypruner="FALSE"
fi
if [ "${OI}" = "all" ]; then
  HRS="TRUE"
  RLWP="TRUE"
  LS="TRUE"
  MO="TRUE"
  MI="TRUE"
  RT="TRUE"
  one_to_one="TRUE"
  run_phylopypruner="TRUE"
fi
if ([ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "${one_to_one}" = "TRUE" ]) && [ "${run_paragone}" = "FALSE" ] && [ "${run_phylopypruner}" = "FALSE" ]; then
  run_phylopypruner="TRUE"
fi

run_iqtree="FALSE"
run_raxml="FALSE"
run_raxml_ng="FALSE"
run_astral="FALSE"
run_wastral="FALSE"

if echo "${tree}" | grep -q "1"; then
  run_iqtree="TRUE"
fi
if echo "${tree}" | grep -q "2"; then
  run_raxml="TRUE"
fi
if echo "${tree}" | grep -q "3"; then
  run_raxml_ng="TRUE"
fi
if echo "${tree}" | grep -q "4"; then
  run_astral="TRUE"
fi
if echo "${tree}" | grep -q "5"; then
  run_wastral="TRUE"
fi
if [ "${tree}" = "all" ]; then
  run_iqtree="TRUE"
  run_raxml="TRUE"
  run_raxml_ng="TRUE"
  run_astral="TRUE"
  run_wastral="TRUE"
fi
#################===========================================================================

#################===========================================================================
# Define skipping running
skip_checking="FALSE"
skip_stage1="FALSE"
skip_stage12="FALSE"
skip_stage123="FALSE"
skip_stage1234="FALSE"
if echo "${skip_stage}" | grep -q "0"; then
  skip_checking="TRUE"
fi
if echo "${skip_stage}" | grep -q "1"; then
  skip_stage1="TRUE"
fi
if echo "${skip_stage}" | grep -q "12"; then
  skip_stage12="TRUE"
fi
if echo "${skip_stage}" | grep -q "123"; then
  skip_stage123="TRUE"
fi
if echo "${skip_stage}" | grep -q "1234"; then
  skip_stage1234="TRUE"
fi
#################===========================================================================

#################===========================================================================
# Define threads
define_threads() {
  local software="$1"
  local stage_log_file="${output_dir}/00-logs_and_checklists/logs/HybSuite_logfile_${current_time}.log"
    
    # Get available CPU cores (compatibility modification)
    if command -v nproc >/dev/null 2>&1; then
        available_cores=$(nproc)
    elif command -v sysctl >/dev/null 2>&1; then
        # Get CPU core count on Mac
        available_cores=$(sysctl -n hw.ncpu 2>/dev/null || sysctl -n hw.logicalcpu 2>/dev/null)
    elif [ -f /proc/cpuinfo ]; then
        # Alternative method to get CPU core count on Linux
        available_cores=$(grep -c ^processor /proc/cpuinfo)
    else
        available_cores=1
    fi
    # If nt is AUTO, automatically set the number of threads based on system load
    if [ "${nt}" = "AUTO" ]; then
        # Get system load
        if [ -f /proc/loadavg ]; then
            current_load=$(cut -d ' ' -f1 /proc/loadavg)
        else
            current_load=$(uptime | awk -F'average: ' '{print $2}' | cut -d',' -f1 | tr -d ' ')
        fi

        # Get used thread count
        if command -v ps >/dev/null 2>&1; then
            used_threads=$(ps -eo pcpu | awk 'NR>1' | awk '{sum+=$1} END {printf "%.0f\n", sum/100}')
        else
            used_threads=$(top -b -n 1 | grep "^[0-9]" | awk '{sum += $10} END {printf "%.0f\n", sum}')
        fi

        free_threads=$(( available_cores - used_threads ))
        if [ $free_threads -lt 1 ]; then
            free_threads=1
        fi
        if (( $(echo "$current_load > 1" | bc -l) )); then
            recommended_threads=$(( free_threads / 2 ))
        else
            recommended_threads=$free_threads
        fi
        max_threads=$(( available_cores * 75 / 100 ))
        if [ $recommended_threads -lt 1 ]; then
            recommended_threads=1
        elif [ $recommended_threads -gt $max_threads ]; then
            recommended_threads=$max_threads
        fi
        eval "nt_${software}=$recommended_threads"
        eval "nt=${recommended_threads}"
    fi
    # If nt is a positive integer, set the number of threads based on the input
    if [ "$nt" -gt 0 ] 2>/dev/null; then
        if [ "$nt" -ge "$available_cores" ]; then
            eval "nt_${software}=$available_cores"
            if [ "${log_mode}" = "full" ]; then
              echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] available_cores: $available_cores" | tee -a "${stage_log_file}"
              echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WARNING] Specified threads (-nt) exceed available cores: $available_cores" | tee -a "${stage_log_file}"
              echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WARNING] Thus, set threads for ${software} to available cores: $available_cores" | tee -a "${stage_log_file}"
            fi
        else
            eval "nt_${software}=$nt"
        fi
    fi
    # Print the number of threads for running ${software}
    if [ "${nt}" = "AUTO" ]; then
        if [ "${log_mode}" = "full" ]; then
          echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Available cores: $available_cores" | tee -a "${stage_log_file}"
          echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Current load: $current_load" | tee -a "${stage_log_file}"
          echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Used threads: $used_threads" | tee -a "${stage_log_file}"
          echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Free threads: $free_threads" | tee -a "${stage_log_file}"
          echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Threads for ${software} (recommended threads by 'AUTO' for '-nt'): $recommended_threads" | tee -a "${stage_log_file}"
        fi
    else
        if [ "$nt" -ge "$available_cores" ]; then
            if [ "${log_mode}" = "full" ]; then
              echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Threads for ${software} (threads by '-nt'): $available_cores" | tee -a "${stage_log_file}"
            fi
        else
            if [ "${log_mode}" = "full" ]; then
              echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] Threads for ${software} (threads by '-nt'): $nt" | tee -a "${stage_log_file}"
            fi
        fi
    fi
}

#################===========================================================================

#################===========================================================================
# Define the type of the target file
hybpiper_tt="dna"
if [ -s "${t}" ]; then
  while IFS= read -r line; do
    line=$(echo "$line" | xargs)
    case "$line" in
        \>*)
            continue
            ;;
    esac
    if echo "$line" | grep -q '[^ATCGatcg-]'; then
        hybpiper_tt="aa"
        break
    else
        hybpiper_tt="dna"
        break
    fi
  done < "${t}"
fi
#################===========================================================================

############################################################################################
# Preparation
############################################################################################

mkdir -p "${output_dir}/00-logs_and_checklists/logs"
#################===========================================================================
# Function: Output information to log file
stage_logfile="${output_dir}/00-logs_and_checklists/logs/HybSuite_logfile_${current_time}.log"
stage_cmd_logfile="${output_dir}/00-logs_and_checklists/logs/HybSuite_cmd_${current_time}.log"
stage_info_main() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "${stage_logfile}"
}
stage_info() {
  local log_mode="$1"
  local message="$2"
  if [ "${log_mode}" = "full" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $message" | tee -a "${stage_logfile}"
  fi
}
stage_error() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "${stage_logfile}"
}
stage_cmd_main() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [CMD] $1" | tee -a "${stage_cmd_logfile}"
}
stage_cmd() {
  local log_mode="$1"
  local message="$2"
  
  if [ "${log_mode}" = "cmd" ] || [ "${log_mode}" = "full" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [CMD] $message" >> "${stage_cmd_logfile}"
  fi
}
stage_blank_main() {
  echo "$1" | tee -a "${stage_logfile}"
}
stage_blank() {
  local log_mode="$1"
  local message="$2"
  if [ "${log_mode}" = "full" ]; then
    echo "$message" | tee -a "${stage_logfile}"
  fi
}
echo "HybSuite input command:" >> "${stage_logfile}"
echo "$0 $@" >> "${stage_logfile}"
#################===========================================================================

#HybSuite CHECKING
#Step 1: Check necessary options
if [ "${skip_checking}" = "TRUE" ]; then
  stage_info_main "HybSuite Checking is skipped."
else
  stage0_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "${stage_logfile}"
  }
  stage0_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "${stage_logfile}"
  }
  stage0_warning() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WARNING] $1" | tee -a "${stage_logfile}"
  }
  stage0_attention() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ATTENTION] $1" | tee -a "${stage_logfile}"
  }
  stage0_cmd() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [CMD] $1" | tee -a "${stage_logfile}"
  }
  stage0_blank() {
    echo "$1" | tee -a "${stage_logfile}"
  }
  stage0_info "<<<======= HybSuite CHECKING =======>>>"
  stage0_info "HybSuite will provide tips with [ATTENTION]."
  stage0_info "HybSuite will alert you to incorrect arguments with [WARNING]."
  stage0_info "HybSuite will notify you of missing software with [ERROR], and then exit."
  stage0_blank ""
  stage0_info "=> Step 1: Check all input parameters" 
  stage0_info "01-Verify if the user has entered the necessary options ..."
  stage0_info "Checking results:"
  ###Verify if the user has entered the necessary parameters
  if [ "${run_to_stage1}" = "true" ]; then
    if [ "${input_list}" = "_____" ] || [ "${output_dir}" = "_____" ]; then
      stage0_error "You haven't set all the necessary options."
      stage0_error "All necessary options must be set."
      stage0_error "Including: "
      stage0_error "-input_list"
      stage0_error "-output_dir"
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    fi
  else
    if [ "${input_list}" = "_____" ] || [ "${t}" = "_____" ] || [ "${output_dir}" = "_____" ]; then
      stage0_info "After checking:"
      stage0_error "You haven't set all the necessary options."
      stage0_error "All necessary options must be set."
      stage0_error "Including: "
      stage0_error "-input_list"
      stage0_error "-output_dir"
      stage0_error "-t"
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    fi
  fi
  stage0_info "Well done!"
  stage0_info "All necessary options have been set."
  stage0_info "Proceeding to the next step ..."
  stage0_blank ""
  
  if [ -s "${input_list}" ]; then
    sed -i 's/\r$//; /^$/d' "${input_list}"
  fi

  stage0_info "02-Check other parameters ..."
  stage0_info "Checking results:"
  stage0_info "<threads control>:"
  # Get available CPU cores (compatibility modification)
    if command -v nproc >/dev/null 2>&1; then
        available_cores=$(nproc)
    elif command -v sysctl >/dev/null 2>&1; then
        # Get CPU core count on Mac
        available_cores=$(sysctl -n hw.ncpu 2>/dev/null || sysctl -n hw.logicalcpu 2>/dev/null)
    elif [ -f /proc/cpuinfo ]; then
        # Alternative method to get CPU core count on Linux
        available_cores=$(grep -c ^processor /proc/cpuinfo)
    else
        available_cores=1
    fi
  # Get system load
    if [ -f /proc/loadavg ]; then
        current_load=$(cut -d ' ' -f1 /proc/loadavg)
    else
        current_load=$(uptime | awk -F'average: ' '{print $2}' | cut -d',' -f1 | tr -d ' ')
    fi
  # Get used thread count
    if command -v ps >/dev/null 2>&1; then
        used_threads=$(ps -eo pcpu | awk 'NR>1' | awk '{sum+=$1} END {printf "%.0f\n", sum/100}')
    else
        used_threads=$(top -b -n 1 | grep "^[0-9]" | awk '{sum += $10} END {printf "%.0f\n", sum}')
    fi
  # Calculate free threads
    free_threads=$(( available_cores - used_threads ))
    if [ $free_threads -lt 1 ]; then
        free_threads=1
    fi
  # Check the number of threads
  if [ "${nt}" = "AUTO" ]; then
    stage0_info "All programs will use the recommended number of threads."
  elif [ "${nt}" -eq "${nt}" ] 2>/dev/null && [ "${nt}" -ge 0 ]; then
    stage0_info "All programs will use the specified number of threads: ${nt}."
    if [ "${nt}" -gt "${free_threads}" ]; then
      stage0_warning "Specified threads (${nt}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_fasterq_dump}" -gt "${free_threads}" ]; then
      stage0_warning "Specified fasterq-dump threads (${nt_fasterq_dump}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_pigz}" -gt "${free_threads}" ]; then
      stage0_warning "Specified pigz threads (${nt_pigz}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_trimmomatic}" -gt "${free_threads}" ]; then
      stage0_warning "Specified Trimmomatic threads (${nt_trimmomatic}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_hybpiper}" -gt "${free_threads}" ]; then
      stage0_warning "Specified HybPiper threads (${nt_hybpiper}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_paragone}" -gt "${free_threads}" ]; then
      stage0_warning "Specified ParaGone threads (${nt_paragone}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_phylopypruner}" -gt "${free_threads}" ]; then
      stage0_warning "Specified PhyloPyPruner threads (${nt_phylopypruner}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_mafft}" -gt "${free_threads}" ]; then
      stage0_warning "Specified MAFFT threads (${nt_mafft}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_modeltest_ng}" -gt "${free_threads}" ]; then
      stage0_warning "Specified ModelTest-NG threads (${nt_modeltest_ng}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_iqtree}" -gt "${free_threads}" ]; then
      stage0_warning "Specified IQ-TREE threads (${nt_iqtree}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_raxml_ng}" -gt "${free_threads}" ]; then
      stage0_warning "Specified RAxML-NG threads (${nt_raxml_ng}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_raxml}" -gt "${free_threads}" ]; then
      stage0_warning "Specified RAxML threads (${nt_raxml}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_astral}" -gt "${free_threads}" ]; then
      stage0_warning "Specified ASTRAL threads (${nt_astral}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_wastral}" -gt "${free_threads}" ]; then
      stage0_warning "Specified wASTRAL threads (${nt_wastral}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
  fi
  stage0_blank ""

  stage0_info "<Other common parameters>:"
  if [ ! -d "${eas_dir}" ] || [ ! -d "${NGS_dir}" ] || [ ! -d "${output_dir}" ]; then
    if [ ! -d "${eas_dir}" ]; then
      stage0_error "The directory for sequences which have been generated by 'hybpiper assemble' does not exist."
      stage0_error "Please check and correct the '-eas_dir' parameter."
    elif [ ! -d "${NGS_dir}" ]; then
      stage0_error "The directory encompassing NGS raw data and clean data does not exist."
      stage0_error "Please check and correct the '-NGS_dir' parameter."
    elif [ ! -d "${ooutput_dir}" ]; then
      stage0_error "The directory encompassing NGS raw data and clean data does not exist."
      stage0_error "Please check and correct the '-output_dir' parameter."
    fi
    stage0_error "HybSuite exits."
    stage0_blank ""
    exit 1
  fi

  if (( $(echo "${min_sample_coverage} >= 0" | bc -l) )) && (( $(echo "${min_sample_coverage} <= 1" | bc -l) )); then
    :
  else
    stage0_error "The -sample_coverage value must be greater than 0 and less than 1."
    stage0_error "Please correct it."
    stage0_error "HybSuite will exit."
    stage0_blank ""
    exit 1
  fi
  
  if (( $(echo "${min_locus_coverage} >= 0" | bc -l) )) && (( $(echo "${min_locus_coverage} <= 1" | bc -l) )); then
    :
  else
    stage0_error "The -min_locus_coverage value must be greater than 0 and less than 1."
    stage0_error "Please correct it."
    stage0_error "HybSuite will exit."
    stage0_blank ""
    exit 1
  fi
  stage0_info "PASS"
  stage0_blank ""

  stage0_info "<Orthology inference control>:"
  stage0_info "According to your input command, the chosen ortholog inference methods are:"
  if [ "${HRS}" = "TRUE" ]; then
    stage0_info "HRS"
  fi
  if [ "${RLWP}" = "TRUE" ]; then
    stage0_info "RLWP"
  fi
  if [ "${LS}" = "TRUE" ]; then
    stage0_info "LS"
  fi
  if [ "${MI}" = "TRUE" ]; then
    stage0_info "MI"
  fi
  if [ "${MO}" = "TRUE" ]; then
    stage0_info "MO"
  fi
  if [ "${RT}" = "TRUE" ]; then
    stage0_info "RT"
  fi
  if [ "${one_to_one}" = "TRUE" ]; then
    stage0_info "1to1"
  fi

  stage0_blank ""
  stage0_info "<Phylogenetic tree inference control>:  "
  stage0_info "According to your input command, the chosen phylogenetic tree inference tools are:"
  if [ "${run_iqtree}" = "TRUE" ]; then
    stage0_info "IQ-TREE"
  fi
  if [ "${run_raxml}" = "TRUE" ]; then
    stage0_info "RAxML"
  fi
  if [ "${run_raxml_ng}" = "TRUE" ]; then
    stage0_info "RAxML-NG"
  fi
  if [ "${run_astral}" = "TRUE" ]; then
    stage0_info "ASTRAL-III"
  fi
  if [ "${run_wastral}" = "TRUE" ]; then
    stage0_info "wASTRAL"
  fi
  if [ "${tree}" = "0" ]; then
    stage0_info "None"
  fi
  stage0_blank ""
  stage0_info "Well done!"
  stage0_info "All parameters are valid."
  stage0_info "Proceeding to the next step ..."
  stage0_blank ""


  ######################################################
  ### Step 2: Check all the input files ################
  ######################################################
  stage0_info "=> Step 2: Check all the input files" 
  # 01-Check the form of the input list file
  stage0_info "01-Check the form of the input list file (specified by '-input_list') ..."
  stage0_info "Checking results:"
  found_public=$(awk -F'\t' '$2 ~ /^(SRR|ERR)/ { print 1; exit }' "${input_list}")
  found_own=$(awk -F'\t' '$2 == "A" { print 1; exit }' "${input_list}")
  found_pre=$(awk -F'\t' '$2 == "B" { print 1; exit }' "${input_list}")
  found_outgroup=$(awk -F'\t' '$3 == "Outgroup" { print 1; exit }' "${input_list}")
  found_other=$(awk -F'\t' '$2 !~ /^(SRR|ERR)/ && $2 != "A" && $2 != "B" { print 1; exit }' "${input_list}")
  if [ "${found_other}" = "1" ] || ([ "${found_public}" != "1" ] && [ "${found_own}" != "1" ]); then
    if [ "${found_other}" = "1" ]; then
      stage0_error "The second column of ${input_list} should start with 'SRR' or 'ERR', or be 'A' or 'B'."
    elif [ "${found_public}" != "1" ] && [ "${found_own}" != "1" ]; then
      stage0_error "At least one type of data (public/your own) must be provided in ${input_list}."
    fi
    stage0_error "HybSuite exits."
    stage0_blank ""
    exit 1
  fi
  if [ "${found_outgroup}" != "1" ]; then
    stage0_warning "No outgroup species name is provided (the third column) in ${input_list}."
    stage0_warning "HybSuite will not reroot the phylogenetic tree in stage 5."
  fi
  if [ "${found_public}" = "1" ]; then
    stage0_info "Public sample names to download are provided."
  elif [ "${found_own}" = "1" ]; then
    stage0_info "The names of samples with existing raw data are provided."
  elif [ "${found_pre}" = "1" ]; then
    stage0_info "The names of samples with pre-assembled sequences are provided."
  fi
  stage0_info "PASS"

  # 02-Check the input data
  stage0_info "02-Checking the input data (specified by '-input_data') ..."
  stage0_info "Checking results:"
  # Check if the path to the input data is provided.
  if ([ "${found_pre}" = "1" ] || [ "${found_own}" = "1" ]) && [ ! -d "${input_data}" ]; then
    stage0_error "You need to specify the correct path to your data by using '-input_data'."
    stage0_error "HybSuite exits."
    stage0_blank ""
    exit 1
  fi

  # Check if the input list is provided when users offer the input data
  if [ "${found_own}" = "1" ] && [ ! -d "${input_data}" ]; then
    stage0_error "The names of samples with your existing raw data should be provided in the input data directory (${input_data})."
    stage0_error "HybSuite exits."
    stage0_blank ""
    exit 1
  fi

  # Check if all sample names in the input list have corresponding correct name of input data
  awk -F'\t' '$2 == "A" {print $1}' "${input_list}" | while IFS= read -r sample; do
    if ([ -s "${input_data}/${sample}_1.fastq" ] && [ -s "${input_data}/${sample}_2.fastq" ]) || \
       ([ -s "${input_data}/${sample}_1.fastq.gz" ] && [ -s "${input_data}/${sample}_2.fastq.gz" ]) || \
       ([ -s "${input_data}/${sample}_1.fq" ] && [ -s "${input_data}/${sample}_2.fq" ]) || \
       ([ -s "${input_data}/${sample}_1.fq.gz" ] && [ -s "${input_data}/${sample}_2.fq.gz" ]) || \
       [ -s "${input_data}/${sample}.fastq" ] || \
       [ -s "${input_data}/${sample}.fastq.gz" ] || \
       [ -s "${input_data}/${sample}.fq" ] || \
       [ -s "${input_data}/${sample}.fq.gz" ]; then
       :
    else
      stage0_error "No FASTQ/FASTQ.GZ/FQ/FQ.GZ files found for sample $sample in the input data directory (${input_data})."
      stage0_error "Please adjust the format of your input data to the acquired format (use -h to check the correct format)."
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    fi
  done
  awk -F'\t' '$2 == "B" {print $1}' "${input_list}" | while IFS= read -r sample; do
    if [ -s "${input_data}/${sample}.fasta" ]; then
      :
    else
      stage0_error "No FASTA file found for sample $sample in the input data directory (${input_data})."
      stage0_error "Please adjust the format of your input data to the acquired format (use -h to check the correct format)."
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    fi
  done
  stage0_info "PASS"

  # 03-Check the target file
  stage0_info "03-Checking the target file (specified by '-t') ..."
  stage0_info "Checking results:"
  if [ ! -s "${t}" ] && [ "${run_to_stage1}" != "true" ]; then
    stage0_error "The target file (reference for HybPiper) you specified does not exist."
    stage0_error "HybSuite exits."
    stage0_blank ""
    exit 1
  else
    ref_num=$(grep -c '>' "${t}")
    stage0_info "The target file is (specified by '-t'):" 
    stage0_info "${t}"
    stage0_info "It contains ${ref_num} sequences"
    stage0_info "PASS"
  fi
  
  # Deliver congratulations messages
  stage0_blank ""
  stage0_info "Well done!"
  stage0_info "All necessary folders and files are prepared."
  stage0_info "Proceeding to the next step ..."
  stage0_blank ""
  
  ###################################
  ### Step 3: Check dependencies ####
  ###################################
  stage0_info "=> Step 3: Check dependencies" 
  stage0_info "01-Check required software in all conda environments..."
  # sra-tools
  check_sra_tools() {
    if ! command -v prefetch >/dev/null 2>&1 && ! command -v fasterq-dump >/dev/null 2>&1; then
      stage0_error "'sra-tools' is not found in your conda environment."
      stage0_error "Please install 'sra-tools' in your conda environment."
      stage0_error "Recommended command for installation:"
      stage0_error "mamba install bioconda::sra-tools -y"
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    else
      stage0_info "'sra-tools' existed, pass"
    fi
  }

  check_pigz() {
    if ! command -v pigz >/dev/null 2>&1; then
      stage0_error "'pigz' is not found in your conda environment."
      stage0_error "Please install 'pigz' in your conda environment."
      stage0_error "Recommended command for installation:"
      stage0_error "mamba install conda-forge::pigz -y"
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    else
      stage0_info "'pigz' existed, pass"
    fi
  }
  
  check_trimmomatic() {
    if ! command -v trimmomatic >/dev/null 2>&1; then
      stage0_error "'trimmomatic' is not found in your conda environment."
      stage0_error "Please install 'trimmomatic' in your conda environment."
      stage0_error "Recommended command for installation:"
      stage0_error "mamba install conda-forge::trimmomatic -y"
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    else
      stage0_info "'trimmomatic' existed, pass"
    fi
  }

  check_hybpiper() {
    if ! command -v hybpiper >/dev/null 2>&1; then
      stage0_error "'hybpiper' is not found in your conda environment."
      stage0_error "Please install 'hybpiper' in your conda environment."
      stage0_error "Recommended command for installation:"
      stage0_error "mamba install bioconda::hybpiper -y"
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    else
      stage0_info "'hybpiper' existed, pass"
    fi
  }

  check_amas() {
    if ! command -v AMAS.py >/dev/null 2>&1; then
      stage0_error "'amas' is not found in your conda environment."
      stage0_error "Please install 'amas' in your conda environment."
      stage0_error "Recommended command for installation:"
      stage0_error "mamba install bioconda::amas -y"
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    else
      stage0_info "'amas' existed, pass"
    fi
  }

  check_mafft() {
    if ! command -v mafft >/dev/null 2>&1; then
      stage0_error "'mafft' is not found in your conda environment."
      stage0_error "Please install 'mafft' in your conda environment."
      stage0_error "Recommended command for installation:"
      stage0_error "mamba install bioconda::mafft -y"
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    else
      stage0_info "'mafft' existed, pass"
    fi
  }

  check_trimal() {
    if ! command -v trimal >/dev/null 2>&1; then
      stage0_error "'trimal' is not found in your conda environment."
      stage0_error "Please install 'trimal' in your conda environment."
      stage0_error "Recommended command for installation:"
      stage0_error "mamba install bioconda::trimal -y"
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    else
      stage0_info "'trimal' existed, pass"
    fi
  }
  
  check_paragone() {
    if ([ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "$one_to_one" = "TRUE" ]) && [ "${run_paragone}" = "TRUE" ]; then
      if ! command -v paragone >/dev/null 2>&1; then
        stage0_error "'ParaGone' is not found in your conda environment."
        stage0_error "Please install 'ParaGone' in your conda environment."
        stage0_error "Recommended command for installation:"
        stage0_error "mamba install bioconda::paragone -y"
        stage0_error "HybSuite exits."
        stage0_blank ""
        exit 1
      else
        stage0_info "'paragone' existed, pass"
      fi
    fi
  }

  check_modeltest_ng() {
    if ! command -v modeltest-ng >/dev/null 2>&1; then
      stage0_error "'modeltest-ng' is not found in your conda environment."
      stage0_error "Please install 'modeltest-ng' in your conda environment."
      stage0_error "Recommended command for installation:"
      stage0_error "mamba install bioconda::modeltest-ng -y"
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    else
      stage0_info "'modeltest-ng' existed, pass"
    fi
  }

  check_iqtree() {
    if ! command -v iqtree >/dev/null 2>&1; then
      stage0_error "'iqtree' is not found in your conda environment."
      stage0_error "Please install 'iqtree' in your conda environment."
      stage0_error "Recommended command for installation:"
      stage0_error "mamba install bioconda::iqtree -y"
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    else
      stage0_info "'iqtree' existed, pass"
    fi
  }

  check_raxml() {
    if ! command -v raxmlHPC >/dev/null 2>&1; then
      stage0_error "'raxml' is not found in your conda environment."
      stage0_error "Please install 'raxml' in your conda environment."
      stage0_error "Recommended command for installation:"
      stage0_error "mamba install bioconda::raxml -y"
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    else
      stage0_info "'raxml' existed, pass"
    fi
  }
  
  check_raxml_ng() {
    if ! command -v raxml-ng >/dev/null 2>&1; then
      stage0_error "'raxml-ng' is not found in your conda environment."
      stage0_error "Please install 'raxml-ng' in your conda environment."
      stage0_error "Recommended command for installation:"
      stage0_error "mamba install bioconda::raxml-ng -y"
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    else
      stage0_info "'raxm-ng' existed, pass"
    fi
  }

  check_wastral() {
    if [ "${run_wastral}" = "TRUE" ]; then
      stage0_info "Checking wASTRAL..."
      if [ ! -s "${wastral_dir}/bin/wastral" ]; then
        stage0_blank ""
        stage0_error "To run wASTRAL, 'wASTRAL' must be installed in ${wastral_dir} (specified by option -wastral_dir)."
        stage0_error "Please ensure 'wASTRAL' is installed and the correct directory is specified."
        stage0_error "Install 'wASTRAL' and add its root directory to the system environment variables."
        stage0_error "HybSuite exits."
        stage0_blank ""
        exit 1
      else
        stage0_info "'wASTRAL' existed, pass"
      fi
    fi
  }

  check_newick_utilis() {
    if ! command -v nw_reroot >/dev/null 2>&1; then
      stage0_error "'newick_utils' must be installed in your conda environment."
      stage0_error "'newick_utils' is not found in your conda environment."
      stage0_error "Please install 'newick_utils' in your conda environment."
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    else
      stage0_info "'newick_utilis' existed, pass"
    fi
  }

  check_r_phytools() {
    if Rscript -e "if (!requireNamespace('phytools', quietly = TRUE)) { quit(status = 1) }"; then
      stage0_info "R packsge 'phytools' existed, pass"
    else
      stage0_error "'phytools' must be installed in your conda environment."
      stage0_error "Please install 'phytools' using install.packages('phytools')."
      stage0_error "Recommended command for installation:"
      stage0_error "conda install conda-forge::r-phytools -y"
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    fi
  }
  
  check_r_ape() {
    if Rscript -e "if (!requireNamespace('ape', quietly = TRUE)) { quit(status = 1) }"; then
      stage0_info "R packsge 'ape' existed, pass"
    else
      stage0_error "To run wASTRAL/ASTRAL-III, 'ape' must be installed in your conda environment."
      stage0_error "Please install 'ape' using install.packages('ape')."
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    fi
  }

  check_py_install() {
    local pyinstall="$1"
    if pip show "${pyinstall}" >/dev/null 2>&1; then
      stage0_info "Python dependency ${pyinstall} existed, pass"
    else
      stage0_error "Python package "${pyinstall}" is not installed."
      stage0_error "Recommended command for installation:"
      stage0_error "pip install pandas"
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    fi
  }

  check_py_phylopypruner() {
      if pip show "phylopypruner" >/dev/null 2>&1; then
        stage0_info "Python dependency 'phylopypruner' existed, pass"
      else
        stage0_error "Python package 'phylopypruner' is not installed."
        stage0_error "Recommended command for installation:"
        stage0_error "pip install phylopypruner"
        stage0_error "HybSuite exits."
        stage0_blank ""
        exit 1
      fi
  }
    
  check_r() {
    if ! command -v R >/dev/null 2>&1; then
        stage0_error "'r' is not installed in the current environment."
        stage0_error "Please install 'r' in your conda environment."
        stage0_error "Recommended command for installation:"
        stage0_error "mamba install r -y"
        stage0_error "HybSuite exits."
        stage0_blank ""
        exit 1
    else
        stage0_info "'r-base' existed, pass"
    fi
  }

  stage0_info "Checking dependencies in your conda environment..."
  check_sra_tools
  check_pigz
  check_trimmomatic
  check_mafft
  check_trimal
  check_amas
  check_modeltest_ng
  check_iqtree
  check_raxml
  check_raxml_ng
  check_hybpiper
  # check r/python
  check_r
  check_r_phytools
  check_r_ape
  check_py_install "PyQt5"
  check_py_install "ete3"
  check_py_install "pandas"
  check_py_install "seaborn"
  check_py_install "matplotlib"
  check_py_install "numpy"
  check_py_install "phylopypruner"
  check_py_install "phykit"
  if [ "${run_wastral}" = "TRUE" ]; then
    # wastral
    check_wastral
  fi
  check_paragone
  stage0_blank ""
  stage0_info "Well done!"
  stage0_info "All dependencies have been successfully installed in your conda environment."
  stage0_info "Proceeding to the next step..."
  stage0_blank ""
fi

if [ "${skip_checking}" != "TRUE" ]; then
  stage0_info "=> Step 4: Check Species Checklists"
  all_sp_num=$(grep -c '^' "${input_list}" || wc -l < "${input_list}")
  all_genus_num=$(awk -F '_' '{print $1}' "${input_list}" | sort -u | grep -c '^')
  awk -F '_' '{print $1}' "${input_list}" | sort -u > "${output_dir}/00-logs_and_checklists/checklists/All_Genus_name_list.txt"
  if [ "${found_public}" = "1" ]; then
    SRR_sp_num=$(awk -F'\t' '$2 ~ /^(SRR|ERR)/' "${input_list}" | grep -c '^')
    SRR_genus_num=$(awk -F'\t' '$2 ~ /^(SRR|ERR)/ {print $1}' "${input_list}" | awk -F'_' '{print $1}' | sort -u | grep -c '^')
  fi
  if [ "${found_own}" = "1" ]; then
    Add_sp_num=$(awk -F'\t' '$2 == "A"' "${input_list}" | grep -c '^')
    Add_genus_num=$(awk -F'\t' '$2 == "A" {print $1}' "${input_list}" | awk -F'_' '{print $1}' | sort -u | grep -c '^')
  fi
  if [ "${found_pre}" = "1" ]; then
    Other_sp_num=$(awk -F'\t' '$2 == "B"' "${input_list}" | grep -c '^')
    Other_genus_num=$(awk -F'\t' '$2 == "B" {print $1}' "${input_list}" | awk -F'_' '{print $1}' | sort -u | grep -c '^')
  fi
fi

if [ "${skip_checking}" != "TRUE" ]; then
  stage0_info "Checking results:"
  stage0_info "(1) Taxonomy:"
  stage0_info "You plan to construct phylogenetic trees for ${all_sp_num} taxa belonging to ${all_genus_num} genera."
  stage0_info "(2) Data sources:"
  if [ "${found_public}" = "1" ]; then
    stage0_info "Downloaded raw data: ${SRR_sp_num} species from ${SRR_genus_num} genera."
  else
    :
  fi
  if [ "${found_own}" = "1" ]; then
    stage0_info "Your own raw data: ${Add_sp_num} species from ${Add_genus_num} genera."
  else
    :
  fi
  if [ "${found_pre}" = "1" ]; then
    stage0_info "Your pre-assembled sequences: ${Other_sp_num} species from ${Other_genus_num} genera."
  else
    :
  fi
  stage0_info "PASS"

  #Read the answer entered by the user
  stage0_info "All in all, the final results will be outputted to ${output_dir}/"
  stage0_blank ""
  stage0_info "=> According to the above feedbacks,"
  stage0_info "proceed to run HybSuite? ([y]/n)"
  read answer
  answer_HybSuite=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
  # Check the user's answers
  if [ "$answer_HybSuite" = "y" ]; then
    stage0_blank ""
    stage0_info "Fantastic! HybSuite will run according to your request ..."
    stage0_info "Let's start it, good luck!"
    stage0_blank ""
  elif [ "$answer_HybSuite" = "n" ]; then
    stage0_blank ""
    stage0_warning "It might be something dosen't satisfy your needs."
    stage0_warning "You can adjust the parameter settings or correct the filenames."
    stage0_warning "HybSuite exits."
    stage0_blank ""
    exit 1
  else
    stage0_blank ""
    stage0_error "Sorry, ${answer} is not a valid answer."
    stage0_error "Please input y (yes) or n (no)."
    stage0_error "HybSuite exits."
    stage0_blank ""
    exit 1
  fi
fi

#===> Preparation <===#
# Create Folders：
### 01 Create the desired folder
stage_info "<<<======= Preparation: Create desired folders and define functions =======>>>"
if [ -d "${output_dir}/00-logs_and_checklists/checklists" ]; then
  rm "${output_dir}/00-logs_and_checklists/checklists"/* > /dev/null 2>&1
fi
mkdir -p "${output_dir}/00-logs_and_checklists/checklists"
found_public=$(awk -F'\t' '$2 ~ /^(SRR|ERR)/ { print 1; exit }' "${input_list}")
found_own=$(awk -F'\t' '$2 == "A" { print 1; exit }' "${input_list}")
found_pre=$(awk -F'\t' '$2 == "B" { print 1; exit }' "${input_list}")
found_outgroup=$(awk -F'\t' '$3 == "Outgroup" { print 1; exit }' "${input_list}")
found_other=$(awk -F'\t' '$2 !~ /^(SRR|ERR)/ && $2 != "A" && $2 != "B" { print 1; exit }' "${input_list}")
if [ "${found_public}" = "1" ]; then
  awk -F'\t' -v OFS='\t' '$2 ~ /^(SRR|ERR)/ {print $1, $2}' "${input_list}" > "${output_dir}/00-logs_and_checklists/checklists/Public_Spname_SRR.txt"
  awk -F'\t' -v OFS='\t' '$2 ~ /^(SRR|ERR)/ {print $1}' "${input_list}" > "${output_dir}/00-logs_and_checklists/checklists/Public_Spname.txt"
fi
if [ "${found_outgroup}" = "1" ]; then
  awk -F'\t' -v OFS='\t' '$3 == "Outgroup" {print $1}' "${input_list}" > "${output_dir}/00-logs_and_checklists/checklists/Outgroup.txt"
fi
if [ "${found_own}" = "1" ]; then
  awk -F'\t' '$2 == "A" {print $1}' "${input_list}" > "${output_dir}/00-logs_and_checklists/checklists/My_Spname.txt"
fi
if [ "${found_pre}" = "1" ]; then
  awk -F'\t' '$2 == "B" {print $1}' "${input_list}" > "${output_dir}/00-logs_and_checklists/checklists/Pre-assembled_Spname.txt"
fi

# set the process:
if [ "${process}" != "all" ]; then
    trap "exec 1000>&-;exec 1000<&-;exit 0" 2
    FIFO_FILE=$$.fifo
    mkfifo $FIFO_FILE
    exec 1000<>$FIFO_FILE 
    rm -rf $FIFO_FILE
    process=${process}
    for ((idx=0; idx<$process; idx++));
    do
        echo>&1000
    done
fi

# Define working directory (for stage 1-4)
work_dir="${output_dir}/00-logs_and_checklists/logs"

  #################===========================================================================
  # Function: Record skipped samples
  record_skipped_sample() {
      local sample="$1"
      local skipping_prefix="$2"
      local stage_logfiles="$3"
      (
          flock -x 200
          # Append current skipped sample to temporary file
          echo "$sample" >> "${work_dir}/skipped_samples.tmp"
          ((skipped_count++))
          echo "$skipped_count" > "${work_dir}/skipped_count.txt"
          
          # Combine all skipped samples into one line
          echo "[$(date '+%Y-%m-%d %H:%M:%S')] [LOG] ${skipping_prefix} $(tr '\n' ' ' < "${work_dir}/skipped_samples.tmp")" > "$skipped_log"
          update_progress "$stage_logfiles"
      ) 200>>$progress_file
  }
  #################===========================================================================

  #################===========================================================================
  # Function: Initialize parallel processing environment
  init_parallel_env() {
      local work_dir="$1"
      local total_sps="$2"
      local process="$3"
      local input_file="$4"
      
      # Initialize progress files
      progress_file="${work_dir}/progress.txt"
      started_file="${work_dir}/started.txt"
      finished_file="${work_dir}/finished.txt"
      batch_info_file="${work_dir}/batch_info.tmp"
      temp_batch_log="${work_dir}/temp_batch.log"
      skipped_log="${work_dir}/skipped.log"
      failed_log="${work_dir}/failed.log"
      FIFO_FILE="${work_dir}/fifo.$$"
      
      # Check working directory permissions
      if [ ! -w "$work_dir" ]; then
          echo "Error: No write permission in working directory: $work_dir"
          return 1
      fi
      
      # Initialize files with fresh content
      echo "0" > "$progress_file"
      echo "0" > "$started_file"
      echo "0" > "$finished_file"
      echo "0" > "${work_dir}/skipped_count.txt"
      : > "$batch_info_file"
      : > "$temp_batch_log"
      : > "$skipped_log"
      : > "${work_dir}/skipped_samples.tmp"
      > "${work_dir}/running_samples.tmp"
      : > "$failed_log"
      : > "${failed_log}.time"
      
      # Record start time
      start_time=$(date +%s)
      
      # Set process number
      if [ "$process" = "all" ]; then
          process_num=$total_sps
      else
          process_num=$process
      fi
      
      # Initialize skipped sample variables
      declare -a skipped_samples
      declare -a skipped_times
      skipped_count=0
      
      # Preprocessing: Group samples into batches
      batch_count=0
      declare -a current_batch
      
      while IFS= read -r sample || [ -n "$sample" ]; do
          current_batch+=("$sample")
          if [ "${#current_batch[@]}" -eq "$process_num" ]; then
              echo "${batch_count}:${current_batch[*]}" >> "$batch_info_file"
              current_batch=()
              ((batch_count++))
          fi
      done < "$input_file"
      
      # Process the last incomplete batch
      if [ "${#current_batch[@]}" -gt 0 ]; then
          echo "${batch_count}:${current_batch[*]}" >> "$batch_info_file"
      fi
      
      # Create FIFO file and process control
      if [ "$process" != "all" ]; then
          trap 'rm -f "${FIFO_FILE}"; exit 0' INT TERM EXIT
          if [ ! -e "$FIFO_FILE" ]; then
              mkfifo "$FIFO_FILE" || return 1
          fi
          exec 1000<>"$FIFO_FILE"
          rm -f "$FIFO_FILE"
          
          for ((idx=0; idx<$process_num; idx++)); do
              echo >&1000
          done
      fi
      
      # Export variables for other functions
      export progress_file started_file finished_file
      export batch_info_file temp_batch_log skipped_log failed_log
      export start_time process_num batch_count
      export skipped_samples skipped_times skipped_count
      
      return 0
  }
  #################===========================================================================

  #################===========================================================================
  # Function: Update running samples list (cross-platform compatible sed)
  update_running_samples() {
      local sample="$1"
      local temp_file="${work_dir}/running_samples.tmp.new"
      
      grep -v "^${sample}$" "${work_dir}/running_samples.tmp" > "$temp_file"
      mv "$temp_file" "${work_dir}/running_samples.tmp"
  }

  #################===========================================================================
  # Function: Update start count and batch start information
  update_start_count() {
      local sample="$1"
      local stage_logfiles="$2"
      (
          flock -x 200
          # Record running sample
          echo "$sample" >> "${work_dir}/running_samples.tmp"
          
          started_j=$(cat $started_file)
          started_j=$((started_j + 1))
          echo $started_j > $started_file
          
          # Find actual batch number for the sample
          actual_batch_num=0
          while IFS= read -r batch_line || [ -n "$batch_line" ]; do
              case "$batch_line" in
                  *"$sample"*)
                      actual_batch_num=$(echo "$batch_line" | cut -d':' -f1)
                      break
                      ;;
              esac
          done < "$batch_info_file"
          
          # Check if this batch has already been recorded
          if ! grep -q "^S:${actual_batch_num}:" "$temp_batch_log" 2>/dev/null; then
              batch_samples=$(grep "^${actual_batch_num}:" $batch_info_file | cut -d':' -f2)
              if [ ! -z "$batch_samples" ]; then
                  echo "S:${actual_batch_num}:[$(date '+%Y-%m-%d %H:%M:%S')] [LOG] Started batch $((actual_batch_num + 1)): $batch_samples" >> "$temp_batch_log"
              fi
          fi
          
          update_progress "$stage_logfiles"
      ) 200>>$progress_file
  }
  #################===========================================================================

  #################===========================================================================
  # Function: Record failed samples
  record_failed_sample() {
      local sample="$1"
      
      (
          flock -x 200
          echo "$sample" >> "$failed_log"
          echo "[$(date '+%Y-%m-%d %H:%M:%S')]" > "${failed_log}.time"
      ) 200>>$progress_file
  }
  #################===========================================================================

  #################===========================================================================
  # Function: Update finish count and batch finish information
  update_finish_count() {
      local sample="$1"
      local stage_logfiles="$2"
      (
          flock -x 200
          # Remove completed sample from running list
          update_running_samples "$sample"
          
          finished_j=$(cat $finished_file)
          local current_batch_num=0
          while IFS= read -r batch_line || [ -n "$batch_line" ]; do
              case "$batch_line" in
                  *"$sample"*)
                      current_batch_num=$(echo "$batch_line" | cut -d':' -f1)
                      break
                      ;;
              esac
          done < "$batch_info_file"
          
          # Check if this batch has already been recorded as completed
          if ! grep -q "^F:${current_batch_num}:" "$temp_batch_log"; then
              # Get all samples in the batch
              local batch_samples=$(grep "^${current_batch_num}:" $batch_info_file | cut -d':' -f2)
              
              # Create temporary file to store completed samples
              local temp_completed="${work_dir}/batch_${current_batch_num}_completed.tmp"
              > "$temp_completed"
              
              # Check status of each sample in the batch
              local all_processed=true
              for batch_sample in $batch_samples; do
                  # Skip already skipped samples
                  if grep -q "^${batch_sample}$" "${work_dir}/skipped_samples.tmp" 2>/dev/null; then
                      continue
                  fi
                  
                  # If sample is still running, mark as not completed
                  if grep -q "^${batch_sample}$" "${work_dir}/running_samples.tmp" 2>/dev/null; then
                      all_processed=false
                      break
                  fi
                  
                  # Only add completed samples (exclude failed samples)
                  if ! grep -q "^${batch_sample}$" "${work_dir}/running_samples.tmp" 2>/dev/null && \
                    ! grep -q "^${batch_sample}$" "$failed_log" 2>/dev/null; then
                      echo "$batch_sample" >> "$temp_completed"
                  fi
              done
              
              # If all samples are processed, record batch completion information
              if [ "$all_processed" = true ] && [ -s "$temp_completed" ]; then
                  local completed_samples=$(tr '\n' ' ' < "$temp_completed")
                  echo "F:${current_batch_num}:[$(date '+%Y-%m-%d %H:%M:%S')] [LOG] Finished batch $((current_batch_num + 1)): $completed_samples" >> "$temp_batch_log"
              fi
              
              # Clean up temporary file
              rm -f "$temp_completed"
          fi
          
          # Only increase finish count if sample has not failed
          if ! grep -q "^${sample}$" "$failed_log" 2>/dev/null; then
              finished_j=$((finished_j + 1))
              echo $finished_j > $finished_file
          fi
          
          update_progress "$stage_logfiles"
      ) 200>>$progress_file
  }
  #################===========================================================================

  #################===========================================================================
  # Function: Clean up parallel processing environment
  cleanup_parallel_env() {
      local work_dir="$1"
      
      rm -f "${work_dir}/progress.txt" "${work_dir}/started.txt" \
          "${work_dir}/skipped.log" \
          "${work_dir}/failed.log.time" \
          "${work_dir}/running_samples.tmp" \
          "${work_dir}/finished.txt" "${work_dir}/temp_batch.log" "${work_dir}/failed.log" \
          "${work_dir}/skipped_samples.tmp" "${work_dir}/skipped_count.txt" \
          "${work_dir}/batch_info.tmp"
      
      exec 1000>&- 2>/dev/null
  }
  #################===========================================================================

  #################===========================================================================
  # Function: Update progress (output to stderr and log file)
  update_progress() {
      local stage_logfiles="$1"
      local finished_j=$(cat $finished_file)
      local skipped_j=$(wc -l < "${work_dir}/skipped_samples.tmp" || echo 0)
      local failed_count=$([ -f "$failed_log" ] && wc -l < "$failed_log" || echo 0)
      local running_count=$(wc -l < "${work_dir}/running_samples.tmp" || echo 0)
      local total_finished=$((finished_j + skipped_j))
      local effective_total=$((total_sps - failed_count))
      
      # Ensure running_count is not negative
      if [ "$running_count" -lt 0 ]; then
          running_count=0
      fi
      
      # Calculate progress bar
      local percent=$((total_finished * 100 / total_sps))
      local progress_bar_length=$((total_finished * 50 / total_sps))
      
      # Generate progress bar information
      local progress_info=$(printf "[%s] [INFO] Processing: Running %d/Skipped %d/Finished %d/Failed %d/Total %d [%-50s] %d%%" \
          "$(date '+%Y-%m-%d %H:%M:%S')" \
          "$running_count" \
          "$skipped_j" \
          "$finished_j" \
          "$failed_count" \
          "$total_sps" \
          "$(printf "#%.0s" $(seq 1 $progress_bar_length))" \
          "$percent")

      # If processing is complete, add total time information
      if [ "$total_finished" -eq "$effective_total" ]; then
          end_time=$(date +%s)
          total_time=$((end_time - start_time))
          hours=$((total_time / 3600))
          minutes=$(((total_time % 3600) / 60))
          seconds=$((total_time % 60))
          progress_info="${progress_info} (Total time: ${hours}h ${minutes}m ${seconds}s)"
      fi
      
      # Output to stderr (using \r and clearing line)
      printf "\033[2K\r%s" "$progress_info" >&2
      
      # Only write to log file and add newline when processing is complete
      if [ "$total_finished" -eq "$effective_total" ]; then
          echo "$progress_info" >> "$stage_logfiles"
      fi
  }
  #################===========================================================================

  #################===========================================================================
  # Function: Display processing log
  display_process_log() {
      local log_file="$1"          
      local stage_prefix="$2"      
      local failing_prefix="$3"

      local info_cmd="${stage_prefix}_info"
      local log_cmd="${stage_prefix}_log"
      local error_cmd="${stage_prefix}_error"
      local blank_cmd="${stage_prefix}_blank"
      
      if [ "${process}" = "all" ]; then
          $info_cmd "${log_mode}" "Processing log (by batches with all samples parallel processes):"
      else
          $info_cmd "${log_mode}" "Processing log (by batches with ${process} samples parallel processes):"
      fi
      
      # Display skipped sample information
      if [ -s "$skipped_log" ]; then
          cat "$skipped_log" | tee -a "$log_file"
      fi
      
      # Create temporary file to store sorted log
      local sorted_log="${work_dir}/sorted_log.tmp"
      > "$sorted_log"
      
      # Display processing log by batch order
      local current_batch=0
      while true; do
          # Check if there are more batches
          if ! grep -q "^[SF]:${current_batch}:" "$temp_batch_log" 2>/dev/null; then
              if [ $current_batch -eq 0 ]; then
                  break
              fi
              ((current_batch++))
              if ! grep -q "^[SF]:${current_batch}:" "$temp_batch_log" 2>/dev/null; then
                  break
              fi
          fi
          
          # Get and display Started information for current batch
          grep "^S:${current_batch}:" "$temp_batch_log" 2>/dev/null | sed 's/^S:[0-9]*://' >> "$sorted_log"
          
          # Get and display Finished information for current batch
          grep "^F:${current_batch}:" "$temp_batch_log" 2>/dev/null | sed 's/^F:[0-9]*://' >> "$sorted_log"
          
          ((current_batch++))
      done
      
      # Display sorted log
      if [ -s "$sorted_log" ]; then
          cat "$sorted_log" | while read line; do
              echo "$line" | tee -a "$log_file"
          done
      fi
      
      # Display failed sample information
      if [ -s "$failed_log" ]; then
          failed_time=$(cat "${failed_log}.time" 2>/dev/null || echo "[$(date '+%Y-%m-%d %H:%M:%S')]")
          failed_samples=$(tr '\n' ' ' < "$failed_log")
          echo "${failed_time} [LOG] ${failing_prefix} ${failed_samples}" | tee -a "$log_file"
      fi
      
      # Clean up temporary file
      rm -f "$sorted_log"
  }

  #################===========================================================================
  
  #################===========================================================================
  # Function: Running MAFFT and TrimAl
  remove_n() {
    local input_fasta=$1
    awk '/^>/ {
        if (seq) {
          if (seq ~ /[ATCGatcg]/) {
            print header
            print seq
          }
        }
        header = $0
        seq = ""
        next
      }
      {
        seq = seq $0
      }
      END {
        if (seq ~ /[ATCGatcg]/) {
          print header
          print seq
        }
      }' "${input_fasta}" > "${input_fasta}.temp"
      mv "${input_fasta}.temp" "${input_fasta}"
  }
  
  run_mafft() {
      local input=$1
      local output=$2
      local threads=$3
      local mafft_cmd
      
      case "${mafft_algorithm}" in
          "auto")
              mafft_cmd="mafft --auto"
              ;;
          "linsi")
              # L-INS-i supports gap parameters
              mafft_cmd="mafft-linsi --op 3 --ep 0.123"
              ;;
          "ginsi")
              mafft_cmd="mafft-ginsi"
              ;;
          "einsi")
              mafft_cmd="mafft-einsi"
              ;;
          *)
              stage_error "Unknown MAFFT algorithm: ${mafft_algorithm}"
              return 1
              ;;
      esac

      mafft_cmd="${mafft_cmd} --quiet --thread ${threads}"
      if [ "${mafft_maxiterate}" != "_____" ]; then
          mafft_cmd="${mafft_cmd} --maxiterate ${mafft_maxiterate}"
      fi

      if [ "${mafft_pair}" = "global" ]; then
          mafft_cmd="${mafft_cmd} --globalpair"
      elif [ "${mafft_pair}" = "local" ]; then
          mafft_cmd="${mafft_cmd} --localpair"
      fi
      
      if [ "${mafft_algorithm}" = "linsi" ] && [ "${mafft_adjustdirection}" = "TRUE" ]; then
          mafft_cmd="${mafft_cmd} --adjustdirectionaccurately"
      fi

      mafft_cmd="${mafft_cmd} ${input} > ${output}"

      eval "${mafft_cmd}" 2>/dev/null

      if [ -s "${output}" ]; then
          return 0
      else
          stage_error "MAFFT alignment failed"
          return 1
      fi
  }

  run_trimal() {
      local input_file=$1
      local output_file=$2
      local trimal_mode=$3
      local gap_threshold=$4
      local sim_threshold=$5
      local cons=$6
      local block=$7
      local res_overlap=$8
      local seq_overlap=$9
      local w=${10}
      local gw=${11}
      local sw=${12}
      local trimal_cmd="trimal"

      trimal_cmd="${trimal_cmd} -in ${input_file} -out ${output_file}"

      case "${trimal_mode}" in
          "nogaps")
              trimal_cmd="${trimal_cmd} -nogaps"
              ;;
          "noallgaps")
              trimal_cmd="${trimal_cmd} -noallgaps"
              ;;
          "gappyout")
              trimal_cmd="${trimal_cmd} -gappyout"
              ;;
          "strict")
              trimal_cmd="${trimal_cmd} -strict"
              ;;
          "strictplus")
              trimal_cmd="${trimal_cmd} -strictplus"
              ;;
          "automated1")
              trimal_cmd="${trimal_cmd} -automated1"
              ;;
          *)
              stage_error "Invalid trimal mode: ${trimal_mode}. Please choose from nogaps, noallgaps, gappyout, strict, strictplus, automated1."
              return 1
              ;;
      esac

      if [ "${gap_threshold}" != "_____" ]; then
          trimal_cmd="${trimal_cmd} -gt ${gap_threshold}"
      fi

      if [ "${sim_threshold}" != "_____" ]; then
          trimal_cmd="${trimal_cmd} -st ${sim_threshold}"
      fi

      if [ "${cons}" != "_____" ]; then
          trimal_cmd="${trimal_cmd} -cons ${cons}"
      fi

      if [ "${block}" != "_____" ]; then
        trimal_cmd="${trimal_cmd} -block ${block}"
      fi

      if [ "${res_overlap}" != "_____" ]; then
      trimal_cmd="${trimal_cmd} -resoverlap ${res_overlap}"
      fi

      if [ "${seq_overlap}" != "_____" ]; then
          trimal_cmd="${trimal_cmd} -seqoverlap ${seq_overlap}"
      fi

      if [ "${w}" != "_____" ]; then
          trimal_cmd="${trimal_cmd} -w ${window_size}"
      fi

      if [ "${gw}" != "_____" ]; then
          trimal_cmd="${trimal_cmd} -gw ${gw}"
      fi

      if [ "${sw}" != "_____" ]; then
          trimal_cmd="${trimal_cmd} -sw ${sw}"
      fi
      eval "${trimal_cmd}" 2>/dev/null
  }
stage_info "Finish"


# Stage 1: NGS dataset construction
if [ "${skip_stage1}" = "TRUE" ] || [ "${skip_stage12}" = "TRUE" ] || [ "${skip_stage123}" = "TRUE" ] || [ "${skip_stage1234}" = "TRUE" ]; then
  stage_info_main "Stage 1 NGS dataset construction is skipped."
else
  ############################################################################################
  #===> Stage 1 NGS dataset construction <===#################################################
  ############################################################################################

  #################===========================================================================
  mkdir -p "${output_dir}/00-logs_and_checklists/logs" "${output_dir}/00-logs_and_checklists/checklists" "${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra" "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz" "${NGS_dir}/02-Downloaded_clean_data" "${NGS_dir}/03-My_clean_data"
  #################===========================================================================
  stage_info_main "<<<======= Stage 1 NGS dataset construction=======>>>"
  #################===========================================================================

  ############################################################################################
  # Stage1-Step1: Download NGS raw data from NCBI via SRAToolKit (sra-tools) #################
  ############################################################################################
  # Use sratoolkit to batch download sra data, then use fasterq-dump to convert the original sra data to fastq/fastq.gz format, and decide whether to delete sra data according to the parameters provided by the user
  if [ -s "${output_dir}/00-logs_and_checklists/checklists/Public_Spname_SRR.txt" ]; then
      # Define total samples number
      total_sps=$(awk 'NF' "${output_dir}/00-logs_and_checklists/checklists/Public_Spname_SRR.txt" | grep -c '^')
      # Initialize parallel environment
      init_parallel_env "$work_dir" "$total_sps" "$process" "${output_dir}/00-logs_and_checklists/checklists/Public_Spname_SRR.txt" || exit 1
      define_threads "pigz"
      define_threads "fasterq_dump"
      stage_info_main "Step1: Downloading raw data for ${total_sps} samples with ${process_num} parallel processes from NCBI..."
      stage_info_main "====>> Running sratoolkit to download raw data (${process} in parallel) ====>>"
      while IFS= read -r sample || [ -n "$sample" ]; do
          spname=$(echo "${sample}" | awk '{print $1}')
          srr=$(echo "${sample}" | awk '{print $2}')
          if [ "${process}" != "all" ]; then
              read -u1000
          fi
          # Here you can define skip conditions
          if { [ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq.gz" ] && [ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq.gz" ]; } || [ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq.gz" ]; then
              record_skipped_sample "$spname" "Skipped downloading existing samples:" "$stage_logfile"
              if [ "${process}" != "all" ]; then
                  echo >&1000
              fi
              continue
          fi
          {
              
              # Update start count
              update_start_count "$spname" "$stage_logfile"

              # Your processing logic
              if [ "$download_format" = "fastq_gz" ]; then
                  # prefetch
                  prefetch "$srr" -O "${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra/" --max-size "${sra_maxsize}" > /dev/null 2>&1

                  # fasterq-dump
                  if [ -s "${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra" ]; then
                    fasterq-dump ${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra -e ${nt_fasterq_dump} -p -O ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/ > /dev/null 2>&1
                  fi

                  # pigz for single-ended
                  if [ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq" ]; then
                      pigz -p ${nt_pigz} ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq > /dev/null 2>&1
                  fi

                  # pigz for pair-ended
                  if [ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq" ] && [ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq" ]; then
                      pigz -p ${nt_pigz} ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq > /dev/null 2>&1
                      pigz -p ${nt_pigz} ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq > /dev/null 2>&1
                  fi

                  #remove the srr files
                  if [ "$rm_sra" != "FALSE" ]; then
                      rm -r ${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}          
                  fi

                  #rename the files
                  if [ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq.gz" ] && [ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq.gz" ]; then
                      mv "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq.gz" "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq.gz"
                      mv "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq.gz" "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq.gz"
                  fi
                  if [ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq.gz" ]; then
                      mv "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq.gz" "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq.gz"
                  fi
              fi
              #if the user choose the format of downloading as fastq
              if [ "$download_format" = "fastq" ]; then
                  # prefetch
                  prefetch "$srr" -O "${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra/" --max-size "${sra_maxsize}" > /dev/null 2>&1

                  # fasterq-dump
                  if [ -s "${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra" ]; then
                    fasterq-dump ${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra -e ${nt_fasterq_dump} -p -O ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/ > /dev/null 2>&1
                  fi

                  #rename the files
                  if [ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq" ] && [ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq" ]; then
                      mv "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq" "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq"
                      mv "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq" "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq"
                  fi
                  if [ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq" ]; then
                      mv "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq" "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq"
                  fi
              fi
              if ([ ! -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq" ] || [ ! -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq" ]) && [ ! -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq" ]; then
                  record_failed_sample "$spname"
              else
                  # Update finish count
                  update_finish_count "$spname" "$stage_logfile"
              fi
              if [ "${process}" != "all" ]; then
                  echo >&1000
              fi
          } &
      done < "${output_dir}/00-logs_and_checklists/checklists/Public_Spname_SRR.txt"
      # Wait for all tasks to complete
      wait
      echo
      # Display processing log
      if [ "${log_mode}" = "full" ]; then
        display_process_log "$stage_logfile" "stage1" "Failed to download raw data:"
      fi
      stage_blank_main ""
  fi
  ############################################################################################

  ############################################################################################
  #Stage1-Step2: Remove the adapters via Trimmomatic #########################################
  ############################################################################################
  # Filter NGS raw data via trimmomatic
  # Raw data filtering of NCBI public data
  stage_info_main "Step2: Removing adapters of raw data via Trimmomatic-0.39 ..."
  cd ${NGS_dir}
  define_threads "trimmomatic"
  if [ -s "${output_dir}/00-logs_and_checklists/checklists/Public_Spname_SRR.txt" ]; then
      total_sps=$(awk 'NF' "${output_dir}/00-logs_and_checklists/checklists/Public_Spname_SRR.txt" | grep -c '^')
      # Initialize parallel environment
      init_parallel_env "$work_dir" "$total_sps" "$process" "${output_dir}/00-logs_and_checklists/checklists/Public_Spname_SRR.txt" || exit 1
      stage_info_main "====>> Removing adapters for downloaded raw data of ${total_sps} samples (${process} in parallel) ====>>"
      stage_info_main "Sequences that have already had adapters removed will not be trimmed for adapters again!!!"
      while IFS= read -r sample || [ -n "$sample" ]; do
          spname=$(echo "${sample}" | awk '{print $1}')
          if [ "${process}" != "all" ]; then
            read -u1000
          fi
          # Skip samples that have already had adapters removed
          if { [ -s "${NGS_dir}/02-Downloaded_clean_data/${spname}_1_clean.paired.fq.gz" ] && [ -s "${NGS_dir}/02-Downloaded_clean_data/${spname}_2_clean.paired.fq.gz" ]; } || [ -s "${NGS_dir}/02-Downloaded_clean_data/${spname}_clean.single.fq.gz" ]; then
              record_skipped_sample "$spname" "Skipped removing adapters for samples:" "$stage_logfile"
              if [ "${process}" != "all" ]; then
                  echo >&1000
              fi
              continue
          fi
          {
          # Update start count
          update_start_count "$spname" "$stage_logfile"
          if ([ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq" ] && [ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq" ]) \
          || ([ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq.gz" ] && [ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq.gz" ]); then
              files1=(${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.f*)
              files2=(${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.f*)
              if [ ${#files1[@]} -gt 0 ] && [ ${#files2[@]} -gt 0 ]; then
                  trimmomatic PE \
                      -threads ${nt_trimmomatic} \
                      -phred33 \
                      ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.f* ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.f* \
                      ./02-Downloaded_clean_data/${spname}_1_clean.paired.fq.gz ./02-Downloaded_clean_data/${spname}_1_clean.unpaired.fq.gz \
                      ./02-Downloaded_clean_data/${spname}_2_clean.paired.fq.gz ./02-Downloaded_clean_data/${spname}_2_clean.unpaired.fq.gz \
                      ILLUMINACLIP:$CONDA_PREFIX/share/trimmomatic/adapters/TruSeq3-PE-2.fa:2:30:10 \
                      SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} \
                      LEADING:${trimmomatic_leading_quality} \
                      TRAILING:${trimmomatic_trailing_quality} \
                      MINLEN:${trimmomatic_min_length} > /dev/null 2>&1
              fi
          fi
          #for single-ended
          if [ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq" ] \
          || [ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq.gz" ]; then  
              files3=(${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.f*)
              if [ ${#files3[@]} -gt 0 ]; then
                  trimmomatic SE \
                      -threads ${nt_trimmomatic} \
                      -phred33 \
                      ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.f* \
                      ${NGS_dir}/02-Downloaded_clean_data/${spname}_clean.single.fq.gz \
                      ILLUMINACLIP:$CONDA_PREFIX/share/trimmomatic/adapters/TruSeq3-SE.fa:2:30:10 \
                      SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} \
                      LEADING:${trimmomatic_leading_quality} \
                      TRAILING:${trimmomatic_trailing_quality} \
                      MINLEN:${trimmomatic_min_length} > /dev/null 2>&1
              fi
          fi
          if [ ! -s "${NGS_dir}/02-Downloaded_clean_data/${spname}_clean.single.fq.gz" ] && ([ ! -s "${NGS_dir}/02-Downloaded_clean_data/${spname}_1_clean.paired.fq.gz" ] || [ ! -s "${NGS_dir}/02-Downloaded_clean_data/${spname}_2_clean.paired.fq.gz" ]); then
              record_failed_sample "$spname"
          else
              # Update finish count
              update_finish_count "$spname" "$stage_logfile"
          fi
          if [ "${process}" != "all" ]; then
              echo >&1000
          fi
        } &
      done < "${output_dir}/00-logs_and_checklists/checklists/Public_Spname_SRR.txt"
      wait
      echo
      # Display processing log
      if [ "${log_mode}" = "full" ]; then
        display_process_log "$stage_logfile" "stage1" "Failed to remove adapters for samples:"
      fi
  fi

  if [ -s "${output_dir}/00-logs_and_checklists/checklists/My_Spname.txt" ] && [ -e "${input_data}" ]; then
    # Define total samples number
    total_sps=$(awk 'NF' "${output_dir}/00-logs_and_checklists/checklists/My_Spname.txt" | grep -c '^')
    # Initialize parallel environment
    init_parallel_env "$work_dir" "$total_sps" "$process" "${output_dir}/00-logs_and_checklists/checklists/My_Spname.txt"
    stage_info_main "====>> Removing adapters for existing (user-provided) raw data of ${total_sps} samples (${process} in parallel) ====>>"
    stage_info_main "Sequences that have already had adapters removed will not be trimmed for adapters again!!!"
    while IFS= read -r sample || [ -n "$sample" ]; do
      if [ "${process}" != "all" ]; then
          read -u1000
      fi
      # Skip samples that have already had adapters removed
      if { [ -s "${NGS_dir}/03-My_clean_data/${sample}_1_clean.paired.fq.gz" ] && [ -s "${NGS_dir}/03-My_clean_data/${sample}_2_clean.paired.fq.gz" ]; } || [ -s "${NGS_dir}/03-My_clean_data/${sample}_clean.single.fq.gz" ]; then
        record_skipped_sample "$sample" "Skipped removing adapters for samples:" "$stage_logfile"
        if [ "${process}" != "all" ]; then
            echo >&1000
        fi
        continue
      fi
      {
          # Update start count
          update_start_count "$sample" "$stage_logfile"
          #for pair-ended
          files1=(${my_raw_data}/${sample}_1.f*)
          files2=(${my_raw_data}/${sample}_2.f*)
          if [ ${#files1[@]} -gt 0 ] && [ ${#files2[@]} -gt 0 ]; then
              trimmomatic PE \
                  -threads ${nt_trimmomatic} \
                  -phred33 \
                  ${my_raw_data}/${sample}_1.f* ${my_raw_data}/${sample}_2.f* \
                  ${NGS_dir}/03-My_clean_data/${sample}_1_clean.paired.fq.gz ${NGS_dir}/03-My_clean_data/${sample}_1_clean.unpaired.fq.gz \
                  ${NGS_dir}/03-My_clean_data/${sample}_2_clean.paired.fq.gz ${NGS_dir}/03-My_clean_data/${sample}_2_clean.unpaired.fq.gz \
                  ILLUMINACLIP:$CONDA_PREFIX/share/trimmomatic/adapters/TruSeq3-PE-2.fa:2:30:10 \
                  SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} \
                  LEADING:${trimmomatic_leading_quality} \
                  TRAILING:${trimmomatic_trailing_quality} \
                  MINLEN:${trimmomatic_min_length} > /dev/null 2>&1
          fi
          #for single-ended 
          files3=(${my_raw_data}/${sample}.f*)
          if [ ${#files3[@]} -gt 0 ]; then
              trimmomatic SE \
                  -threads ${nt_trimmomatic} \
                  -phred33 \
                  ${my_raw_data}/${sample}.f* \
                  ${NGS_dir}/03-My_clean_data/${sample}_clean.single.fq.gz \
                  ILLUMINACLIP:$CONDA_PREFIX/share/trimmomatic/adapters/TruSeq3-SE.fa:2:30:10 \
                  SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} \
                  LEADING:${trimmomatic_leading_quality} \
                  TRAILING:${trimmomatic_trailing_quality} \
                  MINLEN:${trimmomatic_min_length} > /dev/null 2>&1
          fi
          if [ ! -s "${NGS_dir}/03-My_clean_data/${sample}_clean.single.fq.gz" ] && ([ ! -s "${NGS_dir}/03-My_clean_data/${sample}_1_clean.paired.fq.gz" ] || [ ! -s "${NGS_dir}/03-My_clean_data/${sample}_2_clean.paired.fq.gz" ]); then
              record_failed_sample "$sample"
          else
              # Update finish count
              update_finish_count "$sample" "$stage_logfile"
          fi
          if [ "${process}" != "all" ]; then
              echo >&1000
          fi
      } &
    done < "${output_dir}/00-logs_and_checklists/checklists/My_Spname.txt"
    # Wait for all tasks to complete
    wait
    echo
    # Display processing log
    if [ "${log_mode}" = "full" ]; then
      display_process_log "$stage_logfile" "stage1" "Failed to remove adapters for samples:"
    fi
  fi

  ############################################################################################
  # End of Stage 1
  stage_info "${log_mode}" "Successfully finishing running stage1: 'NGS database construction'. "
  stage_info "${log_mode}" "The NGS raw data and clean data have been output to ${NGS_dir}"
  if [ "${run_to_stage1}" = "true" ]; then
    # Clean up environment
    cleanup_parallel_env "$work_dir"
    stage_info "${log_mode}" "You set '--run_to_stage1' to specify HybSuite to run only stage 1."
    stage_info "${log_mode}" "Consequently, HybSuite will stop and exit right now."
    stage_info_main "Thank you for using HybSuite! Enjoy your research!"
    stage_blank_main ""
    exit 1
  else
    stage_info "${log_mode}" "Now moving on to the next stage ..."
    stage_blank_main ""
  fi
  ############################################################################################
fi

############################################################################################
# Data assembly and filtered paralogs retrieving ###################################
############################################################################################
if [ "${skip_stage12}" = "TRUE" ] || [ "${skip_stage123}" = "TRUE" ] || [ "${skip_stage1234}" = "TRUE" ]; then
  stage_info_main "Stage 2 Data assembly and filtered paralogs retrieving is skipped."
else
  ############################################################################################
  # 0.Preparation
  # (1) Change working directory and conda environment
  mkdir -p "${eas_dir}"
  cd "${eas_dir}"
  stage_info_main "<<<======= Stage 2 Data assembly and filtered paralogs retrieving =======>>>"
  # (2) Define threads
  define_threads "hybpiper"
  stage_blank "${log_mode}" ""
  ############################################################################################

  #################===========================================================================
  # (4) Backup existing namelist file
  [ -s "${eas_dir}/Assembled_data_namelist.txt" ] && cp "${eas_dir}/Assembled_data_namelist.txt" "${eas_dir}/Old_assembled_data_namelist_${current_time}.txt"
  # (5) Create a new namelist file
  > "${eas_dir}/Assembled_data_namelist.txt"
  # (6) Process namelist based on input files
  if [ "${found_public}" = "1" ] && [ "${found_own}" != "1" ]; then
    # When only SRR data exists, use NCBI species list directly
    cp "${output_dir}/00-logs_and_checklists/checklists/Public_Spname.txt" "${eas_dir}/Assembled_data_namelist.txt"
  elif [ "${found_own}" = "1" ] && [ "${found_public}" != "1" ]; then
    # When only custom data exists, use My_Spname directly
    cp "${output_dir}/00-logs_and_checklists/checklists/My_Spname.txt" "${eas_dir}/Assembled_data_namelist.txt"
  elif [ "${found_own}" = "1" ] && [ "${found_public}" = "1" ]; then
    # When both types of data exist, merge the lists
    cat "${output_dir}/00-logs_and_checklists/checklists/Public_Spname.txt" "${output_dir}/00-logs_and_checklists/checklists/My_Spname.txt" | sed '/^$/d' > "${eas_dir}/Assembled_data_namelist.txt"
  fi
  #################===========================================================================


  ############################################################################################
  #Stage2-Step1: Data assembly ###############################################################
  ############################################################################################

  #################===========================================================================
  stage_info_main "Step 1: Assembling data using 'hybpiper assemble'..."
  cd "${eas_dir}"
  #################===========================================================================
  if [ "${found_public}" = "1" ]; then
    total_sps=$(awk 'END {print NR}' "${output_dir}/00-logs_and_checklists/checklists/Public_Spname.txt")
    init_parallel_env "$work_dir" "$total_sps" "$process" "${output_dir}/00-logs_and_checklists/checklists/Public_Spname.txt" || exit 1
    stage_info_main "====>> Running 'hybpiper assemble' to assemble public data (${process} in parallel) ====>>"
    while IFS= read -r Spname || [ -n "$Spname" ]; do
      if [ "${process}" != "all" ]; then
          read -u1000
      fi
      # Here you can define skip conditions
      if [ -s "${eas_dir}/${Spname}/genes_with_seqs.txt" ]; then
          record_skipped_sample "$Spname" "Skipped data assembly for existing samples:" "$stage_logfile"
          if [ "${process}" != "all" ]; then
            echo >&1000
          fi
          continue
      fi
      # Your processing logic
      if [ -e "${eas_dir}/${Spname}" ] && [ ! -e "${eas_dir}/${Spname}/genes_with_seqs.txt" ]; then
          rm -rf "${eas_dir}/${Spname}/"*
      fi
      {
        # Update start count
        update_start_count "$Spname" "$stage_logfile"
      
        # Run the loop
        if [ -d "${Spname}" ] && [ ! -s "${Spname}/${Spname}_chimera_check_performed.txt" ]; then
          echo "True" > "${Spname}/${Spname}_chimera_check_performed.txt"
        fi
        # For paired-end
        if ([ -s "${NGS_dir}/02-Downloaded_clean_data/${Spname}_1_clean.paired.fq.gz" ] && [ -s "${NGS_dir}/02-Downloaded_clean_data/${Spname}_2_clean.paired.fq.gz" ]) \
        && [ ! -s "${NGS_dir}/02-Downloaded_clean_data/${Spname}_clean.single.fq.gz" ]; then
          # 01: for protein reference sequence
          # Use diamond to map reads
          if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "diamond" ]; then
              stage_cmd "${log_mode}" "hybpiper assemble "-t_${hybpiper_tt}" ${t} -r ${NGS_dir}/02-Downloaded_clean_data/${Spname}_1_clean.paired.fq.gz ${NGS_dir}/02-Downloaded_clean_data/${Spname}_2_clean.paired.fq.gz -o ${eas_dir} --prefix ${Spname} --diamond --cpu ${nt_hybpiper}"
              hybpiper assemble "-t_${hybpiper_tt}" ${t} \
              -r ${NGS_dir}/02-Downloaded_clean_data/${Spname}_1_clean.paired.fq.gz ${NGS_dir}/02-Downloaded_clean_data/${Spname}_2_clean.paired.fq.gz \
              -o ${eas_dir} \
              --prefix ${Spname} \
              --diamond \
              --cpu ${nt_hybpiper} > /dev/null 2>&1
          fi
          # Use BLASTx (default) to map reads
          if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "blast" ]; then
              stage_cmd "${log_mode}" "hybpiper assemble "-t_${hybpiper_tt}" ${t} -r ${NGS_dir}/02-Downloaded_clean_data/${Spname}_1_clean.paired.fq.gz ${NGS_dir}/02-Downloaded_clean_data/${Spname}_2_clean.paired.fq.gz -o ${eas_dir} --prefix ${Spname} --cpu ${nt_hybpiper}"
              hybpiper assemble "-t_${hybpiper_tt}" ${t} \
              -r ${NGS_dir}/02-Downloaded_clean_data/${Spname}_1_clean.paired.fq.gz ${NGS_dir}/02-Downloaded_clean_data/${Spname}_2_clean.paired.fq.gz \
              -o ${eas_dir} \
              --prefix ${Spname} \
              --cpu ${nt_hybpiper} > /dev/null 2>&1
          fi
          # 02: for nucleotide reference sequence
          if [ "${hybpiper_tt}" = "dna" ]; then
              stage_cmd "${log_mode}" "hybpiper assemble "-t_${hybpiper_tt}" ${t} -r ${NGS_dir}/02-Downloaded_clean_data/${Spname}_1_clean.paired.fq.gz ${NGS_dir}/02-Downloaded_clean_data/${Spname}_2_clean.paired.fq.gz -o ${eas_dir} --prefix ${Spname} --bwa --cpu ${nt_hybpiper}"
              hybpiper assemble "-t_${hybpiper_tt}" ${t} \
              -r ${NGS_dir}/02-Downloaded_clean_data/${Spname}_1_clean.paired.fq.gz ${NGS_dir}/02-Downloaded_clean_data/${Spname}_2_clean.paired.fq.gz \
              -o ${eas_dir} \
              --prefix ${Spname} \
              --bwa \
              --cpu ${nt_hybpiper} > /dev/null 2>&1
          fi
        fi
        # For single-end
        if ([ ! -s "${NGS_dir}/02-Downloaded_clean_data/${Spname}_1_clean.paired.fq.gz" ] && [ ! -s "${NGS_dir}/02-Downloaded_clean_data/${Spname}_2_clean.paired.fq.gz" ]) \
        && [ -s "${NGS_dir}/02-Downloaded_clean_data/${Spname}_clean.single.fq.gz" ]; then
          # 01: for protein reference sequence
          # 01-1: use diamond to map reads
          if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "diamond" ]; then
              stage_cmd "${log_mode}" "hybpiper assemble "-t_${hybpiper_tt}" ${t} -r ${NGS_dir}/02-Downloaded_clean_data/${Spname}_clean.single.fq.gz -o ${eas_dir} --prefix ${Spname} --diamond --cpu ${nt_hybpiper}"
              hybpiper assemble "-t_${hybpiper_tt}" ${t} \
              -r ${NGS_dir}/02-Downloaded_clean_data/${Spname}_clean.single.fq.gz \
              -o ${eas_dir} \
              --prefix ${Spname} \
              --diamond \
              --cpu ${nt_hybpiper} > /dev/null 2>&1
          fi
          # 01-2: use BLASTx (default) to map reads
          if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "blast" ]; then
              stage_cmd "${log_mode}" "hybpiper assemble "-t_${hybpiper_tt}" ${t} -r ${NGS_dir}/02-Downloaded_clean_data/${Spname}_clean.single.fq.gz -o ${eas_dir} --prefix ${Spname} --cpu ${nt_hybpiper}"
              hybpiper assemble "-t_${hybpiper_tt}" ${t} \
              -r ${NGS_dir}/02-Downloaded_clean_data/${Spname}_clean.single.fq.gz \
              -o ${eas_dir} \
              --prefix ${Spname} \
              --cpu ${nt_hybpiper} > /dev/null 2>&1
          fi
          # 02: for nucleotide reference sequence
          if [ "${hybpiper_tt}" = "dna" ]; then
              stage_cmd "${log_mode}" "hybpiper assemble "-t_${hybpiper_tt}" ${t} -r ${NGS_dir}/02-Downloaded_clean_data/${Spname}_clean.single.fq.gz -o ${eas_dir} --prefix ${Spname} --bwa --cpu ${nt_hybpiper}"
              hybpiper assemble "-t_${hybpiper_tt}" ${t} \
              -r ${NGS_dir}/02-Downloaded_clean_data/${Spname}_clean.single.fq.gz \
              -o ${eas_dir} \
              --prefix ${Spname} \
              --bwa \
              --cpu ${nt_hybpiper} > /dev/null 2>&1 
          fi
        fi
        if [ -s "${eas_dir}/${Spname}/genes_with_seqs.txt" ]; then
            update_finish_count "$Spname" "$stage_logfile"
        else
            record_failed_sample "$Spname"
        fi
        if [ "${process}" != "all" ]; then
            echo >&1000
        fi
      } &
    done < "${output_dir}/00-logs_and_checklists/checklists/Public_Spname.txt"
    # Wait for all tasks to complete
    wait
    echo
    # Display processing log
    if [ "${log_mode}" = "full" ]; then
      display_process_log "$stage_logfile" "stage2" "Failed to assemble data:"
    fi
    stage_blank_main ""
  fi

  if [ -s "${output_dir}/00-logs_and_checklists/checklists/My_Spname.txt" ]; then
    total_sps=$(awk 'END {print NR}' "${output_dir}/00-logs_and_checklists/checklists/My_Spname.txt")
    init_parallel_env "$work_dir" "$total_sps" "$process" "${output_dir}/00-logs_and_checklists/checklists/My_Spname.txt" || exit 1
    stage_info_main "====>> Running 'hybpiper assemble' to assemble user-provided data (${process} in parallel) ====>>"
    while IFS= read -r Spname || [ -n "$Spname" ]; do
      if [ "${process}" != "all" ]; then
          read -u1000
      fi
      # Here you can define skip conditions
      if [ -s "${eas_dir}/${Spname}/genes_with_seqs.txt" ]; then
          record_skipped_sample "$Spname" "Skipped data assembly for existing samples:" "$stage_logfile"
          if [ "${process}" != "all" ]; then
            echo >&1000
          fi
          continue
      fi
      # Your processing logic
      if [ -e "${eas_dir}/${Spname}" ] && [ ! -e "${eas_dir}/${Spname}/genes_with_seqs.txt" ]; then
          rm -rf "${eas_dir}/${Spname}/"*
      fi
      {
        # Update start count
        update_start_count "$Spname" "$stage_logfile"
      
        # Run the loop
        if [ -d "${Spname}" ] && [ ! -s "${Spname}/${Spname}_chimera_check_performed.txt" ]; then
          echo "True" > "${Spname}/${Spname}_chimera_check_performed.txt"
        fi
        # For paired-end
        if ([ -s "${NGS_dir}/03-My_clean_data/${Spname}_1_clean.paired.fq.gz" ] && [ -s "${NGS_dir}/03-My_clean_data/${Spname}_2_clean.paired.fq.gz" ]) \
        && [ ! -s "${NGS_dir}/03-My_clean_data/${Spname}_clean.single.fq.gz" ]; then
          # 01: for protein reference sequence
          # Use diamond to map reads
          if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "diamond" ]; then
              stage_cmd "${log_mode}" "hybpiper assemble -t_${hybpiper_tt} ${t} -r ${NGS_dir}/03-My_clean_data/${Spname}_1_clean.paired.fq.gz ${NGS_dir}/03-My_clean_data/${Spname}_2_clean.paired.fq.gz -o ${eas_dir} --prefix ${Spname} --diamond --cpu ${nt_hybpiper}"
              hybpiper assemble -t_${hybpiper_tt} ${t} \
              -r ${NGS_dir}/03-My_clean_data/${Spname}_1_clean.paired.fq.gz ${NGS_dir}/03-My_clean_data/${Spname}_2_clean.paired.fq.gz \
              -o ${eas_dir} \
              --prefix ${Spname} \
              --diamond \
              --cpu ${nt_hybpiper} > /dev/null 2>&1
          fi
          # Use BLASTx (default) to map reads
          if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "blast" ]; then
              stage_cmd "${log_mode}" "hybpiper assemble -t_${hybpiper_tt} ${t} -r ${NGS_dir}/03-My_clean_data/${Spname}_1_clean.paired.fq.gz ${NGS_dir}/03-My_clean_data/${Spname}_2_clean.paired.fq.gz -o ${eas_dir} --prefix ${Spname} --cpu ${nt_hybpiper}"
              hybpiper assemble -t_${hybpiper_tt} ${t} \
              -r ${NGS_dir}/03-My_clean_data/${Spname}_1_clean.paired.fq.gz ${NGS_dir}/03-My_clean_data/${Spname}_2_clean.paired.fq.gz \
              -o ${eas_dir} \
              --prefix ${Spname} \
              --cpu ${nt_hybpiper} > /dev/null 2>&1
          fi
          # 02: for nucleotide reference sequence
          if [ "${hybpiper_tt}" = "dna" ]; then
              stage_cmd "${log_mode}" "hybpiper assemble -t_${hybpiper_tt} ${t} -r ${NGS_dir}/03-My_clean_data/${Spname}_1_clean.paired.fq.gz ${NGS_dir}/03-My_clean_data/${Spname}_2_clean.paired.fq.gz -o ${eas_dir} --prefix ${Spname} --bwa --cpu ${nt_hybpiper}"
              hybpiper assemble -t_${hybpiper_tt} ${t} \
              -r ${NGS_dir}/03-My_clean_data/${Spname}_1_clean.paired.fq.gz ${NGS_dir}/03-My_clean_data/${Spname}_2_clean.paired.fq.gz \
              -o ${eas_dir} \
              --prefix ${Spname} \
              --bwa \
              --cpu ${nt_hybpiper} > /dev/null 2>&1
          fi
        fi
        # For single-end
        if ([ ! -s "${NGS_dir}/03-My_clean_data/${Spname}_1_clean.paired.fq.gz" ] && [ ! -s "${NGS_dir}/03-My_clean_data/${Spname}_2_clean.paired.fq.gz" ]) \
        && [ -s "${NGS_dir}/03-My_clean_data/${Spname}_clean.single.fq.gz" ]; then
          # 01: for protein reference sequence
          # 01-1: use diamond to map reads
          if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "diamond" ]; then
              stage_cmd "${log_mode}" "hybpiper assemble -t_${hybpiper_tt} ${t} -r ${NGS_dir}/03-My_clean_data/${Spname}_clean.single.fq.gz -o ${eas_dir} --prefix ${Spname} --diamond --cpu ${nt_hybpiper}"
              hybpiper assemble -t_${hybpiper_tt} ${t} \
              -r ${NGS_dir}/03-My_clean_data/${Spname}_clean.single.fq.gz \
              -o ${eas_dir} \
              --prefix ${Spname} \
              --diamond \
              --cpu ${nt_hybpiper} > /dev/null 2>&1
          fi
          # 01-2: use BLASTx (default) to map reads
          if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "blast" ]; then
              stage_cmd "${log_mode}" "hybpiper assemble -t_${hybpiper_tt} ${t} -r ${NGS_dir}/03-My_clean_data/${Spname}_clean.single.fq.gz -o ${eas_dir} --prefix ${Spname} --cpu ${nt_hybpiper}"
              hybpiper assemble -t_${hybpiper_tt} ${t} \
              -r ${NGS_dir}/03-My_clean_data/${Spname}_clean.single.fq.gz \
              -o ${eas_dir} \
              --prefix ${Spname} \
              --cpu ${nt_hybpiper} > /dev/null 2>&1
          fi
          # 02: for nucleotide reference sequence
          if [ "${hybpiper_tt}" = "dna" ]; then
              stage_cmd "${log_mode}" "hybpiper assemble -t_${hybpiper_tt} ${t} -r ${NGS_dir}/03-My_clean_data/${Spname}_clean.single.fq.gz -o ${eas_dir} --prefix ${Spname} --bwa --cpu ${nt_hybpiper}"
              hybpiper assemble -t_${hybpiper_tt} ${t} \
              -r ${NGS_dir}/03-My_clean_data/${Spname}_clean.single.fq.gz \
              -o ${eas_dir} \
              --prefix ${Spname} \
              --bwa \
              --cpu ${nt_hybpiper} > /dev/null 2>&1
          fi
        fi
        if [ -s "${eas_dir}/${Spname}/genes_with_seqs.txt" ]; then
            update_finish_count "$Spname" "$stage_logfile"
        else
            record_failed_sample "$Spname"
        fi
        if [ "${process}" != "all" ]; then
            echo >&1000
        fi
      } &
    done < "${output_dir}/00-logs_and_checklists/checklists/My_Spname.txt"
    # Wait for all tasks to complete
    wait
    echo
    # Display processing log
    if [ "${log_mode}" = "full" ]; then
      display_process_log "$stage_logfile" "stage2" "Failed to assemble data:"
    fi
    stage_blank_main ""
  fi

  grep '>' ${t} | awk -F'-' '{print $NF}' | sort | uniq > "${output_dir}/00-logs_and_checklists/checklists/Ref_gene_name_list.txt"
  # Recovered_locus_num_for_samples.tsv
  echo -e "Sample\tRecovered_locus_num" > "${eas_dir}/Recovered_locus_num_for_samples.tsv"
  while IFS= read -r Spname || [ -n "$Spname" ]; do
    if [ -s "${eas_dir}/${Spname}/genes_with_seqs.txt" ]; then
        echo -e "$Spname\t$(wc -l < "${eas_dir}/${Spname}/genes_with_seqs.txt")" >> "${eas_dir}/Recovered_locus_num_for_samples.tsv"
    else
        echo -e "$Spname\t0" >> "${eas_dir}/Recovered_locus_num_for_samples.tsv"
    fi
  done < "${eas_dir}/Assembled_data_namelist.txt"
  
  # Recovered_sample_num_for_loci.tsv
  echo -e "Locus\tRecovered_sample_num" > "${eas_dir}/Recovered_sample_num_for_loci.tsv"
  while IFS= read -r locus || [ -n "$locus" ]; do
    count=0
    while IFS= read -r Spname || [ -n "$Spname" ]; do
        if [ -s "${eas_dir}/${Spname}/genes_with_seqs.txt" ]; then
            if grep -qE "^$locus\b" "${eas_dir}/${Spname}/genes_with_seqs.txt"; then
                count=$((count + 1))
            fi
        fi
    done < "${eas_dir}/Assembled_data_namelist.txt"
    echo -e "$locus\t$count" >> "${eas_dir}/Recovered_sample_num_for_loci.tsv"
  done < "${output_dir}/00-logs_and_checklists/checklists/Ref_gene_name_list.txt"

  ############################################################################################
  #Stage2-Step2: retrieving all original paralogs via HybPiper ###################################
  ############################################################################################

  #################===========================================================================
  if [ "$LS" = "TRUE" ] || [ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "${one_to_one}" = "TRUE" ] || [ "${RLWP}" = "TRUE" ] || [ "${HRS}" = "TRUE" ]; then
    stage_info_main "Step 2: retrieving all original paralogs via HybPiper..."
    if [ -d "${output_dir}/02-All_paralogs/" ]; then
      rm -rf "${output_dir}/02-All_paralogs/"
    fi
    mkdir -p "${output_dir}/02-All_paralogs/01-Original_paralogs" "${output_dir}/02-All_paralogs/02-Original_paralog_reports_and_heatmap"
    cd "${output_dir}/02-All_paralogs/02-Original_paralog_reports_and_heatmap"
  #################===========================================================================
    stage_cmd "${log_mode}" "hybpiper paralog_retriever ${eas_dir}/Assembled_data_namelist.txt "-t_${hybpiper_tt}" ${t} --fasta_dir_all ${output_dir}/02-All_paralogs/01-Original_paralogs --hybpiper_dir ${eas_dir} --no_heatmap"
    hybpiper paralog_retriever ${eas_dir}/Assembled_data_namelist.txt "-t_${hybpiper_tt}" ${t} \
      --fasta_dir_all "${output_dir}/02-All_paralogs/01-Original_paralogs" \
      --hybpiper_dir "${eas_dir}" \
      --no_heatmap > /dev/null 2>&1
    if [ ! -s "./paralog_report.tsv" ] && [ ! -s "./paralogs_above_threshold_report.txt" ]; then
      stage_error "Fail to recover original paralogs via HybPiper."
      stage_error "HybSuite exits."
      stage_blank "${log_mode}" ""
      exit 1
    else
      stage_info_main "Successfully finishing retrieving original paralogs by running 'hybpiper paralog_retriever'. "
      stage_blank "${log_mode}" ""
    fi
    rm ./paralog_report.tsv ./paralogs_above_threshold_report.txt
    find "${output_dir}/02-All_paralogs/01-Original_paralogs/" -type f -empty -delete
    stage_blank_main ""

  ############################################################################################
  #Stage2-Optional step: Adding additional sequences to the dataset ##########################
  ############################################################################################
    if [ "${found_pre}" = "1" ]; then
      stage_info_main "Optional step: Adding other sequences with single copy orthologs ..."
      stage_info_main "====>> Adding other sequences with single copy orthologs (${process} in parallel) ====>>"
      
      # 01-Initialize parallel environment
      total_sps=$(grep -c '^' "${output_dir}/00-logs_and_checklists/checklists/Pre-assembled_Spname.txt")
      init_parallel_env "$work_dir" "$total_sps" "$process" "${output_dir}/00-logs_and_checklists/checklists/Pre-assembled_Spname.txt" || exit 1

      # 02-Run the main loop
      while IFS= read -r add_sp || [ -n "$add_sp" ]; do
        total_genes=$(awk 'END {print NR}' "${output_dir}/00-logs_and_checklists/checklists/Ref_gene_name_list.txt")
        if [ "${process}" != "all" ]; then
              read -u1000
        fi
        {
        # Update start count
        update_start_count "$add_sp" "$stage_logfile"
        while IFS= read -r add_gene || [ -n "$add_gene" ]; do
          if grep -qE ">$add_gene |\[gene=$add_gene\]" "${input_data}/${add_sp}.fasta"; then
            file="${input_data}/${add_sp}.fasta"
            if grep -q "\[gene=${add_gene}\]" "${file}"; then
              sed -e "s|^.*[gene=${add_gene}].*$|>${add_gene} single_hit|g" "${file}" > "${output_dir}/02-All_paralogs/01-Original_paralogs/${add_sp}_${add_gene}_single_hit.fa"
            elif grep -q ">${add_gene}" "${file}"; then
              sed -e "s|>${add_gene}.*$|>${add_gene} single_hit|g" "${file}" > "${output_dir}/02-All_paralogs/01-Original_paralogs/${add_sp}_${add_gene}_single_hit.fa"
            fi
            awk -v gene=">${add_gene} single_hit" '/^>/ {if (print_flag) print ""; print_flag=0} $0 ~ gene {print_flag=1} print_flag {print} END {if (print_flag) print ""}' \
            "${output_dir}/02-All_paralogs/01-Original_paralogs/${add_sp}_${add_gene}_single_hit.fa" >> "${output_dir}/02-All_paralogs/01-Original_paralogs/${add_gene}_paralogs_all.fasta" 
            sed -i "s|${add_gene}|${add_sp}|g;/^$/d" "${output_dir}/02-All_paralogs/01-Original_paralogs/${add_gene}_paralogs_all.fasta"
          fi
        done < "${output_dir}/00-logs_and_checklists/checklists/Ref_gene_name_list.txt"
        find . -type f -name "*.fa" -exec rm -f {} +
        # Update failed sample list
        if ! grep -q "${add_sp}" "${output_dir}"/02-All_paralogs/01-Original_paralogs/*_paralogs_all.fasta; then
            record_failed_sample "$add_sp"
        else
            # Update finish count
            update_finish_count "$add_sp" "$stage_logfile"
        fi
        if [ "${process}" != "all" ]; then
              echo >&1000
        fi
        } &
      done < "${output_dir}/00-logs_and_checklists/checklists/Pre-assembled_Spname.txt"
      wait
      echo
      # 03-Display processing log
      if [ "${log_mode}" = "full" ]; then
        display_process_log "$stage_logfile" "stage2" "Failed to add other sequences:"
      fi
      stage_blank_main ""

      # 04-Formatting the output paralogs
      cd "${output_dir}"/02-All_paralogs/01-Original_paralogs
      for file in *.fasta; do
        python "${script_dir}/Fasta_formatter.py" -i "${file}" -o "${file}" -nt "${nt}" --inter > /dev/null 2>&1
      done
    fi

  ############################################################################################
  #Stage2-Step3: Filtering paralogs by length, locus and sample coverage ######################
  ############################################################################################
  #################===========================================================================
    stage_info_main "Step 3: Filtering paralogs by length, locus and sample coverage..."
    mkdir -p "${output_dir}/02-All_paralogs/03-Filtered_paralogs" "${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap"
    cd "${eas_dir}"
  #################===========================================================================
    # 01-Filtering out paralogs with low length
    stage_info_main "01-Filtering out paralogs with low length via 'filter_seqs_by_length.py'..."
    stage_cmd "${log_mode}" "python ${script_dir}/filter_seqs_by_length.py -i ${output_dir}/02-All_paralogs/01-Original_paralogs -or ${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_out_paralogs_with_low_length_info.tsv --output_dir ${output_dir}/02-All_paralogs/03-Filtered_paralogs --ref ${t} --min_length ${min_length} --mean_length_ratio ${mean_length_ratio} --max_length_ratio ${max_length_ratio} --threads ${nt}"
    stage2_01="python ${script_dir}/filter_seqs_by_length.py \
    -i ${output_dir}/02-All_paralogs/01-Original_paralogs \
    -or ${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_out_paralogs_with_low_length_info.tsv \
    --output_dir ${output_dir}/02-All_paralogs/03-Filtered_paralogs \
    --ref ${t} \
    --min_length ${min_length} \
    --mean_length_ratio ${mean_length_ratio} \
    --max_length_ratio ${max_length_ratio} \
    --threads ${nt}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage2_01}"
    else
      eval "${stage2_01} > /dev/null 2>&1"
    fi

    # 02-Filtering out taxa with low locus coverage and loci with low sample coverage
    stage_info_main "02-Filtering out taxa with low locus coverage and loci with low sample coverage via 'filter_seqs_by_sample_and_locus_coverage.py'..."
    stage_cmd "${log_mode}" "python ${script_dir}/filter_seqs_by_sample_and_locus_coverage.py -i ${output_dir}/02-All_paralogs/03-Filtered_paralogs --min_locus_coverage ${min_locus_coverage} --min_sample_coverage ${min_sample_coverage} --removed_samples_info ${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_out_samples_with_low_locus_coverage_info.tsv --removed_loci_info ${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_out_loci_with_low_sample_coverage_info.tsv --threads ${nt}"
    stage2_02="python ${script_dir}/filter_seqs_by_sample_and_locus_coverage.py \
    -i ${output_dir}/02-All_paralogs/03-Filtered_paralogs \
    --min_locus_coverage ${min_locus_coverage} \
    --min_sample_coverage ${min_sample_coverage} \
    --removed_samples_info ${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_out_samples_with_low_locus_coverage_info.tsv \
    --removed_loci_info ${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_out_loci_with_low_sample_coverage_info.tsv \
    --threads ${nt}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage2_02}"
    else
      eval "${stage2_02} > /dev/null 2>&1"
    fi

    stage_info "${log_mode}" "Finish"
    stage_info "${log_mode}" "The information of filtered out paralog sequences with low length has been written to:"
    stage_info "${log_mode}" "${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_out_paralogs_with_low_length_info.tsv"
    stage_info "${log_mode}" "The information of filtered out taxa with low locus coverage has been written to:"
    stage_info "${log_mode}" "${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_out_samples_with_low_locus_coverage_info.tsv"
    stage_info "${log_mode}" "The information of filtered out loci with low sample coverage has been written to:"
    stage_info "${log_mode}" "${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_out_loci_with_low_sample_coverage_info.tsv"
    stage_blank_main ""
    ############################################################################################
    #Stage2-Step4: Producing the paralog report and plotting the paralog heatmap ###############
    ############################################################################################
    stage_info_main "Step 4: Producing the paralog report and plotting the paralog heatmap..."
    # 01-Producing the paralogs report and plotting the paralogs heatmap for the unfiltered (original) paralogs
    stage_info_main "01-Producing the paralogs report and plotting the paralogs heatmap for the unfiltered (original) paralogs..."
    stage_cmd "${log_mode}" "python ${script_dir}/plot_paralog_heatmap.py -i ${output_dir}/02-All_paralogs/01-Original_paralogs -oph ${output_dir}/02-All_paralogs/02-Original_paralog_reports_and_heatmap/Original_paralog_heatmap.png -opr ${output_dir}/02-All_paralogs/02-Original_paralog_reports_and_heatmap/Original_paralog_report.tsv -t ${nt} --show_values --color ${heatmap_color}"
    stage2_03="python ${script_dir}/plot_paralog_heatmap.py \
    -i ${output_dir}/02-All_paralogs/01-Original_paralogs \
    -oph ${output_dir}/02-All_paralogs/02-Original_paralog_reports_and_heatmap/Original_paralog_heatmap.png \
    -opr ${output_dir}/02-All_paralogs/02-Original_paralog_reports_and_heatmap/Original_paralog_report.tsv \
    -t ${nt} \
    --show_values \
    --color ${heatmap_color}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage2_03}"
    else
      eval "${stage2_03} > /dev/null 2>&1"
    fi

    # 02-Producing the paralogs report and plotting the paralogs heatmap for the filtered paralogs
    stage_info_main "02-Producing the paralogs report and plotting the paralogs heatmap for the filtered paralogs..."
    stage_cmd "${log_mode}" "python ${script_dir}/plot_paralog_heatmap.py -i ${output_dir}/02-All_paralogs/03-Filtered_paralogs -oph ${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_paralog_heatmap.png -opr ${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_paralog_report.tsv -t ${nt} --show_values --color ${heatmap_color}"
    stage2_04="python ${script_dir}/plot_paralog_heatmap.py \
    -i ${output_dir}/02-All_paralogs/03-Filtered_paralogs \
    -oph ${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_paralog_heatmap.png \
    -opr ${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_paralog_report.tsv \
    -t ${nt} \
    --show_values \
    --color ${heatmap_color}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage2_04}"
    else
      eval "${stage2_04} > /dev/null 2>&1"
    fi
  fi

  ############################################################################################
  # End of Stage 2
  stage_info_main "Successfully finishing the stage2: 'Data assembly and filtered paralogs retrieving'."
  stage_info "${log_mode}" "The resulting files have been saved in ${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap"

  if [ "${run_to_stage2}" = "true" ]; then
    # Clean up environment
    cleanup_parallel_env "$work_dir"
    stage_info "${log_mode}" "You set '--run_to_stage2' to specify HybSuite to run only stage 2."
    stage_info "${log_mode}" "Consequently, HybSuite will stop and exit right now."
    stage_info_main "Thank you for using HybSuite! Enjoy your research!"
    stage_blank_main ""
    exit 1
  else
    stage_info "${log_mode}" "Moving on to the next stage..."
    stage_blank_main ""
  fi
  ############################################################################################
fi

############################################################################################
# Stage 3: Orthology inference #############################################################
############################################################################################
if [ "${skip_stage1234}" = "TRUE" ] || [ "${skip_stage123}" = "TRUE" ]; then
  stage_info_main "Stage 3 Orthology inference is skipped."
else
  #################===========================================================================
  # 0.Preparation
  stage_info_main "<<<======= Stage 3 Orthology inference =======>>>"
  #################===========================================================================

  ############################################################################################
  #Stage3-Optional method: HRS ###############################################################
  ############################################################################################
  if [ "${HRS}" = "TRUE" ]; then
    stage_info_main "Running optional method: HRS ..."
    if [ -d "${output_dir}/03-Orthology_inference/HRS/" ]; then
      rm -rf "${output_dir}/03-Orthology_inference/HRS/"
    fi
    mkdir -p "${output_dir}/03-Orthology_inference/HRS/"
    #################===========================================================================

    # 01-Retrieving sequences
    #################===========================================================================
    stage_info_main "Step 1: Retrieving sequences by running 'hybpiper retrieve_sequences' ..."
    mkdir -p "${output_dir}/03-Orthology_inference/HRS/01-Original_HRS_sequences/"
    #################===========================================================================
    stage_cmd "${log_mode}" "hybpiper retrieve_sequences "-t_${hybpiper_tt}" ${t} dna --sample_names ${eas_dir}/Assembled_data_namelist.txt --fasta_dir ${output_dir}/03-Orthology_inference/HRS/01-Original_HRS_sequences/"
    hybpiper retrieve_sequences "-t_${hybpiper_tt}" ${t} dna \
    --hybpiper_dir "${eas_dir}" \
    --sample_names ${eas_dir}/Assembled_data_namelist.txt \
    --fasta_dir ${output_dir}/03-Orthology_inference/HRS/01-Original_HRS_sequences/ > /dev/null 2>&1
    if find "${output_dir}/03-Orthology_inference/HRS/01-Original_HRS_sequences/" -type f -name "*.FNA" -size +0c -quit 2>/dev/null; then
      stage_info_main "Finish"
      stage_blank "${log_mode}" ""
    else
      stage_error "Fail to retrieve sequences by running 'hybpiper retrieve_sequences'."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi

    # Optional step-Adding other sequences
    #################===========================================================================
    if [ "${found_pre}" = "1" ]; then
      stage_info_main "Optional step: Adding other sequences ..." 
      stage_info_main "====>> Adding other sequences (HRS) (${process} in parallel) ====>>"
    #################=========================================================================== 
      # 01-Initialize parallel environment
      total_sps=$(grep -c '^' "${output_dir}/00-logs_and_checklists/checklists/Pre-assembled_Spname.txt")
      init_parallel_env "$work_dir" "$total_sps" "$process" "${output_dir}/00-logs_and_checklists/checklists/Pre-assembled_Spname.txt" || exit 1
      
      # 02-Run the main loop
      while IFS= read -r add_sp || [ -n "$add_sp" ]; do
        total_genes=$(awk 'END {print NR}' "${output_dir}/00-logs_and_checklists/checklists/Ref_gene_name_list.txt")
        if [ "${process}" != "all" ]; then
          read -u1000
        fi
        {
          # Update start count
          update_start_count "$add_sp" "$stage_logfile"
          while IFS= read -r add_gene || [ -n "$add_gene" ]; do
            if grep -qE ">$add_gene |\[gene=$add_gene\]" "${input_data}/${add_sp}.fasta"; then
              file="${input_data}/${add_sp}.fasta"
              if grep -q "\[gene=${add_gene}\]" "${file}"; then
                sed -e "s|^.*[gene=${add_gene}].*$|>${add_gene} single_hit|g" "${file}" > "${output_dir}/03-Orthology_inference/HRS/01-Original_HRS_sequences/${add_sp}_${add_gene}_single_hit.fa"
              elif grep -q ">${add_gene}" "${file}"; then
                sed -e "s|>${add_gene}.*$|>${add_gene} single_hit|g" "${file}" > "${output_dir}/03-Orthology_inference/HRS/01-Original_HRS_sequences/${add_sp}_${add_gene}_single_hit.fa" 
              fi
              awk -v gene=">${add_gene} single_hit" '/^>/ {if (print_flag) print ""; print_flag=0} $0 ~ gene {print_flag=1} print_flag {print} END {if (print_flag) print ""}' \
              "${output_dir}/03-Orthology_inference/HRS/01-Original_HRS_sequences/${add_sp}_${add_gene}_single_hit.fa" >> "${output_dir}/03-Orthology_inference/HRS/01-Original_HRS_sequences/${add_gene}.FNA"
              sed -i "s|${add_gene} |${add_sp} |g;/^$/d" "${output_dir}/03-Orthology_inference/HRS/01-Original_HRS_sequences/${add_gene}.FNA"
            fi
          done < "${output_dir}/00-logs_and_checklists/checklists/Ref_gene_name_list.txt"
          find . -type f -name "*.fa" -exec rm -f {} +
          # Update failed sample list
          if ! grep -q "${add_sp}" "${output_dir}"/03-Orthology_inference/HRS/01-Original_HRS_sequences/*.FNA; then
            record_failed_sample "$add_sp"
          else
            # Update finish count
            update_finish_count "$add_sp" "$stage_logfile"
          fi
          if [ "${process}" != "all" ]; then
            echo >&1000
          fi
        } &
      done < "${output_dir}/00-logs_and_checklists/checklists/Pre-assembled_Spname.txt"
      wait
      echo
      # Display processing log
      if [ "${log_mode}" = "full" ]; then
        display_process_log "$stage_logfile" "stage3" "Failed to add other sequences:"
      fi
      stage_blank_main ""

      # 03-Formatting the output paralogs
      cd "${output_dir}"/03-Orthology_inference/HRS/01-Original_HRS_sequences/
      for file in *.FNA; do
        python "${script_dir}/Fasta_formatter.py" -i "${file}" -o "${file}" -nt "${nt}" --inter > /dev/null 2>&1
      done
    fi

    # 05-Filtering all HRS sequences by length, locus and sample coverage
    #################===========================================================================
    stage_info_main "Step 2: Filtering all HRS sequences by length, locus and sample coverage ..." 
    mkdir -p "${output_dir}/03-Orthology_inference/HRS/03-Filtered_HRS_sequences/" "${output_dir}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/"
    #################===========================================================================

    # 01-Filtering out paralogs with low length
    stage_info_main "01-Filtering out paralogs with low length..."
    stage_cmd "${log_mode}" "python ${script_dir}/filter_seqs_by_length.py -i ${output_dir}/03-Orthology_inference/HRS/01-Original_HRS_sequences/ -or ${output_dir}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_HRS_seqs_with_low_length_info.tsv --output_dir ${output_dir}/03-Orthology_inference/HRS/03-Filtered_HRS_sequences/ --ref ${t} --min_length ${min_length} --mean_length_ratio ${mean_length_ratio} --max_length_ratio ${max_length_ratio} --threads ${nt}"
    stage3_HRS_01="python ${script_dir}/filter_seqs_by_length.py \
    -i ${output_dir}/03-Orthology_inference/HRS/01-Original_HRS_sequences/ \
    -or ${output_dir}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_HRS_seqs_with_low_length_info.tsv \
    --output_dir ${output_dir}/03-Orthology_inference/HRS/03-Filtered_HRS_sequences/ \
    --ref ${t} \
    --min_length ${min_length} \
    --mean_length_ratio ${mean_length_ratio} \
    --max_length_ratio ${max_length_ratio} \
    --threads ${nt}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage3_HRS_01}"
    else
      eval "${stage3_HRS_01} > /dev/null 2>&1"
    fi

    if [ -s "${output_dir}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_HRS_seqs_with_low_length_info.tsv" ]; then
      stage_info "${log_mode}" "The information of filtered out HRS sequences with low length has been written to:"
      stage_info "${log_mode}" "${output_dir}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_HRS_seqs_with_low_length_info.tsv"
    else
      stage_error "Fail to filter out HRS sequences with low length."
    fi

    # 02-Filtering out taxa with low locus coverage and loci with low sample coverage
    stage_info_main "02-Filtering out taxa with low locus coverage and loci with low sample coverage..."
    stage_cmd "${log_mode}" "python ${script_dir}/filter_seqs_by_sample_and_locus_coverage.py -i ${output_dir}/03-Orthology_inference/HRS/03-Filtered_HRS_sequences/ --min_locus_coverage ${min_locus_coverage} --min_sample_coverage ${min_sample_coverage} --removed_samples_info ${output_dir}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_samples_with_low_locus_coverage_info.tsv --removed_loci_info ${output_dir}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_loci_with_low_sample_coverage_info.tsv --threads ${nt}"
    stage3_HRS_02="python ${script_dir}/filter_seqs_by_sample_and_locus_coverage.py \
    -i ${output_dir}/03-Orthology_inference/HRS/03-Filtered_HRS_sequences/ \
    --min_locus_coverage ${min_locus_coverage} \
    --min_sample_coverage ${min_sample_coverage} \
    --removed_samples_info ${output_dir}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_samples_with_low_locus_coverage_info.tsv \
    --removed_loci_info ${output_dir}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_loci_with_low_sample_coverage_info.tsv \
    --threads ${nt}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage3_HRS_02}"
    else
      eval "${stage3_HRS_02} > /dev/null 2>&1"
    fi

    if [ -s "${output_dir}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_samples_with_low_locus_coverage_info.tsv" ]; then
      stage_info "${log_mode}" "The information of filtered out taxa with low locus coverage has been written to:"
      stage_info "${log_mode}" "${output_dir}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_samples_with_low_locus_coverage_info.tsv"
    else
      stage_info "No taxon was filtered out."
    fi
    if [ -s "${output_dir}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_loci_with_low_sample_coverage_info.tsv" ]; then
      stage_info "${log_mode}" "The information of filtered out loci with low sample coverage has been written to:"
      stage_info "${log_mode}" "${output_dir}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_loci_with_low_sample_coverage_info.tsv"
    else
      stage_info "No locus was filtered out."
    fi
    stage_info_main "Finish"
    stage_blank "${log_mode}" ""

    # 01-Retrieving sequences
    #################===========================================================================
    stage_info_main "Step 3: Getting the reports and heatmap ..."
    mkdir -p "${output_dir}/03-Orthology_inference/HRS/02-Original_HRS_sequences_reports_and_heatmap/"
    #################===========================================================================
    # 01-Getting the reports and heatmap of the original HRS sequences
    stage_info_main "01-Getting the reports and heatmap of the original HRS sequences..."
    stage_cmd "${log_mode}" "python "${script_dir}/plot_recovery_heatmap.py" -i "${output_dir}/03-Orthology_inference/HRS/01-Original_HRS_sequences/" -r "${t}" -osl "${output_dir}/03-Orthology_inference/HRS/02-Original_HRS_sequences_reports_and_heatmap/Original_HRS_seq_lengths.tsv" -oh "${output_dir}/03-Orthology_inference/HRS/02-Original_HRS_sequences_reports_and_heatmap/Original_HRS_heatmap" --threads "${nt}" --color "${heatmap_color}""
    stage3_HRS_03="python ${script_dir}/plot_recovery_heatmap.py \
    -i ${output_dir}/03-Orthology_inference/HRS/01-Original_HRS_sequences/ \
    -r ${t} \
    -osl ${output_dir}/03-Orthology_inference/HRS/02-Original_HRS_sequences_reports_and_heatmap/Original_HRS_seq_lengths.tsv \
    -oh ${output_dir}/03-Orthology_inference/HRS/02-Original_HRS_sequences_reports_and_heatmap/Original_HRS_heatmap \
    --threads ${nt} \
    --color ${heatmap_color}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage3_HRS_03}"
    else
      eval "${stage3_HRS_03} > /dev/null 2>&1"
    fi

    if [ -s "${output_dir}/03-Orthology_inference/HRS/02-Original_HRS_sequences_reports_and_heatmap/Original_HRS_heatmap.png" ]; then
      stage_info "${log_mode}" "The reports and heatmap of the original HRS sequences have been written to:"
      stage_info "${log_mode}" "${output_dir}/03-Orthology_inference/HRS/02-Original_HRS_sequences_reports_and_heatmap/"
    else
      stage_error "Fail to get the reports and heatmap of the original HRS sequences."
    fi

    # 02-Getting the reports and heatmap of the filtered HRS sequences
    stage_info_main "02-Getting the reports and heatmap of the filtered HRS sequences..."
    stage_cmd "${log_mode}" "python ${script_dir}/plot_recovery_heatmap.py -i ${output_dir}/03-Orthology_inference/HRS/03-Filtered_HRS_sequences/ -r ${t} -osl ${output_dir}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_HRS_seq_lengths.tsv -oh ${output_dir}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_HRS_heatmap --threads ${nt} --show_values --color ${heatmap_color}"
    stage3_HRS_04="python ${script_dir}/plot_recovery_heatmap.py \
    -i ${output_dir}/03-Orthology_inference/HRS/03-Filtered_HRS_sequences/ \
    -r ${t} \
    -osl ${output_dir}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_HRS_seq_lengths.tsv \
    -oh ${output_dir}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_HRS_heatmap \
    --threads ${nt} \
    --color ${heatmap_color}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage3_HRS_04}"
    else
      eval "${stage3_HRS_04} > /dev/null 2>&1"
    fi
    
    if [ -s "${output_dir}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_HRS_heatmap.png" ]; then
      stage_info "${log_mode}" "The reports and heatmap of the filtered HRS sequences have been written to:"
      stage_info "${log_mode}" "${output_dir}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/"
    else
      stage_error "Fail to get the reports and heatmap of the filtered HRS sequences."
    fi

    stage_info_main "Congratulations! Finish producing HRS sequences in ${output_dir}/03-Orthology_inference/HRS/03-Filtered_HRS_sequences/"
    stage_blank_main ""
  fi

  ############################################################################################
  #Stage3-Optional method: RLWP ##############################################################
  ############################################################################################
  if [ "${RLWP}" = "TRUE" ]; then
    #################===========================================================================
    stage_info_main "Running optional method: RLWP ..."
    if [ -d "${output_dir}/03-Orthology_inference/RLWP/" ]; then
      rm -rf "${output_dir}/03-Orthology_inference/RLWP/"
    fi
    mkdir -p "${output_dir}/03-Orthology_inference/RLWP/"
    #################===========================================================================

    # 01-Retrieving sequences
    #################===========================================================================
    stage_info_main "Step 1: Retrieving sequences by running 'hybpiper retrieve_sequences' ..."
    mkdir -p "${output_dir}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/"
    #################===========================================================================
    stage_cmd "${log_mode}" "hybpiper retrieve_sequences "-t_${hybpiper_tt}" ${t} dna --sample_names ${eas_dir}/Assembled_data_namelist.txt --fasta_dir ${output_dir}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/"
    hybpiper retrieve_sequences "-t_${hybpiper_tt}" ${t} dna \
    --hybpiper_dir "${eas_dir}" \
    --sample_names ${eas_dir}/Assembled_data_namelist.txt \
    --fasta_dir ${output_dir}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/ > /dev/null 2>&1
    if find "${output_dir}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/" -type f -name "*.FNA" -size +0c -quit 2>/dev/null; then
      stage_info "${log_mode}" "Successfully retrieving sequences by running 'hybpiper retrieve_sequences'. "
      stage_blank "${log_mode}" ""
    else
      stage_error "Fail to retrieve sequences by running 'hybpiper retrieve_sequences'."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi

    # Optional step-Adding other sequences
    #################===========================================================================
    if [ "${found_pre}" = "1" ]; then
      stage_blank_main ""
      stage_info_main "Optional step: Adding other sequences ..." 
      stage_info_main "====>> Adding other sequences (RLWP) (${process} in parallel) ====>>"
    #################=========================================================================== 
      # 01-Initialize parallel environment
      total_sps=$(grep -c '^' "${output_dir}/00-logs_and_checklists/checklists/Pre-assembled_Spname.txt")
      init_parallel_env "$work_dir" "$total_sps" "$process" "${output_dir}/00-logs_and_checklists/checklists/Pre-assembled_Spname.txt" || exit 1
      
      # 02-Run the main loop
      while IFS= read -r add_sp || [ -n "$add_sp" ]; do
        total_genes=$(awk 'END {print NR}' "${output_dir}/00-logs_and_checklists/checklists/Ref_gene_name_list.txt")
        if [ "${process}" != "all" ]; then
          read -u1000
        fi
        {
          # Update start count
          update_start_count "$add_sp" "$stage_logfile"
          while IFS= read -r add_gene || [ -n "$add_gene" ]; do
            if grep -qE ">$add_gene |\[gene=$add_gene\]" "${input_data}/${add_sp}.fasta"; then
              file="${input_data}/${add_sp}.fasta"
              if grep -q "\[gene=${add_gene}\]" "${file}"; then
                sed -e "s|^.*[gene=${add_gene}].*$|>${add_gene} single_hit|g" "${file}" > "${output_dir}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/${add_sp}_${add_gene}_single_hit.fa"
              elif grep -q ">${add_gene}" "${file}"; then
                sed -e "s|>${add_gene}.*$|>${add_gene} single_hit|g" "${file}" > "${output_dir}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/${add_sp}_${add_gene}_single_hit.fa"
              fi
              awk -v gene=">${add_gene} single_hit" '/^>/ {if (print_flag) print ""; print_flag=0} $0 ~ gene {print_flag=1} print_flag {print} END {if (print_flag) print ""}' \
              "${output_dir}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/${add_sp}_${add_gene}_single_hit.fa" >> "${output_dir}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/${add_gene}.FNA"
              sed -i "s|${add_gene} |${add_sp} |g;/^$/d" "${output_dir}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/${add_gene}.FNA" > /dev/null 2>&1
            fi
          done < "${output_dir}/00-logs_and_checklists/checklists/Ref_gene_name_list.txt"
          find . -type f -name "*.fa" -exec rm -f {} +
          # Update failed sample list
          if ! grep -q "${add_sp}" "${output_dir}"/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/*.FNA; then
            record_failed_sample "$add_sp"
          else
            # Update finish count
            update_finish_count "$add_sp" "$stage_logfile"
          fi
          if [ "${process}" != "all" ]; then
            echo >&1000
          fi
        } &
      done < "${output_dir}/00-logs_and_checklists/checklists/Pre-assembled_Spname.txt"
      wait
      echo
      # Display processing log
      if [ "${log_mode}" = "full" ]; then
        display_process_log "$stage_logfile" "stage3" "Failed to add other sequences:"
      fi
      stage_blank "${log_mode}" ""

      # 05-Formatting the output sequences
      cd "${output_dir}"/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/
      for file in *.FNA; do
        python "${script_dir}/Fasta_formatter.py" -i "${file}" -o "${file}" -nt "${nt}" --inter > /dev/null 2>&1
      done
    fi

    # 02-Removing loci with paralogues (RLWP)
    stage_info_main "Step 2: Removing loci with paralogues (RLWP) via RLWP.py ..."
    mkdir -p "${output_dir}/03-Orthology_inference/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/"
    stage_cmd "${log_mode}" "python ${script_dir}/RLWP.py -i ${output_dir}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/ -p ${output_dir}/02-All_paralogs/02-Original_paralog_reports_and_heatmap/Original_paralog_report.tsv -s ${RLWP_samples_threshold} -or ${output_dir}/03-Orthology_inference/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/RLWP_removed_loci_info.tsv --threads ${nt}"
    stage3_RLWP_1="python ${script_dir}/RLWP.py \
    -i ${output_dir}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/ \
    -p ${output_dir}/02-All_paralogs/02-Original_paralog_reports_and_heatmap/Original_paralog_report.tsv \
    -s ${RLWP_samples_threshold} \
    -or ${output_dir}/03-Orthology_inference/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/RLWP_removed_loci_info.tsv \
    --threads ${nt}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage3_RLWP_1}"
    else
      eval "${stage3_RLWP_1} > /dev/null 2>&1"
    fi
    stage_blank "${log_mode}" ""

    # 03-Filtering out RLWP sequences with low length, sample and locus coverage
    stage_info_main "Step 3: Filtering out RLWP sequences with low length, sample and locus coverage..."
    mkdir -p "${output_dir}/03-Orthology_inference/RLWP/03-Filtered_RLWP_sequences/" "${output_dir}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/"

    stage_info_main "01-Filtering out RLWP sequences with low length ..."
    stage_cmd "${log_mode}" "python "${script_dir}/filter_seqs_by_length.py" -i "${output_dir}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/" --output_report "${output_dir}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_out_RLWP_seqs_with_low_length_info.tsv" --output_dir "${output_dir}/03-Orthology_inference/RLWP/03-Filtered_RLWP_sequences/" --ref "${t}" --min_length "${min_length}" --mean_length_ratio "${mean_length_ratio}" --max_length_ratio "${max_length_ratio}" --threads "${nt}""
    stage3_RLWP_2="python ${script_dir}/filter_seqs_by_length.py \
    -i ${output_dir}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/ \
    --output_report ${output_dir}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_out_RLWP_seqs_with_low_length_info.tsv \
    --output_dir ${output_dir}/03-Orthology_inference/RLWP/03-Filtered_RLWP_sequences/ \
    --ref ${t} \
    --min_length ${min_length} \
    --mean_length_ratio ${mean_length_ratio} \
    --max_length_ratio ${max_length_ratio} \
    --threads ${nt}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage3_RLWP_2}"
    else
      eval "${stage3_RLWP_2} > /dev/null 2>&1"
    fi
    stage_blank "${log_mode}" ""
    
    # 04-Filtering out taxa with low locus coverage and loci with low sample coverage
    stage_info_main "02-Filtering out taxa with low sample and loci with low sample coverage ..."
    stage_cmd "${log_mode}" "python "${script_dir}/filter_seqs_by_sample_and_locus_coverage.py" -i "${output_dir}/03-Orthology_inference/RLWP/03-Filtered_RLWP_sequences/" --min_locus_coverage "${min_locus_coverage}" --min_sample_coverage "${min_sample_coverage}" --removed_samples_info "${output_dir}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_out_samples_with_low_locus_coverage_info.tsv" --removed_loci_info "${output_dir}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_out_loci_with_low_sample_coverage_info.tsv" --threads "${nt}""
    stage3_RLWP_3="python ${script_dir}/filter_seqs_by_sample_and_locus_coverage.py \
    -i ${output_dir}/03-Orthology_inference/RLWP/03-Filtered_RLWP_sequences/ \
    --min_locus_coverage ${min_locus_coverage} \
    --min_sample_coverage ${min_sample_coverage} \
    --removed_samples_info ${output_dir}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_out_samples_with_low_locus_coverage_info.tsv \
    --removed_loci_info ${output_dir}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_out_loci_with_low_sample_coverage_info.tsv \
    --threads ${nt}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage3_RLWP_3}"
    else
      eval "${stage3_RLWP_3} > /dev/null 2>&1"
    fi
    stage_blank "${log_mode}" ""

    # 05-Plotting the recovery heatmap
    #################===========================================================================
    stage_info_main "Step 4: Plotting the recovery heatmap ..."

    # plot the recovery heatmap for original RLWP sequences
    stage_info_main "01-Plotting the recovery heatmap for original RLWP sequences ..."
    stage_cmd "${log_mode}" "python ${script_dir}/plot_recovery_heatmap.py -i ${output_dir}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/ -r ${t} --output_heatmap ${output_dir}/03-Orthology_inference/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/Original_RLWP_seqs_recovery_heatmap --output_seq_lengths ${output_dir}/03-Orthology_inference/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/Original_RLWP_seqs_lengths.tsv --threads ${nt} --color ${heatmap_color}"
    stage3_RLWP_4="python ${script_dir}/plot_recovery_heatmap.py \
    -i ${output_dir}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/ \
    -r ${t} \
    --output_heatmap ${output_dir}/03-Orthology_inference/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/Original_RLWP_seqs_recovery_heatmap \
    --output_seq_lengths ${output_dir}/03-Orthology_inference/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/Original_RLWP_seqs_lengths.tsv \
    --threads ${nt} \
    --color ${heatmap_color}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage3_RLWP_4}"
    else
      eval "${stage3_RLWP_4} > /dev/null 2>&1"
    fi
    if [ -s "${output_dir}/03-Orthology_inference/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/Original_RLWP_seqs_lengths.tsv" ] && [ -s "${output_dir}/03-Orthology_inference/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/Original_RLWP_seqs_recovery_heatmap.png" ]; then
      stage_info "${log_mode}" "The recovery heatmap of original RLWP sequences has been written to: ${output_dir}/03-Orthology_inference/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/Original_RLWP_seqs_recovery_heatmap.png"
    else
      stage_error "Fail to plot the recovery heatmap of original RLWP sequences."
    fi

    # plot the recovery heatmap for filtered RLWP sequences
    stage_info_main "02-Plotting the recovery heatmap for filtered RLWP sequences ..."
    stage_cmd "${log_mode}" "python ${script_dir}/plot_recovery_heatmap.py -i ${output_dir}/03-Orthology_inference/RLWP/03-Filtered_RLWP_sequences/ -r ${t} --output_heatmap ${output_dir}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_RLWP_seqs_recovery_heatmap --output_seq_lengths ${output_dir}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_RLWP_seqs_lengths.tsv --threads ${nt} --color ${heatmap_color}"
    
    stage3_RLWP_5="python ${script_dir}/plot_recovery_heatmap.py \
    -i ${output_dir}/03-Orthology_inference/RLWP/03-Filtered_RLWP_sequences/ \
    -r ${t} \
    --output_heatmap ${output_dir}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_RLWP_seqs_recovery_heatmap \
    --output_seq_lengths ${output_dir}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_RLWP_seqs_lengths.tsv \
    --threads ${nt} \
    --color ${heatmap_color}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage3_RLWP_5}"
    else
      eval "${stage3_RLWP_5} > /dev/null 2>&1"
    fi
    if [ -s "${output_dir}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_RLWP_seqs_lengths.tsv" ] && [ -s "${output_dir}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_RLWP_seqs_recovery_heatmap.png" ]; then
      stage_info "${log_mode}" "The recovery heatmap of filtered RLWP sequences has been written to: ${output_dir}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_RLWP_seqs_recovery_heatmap.png"
    else
      stage_error "Fail to plot the recovery heatmap of filtered RLWP sequences."
    fi

    stage_info_main "Congratulations! Finish producing RLWP sequences in ${output_dir}/03-Orthology_inference/RLWP/03-Filtered_RLWP_sequences/"
    stage_blank_main ""
  fi

  ############################################################################################
  #Stage3-Optional method: LS/MI/MO/RT/1to1 for PhyloPyPruner ################################
  ############################################################################################
  #1. phylopypruner (optional)
  if [ "$LS" = "TRUE" ] || { ([ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "${one_to_one}" = "TRUE" ]) && [ "${run_phylopypruner}" = "TRUE" ] && [ "${run_paragone}" != "TRUE" ]; }; then
    if [ -d "${output_dir}/03-Orthology_inference/PhyloPyPruner/" ]; then
      rm -r "${output_dir}/03-Orthology_inference/PhyloPyPruner/"
    fi
    mkdir -p "${output_dir}"/03-Orthology_inference/PhyloPyPruner/Input
    cd ${output_dir}/03-Orthology_inference/PhyloPyPruner/Input
    cp ${output_dir}/02-All_paralogs/03-Filtered_paralogs/*.fasta ${output_dir}/03-Orthology_inference/PhyloPyPruner/Input
    stage_info_main "Optional step: LS/MI/MO/RT/1to1 for PhyloPyPruner"
    stage_info_main "01-Preparing fasta files and single gene trees for PhyloPyPruner"
    # 1.MAFFT and TrimAl
    define_threads "mafft"
    define_threads "trimal"
    temp_file="fasta_file_list.txt"
    find . -maxdepth 1 -type f -name "*.fasta" -exec basename {} \; > "$temp_file"
    total_sps=$(find . -maxdepth 1 -type f -name "*.fasta" | wc -l)
    # Initialize parallel environment
    init_parallel_env "$work_dir" "$total_sps" "$process" "${temp_file}" || exit 1
    stage_info_main "====>> Running MAFFT, TrimAl and FastTree for ${total_sps} paralog files (${process} in parallel) ====>>"
    while IFS= read -r file || [ -n "$file" ]; do
      filename=${file%.fasta}
      genename=${file%_paralogs_all.fasta}
      if [ "${process}" != "all" ]; then
        read -u1000
      fi
      {
        # Update start count
        update_start_count "$genename" "$stage_logfile"
        sed -i "s/ single_hit/@single_hit/g;s/ multi/@multi/g;s/ NODE_/@NODE_/g;s/\.[0-9]\+@NODE_/@NODE_/g;s/\.main@NODE_/@NODE_/g" "${file}"
        # Run MAFFT  
        run_mafft "${file}" "${filename}.aln.fasta" "${nt_mafft}"
        run_trimal "./${filename}.aln.fasta" "./${filename}.trimmed.aln.fasta" "${trimal_mode}" \
        "${trimal_gapthreshold}" "${trimal_simthreshold}" "${trimal_cons}" "${trimal_block}" "${trimal_resoverlap}" "${trimal_seqoverlap}" \
        "${trimal_w}" "${trimal_gw}" "${trimal_sw}"
        awk '
        BEGIN { OFS="\n" }
        /^>/ {
            header=$0
            count[header]++
            if(count[header] > 1) {
                printf "%s_%d\n", header, count[header]
            } else {
                print header
            }
            next
        }
        { print $0 }' "./${filename}.trimmed.aln.fasta" > "./${filename}.trimmed.aln.temp" && \
        mv "./${filename}.trimmed.aln.temp" "./${filename}.trimmed.aln.fasta"
        remove_n "./${filename}.trimmed.aln.fasta"
        FastTree -nt -gamma "./${filename}.trimmed.aln.fasta" > "./${filename}.trimmed.aln.fasta.tre" 2>/dev/null
        rm "${file}" "${filename}.aln.fasta"
        # Update failed count
        if [ ! -s "./${filename}.trimmed.aln.fasta" ] || [ ! -s "./${filename}.trimmed.aln.fasta.tre" ]; then
          record_failed_sample "$genename"
        else
          # Update finish count
          update_finish_count "$genename" "$stage_logfile"
        fi
        if [ "${process}" != "all" ]; then
          echo >&1000
        fi
      } &
    done < "$temp_file"
    rm "$temp_file"
    wait
    echo
    # Display processing log
    if [ "${log_mode}" = "full" ]; then
      display_process_log "$stage_logfile" "stage3" "Failed to run MAFFT for paralog files:"
    fi
    stage_blank_main ""
    if ! find ./ -type f -name '*trimmed.aln.fasta' -size +0c -quit 2>/dev/null; then
      stage_error "Fail to run MAFFT and TrimAl."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
    if ! find ./ -type f -name '*trimmed.aln.fasta.tre' -size +0c -quit 2>/dev/null; then
      stage_error "Fail to run FastTree."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi

    define_threads "phylopypruner"
    
    # Define the function to run PhyloPyPruner
    run_phylopypruner() {
        local method=$1
        local output_phylopypruner_dir=$2
        local threads=$3
        local input_dir=$4
        local trim_lb=$5
        local min_taxa=$6
        local min_len=$7
        if [ "${method}" = "MO" ] || [ "${method}" = "RT" ]; then
          local outgroup=$8
        fi

        stage_info_main "Running PhyloPyPruner via ${method} algorithum ..."
        
        # Base command without outgroup
        local base_cmd="phylopypruner --overwrite --no-supermatrix --threads \"${threads}\" --dir \"${input_dir}/PhyloPyPruner/Input\" --output \"${input_dir}/PhyloPyPruner/\" --prune \"${method}\" --trim-lb \"${trim_lb}\" --min-taxa \"${min_taxa}\" --min-len \"${min_len}\""

        # If outgroup parameter is provided and not empty
        if [ -n "${outgroup}" ] && [ -f "${outgroup}" ]; then
            # Read outgroup file and prepare arguments
            outgroup_args=""
            while IFS= read -r line || [ -n "$line" ]; do
                outgroup_args="$outgroup_args $line"
            done < "${outgroup}"
            # Add outgroup to command
            base_cmd="${base_cmd} --outgroup ${outgroup_args}"
            # Log the full command with outgroup
            stage_cmd "${log_mode}" "${base_cmd}"
        else
            # Log the command without outgroup
            stage_cmd "${log_mode}" "${base_cmd}"
        fi

        # Execute the command
        eval "${base_cmd}" > /dev/null 2>&1

        # Move the output files
        mv "${input_dir}/PhyloPyPruner/phylopypruner_output/" "${input_dir}/PhyloPyPruner/${output_phylopypruner_dir}/"
        sed -i "s/@.*$//g" "${input_dir}/PhyloPyPruner/${output_phylopypruner_dir}/output_alignments/"*.fasta

        # Check the running result
        if [ "$(ls -A "${input_dir}/PhyloPyPruner/${output_phylopypruner_dir}/output_alignments")" ]; then
            stage_info "${log_mode}" "Successfully finishing running PhyloPyPruner for ${method}."
            return 0
        else
            stage_error "Fail to run PhyloPyPruner for ${method}."
            stage_error "HybSuite exits."
            stage_blank_main ""
            exit 1
        fi
    }

    # Run PhyloPyPruner for LS
    if [ "${LS}" = "TRUE" ]; then
        run_phylopypruner "LS" "Output_LS" "${nt_phylopypruner}" "${output_dir}/03-Orthology_inference" "${pp_trim_lb}" "${pp_min_taxa}" "${min_length}" || exit 1
    fi

    # Run PhyloPyPruner for MI
    if [ "${MI}" = "TRUE" ] && [ "${run_paragone}" = "FALSE" ]; then
        run_phylopypruner "MI" "Output_MI" "${nt_phylopypruner}" "${output_dir}/03-Orthology_inference" "${pp_trim_lb}" "${pp_min_taxa}" "${min_length}" || exit 1
    fi

    # Run PhyloPyPruner for MO
    if [ "${MO}" = "TRUE" ] && [ "${run_paragone}" = "FALSE" ]; then
        run_phylopypruner "MO" "Output_MO" "${nt_phylopypruner}" "${output_dir}/03-Orthology_inference" "${pp_trim_lb}" "${pp_min_taxa}" "${min_length}" "${output_dir}/00-logs_and_checklists/checklists/Outgroup.txt" || exit 1
    fi

    # Run PhyloPyPruner for RT
    if [ "${RT}" = "TRUE" ] && [ "${run_paragone}" = "FALSE" ]; then
        run_phylopypruner "RT" "Output_RT" "${nt_phylopypruner}" "${output_dir}/03-Orthology_inference" "${pp_trim_lb}" "${pp_min_taxa}" "${min_length}" "${output_dir}/00-logs_and_checklists/checklists/Outgroup.txt" || exit 1
    fi
    
    # Run PhyloPyPruner for 1to1
    if [ "${one_to_one}" = "TRUE" ] && [ "${run_paragone}" = "FALSE" ]; then
        run_phylopypruner "1to1" "Output_1to1" "${nt_phylopypruner}" "${output_dir}/03-Orthology_inference" "${pp_trim_lb}" "${pp_min_taxa}" "${min_length}" || exit 1
    fi
  fi

  ############################################################################################
  #Stage3-Optional method: MO/MI/RT/1to1 for ParaGone ########################################
  ############################################################################################
  #ParaGone (optional)
  if ([ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "${one_to_one}" = "TRUE" ]) && [ "${run_paragone}" = "TRUE" ] && [ "${run_phylopypruner}" = "FALSE" ]; then
    stage_blank "${log_mode}" ""
    stage_info "${log_mode}" "Optional Part: Run ParaGone (MO/MI/RT/1to1) ... "
    
    # Preparation: remove existed files
    if [ -d "${output_dir}/03-Orthology_inference/ParaGone" ]; then
      rm -rf "${output_dir}/03-Orthology_inference/ParaGone"
    fi
    # Preparation: Directories and reminders
    mkdir -p ${output_dir}/03-Orthology_inference/ParaGone
    # Preparation: Outgroup processing
    cd ${output_dir}/03-Orthology_inference/ParaGone
    outgroup_args=""
    while IFS= read -r line || [ -n "$line" ]; do
      outgroup_args="$outgroup_args --internal_outgroup $line"
    done < "${output_dir}/00-logs_and_checklists/checklists/Outgroup.txt"
    # Preparation: change species names to correct ones for running ParaGone 
    for file in "${output_dir}/02-All_paralogs/03-Filtered_paralogs/"*; do
      sed -i "s/_var\._/_var_/g"  "${file}"
      sed -i "s/_subsp\._/_subsp_/g" "${file}"
      sed -i "s/_f\._/_f_/g" "${file}"
    done

    # Define threads
    define_threads "paragone"

    # ParaGone fullpipeline
    run_paragone() {
      local input_dir="${output_dir}/02-All_paralogs/03-Filtered_paralogs"
      
      stage_blank "${log_mode}" ""
      log_info="====>> Running ParaGone via "
      if [ "${MO}" = "TRUE" ]; then
        log_info="${log_info} MO"
      fi
      if [ "${MI}" = "TRUE" ]; then
        log_info="${log_info} MI"
      fi
      if [ "${RT}" = "TRUE" ]; then
        log_info="${log_info} RT"
      fi
      if [ "${one_to_one}" = "TRUE" ]; then
        log_info="${log_info} 1to1"
      fi
      log_info="${log_info} ... ====>>"

      paragone_step1_cmd="paragone check_and_align ${input_dir}${outgroup_args} --pool ${paragone_pool} --threads ${nt_paragone} --mafft_algorithm ${mafft_algorithm} --trimal_${trimal_mode}"
      paragone_step2_cmd="paragone alignment_to_tree 04_alignments_trimmed_cleaned --pool ${paragone_pool} --threads ${nt_paragone}"
      paragone_step3_cmd="paragone qc_trees_and_extract_fasta 04_alignments_trimmed_cleaned --min_tips ${paragone_min_tips} --treeshrink_q_value ${paragone_treeshrink_q_value} --cut_deep_paralogs_internal_branch_length_cutoff ${paragone_cutoff_value}"
      paragone_step4_cmd="paragone align_selected_and_tree 04_alignments_trimmed_cleaned --pool ${paragone_pool} --threads ${nt_paragone}"
      paragone_step5_cmd="paragone prune_paralogs --minimum_taxa ${paragone_minimum_taxa}"
      paragone_step6_cmd="paragone final_alignments --pool ${paragone_pool} --threads ${nt_paragone}"

      if [ "${trimal_gapthreshold}" != "_____" ]; then
        paragone_step1_cmd="${paragone_step1_cmd} --trimal_gapthreshold ${trimal_gapthreshold}"
        paragone_step4_cmd="${paragone_step4_cmd} --trimal_gapthreshold ${trimal_gapthreshold}"
        paragone_step6_cmd="${paragone_step6_cmd} --trimal_gapthreshold ${trimal_gapthreshold}"
      fi
      if [ "${trimal_simthreshold}" != "_____" ]; then
        paragone_step1_cmd="${paragone_step1_cmd} --trimal_simthreshold ${trimal_simthreshold}"
        paragone_step4_cmd="${paragone_step4_cmd} --trimal_simthreshold ${trimal_simthreshold}"
        paragone_step6_cmd="${paragone_step6_cmd} --trimal_simthreshold ${trimal_simthreshold}"
      fi  
      if [ "${trimal_cons}" != "_____" ]; then
        paragone_step1_cmd="${paragone_step1_cmd} --trimal_cons ${trimal_cons}"
        paragone_step4_cmd="${paragone_step4_cmd} --trimal_cons ${trimal_cons}"
        paragone_step6_cmd="${paragone_step6_cmd} --trimal_cons ${trimal_cons}"
      fi
      if [ "${trimal_resoverlap}" != "_____" ]; then
        paragone_step1_cmd="${paragone_step1_cmd} --trimal_resoverlap ${trimal_resoverlap}"
        paragone_step4_cmd="${paragone_step4_cmd} --trimal_resoverlap ${trimal_resoverlap}"
        paragone_step6_cmd="${paragone_step6_cmd} --trimal_resoverlap ${trimal_resoverlap}"
      fi  
      if [ "${trimal_seqoverlap}" != "_____" ]; then
        paragone_step1_cmd="${paragone_step1_cmd} --trimal_seqoverlap ${trimal_seqoverlap}"
        paragone_step4_cmd="${paragone_step4_cmd} --trimal_seqoverlap ${trimal_seqoverlap}"
        paragone_step6_cmd="${paragone_step6_cmd} --trimal_seqoverlap ${trimal_seqoverlap}"
      fi
      if [ "${trimal_w}" != "_____" ]; then
        paragone_step1_cmd="${paragone_step1_cmd} --trimal_w ${trimal_w}"
        paragone_step4_cmd="${paragone_step4_cmd} --trimal_w ${trimal_w}"
        paragone_step6_cmd="${paragone_step6_cmd} --trimal_w ${trimal_w}"
      fi  
      if [ "${trimal_gw}" != "_____" ]; then
        paragone_step1_cmd="${paragone_step1_cmd} --trimal_gw ${trimal_gw}"
        paragone_step4_cmd="${paragone_step4_cmd} --trimal_gw ${trimal_gw}"
        paragone_step6_cmd="${paragone_step6_cmd} --trimal_gw ${trimal_gw}"
      fi  
      if [ "${trimal_sw}" != "_____" ]; then
        paragone_step1_cmd="${paragone_step1_cmd} --trimal_sw ${trimal_sw}"
        paragone_step4_cmd="${paragone_step4_cmd} --trimal_sw ${trimal_sw}"
        paragone_step6_cmd="${paragone_step6_cmd} --trimal_sw ${trimal_sw}"
      fi  
      
      if [ "${paragone_tree}" = "fasttree" ]; then
        paragone_step2_cmd="${paragone_step2_cmd} --use_fasttree"
        paragone_step4_cmd="${paragone_step4_cmd} --use_fasttree"
      fi

      if [ "${paragone_keep_intermediate_files}" = "TRUE" ]; then
        paragone_step6_cmd="${paragone_step6_cmd} --keep_intermediate_files"
      fi

      if [ "${MO}" = "TRUE" ] || [ "${one_to_one}" = "TRUE" ]; then
        paragone_step5_cmd="${paragone_step5_cmd} --mo"
      fi
      if [ "${MI}" = "TRUE" ]; then
        paragone_step5_cmd="${paragone_step5_cmd} --mi"
      fi
      if [ "${RT}" = "TRUE" ]; then
        paragone_step5_cmd="${paragone_step5_cmd} --rt"
      fi

      stage_info_main "Running ParaGone step1 ... "
      stage_cmd "${log_mode}" "${paragone_step1_cmd}"
      eval "${paragone_step1_cmd}" > /dev/null 2>&1
      if [ ! -n "$(find "./04_alignments_trimmed_cleaned" -maxdepth 1 -mindepth 1 -print -quit)" ]; then
        stage_error "Fail to run ParaGone step1."
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      else
        stage_info_main "Finish."
      fi
      stage_info_main "Running ParaGone step2 ... "
      stage_cmd "${log_mode}" "${paragone_step2_cmd}"
      eval "${paragone_step2_cmd}" > /dev/null 2>&1
      if [ ! -n "$(find "./05_trees_pre_quality_control" -maxdepth 1 -mindepth 1 -print -quit)" ]; then
        stage_error "Fail to run ParaGone step2."
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      else
        stage_info_main "Finish."
      fi
      stage_info_main "Running ParaGone step3 ... "
      stage_cmd "${log_mode}" "${paragone_step3_cmd}"
      eval "${paragone_step3_cmd}" > /dev/null 2>&1
      if [ ! -n "$(find "./09_sequences_from_qc_trees" -maxdepth 1 -mindepth 1 -print -quit)" ]; then
        stage_error "Fail to run ParaGone step3."
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      else
        stage_info_main "Finish."
      fi
      stage_info_main "Running ParaGone step4 ... "
      stage_cmd "${log_mode}" "${paragone_step4_cmd}"
      eval "${paragone_step4_cmd}" > /dev/null 2>&1
      if [ ! -n "$(find "./13_pre_paralog_resolution_trees" -maxdepth 1 -mindepth 1 -print -quit)" ]; then
        stage_error "Fail to run ParaGone step4."
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      else
        stage_info_main "Finish."
      fi
      stage_info_main "Running ParaGone step5 ... "
      stage_cmd "${log_mode}" "${paragone_step5_cmd}"
      eval "${paragone_step5_cmd}" > /dev/null 2>&1
      if [ ! -n "$(find "./14_pruned_MO" -maxdepth 1 -mindepth 1 -print -quit)" ] \
      && [ ! -n "$(find "./15_pruned_MI" -maxdepth 1 -mindepth 1 -print -quit)" ] \
      && [ ! -n "$(find "./16_pruned_RT" -maxdepth 1 -mindepth 1 -print -quit) " ]; then
        stage_error "Fail to run ParaGone step5."
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      else
        stage_info_main "Finish."
      fi
      stage_info_main "Running ParaGone step6 ... "
      stage_cmd "${log_mode}" "${paragone_step6_cmd}"
      eval "${paragone_step6_cmd}" > /dev/null 2>&1
      if [ ! -n "$(find "./23_MO_final_alignments" -maxdepth 1 -mindepth 1 -print -quit)" ] \
      && [ ! -n "$(find "./24_MI_final_alignments" -maxdepth 1 -mindepth 1 -print -quit)" ] \
      && [ ! -n "$(find "./25_RT_final_alignments" -maxdepth 1 -mindepth 1 -print -quit)" ] \
      && [ ! -n "$(find "./26_MO_final_alignments_trimmed" -maxdepth 1 -mindepth 1 -print -quit)" ] \
      && [ ! -n "$(find "./27_MI_final_alignments_trimmed" -maxdepth 1 -mindepth 1 -print -quit)" ] \
      && [ ! -n "$(find "./28_RT_final_alignments_trimmed" -maxdepth 1 -mindepth 1 -print -quit)" ]; then
        stage_error "Fail to finish running ParaGone."
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      else
        stage_info_main "Finish."
      fi

      if [ "${one_to_one}" = "TRUE" ]; then
        cd ./26_MO_final_alignments_trimmed
        mkdir -p ../HybSuite_1to1_final_alignments_trimmed
        files=$(find . -maxdepth 1 -type f -name "*1to1*")
        total_sps=$(find . -maxdepth 1 -type f -name "*1to1*" | wc -l)
        j=0
        stage_info_main "====>> Extracting 1to1 alignments ====>>"
        for file in $files; do
          j=$((j + 1 ))
          cp "$file" "../HybSuite_1to1_final_alignments_trimmed"
          progress=$((j * 100 / total_sps))
          printf "\r[$(date +%Y-%m-%d\ %H:%M:%S)] [INFO] Extracting 1to1 alignments: ${j}/${total_sps} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress"
        done
        echo
        for file in "${output_dir}/03-Orthology_inference/ParaGone/HybSuite_1to1_final_alignments_trimmed/"*; do
          sed -i "s/_var_/_var\._/g"  "${file}"
          sed -i "s/_subsp_/_subsp\._/g" "${file}"
          sed -i "s/_f_/_f\._/g" "${file}"
        done
      fi
      if [ "${MO}" = "TRUE" ]; then
        for file in ${output_dir}/03-Orthology_inference/ParaGone/26_MO_final_alignments_trimmed/*; do
          sed -i "s/_var_/_var\._/g"  "${file}"
          sed -i "s/_subsp_/_subsp\._/g" "${file}"
          sed -i "s/_f_/_f\._/g" "${file}"
        done
      fi
      if [ "${MI}" = "TRUE" ]; then
        for file in ${output_dir}/03-Orthology_inference/ParaGone/27_MI_final_alignments_trimmed/*; do
          sed -i "s/_var_/_var\._/g"  "${file}"
          sed -i "s/_subsp_/_subsp\._/g" "${file}"
          sed -i "s/_f_/_f\._/g" "${file}"
        done
      fi
      if [ "${RT}" = "TRUE" ]; then
        for file in ${output_dir}/03-Orthology_inference/ParaGone/28_RT_final_alignments_trimmed/*; do
          sed -i "s/_var_/_var\._/g"  "${file}"
          sed -i "s/_subsp_/_subsp\._/g" "${file}"
          sed -i "s/_f_/_f\._/g" "${file}"
        done
      fi
    }
    cd "${output_dir}/03-Orthology_inference/ParaGone"
    stage_info_main "Running ParaGone full pipeline from step1 to step6 ... "
    stage_info_main "See results in ${output_dir}/03-Orthology_inference/ParaGone."
    stage_info_main "See ParaGone logs in ${output_dir}/03-Orthology_inference/ParaGone/00_logs_and_reports/logs/"
    run_paragone
  fi

  ############################################################################################
  # End of Stage 3
  stage_info_main "Successfully finishing the stage3: 'Orthology inference'."
  stage_info_main "The resulting files have been saved in ${output_dir}/03-Orthology_inference/"

  if [ "${run_to_stage3}" = "true" ]; then
    # Clean up environment
    cleanup_parallel_env "$work_dir"
    stage_info_main "You set '--run_to_stage3' to specify HybSuite to run only stage 3."
    stage_info_main "Consequently, HybSuite will stop and exit right now."
    stage_info_main "Thank you for using HybSuite! Enjoy your research!"
    stage_blank_main ""
    exit 1
  else
    stage_info "${log_mode}" "Moving on to the next stage..."
    stage_blank_main ""
  fi
  ############################################################################################
fi

############################################################################################
# Stage 4: Sequence Alignment, Trimming, and Supermatrix Construction ######################
############################################################################################
if [ "${skip_stage1234}" = "TRUE" ]; then
  stage_info_main "Stage 4 Sequence Alignment, Trimming, and Supermatrix Construction is skipped."
else
  #################===========================================================================
  # 0.Preparation
  stage_info_main "<<<======= Stage 4 Sequence Alignment, Trimming, and Supermatrix Construction =======>>>"
  #################===========================================================================

  ##############################################################################################
  #Stage4-Optional step: Running MAFFT and Trimal, constructing supermatrix for HRS sequences ##
  ##############################################################################################
  if [ "${HRS}" = "TRUE" ]; then
    stage_info_main "Optional step: Running MAFFT and Trimal, constructing supermatrix for HRS sequences ..."
    #01-Running MAFFT and Trimal for HRS sequences
    stage_info_main "01-Running MAFFT and Trimal for HRS sequences ..."
    cd ${output_dir}/03-Orthology_inference/HRS/03-Filtered_HRS_sequences
    if [ -d "${output_dir}/04-Alignments/HRS" ]; then
      rm -rf "${output_dir}/04-Alignments/HRS"
    fi
    mkdir -p "${output_dir}/04-Alignments/HRS"
    temp_file="fna_file_list.txt"
    find . -maxdepth 1 -type f -name "*.FNA" -exec basename {} \; > "$temp_file"
    total_sps=$(wc -l < "$temp_file")
    init_parallel_env "$work_dir" "$total_sps" "$process" "$temp_file" || exit 1
    while IFS= read -r file || [ -n "$file" ]; do
      if [ "${process}" != "all" ]; then
        read -u1000
      fi
      {
      file_name=$(basename "${file}" .FNA)
      # Update start count
      update_start_count "$file_name" "$stage_logfile"
      sed -e 's/ single_hit//g;s/ multi_hit_stitched_contig_comprising_.*_hits//g' "${file}" > "${output_dir}/04-Alignments/HRS/${file_name}.fasta"
      run_mafft "${output_dir}/04-Alignments/HRS/${file_name}.fasta" "${output_dir}/04-Alignments/HRS/${file_name}.aln.fasta" "${nt_mafft}"
      run_trimal "${output_dir}/04-Alignments/HRS/${file_name}.aln.fasta" "${output_dir}/04-Alignments/HRS/${file_name}.trimmed.aln.fasta" "${trimal_mode}" \
      "${trimal_gapthreshold}" "${trimal_simthreshold}" "${trimal_cons}" "${trimal_block}" "${trimal_resoverlap}" "${trimal_seqoverlap}" \
      "${trimal_w}" "${trimal_gw}" "${trimal_sw}"
      rm "${output_dir}/04-Alignments/HRS/${file_name}.aln.fasta" "${output_dir}/04-Alignments/HRS/${file_name}.fasta"
      remove_n "${output_dir}/04-Alignments/HRS/${file_name}.trimmed.aln.fasta"
      # Update failed count
      if [ ! -s "${output_dir}/04-Alignments/HRS/${file_name}.trimmed.aln.fasta" ]; then
        record_failed_sample "$file_name"
      else
        # Update finish count
        update_finish_count "$file_name" "$stage_logfile"
      fi
      if [ "${process}" != "all" ]; then
        echo >&1000
      fi
      } &
    done < "$temp_file"
    wait
    echo
    # Display processing log
    if [ "${log_mode}" = "full" ]; then
      display_process_log "$stage_logfile" "stage4" "Failed to run MAFFT and Trimal for HRS sequences:"
    fi
    stage_blank "${log_mode}" ""
    rm -r "$temp_file"

    #02-Run AMAS.py to check every alignment
    mkdir -p "${output_dir}/05-Supermatrix/HRS"
    stage_info_main "02-Running AMAS.py to check every alignment ..."
    cd "${output_dir}/04-Alignments/HRS/"
    stage_cmd "${log_mode}" "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${output_dir}/04-Alignments/HRS/*.trimmed.aln.fasta -o ${output_dir}/05-Supermatrix/HRS/AMAS_reports_HRS_raw.tsv"
    python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
    summary -f fasta -d dna -i "${output_dir}"/04-Alignments/HRS/*.trimmed.aln.fasta \
    -o "${output_dir}"/05-Supermatrix/HRS/AMAS_reports_HRS_raw.tsv > /dev/null 2>&1
    if [ -s "${output_dir}/05-Supermatrix/HRS/AMAS_reports_HRS_raw.tsv" ]; then
      stage_info_main "Successfully running AMAS.py to check every HRS alignment."
      stage_info_main "The AMAS summaries have been written to ${output_dir}/05-Supermatrix/HRS/AMAS_reports_HRS_raw.tsv"
    else
      stage_error "Fail to run AMAS.py to check every HRS alignment."
    fi

    #03-Remove alignments with no parsimony informative sites
    stage_blank "${log_mode}" ""
    stage_info_main "03-Removing alignments with no parsimony informative sites ..."
    awk '$9==0 {print $1}' "${output_dir}/05-Supermatrix/HRS/AMAS_reports_HRS_raw.tsv" > "${output_dir}"/05-Supermatrix/HRS/Removed_alignments_for_concatenation_list.txt
    sed -i '1d' "${output_dir}"/05-Supermatrix/HRS/Removed_alignments_for_concatenation_list.txt
    awk '$9!=0 {print $1}' "${output_dir}/05-Supermatrix/HRS/AMAS_reports_HRS_raw.tsv" > "${output_dir}"/05-Supermatrix/HRS/Final_alignments_for_concatenation_list.txt
    sed -i '1d' "${output_dir}"/05-Supermatrix/HRS/Final_alignments_for_concatenation_list.txt
    awk '$9!=0 {print $0}' "${output_dir}/05-Supermatrix/HRS/AMAS_reports_HRS_raw.tsv" > "${output_dir}"/05-Supermatrix/HRS/AMAS_reports_HRS_final.tsv
    while IFS= read -r line || [ -n "$line" ]; do
      rm "${output_dir}"/04-Alignments/HRS/"${line}"
      stage_info "${log_mode}" "Remove alignment ${line}."
    done < "${output_dir}"/05-Supermatrix/HRS/Removed_alignments_for_concatenation_list.txt
    awk '{print $0 "\tno_parsimony_informative_sites"}' "${output_dir}/05-Supermatrix/HRS/Removed_alignments_for_concatenation_list.txt" > "${output_dir}/05-Supermatrix/HRS/Removed_alignments_for_concatenation_list.txt"
    num_filtered_aln=$(wc -l < "${output_dir}"/05-Supermatrix/HRS/Removed_alignments_for_concatenation_list.txt)
    stage_info_main "Successfully removing ${num_filtered_aln} HRS alignments with no parsimony informative sites."

    #04-Concatenate trimmed alignments
    stage_blank "${log_mode}" ""
    stage_info_main "04-Concatenating HRS alignments into the supermatrix ... "
    define_threads "amas"
    stage_cmd "${log_mode}" "AMAS.py concat -f fasta -d dna -i ${output_dir}/04-Alignments/HRS/*.trimmed.aln.fasta -p ${output_dir}/05-Supermatrix/HRS/partition.txt -t ${output_dir}/05-Supermatrix/HRS/${prefix}_HRS2.fasta -y raxml -c ${nt_amas}"
    AMAS.py concat \
    -f fasta \
    -d dna \
    -i ${output_dir}/04-Alignments/HRS/*.trimmed.aln.fasta \
    -p ${output_dir}/05-Supermatrix/HRS/partition.txt \
    -t ${output_dir}/05-Supermatrix/HRS/${prefix}_HRS2.fasta \
    -y raxml \
    -c ${nt_amas} > /dev/null 2>&1
    stage_cmd "${log_mode}" "awk '/^>/ {print $0; next} {gsub(/\?/, "-"); print}' ${output_dir}/05-Supermatrix/HRS/${prefix}_HRS2.fasta > ${output_dir}/05-Supermatrix/HRS/${prefix}_HRS.fasta"
    awk '/^>/ {print $0; next} {gsub(/\?/, "-"); print}' ${output_dir}/05-Supermatrix/HRS/${prefix}_HRS2.fasta > ${output_dir}/05-Supermatrix/HRS/${prefix}_HRS.fasta
    rm ${output_dir}/05-Supermatrix/HRS/${prefix}_HRS2.fasta
    if [ -s "${output_dir}/05-Supermatrix/HRS/${prefix}_HRS.fasta" ]; then
      stage_info_main "Successfully concatenating HRS alignments into the supermatrix."
    else
      stage_error "Fail to concatenate HRS alignments into the supermatrix."
    fi

    #05-Run AMAS.py to check the HRS supermatrix
    stage_blank "${log_mode}" ""
    stage_info_main "05-Running AMAS.py to check the HRS supermatrix ... "
    stage_cmd "${log_mode}" "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${output_dir}/05-Supermatrix/HRS/${prefix}_HRS.fasta -o ${output_dir}/05-Supermatrix/HRS/AMAS_reports_HRS_supermatrix.tsv"
    python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
    summary -f fasta -d dna -i ${output_dir}/05-Supermatrix/HRS/${prefix}_HRS.fasta \
    -o "${output_dir}"/05-Supermatrix/HRS/AMAS_reports_HRS_supermatrix.tsv > /dev/null 2>&1
    awk 'NR==2' "${output_dir}"/05-Supermatrix/HRS/AMAS_reports_HRS_supermatrix.tsv >> "${output_dir}"/05-Supermatrix/HRS/AMAS_reports_HRS_raw.tsv
    awk 'NR==2' "${output_dir}"/05-Supermatrix/HRS/AMAS_reports_HRS_supermatrix.tsv >> "${output_dir}"/05-Supermatrix/HRS/AMAS_reports_HRS_final.tsv
    if [ -s "${output_dir}/05-Supermatrix/HRS/AMAS_reports_HRS_supermatrix.tsv" ]; then
      stage_info_main "Successfully running AMAS.py to check the HRS supermatrix."
      stage_info_main "The AMAS summary of the HRS supermatrix has been written to the last row of ${output_dir}/05-Supermatrix/HRS/AMAS_reports_HRS_final.tsv"
    else
      stage_error "Fail to run AMAS.py to check HRS supermatrix."
    fi
    rm "${output_dir}"/05-Supermatrix/HRS/AMAS_reports_HRS_supermatrix.tsv
    stage_blank_main ""
  fi

  ##############################################################################################
  #Stage4-Optional step: Running MAFFT and Trimal, constructing supermatrix for RLWP sequences #
  ##############################################################################################
  if [ "${RLWP}" = "TRUE" ]; then
    stage_info_main "Optional step: Running MAFFT and Trimal, constructing supermatrix for RLWP sequences ..."
    #01-Running MAFFT and Trimal for RLWP sequences
    stage_info_main "01-Running MAFFT and Trimal for RLWP sequences ..."
    cd ${output_dir}/03-Orthology_inference/RLWP/03-Filtered_RLWP_sequences
    if [ -d "${output_dir}/04-Alignments/RLWP" ]; then
      rm -rf "${output_dir}/04-Alignments/RLWP"
    fi
    mkdir -p "${output_dir}/04-Alignments/RLWP"
    temp_file="fna_file_list.txt"
    find . -maxdepth 1 -type f -name "*.FNA" -exec basename {} \; > "$temp_file"
    total_sps=$(wc -l < "$temp_file")
    init_parallel_env "$work_dir" "$total_sps" "$process" "$temp_file" || exit 1
    while IFS= read -r file || [ -n "$file" ]; do
      if [ "${process}" != "all" ]; then
        read -u1000
      fi
      {
      file_name=$(basename "${file}" .FNA)
      # Update start count
      update_start_count "$file_name" "$stage_logfile"
      sed -e 's/ single_hit//g;s/ multi_hit_stitched_contig_comprising_.*_hits//g' "${file}" > "${output_dir}/04-Alignments/RLWP/${file_name}.fasta"
      run_mafft "${output_dir}/04-Alignments/RLWP/${file_name}.fasta" "${output_dir}/04-Alignments/RLWP/${file_name}.aln.fasta" "${nt_mafft}"
      run_trimal "${output_dir}/04-Alignments/RLWP/${file_name}.aln.fasta" "${output_dir}/04-Alignments/RLWP/${file_name}.trimmed.aln.fasta" "${trimal_mode}" \
      "${trimal_gapthreshold}" "${trimal_simthreshold}" "${trimal_cons}" "${trimal_block}" "${trimal_resoverlap}" "${trimal_seqoverlap}" \
      "${trimal_w}" "${trimal_gw}" "${trimal_sw}"
      rm "${output_dir}/04-Alignments/RLWP/${file_name}.aln.fasta" "${output_dir}/04-Alignments/RLWP/${file_name}.fasta"
      remove_n "${output_dir}/04-Alignments/RLWP/${file_name}.trimmed.aln.fasta"
      # Update failed count
      if [ ! -s "${output_dir}/04-Alignments/RLWP/${file_name}.trimmed.aln.fasta" ]; then
        record_failed_sample "$file_name"
      else
        # Update finish count
        update_finish_count "$file_name" "$stage_logfile"
      fi
      if [ "${process}" != "all" ]; then
        echo >&1000
      fi
      } &
    done < "$temp_file"
    wait
    echo
    # Display processing log
    if [ "${log_mode}" = "full" ]; then
      display_process_log "$stage_logfile" "stage4" "Failed to run MAFFT and Trimal for RLWP sequences:"
    fi
    stage_blank "${log_mode}" ""
    rm -r "$temp_file"

    #02-Run AMAS.py to check every alignment
    mkdir -p "${output_dir}/05-Supermatrix/RLWP"
    stage_info_main "02-Running AMAS.py to check every alignment ..."
    cd "${output_dir}/04-Alignments/RLWP/"
    stage_cmd "${log_mode}" "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${output_dir}/04-Alignments/RLWP/*.trimmed.aln.fasta -o ${output_dir}/05-Supermatrix/RLWP/AMAS_reports_RLWP_raw.tsv"
    python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
    summary -f fasta -d dna -i "${output_dir}"/04-Alignments/RLWP/*.trimmed.aln.fasta \
    -o "${output_dir}"/05-Supermatrix/RLWP/AMAS_reports_RLWP_raw.tsv > /dev/null 2>&1
    if [ -s "${output_dir}/05-Supermatrix/RLWP/AMAS_reports_RLWP_raw.tsv" ]; then
      stage_info_main "Successfully running AMAS.py to check every RLWP alignment."
      stage_info_main "The AMAS summaries have been written to ${output_dir}/05-Supermatrix/RLWP/AMAS_reports_RLWP_raw.tsv"
    else
      stage_error "Fail to run AMAS.py to check every RLWP alignment."
    fi

    #03-Remove alignments with no parsimony informative sites
    stage_blank "${log_mode}" ""
    stage_info_main "03-Removing alignments with no parsimony informative sites ..."
    awk '$9==0 {print $1}' "${output_dir}/05-Supermatrix/RLWP/AMAS_reports_RLWP_raw.tsv" > "${output_dir}"/05-Supermatrix/RLWP/Removed_alignments_for_concatenation_list.txt
    sed -i '1d' "${output_dir}"/05-Supermatrix/RLWP/Removed_alignments_for_concatenation_list.txt
    awk '$9!=0 {print $1}' "${output_dir}/05-Supermatrix/RLWP/AMAS_reports_RLWP_raw.tsv" > "${output_dir}"/05-Supermatrix/RLWP/Final_alignments_for_concatenation_list.txt
    sed -i '1d' "${output_dir}"/05-Supermatrix/RLWP/Final_alignments_for_concatenation_list.txt
    awk '$9!=0 {print $0}' "${output_dir}/05-Supermatrix/RLWP/AMAS_reports_RLWP_raw.tsv" > "${output_dir}"/05-Supermatrix/RLWP/AMAS_reports_RLWP_final.tsv
    
    while IFS= read -r line || [ -n "$line" ]; do
      rm "${output_dir}"/04-Alignments/RLWP/"${line}"
      stage_info "${log_mode}" "Remove alignment ${line}."
    done < "${output_dir}"/05-Supermatrix/RLWP/Removed_alignments_for_concatenation_list.txt
    awk '{print $0 "\tno_parsimony_informative_sites"}' "${output_dir}/05-Supermatrix/RLWP/Removed_alignments_for_concatenation_list.txt" > "${output_dir}/05-Supermatrix/RLWP/Removed_alignments_for_concatenation_list.txt"
    num_filtered_aln=$(wc -l < "${output_dir}"/05-Supermatrix/RLWP/Removed_alignments_for_concatenation_list.txt)
    stage_info_main "Successfully removing ${num_filtered_aln} RLWP alignments with no parsimony informative sites."

    #04-Concatenate trimmed alignments
    stage_blank "${log_mode}" ""
    stage_info_main "04-Concatenating RLWP alignments into the supermatrix ... "
    define_threads "amas"
    stage_cmd "${log_mode}" "AMAS.py concat -f fasta -d dna -i ${output_dir}/04-Alignments/RLWP/*.trimmed.aln.fasta -p ${output_dir}/05-Supermatrix/RLWP/partition.txt -t ${output_dir}/05-Supermatrix/RLWP/${prefix}_RLWP2.fasta -y raxml -c ${nt_amas}"
    AMAS.py concat \
    -f fasta \
    -d dna \
    -i ${output_dir}/04-Alignments/RLWP/*.trimmed.aln.fasta \
    -p ${output_dir}/05-Supermatrix/RLWP/partition.txt \
    -t ${output_dir}/05-Supermatrix/RLWP/${prefix}_RLWP2.fasta \
    -y raxml \
    -c ${nt_amas} > /dev/null 2>&1
    stage_cmd "${log_mode}" "awk '/^>/ {print $0; next} {gsub(/\?/, "-"); print}' ${output_dir}/05-Supermatrix/RLWP/${prefix}_RLWP2.fasta > ${output_dir}/05-Supermatrix/RLWP/${prefix}_RLWP.fasta"
    awk '/^>/ {print $0; next} {gsub(/\?/, "-"); print}' ${output_dir}/05-Supermatrix/RLWP/${prefix}_RLWP2.fasta > ${output_dir}/05-Supermatrix/RLWP/${prefix}_RLWP.fasta
    rm ${output_dir}/05-Supermatrix/RLWP/${prefix}_RLWP2.fasta
    if [ -s "${output_dir}/05-Supermatrix/RLWP/${prefix}_RLWP.fasta" ]; then
      stage_info_main "Successfully concatenating RLWP alignments into the supermatrix."
    else
      stage_error "Fail to concatenate RLWP alignments into the supermatrix."
    fi

    #05-Run AMAS.py to check the RLWP supermatrix
    stage_blank "${log_mode}" ""
    stage_info_main "05-Running AMAS.py to check the RLWP supermatrix ... "
    stage_cmd "${log_mode}" "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${output_dir}/05-Supermatrix/RLWP/${prefix}_RLWP.fasta -o ${output_dir}/05-Supermatrix/RLWP/AMAS_reports_RLWP_supermatrix.tsv"
    python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
    summary -f fasta -d dna -i ${output_dir}/05-Supermatrix/RLWP/${prefix}_RLWP.fasta \
    -o "${output_dir}"/05-Supermatrix/RLWP/AMAS_reports_RLWP_supermatrix.tsv > /dev/null 2>&1
    awk 'NR==2' "${output_dir}"/05-Supermatrix/RLWP/AMAS_reports_RLWP_supermatrix.tsv >> "${output_dir}"/05-Supermatrix/RLWP/AMAS_reports_RLWP_raw.tsv
    awk 'NR==2' "${output_dir}"/05-Supermatrix/RLWP/AMAS_reports_RLWP_supermatrix.tsv >> "${output_dir}"/05-Supermatrix/RLWP/AMAS_reports_RLWP_final.tsv
    if [ -s "${output_dir}/05-Supermatrix/RLWP/AMAS_reports_RLWP_supermatrix.tsv" ]; then
      stage_info_main "Successfully running AMAS.py to check the RLWP supermatrix."
      stage_info_main "The AMAS summary of the RLWP supermatrix has been written to the last row of ${output_dir}/05-Supermatrix/RLWP/AMAS_reports_RLWP_final.tsv"
    else
      stage_error "Fail to run AMAS.py to check RLWP supermatrix."
    fi
    rm "${output_dir}"/05-Supermatrix/RLWP/AMAS_reports_RLWP_supermatrix.tsv
    stage_blank_main ""
  fi
  

  ###################################################################################################
  #Stage4-Optional step: Extracting PhyloPyPruner output, constructing supermatrix for orthogroups ##
  ###################################################################################################
  if [ "$LS" = "TRUE" ] || { ([ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "$one_to_one" = "TRUE" ]) && [ "${run_phylopypruner}" = "TRUE" ] && [ "${run_paragone}" != "TRUE" ]; }; then
    stage_info_main "Optional step: Extracting PhyloPyPruner output, constructing supermatrix for orthogroups ..."

    stage4_ortho_phylopypruner () {
      local ortho_method=$1
      local output_ortho_phylopypruner_dir=$2

      stage_info_main "====>> ${ortho_method} ====>>"
      stage_info_main "01-Extracting PhyloPyPruner ${ortho_method} output sequences ..."
      if [ -d "${output_dir}/04-Alignments/${ortho_method}" ]; then
        rm -rf "${output_dir}/04-Alignments/${ortho_method}"
      fi
      if [ -d "${output_dir}/05-Supermatrix/${ortho_method}" ]; then
        rm -rf "${output_dir}/05-Supermatrix/${ortho_method}"
      fi
      mkdir -p "${output_dir}/04-Alignments/${ortho_method}" "${output_dir}/05-Supermatrix/${ortho_method}"
      cp "${output_dir}/03-Orthology_inference/PhyloPyPruner/Output_${ortho_method}/output_alignments/"*.fasta "${output_dir}/04-Alignments/${ortho_method}/"
      cd "${output_dir}/04-Alignments/${ortho_method}/"
      for fasta_file in "${output_dir}/04-Alignments/${ortho_method}/"*.fasta; do
          new_name="${fasta_file/_paralogs_all.trimmed.aln/}"
          new_name="${new_name%.fasta}"
          new_name="${new_name/_pruned/}"
          new_name="${new_name}.trimmed.aln.fasta"
          mv "$fasta_file" "$new_name"
      done

      stage_info_main "02-Removing ${ortho_method} orthogroups with <${min_sample_coverage} sample coverage ..."
      stage_cmd "${log_mode}" "python ${script_dir}/filter_seqs_by_sample_and_locus_coverage.py -i ${output_dir}/04-Alignments/${ortho_method}/ --min_sample_coverage ${min_sample_coverage} --removed_samples_info ${output_dir}/04-Alignments/${ortho_method}/Removed_alignments_with_low_sample_coverage.txt -t ${nt}"
      stage4_02="python ${script_dir}/filter_seqs_by_sample_and_locus_coverage.py -i ${output_dir}/04-Alignments/${ortho_method}/ --min_sample_coverage ${min_sample_coverage} --removed_samples_info ${output_dir}/04-Alignments/${ortho_method}/Removed_alignments_with_low_sample_coverage.txt -t ${nt}"
      if [ "${log_mode}" = "full" ]; then
        eval "${stage4_02}"
      else
        eval "${stage4_02} > /dev/null 2>&1"
      fi

      stage_info_main "03-Removing ${ortho_method} orthogroups with no parsimony informative sites ..."
      stage_cmd "${log_mode}" "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${output_dir}/04-Alignments/${ortho_method}/*.trimmed.aln.fasta -o ${output_dir}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv"
      python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
      summary -f fasta -d dna -i "${output_dir}/04-Alignments/${ortho_method}/"*.trimmed.aln.fasta -o "${output_dir}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" > /dev/null 2>&1
      awk '$9==0 {print $1}' "${output_dir}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" > "${output_dir}/05-Supermatrix/${ortho_method}/Removed_alignments_for_concatenation_list.txt"
      sed -i '1d' "${output_dir}/05-Supermatrix/${ortho_method}/Removed_alignments_for_concatenation_list.txt"
      awk '$9!=0 {print $1}' "${output_dir}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" > "${output_dir}/05-Supermatrix/${ortho_method}/Final_alignments_for_concatenation_list.txt"
      sed -i '1d' "${output_dir}/05-Supermatrix/${ortho_method}/Final_alignments_for_concatenation_list.txt"
      awk '$9!=0 {print $0}' "${output_dir}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" > "${output_dir}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_final.tsv"
      while IFS= read -r line || [ -n "$line" ]; do
        rm "${output_dir}"/04-Alignments/${ortho_method}/"${line}"
      done < "${output_dir}"/05-Supermatrix/${ortho_method}/Removed_alignments_for_concatenation_list.txt

      stage_info_main "04-Concatenating ${ortho_method} orthogroups into the supermatrix ..."
      define_threads "amas"
      stage_cmd "${log_mode}" "AMAS.py concat -f fasta -d dna -i ${output_dir}/04-Alignments/${ortho_method}/*.trimmed.aln.fasta -p ${output_dir}/05-Supermatrix/${ortho_method}/partition.txt -t ${output_dir}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}2.fasta -y raxml -c ${nt_amas}"
      AMAS.py concat \
      -f fasta \
      -d dna \
      -i ${output_dir}/04-Alignments/${ortho_method}/*.trimmed.aln.fasta \
      -p ${output_dir}/05-Supermatrix/${ortho_method}/partition.txt \
      -t ${output_dir}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}2.fasta \
      -y raxml \
      -c ${nt_amas} > /dev/null 2>&1
      stage_cmd "${log_mode}" "awk '/^>/ {print $0; next} {gsub(/\?/, "-"); print}' ${output_dir}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}2.fasta > ${output_dir}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}.fasta"
      awk '/^>/ {print $0; next} {gsub(/\?/, "-"); print}' ${output_dir}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}2.fasta > ${output_dir}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}.fasta
      rm ${output_dir}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}2.fasta

      stage_info_main "05-Running AMAS.py to check the ${ortho_method} supermatrix ..."
      stage_cmd "${log_mode}" "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${output_dir}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}.fasta -o ${output_dir}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv"
      python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
      summary -f fasta -d dna -i "${output_dir}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}.fasta" -o "${output_dir}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" > /dev/null 2>&1
      awk 'NR==2' "${output_dir}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" >> "${output_dir}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_final.tsv"
      rm "${output_dir}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv"
      sed -i 's/AA, /DNA, /g' "${output_dir}/05-Supermatrix/${ortho_method}/partition.txt"
    }

    if [ "${LS}" = "TRUE" ]; then
      stage4_ortho_phylopypruner "LS" "Output_LS"
    fi
    if [ "${MI}" = "TRUE" ] && [ "${run_paragone}" = "FALSE" ]; then
      stage4_ortho_phylopypruner "MI" "Output_MI"
    fi
    if [ "${MO}" = "TRUE" ] && [ "${run_paragone}" = "FALSE" ]; then
      stage4_ortho_phylopypruner "MO" "Output_MO"
    fi
    if [ "${RT}" = "TRUE" ] && [ "${run_paragone}" = "FALSE" ]; then
      stage4_ortho_phylopypruner "RT" "Output_RT"
    fi
    if [ "${one_to_one}" = "TRUE" ] && [ "${run_paragone}" = "FALSE" ]; then
      stage4_ortho_phylopypruner "1to1" "Output_1to1"
    fi
  fi
  stage_blank_main ""
  
  ###################################################################################################
  #Stage4-Optional step: Extracting ParaGone output, constructing supermatrix for orthogroups #######
  ###################################################################################################
  if [ "${MO}" = "TRUE" ] || [ "${MI}" = "TRUE" ] || [ "${RT}" = "TRUE" ] || [ "${one_to_one}" = "TRUE" ] && [ "${run_paragone}" = "TRUE" ] && [ "${run_phylopypruner}" != "TRUE" ]; then
    stage_info_main "Optional step: Extracting ParaGone output, constructing supermatrix for orthogroups ..."
    stage4_ortho_paragone () {
      local ortho_method=$1
      local output_paragone_dir=$2
      
      stage_info_main "01-Extracting ParaGone ${ortho_method} output sequences ..."
      if [ -d "${output_dir}/04-Alignments/${ortho_method}" ]; then
        rm -rf "${output_dir}/04-Alignments/${ortho_method}"
      fi
      mkdir -p "${output_dir}/04-Alignments/${ortho_method}" "${output_dir}/05-Supermatrix/${ortho_method}"
      cp "${output_dir}/03-Orthology_inference/ParaGone/${output_paragone_dir}/"*.fasta "${output_dir}/04-Alignments/${ortho_method}/"
      cd "${output_dir}/04-Alignments/${ortho_method}/"
      for file in "${output_dir}/04-Alignments/${ortho_method}/"*; do
      # Use sed to replace the second occurrence of "ortho." or "ortho<number>." with "aln.trimmed.fasta"
        new_filename=$(echo "${file}" | sed -E 's/selected_stripped.aln.trimmed.fasta/trimmed.aln.fasta/')
        mv "${file}" "${new_filename}"
      done
      
      stage_info_main "02-Removing ${ortho_method} orthogroups with <${min_sample_coverage} sample coverage ..."
      stage_cmd "${log_mode}" "python ${script_dir}/filter_seqs_by_sample_and_locus_coverage.py -i ${output_dir}/04-Alignments/${ortho_method}/ --min_sample_coverage ${min_sample_coverage} --removed_samples_info ${output_dir}/04-Alignments/${ortho_method}/Removed_alignments_with_low_sample_coverage.txt -t ${nt}"
      stage4_02="python ${script_dir}/filter_seqs_by_sample_and_locus_coverage.py -i ${output_dir}/04-Alignments/${ortho_method}/ --min_sample_coverage ${min_sample_coverage} --removed_samples_info ${output_dir}/04-Alignments/${ortho_method}/Removed_alignments_with_low_sample_coverage.txt -t ${nt}"
      if [ "${log_mode}" = "full" ]; then
        eval "${stage4_02}"
      else
        eval "${stage4_02} > /dev/null 2>&1"
      fi

      stage_info_main "03-Removing ${ortho_method} orthogroups with no parsimony informative sites ..."
      stage_cmd "${log_mode}" "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${output_dir}/04-Alignments/${ortho_method}/*.trimmed.aln.fasta -o ${output_dir}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv"
      python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
      summary -f fasta -d dna -i "${output_dir}/04-Alignments/${ortho_method}/"*.trimmed.aln.fasta -o "${output_dir}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" > /dev/null 2>&1
      awk '$9==0 {print $1}' "${output_dir}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" > "${output_dir}/05-Supermatrix/${ortho_method}/Removed_alignments_for_concatenation_list.txt"
      sed -i '1d' "${output_dir}/05-Supermatrix/${ortho_method}/Removed_alignments_for_concatenation_list.txt"
      awk '$9!=0 {print $1}' "${output_dir}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" > "${output_dir}/05-Supermatrix/${ortho_method}/Final_alignments_for_concatenation_list.txt"
      sed -i '1d' "${output_dir}/05-Supermatrix/${ortho_method}/Final_alignments_for_concatenation_list.txt"
      awk '$9!=0 {print $0}' "${output_dir}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" > "${output_dir}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_final.tsv"
      while IFS= read -r line || [ -n "$line" ]; do
        rm "${output_dir}"/04-Alignments/${ortho_method}/"${line}"
      done < "${output_dir}"/05-Supermatrix/${ortho_method}/Removed_alignments_for_concatenation_list.txt

      stage_info_main "04-Concatenating ${ortho_method} orthogroups into the supermatrix ..."
      define_threads "amas"
      stage_cmd "${log_mode}" "AMAS.py concat -f fasta -d dna -i ${output_dir}/04-Alignments/${ortho_method}/*.trimmed.aln.fasta -p ${output_dir}/05-Supermatrix/${ortho_method}/partition.txt -t ${output_dir}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}2.fasta -y raxml"
      AMAS.py concat \
      -f fasta \
      -d dna \
      -i ${output_dir}/04-Alignments/${ortho_method}/*.trimmed.aln.fasta \
      -p ${output_dir}/05-Supermatrix/${ortho_method}/partition.txt \
      -t ${output_dir}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}2.fasta \
      -y raxml \
      -c ${nt_amas} > /dev/null 2>&1
      stage_cmd "${log_mode}" "awk '/^>/ {print $0; next} {gsub(/\?/, "-"); print}' ${output_dir}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}2.fasta > ${output_dir}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}.fasta"
      awk '/^>/ {print $0; next} {gsub(/\?/, "-"); print}' ${output_dir}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}2.fasta > ${output_dir}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}.fasta
      rm ${output_dir}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}2.fasta

      stage_info_main "05-Running AMAS.py to check the ${ortho_method} supermatrix ..."
      stage_cmd "${log_mode}" "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${output_dir}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}.fasta -o ${output_dir}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv"
      python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
      summary -f fasta -d dna -i "${output_dir}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}.fasta" -o "${output_dir}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" > /dev/null 2>&1
      awk 'NR==2' "${output_dir}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" >> "${output_dir}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_final.tsv"
      rm "${output_dir}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv"
    }

    if [ "${MO}" = "TRUE" ] && [ "${run_phylopypruner}" = "FALSE" ]; then
      stage4_ortho_paragone "MO" "26_MO_final_alignments_trimmed"
    fi
    if [ "${MI}" = "TRUE" ] && [ "${run_phylopypruner}" = "FALSE" ]; then
      stage4_ortho_paragone "MI" "27_MI_final_alignments_trimmed"
    fi
    if [ "${RT}" = "TRUE" ] && [ "${run_phylopypruner}" = "FALSE" ]; then
      stage4_ortho_paragone "RT" "28_RT_final_alignments_trimmed"
    fi
    if [ "${one_to_one}" = "TRUE" ] && [ "${run_phylopypruner}" = "FALSE" ]; then
      stage4_ortho_paragone "1to1" "HybSuite_1to1_final_alignments_trimmed"
    fi
  fi
  stage_blank "${log_mode}" ""
  ############################################################################################
  # End of Stage 4
  stage_info_main "Successfully finishing the stage 4: Sequence alignment, trimming and supermatrix construction."
  stage_info "${log_mode}" "The resulting files have been saved in ${output_dir}/04-Alignments/ and ${output_dir}/05-Supermatrix"

  if [ "${run_to_stage4}" = "true" ]; then
    # Clean up environment
    cleanup_parallel_env "$work_dir"
    stage_info_main "You set '--run_to_stage4' to specify HybSuite to run to the stage 4."
    stage_info_main "Consequently, HybSuite will stop and exit right now."
    stage_info_main "Thank you for using HybSuite! Enjoy your research!"
    stage_blank_main ""
    exit 1
  else
    stage_info_main "Moving on to the next stage..."
    stage_blank_main ""
  fi
  ############################################################################################
fi



############################################################################################
# Stage 5: Phylogenetic trees inference ####################################################
############################################################################################
if [ -d "${output_dir}/06-ModelTest-NG" ]; then
    rm -rf "${output_dir}/06-ModelTest-NG"
fi
mkdir -p "${output_dir}/06-ModelTest-NG"
################===========================================================================
# 0.Preparation
stage_info_main "<<<======= Stage 5 Phylogenetic trees inference =======>>>"
################===========================================================================

###################################################################################################
#Stage5-Optional step: Model Test #################################################################
###################################################################################################
#1. ModelTest-NG (Optional)
#Preparation
if [ "${run_modeltest_ng}" = "TRUE" ] && ([ "${run_iqtree}" = "TRUE" ] || [ "${run_raxml}" = "TRUE" ] || [ "${run_raxml_ng}" = "TRUE" ]); then
  stage_info_main "Optional step: Model Test"
  define_threads "modeltest_ng"

  run_modeltest_ng() {
    local ortho_method="$1"
  
    if [ "${ortho_method}" = "1to1" ]; then
      ortho_method="one_to_one"
      ortho_method_dir="1to1"
    else
      ortho_method_dir="${ortho_method}"
    fi
    stage_info_main "Running ModelTest-NG for the ${ortho_method_dir} supermatrix ... "
    mkdir -p "${output_dir}/06-ModelTest-NG/${ortho_method_dir}"
    stage_cmd "${log_mode}" "modeltest-ng -d nt --force -p ${nt_modeltest_ng} -i ${output_dir}/05-Supermatrix/${ortho_method_dir}/${prefix}_${ortho_method_dir}.fasta -o ${output_dir}/06-ModelTest-NG/${ortho_method_dir}/${prefix}_modeltest.txt -T raxml"
    modeltest-ng -d nt \
    --force \
    -p ${nt_modeltest_ng} \
    -i "${output_dir}/05-Supermatrix/${ortho_method_dir}/${prefix}_${ortho_method_dir}.fasta" \
    -o "${output_dir}/06-ModelTest-NG/${ortho_method_dir}/${prefix}_modeltest.txt" \
    -T raxml > /dev/null 2>&1
    stage_blank "${log_mode}" ""
    ###02-According to the result, assign different variables to the suggested commands for each tree building software
    eval "${ortho_method}_iqtree=\$(grep -n 'iqtree' ${output_dir}/06-ModelTest-NG/${ortho_method_dir}/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*iqtree/iqtree/g')"
    eval "${ortho_method}_raxml_ng_mtest=\$(grep -n 'raxml-ng' ${output_dir}/06-ModelTest-NG/${ortho_method_dir}/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxml-ng/raxml-ng/g')"
    eval "${ortho_method}_raxmlHPC_mtest=\$(grep -n 'raxmlHPC' ${output_dir}/06-ModelTest-NG/${ortho_method_dir}/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxmlHPC/raxmlHPC-PTHREADS/g; s/ -n .*$//')"
  }

  if [ "${HRS}" = "TRUE" ]; then
    run_modeltest_ng "HRS"
  fi
  if [ "${RLWP}" = "TRUE" ]; then
    run_modeltest_ng "RLWP"
  fi
  if [ "${LS}" = "TRUE" ]; then
    run_modeltest_ng "LS"
  fi
  if [ "${MI}" = "TRUE" ]; then
    run_modeltest_ng "MI"
  fi
  if [ "${MO}" = "TRUE" ]; then
    run_modeltest_ng "MO"
  fi
  if [ "${RT}" = "TRUE" ]; then
    run_modeltest_ng "RT"
  fi
  if [ "${one_to_one}" = "TRUE" ]; then
    run_modeltest_ng "1to1"
  fi
fi
stage_blank_main ""

###################################################################################################
#Stage5-Optional step: Constructing concatenation-based trees #####################################
###################################################################################################
#Preparation
if [ "${run_iqtree}" = "TRUE" ] || [ "${run_raxml}" = "TRUE" ] || [ "${run_raxml_ng}" = "TRUE" ]; then
  
  run_iqtree() {
    local ortho_method="$1"

    if [ -d "${output_dir}/07-Concatenation-based_trees/${ortho_method}/IQ-TREE" ]; then
      rm -rf "${output_dir}/07-Concatenation-based_trees/${ortho_method}/IQ-TREE"
    fi
    stage_info_main "Optional step: Constructing concatenation-based trees for "${ortho_method}" supermatrix via IQ-TREE"
    define_threads "iqtree"
    mkdir -p "${output_dir}/07-Concatenation-based_trees/${ortho_method}/IQ-TREE"
    cd "${output_dir}/05-Supermatrix/${ortho_method}"
    if [ "${ortho_method}" = "1to1" ]; then
        ortho_method="one_to_one"
        ortho_method_dir="1to1"
    else
        ortho_method_dir="${ortho_method}"
    fi
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      var_name="${ortho_method}_iqtree"
      eval "iqtree_cmd=\$$var_name"
      run_iqtree_cmd="${iqtree_cmd} -B ${iqtree_bb} --undo \
      --seed 12345 -T ${nt_iqtree} -pre ${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/IQ-TREE/IQ-TREE_${prefix}_${ortho_method_dir}"
      if [ "${iqtree_partition}" = "TRUE" ]; then
        run_iqtree_cmd="${run_iqtree_cmd} -p ${output_dir}/05-Supermatrix/${ortho_method_dir}/partition.txt"
      fi
      if [ "${iqtree_constraint_tree}" != "_____" ]; then
        run_iqtree_cmd="${run_iqtree_cmd} -g ${iqtree_constraint_tree}"
      fi
      if [ "${iqtree_alrt}" != "FALSE" ]; then
        run_iqtree_cmd="${run_iqtree_cmd} -alrt ${iqtree_alrt}"
      fi
      stage_cmd "${log_mode}" "${run_iqtree_cmd}"
      eval "${run_iqtree_cmd} > /dev/null 2>&1"
    else
      run_iqtree_cmd="iqtree -s ${output_dir}/05-Supermatrix/${ortho_method_dir}/${prefix}_${ortho_method_dir}.fasta --undo \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -m MFP \
          -pre ${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/IQ-TREE/IQ-TREE_${prefix}_${ortho_method_dir}"
      if [ "${iqtree_partition}" = "TRUE" ]; then
        run_iqtree_cmd="${run_iqtree_cmd} -p ${output_dir}/05-Supermatrix/${ortho_method_dir}/partition.txt"
      fi
      if [ "${iqtree_constraint_tree}" != "_____" ]; then
        run_iqtree_cmd="${run_iqtree_cmd} -g ${iqtree_constraint_tree}"
      fi
      if [ "${iqtree_alrt}" != "FALSE" ]; then
        run_iqtree_cmd="${run_iqtree_cmd} -alrt ${iqtree_alrt}"
      fi
      stage_cmd "${log_mode}" "${run_iqtree_cmd}"
      eval "${run_iqtree_cmd} > /dev/null 2>&1" 
    fi
    if [ ! -s "${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/IQ-TREE/IQ-TREE_${prefix}_${ortho_method_dir}.treefile" ]; then
      stage_error "Fail to run IQ-TREE." 
      stage_error "HybSuite exits." 
      stage_blank_main ""
      exit 1
    else 
      stage_info_main "Successfully constructing the ${ortho_mode_dir} concatenation-based tree (IQ-TREE)."
    fi
    cd "${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/IQ-TREE/"
    ##01-4 reroot the tree via phykit
    if [ "${found_outgroup}" = "1" ]; then
      stage_info "${log_mode}" "Use PhyKit to reroot the tree (IQTREE)..." 
      stage_cmd "${log_mode}" "phykit root_tree ${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/IQ-TREE/IQ-TREE_${prefix}_${ortho_method_dir}.treefile -r ${output_dir}/00-logs_and_checklists/checklists/Outgroup.txt -o ${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/IQ-TREE/IQ-TREE_rr_${prefix}_${ortho_method_dir}.tre"
      phykit root_tree \
      "${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/IQ-TREE/IQ-TREE_${prefix}_${ortho_method_dir}.treefile" \
      -r "${output_dir}/00-logs_and_checklists/checklists/Outgroup.txt" \
      -o "${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/IQ-TREE/IQ-TREE_rr_${prefix}_${ortho_method_dir}.tre" > /dev/null 2>&1
      
      if [ ! -s "${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/IQ-TREE/IQ-TREE_rr_${prefix}_${ortho_method_dir}.tre" ]; then
        stage_error "Fail to reroot the tree: ${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/IQ-TREE/IQ-TREE_${prefix}_${ortho_method_dir}.treefile." 
        stage_error "Please check your alignments and trees produced by IQ-TREE." 
        stage_blank_main ""
      else
        stage_info "${log_mode}" "Successfully rerooting the ${ortho_mode_dir} concatenation-based tree (IQ-TREE)."  
        stage_info_main "Now moving on to the next step..." 
        stage_blank_main "" 
      fi
    else
      stage_info_main "No outgroup name is provided. The tree will not be rerooted."
    fi
  }

  run_raxml() {
    local ortho_method="$1"
    
    if [ -d "${output_dir}/07-Concatenation-based_trees/${ortho_method}/RAxML" ]; then
      rm -rf "${output_dir}/07-Concatenation-based_trees/${ortho_method}/RAxML"
    fi
    stage_info_main "Optional step: Constructing concatenation-based trees for "${ortho_method}" supermatrix via RAxML"
    mkdir -p "${output_dir}/07-Concatenation-based_trees/${ortho_method}/RAxML"
    cd "${output_dir}/05-Supermatrix/${ortho_method}"
    define_threads "raxml"
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      if [ "${ortho_method}" = "1to1" ]; then
        ortho_method="one_to_one"
        ortho_method_dir="1to1"
      else
        ortho_method_dir="${ortho_method}"
      fi
      var_name="${ortho_method}_raxmlHPC_mtest"
      eval "raxmlHPC_cmd=\$$var_name"
      run_raxmlHPC_cmd="${raxmlHPC_cmd} -f a -T ${nt_raxml} -p 12345 -x 67890 -# ${raxml_bb} -n ${prefix}_${ortho_method_dir}.tre -w ${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML"
      if [ "${raxml_constraint_tree}" != "_____" ]; then
        run_raxmlHPC_cmd="${run_raxmlHPC_cmd} -g ${raxml_constraint_tree}"
      fi
      stage_cmd "${log_mode}" "${run_raxmlHPC_cmd}"
      eval "${run_raxmlHPC_cmd} > /dev/null 2>&1"
    else
      run_raxmlHPC_cmd="raxmlHPC-PTHREADS -s ${output_dir}/05-Supermatrix/${ortho_method_dir}/${prefix}_${ortho_method_dir}.fasta -m ${raxml_m} -f a -T ${nt_raxml} -p 12345 -x 67890 -# ${raxml_bb} -n ${prefix}_${ortho_method_dir}.tre -w ${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML"
      if [ "${raxml_constraint_tree}" != "_____" ]; then
        run_raxmlHPC_cmd="${run_raxmlHPC_cmd} -g ${raxml_constraint_tree}"
      fi
      stage_cmd "${log_mode}" "${run_raxmlHPC_cmd}"
      eval "${run_raxmlHPC_cmd} > /dev/null 2>&1"
    fi
    if [ ! -s "${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML/RAxML_bestTree.${prefix}_${ortho_method_dir}.tre" ]; then
      stage_info_main "Fail to run RAxML." 
      stage_info_main "HybSuite exits." 
      stage_blank_main "" 
      exit 1
    else 
      stage_info_main "Successfully constructing the ${ortho_mode_dir} concatenation-based tree (RAxML)."
    fi
    ##02-3 reroot the tree via phykit
    if [ "${found_outgroup}" = "1" ]; then
      cd "${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML/"
      # Run phykit to reroot the tree
      stage_info "${log_mode}" "Use PhyKit to reroot the tree (RAxML)..." 
      stage_cmd "${log_mode}" "phykit root_tree ${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML/RAxML_bipartitions.${prefix}_${ortho_method_dir}.tre -r ${output_dir}/00-logs_and_checklists/checklists/Outgroup.txt -o ${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML/RAxML_rr_${prefix}_${ortho_method_dir}.tre"
      phykit root_tree "${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML/RAxML_bipartitions.${prefix}_${ortho_method_dir}.tre" \
      -r ${output_dir}/00-logs_and_checklists/checklists/Outgroup.txt \
      -o "${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML/RAxML_rr_${prefix}_${ortho_method_dir}.tre" > /dev/null 2>&1
      # Check if the user ran phykit successfully
      if [ ! -s "${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML/RAxML_rr_${prefix}_${ortho_method_dir}.tre" ]; then
        stage_error "${log_mode}" "Fail to reroot the tree: ${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML/RAxML_bipartitions.${prefix}_${ortho_method_dir}.tre." 
        stage_error "${log_mode}" "Please check your alignments and trees produced by RAxML." 
        stage_blank "${log_mode}" ""
      else
        stage_info "${log_mode}" "Successfully rerooting the ${ortho_mode} concatenation-based tree (RAxML)." 
        stage_info_main "Successfully finishing running RAxML for ${ortho_method_dir} supermatrix..." 
        stage_info_main "Now moving on to the next step..."
        stage_blank_main ""
      fi
    else
      stage_info_main "No outgroup name is provided. The tree will not be rerooted."
    fi
  }

  run_raxml_ng() {
    local ortho_method="$1"
    
    if [ -d "${output_dir}/07-Concatenation-based_trees/${ortho_method}/RAxML-NG" ]; then
      rm -rf "${output_dir}/07-Concatenation-based_trees/${ortho_method}/RAxML-NG"
    fi
    stage_info_main "Optional step: Constructing concatenation-based trees for "${ortho_method}" supermatrix via RAxMl-NG"
    ##01 Set the directory
    mkdir -p "${output_dir}/07-Concatenation-based_trees/${ortho_method}/RAxML-NG"
    cd "${output_dir}/05-Supermatrix/${ortho_method}"
    ##02 Run RAxML-NG
    stage_info_main "Running RAxML-NG for ${ortho_method} alignments..." 
    define_threads "raxml_ng"
    ##02.1 If the user sets the rng_force parameter to TRUE, the Ignore Thread warning feature is enabled (add the --force perf_threads parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      if [ "${ortho_method}" = "1to1" ]; then
        ortho_method="one_to_one"
        ortho_method_dir="1to1"
      else
        ortho_method_dir="${ortho_method}"
      fi
      var_name="${ortho_method}_raxml_ng_mtest"
      eval "raxml_ng_cmd=\$$var_name"
      raxml_ng_cmd="${raxml_ng_cmd} --all --threads ${nt_raxml_ng} --prefix ${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML-NG/RAxML-NG_${prefix}_${ortho_method_dir} --bs-trees ${rng_bs_trees}"
      if [ "${rng_force}" = "TRUE" ]; then
        raxml_ng_cmd="${raxml_ng_cmd} --force perf_threads"
      fi
      if [ -s "${rng_constraint_tree}" ]; then
        raxml_ng_cmd="${raxml_ng_cmd} --tree-constraint ${rng_constraint_tree}"
      fi
      stage_cmd "${log_mode}" "${raxml_ng_cmd}"
      eval "${raxml_ng_cmd} > /dev/null 2>&1"
    else
      raxml-ng --parse --msa ${output_dir}/05-Supermatrix/${ortho_method_dir}/HybSuite_${ortho_method_dir}.fasta \
        --model GTR+G \
        --prefix ${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
      Model=$(grep "Model:" ${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
      raxml_ng_cmd="raxml-ng --all --msa ${output_dir}/05-Supermatrix/${ortho_method_dir}/${prefix}_${ortho_method_dir}.fasta --model ${Model} --threads ${nt_raxml_ng} --prefix ${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML-NG/RAxML-NG_${prefix}_${ortho_method_dir} --bs-trees ${rng_bs_trees}"
      if [ "${rng_force}" = "TRUE" ]; then
        raxml_ng_cmd="${raxml_ng_cmd} --force perf_threads"
      fi
      if [ -s "${rng_constraint_tree}" ]; then
        raxml_ng_cmd="${raxml_ng_cmd} --tree-constraint ${rng_constraint_tree}"
      fi
      stage_cmd "${log_mode}" "${raxml_ng_cmd}"
      eval "${raxml_ng_cmd} > /dev/null 2>&1"
    fi

    ##02.2 Check if the user ran RAxML-NG successfully
    if [ ! -s "${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML-NG/RAxML-NG_${prefix}_${ortho_method_dir}.raxml.support" ]; then
      stage_error "Fail to run RAxML-NG."
      stage_error "HybSuite exits."
      stage_blank_main "" 
      exit 1
    else 
      stage_info_main "Successfully constructing the ${ortho_mode_dir} concatenation-based tree (RAxML-NG)." 
    fi
    ##03 reroot the tree via phykit
    if [ "${found_outgroup}" = "1" ]; then
      cd "${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML-NG/"
      stage_info "${log_mode}" "Use phykit to reroot the tree (RAxML-NG)..."
      stage_cmd "${log_mode}" "phykit root_tree ${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML-NG/RAxML-NG_${prefix}_${ortho_method_dir}.raxml.support -r ${output_dir}/00-logs_and_checklists/checklists/Outgroup.txt -o ${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML-NG/RAxML-NG_rr_${prefix}_${ortho_method_dir}.tre"
      phykit root_tree "${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML-NG/RAxML-NG_${prefix}_${ortho_method_dir}.raxml.support" \
      -r "${output_dir}/00-logs_and_checklists/checklists/Outgroup.txt" \
      -o "${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML-NG/RAxML-NG_rr_${prefix}_${ortho_method_dir}.tre" > /dev/null 2>&1
    
      if [ ! -s "${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML-NG/RAxML-NG_rr_${prefix}_${ortho_method_dir}.tre" ]; then
        stage_error "Fail to reroot the tree: ${output_dir}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML-NG/RAxML-NG_${prefix}_${ortho_method_dir}.tre." 
        stage_error "Please check your alignments and trees produced by RAxML-NG." 
        stage_blank_main ""
      else
          stage_info_main "Successfully rerooting the ${ortho_mode_dir} concatenation-based tree (RAxML-NG)."
          stage_info_main "Now moving on to the next step..."
          stage_blank_main "" 
      fi
    else
      stage_info_main "No outgroup name is provided. The tree will not be rerooted."
    fi
  }

  if [ "${HRS}" = "TRUE" ]; then
    if [ "${run_iqtree}" = "TRUE" ]; then
      run_iqtree "HRS"
    fi
    if [ "${run_raxml}" = "TRUE" ]; then
      run_raxml "HRS"
    fi
    if [ "${run_raxml_ng}" = "TRUE" ]; then
      run_raxml_ng "HRS"
    fi
  fi
  if [ "${RLWP}" = "TRUE" ]; then
    if [ "${run_iqtree}" = "TRUE" ]; then
      run_iqtree "RLWP"
    fi
    if [ "${run_raxml}" = "TRUE" ]; then
      run_raxml "RLWP"
    fi
    if [ "${run_raxml_ng}" = "TRUE" ]; then
      run_raxml_ng "RLWP"
    fi
  fi
  if [ "${LS}" = "TRUE" ]; then
    if [ "${run_iqtree}" = "TRUE" ]; then
      run_iqtree "LS"
    fi
    if [ "${run_raxml}" = "TRUE" ]; then
      run_raxml "LS"
    fi
    if [ "${run_raxml_ng}" = "TRUE" ]; then
      run_raxml_ng "LS"
    fi
  fi
  if [ "${MI}" = "TRUE" ]; then
    if [ "${run_iqtree}" = "TRUE" ]; then
      run_iqtree "MI"
    fi
    if [ "${run_raxml}" = "TRUE" ]; then
      run_raxml "MI"
    fi
    if [ "${run_raxml_ng}" = "TRUE" ]; then
      run_raxml_ng "MI"
    fi
  fi
  if [ "${MO}" = "TRUE" ]; then
    if [ "${run_iqtree}" = "TRUE" ]; then
      run_iqtree "MO"
    fi
    if [ "${run_raxml}" = "TRUE" ]; then
      run_raxml "MO"
    fi
    if [ "${run_raxml_ng}" = "TRUE" ]; then
      run_raxml_ng "MO"
    fi
  fi
  if [ "${RT}" = "TRUE" ]; then
    if [ "${run_iqtree}" = "TRUE" ]; then
      run_iqtree "RT"
    fi
    if [ "${run_raxml}" = "TRUE" ]; then
      run_raxml "RT"
    fi
    if [ "${run_raxml_ng}" = "TRUE" ]; then
      run_raxml_ng "RT"
    fi
  fi
  if [ "${one_to_one}" = "TRUE" ]; then
    if [ "${run_iqtree}" = "TRUE" ]; then
      run_iqtree "1to1"
    fi
    if [ "${run_raxml}" = "TRUE" ]; then
      run_raxml "1to1"
    fi
    if [ "${run_raxml_ng}" = "TRUE" ]; then
      run_raxml_ng "1to1"
    fi
  fi
fi

###################################################################################################
#Stage5-Optional step: Constructing coalescent-based trees #####################################
###################################################################################################
#Preparation
if [ "${run_astral}" = "TRUE" ] || [ "${run_wastral}" = "TRUE" ]; then
  stage_info_main "Optional step: Constructing coalescent-based trees using ASTRAL/wASTRAL."
  
  reroot_and_sort_tree() {
    local input_tree="$1"
    local output_tree="$2"

	  if [ "${found_outgroup}" = "1" ]; then
      stage_cmd "${log_mode}" "phykit root_tree ${input_tree} -r ${output_dir}/00-logs_and_checklists/checklists/Outgroup.txt -o 2_${output_tree}"
      phykit root_tree ${input_tree} -r ${output_dir}/00-logs_and_checklists/checklists/Outgroup.txt -o 2_${output_tree} > /dev/null 2>&1
      nw_order -c d 2_${output_tree} > ${output_tree}
      rm 2_${output_tree} > /dev/null 2>&1
    else
      stage_info_main "No outgroup name is provided. The tree will only be sorted, not rerooted."
      stage_cmd "${log_mode}" "nw_order -c d ${input_tree} > ${output_tre e}"
      nw_order -c d ${input_tree} > ${output_tree}
    fi
  }
  
  run_raxml_sg() {
    local ortho_method="$1"
    local Genename="$2"

    define_threads "raxml"
    mkdir -p ${output_dir}/08-Coalescent-based_trees/${ortho_method}/01-Gene_trees/${Genename}
    stage_cmd "${log_mode}" "raxmlHPC-PTHREADS -f a -T ${nt_raxml} -s ${Genename}.trimmed.aln.fasta -k -x $RANDOM -m GTRGAMMA -p $RANDOM -n ${Genename}.tre -w ${output_dir}/08-Coalescent-based_trees/${ortho_method}/01-Gene_trees/${Genename} -N 100"

    raxmlHPC-PTHREADS -T "${nt_raxml}" -f a \
    	-s ${Genename}.trimmed.aln.fasta \
    	-k -x "$RANDOM" \
    	-m GTRGAMMA \
    	-p "$RANDOM" \
    	-n "${Genename}.tre" \
    	-w "${output_dir}/08-Coalescent-based_trees/${ortho_method}/01-Gene_trees/${Genename}/" \
    	-N 100 > /dev/null 2>&1
  }

  run_astral() {
    local input_combined_tree="$1"
    local output_astral_prefix="$2"

    stage_info_main "Running ASTRAL-Ⅲ ..."
    stage_cmd "${log_mode}" "java -jar ${dependencies_dir}/ASTRAL-master/Astral/astral.5.7.8.jar -i ${input_combined_tree} -o ${output_astral_prefix}.tre 2> ${output_dir}/00-logs_and_checklists/logs/${prefix}_${ortho_method}_ASTRAL.log"
    java -jar ${dependencies_dir}/ASTRAL-master/Astral/astral.5.7.8.jar \
    -i "${input_combined_tree}" \
    -o "${output_astral_prefix}.tre" 2> ${output_dir}/00-logs_and_checklists/logs/ASTRAL_${prefix}_${ortho_method}.log
    if [ -s "${output_astral_prefix}.tre" ]; then
      stage_info_main "Succeed to run ASTRAL-Ⅲ."
    else
      stage_error "Fail to run ASTRAL-Ⅲ."
      stage_blank_main ""
    fi
    # reroot and sort the ASTRAL tree
    reroot_and_sort_tree "${output_astral_prefix}.tre" "${output_astral_prefix}_sorted_rr.tre"
  }



  run_wastral() {
    local input_combined_tree="$1"
    local output_wastral_prefix="$2"
    local gene_list="$3"

    mkdir -p ${output_dir}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree
    cd ${wastral_dir}
    define_threads "wastral"
    # if the number of species is less than 2000, run wastral
    if [ $(wc -l < "${gene_list}") -lt 2000 ]; then
      # 01-run wastral
      stage_cmd "${log_mode}" "bin/wastral --mode ${wastral_mode} -t ${nt_wastral} -r ${wastral_R} -s ${wastral_S} -o ${output_wastral_prefix}.tre ${input_combined_tree} 2> ${output_dir}/00-logs_and_checklists/logs/wASTRAL_${prefix}_${ortho_method}.log"
      bin/wastral --mode "${wastral_mode}" -t "${nt_wastral}" \
      -r "${wastral_R}" -s "${wastral_S}" \
      -o "${output_wastral_prefix}.tre" \
      "${input_combined_tree}" 2> "${output_dir}/00-logs_and_checklists/logs/wASTRAL_${prefix}_${ortho_method}.log"
      # 02-Add bootstrap value by wastral
      stage_cmd "${log_mode}" "bin/wastral -S ${output_wastral_prefix}.tre > ${output_wastral_prefix}_bootstrap.tre"
      bin/wastral -S "${output_wastral_prefix}.tre" > "${output_wastral_prefix}_bootstrap.tre"
    # if the number of species is more than 2000, run wastral
    else
      # 01-run wastral
      stage_cmd "${log_mode}" "bin/wastral_precise --mode ${wastral_mode} -t ${nt_wastral} -r ${wastral_R} -s ${wastral_S} -o ${output_wastral_prefix}.tre ${input_combined_tree} 2> ${output_dir}/00-logs_and_checklists/logs/wASTRAL_${prefix}_${ortho_method}.log"
      bin/wastral_precise --mode ${wastral_mode} -t ${nt_wastral} \
      -r ${wastral_R} -s ${wastral_S} \
      -o "${output_wastral_prefix}.tre" \
      "${input_combined_tree}" 2> ${output_dir}/00-logs_and_checklists/logs/wASTRAL_${prefix}_${ortho_method}.log
      # 02-Add bootstrap value by wastral
      stage_cmd "${log_mode}" "bin/wastral_precise -S ${output_wastral_prefix}.tre > ${output_wastral_prefix}_bootstrap.tre"
      bin/wastral_precise -S "${output_wastral_prefix}.tre" > "${output_wastral_prefix}_bootstrap.tre"
    fi
      
    if [ -s "${output_dir}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/wASTRAL_bootstrap_${prefix}_${ortho_method}.tre" ]; then
      stage_info_main "Succeed to run wASTRAL"
    else
      stage_error "Fail to run wASTRAL."
      stage_blank_main ""
    fi
    # reroot and sort the wASTRAL tree
    reroot_and_sort_tree "${output_wastral_prefix}_bootstrap.tre" "${output_wastral_prefix}_bootstrap_sorted_rr.tre"
  }

  calculate_branch_length() {
    local supermatrix_name="$1"
    local bp_output_dir="$2"
    local bp_output_dir2="$3"
    local alignments_list="$4"
    local suffix="$5"
    
    mkdir -p "${bp_output_dir}" "${bp_output_dir2}"
    # Construct the supermatrix for recalculating branch length
    while IFS= read -r line || [ -n "${line}" ]; do
      cp "${output_dir}/04-Alignments/${ortho_method}/${line}" "${bp_output_dir}"
    done < "${alignments_list}"
    define_threads "amas"
    stage_cmd "${log_mode}" "AMAS.py concat -f fasta -d dna -i "${bp_output_dir}"/*.trimmed.aln.fasta -p "${bp_output_dir2}/partition_recalculating_bl.txt" -t "${bp_output_dir2}/2_${supermatrix_name}" -y raxml -c ${nt_amas}"
    AMAS.py concat \
    -f fasta \
    -d dna \
    -i "${bp_output_dir}"/*.trimmed.aln.fasta \
    -p "${bp_output_dir2}/partition_recalculating_bl.txt" \
    -t "${bp_output_dir2}/2_${supermatrix_name}" \
    -y raxml \
    -c "${nt_amas}" > /dev/null 2>&1
    stage_cmd "${log_mode}" "awk '/^>/ {print $0; next} {gsub(/\?/, "-"); print}' ${bp_output_dir2}/2_${supermatrix_name} > ${bp_output_dir2}/${supermatrix_name}"
    awk '/^>/ {print $0; next} {gsub(/\?/, "-"); print}' "${bp_output_dir2}/2_${supermatrix_name}" > "${bp_output_dir2}/${supermatrix_name}"
    rm "${bp_output_dir2}/2_${supermatrix_name}"
    rm "${bp_output_dir}"/*.trimmed.aln.fasta

    # run RAxML
    stage_cmd "${log_mode}" "raxmlHPC -f e -t ${output_dir}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/${suffix}_${prefix}_${ortho_method}.tre -m GTRGAMMA -s ${bp_output_dir2}/${supermatrix_name} -n ${suffix}_${prefix}_${ortho_method}_bl.tre -w ${bp_output_dir2} -N 100"
    raxmlHPC -f e -t ${output_dir}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/${suffix}_${prefix}_${ortho_method}.tre -m GTRGAMMA \
    -s "${bp_output_dir2}/${supermatrix_name}" \
    -n "${suffix}_${prefix}_${ortho_method}_bl.tre" \
    -w "${bp_output_dir2}" \
    -N 100 > /dev/null 2>&1
    cd "${bp_output_dir2}"
    # reroot the recalculated bl ASTRAL tree
    reroot_and_sort_tree "${bp_output_dir2}/RAxML_result.${suffix}_${prefix}_${ortho_method}_bl.tre" "${bp_output_dir2}/${suffix}_${prefix}_${ortho_method}_sorted_bl_rr.tre"
    if [ -s "${bp_output_dir2}/RAxML_result.${suffix}_${prefix}_${ortho_method}_bl.tre" ]; then
      stage_info_main "Finish"
    else
      stage_error "Fail to calculate the branch length for ASTRAL tree via RAxML."
      stage_blank_main ""
    fi
  }

  calculate_branch_length_sortadate() {
    local supermatrix_name="$1"
    local bp_output_dir="$2"
    local alignments_list="$3"
    local suffix="$4"
    
    # Construct the supermatrix for recalculating branch length
    while IFS= read -r line || [ -n "${line}" ]; do
      cp "${output_dir}/04-Alignments/${ortho_method}/${line}" "${bp_output_dir}"
    done < "${alignments_list}"
    stage_cmd "${log_mode}" "AMAS.py concat -f fasta -d dna -i ${bp_output_dir}/*.trimmed.aln.fasta -p ${bp_output_dir}/partition_recalculating_bl.txt -t ${bp_output_dir}/2${supermatrix_name} -y raxml"
    AMAS.py concat \
    -f fasta \
    -d dna \
    -i "${bp_output_dir}"/*.trimmed.aln.fasta \
    -p "${bp_output_dir}/partition_recalculating_bl.txt" \
    -t "${bp_output_dir}/2_${supermatrix_name}" \
    -y raxml > /dev/null 2>&1
    stage_cmd "${log_mode}" "awk '/^>/ {print $0; next} {gsub(/\?/, "-"); print}' ${bp_output_dir}/2_${supermatrix_name} > ${bp_output_dir}/${supermatrix_name}"
    awk '/^>/ {print $0; next} {gsub(/\?/, "-"); print}' "${bp_output_dir}/2_${supermatrix_name}" > "${bp_output_dir}/${supermatrix_name}"
    rm "${bp_output_dir}/2_${supermatrix_name}"
    rm "${bp_output_dir}"/*.trimmed.aln.fasta

    # run RAxML
    stage_cmd "${log_mode}" "raxmlHPC -f e -t ${output_dir}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/${suffix}_${prefix}_${ortho_method}.tre -m GTRGAMMA -s ${bp_output_dir}/${supermatrix_name} -n ${suffix}_sortadate_${prefix}_${ortho_method}_bl.tre -w ${bp_output_dir} -N 100"
    raxmlHPC -f e -t ${output_dir}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/${suffix}_${prefix}_${ortho_method}.tre -m GTRGAMMA \
    -s "${bp_output_dir}/${supermatrix_name}" \
    -n "${suffix}_sortadate_${prefix}_${ortho_method}_bl.tre" \
    -w "${bp_output_dir}" \
    -N 100 > /dev/null 2>&1
    cd "${bp_output_dir}"
    # reroot the recalculated bl ASTRAL tree
    reroot_and_sort_tree "${bp_output_dir}/RAxML_result.${suffix}_sortadate_${prefix}_${ortho_method}_bl.tre" "${bp_output_dir}/${suffix}_sortadate_${prefix}_${ortho_method}_sorted_bl_rr.tre"
    if [ -s "${bp_output_dir}/RAxML_result.${suffix}_sortadate_${prefix}_${ortho_method}_bl.tre" ]; then
      stage_info_main "Succeed to run SortaDate for ASTRAL results and recalculate the branch length."
    else
      stage_error "Fail to run SortaDate for wASTRAL results and recalculate the branch length."
      stage_blank_main ""
    fi
  }


  run_phyparts_piecharts() {
    local ortho_method="$1"
    
    if [ -d "${output_dir}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts" ]; then
      rm -rf "${output_dir}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts"
    fi
    mkdir -p "${output_dir}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts"
    cd "${output_dir}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts"
    # ASTRAL ############
    if [ "${run_astral}" = "TRUE" ]; then
      stage_info_main "Running PhyPartsPieCharts for ${ortho_method} coalescent-based tree (ASTRAL) ..."
      stage_cmd "${log_mode}" "java -jar ${dependencies_dir}/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d ${output_dir}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees -m ${output_dir}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/ASTRAL_${prefix}_${ortho_method}_sorted_rr.tre -o ${output_dir}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts/ASTRAL_PhyParts"
      java -jar ${dependencies_dir}/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar \
      -a 1 -v -d ${output_dir}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees \
      -m ${output_dir}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/ASTRAL_${prefix}_${ortho_method}_sorted_rr.tre \
      -o ${output_dir}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts/ASTRAL_PhyParts > /dev/null 2>&1
            
      phyparts_number=$(find ${output_dir}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees -type f -name "*_rr.tre" | wc -l)
      python3 ${script_dir}/modified_phypartspiecharts.py \
      ${output_dir}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/ASTRAL_${prefix}_${ortho_method}_sorted_rr.tre \
      ASTRAL_PhyParts "${phyparts_number}" \
      --output "${output_dir}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts/ASTRAL_phypartspiecharts_${prefix}_${ortho_method}.svg" \
      --to_csv \
      --tree_type "${phypartspiecharts_tree_type}" \
      --show_num_mode "${phypartspiecharts_num_mode}" \
      --stat "${output_dir}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts/ASTRAL_phypartspiecharts_${prefix}_${ortho_method}.tsv" \
      --threads "${nt}" > /dev/null 2>&1
    
      stage_cmd "${log_mode}" "python3 ${script_dir}/modified_phypartspiecharts.py ${output_dir}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/ASTRAL_${prefix}_${ortho_method}_sorted_rr.tre ASTRAL_PhyParts ${phyparts_number} --output ${output_dir}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts/ASTRAL_phypartspiecharts_${prefix}_${ortho_method}.svg --to_csv --tree_type ${phypartspiecharts_tree_type} --show_num_mode ${phypartspiecharts_num_mode} --stat ${output_dir}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts/ASTRAL_phypartspiecharts_${prefix}_${ortho_method}.tsv --threads ${nt}"
      if [ -s "${output_dir}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts/ASTRAL_phypartspiecharts_${prefix}_${ortho_method}.svg" ]; then
        stage_info_main "Finish"
      else
        stage_error "Fail to run modified_phypartspiecharts.py."
        stage_blank_main ""
      fi
    fi
    # wASTRAL #################
    if [ "${run_wastral}" = "TRUE" ]; then
      stage_info_main "Running PhyPartsPieCharts for ${ortho_method} coalescent-based tree (wASTRAL) ..."
      stage_cmd "${log_mode}" "java -jar ${dependencies_dir}/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d ${output_dir}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees -m ${output_dir}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/wASTRAL_${prefix}_${ortho_method}_sorted_rr.tre -o ${output_dir}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts/wASTRAL_PhyParts"
      java -jar ${dependencies_dir}/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar \
      -a 1 -v -d ${output_dir}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees \
      -m ${output_dir}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/wASTRAL_${prefix}_${ortho_method}_sorted_rr.tre \
      -o ${output_dir}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts/wASTRAL_PhyParts &> /dev/null
            
      phyparts_number=$(find ${output_dir}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees -type f -name "*_rr.tre" | wc -l)
      python3 ${script_dir}/modified_phypartspiecharts.py \
      ${output_dir}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/wASTRAL_${prefix}_${ortho_method}_sorted_rr.tre \
      wASTRAL_PhyParts ${phyparts_number} \
      --output "${output_dir}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts/wASTRAL_phypartspiecharts_${prefix}_${ortho_method}.svg" \
      --to_csv \
      --tree_type "${phypartspiecharts_tree_type}" \
      --show_num_mode "${phypartspiecharts_num_mode}" \
      --stat "${output_dir}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts/wASTRAL_phypartspiecharts_${prefix}_${ortho_method}.tsv" \
      --threads "${nt}" > /dev/null 2>&1
  
      stage_cmd "${log_mode}" "python3 ${script_dir}/modified_phypartspiecharts.py ${output_dir}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/wASTRAL_${prefix}_${ortho_method}_sorted_rr.tre wASTRAL_PhyParts ${phyparts_number} --output ${output_dir}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts/wASTRAL_phypartspiecharts_${prefix}_${ortho_method}.svg --to_csv --tree_type ${phypartspiecharts_tree_type} --show_num_mode ${phypartspiecharts_num_mode} --stat ${output_dir}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts/wASTRAL_phypartspiecharts_${prefix}_${ortho_method}.tsv --threads ${nt}"
      if [ -s "${output_dir}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts/wASTRAL_phypartspiecharts_${prefix}_${ortho_method}.svg" ]; then
        stage_info_main "Finish"
      else
        stage_error "Fail to run modified_phypartspiecharts.py."
        stage_blank_main ""
      fi
    fi
  }

  run_sortadate(){
    local final_ASTRAL_rr_tree="${output_dir}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/ASTRAL_${prefix}_${ortho_method}_sorted_rr.tre"
    local final_wASTRAL_rr_tree="${output_dir}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/wASTRAL_${prefix}_${ortho_method}_bootstrap_sorted_rr.tre"
    local input_gene_rr_trees="${output_dir}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees/"
    local sortadate_results_dir_astral="${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_ASTRAL_results"
    local sortadate_results_dir_wastral="${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_wASTRAL_results"

    stage_info_main "Optional step: Running SortaDate to select clock-like genes to recalculate the branch length of ASTRAL and wASTRAL trees"

    if [ -d "${sortadate_results_dir_astral}" ]; then
      rm -rf "${sortadate_results_dir_astral}"
      mkdir -p "${sortadate_results_dir_astral}"
    fi
    if [ -d "${sortadate_results_dir_wastral}" ]; then
      rm -rf "${sortadate_results_dir_wastral}"
      mkdir -p "${sortadate_results_dir_wastral}"
    fi

    if [ "${run_astral}" = "TRUE" ]; then
      mkdir -p "${sortadate_results_dir_astral}"
      # sortadate step 01
      stage_cmd "${log_mode}" "python ${dependencies_dir}/Sortadate/get_var_length.py ${input_gene_rr_trees} --flend _rr.tre --outf ${sortadate_results_dir_astral}/step1_result.txt --outg ${og_params}"
      python "${dependencies_dir}/Sortadate/get_var_length.py" "${input_gene_rr_trees}" \
      --flend ".tre" \
      --outf "${sortadate_results_dir_astral}/step1_result.txt" \
      --outg "${og_params}" > /dev/null 2>&1
      
      # sortadate step 02
      stage_cmd "${log_mode}" "python ${dependencies_dir}/Sortadate/get_bp_genetrees.py ${input_gene_rr_trees} ${final_ASTRAL_rr_tree} --flend _rr.tre --outf ${sortadate_results_dir_astral}/step1_result.txt"
      python "${dependencies_dir}/Sortadate/get_bp_genetrees.py" "${input_gene_rr_trees}" "${final_ASTRAL_rr_tree}" \
      --flend ".tre" \
      --outf "${sortadate_results_dir_astral}/step2_result.txt" > /dev/null 2>&1

      # sortadate step 03
      stage_cmd "${log_mode}" "python ${dependencies_dir}/Sortadate/combine_results.py ${sortadate_results_dir_astral}/step1_result.txt ${sortadate_results_dir_astral}/step2_result.txt --outf ${sortadate_results_dir_astral}/step3_result.txt"
      python "${dependencies_dir}/Sortadate/combine_results.py" "${sortadate_results_dir_astral}/step1_result.txt" "${sortadate_results_dir_astral}/step2_result.txt" \
      --outf "${sortadate_results_dir_astral}/step3_result.txt" > /dev/null 2>&1

      # sortadate step 04
      stage_cmd "${log_mode}" "python ${dependencies_dir}/Sortadate/get_good_genes.py ${sortadate_results_dir_astral}/step3_result.txt --max ${sortadate_genes_num} --outf ${sortadate_results_dir_astral}/Selected_sortadate_alignments_for_dating_info.txt"
      python "${dependencies_dir}/Sortadate/get_good_genes.py" "${sortadate_results_dir_astral}/step3_result.txt" \
      --max "${sortadate_genes_num}" \
      --outf "${sortadate_results_dir_astral}/Selected_sortadate_alignments_for_dating_info.txt" > /dev/null 2>&1
      rm "${sortadate_results_dir_astral}"/step*
      sed '1d' "${sortadate_results_dir_astral}/Selected_sortadate_alignments_for_dating_info.txt" | cut -f1 -d' ' | sed 's/_rr\.tre$/.trimmed.aln.fasta/g' > "${sortadate_results_dir_astral}/Selected_sortadate_alignments_for_dating_list.txt"
    fi
    if [ "${run_wastral}" = "TRUE" ]; then
      mkdir -p "${sortadate_results_dir_wastral}"
      # sortadate step 01
      stage_cmd "${log_mode}" "python ${dependencies_dir}/Sortadate/get_var_length.py ${input_gene_rr_trees} --flend .tre --outf ${sortadate_results_dir_wastral}/step1_result.txt --outg ${og_params}"
      python "${dependencies_dir}/Sortadate/get_var_length.py" "${input_gene_rr_trees}" \
      --flend ".tre" \
      --outf "${sortadate_results_dir_wastral}/step1_result.txt" \
      --outg "${og_params}" > /dev/null 2>&1

      # sortadate step 02
      stage_cmd "${log_mode}" "python ${dependencies_dir}/Sortadate/get_bp_genetrees.py ${input_gene_rr_trees} ${final_wASTRAL_rr_tree} --flend .tre --outf ${sortadate_results_dir_wastral}/step1_result.txt"
      python "${dependencies_dir}/Sortadate/get_bp_genetrees.py" "${input_gene_rr_trees}" "${final_wASTRAL_rr_tree}" \
      --flend ".tre" \
      --outf "${sortadate_results_dir_wastral}/step2_result.txt" > /dev/null 2>&1

      # sortadate step 03
      stage_cmd "${log_mode}" "python ${dependencies_dir}/Sortadate/combine_results.py ${sortadate_results_dir_wastral}/step1_result.txt ${sortadate_results_dir_wastral}/step2_result.txt --outf ${sortadate_results_dir_wastral}/step3_result.txt"
      python "${dependencies_dir}/Sortadate/combine_results.py" "${sortadate_results_dir_wastral}/step1_result.txt" "${sortadate_results_dir_wastral}/step2_result.txt" \
      --outf "${sortadate_results_dir_wastral}/step3_result.txt" > /dev/null 2>&1

      # sortadate step 04
      stage_cmd "${log_mode}" "python ${dependencies_dir}/Sortadate/get_good_genes.py ${sortadate_results_dir_wastral}/step3_result.txt --max ${sortadate_genes_num} --outf ${sortadate_results_dir_wastral}/Selected_wASTRAL_alignments_for_dating_info.txt"
      python "${dependencies_dir}/Sortadate/get_good_genes.py" "${sortadate_results_dir_wastral}/step3_result.txt" \
      --max "${sortadate_genes_num}" \
      --outf "${sortadate_results_dir_wastral}/Selected_wASTRAL_alignments_for_dating_info.txt" > /dev/null 2>&1
      rm "${sortadate_results_dir_wastral}"/step*
      sed '1d' "${sortadate_results_dir_wastral}/Selected_wASTRAL_alignments_for_dating_info.txt" | cut -f1 -d' ' | sed 's/_rr\.tre$/.trimmed.aln.fasta/g' > "${sortadate_results_dir_wastral}/Selected_sortadate_alignments_for_dating_list.txt"
    fi

  }

  run_coalescent_trees() {
    local ortho_method="$1"
    
    stage_info_main "Infering ${ortho_method} coalescent-based tree ..."
    #############################################
    #01：Constructing single gene trees
    #############################################
    if [ "${skip_genetree_for_coalescent}" != "TRUE" ]; then
      if [ -d "${output_dir}/08-Coalescent-based_trees/${ortho_method}" ]; then
        rm -rf "${output_dir}/08-Coalescent-based_trees/${ortho_method}"
      fi
      mkdir -p ${output_dir}/08-Coalescent-based_trees/${ortho_method}/01-Gene_trees
      > "${output_dir}/08-Coalescent-based_trees/${ortho_method}/Removed_alignments_with_less_than_5_seqs_list.txt"
      > "${output_dir}/08-Coalescent-based_trees/${ortho_method}/Final_alignments_for_coalscent_list.txt"
      cd ${output_dir}/04-Alignments/${ortho_method}/
      define_threads "astral"
      for Gene in *.trimmed.aln.fasta; do
        if [ $(grep -c '^>' "${Gene}") -lt 5 ]; then
          echo "$Gene" >> "${output_dir}/08-Coalescent-based_trees/${ortho_method}/Removed_alignments_with_less_than_5_seqs_list.txt"
        else
          echo "$Gene" >> "${output_dir}/08-Coalescent-based_trees/${ortho_method}/Final_alignments_for_coalscent_list.txt"
        fi
      done
      
      total_sps=$(awk 'NF' "${output_dir}/08-Coalescent-based_trees/${ortho_method}/Final_alignments_for_coalscent_list.txt" | wc -l)
      init_parallel_env "$work_dir" "$total_sps" "$process" "${output_dir}/08-Coalescent-based_trees/${ortho_method}/Final_alignments_for_coalscent_list.txt" || exit 1
      stage_info_main "Step1: Constructing single gene trees for ${ortho_method} alignments"
      stage_info_main "====>> Constructing single gene trees for ${ortho_method} alignments (${process} in parallel) ====>>"
      
      while IFS= read -r line || [ -n "$line" ]; do
        Genename=$(basename "$line" .trimmed.aln.fasta)
        if [ "${process}" != "all" ]; then
          read -u1000
        fi
        {
          update_start_count "$line" "$stage_logfile"
          remove_n "${line}"
          run_raxml_sg "${ortho_method}" "${Genename}"
          if [ ! -s "${output_dir}/08-Coalescent-based_trees/${ortho_method}/01-Gene_trees/${Genename}/RAxML_bestTree.${Genename}.tre" ]; then
            record_failed_sample "$line"
          else
            update_finish_count "$Genename" "$stage_logfile"
          fi
          if [ "${process}" != "all" ]; then
              echo >&1000
          fi
        } &
      done < "${output_dir}/08-Coalescent-based_trees/${ortho_method}/Final_alignments_for_coalscent_list.txt"
      wait
      echo
      if [ "${log_mode}" = "full" ]; then
        display_process_log "$stage_logfile" "stage5" "Failed to construct single gene trees for ${ortho_method} alignments:"
      fi
      stage_blank "${log_mode}" ""
    fi

    #####################################################
    #02：Reroot the gene trees via mad(R) or newick_utils
    #####################################################
    stage_info_main "Step2: Rerooting single-gene trees via mad(R) and newick_utilis"
    mkdir -p "${output_dir}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees"
    total_sps=$(awk 'NF' "${output_dir}/08-Coalescent-based_trees/${ortho_method}/Final_alignments_for_coalscent_list.txt" | wc -l)
    # Initialize parallel environment
    init_parallel_env "$work_dir" "$total_sps" "$process" "${output_dir}/08-Coalescent-based_trees/${ortho_method}/Final_alignments_for_coalscent_list.txt" || exit 1
    stage_info_main "====>> Rerooting single-gene trees via mad(R) and newick_utilis (${process} in parallel) ====>>"
    if [ "${found_outgroup}" = "1" ]; then
      while IFS= read -r line || [ -n "$line" ]; do
        if [ "${process}" != "all" ]; then
          read -u1000
        fi
        {
        Genename=$(basename "$line" .trimmed.aln.fasta)
        update_start_count "$Genename" "$stage_logfile"
        # Dynamically build the parameters of the nw reroot command
        cmd="Rscript ${script_dir}/Reroot_genetree.R ${Genename} ${output_dir}/08-Coalescent-based_trees/${ortho_method}/01-Gene_trees ${output_dir}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees ${output_dir}/00-logs_and_checklists/checklists/Outgroup.txt"
        stage_cmd "${log_mode}" "${cmd}"
        eval "${cmd}" > /dev/null 2>&1
        if [ ! -s "${output_dir}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees/${Genename}_rr.tre" ]; then
          record_failed_sample "$Genename"
        else
          update_finish_count "$Genename" "$stage_logfile"
          echo ${Genename} >> "${output_dir}/08-Coalescent-based_trees/${ortho_method}/Final_genes_for_coalscent_list.txt"
        fi
        if [ "${process}" != "all" ]; then
            echo >&1000
        fi
      } &
      done < "${output_dir}/08-Coalescent-based_trees/${ortho_method}/Final_alignments_for_coalscent_list.txt"
      wait
      echo
      if [ "${log_mode}" = "full" ]; then
        display_process_log "$stage_logfile" "stage5" "Failed to reroot single-gene trees for ${ortho_method} alignments:"
      fi
      stage_blank "${log_mode}" ""
    else
      stage_info_main "No outgroup found, skipping rerooting step"
    fi

    #############################################
    #03：Merge all tree files ###################
    #############################################
    stage_info_main "Step3: Merge all tree files"
    mkdir -p ${output_dir}/08-Coalescent-based_trees/${ortho_method}/03-Combined_gene_trees
    > ${output_dir}/08-Coalescent-based_trees/${ortho_method}/03-Combined_gene_trees/${prefix}_${ortho_method}_combined.tre
    if [ "${found_outgroup}" = "1" ]; then
      awk '1' ${output_dir}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees/*_rr.tre >> ${output_dir}/08-Coalescent-based_trees/${ortho_method}/03-Combined_gene_trees/${prefix}_${ortho_method}_combined.tre
    else
      awk '1' ${output_dir}/08-Coalescent-based_trees/${ortho_method}/01-Gene_trees/*.tre >> ${output_dir}/08-Coalescent-based_trees/${ortho_method}/03-Combined_gene_trees/${prefix}_${ortho_method}_combined.tre
    fi
    cd "${output_dir}/08-Coalescent-based_trees/${ortho_method}/03-Combined_gene_trees"

    #############################################
    #04：Run ASTRAL or wASTRAL ##################
    #############################################
    # 01-Infer the ASTRAL coalescent-based tree 
    stage_info_main "Step4: Run ASTRAL or wASTRAL"
    mkdir -p ${output_dir}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree
    if [ "${run_astral}" = "TRUE" ]; then
      run_astral "${output_dir}/08-Coalescent-based_trees/${ortho_method}/03-Combined_gene_trees/${prefix}_${ortho_method}_combined.tre" "${output_dir}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/ASTRAL_${prefix}_${ortho_method}"
    fi
    if [ "${run_wastral}" = "TRUE" ]; then
      run_wastral "${output_dir}/08-Coalescent-based_trees/${ortho_method}/03-Combined_gene_trees/${prefix}_${ortho_method}_combined.tre" "${output_dir}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/wASTRAL_${prefix}_${ortho_method}.tre" "${output_dir}/08-Coalescent-based_trees/${ortho_method}/Final_genes_for_coalscent_list.txt"
    fi

    ############################################################
    #05: Run PhyParts_PieCharts
    ############################################################
    if [ "${run_phyparts}" = "TRUE" ]; then
      stage_blank "${log_mode}" ""
      stage_info_main "Step6: Run PhyParts and modified_phypartspiecharts.py"
      run_phyparts_piecharts "${ortho_method}"
      stage_blank_main ""
    else
      stage_blank_main ""
    fi

    ############################################################
    #06：Caculate the branch length for ASTRAL results via RAxMl
    ############################################################
    stage_blank "${log_mode}" ""
    stage_info_main "Step6: Recaculate the branch length via RAxMl"
    if [ -d "${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/" ]; then  
      rm -rf "${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/"
    fi
    mkdir -p "${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/"
    ### Default: Run SortaDate to sort clock-like genes and recalculate the branch length
    if [ "${recalculate_length}" = "sortadate" ] && [ "${found_outgroup}" = "1" ]; then
      run_sortadate "${output_dir}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees/"
      if [ "${run_astral}" = "TRUE" ]; then
        calculate_branch_length_sortadate "Sortadate_supermatrix_for_recalculating_bl.fasta" \
        "${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_ASTRAL_results" \
        "${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_ASTRAL_results/Selected_sortadate_alignments_for_dating_list.txt" \
        "ASTRAL"

        if [ -s "${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_ASTRAL_results/ASTRAL_sortadate_${prefix}_${ortho_method}_sorted_bl_rr.tre" ]; then
          mv ${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_ASTRAL_results/ASTRAL_sortadate_${prefix}_${ortho_method}_sorted_bl_rr.tre "${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/"
          mv "${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_ASTRAL_results/"RAxML* "${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/"
          stage_info "${log_mode}" "The sorted, rerooted, and recalculated branch length tree has been written to ${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/ASTRAL_sortadate_${prefix}_${ortho_method}_sorted_bl_rr.tre"
        else
          stage_error "Fail"
        fi
      fi
      if [ "${run_wastral}" = "TRUE" ]; then
        calculate_branch_length_sortadate "Sortadate_supermatrix_for_recalculating_bl.fasta" \
        "${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_wASTRAL_results" \
        "${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_wASTRAL_results/Selected_sortadate_alignments_for_dating_list.txt" \
        "wASTRAL"
        if [ -s "${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_wASTRAL_results/wASTRAL_sortadate_${prefix}_${ortho_method}_sorted_bl_rr.tre" ]; then
          mv ${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_wASTRAL_results/wASTRAL_sortadate_${prefix}_${ortho_method}_sorted_bl_rr.tre "${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/"
          mv "${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_wASTRAL_results/"RAxML* "${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/"
          stage_info "${log_mode}" "The sorted, rerooted, and recalculated branch length tree has been written to ${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_ASTRAL_results/wASTRAL_sortadate_${prefix}_${ortho_method}_sorted_bl_rr.tre"
        else
          stage_error "Fail to run SortaDate for wASTRAL results and recalculate the branch length."
        fi
      fi
    else
      stage_error "No outgroup name is provided in ${input_list}."
      stage_error "Outgroup must be specified to reroot gene trees and run SortaDate."
      stage_error "HybSuite stops running SortaDate to recalculate the branch length of coalesecent-based trees."
      stage_blank_main ""
    fi

    if [ "${recalculate_length}" = "all_aln" ]; then
      if [ "${run_astral}" = "TRUE" ]; then
        calculate_branch_length "Supermatrix_for_recalculating_bl.fasta" \
        "${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/alignments" \
        "${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree" \
        "${output_dir}/08-Coalescent-based_trees/${ortho_method}/Final_alignments_for_coalscent_list.txt" \
        "ASTRAL"
      fi
      if [ "${run_wastral}" = "TRUE" ]; then
        calculate_branch_length "Supermatrix_for_recalculating_bl.fasta" \
        "${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/alignments" \
        "${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree" \
        "${output_dir}/08-Coalescent-based_trees/${ortho_method}/Final_alignments_for_coalscent_list.txt" \
        "wASTRAL"
      fi
      if [ -d "${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/alignments" ]; then
        rm -rf "${output_dir}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/alignments"
      fi
    fi
  }
  if [ "${HRS}" = "TRUE" ]; then
    run_coalescent_trees "HRS"
  fi
  if [ "${RLWP}" = "TRUE" ]; then
    run_coalescent_trees "RLWP"
  fi
  if [ "${LS}" = "TRUE" ]; then
    run_coalescent_trees "LS"
  fi
  if [ "${MI}" = "TRUE" ]; then
    run_coalescent_trees "MI"
  fi
  if [ "${MO}" = "TRUE" ]; then
    run_coalescent_trees "MO"
  fi
  if [ "${RT}" = "TRUE" ]; then
    run_coalescent_trees "RT"
  fi
  if [ "${one_to_one}" = "TRUE" ]; then
    run_coalescent_trees "1to1"
  fi
fi
############################################################################################
# End of Stage 5
stage_info_main "Successfully finishing the stage 5: Phylogenetic trees inference."
stage_info "${log_mode}" "The resulting files have been saved in ${output_dir}/06-Modeltest-NG/ or ${output_dir}/07-Concatenation-based_trees or 08-Coalescent-based_trees."

# Clean up environment
cleanup_parallel_env "$work_dir"
stage_info_main "Thank you for using HybSuite! Enjoy your research!"
stage_blank_main ""
exit 1
############################################################################################
