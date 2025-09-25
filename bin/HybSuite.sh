#!/bin/bash
# Script Name: HybSuite.sh
# Author: Yuxuan Liu
#===> Preparation and HybSuite Checking <===#
#Options setting
###set the run name:
hybsuite_version="1.1.5"
current_time=$(date +"%Y-%m-%d_%H:%M:%S")
# Read the variable list file and set the default values
# Obtain the script path
script_dir="$(cd "$(dirname "$0")" && pwd)"
config_dir="$script_dir/../config"
dependencies_dir="$script_dir/../dependencies"

print_welcome_phrases() {
  PURPLE_HEADER='\033[0;38;5;129m'
  PURPLE_BOLD='\033[1;38;5;141m'       
  PURPLE_DARK='\033[0;38;5;99m'        
  PURPLE_LIGHT='\033[0;38;5;183m'    
  PURPLE_ACCENT='\033[0;38;5;147m'    
  CYAN_ACCENT='\033[0;36m'            
  NC='\033[0m'                        

  echo -e ""
  echo -e "${PURPLE_DARK}.....>>>> Hyb-Seq Phylogenomics Pipeline${NC}"
  echo -e "${PURPLE_DARK} _     _                 _          ________               _     ${NC}"
  echo -e "${PURPLE_DARK}| |   | |               | |        / _______|             |_|     _  ${NC}"
  echo -e "${PURPLE_BOLD}| |   | |               | |        | |_         _     _    _    _| |_    ______        ${NC}"
  echo -e "${PURPLE_BOLD}| |___| |  __      __   | |____     \_ \_      | |   | |  | |  |_   _|  /  ____|    ${NC}"
  echo -e "${PURPLE_LIGHT}|  ___  |  \ \    / /   |  ___ \      \_ \_    | |   | |  | |    | |    | |____    ${NC}"
  echo -e "${PURPLE_LIGHT}| |   | |   \ \  / /    | |   \ \       \_ \   | |   | |  | |    | |    |  ____|${NC}"
  echo -e "${PURPLE_DARK}| |   | |    \ \/ /     | |___/ /   ______| |  | |___| |  | |    | |_   | |____  ${NC}"
  echo -e "${PURPLE_DARK}|_|   |_|     \  /      |______/   |________/   \_____/   |_|    |__/   \______|              ${NC}"
  echo -e "${PURPLE_ACCENT}              / /                                     ${NC}"
  echo -e "${PURPLE_ACCENT}             / /           ${NC}"
  echo -e "${PURPLE_LIGHT}            /_/                       | ${CYAN_ACCENT}Transparent${PURPLE_LIGHT} | ${CYAN_ACCENT}Reproducible${PURPLE_LIGHT} | ${CYAN_ACCENT}Flexible${PURPLE_LIGHT} |  ${NC}"
  echo -e "${PURPLE_DARK}                                      NGS raw reads ATGCTATCCCT .....>>>> Trees  ${NC}"
  echo -e ""
  echo "================================================================================="
  echo "HybSuite v. ${hybsuite_version} released by YuxuanLiu, from Sun Lab."
  echo "Latest version: https://github.com/Yuxuanliu-HZAU/HybSuite.git"
  echo "================================================================================="
  echo ""
}


display_help() {
  local subcommand="$1"
  
  PURPLE_HEADER='\033[0;38;5;129m'
  PURPLE_BOLD='\033[1;38;5;141m'       
  PURPLE_DARK='\033[0;38;5;99m'        
  PURPLE_LIGHT='\033[0;38;5;183m'    
  PURPLE_ACCENT='\033[0;38;5;147m'    
  CYAN_ACCENT='\033[0;36m'            
  NC='\033[0m'                        

  echo -e ""
  echo -e "${PURPLE_DARK}.....>>>> Hyb-Seq Phylogenomics Pipeline${NC}"
  echo -e "${PURPLE_DARK} _     _                 _          ________               _     ${NC}"
  echo -e "${PURPLE_DARK}| |   | |               | |        / _______|             |_|     _  ${NC}"
  echo -e "${PURPLE_BOLD}| |   | |               | |        | |_         _     _    _    _| |_    ______        ${NC}"
  echo -e "${PURPLE_BOLD}| |___| |  __      __   | |____     \_ \_      | |   | |  | |  |_   _|  /  ____|    ${NC}"
  echo -e "${PURPLE_LIGHT}|  ___  |  \ \    / /   |  ___ \      \_ \_    | |   | |  | |    | |    | |____    ${NC}"
  echo -e "${PURPLE_LIGHT}| |   | |   \ \  / /    | |   \ \       \_ \   | |   | |  | |    | |    |  ____|${NC}"
  echo -e "${PURPLE_DARK}| |   | |    \ \/ /     | |___/ /   ______| |  | |___| |  | |    | |_   | |____  ${NC}"
  echo -e "${PURPLE_DARK}|_|   |_|     \  /      |______/   |________/   \_____/   |_|    |__/   \______|              ${NC}"
  echo -e "${PURPLE_ACCENT}              / /                                     ${NC}"
  echo -e "${PURPLE_ACCENT}             / /           ${NC}"
  echo -e "${PURPLE_LIGHT}            /_/                       | ${CYAN_ACCENT}Transparent${PURPLE_LIGHT} | ${CYAN_ACCENT}Reproducible${PURPLE_LIGHT} | ${CYAN_ACCENT}Flexible${PURPLE_LIGHT} |  ${NC}"
  echo -e "${PURPLE_DARK}                                      NGS raw reads ATGCTATCCCT .....>>>> Trees  ${NC}"
  echo -e ""
  if [ -z "$subcommand" ]; then
    sed -n '1,$p' $config_dir/HybSuite_help.txt
  else
    sed -n '1,$p' $config_dir/${subcommand}_help.txt
  fi
}

# Function to display the version number
display_version() {
  PURPLE_HEADER='\033[0;38;5;129m'
  PURPLE_BOLD='\033[1;38;5;141m'       
  PURPLE_DARK='\033[0;38;5;99m'        
  PURPLE_LIGHT='\033[0;38;5;183m'    
  PURPLE_ACCENT='\033[0;38;5;147m'    
  CYAN_ACCENT='\033[0;36m'            
  NC='\033[0m'                        

  echo -e ""
  echo -e "${PURPLE_DARK}.....>>>> Hyb-Seq Phylogenomics Pipeline${NC}"
  echo -e "${PURPLE_DARK} _     _                 _          ________               _     ${NC}"
  echo -e "${PURPLE_DARK}| |   | |               | |        / _______|             |_|     _  ${NC}"
  echo -e "${PURPLE_BOLD}| |   | |               | |        | |_         _     _    _    _| |_    ______        ${NC}"
  echo -e "${PURPLE_BOLD}| |___| |  __      __   | |____     \_ \_      | |   | |  | |  |_   _|  /  ____|    ${NC}"
  echo -e "${PURPLE_LIGHT}|  ___  |  \ \    / /   |  ___ \      \_ \_    | |   | |  | |    | |    | |____    ${NC}"
  echo -e "${PURPLE_LIGHT}| |   | |   \ \  / /    | |   \ \       \_ \   | |   | |  | |    | |    |  ____|${NC}"
  echo -e "${PURPLE_DARK}| |   | |    \ \/ /     | |___/ /   ______| |  | |___| |  | |    | |_   | |____  ${NC}"
  echo -e "${PURPLE_DARK}|_|   |_|     \  /      |______/   |________/   \_____/   |_|    |__/   \______|              ${NC}"
  echo -e "${PURPLE_ACCENT}              / /                                     ${NC}"
  echo -e "${PURPLE_ACCENT}             / /           ${NC}"
  echo -e "${PURPLE_LIGHT}            /_/                       | ${CYAN_ACCENT}Transparent${PURPLE_LIGHT} | ${CYAN_ACCENT}Reproducible${PURPLE_LIGHT} | ${CYAN_ACCENT}Flexible${PURPLE_LIGHT} |  ${NC}"
  echo -e "${PURPLE_DARK}                                      NGS raw reads ATGCTATCCCT .....>>>> Trees  ${NC}"
  echo -e ""
  echo -e "${PURPLE_DARK}Version: ${PURPLE_BOLD}${hybsuite_version}${NC}"
  echo -e ""
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
if [ "$1" = "stage1" ] && ([ "$2" = "-h" ] || [ "$2" = "--help" ]); then
  display_help "Stage1"
  exit 0
fi

if [ "$1" = "stage2" ] && ([ "$2" = "-h" ] || [ "$2" = "--help" ]); then
  display_help "Stage2"
  exit 0
fi

if [ "$1" = "stage3" ] && ([ "$2" = "-h" ] || [ "$2" = "--help" ]); then
  display_help "Stage3"
  exit 0
fi

if [ "$1" = "stage4" ] && ([ "$2" = "-h" ] || [ "$2" = "--help" ]); then
  display_help "Stage4"
  exit 0
fi

if [ "$1" = "full_pipeline" ] && ([ "$2" = "-h" ] || [ "$2" = "--help" ]); then
  display_help "Full_pipeline"
  exit 0
fi

if { [ "$1" = "filter_seqs_by_length" ] || [ "$1" = "fsl" ]; } && { [ "$2" = "-h" ] || [ "$2" = "--help" ]; }; then
  "${script_dir}/filter_seqs_by_length.py" "$@"
  exit $?
fi

if { [ "$1" = "filter_seqs_by_coverage" ] || [ "$1" = "fsc" ]; } && { [ "$2" = "-h" ] || [ "$2" = "--help" ]; }; then
  "${script_dir}/filter_seqs_by_sample_and_locus_coverage.py" "$@"
  exit $?
fi

if { [ "$1" = "plot_paralog_heatmap" ] || [ "$1" = "pph" ]; } && { [ "$2" = "-h" ] || [ "$2" = "--help" ]; }; then
  "${script_dir}/plot_paralog_heatmap.py" "$@"
  exit $?
fi

if { [ "$1" = "plot_recovery_heatmap" ] || [ "$1" = "prh" ]; } && { [ "$2" = "-h" ] || [ "$2" = "--help" ]; }; then
  "${script_dir}/plot_recovery_heatmap.py" "$@"
  exit $?
fi

if { [ "$1" = "rlwp" ]; } && { [ "$2" = "-h" ] || [ "$2" = "--help" ]; }; then
  "${script_dir}/RLWP.py" "$@"
  exit $?
fi

if { [ "$1" = "fasta_formatter" ] || [ "$1" = "ff" ]; } && { [ "$2" = "-h" ] || [ "$2" = "--help" ]; }; then
  "${script_dir}/Fasta_formatter.py" "$@"
  exit $?
fi

if { [ "$1" = "rename_assembled_data" ] || [ "$1" = "rad" ]; } && { [ "$2" = "-h" ] || [ "$2" = "--help" ]; }; then
  "${script_dir}/rename_assembled_data.py" "$@"
  exit $?
fi

if { [ "$1" = "modified_phypartspiecharts" ] || [ "$1" = "mpp" ]; } && { [ "$2" = "-h" ] || [ "$2" = "--help" ]; }; then
  "${script_dir}/modified_phypartspiecharts.py" "$@"
  exit $?
fi

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    display_help
    exit 0
fi
if [ "$1" = "-v" ] || [ "$1" = "--version" ]; then
    display_version
    exit 0
fi

#Print welcome phrases
print_welcome_phrases
echo "================================================================================="
echo "HybSuite User input command:"
echo "$0 $@"
input_command="$0 $@"
echo "================================================================================="
echo ""

check_error() {
  local message="$1"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  local red_color='\033[0;31m'
  local reset_color='\033[0m'

  echo -e "${red_color}[${timestamp}] [ERROR] ${message}${reset_color}"
}

# Main function for configuring the HybSuite
config_main() {
  local config_file="$1"
  # Switch to the script path
  while IFS= read -r line || [ -n "$line" ]; do
    var=$(echo "${line}" | awk '{print $1}')
    default=$(echo "${line}" | awk '{print $2}')
    eval "${var}=''" > /dev/null 2>&1
    eval "Default_${var}='${default}'" > /dev/null 2>&1
    eval "found_${var}=false" > /dev/null 2>&1
  done < "${config_dir}/${config_file}"

  shift 1
  while [ "$#" -gt 1 ]; do
    case "$2" in
        -*)
            option="${2#-}"
            vars=""
            while IFS= read -r line; do
                vars="$vars $(echo "$line" | awk '{print $1}')"
            done < "${config_dir}/${config_file}"
            #echo "                    -$option: $3"
            case "$3" in
              -*)
                option3="${3#-}"
                found_arg=0
                for v in $vars; do
                  if [ "$v" = "$option3" ]; then
                    found_arg=1
                    break
                  fi
                done
                if [ "$found_arg" -eq 1 ]; then
                  echo ""
                  echo "[HybSuite-WARNING]: The argument for option $2 is not permitted to start with '-'"
                  echo "                    Please change your argument for the option $2."
                  echo "[HybSuite-WARNING]: Or you didn't specify any argument for the option $2."
                  echo "                    Please specify an argument for the option $2."
                  echo "                    HybSuite exits."
                  echo ""
                  exit 1
                fi
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
            for v in $vars; do
              if [ "$v" = "$option" ]; then
                found=1
                break
              fi
            done
            if [ $found -eq 1 ]; then
              last_char=$(printf '%s' "$3" | tail -c 1)
              if [ "$last_char" = "/" ]; then
                value=$(printf '%s' "$3" | sed 's/\/$//')
              else
                value="$3"
              fi
              eval "${option}=\"\$value\""
              eval "found_${option}=true"
              echo "$option" >> "${config_dir}/Option-list.txt"
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
  cut -f 1 $config_dir/${config_file} > $config_dir/Option-all-list.txt
  sort $config_dir/Option-all-list.txt $config_dir/Option-list.txt 2>/dev/null |uniq -u 2>/dev/null > $config_dir/Option-default-list.txt

  while read -r line; do
      default_var="Default_${line}"
      eval "default_value=\$$default_var"
      eval "default_value=${default_value}" > /dev/null 2>&1
      eval "${line}=\"${default_value}\"" > /dev/null 2>&1
      #echo "                    Default argument for -${line}: ${default_value}"
  done < "$config_dir/Option-default-list.txt"
  rm "$config_dir"/Option*

  for var in input_data output_dir NGS_dir eas_dir t iqtree_constraint_tree raxml_constraint_tree rng_constraint_tree aln_dir paralogs_dir; do
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
}

# Check if the subcommand is used
full_pipeline="FALSE"
run_stage1="FALSE"
run_stage2="FALSE"
run_stage3="FALSE"
run_stage4="FALSE"
if [ "$#" -gt 0 ]; then
  case "$1" in
    "filter_seqs_by_length"|"fsl")
      print_welcome_phrases
      shift
      # Execute filter_seqs_by_length.py script
      "${script_dir}/filter_seqs_by_length.py" "$@"
      exit $?
      ;;
    "filter_seqs_by_coverage"|"fsc")
      print_welcome_phrases
      shift
      # Execute filter_seqs_by_coverage.py script
      "${script_dir}/filter_seqs_by_sample_and_locus_coverage.py" "$@"
      exit $?
      ;;
    "plot_paralog_heatmap"|"pph")
      print_welcome_phrases
      shift
      # Execute plot_paralog_heatmap.py script
      "${script_dir}/plot_paralog_heatmap.py" "$@"
      exit $?
      ;;
    "plot_recovery_heatmap"|"prh")
      print_welcome_phrases
      shift
      # Execute plot_recovery_heatmap.py script
      "${script_dir}/plot_recovery_heatmap.py" "$@"
      exit $?
      ;;
    "rlwp")
      print_welcome_phrases
      shift
      # Execute RLWP.py script
      "${script_dir}/RLWP.py" "$@"
      exit $?
      ;;
    "fasta_formatter"|"ff")
      print_welcome_phrases
      shift
      # Execute Fasta_formatter.py script
      "${script_dir}/Fasta_formatter.py" "$@"
      exit $?
      ;;
    "rename_assembled_data"|"rad")
      print_welcome_phrases
      shift
      # Execute rename_assembled_data.py script
      "${script_dir}/rename_assembled_data.py" "$@"
      exit $?
      ;;
    "modified_phypartspiecharts"|"mpp")
      print_welcome_phrases
      shift
      # Execute modified_phypartspiecharts.py script
      "${script_dir}/modified_phypartspiecharts.py" "$@"
      exit $?
      ;;
    "full_pipeline")
      config_main "Full_pipeline.config"
      full_pipeline="TRUE"
      ;;
    "stage1")
      config_main "Stage1.config" "$@"
      run_stage1="TRUE"
      ;;
    "stage2")
      config_main "Stage2.config" "$@"
      run_stage2="TRUE"
      ;;
    "stage3")
      config_main "Stage3.config" "$@"
      run_stage3="TRUE"
      ;;
    "stage4")
      config_main "Stage4.config" "$@"
      run_stage4="TRUE"
      ;;
    "retrieve_results")
      if [ "$2" = "-h" ]; then
        echo "Usage: HybSuite retrieve_results"
        echo "Retrieve all tree files and figures generated by HybSuite."
        echo "Options:"
        echo "  -h, --help    Show this help message and exit"
        echo "  -i            Specify the directory containing the results generated by HybSuite."
        echo "  -o            Specify the output directory, all retrieved files will be saved in this directory."
        exit 0
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
        cp ${retrieve_input_dir}/07-Concatenated_analysis/*/02-Species_tree/IQ-TREE/IQ-TREE*rr.tre "${retrieve_output_dir}" 2>/dev/null || true
        cp ${retrieve_input_dir}/07-Concatenated_analysis/*/02-Species_tree/RAxML-NG/RAxML-NG*rr.tre "${retrieve_output_dir}" 2>/dev/null || true
        cp ${retrieve_input_dir}/07-Concatenated_analysis/*/02-Species_tree/RAxML/RAxML*rr.tre "${retrieve_output_dir}" 2>/dev/null || true
        cp ${retrieve_input_dir}/08-Coalescent_analysis/*/03-Species_tree/*/*rr.tre "${retrieve_output_dir}" 2>/dev/null || true
        cp ${retrieve_input_dir}/08-Coalescent_analysis/*/04-PhyParts_PieCharts/*_phypartspiecharts_*.svg "${retrieve_output_dir}" 2>/dev/null || true
        cp ${retrieve_input_dir}/08-Coalescent_analysis/*/04-PhyParts_PieCharts/*_phypartspiecharts_*.tsv "${retrieve_output_dir}" 2>/dev/null || true
        exit 0
      fi
      ;;
      *)
        check_error "ERROR: Unknown HybSuite subcommand: $1."
        check_error "HybSuite exits."
        echo "Command mode 1 (for conda version):"
        echo "  hybsuite [subcommand] [options] ..."
        echo "Command mode 2 (for local version):"
        echo "  bash HybSuite.sh [subcommand] [options] ..."
        echo "Available subcommands for running HybSuite pipeline:"
        echo "  full_pipeline                       - Run all stages (stage1-4)"
        echo "  stage1                              - Run stage 1"
        echo "  stage2                              - Run stage 2"
        echo "  stage3                              - Run stage 3"
        echo "  stage4                              - Run stage 4"
        echo "  retrieve_results                    - Retrieve treefiles and figures generated by HybSuite"
        echo "Available subcommands for running HybSuite extension tools:"
        echo "  filter_seqs_by_length | fsl         - Filter sequences by length (filter_seqs_by_length.py)"
        echo "  filter_seqs_by_coverage | fsc       - Filter sequences by sample and locus coverage (filter_seqs_by_sample_and_locus_coverage.py)"
        echo "  plot_paralog_heatmap | pph          - Plot paralog heatmap (plot_paralog_heatmap.py)"
        echo "  plot_recovery_heatmap | prh         - Plot recovery heatmap (plot_recovery_heatmap.py)"
        echo "  rlwp | rlwp                         - RLWP tool (RLWP.py)"
        echo "  fasta_formatter | ff                - FASTA formatting tool (Fasta_formatter.py)"
        echo "  rename_assembled_data | rad         - Rename HybPiper assembled data directory (rename_assembled_data.py)"
        echo "  modified_phypartspiecharts | mpp    - modified_phypartspiecharts.py"
        echo ""
        exit 1
      ;;
  esac
fi

if [ "$#" -eq 1 ]; then
  check_error "ERROR: Missing required parameters for '$1' subcommand."
  check_error "Usage: hybsuite $1 [required_options] (use -h for help)"
  check_error "Or: $0 $1 [required_options] (use -h for help)"
  check_error "HybSuite exits."
  echo ""
  exit 1
fi

#################===========================================================================
# Define OI and tree
HRS="FALSE"
RLWP="FALSE"
LS="FALSE"
MO="FALSE"
MI="FALSE"
RT="FALSE"
one_to_one="FALSE"

if echo "${PH}" | grep -q "1"; then
  HRS="TRUE"
fi
if echo "${PH}" | grep -q "2"; then
  RLWP="TRUE"
fi
if echo "${PH}" | grep -q "3"; then
  LS="TRUE"
fi
if echo "${PH}" | grep -q "4"; then
  MI="TRUE"
fi
if echo "${PH}" | grep -q "5"; then
  MO="TRUE"
fi
if echo "${PH}" | grep -q "6"; then
  RT="TRUE"
fi
if echo "${PH}" | grep -q "7"; then
  one_to_one="TRUE"
fi
if echo "${PH}" | grep -q "a"; then
  run_phylopypruner="TRUE"
  run_paragone="FALSE"
fi
if echo "${PH}" | grep -q "b"; then
  run_paragone="TRUE"
  run_phylopypruner="FALSE"
fi
if [ "${PH}" = "all" ]; then
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
run_astral4="FALSE"
run_wastral="FALSE"
run_astral_pro="FALSE"

if echo "${sp_tree}" | grep -q "1"; then
  run_iqtree="TRUE"
fi
if echo "${sp_tree}" | grep -q "2"; then
  run_raxml="TRUE"
fi
if echo "${sp_tree}" | grep -q "3"; then
  run_raxml_ng="TRUE"
fi
if echo "${sp_tree}" | grep -q "4"; then
  run_astral4="TRUE"
fi
if echo "${sp_tree}" | grep -q "5"; then
  run_wastral="TRUE"
fi
if echo "${sp_tree}" | grep -q "6"; then
  run_astral_pro="TRUE"
fi
if [ "${sp_tree}" = "all" ]; then
  run_iqtree="TRUE"
  run_raxml="TRUE"
  run_raxml_ng="TRUE"
  run_astral="TRUE"
  run_astral4="TRUE"
  run_wastral="TRUE"
fi
#################===========================================================================

#################===========================================================================
# Define threads
define_threads() {
  local software="$1"
  local stage_log_file="${output_dir}/hybsuite_logs/hybsuite_${current_time}.log"
    
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
        if [ "$(echo "$current_load > 1" | bc -l)" -eq 1 ]; then
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
mkdir -p "${output_dir}/hybsuite_logs"
mkdir -p "${output_dir}/hybsuite_checklists"
############################################################################################

#################===========================================================================
# Function: Output information to log file
stage_logfile="${output_dir}/hybsuite_logs/hybsuite_${current_time}.log"
stage_info_main() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "${stage_logfile}"
}

stage_info_main_light_purple() {
  local message="$1"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  local lightpurple_color='\033[0;38;5;183m'
  local reset_color='\033[0m'
  
  echo -e "${lightpurple_color}[${timestamp}] [INFO] ${message}${reset_color}"
  echo "[${timestamp}] [INFO] ${message}" >> "${stage_logfile}"
}

stage_info_main_purple() {
  local message="$1"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  local purple_color='\033[0;38;5;99m'
  local reset_color='\033[0m'
  
  echo -e "${purple_color}[${timestamp}] [INFO] ${message}${reset_color}"
  echo "[${timestamp}] [INFO] ${message}" >> "${stage_logfile}"
}

stage_info_main_blue() {
  local message="$1"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  local blue_color='\033[0;36m'
  local reset_color='\033[0m'
  
  echo -e "${blue_color}[${timestamp}] [INFO] ${message}${reset_color}"
  echo "[${timestamp}] [INFO] ${message}" >> "${stage_logfile}"
}

stage_info_main_success() {
  local message="$1"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  local green_color='\033[0;32m'
  local reset_color='\033[0m'
  
  echo -e "${green_color}[${timestamp}] [INFO] ${message}${reset_color}"
  echo "[${timestamp}] [INFO] ${message}" >> "${stage_logfile}"
}

stage_success() {
  local message="$1"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  local green_color='\033[0;32m'
  local reset_color='\033[0m'
  
  echo -e "${green_color}[${timestamp}] [SUCCESS] ${message}${reset_color}"
  echo "[${timestamp}] [SUCCESS] ${message}" >> "${stage_logfile}"
}

stage_info() {
  local log_mode="$1"
  local message="$2"
  if [ "${log_mode}" = "full" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $message" | tee -a "${stage_logfile}"
  fi
}

stage_error() {
  local message="$1"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  local red_color='\033[0;31m'
  local reset_color='\033[0m'

  echo -e "${red_color}[${timestamp}] [ERROR] ${message}${reset_color}"
  echo "[${timestamp}] [ERROR] ${message}" >> "${stage_logfile}"
}

stage_warning() {
  local message="$1"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  local yellow_color='\033[0;33m'
  local reset_color='\033[0m'

  echo -e "${yellow_color}[${timestamp}] [WARNING] ${message}${reset_color}"
  echo "[${timestamp}] [WARNING] ${message}" >> "${stage_logfile}"
}

stage_attention() {
  local message="$1"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  local blue_color='\033[0;34m'
  local reset_color='\033[0m'

  echo -e "${blue_color}[${timestamp}] [ATTENTION] ${message}${reset_color}"
  echo "[${timestamp}] [ATTENTION] ${message}" >> "${stage_logfile}"
}

stage_cmd_main() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [CMD] $1" | tee -a "${stage_logfile}"
}

stage_cmd() {
  local log_mode="$1"
  local message="$2"
  
  if [ "${log_mode}" = "cmd" ] || [ "${log_mode}" = "full" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [CMD] $message" >> "${stage_logfile}"
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

echo "HybSuite Version: ${hybsuite_version}" >> "${stage_logfile}"
echo "HybSuite input command (reuse or change these parameters for next run):" >> "${stage_logfile}"
echo "${input_command}" >> "${stage_logfile}"
echo "[${current_time}]" >> "${stage_logfile}"
echo "---------------------" >> "${stage_logfile}"
echo "" >> "${stage_logfile}"
#################===========================================================================

#HybSuite CHECKING
#Step 1: Check necessary options
check_necessary_options() {
  if [ "${run_stage1}" = "TRUE" ]; then
    if [ "${input_list}" = "_____" ] || [ "${output_dir}" = "_____" ]; then
      stage_error "ERROR: Missing required parameters for running subcommand: stage1"
      stage_error "The following mandatory options must be specified:"
      stage_error "-input_list -input_data (required when including user-provided data) -output_dir"
      stage_error "Use 'hybsuite stage1 -h' or 'hybsuite stage1 --help' for usage instructions."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
  fi
  if [ "${run_stage2}" = "TRUE" ]; then
    if [ "${input_list}" = "_____" ] || [ "${NGS_dir}" = "_____" ] || [ "${output_dir}" = "_____" ] || [ "${t}" = "_____" ]; then
      stage_error "ERROR: Missing required parameters for running subcommand: stage2"
      stage_error "The following mandatory options must be specified:"
      stage_error "-input_list -NGS_dir -t -output_dir"
      stage_error "Use 'hybsuite stage2 -h' or 'hybsuite stage2 --help' for usage instructions."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
  fi
  if [ "${run_stage3}" = "TRUE" ]; then
    if [ "${input_list}" = "_____" ] || [ "${eas_dir}" = "_____" ] || [ "${paralogs_dir}" = "_____" ] || [ "${output_dir}" = "_____" ] || [ "${t}" = "_____" ]; then
      stage_error "ERROR: Missing required parameters for running subcommand: stage3"
      stage_error "The following mandatory options must be specified:"
      stage_error "-input_list -eas_dir -paralogs_dir -t -output_dir"
      stage_error "Use 'hybsuite stage3 -h' or 'hybsuite stage3 --help' for usage instructions."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
  fi
  if [ "${run_stage4}" = "TRUE" ]; then
    if [ "${input_list}" = "_____" ] || [ "${aln_dir}" = "_____" ] || [ "${output_dir}" = "_____" ]; then
      stage_error "ERROR: Missing required parameters for running subcommand: stage4"
      stage_error "The following mandatory options must be specified:"
      stage_error "-input_list -aln_dir -output_dir"
      stage_error "Use 'hybsuite stage4 -h' or 'hybsuite stage4 --help' for usage instructions."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
  fi
  if [ "${full_pipeline}" = "TRUE" ]; then
    if [ "${input_list}" = "_____" ] || [ "${t}" = "_____" ] || [ "${output_dir}" = "_____" ]; then
      stage_error "ERROR: Missing required parameters for running subcommand: full_pipeline"
      stage_error "The following mandatory options must be specified:"
      stage_error "-input_list -t -output_dir"
      stage_error "Use 'hybsuite full_pipeline -h' or 'hybsuite full_pipeline --help' for usage instructions."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
  fi
}
if [ "${check}" = "FALSE" ]; then
  stage_info_main "HybSuite Checking is skipped."
elif [ "${check}" = "TRUE" ]; then
  stage_info_main_ "<<<======= HybSuite CHECKING =======>>>"
  stage_info_main "Message Severity Convention:"
  stage_info_main "[ATTENTION]  Important notices requiring user awareness"
  stage_info_main "[WARNING]    Configuration issues that may impact analysis"
  stage_info_main "[ERROR]      Fatal errors causing pipeline termination (e.g. missing dependencies)"
  stage_blank_main ""
  stage_info_main "=> Step 1: Input Parameter Validation"
  stage_info_main "01-Verifying required command-line options..."
  stage_info_main "Validation results:"
  ###Verify if the user has entered the necessary parameters
  check_necessary_options
  stage_info_main "PASS"
  
  if [ -s "${input_list}" ]; then
    sed -i 's/\r$//; /^$/d' "${input_list}"
  fi

  # 02-Checking other parameters
  stage_info_main "02-Checking other parameters ..."
  stage_info_main "Checking results:"
  ################===========================================
  check_threads() {
    stage_info_main "<threads control>:"
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
    stage_info_main "All programs will use the recommended number of threads."
  elif [ "${nt}" -eq "${nt}" ] 2>/dev/null && [ "${nt}" -ge 0 ]; then
    stage_info_main "All programs will use the specified number of threads: ${nt}."
    if [ "${nt}" -gt "${free_threads}" ]; then
      stage_warning "Specified threads (${nt}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_fasterq_dump}" -gt "${free_threads}" ]; then
      stage_warning "Specified fasterq-dump threads (${nt_fasterq_dump}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_pigz}" -gt "${free_threads}" ]; then
      stage_warning "Specified pigz threads (${nt_pigz}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_trimmomatic}" -gt "${free_threads}" ]; then
      stage_warning "Specified Trimmomatic threads (${nt_trimmomatic}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_hybpiper}" -gt "${free_threads}" ]; then
      stage_warning "Specified HybPiper threads (${nt_hybpiper}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_paragone}" -gt "${free_threads}" ]; then
      stage_warning "Specified ParaGone threads (${nt_paragone}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_phylopypruner}" -gt "${free_threads}" ]; then
      stage_warning "Specified PhyloPyPruner threads (${nt_phylopypruner}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_mafft}" -gt "${free_threads}" ]; then
      stage_warning "Specified MAFFT threads (${nt_mafft}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_modeltest_ng}" -gt "${free_threads}" ]; then
      stage_warning "Specified ModelTest-NG threads (${nt_modeltest_ng}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_iqtree}" -gt "${free_threads}" ]; then
      stage_warning "Specified IQ-TREE threads (${nt_iqtree}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_fasttree}" -gt "${free_threads}" ]; then
      stage_warning "Specified FastTree threads (${nt_fasttree}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_raxml_ng}" -gt "${free_threads}" ]; then
      stage_warning "Specified RAxML-NG threads (${nt_raxml_ng}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_raxml}" -gt "${free_threads}" ]; then
      stage_warning "Specified RAxML threads (${nt_raxml}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_astral}" -gt "${free_threads}" ]; then
      stage_warning "Specified ASTRAL threads (${nt_astral}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_astral4}" -gt "${free_threads}" ]; then
      stage_warning "Specified ASTRAL-IV threads (${nt_astral4}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
    if [ "${nt_wastral}" -gt "${free_threads}" ]; then
      stage_warning "Specified wASTRAL threads (${nt_wastral}) exceed available free CPU threads (${free_threads}). This may impact performance."
    fi
  fi
  stage_blank_main ""
  }
  ################===========================================
  
  # check parameters for inputs
  stage_info_main "<Parameters for inputs and outputs>"
  if [ "${run_stage1}" = "TRUE" ]; then
    if [ ! -s "${input_list}" ]; then
      stage_error "The input list file (specified by '-input_list') does not exist."
      stage_error "Please check and correct the '-input_list' parameter."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    else
      found_own=$(awk -F'\t' '$2 == "A" { print 1; exit }' "${input_list}")
      found_pre=$(awk -F'\t' '$2 == "B" { print 1; exit }' "${input_list}")
      if [ "${found_own}" = "1" ] || [ "${found_pre}" = "1" ]; then
        if [ ! -d "${input_data}" ]; then
        stage_error "The input data directory (specified by '-input_data') does not exist."
        stage_error "Please check and correct the '-input_data' parameter."
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
        fi
      fi
    fi
    if [ ! -d "${output_dir}" ]; then
      stage_error "The output directory (specified by '-output_dir') does not exist."
      stage_error "Please check and correct the '-output_dir' parameter."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
  fi
  if [ "${run_stage2}" = "TRUE" ]; then
    if [ ! -s "${input_list}" ]; then
      stage_error "The input list file (specified by '-input_list') does not exist."
      stage_error "Please check and correct the '-input_list' parameter."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
    if [ ! -s "${t}" ]; then
      stage_error "The target file (specified by '-t') does not exist."
      stage_error "Please check and correct the '-t' parameter."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
    if [ ! -d "${NGS_dir}" ] && [ "${NGS_dir}" != "${output_dir}/NGS_dataset" ]; then
      stage_error "The NGS dataset directory generated in stage 1 (specified by '-NGS_dir') does not exist."
      stage_error "Please check and correct the '-NGS_dir' parameter."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
    if [ ! -d "${output_dir}" ]; then
      stage_error "The output directory (specified by '-output_dir') does not exist."
      stage_error "Please check and correct the '-output_dir' parameter."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
    if [ ! -d "${eas_dir}" ] && [ "${eas_dir}" != "${output_dir}/01-Assembled_data" ]; then
      stage_error "The output directory for sequences generated by 'hybpiper assemble' (specified by '-eas_dir') does not exist."
      stage_error "Please check and correct the '-eas_dir' parameter."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
  fi
  if [ "${run_stage3}" = "TRUE" ]; then
    if [ ! -s "${input_list}" ]; then
      stage_error "The input list file (specified by '-input_list') does not exist."
      stage_error "Please check and correct the '-input_list' parameter."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
    if [ ! -s "${t}" ]; then
      stage_error "The target file (specified by '-t') does not exist."
      stage_error "Please check and correct the '-t' parameter."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
    if [ ! -d "${output_dir}" ]; then
      stage_error "The output directory (specified by '-output_dir') does not exist."
      stage_error "Please check and correct the '-output_dir' parameter."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
    if [ ! -d "${eas_dir}" ] && [ "${eas_dir}" != "${output_dir}/01-Assembled_data" ]; then
      stage_error "The output directory for sequences generated by 'hybpiper assemble' (specified by '-eas_dir') does not exist."
      stage_error "Please check and correct the '-eas_dir' parameter."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
    if [ ! -d "${paralogs_dir}" ] && [ "${paralogs_dir}" != "${output_dir}/02-All_paralogs/03-Filtered_paralogs" ]; then
      stage_error "The directory containing all putative paralog sequences generated in stage 2 or by users themselves (specified by '-paralogs_dir') does not exist."
      stage_error "Please check and correct the '-paralogs_dir' parameter."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
  fi
  if [ "${run_stage4}" = "TRUE" ]; then
    if [ ! -s "${input_list}" ]; then
      stage_error "The input list file (specified by '-input_list') does not exist."
      stage_error "Please check and correct the '-input_list' parameter."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
    if [ ! -d "${aln_dir}" ] && [ "${aln_dir}" != "${paralogs_dir}" ]; then
      stage_error "The directory containing all aligned sequences (specified by '-aln_dir') does not exist."
      stage_error "Please check and correct the '-aln_dir' parameter."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
    if [ ! -d "${output_dir}" ]; then
      stage_error "The output directory (specified by '-output_dir') does not exist."
      stage_error "Please check and correct the '-output_dir' parameter."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
  fi
  if [ "${full_pipeline}" = "TRUE" ]; then
    if [ ! -s "${input_list}" ]; then
      stage_error "The input list file (specified by '-input_list') does not exist."
      stage_error "Please check and correct the '-input_list' parameter."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
    if [ ! -d "${output_dir}" ]; then
      stage_error "The output directory (specified by '-output_dir') does not exist."
      stage_error "Please check and correct the '-output_dir' parameter."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
    if [ ! -d "${NGS_dir}" ] && [ "${NGS_dir}" != "${output_dir}/NGS_dataset" ]; then
      stage_error "The NGS dataset directory generated in stage 1 (specified by '-NGS_dir') does not exist."
      stage_error "Please check and correct the '-NGS_dir' parameter."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
    if [ ! -d "${eas_dir}" ] && [ "${eas_dir}" != "${output_dir}/01-Assembled_data" ]; then
      stage_error "The directory containing all sequences generated by 'hybpiper assemble' (specified by '-eas_dir') does not exist."
      stage_error "Please check and correct the '-eas_dir' parameter."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
    if [ ! -s "${t}" ]; then
      stage_error "The target file (specified by '-t') does not exist."
      stage_error "Please check and correct the '-t' parameter."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
  fi
  stage_info_main "PASS"
  
  # check other general parameters
  if [ "${run_stage2}" = "TRUE" ] || [ "${run_stage3}" = "TRUE" ] || [ "${full_pipeline}" = "TRUE" ]; then
    stage_info_main "<Parameters for sequences and alignments filtering control>"
    stage_info_main "Checking results:"
    if [ "${run_stage2}" = "TRUE" ] || [ "${full_pipeline}" = "TRUE" ]; then
      if [ "$(echo "${seqs_locus_filter} >= 0" | bc -l)" -eq 1 ] && [ "$(echo "${seqs_locus_filter} <= 1" | bc -l)" -eq 1 ]; then
        :
      else
        stage_error "The '-seqs_locus_filter' value must be greater than 0 and less than 1."
        stage_error "Please correct it."
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      fi
      if [ "$(echo "${seqs_sample_filter} >= 0" | bc -l)" -eq 1 ] && [ "$(echo "${seqs_sample_filter} <= 1" | bc -l)" -eq 1 ]; then
        :
      else
        stage_error "The '-seqs_sample_filter' value must be greater than 0 and less than 1."
        stage_error "Please correct it."
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      fi
    fi

    if [ "${run_stage3}" = "TRUE" ] || [ "${full_pipeline}" = "TRUE" ]; then
      if [ "$(echo "${aln_sample_filter} >= 0" | bc -l)" -eq 1 ] && [ "$(echo "${aln_sample_filter} <= 1" | bc -l)" -eq 1 ]; then
        :
      else
        stage_error "The '-aln_sample_filter' value must be greater than 0 and less than 1."
        stage_error "Please correct it."
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      fi

      if [ "$(echo "${aln_locus_filter} >= 0" | bc -l)" -eq 1 ] && [ "$(echo "${aln_locus_filter} <= 1" | bc -l)" -eq 1 ]; then
        :
      else
        stage_error "The '-aln_locus_filter' value must be greater than 0 and less than 1."
        stage_error "Please correct it."
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      fi
    fi
    stage_info_main "PASS"
  fi

  if [ "${run_stage3}" = "TRUE" ] || [ "${run_stage4}" = "TRUE" ] || [ "${full_pipeline}" = "TRUE" ]; then
    stage_info_main "<Parameters for orthology inference control>:"
    stage_info_main "According to your input command, the chosen ortholog inference methods are:"
    if [ "${HRS}" = "TRUE" ]; then
      stage_info_main "HRS"
    fi
    if [ "${RLWP}" = "TRUE" ]; then
      stage_info_main "RLWP"
    fi
    if [ "${LS}" = "TRUE" ]; then
      stage_info_main "LS"
    fi
    if [ "${MI}" = "TRUE" ]; then
      stage_info_main "MI"
    fi
    if [ "${MO}" = "TRUE" ]; then
      stage_info_main "MO"
    fi
    if [ "${RT}" = "TRUE" ]; then
      stage_info_main "RT"
    fi
    if [ "${one_to_one}" = "TRUE" ]; then
      stage_info_main "1to1"
    fi
    stage_info_main "PASS"
  fi

  if [ "${run_stage4}" = "TRUE" ] || [ "${full_pipeline}" = "TRUE" ]; then
    stage_info_main "<Parameters for species tree inference control>:"
    stage_info_main "According to your input command, the chosen species tree inference tools are:"
    if [ "${run_iqtree}" = "TRUE" ]; then
      stage_info_main "IQ-TREE"
    fi
    if [ "${run_raxml}" = "TRUE" ]; then
      stage_info_main "RAxML"
    fi
    if [ "${run_raxml_ng}" = "TRUE" ]; then
      stage_info_main "RAxML-NG"
    fi
    if [ "${run_astral}" = "TRUE" ]; then
      stage_info_main "ASTRAL-I"
    fi
    if [ "${run_wastral}" = "TRUE" ]; then
      stage_info_main "wASTRAL"
    fi
    if [ "${sp_tree}" = "0" ]; then
      stage_info_main "None"
    fi
    stage_info_main "PASS"
  fi
  stage_success "Well done!"
  stage_success "All parameters are valid."
  stage_success "Moving on to the next step ..."
  stage_blank_main ""

  ###################################
  ### Step 2: Check dependencies ####
  ###################################
  stage_info_main "=> Step 2: Check dependencies" 
  stage_info_main "01-Check required software in all conda environments..."
  # sra-tools
  check_sra_tools() {
    if ! command -v prefetch >/dev/null 2>&1 && ! command -v fasterq-dump >/dev/null 2>&1; then
      stage_error "'sra-tools' is not found in your conda environment."
      stage_error "Please install 'sra-tools' in your conda environment."
      stage_error "Recommended command for installation:"
      stage_error "mamba install bioconda::sra-tools -y"
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    else
      stage_info_main "'sra-tools' existed, pass"
    fi
  }

  check_pigz() {
    if ! command -v pigz >/dev/null 2>&1; then
      stage_error "'pigz' is not found in your conda environment."
      stage_error "Please install 'pigz' in your conda environment."
      stage_error "Recommended command for installation:"
      stage_error "mamba install conda-forge::pigz -y"
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    else
      stage_info_main "'pigz' existed, pass"
    fi
  }
  
  check_trimmomatic() {
    if ! command -v trimmomatic >/dev/null 2>&1; then
      stage_error "'trimmomatic' is not found in your conda environment."
      stage_error "Please install 'trimmomatic' in your conda environment."
      stage_error "Recommended command for installation:"
      stage_error "mamba install conda-forge::trimmomatic -y"
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    else
      stage_info_main "'trimmomatic' existed, pass"
    fi
  }

  check_hybpiper() {
    if ! command -v hybpiper >/dev/null 2>&1; then
      stage_error "'hybpiper' is not found in your conda environment."
      stage_error "Please install 'hybpiper' in your conda environment."
      stage_error "Recommended command for installation:"
      stage_error "mamba install bioconda::hybpiper -y"
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    else
      stage_info_main "'hybpiper' existed, pass"
    fi
  }

  check_amas() {
    if ! command -v AMAS.py >/dev/null 2>&1; then
      stage_error "'amas' is not found in your conda environment."
      stage_error "Please install 'amas' in your conda environment."
      stage_error "Recommended command for installation:"
      stage_error "mamba install bioconda::amas -y"
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    else
      stage_info_main "'amas' existed, pass"
    fi
  }

  check_mafft() {
    if ! command -v mafft >/dev/null 2>&1; then
      stage_error "'mafft' is not found in your conda environment."
      stage_error "Please install 'mafft' in your conda environment."
      stage_error "Recommended command for installation:"
      stage_error "mamba install bioconda::mafft -y"
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    else
      stage_info_main "'mafft' existed, pass"
    fi
  }

  check_trimal() {
    if ! command -v trimal >/dev/null 2>&1; then
      stage_error "'trimal' is not found in your conda environment."
      stage_error "Please install 'trimal' in your conda environment."
      stage_error "Recommended command for installation:"
      stage_error "mamba install bioconda::trimal -y"
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    else
      stage_info_main "'trimal' existed, pass"
    fi
  }
  
  check_paragone() {
    if ([ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "$one_to_one" = "TRUE" ]) && [ "${run_paragone}" = "TRUE" ]; then
      if ! command -v paragone >/dev/null 2>&1; then
        stage_error "'ParaGone' is not found in your conda environment."
        stage_error "Please install 'ParaGone' in your conda environment."
        stage_error "Recommended command for installation:"
        stage_error "mamba install bioconda::paragone -y"
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      else
        stage_info_main "'paragone' existed, pass"
      fi
    fi
  }

  check_modeltest_ng() {
    if ! command -v modeltest-ng >/dev/null 2>&1; then
      stage_error "'modeltest-ng' is not found in your conda environment."
      stage_error "Please install 'modeltest-ng' in your conda environment."
      stage_error "Recommended command for installation:"
      stage_error "mamba install bioconda::modeltest-ng -y"
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    else
      stage_info_main "'modeltest-ng' existed, pass"
    fi
  }

  check_iqtree() {
    if ! command -v iqtree >/dev/null 2>&1; then
      stage_error "'iqtree' is not found in your conda environment."
      stage_error "Please install 'iqtree' in your conda environment."
      stage_error "Recommended command for installation:"
      stage_error "mamba install bioconda::iqtree -y"
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    else
      stage_info_main "'iqtree' existed, pass"
    fi
  }

  check_raxml() {
    if ! command -v raxmlHPC >/dev/null 2>&1; then
      stage_error "'raxml' is not found in your conda environment."
      stage_error "Please install 'raxml' in your conda environment."
      stage_error "Recommended command for installation:"
      stage_error "mamba install bioconda::raxml -y"
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    else
      stage_info_main "'raxml' existed, pass"
    fi
  }
  
  check_raxml_ng() {
    if ! command -v raxml-ng >/dev/null 2>&1; then
      stage_error "'raxml-ng' is not found in your conda environment."
      stage_error "Please install 'raxml-ng' in your conda environment."
      stage_error "Recommended command for installation:"
      stage_error "mamba install bioconda::raxml-ng -y"
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    else
      stage_info_main "'raxm-ng' existed, pass"
    fi
  }

  check_aster() {

    if ! command -v astral4 >/dev/null 2>&1; then
      stage_error "'aster' is not found in your conda environment."
      stage_error "Please install 'aster' in your conda environment."
      stage_error "Recommended command for installation:"
      stage_error "mamba install bioconda::aster -y"
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    else
      stage_info_main "'aster' existed, pass"
    fi
  }

  check_newick_utilis() {
    if ! command -v nw_reroot >/dev/null 2>&1; then
      stage_error "'newick_utils' must be installed in your conda environment."
      stage_error "'newick_utils' is not found in your conda environment."
      stage_error "Please install 'newick_utils' in your conda environment."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    else
      stage_info_main "'newick_utilis' existed, pass"
    fi
  }

  check_py_install() {
    local pyinstall="$1"
    if pip show "${pyinstall}" >/dev/null 2>&1; then
      stage_info_main "Python dependency ${pyinstall} existed, pass"
    else
      stage_error "Python package "${pyinstall}" is not installed."
      stage_error "Recommended command for installation:"
      stage_error "pip install ${pyinstall}"
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
  }

  check_py_phylopypruner() {
      if pip show "phylopypruner" >/dev/null 2>&1; then
        stage_info_main "Python dependency 'phylopypruner' existed, pass"
      else
        stage_error "Python package 'phylopypruner' is not installed."
        stage_error "Recommended command for installation:"
        stage_error "pip install phylopypruner"
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      fi
  }

  stage_info_main "Checking dependencies in your conda environment..."
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
  check_paragone
  check_aster
  check_newick_utilis
  # check python
  check_py_install "PyQt5"
  check_py_install "ete3"
  check_py_install "pandas"
  check_py_install "seaborn"
  check_py_install "matplotlib"
  check_py_install "numpy"
  check_py_install "phylopypruner"
  stage_success "Well done!"
  stage_success "All dependencies have been successfully installed in your conda environment."
  stage_success "Proceeding to the next step..."
  stage_blank_main ""

  ######################################################
  ### Step 3: Check the inputs #########################
  ######################################################
  stage_info_main "=> Step 3: Check the inputs" 
  # 01-Check the form of the input list file
  stage_info_main "01-Check the form of the input list file (specified by '-input_list') ..."
  stage_info_main "Checking results:"
  found_public=$(awk -F'\t' '$2 ~ /^(SRR|ERR|DRR|KRR|LRR)/ { print 1; exit }' "${input_list}")
  found_own=$(awk -F'\t' '$2 == "A" { print 1; exit }' "${input_list}")
  found_pre=$(awk -F'\t' '$2 == "B" { print 1; exit }' "${input_list}")
  found_outgroup=$(awk -F'\t' '$3 == "Outgroup" { print 1; exit }' "${input_list}")
  found_other=$(awk -F'\t' '$2 !~ /^(SRR|ERR|DRR|KRR|LRR)/ && $2 != "A" && $2 != "B" { print 1; exit }' "${input_list}")
  if [ "${found_other}" = "1" ] || ([ "${found_public}" != "1" ] && [ "${found_own}" != "1" ] && [ "${found_pre}" != "1" ]); then
    if [ "${found_other}" = "1" ]; then
      stage_error "The second column of ${input_list} should start with 'SRR','ERR','DRR','KRR','LRR', or be 'A' or 'B'."
    elif [ "${found_public}" != "1" ] && [ "${found_own}" != "1" ] && [ "${found_pre}" != "1" ]; then
      stage_error "At least one type of data (public raw data/existing raw data/pre-assembled sequences) must be provided in ${input_list}."
    fi
    stage_error "HybSuite exits."
    stage_blank_main ""
    exit 1
  fi
  if [ "${found_outgroup}" != "1" ]; then
    stage_warning "No outgroup species name is provided (the third column) in ${input_list}."
    stage_warning "HybSuite will not reroot the phylogenetic tree in stage 4."
  fi
  if [ "${found_public}" = "1" ]; then
    stage_info_main "Public sample names to download are provided."
  elif [ "${found_own}" = "1" ]; then
    stage_info_main "The names of samples with existing raw data are provided."
  elif [ "${found_pre}" = "1" ]; then
    stage_info_main "The names of samples with pre-assembled sequences are provided."
  fi
  stage_info_main "PASS"

  if [ "${run_stage1}" = "TRUE" ] || [ "${full_pipeline}" = "TRUE" ]; then
    # 02-Check the input data
    stage_info_main "02-Checking the input data (specified by '-input_data') ..."
    stage_info_main "Checking results:"
    # Check if the path to the input data is provided.
    if ([ "${found_pre}" = "1" ] || [ "${found_own}" = "1" ]) && [ ! -d "${input_data}" ]; then
      stage_error "You need to specify the correct path to your data by using '-input_data'."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
    # Check if the input list is provided when users offer the input data
    if [ "${found_own}" = "1" ] && [ ! -d "${input_data}" ]; then
      stage_error "The names of samples with your existing raw data should be provided in the input data directory (${input_data})."
      stage_error "HybSuite exits."
      stage_blank_main ""
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
        stage_error "No FASTQ/FASTQ.GZ/FQ/FQ.GZ files found for sample $sample in the input data directory (${input_data})."
        stage_error "Please adjust the format of your input data to the acquired format (use -h to check the correct format)."
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      fi
    done
    awk -F'\t' '$2 == "B" {print $1}' "${input_list}" | while IFS= read -r sample; do
      if [ -s "${input_data}/${sample}.fasta" ]; then
        :
      else
        stage_error "No FASTA file found for sample $sample in the input data directory (${input_data})."
        stage_error "Please adjust the format of your input data to the acquired format (use -h to check the correct format)."
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      fi
    done
    stage_info_main "PASS"
  fi
  if [ -s "${t}" ]; then
    # 03-Check the target file
    stage_info_main "03-Checking the target file (specified by '-t') ..."
    stage_info_main "Checking results:"
    if [ ! -s "${t}" ] && [ "${run_to_stage1}" != "true" ]; then
      stage_error "The target file (reference for HybPiper) you specified does not exist."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    elif [ ! -s "${t}" ] && [ "${run_to_stage1}" = "true" ]; then
      stage_info_main "The target file is not provided. It is still OK since you only plan to run HybSuite stage 1."
    else
      ref_num=$(grep -c '>' "${t}")
      stage_info_main "The target file is (specified by '-t'): ${t}"
      stage_info_main "It contains ${ref_num} sequences"
      stage_info_main "PASS"
    fi
  fi
  
  # Deliver congratulations messages
  stage_success "Well done!"
  stage_success "All inputs are checked and no errors are found."
  stage_success "Proceeding to the next step ..."
  stage_blank_main ""
fi

if [ "${check}" = "TRUE" ]; then
  if [ -s "${input_list}" ]; then
    stage_info_main "=> Step 4: Check species checklists"
    all_sp_num=$(grep -c '^' "${input_list}" || wc -l < "${input_list}")
    all_genus_num=$(awk -F '_' '{print $1}' "${input_list}" | sort -u | grep -c '^')
    awk -F '_' '{print $1}' "${input_list}" | sort -u >> "${output_dir}/hybsuite_checklists/All_Genus_name_list.txt"
    if [ "${found_public}" = "1" ]; then
      SRR_sp_num=$(awk -F'\t' '$2 ~ /^(SRR|ERR|DRR|KRR|LRR)/' "${input_list}" | grep -c '^')
      SRR_genus_num=$(awk -F'\t' '$2 ~ /^(SRR|ERR|DRR|KRR|LRR)/ {print $1}' "${input_list}" | awk -F'_' '{print $1}' | sort -u | grep -c '^')
    fi
    if [ "${found_own}" = "1" ]; then
      Add_sp_num=$(awk -F'\t' '$2 == "A"' "${input_list}" | grep -c '^')
      Add_genus_num=$(awk -F'\t' '$2 == "A" {print $1}' "${input_list}" | awk -F'_' '{print $1}' | sort -u | grep -c '^')
    fi
    if [ "${found_pre}" = "1" ]; then
      Other_sp_num=$(awk -F'\t' '$2 == "B"' "${input_list}" | grep -c '^')
      Other_genus_num=$(awk -F'\t' '$2 == "B" {print $1}' "${input_list}" | awk -F'_' '{print $1}' | sort -u | grep -c '^')
    fi
    stage_info_main "Checking results:"
    stage_info_main "(1) Taxonomy:"
    stage_info_main "You plan to construct phylogenetic trees for ${all_sp_num} taxa belonging to ${all_genus_num} genera."
    stage_info_main "(2) Data sources:"
    if [ "${found_public}" = "1" ]; then
      stage_info_main "Downloaded raw data: ${SRR_sp_num} species from ${SRR_genus_num} genera."
    elif [ "${found_own}" = "1" ]; then
      stage_info_main "Your own raw data: ${Add_sp_num} species from ${Add_genus_num} genera."
    elif [ "${found_pre}" = "1" ]; then
      stage_info_main "Your pre-assembled sequences: ${Other_sp_num} species from ${Other_genus_num} genera."
    fi
  fi
  stage_info_main "All in all, final outputs will be saved to: ${output_dir}/"
  stage_info_main "Based on the above configuration:"
  stage_info_main_success "Confirm to execute HybSuite pipeline $1? ([y]/n)"
  read answer
  answer_HybSuite=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
  # Check the user's answers
  if [[ -z "$answer_HybSuite" || "$answer_HybSuite" = "y" ]]; then
    stage_blank_main ""
    stage_info_main "Initializing '$0 $1' analysis ..."
    stage_info_main_success "Starting processing - good luck with your analysis!"
    stage_blank_main ""
  elif [[ "$answer_HybSuite" = "n" ]]; then
      stage_blank_main ""
      stage_warning "Configuration may not meet your requirements"
      stage_warning "Suggested actions:"
      stage_warning "1. Adjust parameters via command-line options"
      stage_warning "2. Verify input file names and paths"
      stage_warning "HybSuite pipeline terminated by user request"
      stage_blank_main ""
      exit 0
  else
      stage_warning "Invalid input. Please answer with 'y' or 'n'."
      stage_warning "HybSuite pipeline terminated."
      stage_blank_main ""
      exit 1
  fi
fi

#===> Preparation <===#
# Create Folders：
### 01 Create the desired folder
stage_info "<<<======= Preparation: Create desired folders and define functions =======>>>"
if [ "${eas_dir}" = "_____" ]; then
  eas_dir="${output_dir}/01-Assembled_data"
  stage_info "Assembled data directory was not specified, set to: ${eas_dir} by default"
fi
if [ "${NGS_dir}" = "_____" ]; then
  NGS_dir="${output_dir}/NGS_dataset"
  stage_info "NGS dataset directory was not specified, set to: ${NGS_dir} by default"
fi
if [ -s "${input_list}" ]; then
  if [ -d "${output_dir}/hybsuite_checklists" ]; then
    rm "${output_dir}/hybsuite_checklists"/* > /dev/null 2>&1
  fi
  mkdir -p "${output_dir}/hybsuite_checklists"
  found_public=$(awk -F'\t' '$2 ~ /^(SRR|ERR|DRR|KRR|LRR)/ { print 1; exit }' "${input_list}")
  found_own=$(awk -F'\t' '$2 == "A" { print 1; exit }' "${input_list}")
  found_pre=$(awk -F'\t' '$2 == "B" { print 1; exit }' "${input_list}")
  found_outgroup=$(awk -F'\t' '$3 == "Outgroup" { print 1; exit }' "${input_list}")
  found_other=$(awk -F'\t' '$2 !~ /^(SRR|ERR|DRR|KRR|LRR)/ && $2 != "A" && $2 != "B" { print 1; exit }' "${input_list}")
  if [ "${found_public}" = "1" ]; then
    awk -F'\t' -v OFS='\t' '$2 ~ /^(SRR|ERR|DRR|KRR|LRR)/ {print $1, $2}' "${input_list}" > "${output_dir}/hybsuite_checklists/Public_Spname_SRR.txt"
    awk -F'\t' -v OFS='\t' '$2 ~ /^(SRR|ERR|DRR|KRR|LRR)/ {print $1}' "${input_list}" > "${output_dir}/hybsuite_checklists/Public_Spname.txt"
  fi
  if [ "${found_outgroup}" = "1" ]; then
    awk -F'\t' -v OFS='\t' '$3 == "Outgroup" {print $1}' "${input_list}" > "${output_dir}/hybsuite_checklists/Outgroup.txt"
  fi
  if [ "${found_own}" = "1" ]; then
    awk -F'\t' '$2 == "A" {print $1}' "${input_list}" > "${output_dir}/hybsuite_checklists/My_Spname.txt"
  fi
  if [ "${found_pre}" = "1" ]; then
    awk -F'\t' '$2 == "B" {print $1}' "${input_list}" > "${output_dir}/hybsuite_checklists/Pre-assembled_Spname.txt"
  fi
fi

# set the process:
if [ "${process}" != "all" ]; then
    trap "exec 1000>&-;exec 1000<&-;exit 0" 2
    FIFO_FILE=$$.fifo
    mkfifo $FIFO_FILE
    exec 1000<>$FIFO_FILE 
    rm -rf $FIFO_FILE
    process=${process}
    idx=0
    while [ $idx -lt $process ]; do
        echo>&1000
        idx=$((idx + 1))
    done
fi

# Define working directory (for stage 1-4)
work_dir="${output_dir}/hybsuite_logs"

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
          skipped_count=$((skipped_count + 1))
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
      skipped_samples=""
      skipped_times=""
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
          
          idx=0
          while [ $idx -lt $process_num ]; do
              echo >&1000
              idx=$((idx + 1))
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
      local failing_prefix="$2"

      if [ "${process}" = "all" ]; then
          stage_cmd "${log_mode}" "Processing log (by batches with all samples parallel processes):"
      else
          stage_cmd "${log_mode}" "Processing log (by batches with ${process} samples parallel processes):"
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
              current_batch=$(( current_batch + 1 ))
              if ! grep -q "^[SF]:${current_batch}:" "$temp_batch_log" 2>/dev/null; then
                  break
              fi
          fi
          
          # Get and display Started information for current batch
          grep "^S:${current_batch}:" "$temp_batch_log" 2>/dev/null | sed 's/^S:[0-9]*://' >> "$sorted_log"
          
          # Get and display Finished information for current batch
          grep "^F:${current_batch}:" "$temp_batch_log" 2>/dev/null | sed 's/^F:[0-9]*://' >> "$sorted_log"
          
          current_batch=$((current_batch + 1))
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
  # Function: Display only failed log
  display_only_failed_log() {
    local log_file="$1"
    local failing_prefix="$2"

    # Display failed sample information
      if [ -s "$failed_log" ]; then
          failed_time=$(cat "${failed_log}.time" 2>/dev/null || echo "[$(date '+%Y-%m-%d %H:%M:%S')]")
          failed_samples=$(tr '\n' ' ' < "$failed_log")
          sed -i "/*\[LOG\] ${failing_prefix}*/d" "$log_file"
          echo "${failed_time} [LOG] ${failing_prefix} ${failed_samples}" >> "$log_file"
      fi
  }

  #################===========================================================================
  
  # Function: Remove fasta with less than 4 seqs
  remove_fasta_with_less_than_4_seqs() {
    local target_dir=$1
    local log_file_name=$2

    > "${log_file_name}"
    echo -e "Removed_fasta_with_less_than_4_seqs:\tNumber_of_sequences" >> "${log_file_name}"
    for fasta_file in "${target_dir}"/*.fasta; do
      seq_count=$(grep -c "^>" "$fasta_file")
      if [ "$seq_count" -lt 4 ]; then
        echo -e "$fasta_file\t$seq_count" >> "${log_file_name}"
        rm -f "$fasta_file"
      fi
    done
  }

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

  replace_n() {
    local input_fasta=$1
    awk '
    BEGIN {
        gap = "-";
    }
    /^>/ {
        if (header) {
            print header;
            print processed_seq;
        }
        header = $0;
        seq = "";
        processed_seq = "";
        next;
    }
    {
        seq = seq $0;
    }
    END {
        if (header) {
            print header;
            gsub(/[Nn?]/, gap, seq);
            print seq;
        }
    }
    ' "$input_fasta" > "${input_fasta}.tmp" && 
    mv "${input_fasta}.tmp" "$input_fasta"
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
          stage_warning "MAFFT alignment failed: ${input}"
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

run_hmmcleaner() {
    local input_file=$1
    local cost=$2
    
    IFS='_' read -r cost1 cost2 cost3 cost4 <<< "$cost"
    seq_num=$(grep -c ">" "${input_file}")
    
    if (( $(echo "${cost1} < 0 && ${cost2} < 0 && ${cost3} > 0 && ${cost4} > 0 && \
             ${cost1} < ${cost2} && ${cost3} < ${cost4} && ${cost2} < ${cost3}" | bc -l) )); then
        if [ "${seq_num}" -lt 2 ]; then
            stage_blank_main ""
            stage_error "The number of sequences in ${input_file} is less than 2, Please check the input file."
        elif [ "${seq_num}" -lt 50 ]; then
            stage_cmd "${log_mode}" "HmmCleaner.pl ${input_file} -costs ${cost1} ${cost2} ${cost3} ${cost4} --noX"
            #HmmCleaner.pl "${input_file}" -costs ${cost1} ${cost2} ${cost3} ${cost4} --noX 2>&1 >/dev/null
            #script -q -c 'HmmCleaner.pl "${input_file}" -costs "${cost1}" "${cost2}" "${cost3}" "${cost4}" --noX' /dev/null | grep -v "WARNING"
            HmmCleaner.pl "${input_file}" -costs "${cost1}" "${cost2}" "${cost3}" "${cost4}" --noX 2>&1 >/dev/null | grep -v "WARNING\|at reader Bio\|line"
        else
            stage_cmd "${log_mode}" "HmmCleaner.pl ${input_file} -costs ${cost1} ${cost2} ${cost3} ${cost4} --noX --large"
            #HmmCleaner.pl "${input_file}" -costs ${cost1} ${cost2} ${cost3} ${cost4} --noX --large 2>&1 >/dev/null
            #script -q -c 'HmmCleaner.pl "${input_file}" -costs "${cost1}" "${cost2}" "${cost3}" "${cost4}" --noX --large' /dev/null | grep -v "WARNING"
            HmmCleaner.pl "${input_file}" -costs "${cost1}" "${cost2}" "${cost3}" "${cost4}" --noX --large 2>&1 >/dev/null | grep -v "WARNING\|at reader Bio\|line"
        fi
    else
        stage_blank_main ""
        stage_error "The cost values are not valid, Please check the cost values."
        stage_error "Expected format: negative_negative_positive_positive (e.g., -0.15_-0.08_0.15_0.45)"
        stage_error "Current value: $cost"
    fi
}
# Stage 1: NGS dataset construction
if [ "${run_stage1}" = "TRUE" ]; then
  ############################################################################################
  #===> Stage 1 NGS dataset construction <===#################################################
  ############################################################################################

  #################===========================================================================
  mkdir -p "${output_dir}/hybsuite_logs" "${output_dir}/hybsuite_checklists" "${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra" "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz" "${NGS_dir}/02-Downloaded_clean_data" "${NGS_dir}/03-My_clean_data"
  #################===========================================================================
  stage_info_main_purple "<<<======= Stage 1 NGS dataset construction=======>>>"
  #################===========================================================================

  ############################################################################################
  # Stage1-Step1: Download NGS raw data from NCBI via SRAToolKit (sra-tools) #################
  ############################################################################################
  # Use sratoolkit to batch download sra data, then use fasterq-dump to convert the original sra data to fastq/fastq.gz format, and decide whether to delete sra data according to the parameters provided by the user
  if [ -s "${output_dir}/hybsuite_checklists/Public_Spname_SRR.txt" ]; then
      # Define total samples number
      total_sps=$(awk 'NF' "${output_dir}/hybsuite_checklists/Public_Spname_SRR.txt" | grep -c '^')
      # Initialize parallel environment
      init_parallel_env "$work_dir" "$total_sps" "$process" "${output_dir}/hybsuite_checklists/Public_Spname_SRR.txt" || exit 1
      define_threads "pigz"
      define_threads "fasterq_dump"
      stage_info_main_blue "Step1: Downloading raw data for ${total_sps} samples with ${process_num} parallel processes from NCBI..."
      stage_info_main "====>> Running sratoolkit to download raw data (${process} in parallel) ====>>"
      while IFS= read -r sample || [ -n "$sample" ]; do
          spname=$(echo "${sample}" | awk '{print $1}')
          srr=$(echo "${sample}" | awk '{print $2}')
          if [ -s "${NGS_dir}/02-Downloaded_clean_data/${spname}_1_clean.paired.fq.gz" ] && [ -s "${NGS_dir}/02-Downloaded_clean_data/${spname}_2_clean.paired.fq.gz" ]; then
              check_paired_clean_data="TRUE"
          else
              check_paired_clean_data="FALSE"
          fi

          if [ -s "${NGS_dir}/02-Downloaded_clean_data/${spname}_clean.single.fq.gz" ]; then
              check_single_clean_data="TRUE"
          else
              check_single_clean_data="FALSE"
          fi

          if ([ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq.gz" ] && [ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq.gz" ]) || ([ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq" ] && [ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq" ]); then
              check_paired_raw_data="TRUE"
          else
              check_paired_raw_data="FALSE"
          fi

          if ([ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq.gz" ] || [ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq" ]); then
              check_single_raw_data="TRUE"
          else
              check_single_raw_data="FALSE"
          fi
          
          if [ "${process}" != "all" ]; then
              read -u1000
          fi
          # check the existed clean and raw data
          if [ "${check_paired_clean_data}" = "TRUE" ] || [ "${check_single_clean_data}" = "TRUE" ] || [ "${check_paired_raw_data}" = "TRUE" ] || [ "${check_single_raw_data}" = "TRUE" ]; then
              record_skipped_sample "$spname" "Skipped downloading existing samples:" "$stage_logfile"
              if [ "${process}" != "all" ]; then
                  echo >&1000
              fi
              continue
          fi
          {
              # Update start count
              update_start_count "$spname" "$stage_logfile"
              # download raw data
              if [ "$download_format" = "fastq_gz" ]; then
                  # prefetch
                  stage_cmd "${log_mode}" "prefetch ${srr} -O ${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra/ --max-size ${sra_maxsize}"
                  prefetch "$srr" -O "${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra/" --max-size "${sra_maxsize}" > /dev/null 2>&1

                  # fasterq-dump
                  if [ -s "${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra" ]; then
                    stage_cmd "${log_mode}" "fasterq-dump ${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra -e ${nt_fasterq_dump} -p -O ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/"
                    fasterq-dump ${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra -e ${nt_fasterq_dump} -p -O ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/ > /dev/null 2>&1
                  fi

                  # pigz for single-ended
                  if [ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq" ]; then
                      stage_cmd "${log_mode}" "pigz -p ${nt_pigz} ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq"
                      pigz -p ${nt_pigz} ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq > /dev/null 2>&1
                  fi

                  # pigz for pair-ended
                  if [ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq" ] && [ -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq" ]; then
                      stage_cmd "${log_mode}" "pigz -p ${nt_pigz} ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq"
                      pigz -p ${nt_pigz} ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq > /dev/null 2>&1
                      stage_cmd "${log_mode}" "pigz -p ${nt_pigz} ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq"
                      pigz -p ${nt_pigz} ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq > /dev/null 2>&1
                  fi

                  #remove the srr files
                  if [ "$rm_sra" != "FALSE" ]; then
                      if [ -d "${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}" ]; then
                          rm -r ${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}          
                      fi
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
                  stage_cmd "${log_mode}" "prefetch ${srr} -O ${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra/ --max-size ${sra_maxsize}"
                  prefetch "$srr" -O "${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra/" --max-size "${sra_maxsize}" > /dev/null 2>&1

                  # fasterq-dump
                  if [ -s "${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra" ]; then
                    stage_cmd "${log_mode}" "fasterq-dump ${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra -e ${nt_fasterq_dump} -p -O ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/"
                    fasterq-dump ${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra -e ${nt_fasterq_dump} -p -O ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/ > /dev/null 2>&1
                  fi

                  #remove the srr files
                  if [ "$rm_sra" != "FALSE" ]; then
                      if [ -d "${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}" ]; then
                          rm -r ${NGS_dir}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}          
                      fi
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
              if (([ ! -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq" ] || [ ! -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq" ]) && [ ! -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq" ]) && (([ ! -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq.gz" ] || [ ! -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq.gz" ]) && [ ! -s "${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq.gz" ]); then
                  record_failed_sample "$spname"
              else
                  # Update finish count
                  update_finish_count "$spname" "$stage_logfile"
              fi
              if [ "${process}" != "all" ]; then
                  echo >&1000
              fi
          } &
        if [ "${log_mode}" = "cmd" ] || [ "${log_mode}" = "full" ]; then
          display_only_failed_log "$stage_logfile" "Failed to download raw data:"
        fi
      done < "${output_dir}/hybsuite_checklists/Public_Spname_SRR.txt"
      # Wait for all tasks to complete
      wait
      echo
      # Display processing log
      if [ "${log_mode}" = "full" ]; then
        display_process_log "$stage_logfile" "Failed to download raw data:"
      fi
      stage_blank_main ""
  fi
  ############################################################################################

  ############################################################################################
  #Stage1-Step2: Remove the adapters via Trimmomatic #########################################
  ############################################################################################
  # Filter NGS raw data via trimmomatic
  # Raw data filtering of NCBI public data
  stage_info_main_blue "Step2: Removing adapters of raw data via Trimmomatic-0.39 ..."
  cd ${NGS_dir}
  define_threads "trimmomatic"
  if [ -s "${output_dir}/hybsuite_checklists/Public_Spname_SRR.txt" ]; then
      total_sps=$(awk 'NF' "${output_dir}/hybsuite_checklists/Public_Spname_SRR.txt" | grep -c '^')
      # Initialize parallel environment
      init_parallel_env "$work_dir" "$total_sps" "$process" "${output_dir}/hybsuite_checklists/Public_Spname_SRR.txt" || exit 1
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
                  stage_cmd "${log_mode}" "trimmomatic PE ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.f* ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.f* -threads ${nt_trimmomatic} -phred33 -basein ${spname} -baseout ${NGS_dir}/02-Downloaded_clean_data/${spname}_clean.paired.fq.gz ILLUMINACLIP:$CONDA_PREFIX/share/trimmomatic/adapters/TruSeq3-PE-2.fa:2:30:10 SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} LEADING:${trimmomatic_leading_quality} TRAILING:${trimmomatic_trailing_quality} MINLEN:${trimmomatic_min_length}"
                  trimmomatic PE \
                      -threads ${nt_trimmomatic} \
                      -phred33 \
                      ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.f* ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.f* \
                      ${NGS_dir}/02-Downloaded_clean_data/${spname}_1_clean.paired.fq.gz ${NGS_dir}/02-Downloaded_clean_data/${spname}_1_clean.unpaired.fq.gz \
                      ${NGS_dir}/02-Downloaded_clean_data/${spname}_2_clean.paired.fq.gz ${NGS_dir}/02-Downloaded_clean_data/${spname}_2_clean.unpaired.fq.gz \
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
                  stage_cmd "trimmomatic SE ${NGS_dir}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.f* -threads ${nt_trimmomatic} -phred33 -basein ${spname} -baseout ${NGS_dir}/02-Downloaded_clean_data/${spname}_clean.single.fq.gz ILLUMINACLIP:$CONDA_PREFIX/share/trimmomatic/adapters/TruSeq3-SE.fa:2:30:10 SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} LEADING:${trimmomatic_leading_quality} TRAILING:${trimmomatic_trailing_quality} MINLEN:${trimmomatic_min_length}"
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
        if [ "${log_mode}" = "cmd" ] || [ "${log_mode}" = "full" ]; then
          display_only_failed_log "$stage_logfile" "Failed to remove adapters for public samples:"
        fi
      done < "${output_dir}/hybsuite_checklists/Public_Spname_SRR.txt"
      wait
      echo
      # Display processing log
      if [ "${log_mode}" = "full" ]; then
        display_process_log "$stage_logfile" "Failed to remove adapters for public samples:"
      fi
      stage_blank_main ""
  fi

  if [ -s "${output_dir}/hybsuite_checklists/My_Spname.txt" ] && [ -e "${input_data}" ]; then
    # Define total samples number
    total_sps=$(awk 'NF' "${output_dir}/hybsuite_checklists/My_Spname.txt" | grep -c '^')
    # Initialize parallel environment
    init_parallel_env "$work_dir" "$total_sps" "$process" "${output_dir}/hybsuite_checklists/My_Spname.txt"
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
          files1=(${input_data}/${sample}_1.f*)
          files2=(${input_data}/${sample}_2.f*)
          if [ ${#files1[@]} -gt 0 ] && [ ${#files2[@]} -gt 0 ]; then
              stage_cmd "${log_mode}" "trimmomatic PE ${input_data}/${sample}_1.f* ${input_data}/${sample}_2.f* -threads ${nt_trimmomatic} -phred33 -basein ${sample} -baseout ${NGS_dir}/03-My_clean_data/${sample}_clean.paired.fq.gz ILLUMINACLIP:$CONDA_PREFIX/share/trimmomatic/adapters/TruSeq3-PE-2.fa:2:30:10 SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} LEADING:${trimmomatic_leading_quality} TRAILING:${trimmomatic_trailing_quality} MINLEN:${trimmomatic_min_length}"
              trimmomatic PE \
                  -threads ${nt_trimmomatic} \
                  -phred33 \
                  ${input_data}/${sample}_1.f* ${input_data}/${sample}_2.f* \
                  ${NGS_dir}/03-My_clean_data/${sample}_1_clean.paired.fq.gz ${NGS_dir}/03-My_clean_data/${sample}_1_clean.unpaired.fq.gz \
                  ${NGS_dir}/03-My_clean_data/${sample}_2_clean.paired.fq.gz ${NGS_dir}/03-My_clean_data/${sample}_2_clean.unpaired.fq.gz \
                  ILLUMINACLIP:$CONDA_PREFIX/share/trimmomatic/adapters/TruSeq3-PE-2.fa:2:30:10 \
                  SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} \
                  LEADING:${trimmomatic_leading_quality} \
                  TRAILING:${trimmomatic_trailing_quality} \
                  MINLEN:${trimmomatic_min_length} > /dev/null 2>&1
          fi
          #for single-ended 
          files3=(${input_data}/${sample}.f*)
          if [ ${#files3[@]} -gt 0 ]; then
              stage_cmd "${log_mode}" "trimmomatic SE -threads ${nt_trimmomatic} -phred33 ${input_data}/${sample}.f* ${NGS_dir}/03-My_clean_data/${sample}_clean.single.fq.gz ILLUMINACLIP:$CONDA_PREFIX/share/trimmomatic/adapters/TruSeq3-SE.fa:2:30:10 SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} LEADING:${trimmomatic_leading_quality} TRAILING:${trimmomatic_trailing_quality} MINLEN:${trimmomatic_min_length}"
              trimmomatic SE \
                  -threads ${nt_trimmomatic} \
                  -phred33 \
                  ${input_data}/${sample}.f* \
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
      if [ "${log_mode}" = "cmd" ] || [ "${log_mode}" = "full" ]; then
        display_only_failed_log "$stage_logfile" "Failed to remove adapters for user-provided samples:"
      fi
    done < "${output_dir}/hybsuite_checklists/My_Spname.txt"
    # Wait for all tasks to complete
    wait
    echo
    # Display processing log
    if [ "${log_mode}" = "full" ]; then
      display_process_log "$stage_logfile" "Failed to remove adapters for user-provided samples:"
    fi
    stage_blank_main ""
  fi

  ############################################################################################
  # End of Stage 1
  stage_info_main_success "Stage 1 completed: NGS database construction"
  stage_info_main_success "Output directories: ${NGS_dir}"
  stage_info_main_success " (1) Downloaded raw data: ${NGS_dir}/01-Downloaded_raw_data/"
  stage_info_main_success " (2) Downloaded clean data: ${NGS_dir}/02-Downloaded_clean_data/"
  stage_info_main_success " (3) User-provided samples' clean data: ${NGS_dir}/03-My_clean_data/"
  ############################################################################################
  if [ "${full_pipeline}" = "FALSE" ]; then
    # Clean up environment
    cleanup_parallel_env "$work_dir"
    stage_success "HybSuite execution completed successfully, please reference our publication in your work."
    stage_blank_main ""
    exit 0
  elif [ "${full_pipeline}" = "TRUE" ]; then
    stage_info_main "Now moving on to the next stage ..."
    stage_blank_main ""
  fi
  ############################################################################################
fi


############################################################################################
# Stage 2 Data assembly and filtering ######################################################
############################################################################################
if [ "${run_stage2}" = "TRUE" ] || [ "${full_pipeline}" = "TRUE" ]; then
  ############################################################################################
  # 0.Preparation
  # (1) Change working directory and conda environment
  mkdir -p "${eas_dir}"
  cd "${eas_dir}"
  stage_info_main_purple "<<<======= Stage 2 Data assembly and filtering =======>>>"
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
    cp "${output_dir}/hybsuite_checklists/Public_Spname.txt" "${eas_dir}/Assembled_data_namelist.txt"
  elif [ "${found_own}" = "1" ] && [ "${found_public}" != "1" ]; then
    # When only custom data exists, use My_Spname directly
    cp "${output_dir}/hybsuite_checklists/My_Spname.txt" "${eas_dir}/Assembled_data_namelist.txt"
  elif [ "${found_own}" = "1" ] && [ "${found_public}" = "1" ]; then
    # When both types of data exist, merge the lists
    cat "${output_dir}/hybsuite_checklists/Public_Spname.txt" "${output_dir}/hybsuite_checklists/My_Spname.txt" | sed '/^$/d' > "${eas_dir}/Assembled_data_namelist.txt"
  fi
  #################===========================================================================


  ############################################################################################
  #Stage2-Step1: Data assembly ###############################################################
  ############################################################################################

  #################===========================================================================
  stage_info_main_blue "Step 1: Assembling data using 'hybpiper assemble'..."
  cd "${eas_dir}"
  #################===========================================================================
  if [ "${found_public}" = "1" ]; then
    total_sps=$(awk 'END {print NR}' "${output_dir}/hybsuite_checklists/Public_Spname.txt")
    init_parallel_env "$work_dir" "$total_sps" "$process" "${output_dir}/hybsuite_checklists/Public_Spname.txt" || exit 1
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
              stage_cmd "${log_mode}" "hybpiper assemble -t_${hybpiper_tt} ${t} -r ${NGS_dir}/02-Downloaded_clean_data/${Spname}_1_clean.paired.fq.gz ${NGS_dir}/02-Downloaded_clean_data/${Spname}_2_clean.paired.fq.gz -o ${eas_dir} --prefix ${Spname} --diamond --cpu ${nt_hybpiper}"
              hybpiper assemble "-t_${hybpiper_tt}" ${t} \
              -r ${NGS_dir}/02-Downloaded_clean_data/${Spname}_1_clean.paired.fq.gz ${NGS_dir}/02-Downloaded_clean_data/${Spname}_2_clean.paired.fq.gz \
              -o ${eas_dir} \
              --prefix ${Spname} \
              --diamond \
              --cpu ${nt_hybpiper} > /dev/null 2>&1
          fi
          # Use BLASTx (default) to map reads
          if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "blast" ]; then
              stage_cmd "${log_mode}" "hybpiper assemble -t_${hybpiper_tt} ${t} -r ${NGS_dir}/02-Downloaded_clean_data/${Spname}_1_clean.paired.fq.gz ${NGS_dir}/02-Downloaded_clean_data/${Spname}_2_clean.paired.fq.gz -o ${eas_dir} --prefix ${Spname} --cpu ${nt_hybpiper}"
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
      if [ "${log_mode}" = "cmd" ] || [ "${log_mode}" = "full" ]; then
        display_only_failed_log "$stage_logfile" "Failed to assemble data for public samples:"
      fi
    done < "${output_dir}/hybsuite_checklists/Public_Spname.txt"
    # Wait for all tasks to complete
    wait
    echo
    # Display processing log
    if [ "${log_mode}" = "full" ]; then
      display_process_log "$stage_logfile" "Failed to assemble data for public samples:"
    fi
  fi

  if [ -s "${output_dir}/hybsuite_checklists/My_Spname.txt" ]; then
    total_sps=$(awk 'END {print NR}' "${output_dir}/hybsuite_checklists/My_Spname.txt")
    init_parallel_env "$work_dir" "$total_sps" "$process" "${output_dir}/hybsuite_checklists/My_Spname.txt" || exit 1
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
      if [ "${log_mode}" = "cmd" ] || [ "${log_mode}" = "full" ]; then
        display_only_failed_log "$stage_logfile" "Failed to assemble data for user-provided samples:"
      fi
    done < "${output_dir}/hybsuite_checklists/My_Spname.txt"
    # Wait for all tasks to complete
    wait
    echo
    # Display processing log
    if [ "${log_mode}" = "full" ]; then
      display_process_log "$stage_logfile" "Failed to assemble data for user-provided samples:"
    fi
  fi

  grep '>' ${t} | awk -F'-' '{print $NF}' | sort | uniq > "${output_dir}/hybsuite_checklists/Ref_gene_name_list.txt"
  # Recovered_locus_num_for_samples.tsv
  stage_info_main "Generating the tsv file listing the number of recovered loci for each sample..."
  printf "Sample\tRecovered_locus_num\n" > "${output_dir}/hybsuite_checklists/Recovered_locus_num_for_samples.tsv"
  while IFS= read -r Spname || [ -n "$Spname" ]; do
    if [ -s "${eas_dir}/${Spname}/genes_with_seqs.txt" ]; then
        printf "%s\t%s\n" "$Spname" "$(wc -l < "${eas_dir}/${Spname}/genes_with_seqs.txt")" >> "${output_dir}/hybsuite_checklists/Recovered_locus_num_for_samples.tsv"
    else
        printf "%s\t0\n" "$Spname" >> "${output_dir}/hybsuite_checklists/Recovered_locus_num_for_samples.tsv"
    fi
  done < "${eas_dir}/Assembled_data_namelist.txt"
  if [ -s "${output_dir}/hybsuite_checklists/Recovered_locus_num_for_samples.tsv" ]; then
    stage_info_main "Succeed -> ${output_dir}/hybsuite_checklists/Recovered_locus_num_for_samples.tsv"
  else
    stage_warning "Failed to generate the tsv file listing the number of recovered loci for each sample."
  fi
  
  # Recovered_sample_num_for_loci.tsv
  stage_info_main "Generating the tsv file listing the number of recovered samples for each locus..."
  printf "Locus\tRecovered_sample_num\n" > "${output_dir}/hybsuite_checklists/Recovered_sample_num_for_loci.tsv"
  while IFS= read -r locus || [ -n "$locus" ]; do
    count=0
    while IFS= read -r Spname || [ -n "$Spname" ]; do
        if [ -s "${eas_dir}/${Spname}/genes_with_seqs.txt" ]; then
            if grep -qE "^$locus\b" "${eas_dir}/${Spname}/genes_with_seqs.txt"; then
                count=$((count + 1))
            fi
        fi
    done < "${eas_dir}/Assembled_data_namelist.txt"
   printf "%s\t%d\n" "$locus" "$count"  >> "${output_dir}/hybsuite_checklists/Recovered_sample_num_for_loci.tsv"
  done < "${output_dir}/hybsuite_checklists/Ref_gene_name_list.txt"
  if [ -s "${output_dir}/hybsuite_checklists/Recovered_sample_num_for_loci.tsv" ]; then
    stage_info_main "Succeed -> ${output_dir}/hybsuite_checklists/Recovered_sample_num_for_loci.tsv"
  else
    stage_warning "Failed to generating the tsv file listing the number of recovered samples for each locus"
  fi
  stage_blank_main ""

  ############################################################################################
  #Stage2-Step2: retrieving all original paralogs via HybPiper ###################################
  ############################################################################################

  #################===========================================================================
    stage_info_main_blue "Step 2: retrieving all putative paralogs via HybPiper..."
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
      stage_error "Failed to retrieve putative paralogs via HybPiper."
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
      process_add = "1"
      stage_info_main "Optional step: Adding other sequences with single copy orthologs ..."
      stage_info_main "====>> Adding other sequences with single copy orthologs (${process_add} in parallel) ====>>"
      
      # 01-Initialize parallel environment
      total_sps=$(grep -c '^' "${output_dir}/hybsuite_checklists/Pre-assembled_Spname.txt")
      
      init_parallel_env "$work_dir" "$total_sps" "$process_add" "${output_dir}/hybsuite_checklists/Pre-assembled_Spname.txt" || exit 1
      # 02-Run the main loop
      while IFS= read -r add_sp || [ -n "$add_sp" ]; do
        total_genes=$(awk 'END {print NR}' "${output_dir}/hybsuite_checklists/Ref_gene_name_list.txt")
        if [ "${process_add}" != "all" ]; then
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
        done < "${output_dir}/hybsuite_checklists/Ref_gene_name_list.txt"
        find . -type f -name "*.fa" -exec rm -f {} +
        # Update failed sample list
        if ! grep -q "${add_sp}" "${output_dir}"/02-All_paralogs/01-Original_paralogs/*_paralogs_all.fasta; then
            record_failed_sample "$add_sp"
        else
            # Update finish count
            update_finish_count "$add_sp" "$stage_logfile"
        fi
        if [ "${process_add}" != "all" ]; then
              echo >&1000
        fi
        } &
        if [ "${log_mode}" = "cmd" ] || [ "${log_mode}" = "full" ]; then
          display_only_failed_log "$stage_logfile" "Failed to integrate pre-assembled sequences into all putative paralogs:"
        fi
      done < "${output_dir}/hybsuite_checklists/Pre-assembled_Spname.txt"
      wait
      echo
      # 03-Display processing log
      if [ "${log_mode}" = "full" ]; then
        display_process_log "$stage_logfile" "Failed to integrate pre-assembled sequences into all putative paralogs:"
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
    stage_info_main_blue "Step 3: Filtering paralogs by length, locus and sample coverage..."
    mkdir -p "${output_dir}/02-All_paralogs/03-Filtered_paralogs" "${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap"
    cd "${eas_dir}"
  #################===========================================================================
    # 01-Removing paralogs with low length
    stage_info_main "01-Removing paralogs with low length via 'filter_seqs_by_length.py'..."
    stage_cmd "${log_mode}" "python ${script_dir}/filter_seqs_by_length.py -i ${output_dir}/02-All_paralogs/01-Original_paralogs -or ${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Removed_paralogs_with_low_length_info.tsv --output_dir ${output_dir}/02-All_paralogs/03-Filtered_paralogs --ref ${t} --min_length ${seqs_min_length} --mean_length_ratio ${seqs_mean_length_ratio} --max_length_ratio ${seqs_max_length_ratio} --threads ${nt}"
    stage2_01="python ${script_dir}/filter_seqs_by_length.py \
    -i ${output_dir}/02-All_paralogs/01-Original_paralogs \
    -or ${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Removed_paralogs_with_low_length_info.tsv \
    --output_dir ${output_dir}/02-All_paralogs/03-Filtered_paralogs \
    --ref ${t} \
    --min_length ${seqs_min_length} \
    --mean_length_ratio ${seqs_mean_length_ratio} \
    --max_length_ratio ${seqs_max_length_ratio} \
    --threads ${nt}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage2_01}"
    else
      eval "${stage2_01} > /dev/null 2>&1"
    fi

    # 02-Removing taxa with low locus coverage and loci with low sample coverage
    stage_info_main "02-Removing taxa with low locus coverage and loci with low sample coverage via 'filter_seqs_by_sample_and_locus_coverage.py'..."
    stage_cmd "${log_mode}" "python ${script_dir}/filter_seqs_by_sample_and_locus_coverage.py -i ${output_dir}/02-All_paralogs/03-Filtered_paralogs --min_locus_coverage ${seqs_sample_filter} --min_sample_coverage ${seqs_locus_filter} --removed_samples_info ${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Removed_samples_with_low_locus_coverage_info.tsv --removed_loci_info ${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Removed_loci_with_low_sample_coverage_info.tsv --threads ${nt}"
    stage2_02="python ${script_dir}/filter_seqs_by_sample_and_locus_coverage.py \
    -i ${output_dir}/02-All_paralogs/03-Filtered_paralogs \
    --min_locus_coverage ${seqs_sample_filter} \
    --min_sample_coverage ${seqs_locus_filter} \
    --removed_samples_info ${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Removed_samples_with_low_locus_coverage_info.tsv \
    --removed_loci_info ${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Removed_loci_with_low_sample_coverage_info.tsv \
    --threads ${nt}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage2_02}"
    else
      eval "${stage2_02} > /dev/null 2>&1"
    fi

    stage_info_main "03-Removing fasta with less than 4 sequences ..."
    remove_fasta_with_less_than_4_seqs "${output_dir}/02-All_paralogs/03-Filtered_paralogs" "${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Removed_all_paralogs_files_with_less_than_4_seqs.tsv"

    stage_info "${log_mode}" "Finish"
    stage_info "${log_mode}" "The information of removed paralog sequences with low length has been written to:"
    stage_info "${log_mode}" "${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Removed_paralogs_with_low_length_info.tsv"
    stage_info "${log_mode}" "The information of removed taxa with low locus coverage has been written to:"
    stage_info "${log_mode}" "${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Removed_samples_with_low_locus_coverage_info.tsv"
    stage_info "${log_mode}" "The information of removed loci with low sample coverage has been written to:"
    stage_info "${log_mode}" "${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Removed_loci_with_low_sample_coverage_info.tsv"
    stage_info "${log_mode}" "The information of removed all paralogs files with less than 4 sequences has been written to:"
    stage_info "${log_mode}" "${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Removed_all_paralogs_files_with_less_than_4_seqs.tsv"
    
    stage_blank_main ""
    
    ############################################################################################
    #Stage2-Step4: Producing the paralog report and plotting the paralog heatmap ###############
    ############################################################################################
    stage_info_main_blue "Step 4: Producing the paralog report and plotting the paralog heatmap..."
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
    if [ -s "${output_dir}/02-All_paralogs/02-Original_paralog_reports_and_heatmap/Original_paralog_heatmap.png" ]; then
      stage_info_main "Succeed -> ${output_dir}/02-All_paralogs/02-Original_paralog_reports_and_heatmap/Original_paralog_heatmap.png"
    else
      stage_warning "Fail to produce the paralogs heatmap for the original paralogs."
    fi
    if [ -s "${output_dir}/02-All_paralogs/02-Original_paralog_reports_and_heatmap/Original_paralog_report.tsv" ]; then
      stage_info_main "Succeed -> ${output_dir}/02-All_paralogs/02-Original_paralog_reports_and_heatmap/Original_paralog_report.tsv"
    else
      stage_warning "Fail to produce the paralogs report for the original paralogs."
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
    if [ -s "${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_paralog_heatmap.png" ]; then
      stage_info_main "Succeed -> ${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_paralog_heatmap.png"
    else
      stage_warning "Fail to produce the paralogs heatmap for the filtered paralogs."
    fi
    if [ -s "${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_paralog_report.tsv" ]; then
      stage_info_main "Succeed -> ${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_paralog_report.tsv"
    else
      stage_warning "Fail to produce the paralogs report for the filtered paralogs."
    fi
    stage_blank_main ""

  ############################################################################################
  # End of Stage 2
  stage_info_main_success "Stage 2 completed: Data assembly and filtering."
  stage_info_main_success "Output directorie 1: ${output_dir}/01-Assembled_data/"  
  stage_info_main_success "(1) HybPiper assembled data directory: ${output_dir}/01-Assembled_data/<sample_name>"
  stage_info_main_success "Output directorie 2: ${output_dir}/02-All_paralogs/"
  stage_info_main_success "(1) Original paralogs: ${output_dir}/02-All_paralogs/01-Original_paralogs/"
  stage_info_main_success "(2) Original paralog reports and heatmap: ${output_dir}/02-All_paralogs/02-Original_paralog_reports_and_heatmap"
  stage_info_main_success "(3) Filtered paralogs: ${output_dir}/02-All_paralogs/03-Filtered_paralogs/"
  stage_info_main_success "(4) Filtered paralogs reports and heatmap: ${output_dir}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap"
  if [ "${full_pipeline}" = "FALSE" ]; then
    # Clean up environment
    cleanup_parallel_env "$work_dir"
    stage_success "HybSuite execution completed successfully, please reference our publication in your work."
    stage_blank_main ""
    exit 0
  else
    stage_info_main "Moving on to the next stage..."
    stage_blank_main ""
  fi
fi

############################################################################################

############################################################################################
# Stage 3 Paralogs handling ################################################################
############################################################################################
if [ "${run_stage3}" = "TRUE" ] || [ "${full_pipeline}" = "TRUE" ]; then
  #################===========================================================================
  # 0.Preparation
  stage_info_main_purple "<<<======= Stage 3 Paralogs handling =======>>>"
  if [ "${full_pipeline}" = "TRUE" ]; then
    paralogs_dir="${output_dir}/02-All_paralogs/03-Filtered_paralogs"
  fi
  #################===========================================================================
  
  #################===========================================================================
  # Function retrieve_hybpiper_sequences()
  retrieve_hybpiper_sequences() {
    ortho_method="$1"
    
    mkdir -p "${output_dir}/03-Paralogs_handling/${ortho_method}/01-Original_${ortho_method}_sequences/"
    stage_cmd "${log_mode}" "hybpiper retrieve_sequences "-t_${hybpiper_tt}" ${t} dna --sample_names ${eas_dir}/Assembled_data_namelist.txt --fasta_dir ${output_dir}/03-Paralogs_handling/${ortho_method}/01-Original_${ortho_method}_sequences/"
    hybpiper retrieve_sequences "-t_${hybpiper_tt}" ${t} dna \
    --hybpiper_dir "${eas_dir}" \
    --sample_names ${eas_dir}/Assembled_data_namelist.txt \
    --fasta_dir ${output_dir}/03-Paralogs_handling/${ortho_method}/01-Original_${ortho_method}_sequences/ > /dev/null 2>&1
    if find "${output_dir}/03-Paralogs_handling/${ortho_method}/01-Original_${ortho_method}_sequences/" -type f -name "*.FNA" -size +0c -quit 2>/dev/null; then
      stage_success "Finished."
      stage_blank_main ""
    else
      stage_error "Sequence retrieval via HybPiper failed. Ensure ${eas_dir} has assembled data folders."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
  }  
  #################===========================================================================

  #################===========================================================================
  # Function filter_seqs_by_llsc()
  filter_seqs_by_llsc() {
    local ortho_method="$1"
    
    mkdir -p "${output_dir}/03-Paralogs_handling/${ortho_method}/03-Filtered_${ortho_method}_sequences/" "${output_dir}/03-Paralogs_handling/${ortho_method}/04-Filtered_${ortho_method}_sequences_reports_and_heatmap/"
    # 01-Removing ${ortho_method} sequences with low length
    stage_info_main "01-Removing ${ortho_method} sequences with low length..."
    stage_cmd "${log_mode}" "python ${script_dir}/filter_seqs_by_length.py -i ${output_dir}/03-Paralogs_handling/${ortho_method}/01-Original_${ortho_method}_sequences/ -or ${output_dir}/03-Paralogs_handling/${ortho_method}/04-Filtered_${ortho_method}_sequences_reports_and_heatmap/Removed_${ortho_method}_seqs_with_low_length_info.tsv --output_dir ${output_dir}/03-Paralogs_handling/${ortho_method}/03-Filtered_${ortho_method}_sequences/ --ref ${t} --min_length ${seqs_min_length} --mean_length_ratio ${seqs_mean_length_ratio} --max_length_ratio ${seqs_max_length_ratio} --threads ${nt}"
    stage3_01="python ${script_dir}/filter_seqs_by_length.py \
    -i ${output_dir}/03-Paralogs_handling/${ortho_method}/01-Original_${ortho_method}_sequences/ \
    -or ${output_dir}/03-Paralogs_handling/${ortho_method}/04-Filtered_${ortho_method}_sequences_reports_and_heatmap/Removed_${ortho_method}_seqs_with_low_length_info.tsv \
    --output_dir ${output_dir}/03-Paralogs_handling/${ortho_method}/03-Filtered_${ortho_method}_sequences/ \
    --ref ${t} \
    --min_length ${seqs_min_length} \
    --mean_length_ratio ${seqs_mean_length_ratio} \
    --max_length_ratio ${seqs_max_length_ratio} \
    --threads ${nt}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage3_01}"
    else
      eval "${stage3_01} > /dev/null 2>&1"
    fi

    if ! find "${output_dir}/03-Paralogs_handling/${ortho_method}/03-Filtered_${ortho_method}_sequences/" -maxdepth 1 -type f -name "*.FNA" | grep -q .; then
      stage_error "Failed to Remove ${ortho_method} sequences with length than ${seqs_min_length}."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    else
      if [ -s "${output_dir}/03-Paralogs_handling/${ortho_method}/04-Filtered_${ortho_method}_sequences_reports_and_heatmap/Removed_${ortho_method}_seqs_with_low_length_info.tsv" ]; then
        stage_info_main "The information of removed ${ortho_method} sequences with low length has been written to:"
        stage_info_main "${output_dir}/03-Paralogs_handling/${ortho_method}/04-Filtered_${ortho_method}_sequences_reports_and_heatmap/Removed_${ortho_method}_seqs_with_low_length_info.tsv"
      else
        stage_info_main "No ${ortho_method} sequence with low length was removed."
      fi
    fi

    # Step 2.2: Removing samples with low locus coverage and loci with low sample coverage
    stage_info_main "02-Removing taxa with low locus coverage and loci with low sample coverage..."
    stage_cmd "${log_mode}" "python ${script_dir}/filter_seqs_by_sample_and_locus_coverage.py -i ${output_dir}/03-Paralogs_handling/${ortho_method}/03-Filtered_${ortho_method}_sequences/ --min_locus_coverage ${seqs_sample_filter} --min_sample_coverage ${seqs_locus_filter} --removed_samples_info ${output_dir}/03-Paralogs_handling/${ortho_method}/04-Filtered_${ortho_method}_sequences_reports_and_heatmap/Removed_samples_with_low_locus_coverage_info.tsv --removed_loci_info ${output_dir}/03-Paralogs_handling/${ortho_method}/04-Filtered_${ortho_method}_sequences_reports_and_heatmap/Removed_loci_with_low_sample_coverage_info.tsv --threads ${nt}"
    stage3_02="python ${script_dir}/filter_seqs_by_sample_and_locus_coverage.py \
    -i ${output_dir}/03-Paralogs_handling/${ortho_method}/03-Filtered_${ortho_method}_sequences/ \
    --min_locus_coverage ${seqs_sample_filter} \
    --min_sample_coverage ${seqs_locus_filter} \
    --removed_samples_info ${output_dir}/03-Paralogs_handling/${ortho_method}/04-Filtered_${ortho_method}_sequences_reports_and_heatmap/Removed_samples_with_low_locus_coverage_info.tsv \
    --removed_loci_info ${output_dir}/03-Paralogs_handling/${ortho_method}/04-Filtered_${ortho_method}_sequences_reports_and_heatmap/Removed_loci_with_low_sample_coverage_info.tsv \
    --threads ${nt}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage3_02}"
    else
      eval "${stage3_02} > /dev/null 2>&1"
    fi

    if ! find "${output_dir}/03-Paralogs_handling/${ortho_method}/03-Filtered_${ortho_method}_sequences/" -maxdepth 1 -type f -name "*.FNA" | grep -q .; then
      stage_error "Failed to Remove ${ortho_method} sequences with length than ${seqs_min_length}."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    else
      if [ -s "${output_dir}/03-Paralogs_handling/${ortho_method}/04-Filtered_${ortho_method}_sequences_reports_and_heatmap/Removed_samples_with_low_locus_coverage_info.tsv" ]; then
        stage_info_main "The information of removed taxa with low locus coverage has been written to:"
        stage_info_main "${output_dir}/03-Paralogs_handling/${ortho_method}/04-Filtered_${ortho_method}_sequences_reports_and_heatmap/Removed_samples_with_low_locus_coverage_info.tsv"
      else
        stage_info_main "No sample was removed."
      fi
      if [ -s "${output_dir}/03-Paralogs_handling/${ortho_method}/04-Filtered_${ortho_method}_sequences_reports_and_heatmap/Removed_loci_with_low_sample_coverage_info.tsv" ]; then
        stage_info_main "The information of removed loci with low sample coverage has been written to:"
        stage_info_main "${output_dir}/03-Paralogs_handling/${ortho_method}/04-Filtered_${ortho_method}_sequences_reports_and_heatmap/Removed_loci_with_low_sample_coverage_info.tsv"
      else
        stage_info_main "No locus was removed."
      fi
      stage_success "Finished."
      stage_blank_main ""
    fi
  }
  #################===========================================================================

  #################===========================================================================
  # Function MSA_and_trim()
  MSA_and_trim() {
    local ortho_method="$1"
    local seq_dir="$2"
    local seq_suffix="$3"

    # 01-Aligning ${ortho_method} sequences via MAFFT...
    stage_info_main "01-Aligning ${ortho_method} sequences via MAFFT..."
    stage_info_main "====>> Aligning ${ortho_method} sequences via MAFFT (${process} in parallel) ====>>"
    cd "${seq_dir}"
    if [ -d "${output_dir}/04-Alignments/${ortho_method}" ]; then
      rm -rf "${output_dir}/04-Alignments/${ortho_method}"
    fi
    mkdir -p "${output_dir}/04-Alignments/${ortho_method}"
    temp_file="fna_file_list.txt"
    find . -maxdepth 1 -type f -name "*.${seq_suffix}" -exec basename {} \; > "$temp_file"
    total_sps=$(wc -l < "$temp_file")
    init_parallel_env "$work_dir" "$total_sps" "$process" "$temp_file" || exit 1
    while IFS= read -r file || [ -n "$file" ]; do
      if [ "${process}" != "all" ]; then
        read -u1000
      fi
      {
      if [ "${run_paragone}" = "TRUE" ] && ([ "${ortho_method}" = "MO" ] || [ "${ortho_method}" = "MI" ] || [ "${ortho_method}" = "RT" ] || [ "${ortho_method}" = "1to1" ]); then 
        file_name=$(basename "${file}" ."selected_stripped.aln.trimmed.fasta")
      elif [ "${run_phylopypruner}" = "TRUE" ] && ([ "${ortho_method}" = "LS" ] || [ "${ortho_method}" = "MO" ] || [ "${ortho_method}" = "MI" ] || [ "${ortho_method}" = "RT" ] || [ "${ortho_method}" = "1to1" ]); then
        file_name="${file%%.*}"
        file_name="${file_name%_paralogs_all*}"
      elif [ "${ortho_method}" = "HRS" ] || [ "${ortho_method}" = "RLWP" ]; then
        file_name="${file%.FNA}"
      fi
      # Update start count
      update_start_count "$file_name" "$stage_logfile"
      sed -e 's/ single_hit//g;s/ multi_hit_stitched_contig_comprising_.*_hits//g' "${file}" > "${output_dir}/04-Alignments/${ortho_method}/${file_name}.fasta"
      run_mafft "${output_dir}/04-Alignments/${ortho_method}/${file_name}.fasta" "${output_dir}/04-Alignments/${ortho_method}/${file_name}.aln.fasta" "${nt_mafft}"
      rm -f "${output_dir}/04-Alignments/${ortho_method}/${file_name}.fasta"
      remove_n "${output_dir}/04-Alignments/${ortho_method}/${file_name}.aln.fasta"
      if [ "${replace_n}" = "TRUE" ]; then
        replace_n "${output_dir}/04-Alignments/${ortho_method}/${file_name}.aln.fasta"
      fi
      # Update failed count
      if [ ! -s "${output_dir}/04-Alignments/${ortho_method}/${file_name}.aln.fasta" ]; then
        record_failed_sample "$file_name"
      else
        # Update finish count
        update_finish_count "$file_name" "$stage_logfile"
      fi
      if [ "${process}" != "all" ]; then
        echo >&1000
      fi
      } &
      if [ "${log_mode}" = "cmd" ] || [ "${log_mode}" = "full" ]; then
        display_only_failed_log "$stage_logfile" "Failed to align ${ortho_method} sequences via MAFFT:"
      fi
    done < "$temp_file"
    wait
    echo
    # Display processing log
    if [ "${log_mode}" = "full" ]; then
      display_process_log "$stage_logfile" "Failed to align ${ortho_method} sequences via MAFFT:"
    fi
    if ! find "${output_dir}/04-Alignments/${ortho_method}/" -maxdepth 1 -type f -name "*.fasta" | grep -q .; then
      stage_error "No any alignments were generated in ${output_dir}/04-Alignments/${ortho_method}/."
      stage_error "Please check the parameters for MAFFT."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
    
    # 02-Trimming ${ortho_method} alignments via trimAl
    if [ "${trim_tool}" = "1" ]; then
      stage_info_main "02-Trimming ${ortho_method} alignments via trimAl..."
      stage_info_main "====>> Trimming ${ortho_method} alignments via trimAl (${process} in parallel) ====>>"
    elif [ "${trim_tool}" = "2" ]; then
      stage_info_main "02-Trimming ${ortho_method} alignments via HMMCleaner..."
      stage_info_main "====>> Trimming ${ortho_method} alignments via HMMCleaner (${process} in parallel) ====>>"
    fi
    
    rm -rf "${output_dir}/05-Trimmed_alignments/${ortho_method}"
    mkdir -p "${output_dir}/05-Trimmed_alignments/${ortho_method}"
    temp_file="fna_file_list.txt"
    find . -maxdepth 1 -type f -name "*.${seq_suffix}" -exec basename {} \; > "$temp_file"
    total_sps=$(wc -l < "$temp_file")
    init_parallel_env "$work_dir" "$total_sps" "$process" "$temp_file" || exit 1
    while IFS= read -r file || [ -n "$file" ]; do
      if [ "${process}" != "all" ]; then
        read -u1000
      fi
      {
        if [ "${run_paragone}" = "TRUE" ] && ([ "${ortho_method}" = "MO" ] || [ "${ortho_method}" = "MI" ] || [ "${ortho_method}" = "RT" ] || [ "${ortho_method}" = "1to1" ]); then 
          file_name=$(basename "${file}" ."selected_stripped.aln.trimmed.fasta")
        elif [ "${run_phylopypruner}" = "TRUE" ] && ([ "${ortho_method}" = "LS" ] || [ "${ortho_method}" = "MO" ] || [ "${ortho_method}" = "MI" ] || [ "${ortho_method}" = "RT" ] || [ "${ortho_method}" = "1to1" ]); then
          file_name="${file%%.*}"
          file_name="${file_name%_paralogs_all*}"
        elif [ "${ortho_method}" = "HRS" ] || [ "${ortho_method}" = "RLWP" ]; then
          file_name="${file%.FNA}"
        fi
        # Update start count
        update_start_count "$file_name" "$stage_logfile"
        if [ "${trim_tool}" = "1" ]; then
          run_trimal "${output_dir}/04-Alignments/${ortho_method}/${file_name}.aln.fasta" "${output_dir}/05-Trimmed_alignments/${ortho_method}/${file_name}.aln.trimmed.fasta" "${trimal_mode}" \
          "${trimal_gapthreshold}" "${trimal_simthreshold}" "${trimal_cons}" "${trimal_block}" "${trimal_resoverlap}" "${trimal_seqoverlap}" \
          "${trimal_w}" "${trimal_gw}" "${trimal_sw}"
          if [ ! -s "${output_dir}/05-Trimmed_alignments/${ortho_method}/${file_name}.aln.trimmed.fasta" ]; then
            record_failed_sample "$file_name"
          else
            update_finish_count "$file_name" "$stage_logfile"
          fi
        fi
        if [ "${trim_tool}" = "2" ]; then
          run_hmmcleaner "${output_dir}/04-Alignments/${ortho_method}/${file_name}.aln.fasta" "${hmmcleaner_cost}"
          if [ -s "${output_dir}/04-Alignments/${ortho_method}/${file_name}.aln_hmm.fasta" ]; then
            update_finish_count "$file_name" "$stage_logfile"
            mv "${output_dir}/04-Alignments/${ortho_method}/${file_name}.aln_hmm.fasta" "${output_dir}/05-Trimmed_alignments/${ortho_method}/${file_name}.aln.trimmed.fasta"
            rm -f "${output_dir}/04-Alignments/${ortho_method}/${file_name}.aln_hmm"*
          else
            record_failed_sample "$file_name"
          fi
        fi
        if [ "${process}" != "all" ]; then
          echo >&1000
        fi
      } &
      if [ "${log_mode}" = "cmd" ] || [ "${log_mode}" = "full" ]; then
        if [ "${trimal_tool}" = "1" ]; then
          display_only_failed_log "$stage_logfile" "Failed to trim ${ortho_method} alignments via trimAl:"
        else
          display_only_failed_log "$stage_logfile" "Failed to trim ${ortho_method} alignments via HMMCleaner:"
        fi
      fi
    done < "$temp_file"
    wait
    echo
    # Display processing log
    if [ "${log_mode}" = "full" ]; then
      if [ "${trimal_tool}" = "1" ]; then
        display_process_log "$stage_logfile" "Failed to trim ${ortho_method} alignments via trimAl:"
      else
        display_process_log "$stage_logfile" "Failed to trim ${ortho_method} alignments via HMMCleaner:"
      fi
    fi
    if ! find "${output_dir}/05-Trimmed_alignments/${ortho_method}/" -maxdepth 1 -type f -name "*.fasta" | grep -q .; then
      stage_error "No any trimmed alignments were generated in ${output_dir}/05-Trimmed_alignments/${ortho_method}/."
      stage_error "Please check the parameters for trimAl/HMMCleaner."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    else
      stage_success "Finished."
      stage_blank_main ""
    fi
    rm -rf "$temp_file"
  }
  #################===========================================================================

  #################=========================================
  # Function generate_reports_heatmap 
  generate_reports_heatmap() {
    ortho_method="$1"
    
    rm -rf "${output_dir}/03-Paralogs_handling/${ortho_method}/02-Original_${ortho_method}_sequences_reports_and_heatmap/"
    mkdir -p "${output_dir}/03-Paralogs_handling/${ortho_method}/02-Original_${ortho_method}_sequences_reports_and_heatmap/"
    # 01-Generating the reports and heatmap of the original ${ortho_method} sequences
    stage_info_main "01-Generating the reports and heatmap of the original ${ortho_method} sequences..."
    stage_cmd "${log_mode}" "python ${script_dir}/plot_recovery_heatmap.py -i ${output_dir}/03-Paralogs_handling/${ortho_method}/01-Original_${ortho_method}_sequences/ -r ${t} -osl ${output_dir}/03-Paralogs_handling/${ortho_method}/02-Original_${ortho_method}_sequences_reports_and_heatmap/Original_${ortho_method}_seq_lengths.tsv -oh ${output_dir}/03-Paralogs_handling/${ortho_method}/02-Original_${ortho_method}_sequences_reports_and_heatmap/Original_${ortho_method}_heatmap --threads ${nt} --color ${heatmap_color}"
    stage3_03="python ${script_dir}/plot_recovery_heatmap.py \
    -i ${output_dir}/03-Paralogs_handling/${ortho_method}/01-Original_${ortho_method}_sequences/ \
    -r ${t} \
    -osl ${output_dir}/03-Paralogs_handling/${ortho_method}/02-Original_${ortho_method}_sequences_reports_and_heatmap/Original_${ortho_method}_seq_lengths.tsv \
    -oh ${output_dir}/03-Paralogs_handling/${ortho_method}/02-Original_${ortho_method}_sequences_reports_and_heatmap/Original_${ortho_method}_heatmap \
    --threads ${nt} \
    --color ${heatmap_color}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage3_03}"
    else
      eval "${stage3_03} > /dev/null 2>&1"
    fi

    if [ -s "${output_dir}/03-Paralogs_handling/${ortho_method}/02-Original_${ortho_method}_sequences_reports_and_heatmap/Original_${ortho_method}_heatmap.png" ]; then
      stage_info "${log_mode}" "The reports and heatmap of the original ${ortho_method} sequences have been written to:"
      stage_info "${log_mode}" "${output_dir}/03-Paralogs_handling/${ortho_method}/02-Original_${ortho_method}_sequences_reports_and_heatmap/"
    else
      stage_error "Failed to get the reports and heatmap of the original ${ortho_method} sequences."
    fi

    # 02-Generating the reports and heatmap of the filtered ${ortho_method} sequences
    stage_info_main "02-Generating the reports and heatmap of the filtered ${ortho_method} sequences..."
    stage_cmd "${log_mode}" "python ${script_dir}/plot_recovery_heatmap.py -i ${output_dir}/03-Paralogs_handling/${ortho_method}/03-Filtered_${ortho_method}_sequences/ -r ${t} -osl ${output_dir}/03-Paralogs_handling/${ortho_method}/04-Filtered_${ortho_method}_sequences_reports_and_heatmap/Filtered_${ortho_method}_seq_lengths.tsv -oh ${output_dir}/03-Paralogs_handling/${ortho_method}/04-Filtered_${ortho_method}_sequences_reports_and_heatmap/Filtered_${ortho_method}_heatmap --threads ${nt} --show_values --color ${heatmap_color}"
    stage3_04="python ${script_dir}/plot_recovery_heatmap.py \
    -i ${output_dir}/03-Paralogs_handling/${ortho_method}/03-Filtered_${ortho_method}_sequences/ \
    -r ${t} \
    -osl ${output_dir}/03-Paralogs_handling/${ortho_method}/04-Filtered_${ortho_method}_sequences_reports_and_heatmap/Filtered_${ortho_method}_seq_lengths.tsv \
    -oh ${output_dir}/03-Paralogs_handling/${ortho_method}/04-Filtered_${ortho_method}_sequences_reports_and_heatmap/Filtered_${ortho_method}_heatmap \
    --threads ${nt} \
    --color ${heatmap_color}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage3_04}"
    else
      eval "${stage3_04} > /dev/null 2>&1"
    fi
    
    if [ -s "${output_dir}/03-Paralogs_handling/${ortho_method}/04-Filtered_${ortho_method}_sequences_reports_and_heatmap/Filtered_${ortho_method}_heatmap.png" ]; then
      stage_info "${log_mode}" "The reports and heatmap of the filtered ${ortho_method} sequences have been written to:"
      stage_info "${log_mode}" "${output_dir}/03-Paralogs_handling/${ortho_method}/04-Filtered_${ortho_method}_sequences_reports_and_heatmap/"
      stage_success "Finished."
      stage_blank_main ""
    else
      stage_error "Failed to get reports and heatmap of the filtered ${ortho_method} sequences."
      stage_blank_main ""
    fi
  }
    
  #################===========================================================================

  ################===========================================================================
  # Function count_species()
  ################===========================================================================
  count_species() {
    local fasta_dir="$1"

    temp_file="${fasta_dir}/species_list.txt"
    for fasta_file in "$fasta_dir"/*.fasta; do
      if [ -f "$fasta_file" ]; then
          grep "^>" "$fasta_file" | sort | uniq >> "$temp_file"
      fi
    done
    total_sps_num=$(sort "$temp_file" | uniq | wc -l)
    rm "$temp_file"
  }

  #################===========================================================================
  # Function summarize_and_filter_alignments()
  summarize_and_filter_alignments() {
    local ortho_method="$1"
    
    #01-Run AMAS.py to check every original and trimmed ${ortho_method} alignment
    mkdir -p "${output_dir}/hybsuite_reports/Alignments_stats"
    rm -f "${output_dir}/hybsuite_reports/Alignments_stats"${ortho_method}*
    stage_info_main "01-Running AMAS.py to check every original ${ortho_method} alignment ..."
    cd "${output_dir}/04-Alignments/${ortho_method}/"
    stage_cmd "${log_mode}" "AMAS.py summary -f fasta -d dna -i ${output_dir}/04-Alignments/${ortho_method}/*.aln.trimmed.fasta -o ${output_dir}/hybsuite_reports/Alignments_stats/${ortho_method}-01_Alignments_stats_AMAS.tsv"
    AMAS.py \
    summary -f fasta -d dna -i "${output_dir}"/04-Alignments/${ortho_method}/*.aln.fasta \
    -o "${output_dir}"/hybsuite_reports/Alignments_stats/${ortho_method}-01_Alignments_stats_AMAS.tsv > /dev/null 2>&1
    if [ -s "${output_dir}/hybsuite_reports/Alignments_stats/${ortho_method}-01_Alignments_stats_AMAS.tsv" ]; then
      num_filtered_a=$(awk 'END{print NR-1}' "${output_dir}/hybsuite_reports/Alignments_stats/${ortho_method}-01_Alignments_stats_AMAS.tsv")
      stage_info_main "${num_filtered_a} trimmed ${ortho_method} alignments were detected."
      stage_info_main "The AMAS summaries have been written to ${output_dir}/hybsuite_reports/Alignments_stats/${ortho_method}-01_Alignments_stats_AMAS.tsv"
    else
      stage_error "Fail to run AMAS.py to check every original ${ortho_method} alignment."
    fi

    #02-Run AMAS.py to check every trimmed ${ortho_method} alignment
    stage_info_main "02-Running AMAS.py to check every trimmed ${ortho_method} alignment ..."
    cd "${output_dir}/05-Trimmed_alignments/${ortho_method}/"
    stage_cmd "${log_mode}" "AMAS.py summary -f fasta -d dna -i ${output_dir}/05-Trimmed_alignments/${ortho_method}/*.aln.trimmed.fasta -o ${output_dir}/hybsuite_reports/Alignments_stats/${ortho_method}-02_Trimmed_alignments_stats_AMAS.tsv"
    AMAS.py \
    summary -f fasta -d dna -i "${output_dir}"/05-Trimmed_alignments/${ortho_method}/*aln.trimmed.fasta \
    -o "${output_dir}"/hybsuite_reports/Alignments_stats/${ortho_method}-02_Trimmed_alignments_stats_AMAS.tsv > /dev/null 2>&1
    if [ -s "${output_dir}/hybsuite_reports/Alignments_stats/${ortho_method}-02_Trimmed_alignments_stats_AMAS.tsv" ]; then
      num_filtered_t=$(awk 'END{print NR-1}' "${output_dir}/hybsuite_reports/Alignments_stats/${ortho_method}-02_Trimmed_alignments_stats_AMAS.tsv")
      stage_info_main "${num_filtered_t} trimmed ${ortho_method} alignments were detected."
      stage_info_main "The AMAS summaries have been written to ${output_dir}/hybsuite_reports/Alignments_stats/${ortho_method}-02_Trimmed_alignments_stats_AMAS.tsv"
    else
      stage_error "Fail to run AMAS.py to check every trimmed ${ortho_method} alignment."
    fi

    #03-Filtering alignments
    stage_info_main "03-Filtering alignments for species tree inference ..."
    # 03_Removed_alignments_without_parsimony_informative_sites.txt
    awk '$9 == 0 {print $1}' "${output_dir}/hybsuite_reports/Alignments_stats/${ortho_method}-02_Trimmed_alignments_stats_AMAS.tsv" > "${output_dir}"/hybsuite_reports/Alignments_stats/${ortho_method}-03_Removed_alignments_without_parsimony_informative_sites.txt
    sed -i '1d' "${output_dir}"/hybsuite_reports/Alignments_stats/${ortho_method}-03_Removed_alignments_without_parsimony_informative_sites.txt
    num_filtered_p=$(wc -l < "${output_dir}"/hybsuite_reports/Alignments_stats/${ortho_method}-03_Removed_alignments_without_parsimony_informative_sites.txt)
    stage_info_main "Removed ${num_filtered_p} ${ortho_method} alignments without parsimony informative sites."

    # 04_Removed_alignments_with_length_less_than_"${aln_min_length}".txt
    awk -v cov_length_thresh="${aln_min_length}" '$9 != 0 && $3 < cov_length_thresh {print $1}' "${output_dir}/hybsuite_reports/Alignments_stats/${ortho_method}-02_Trimmed_alignments_stats_AMAS.tsv" > "${output_dir}"/hybsuite_reports/Alignments_stats/${ortho_method}-04_Removed_alignments_with_length_less_than_"${aln_min_length}".txt
    sed -i '1d' "${output_dir}"/hybsuite_reports/Alignments_stats/${ortho_method}-04_Removed_alignments_with_length_less_than_"${aln_min_length}".txt
    num_filtered_l=$(wc -l < "${output_dir}"/hybsuite_reports/Alignments_stats/${ortho_method}-04_Removed_alignments_with_length_less_than_"${aln_min_length}".txt)
    stage_info_main "Removed ${num_filtered_l} ${ortho_method} alignments with length less than ${aln_min_length}."

    # 05_Removed_alignments_with_sample_coverage_less_than_${aln_locus_filter}.txt
    count_species "${output_dir}/05-Trimmed_alignments/${ortho_method}"
    awk -v all_sp="${total_sps_num}" -v cov_thresh="${aln_locus_filter}" -v cov_length_thresh="${aln_min_length}" \
    '$9 != 0 && $3 >= cov_length_thresh && ($2 / all_sp) < cov_thresh {print $1}' \
    "${output_dir}/hybsuite_reports/Alignments_stats/${ortho_method}-02_Trimmed_alignments_stats_AMAS.tsv" \
    > "${output_dir}/hybsuite_reports/Alignments_stats/${ortho_method}-05_Removed_alignments_with_sample_coverage_less_than_${aln_locus_filter}.txt"
    sed -i '1d' "${output_dir}"/hybsuite_reports/Alignments_stats/${ortho_method}-05_Removed_alignments_with_sample_coverage_less_than_${aln_locus_filter}.txt
    num_filtered_s=$(wc -l < "${output_dir}"/hybsuite_reports/Alignments_stats/${ortho_method}-05_Removed_alignments_with_sample_coverage_less_than_${aln_locus_filter}.txt)
    stage_info_main "Removed ${num_filtered_s} ${ortho_method} alignments with sample coverage less than ${aln_locus_filter}."

    # 06_Final_alignments_list.txt
    awk -v all_sp="${total_sps_num}" -v cov_thresh="${aln_locus_filter}" -v cov_length_thresh="${aln_min_length}" '$9!=0 && $3 >= cov_length_thresh && ($2 / all_sp) >= cov_thresh {print $1}' "${output_dir}/hybsuite_reports/Alignments_stats/${ortho_method}-02_Trimmed_alignments_stats_AMAS.tsv" > "${output_dir}"/hybsuite_reports/Alignments_stats/${ortho_method}-06_Final_alignments_list.txt
    sed -i '1d' "${output_dir}"/hybsuite_reports/Alignments_stats/${ortho_method}-06_Final_alignments_list.txt
    if [ ! -s "${output_dir}/hybsuite_reports/Alignments_stats/${ortho_method}-06_Final_alignments_list.txt" ]; then
      stage_error "No final alignments were genereated. Maybe all trimmed alignments were removed."
      stage_error "Please adjust the parameter '-aln_min_length' and '-aln_locus_filter', and run hybsuite again."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi

    # 07_Final_alignments_stats.txt
    awk -v all_sp="${total_sps_num}" -v cov_thresh="${aln_locus_filter}" -v cov_length_thresh="${aln_min_length}" '$9!=0 && $3 >= cov_length_thresh && ($2 / all_sp) >= cov_thresh {print $0}' "${output_dir}/hybsuite_reports/Alignments_stats/${ortho_method}-01_Alignments_stats_AMAS.tsv" > "${output_dir}"/hybsuite_reports/Alignments_stats/${ortho_method}-07_Final_alignments_stats_AMAS.txt
    rm -rf "${paralogs_dir}/${ortho_method}/"
    mkdir -p "${paralogs_dir}/${ortho_method}/"
    while IFS= read -r line || [ -n "$line" ]; do
      cp "${output_dir}"/05-Trimmed_alignments/${ortho_method}/"${line}" "${output_dir}"/06-Final_alignments/${ortho_method}/
    done < "${output_dir}/hybsuite_reports/Alignments_stats/${ortho_method}-06_Final_alignments_list.txt"

    stage_success "Congratulations! Finished generating ${ortho_method} final alignments in ${paralogs_dir}/${ortho_method}/"
    num_aln_final=$(wc -l < "${output_dir}/hybsuite_reports/Alignments_stats/${ortho_method}-06_Final_alignments_list.txt")
    stage_info_main_success "Totally $num_aln_final ${ortho_method} final alignments were generated, which will be used for species tree inference in stage 4."
    stage_blank_main ""
  }
  #################===========================================================================

  ############################################################################################
  #Stage3-Optional method: HRS ###############################################################
  ############################################################################################
  if [ "${HRS}" = "TRUE" ]; then
    #################===========================================================================
    stage_info_main "====>> Running optional method: HRS <<===="
    if [ -d "${output_dir}/03-Paralogs_handling/HRS/" ]; then
      rm -rf "${output_dir}/03-Paralogs_handling/HRS/"
    fi
    mkdir -p "${output_dir}/03-Paralogs_handling/HRS/"
    #################===========================================================================

    # Step 1: Retrieving sequences
    #################===========================================================================
    stage_info_main_blue "Step 1: Retrieving sequences by running 'hybpiper retrieve_sequences' ..."
    #################===========================================================================
    retrieve_hybpiper_sequences "HRS"

    # Optional step: Integrating pre-assembled sequences
    #################===========================================================================
    stage_info_main_blue "Step 2: Integrating pre-assembled sequences ..."
    #################===========================================================================
    if [ "${found_pre}" != "1" ]; then
      stage_info_main "No input pre-assembled sequences are detected."
      stage_info_main "Skipped"
      stage_blank_main ""
    else 
      process_integration="1"
      stage_info_main "====>> Integrating pre-assembled sequences (HRS) (${process_integration} in parallel) ====>>"
      # 01-Initialize parallel environment
      total_sps=$(grep -c '^' "${output_dir}/hybsuite_checklists/Pre-assembled_Spname.txt")
      init_parallel_env "$work_dir" "$total_sps" "$process_integration" "${output_dir}/hybsuite_checklists/Pre-assembled_Spname.txt" || exit 1
      
      # 02-Run the main loop
      while IFS= read -r add_sp || [ -n "$add_sp" ]; do
        total_genes=$(awk 'END {print NR}' "${output_dir}/hybsuite_checklists/Ref_gene_name_list.txt")
        if [ "${process_integration}" != "all" ]; then
          read -u1000
        fi
        {
          # Update start count
          update_start_count "$add_sp" "$stage_logfile"
          while IFS= read -r add_gene || [ -n "$add_gene" ]; do
            if grep -qE ">$add_gene |\[gene=$add_gene\]" "${input_data}/${add_sp}.fasta"; then
              file="${input_data}/${add_sp}.fasta"
              if grep -q "\[gene=${add_gene}\]" "${file}"; then
                sed -e "s|^.*[gene=${add_gene}].*$|>${add_gene} single_hit|g" "${file}" > "${output_dir}/03-Paralogs_handling/HRS/01-Original_HRS_sequences/${add_sp}_${add_gene}_single_hit.fa"
              elif grep -q ">${add_gene}" "${file}"; then
                sed -e "s|>${add_gene}.*$|>${add_gene} single_hit|g" "${file}" > "${output_dir}/03-Paralogs_handling/HRS/01-Original_HRS_sequences/${add_sp}_${add_gene}_single_hit.fa" 
              fi
              awk -v gene=">${add_gene} single_hit" '/^>/ {if (print_flag) print ""; print_flag=0} $0 ~ gene {print_flag=1} print_flag {print} END {if (print_flag) print ""}' \
              "${output_dir}/03-Paralogs_handling/HRS/01-Original_HRS_sequences/${add_sp}_${add_gene}_single_hit.fa" >> "${output_dir}/03-Paralogs_handling/HRS/01-Original_HRS_sequences/${add_gene}.FNA"
              sed -i "s|${add_gene} |${add_sp} |g;/^$/d" "${output_dir}/03-Paralogs_handling/HRS/01-Original_HRS_sequences/${add_gene}.FNA"
            fi
          done < "${output_dir}/hybsuite_checklists/Ref_gene_name_list.txt"
          find . -type f -name "*.fa" -exec rm -f {} +
          # Update failed sample list
          if ! grep -q "${add_sp}" "${output_dir}"/03-Paralogs_handling/HRS/01-Original_HRS_sequences/*.FNA; then
            record_failed_sample "$add_sp"
          else
            # Update finish count
            update_finish_count "$add_sp" "$stage_logfile"
          fi
          if [ "${process_integration}" != "all" ]; then
            echo >&1000
          fi
        } &
        if [ "${log_mode}" = "cmd" ] || [ "${log_mode}" = "full" ]; then
          display_only_failed_log "$stage_logfile" "Failed to integrate pre-assembled sequences into HRS dataset:"
        fi
      done < "${output_dir}/hybsuite_checklists/Pre-assembled_Spname.txt"
      wait
      echo
      # Display processing log
      if [ "${log_mode}" = "full" ]; then
        display_process_log "$stage_logfile" "Failed to integrate pre-assembled sequences into HRS dataset:"
      fi

      # 03-Formatting the output HRS sequences
      cd "${output_dir}"/03-Paralogs_handling/HRS/01-Original_HRS_sequences/
      for file in *.FNA; do
        python "${script_dir}/Fasta_formatter.py" -i "${file}" -o "${file}" -nt "${nt}" --inter > /dev/null 2>&1
      done
      stage_info_main "Finsihed"
      stage_blank_main ""
    fi

    # Step 3: Filtering all HRS sequences by length, locus and sample coverage
    #################===========================================================================
    stage_info_main_blue "Step 3: Filtering all HRS sequences by length, locus and sample coverage ..." 
    #################===========================================================================
    filter_seqs_by_llsc "HRS"
    
    # Step 4: Generating the reports and heatmap
    #################===========================================================================
    stage_info_main_blue "Step 4: Generating the reports and heatmap ..."
    #################===========================================================================
    generate_reports_heatmap "HRS"

    # Step 5: Multiple Sequence Alignment (MSA) and trimming
    #################===========================================================================
    stage_info_main_blue "Step 5: Aligning, trimming, and filtering HRS sequences ..."
    #################===========================================================================
    MSA_and_trim "HRS" "${output_dir}/03-Paralogs_handling/HRS/03-Filtered_HRS_sequences" "FNA"

    # Step 6: Summarizing statistics and filtering HRS alignments
    #################===========================================================================
    stage_info_main_blue "Step 6: Summarizing statistics and filtering HRS alignments..."
    #################===========================================================================
    summarize_and_filter_alignments "HRS"
  fi

  ############################################################################################
  #Stage3-Optional method: RLWP ##############################################################
  ############################################################################################
  if [ "${RLWP}" = "TRUE" ]; then
    #################===========================================================================
    stage_info_main "====>> Running optional method: RLWP <<===="
    if [ -d "${output_dir}/03-Paralogs_handling/RLWP/" ]; then
      rm -rf "${output_dir}/03-Paralogs_handling/RLWP/"
    fi
    mkdir -p "${output_dir}/03-Paralogs_handling/RLWP/"
    #################===========================================================================

    # Step 1: Retrieving sequences
    #################===========================================================================
    stage_info_main_blue "Step 1: Retrieving sequences by running 'hybpiper retrieve_sequences' ..."
    #################===========================================================================
    retrieve_hybpiper_sequences "RLWP"

    # Step 2: Integrating pre-assembled sequences
    #################===========================================================================
    stage_info_main_blue "Step 2: Integrating pre-assembled sequences ..."
    #################===========================================================================
    if [ "${found_pre}" != "1" ]; then
      stage_info_main "No input pre-assembled sequences are detected."
      stage_info_main "Skipped"
      stage_blank_main ""
    else 
      process_integration="1"
      stage_blank_main ""
      stage_info_main "====>> Integrating pre-assembled sequences (RLWP) (${process_integration} in parallel) ====>>" 
      # 01-Initialize parallel environment
      total_sps=$(grep -c '^' "${output_dir}/hybsuite_checklists/Pre-assembled_Spname.txt")
      init_parallel_env "$work_dir" "$total_sps" "$process_integration" "${output_dir}/hybsuite_checklists/Pre-assembled_Spname.txt" || exit 1
      
      # 02-Run the main loop
      while IFS= read -r add_sp || [ -n "$add_sp" ]; do
        total_genes=$(awk 'END {print NR}' "${output_dir}/hybsuite_checklists/Ref_gene_name_list.txt")
        if [ "${process_integration}" != "all" ]; then
          read -u1000
        fi
        {
          # Update start count
          update_start_count "$add_sp" "$stage_logfile"
          while IFS= read -r add_gene || [ -n "$add_gene" ]; do
            if grep -qE ">$add_gene |\[gene=$add_gene\]" "${input_data}/${add_sp}.fasta"; then
              file="${input_data}/${add_sp}.fasta"
              if grep -q "\[gene=${add_gene}\]" "${file}"; then
                sed -e "s|^.*[gene=${add_gene}].*$|>${add_gene} single_hit|g" "${file}" > "${output_dir}/03-Paralogs_handling/RLWP/01-Original_RLWP_sequences/${add_sp}_${add_gene}_single_hit.fa"
              elif grep -q ">${add_gene}" "${file}"; then
                sed -e "s|>${add_gene}.*$|>${add_gene} single_hit|g" "${file}" > "${output_dir}/03-Paralogs_handling/RLWP/01-Original_RLWP_sequences/${add_sp}_${add_gene}_single_hit.fa"
              fi
              awk -v gene=">${add_gene} single_hit" '/^>/ {if (print_flag) print ""; print_flag=0} $0 ~ gene {print_flag=1} print_flag {print} END {if (print_flag) print ""}' \
              "${output_dir}/03-Paralogs_handling/RLWP/01-Original_RLWP_sequences/${add_sp}_${add_gene}_single_hit.fa" >> "${output_dir}/03-Paralogs_handling/RLWP/01-Original_RLWP_sequences/${add_gene}.FNA"
              sed -i "s|${add_gene} |${add_sp} |g;/^$/d" "${output_dir}/03-Paralogs_handling/RLWP/01-Original_RLWP_sequences/${add_gene}.FNA" > /dev/null 2>&1
            fi
          done < "${output_dir}/hybsuite_checklists/Ref_gene_name_list.txt"
          find . -type f -name "*.fa" -exec rm -f {} +
          # Update failed sample list
          if ! grep -q "${add_sp}" "${output_dir}"/03-Paralogs_handling/RLWP/01-Original_RLWP_sequences/*.FNA; then
            record_failed_sample "$add_sp"
          else
            # Update finish count
            update_finish_count "$add_sp" "$stage_logfile"
          fi
          if [ "${process_integration}" != "all" ]; then
            echo >&1000
          fi
        } &
        if [ "${log_mode}" = "cmd" ] || [ "${log_mode}" = "full" ]; then
          display_only_failed_log "$stage_logfile" "Failed to integrate pre-assembled sequences into RLWP dataset:"
        fi
      done < "${output_dir}/hybsuite_checklists/Pre-assembled_Spname.txt"
      wait
      echo
      # Display processing log
      if [ "${log_mode}" = "full" ]; then
        display_process_log "$stage_logfile" "Failed to integrate pre-assembled sequences into RLWP dataset:"
      fi
      stage_success "Finished."
      stage_blank_main ""

      # 03-Formatting the output sequences
      cd "${output_dir}"/03-Paralogs_handling/RLWP/01-Original_RLWP_sequences/
      for file in *.FNA; do
        python "${script_dir}/Fasta_formatter.py" -i "${file}" -o "${file}" -nt "${nt}" --inter > /dev/null 2>&1
      done
    fi

    # Step 3: Removing loci with paralogues (RLWP)
    #################===========================================================================
    stage_info_main_blue "Step 3: Removing loci with paralogues (RLWP) via RLWP.py ..."
    #################===========================================================================
    mkdir -p "${output_dir}/03-Paralogs_handling/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/"
    stage_cmd "${log_mode}" "python ${script_dir}/RLWP.py -i ${output_dir}/03-Paralogs_handling/RLWP/01-Original_RLWP_sequences/ -p ${output_dir}/02-All_paralogs/02-Original_paralog_reports_and_heatmap/Original_paralog_report.tsv -s ${rlwp} -or ${output_dir}/03-Paralogs_handling/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/RLWP_removed_loci_info.tsv --threads ${nt}"
    stage3_RLWP_1="python ${script_dir}/RLWP.py \
    -i ${output_dir}/03-Paralogs_handling/RLWP/01-Original_RLWP_sequences/ \
    -p ${output_dir}/02-All_paralogs/02-Original_paralog_reports_and_heatmap/Original_paralog_report.tsv \
    -s ${rlwp} \
    -or ${output_dir}/03-Paralogs_handling/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/RLWP_removed_loci_info.tsv \
    --threads ${nt}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage3_RLWP_1}"
    else
      eval "${stage3_RLWP_1} > /dev/null 2>&1"
    fi
    stage_blank "${log_mode}" ""

    # Step 4: Filtering RLWP sequences by length, sample and locus coverage
    #################===========================================================================
    stage_info_main_blue "Step 4: Filtering RLWP sequences by length, sample and locus coverage..."
    #################===========================================================================
    filter_seqs_by_llsc "RLWP"

    # Step 5: Generating the reports and heatmap
    #################===========================================================================
    stage_info_main_blue "Step 5: Generating the reports and heatmap ..."
    #################===========================================================================
    generate_reports_heatmap "RLWP"

    # Step 6: Multiple Sequence Alignment (MSA) and trimming
    #################===========================================================================
    stage_info_main_blue "Step 6: Aligning, trimming, and filtering RLWP sequences ..."
    #################===========================================================================
    MSA_and_trim "RLWP" "${output_dir}/03-Paralogs_handling/RLWP/03-Filtered_RLWP_sequences" "FNA"

    # Step 7: Summarizing statistics and filtering RLWP alignments
    #################===========================================================================
    stage_info_main_blue "Step 7: Summarizing statistics and filtering RLWP alignments..."
    #################===========================================================================
    summarize_and_filter_alignments "RLWP"
  fi

  ############################################################################################
  #Stage3-Optional method: LS/MI/MO/RT/1to1 for PhyloPyPruner ################################
  ############################################################################################
  #1. phylopypruner (optional)
  if [ "$LS" = "TRUE" ] || { ([ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "${one_to_one}" = "TRUE" ]) && [ "${run_phylopypruner}" = "TRUE" ] && [ "${run_paragone}" != "TRUE" ]; }; then
    #################===========================================================================
    step_parts=""
    [ "$LS" = "TRUE" ] && step_parts="${step_parts}LS/"
    [ "$MO" = "TRUE" ] && step_parts="${step_parts}MO/"
    [ "$MI" = "TRUE" ] && step_parts="${step_parts}MI/"
    [ "$RT" = "TRUE" ] && step_parts="${step_parts}RT/"
    [ "${one_to_one}" = "TRUE" ] && step_parts="${step_parts}1to1/"
    step_parts=${step_parts%/}
    stage_info_main "====>> Optional method: tree-based algorithm (${step_parts}) via PhyloPyPruner <<===="
    #################===========================================================================
    if [ -d "${output_dir}/03-Paralogs_handling/PhyloPyPruner/" ]; then
      rm -r "${output_dir}/03-Paralogs_handling/PhyloPyPruner/"
    fi
    mkdir -p "${output_dir}"/03-Paralogs_handling/PhyloPyPruner/Input
    cd ${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input
    cp ${paralogs_dir}/*.fasta ${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input
    
    #################===========================================================================
    # Step 1: Preparing fasta files and single gene trees for PhyloPyPruner
    stage_info_main_blue "Step 1: Preparing fasta files and single gene trees for PhyloPyPruner"
    #################===========================================================================
    # 01-MSA and trimming
    define_threads "mafft"
    define_threads "trimal"
    temp_file="fasta_file_list.txt"
    find . -maxdepth 1 -type f -name "*.fasta" -exec basename {} \; > "$temp_file"
    total_sps=$(find . -maxdepth 1 -type f -name "*.fasta" | wc -l)
    # Initialize parallel environment
    init_parallel_env "$work_dir" "$total_sps" "$process" "${temp_file}" || exit 1
    if [ "${gene_tree}" = "1" ]; then
      gene_tree_tool="IQ-TREE"
      define_threads "iqtree"
    elif [ "${gene_tree}" = "2" ]; then
      gene_tree_tool="FastTree"
      define_threads "fasttree"
      export OMP_NUM_THREADS=${nt_fasttree}
    fi
    if [ "${trim_tool}" = "1" ]; then
      trim_tool_tool="trimAl"
      define_threads "trimal"
    elif [ "${trim_tool}" = "2" ]; then
      trim_tool_tool="HMMCleaner"
    fi
    stage_info_main "====>> Running MAFFT, ${trim_tool_tool} and ${gene_tree_tool} for ${total_sps} putative paralog files (${process} in parallel) ====>>"
    
    while IFS= read -r file || [ -n "$file" ]; do
      filename=${file%.fasta}
      genename=${file%_paralogs_all.fasta}
      if [ "${process}" != "all" ]; then
        read -u1000
      fi
      {
        # Update start count
        update_start_count "$genename" "$stage_logfile"
        sed -i "s/ single_hit/|single_hit/g;s/ multi/|multi/g;s/ NODE_/|NODE_/g;s/\.[0-9]\+|NODE_/|NODE_/g;s/\.main|NODE_/|NODE_/g" "${file}"
        # Run MAFFT  
        run_mafft "${file}" "${filename}.aln.fasta" "${nt_mafft}"
        remove_n "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln.fasta"
        if [ "${replace_n}" = "TRUE" ]; then
          replace_n "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln.fasta"
        fi
        if [ "${trim_tool}" = "1" ]; then
          run_trimal "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln.fasta" "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln.trimmed.fasta" "${trimal_mode}" \
          "${trimal_gapthreshold}" "${trimal_simthreshold}" "${trimal_cons}" "${trimal_block}" "${trimal_resoverlap}" "${trimal_seqoverlap}" \
          "${trimal_w}" "${trimal_gw}" "${trimal_sw}"
        fi
        if [ "${trim_tool}" = "2" ]; then
          run_hmmcleaner "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln.fasta" "${hmmcleaner_cost}"
          if [ -s "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln_hmm.fasta" ]; then
            update_finish_count "$genename" "$stage_logfile"
            mv "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln_hmm.fasta" "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln.trimmed.fasta"
            rm -f "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln_hmm"*
          else
            record_failed_sample "$genename"
          fi
        fi
        
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
        { print $0 }' "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln.trimmed.fasta" > "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln.trimmed.temp" && \
        mv "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln.trimmed.temp" "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln.trimmed.fasta"
        if [ ! -s "./${filename}.aln.trimmed.fasta" ]; then
          record_failed_sample "$genename"
        fi
        if [ "${gene_tree}" = "1" ]; then
          stage_cmd "${log_mode}" "iqtree -s ${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln.trimmed.fasta -m MFP -nt ${nt_iqtree} -bb ${gene_tree_bb} -pre ${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln.trimmed.fasta"
          iqtree -s "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln.trimmed.fasta" -m MFP -nt ${nt_iqtree} -bb "${gene_tree_bb}" -pre "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln.trimmed.fasta" > /dev/null 2>&1
          if [ -s "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln.trimmed.fasta.treefile" ]; then
            mv "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln.trimmed.fasta.treefile" "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln.trimmed.fasta.tre"
            find . -maxdepth 1 -name "${filename}.aln.trimmed.fasta*" ! -name "*.tre" ! -name "*.fasta" -delete
          else
            record_failed_sample "$genename"
          fi
        elif [ "${gene_tree}" = "2" ]; then
          stage_cmd "${log_mode}" "FastTreeMP -nt -gtr -gamma -boot ${gene_tree_bb} ${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln.trimmed.fasta > ./${filename}.aln.trimmed.fasta.tre"
          FastTreeMP -nt -gtr -gamma -boot "${gene_tree_bb}" "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln.trimmed.fasta" > "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln.trimmed.fasta.tre" 2>/dev/null
          if [ ! -s "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln.trimmed.fasta.tre" ]; then
            record_failed_sample "$genename"
          fi
        fi
        rm "${file}" "${filename}.aln.fasta" 2>/dev/null
        # Update failed count
        update_finish_count "$genename" "$stage_logfile"
        if [ "${process}" != "all" ]; then
          echo >&1000
        fi
      } &
      if [ "${log_mode}" = "cmd" ] || [ "${log_mode}" = "full" ]; then
        display_only_failed_log "$stage_logfile" "Failed to prepare fasta files and single gene trees for PhyloPyPruner:"
      fi
    done < "$temp_file"
    rm "$temp_file"
    wait
    echo
    # Display processing log
    if [ "${log_mode}" = "full" ]; then
      display_process_log "$stage_logfile" "Failed to prepare fasta files and single gene trees for PhyloPyPruner:"
    fi
    if ! find ./ -type f -name '*.aln.trimmed.fasta' -size +0c -quit 2>/dev/null; then
      stage_error "Fail to run MAFFT and trimAl/HMMCleaner."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
    if ! find ./ -type f -name '*.aln.trimmed.fasta.tre' -size +0c -quit 2>/dev/null; then
      stage_error "Fail to run FastTree."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
    stage_success "Finished."
    stage_blank_main ""

    # Step 2: Running PhyloPyPruner
    #################===========================================================================
    stage_info_main_blue "Step 2: Running PhyloPyPruner for ${step_parts}..."
    #################===========================================================================
    define_threads "phylopypruner"
    # Define the function to run PhyloPyPruner
    run_phylopypruner() {
        local method=$1
        local output_phylopypruner_dir=$2
        local threads=$3
        local input_dir=$4
        local trim_lb=$5
        local min_taxa=$6
        if [ "${method}" = "MO" ] || [ "${method}" = "RT" ]; then
          local outgroup=$7
        fi

        stage_info_main "Running ${method} algorithum via PhyloPyPruner ..."
        
        # Base command without outgroup
        local base_cmd="phylopypruner --overwrite --no-supermatrix --threads \"${threads}\" --dir \"${input_dir}/PhyloPyPruner/Input\" --output \"${input_dir}/PhyloPyPruner/\" --prune \"${method}\" --trim-lb \"${trim_lb}\" --min-taxa \"${min_taxa}\""

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
        sed -i "s/|.*$//" "${input_dir}/PhyloPyPruner/${output_phylopypruner_dir}/output_alignments/"*.fasta

        # Check the running result
        if [ "$(ls -A "${input_dir}/PhyloPyPruner/${output_phylopypruner_dir}/output_alignments")" ]; then
            stage_success "Finished."
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
        run_phylopypruner "LS" "Output_LS" "${nt_phylopypruner}" "${output_dir}/03-Paralogs_handling" "${pp_trim_lb}" "${pp_min_taxa}"
    fi

    # Run PhyloPyPruner for MI
    if [ "${MI}" = "TRUE" ] && [ "${run_paragone}" = "FALSE" ]; then
        run_phylopypruner "MI" "Output_MI" "${nt_phylopypruner}" "${output_dir}/03-Paralogs_handling" "${pp_trim_lb}" "${pp_min_taxa}"
    fi

    # Run PhyloPyPruner for MO
    if [ "${MO}" = "TRUE" ] && [ "${run_paragone}" = "FALSE" ]; then
        run_phylopypruner "MO" "Output_MO" "${nt_phylopypruner}" "${output_dir}/03-Paralogs_handling" "${pp_trim_lb}" "${pp_min_taxa}" "${output_dir}/hybsuite_checklists/Outgroup.txt"
    fi

    # Run PhyloPyPruner for RT
    if [ "${RT}" = "TRUE" ] && [ "${run_paragone}" = "FALSE" ]; then
        run_phylopypruner "RT" "Output_RT" "${nt_phylopypruner}" "${output_dir}/03-Paralogs_handling" "${pp_trim_lb}" "${pp_min_taxa}" "${output_dir}/hybsuite_checklists/Outgroup.txt"
    fi
    
    # Run PhyloPyPruner for 1to1
    if [ "${one_to_one}" = "TRUE" ] && [ "${run_paragone}" = "FALSE" ]; then
        run_phylopypruner "1to1" "Output_1to1" "${nt_phylopypruner}" "${output_dir}/03-Paralogs_handling" "${pp_trim_lb}" "${pp_min_taxa}"
    fi

    # Step 3: Realigning and trimming orthogroup alignments generated via PhyloPyPruner
    #################===========================================================================
    stage_blank_main ""
    stage_info_main_blue "Step 3: Realigning and trimming ${step_parts} orthogroup alignments generated via PhyloPyPruner ..."
    #################===========================================================================
    if [ "${LS}" = "TRUE" ]; then
      stage_info_main "====>> LS ====>>"
      MSA_and_trim "LS" "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Output_LS/output_alignments" "aln.trimmed_pruned"*".fasta"
    fi
    if [ "${MI}" = "TRUE" ]; then
      stage_info_main "====>> MI ====>>"
      MSA_and_trim "MI" "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Output_MI/output_alignments" "aln.trimmed_pruned"*".fasta"
    fi
    if [ "${MO}" = "TRUE" ]; then
      stage_info_main "====>> MO ====>>"
      MSA_and_trim "MO" "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Output_MO/output_alignments" "aln.trimmed_pruned"*".fasta"
    fi
    if [ "${RT}" = "TRUE" ]; then
      stage_info_main "====>> RT ====>>"
      MSA_and_trim "RT" "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Output_RT/output_alignments" "aln.trimmed_pruned"*".fasta"
    fi
    if [ "${one_to_one}" = "TRUE" ]; then
      stage_info_main "====>> 1to1 ====>>"
      MSA_and_trim "1to1" "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Output_1to1/output_alignments" "aln.trimmed_pruned"*".fasta"
    fi

    # Step 4: Summarizing and filtering ${step_parts} orthogroup alignments generated via PhyloPyPruner
    #################===========================================================================
    stage_info_main_blue "Step 4: Summarizing and filtering ${step_parts} orthogroup alignments generated via PhyloPyPruner ..."
    #################===========================================================================
    if [ "${LS}" = "TRUE" ]; then
      stage_info_main "====>> LS ====>>"
      summarize_and_filter_alignments "LS"
    fi
    if [ "${MI}" = "TRUE" ]; then
      stage_info_main "====>> MI ====>>"
      summarize_and_filter_alignments "MI"
    fi
    if [ "${MO}" = "TRUE" ]; then
      stage_info_main "====>> MO ====>>"
      summarize_and_filter_alignments "MO"
    fi
    if [ "${RT}" = "TRUE" ]; then
      stage_info_main "====>> RT ====>>"
      summarize_and_filter_alignments "RT"
    fi
    if [ "${one_to_one}" = "TRUE" ]; then
      stage_info_main "====>> 1to1 ====>>"
      summarize_and_filter_alignments "1to1"
    fi
    stage_blank_main ""
  fi

  ############################################################################################
  #Stage3-Optional method: MO/MI/RT/1to1 for ParaGone ########################################
  ############################################################################################
  #ParaGone (optional)
  if ([ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "${one_to_one}" = "TRUE" ]) && [ "${run_paragone}" = "TRUE" ] && [ "${run_phylopypruner}" = "FALSE" ]; then
    #################===========================================================================
    step_parts=""
    [ "$MO" = "TRUE" ] && step_parts="${step_parts}MO/"
    [ "$MI" = "TRUE" ] && step_parts="${step_parts}MI/"
    [ "$RT" = "TRUE" ] && step_parts="${step_parts}RT/"
    [ "${one_to_one}" = "TRUE" ] && step_parts="${step_parts}1to1/"
    step_parts=${step_parts%/}
    stage_info_main "====>> Optional method: tree-based algorithm (${step_parts}) via ParaGone <<===="
    #################===========================================================================
    
    # Preparation: remove existed files
    if [ -d "${output_dir}/03-Paralogs_handling/ParaGone" ]; then
      rm -rf "${output_dir}/03-Paralogs_handling/ParaGone"
    fi
    # Preparation: Directories and reminders
    mkdir -p ${output_dir}/03-Paralogs_handling/ParaGone
    # Preparation: Outgroup processing
    cd ${output_dir}/03-Paralogs_handling/ParaGone
    outgroup_args=""
    while IFS= read -r line || [ -n "$line" ]; do
      outgroup_args="$outgroup_args --internal_outgroup $line"
    done < "${output_dir}/hybsuite_checklists/Outgroup.txt"
    # Preparation: change species names to correct ones for running ParaGone 
    sed -i "s/_var\._/_var_/g;s/_subsp\._/_subsp_/g;s/_f\._/_f_/g"  "${paralogs_dir}/"*
    
    #for file in "${paralogs_dir}/"*; do
    #  sed -i "s/_var\._/_var_/g"  "${file}"
    #  sed -i "s/_subsp\._/_subsp_/g" "${file}"
    #  sed -i "s/_f\._/_f_/g" "${file}"
    #done

    # Define threads
    define_threads "paragone"

    # ParaGone fullpipeline
    run_paragone() {
      local input_dir="${paralogs_dir}"
      
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
      
      if [ "${gene_tree}" = "2" ]; then
        paragone_step2_cmd="${paragone_step2_cmd} --use_fasttree"
        paragone_step4_cmd="${paragone_step4_cmd} --use_fasttree"
      fi

      if [ "${paragone_keep_intermediate_files}" = "TRUE" ]; then
        paragone_step6_cmd="${paragone_step6_cmd} --keep_intermediate_files"
      fi

      if [ "${MO}" = "TRUE" ] || [ "${one_to_one}" = "TRUE" ]; then
        paragone_step5_cmd="${paragone_step5_cmd} --mo"
        paragone_step6_cmd="${paragone_step6_cmd} --mo"
      fi
      if [ "${MI}" = "TRUE" ]; then
        paragone_step5_cmd="${paragone_step5_cmd} --mi"
        paragone_step6_cmd="${paragone_step6_cmd} --mi"
      fi
      if [ "${RT}" = "TRUE" ]; then
        paragone_step5_cmd="${paragone_step5_cmd} --rt"
        paragone_step6_cmd="${paragone_step6_cmd} --rt"
      fi

      #################===========================================================================
      stage_info_main "Running ParaGone step1 ... "
      #################===========================================================================
      stage_cmd "${log_mode}" "${paragone_step1_cmd}"
      eval "${paragone_step1_cmd}" > /dev/null 2>&1
      if [ ! -n "$(find "./04_alignments_trimmed_cleaned" -maxdepth 1 -mindepth 1 -print -quit 2>/dev/null)" ]; then
        stage_error "Fail to run ParaGone step1."
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      else
        stage_success "Finished."
        stage_blank_main ""
      fi

      #################===========================================================================
      stage_info_main "Running ParaGone step2 ... "
      #################===========================================================================
      stage_cmd "${log_mode}" "${paragone_step2_cmd}"
      eval "${paragone_step2_cmd}" > /dev/null 2>&1
      if [ ! -n "$(find "./05_trees_pre_quality_control" -maxdepth 1 -mindepth 1 -print -quit 2>/dev/null)" ]; then
        stage_error "Fail to run ParaGone step2."
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      else
        stage_success "Finished."
        stage_blank_main ""
      fi

      #################===========================================================================
      stage_info_main "Running ParaGone step3 ... "
      #################===========================================================================
      stage_cmd "${log_mode}" "${paragone_step3_cmd}"
      eval "${paragone_step3_cmd}" > /dev/null 2>&1
      if [ ! -n "$(find "./09_sequences_from_qc_trees" -maxdepth 1 -mindepth 1 -print -quit 2>/dev/null)" ]; then
        stage_error "Fail to run ParaGone step3."
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      else
        stage_success "Finished."
        stage_blank_main ""
      fi

      #################===========================================================================
      stage_info_main "Running ParaGone step4 ... "
      #################===========================================================================
      stage_cmd "${log_mode}" "${paragone_step4_cmd}"
      eval "${paragone_step4_cmd}" > /dev/null 2>&1
      if [ ! -n "$(find "./13_pre_paralog_resolution_trees" -maxdepth 1 -mindepth 1 -print -quit 2>/dev/null)" ]; then
        stage_error "Fail to run ParaGone step4."
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      else
        stage_success "Finished."
      fi

      #################===========================================================================
      stage_info_main "Running ParaGone step5 ... "
      #################===========================================================================
      stage_cmd "${log_mode}" "${paragone_step5_cmd}"
      eval "${paragone_step5_cmd}" > /dev/null 2>&1
      if [ ! -n "$(find "./14_pruned_MO" -maxdepth 1 -mindepth 1 -print -quit 2>/dev/null)" ] \
      && [ ! -n "$(find "./15_pruned_MI" -maxdepth 1 -mindepth 1 -print -quit 2>/dev/null)" ] \
      && [ ! -n "$(find "./16_pruned_RT" -maxdepth 1 -mindepth 1 -print -quit 2>/dev/null)" ]; then
        stage_error "Fail to run ParaGone step5."
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      else
        stage_success "Finished."
        stage_blank_main ""
      fi
      
      
      #################===========================================================================
      stage_info_main "Running ParaGone step6 ... "
      #################===========================================================================
      stage_cmd "${log_mode}" "${paragone_step6_cmd}"
      eval "${paragone_step6_cmd}" > /dev/null 2>&1
      if [ ! -n "$(find "./23_MO_final_alignments" -maxdepth 1 -mindepth 1 -print -quit 2>/dev/null)" ] \
      && [ ! -n "$(find "./24_MI_final_alignments" -maxdepth 1 -mindepth 1 -print -quit 2>/dev/null)" ] \
      && [ ! -n "$(find "./25_RT_final_alignments" -maxdepth 1 -mindepth 1 -print -quit 2>/dev/null)" ] \
      && [ ! -n "$(find "./26_MO_final_alignments_trimmed" -maxdepth 1 -mindepth 1 -print -quit 2>/dev/null)" ] \
      && [ ! -n "$(find "./27_MI_final_alignments_trimmed" -maxdepth 1 -mindepth 1 -print -quit 2>/dev/null)" ] \
      && [ ! -n "$(find "./28_RT_final_alignments_trimmed" -maxdepth 1 -mindepth 1 -print -quit 2>/dev/null)" ]; then
        stage_error "Fail to finish running ParaGone."
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      else
        stage_success "Finished."
        stage_blank_main ""
      fi

      #################===========================================================================
      stage_info_main "Extracting ${step_parts} orthogroup alignments and trimmed alignments ... "
      #################===========================================================================
      if [ "${MO}" = "TRUE" ]; then
        stage_info_main "====>> MO ====>>"
        rm -rf "${output_dir}/04-Alignments/MO/"
        rm -rf "${output_dir}/05-Trimmed_alignments/MO/"
        mkdir -p "${output_dir}/04-Alignments/MO/"
        mkdir -p "${output_dir}/05-Trimmed_alignments/MO/"
        sed -i "s/_var_/_var\._/g;s/_subsp_/_subsp\._/g;s/_f_/_f\._/g" "${output_dir}/03-Paralogs_handling/ParaGone/23_MO_final_alignments/"*
        sed -i "s/_var_/_var\._/g;s/_subsp_/_subsp\._/g;s/_f_/_f\._/g" "${output_dir}/03-Paralogs_handling/ParaGone/26_MO_final_alignments_trimmed/"*
        cp "${output_dir}/03-Paralogs_handling/ParaGone/23_MO_final_alignments"/*.fasta "${output_dir}/04-Alignments/MO/"
        cp "${output_dir}/03-Paralogs_handling/ParaGone/26_MO_final_alignments_trimmed"/*.fasta "${output_dir}/05-Trimmed_alignments/MO/"
      fi
      if [ "${MI}" = "TRUE" ]; then
        stage_info_main "====>> MI ====>>"
        rm -rf "${output_dir}/04-Alignments/MI/"
        rm -rf "${output_dir}/05-Trimmed_alignments/MI/"
        mkdir -p "${output_dir}/04-Alignments/MI/"
        mkdir -p "${output_dir}/05-Trimmed_alignments/MI/"
        sed -i "s/_var_/_var\._/g;s/_subsp_/_subsp\._/g;s/_f_/_f\._/g" "${output_dir}/03-Paralogs_handling/ParaGone/24_MI_final_alignments/"*
        sed -i "s/_var_/_var\._/g;s/_subsp_/_subsp\._/g;s/_f_/_f\._/g" "${output_dir}/03-Paralogs_handling/ParaGone/27_MI_final_alignments_trimmed/"*
        cp "${output_dir}/03-Paralogs_handling/ParaGone/24_MI_final_alignments"/*.fasta "${output_dir}/04-Alignments/MI/"
        cp "${output_dir}/03-Paralogs_handling/ParaGone/27_MI_final_alignments_trimmed"/*.fasta "${output_dir}/05-Trimmed_alignments/MI/"
      fi
      if [ "${RT}" = "TRUE" ]; then
        stage_info_main "====>> RT ====>>"
        rm -rf "${output_dir}/04-Alignments/RT/"
        rm -rf "${output_dir}/05-Trimmed_alignments/RT/"
        mkdir -p "${output_dir}/04-Alignments/RT/"
        mkdir -p "${output_dir}/05-Trimmed_alignments/RT/"
        sed -i "s/_var_/_var\._/g;s/_subsp_/_subsp\._/g;s/_f_/_f\._/g" "${output_dir}/03-Paralogs_handling/ParaGone/28_RT_final_alignments_trimmed/"*
        cp "${output_dir}/03-Paralogs_handling/ParaGone/28_RT_final_alignments_trimmed"/*.fasta "${output_dir}/05-Trimmed_alignments/RT/"
      fi
      if [ "${one_to_one}" = "TRUE" ]; then
        stage_info_main "====>> 1to1 ====>>"
        # Orthogroup alignments
        cd "${output_dir}/03-Paralogs_handling/ParaGone/23_MO_final_alignments"
        rm -rf "${output_dir}/04-Alignments/1to1/"
        mkdir -p "${output_dir}/04-Alignments/1to1/"
        files=$(find . -maxdepth 1 -type f -name "*1to1*")
        total_sps=$(find . -maxdepth 1 -type f -name "*1to1*" | wc -l)
        j=0
        stage_info_main "Orthogroup alignments:"
        for file in $files; do
          j=$((j + 1 ))
          cp "$file" "${output_dir}/04-Alignments/1to1/"
          sed -i "s/_var_/_var\._/g;s/_subsp_/_subsp\._/g;s/_f_/_f\._/g"  "${output_dir}/04-Alignments/1to1/${file}"
          progress=$((j * 100 / total_sps))
          printf "\r[$(date +%Y-%m-%d\ %H:%M:%S)] [INFO] Extracting 1to1 alignments: ${j}/${total_sps} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress"
        done
        echo
        
        # Trimmed orthogroup alignments
        cd "${output_dir}/03-Paralogs_handling/ParaGone/26_MO_final_alignments_trimmed"
        rm -rf "${output_dir}/05-Trimmed_alignments/1to1/"
        mkdir -p "${output_dir}/05-Trimmed_alignments/1to1/"
        files=$(find . -maxdepth 1 -type f -name "*1to1*")
        total_sps=$(find . -maxdepth 1 -type f -name "*1to1*" | wc -l)
        j=0
        stage_info_main "Trimmed orthogroup alignments:"
        for file in $files; do
          j=$((j + 1 ))
          cp "$file" "${output_dir}/05-Trimmed_alignments/1to1/"
          sed -i "s/_var_/_var\._/g;s/_subsp_/_subsp\._/g;s/_f_/_f\._/g"  "${output_dir}/05-Trimmed_alignments/1to1/${file}"
          progress=$((j * 100 / total_sps))
          printf "\r[$(date +%Y-%m-%d\ %H:%M:%S)] [INFO] Extracting 1to1 trimmed alignments: ${j}/${total_sps} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress"
        done
        echo
        stage_blank_main ""
      fi

      #################===========================================================================
      stage_info_main "Summarizing and filtering ${step_parts} alignments ... "
      #################===========================================================================
      if [ "${MO}" = "TRUE" ]; then
        stage_info_main "====>> MO ====>>"
        summarize_and_filter_alignments "MO"
      fi
      if [ "${MI}" = "TRUE" ]; then
        stage_info_main "====>> MI ====>>"
        summarize_and_filter_alignments "MI"
      fi
      if [ "${RT}" = "TRUE" ]; then
        stage_info_main "====>> RT ====>>"
        summarize_and_filter_alignments "RT"
      fi
      if [ "${one_to_one}" = "TRUE" ]; then
        stage_info_main "====>> 1to1 ====>>"
        summarize_and_filter_alignments "1to1"
      fi
    }
    cd "${output_dir}/03-Paralogs_handling/ParaGone"
    stage_info_main "Running ParaGone full pipeline from step1 to step6 ... "
    stage_info_main "See results in ${output_dir}/03-Paralogs_handling/ParaGone."
    stage_info_main "See ParaGone logs in ${output_dir}/03-Paralogs_handling/ParaGone/00_logs_and_reports/logs/"
    run_paragone
  fi

  ############################################################################################
  # End of Stage 3
  stage_success "Successfully finished Stage3: 'Paralogs handling'."
  stage_info_main_success "The resulting files have been saved in:"
  stage_info_main_success "(1) ${output_dir}/03-Paralogs_handling/"
  stage_info_main_success "(2) ${output_dir}/04-Alignments/"
  stage_info_main_success "(3) ${output_dir}/05-Trimmed_alignments/"
  stage_info_main_success "(4) ${paralogs_dir}/"
  stage_info_main_success "Reports have been saved in:"
  stage_info_main_success "${output_dir}/hybsuite_reports/"
  stage_info_main_success "The logfile has been saved in:"
  stage_info_main_success "${output_dir}/hybsuite_logs/hybsuite_${current_time}.log"
  if [ "${full_pipeline}" = "FALSE" ]; then
  # Clean up environment
    cleanup_parallel_env "$work_dir"
    stage_success "HybSuite execution completed successfully, please reference our publication in your work."
    stage_blank_main ""
    exit 0
  else
    stage_info_main "Moving on to the next stage..."
    stage_blank_main ""
  fi
fi
############################################################################################

######################################################################################
# Stage 4: Species tree inference ####################################################
######################################################################################
if [ "${run_stage4}" = "TRUE" ] || [ "${full_pipeline}" = "TRUE" ]; then
# 0.Preparation
stage_info_main_purple "<<<======= Stage 4 Species tree inference =======>>>"
if [ "${full_pipeline}" = "TRUE" ]; then
  paralogs_dir="${output_dir}/06-Final_alignments"
fi

################===========================================================================
# Function concatenation()
################===========================================================================
concatenation() {
  local ortho_method="$1"
  local input="$2"

  rm -rf "${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix"
  mkdir -p "${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix"

  #01-Concatenate final alignments
    stage_info_main "01-Concatenating ${ortho_method} final alignments into the supermatrix ... "
    define_threads "amas"
    stage_cmd "${log_mode}" "AMAS.py concat -f fasta -d dna -i ${input}/*.aln.trimmed.fasta -p ${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix/partition.txt -t ${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix/${prefix}_${ortho_method}2.fasta -y raxml -c ${nt_amas}"
    AMAS.py concat \
    -f fasta \
    -d dna \
    -i ${input}/*.aln.trimmed.fasta \
    -p ${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix/partition.txt \
    -t ${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix/${prefix}_${ortho_method}2.fasta \
    -y raxml \
    -c ${nt_amas} > /dev/null 2>&1
    stage_cmd "${log_mode}" "awk '/^>/ {print $0; next} {gsub(/\?/, "-"); print}' ${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix/${prefix}_${ortho_method}2.fasta > ${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix/${prefix}_${ortho_method}.fasta"
    awk '/^>/ {print $0; next} {gsub(/\?/, "-"); print}' ${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix/${prefix}_${ortho_method}2.fasta > ${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix/${prefix}_${ortho_method}.fasta
    rm -f ${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix/${prefix}_${ortho_method}2.fasta
    if [ -s "${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix/${prefix}_${ortho_method}.fasta" ]; then
      stage_info_main "Succeed -> ${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix/${prefix}_${ortho_method}.fasta"
    else
      stage_error "Fail to concatenate ${ortho_method} alignments into the supermatrix."
    fi

    #02-Run AMAS.py to check the ${ortho_method} supermatrix
    rm -f "${output_dir}/hybsuite_reports/Supermatrix_stats/${ortho_method}-Supermatrix_stats_AMAS.tsv"
    mkdir -p "${output_dir}/hybsuite_reports/Supermatrix_stats/"
    stage_info_main "02-Running AMAS.py to check the ${ortho_method} supermatrix ... "
    stage_cmd "${log_mode}" "AMAS.py summary -f fasta -d dna -i ${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix/${prefix}_${ortho_method}.fasta -o ${output_dir}/hybsuite_reports/Supermatrix_stats/${ortho_method}-Supermatrix_stats_AMAS.tsv"
    AMAS.py summary -f fasta -d dna -i ${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix/${prefix}_${ortho_method}.fasta \
    -o "${output_dir}/hybsuite_reports/Supermatrix_stats/${ortho_method}-Supermatrix_stats_AMAS.tsv" > /dev/null 2>&1
    if [ -s "${output_dir}/hybsuite_reports/Supermatrix_stats/${ortho_method}-Supermatrix_stats_AMAS.tsv" ]; then
      stage_info_main "Succeed -> ${output_dir}/hybsuite_reports/Supermatrix_stats/${ortho_method}-Supermatrix_stats_AMAS.tsv"
      stage_success "Finished."
    else
      stage_error "Fail to run AMAS.py to check ${ortho_method} supermatrix."
    fi
    stage_blank_main ""
}
################===========================================================================

################===========================================================================
# Function run_modeltest_ng()
################===========================================================================
run_modeltest_ng() {
  local ortho_method="$1"
  # input:{output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix/${prefix}_${ortho_method}.fasta
  local input="$2"
  # output:{output_dir}/07-Concatenated_analysis/${ortho_method}/02-Species_tree/${prefix}_${ortho_method}_ModelTest_NG.txt
  local output="$3"

  if [ "${run_modeltest_ng}" = "TRUE" ] && ([ "${run_iqtree}" = "TRUE" ] || [ "${run_raxml}" = "TRUE" ] || [ "${run_raxml_ng}" = "TRUE" ]); then
    define_threads "modeltest_ng"
    stage_info_main "Optional step: getting the best model via ModelTest-NG ..."
    stage_info_main "Running ModelTest-NG to get the best model for the ${ortho_method} supermatrix ... "
    mkdir -p "${output_dir}/07-Concatenated_analysis/${ortho_method}/02-Species_tree"
    stage_cmd "${log_mode}" "modeltest-ng -d nt --force -p ${nt_modeltest_ng} -i ${input} -o ${output} -T raxml"
    modeltest-ng -d nt \
    --force \
    -p ${nt_modeltest_ng} \
    -i "${input}" \
    -o "${output}" \
    -T raxml > /dev/null 2>&1
    if [ -s "${output}.log" ]; then
      ###02-According to the result, assign different variables to the suggested commands for each tree building software
      eval "iqtree_cmd=\$(grep -n 'iqtree' ${output}.log | head -n 3 | tail -n 1 | sed -e 's/^.*iqtree/iqtree/g')"
      stage_info_main "The best model for IQ-TREE is: ${iqtree_cmd}"
      eval "raxml_ng_cmd=\$(grep -n 'raxml-ng' ${output}.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxml-ng/raxml-ng/g')"
      stage_info_main "The best model for RAxML-NG is: ${raxml_ng_cmd}"
      eval "raxmlHPC_cmd=\$(grep -n 'raxmlHPC' ${output}.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxmlHPC/raxmlHPC-PTHREADS/g; s/ -n .*$//')"
      stage_info_main "The best model for RAxML-NG is: ${raxmlHPC_cmd}"
      stage_info_main_success "Successfully running ModelTest-NG, the result has been written to:"
      stage_info_main_success "${output}.log"
      stage_success "Finished."
      stage_blank_main ""
    else
      stage_error "Fail to run ModelTest-NG to get the best model for the ${ortho_method} supermatrix."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi   
  fi
}
################===========================================================================

################===========================================================================
# Function run_sp_tree_iqtree()
################===========================================================================
run_sp_tree_iqtree() {
  local ortho_method="$1"
  # input:{output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix/${prefix}_${ortho_method}.fasta
  local input="$2"
  # output_prefix:{output_dir}/07-Concatenated_analysis/${ortho_method}/IQ-TREE/IQ-TREE_${prefix}_${ortho_method}
  local output_prefix="$3"

  stage_info_main "Optional step: Constructing ${ortho_method} concatenation-based species tree via IQ-TREE"
  rm -rf "${output_dir}/07-Concatenated_analysis/${ortho_method}/02-Species_tree/IQ-TREE"
  mkdir -p "${output_dir}/07-Concatenated_analysis/${ortho_method}/02-Species_tree/IQ-TREE"
  cd "${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix"
    
  # 01-Running IQ-TREE
  stage_info_main "01-Running IQ-TREE ..."
  define_threads "iqtree"
  if [ "${run_modeltest_ng}" = "TRUE" ]; then
    run_iqtree_cmd="${iqtree_cmd} -B ${iqtree_bb} --undo --seed 12345 -T ${nt_iqtree} -pre ${output_prefix}"
    if [ "${iqtree_partition}" = "TRUE" ]; then
      run_iqtree_cmd="${run_iqtree_cmd} -p ${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix/partition.txt"
    fi
    if [ "${iqtree_constraint_tree}" != "_____" ]; then
      run_iqtree_cmd="${run_iqtree_cmd} -g ${iqtree_constraint_tree}"
    fi
    if [ "${iqtree_alrt}" != "FALSE" ]; then
      run_iqtree_cmd="${run_iqtree_cmd} -alrt ${iqtree_alrt}"
    fi
    stage_cmd_main "${run_iqtree_cmd}"
    eval "${run_iqtree_cmd} > /dev/null 2>&1"
  else
    run_iqtree_cmd="iqtree -s ${input} --undo --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -m MFP -pre ${output_prefix}"
    if [ "${iqtree_partition}" = "TRUE" ]; then
      run_iqtree_cmd="${run_iqtree_cmd} -p ${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix/partition.txt"
    fi
    if [ "${iqtree_constraint_tree}" != "_____" ]; then
      run_iqtree_cmd="${run_iqtree_cmd} -g ${iqtree_constraint_tree}"
    fi
    if [ "${iqtree_alrt}" != "FALSE" ]; then
      run_iqtree_cmd="${run_iqtree_cmd} -alrt ${iqtree_alrt}"
    fi
    stage_cmd_main "${run_iqtree_cmd}"
    eval "${run_iqtree_cmd} > /dev/null 2>&1" 
  fi
  if [ ! -s "${output_prefix}.treefile" ]; then
    stage_error "Fail to run IQ-TREE, check the log file:"
    stage_error "${output_prefix}.log" 
    stage_error "HybSuite exits." 
    stage_blank_main ""
    exit 1
  else 
    stage_info_main_success "Successfully constructing the ${ortho_method} concatenation-based species tree (IQ-TREE) in:"
    stage_info_main_success "${output_prefix}.treefile"
    stage_success "Finished."
    stage_blank_main ""
  fi
  cd "${output_dir}/07-Concatenated_analysis/${ortho_method}/02-Species_tree/IQ-TREE/"
    
  # 02-Rerooting the tree via Newick Utilities
  if [ "${found_outgroup}" = "1" ]; then
    stage_info_main "02-Using Newick Utilities to reroot the tree (IQ-TREE)..." 
    outgroup_name=$(cat "${output_dir}"/hybsuite_checklists/Outgroup.txt|fmt)
    stage_cmd_main "nw_reroot ${output_prefix}.treefile ${outgroup_name} > ${output_prefix}.rr.tre"
    nw_reroot "${output_prefix}.treefile" ${outgroup_name} > "${output_prefix}.rr.tre"
      
    if [ ! -s "${output_prefix}.rr.tre" ]; then
      stage_error "Fail to reroot the tree: ${output_prefix}.treefile." 
      stage_error "Please check your alignments and trees produced by IQ-TREE." 
      stage_blank_main ""
    else
      stage_info_main_success "Successfully rerooting the ${ortho_method} concatenation-based tree (IQ-TREE) to:"
      stage_info_main_success "${output_prefix}.rr.tre"
      stage_success "Finished."
      stage_blank_main "" 
    fi
  else
    stage_info_main "No outgroup name is provided. The tree will not be rerooted."
    cp ${output_prefix}.treefile ${output_prefix}.no_rr.tre
    stage_info_main_success "The final unrooted ${ortho_method} concatenation-based tree (IQ-TREE) has been written to:"
    stage_info_main_success "${output_prefix}.no_rr.tre"
    stage_success "Finished."
    stage_blank_main ""
  fi
}
################===========================================================================

################===========================================================================
# Function run_sp_tree_raxml()
################===========================================================================
run_sp_tree_raxml() {
    local ortho_method="$1"
    # input:{output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix/${prefix}_${ortho_method}.fasta
    local input="$2"
    # output:{output_dir}/07-Concatenated_analysis/${ortho_method}/02-Species_tree/RAxML
    local output="$3"

    if [ -d "${output}" ]; then
      rm -rf "${output}"
    fi
    stage_info_main "Optional step: Constructing ${ortho_method} concatenation-based species tree via RAxML"
    stage_info_main "Running RAxML to construct the ${ortho_method} concatenation-based species tree ... "
    mkdir -p "${output_dir}/07-Concatenated_analysis/${ortho_method}/02-Species_tree/RAxML"
    cd "${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix"

    # 01-Running RAxML
    stage_info_main "01-Running RAxML ..."
    define_threads "raxml"
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      run_raxmlHPC_cmd="${raxmlHPC_cmd} -f a -T ${nt_raxml} -p 12345 -x 67890 -# ${raxml_bb} -n ${prefix}_${ortho_method}.tre -w ${output}"
      if [ "${raxml_constraint_tree}" != "_____" ]; then
        run_raxmlHPC_cmd="${run_raxmlHPC_cmd} -g ${raxml_constraint_tree}"
      fi
      stage_cmd_main "${run_raxmlHPC_cmd}"
      eval "${run_raxmlHPC_cmd} > /dev/null 2>&1"
    else
      run_raxmlHPC_cmd="raxmlHPC-PTHREADS -s ${input} -m ${raxml_m} -f a -T ${nt_raxml} -p 12345 -x 67890 -# ${raxml_bb} -n ${prefix}_${ortho_method}.tre -w ${output}"
      if [ "${raxml_constraint_tree}" != "_____" ]; then
        run_raxmlHPC_cmd="${run_raxmlHPC_cmd} -g ${raxml_constraint_tree}"
      fi
      stage_cmd_main "${run_raxmlHPC_cmd}"
      eval "${run_raxmlHPC_cmd} > /dev/null 2>&1"
    fi
    if [ ! -s "${output}/RAxML_bestTree.${prefix}_${ortho_method}.tre" ]; then
      stage_info_main "Failed to run RAxML." 
      stage_info_main "HybSuite exits." 
      stage_blank_main "" 
      exit 1
    else 
      stage_info_main "Successfully constructed the ${ortho_method} concatenation-based tree (RAxML)."
      stage_info_main "The ${ortho_method} concatenation-based tree (RAxML) has been written to:"
      stage_info_main_success "${output}/"
      stage_success "Finished."
      stage_blank_main ""
    fi
    ##02-3 reroot the tree via Newick Utilities
    if [ "${found_outgroup}" = "1" ]; then
      cd "${output}"
      # Run Newick Utilities to reroot the tree
      stage_info_main "02-Using Newick Utilities to reroot the tree (RAxML)..." 
      outgroup_name=$(cat "${output_dir}"/hybsuite_checklists/Outgroup.txt|fmt)
      stage_cmd_main "nw_reroot ${output}/RAxML_bipartitions.${prefix}_${ortho_method}.tre ${outgroup_name} -l > ${output}/RAxML_rr_${prefix}_${ortho_method}.tre"
      nw_reroot ${output}/RAxML_bipartitions.${prefix}_${ortho_method}.tre ${outgroup_name} -l > ${output}/RAxML_rr_${prefix}_${ortho_method}.tre
      
      # Check if the user ran Newick Utilities successfully
      if [ ! -s "${output}/RAxML_rr_${prefix}_${ortho_method}.tre" ]; then
        stage_error "Failed to reroot the tree: ${output}/RAxML_bipartitions.${prefix}_${ortho_method}.tre." 
        stage_error "Please check your alignments and trees produced by RAxML." 
        stage_blank_main ""
      else
        stage_info_main "Successfully rerooted the ${ortho_method} concatenation-based tree (RAxML)." 
        stage_info_main "The final rooted ${ortho_method} concatenation-based tree (RAxML) has been written to:"
        stage_info_main "${output}/RAxML_rr_${prefix}_${ortho_method}.tre"
        stage_success "Finished."
        stage_blank_main ""
      fi
    else
      stage_info_main "No outgroup name is provided. The tree will not be rerooted."
      cp ${output}/RAxML_bipartitions.${prefix}_${ortho_method}.tre ${output}/RAxML_no_rr_${prefix}_${ortho_method}.tre
      stage_info_main "The final unrooted ${ortho_method} concatenation-based tree (RAxML) has been written to:"
      stage_info_main "${output}/RAxML_no_rr_${prefix}_${ortho_method}.tre"
      stage_success "Finished."
      stage_blank_main ""
    fi
}
################===========================================================================

################===========================================================================
# Function run_sp_tree_raxml_ng()
################===========================================================================
run_sp_tree_raxml_ng() {
    local ortho_method="$1"
    local input="$2"
    # output:{output_dir}/07-Concatenated_analysis/${ortho_method}/02-Species_tree/RAxML-NG
    local output="$3"
    
    if [ -d "${output}" ]; then
      rm -rf "${output}"
    fi
    stage_info_main "Optional step: Constructing ${ortho_method} concatenation-based species tree via RAxML-NG"
    ##01 Set the directory
    mkdir -p "${output}"
    cd "${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix"
    ##02 Run RAxML-NG
    stage_info_main "01-Running RAxML-NG ..." 
    define_threads "raxml_ng"
    ##02.1 If the user sets the rng_force parameter to TRUE, the Ignore Thread warning feature is enabled (add the --force perf_threads parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      raxml_ng_cmd="${raxml_ng_cmd} --all --threads ${nt_raxml_ng} --prefix ${output_dir}/07-Concatenated_analysis/${ortho_method}/02-Species_tree/RAxML-NG/RAxML-NG_${prefix}_${ortho_method} --bs-trees ${rng_bs_trees}"
      if [ "${rng_force}" = "TRUE" ]; then
        raxml_ng_cmd="${raxml_ng_cmd} --force perf_threads"
      fi
      if [ -s "${rng_constraint_tree}" ]; then
        raxml_ng_cmd="${raxml_ng_cmd} --tree-constraint ${rng_constraint_tree}"
      fi
      stage_cmd_main "${raxml_ng_cmd}"
      eval "${raxml_ng_cmd} > /dev/null 2>&1"
    else
      raxml-ng --parse --msa ${output_dir}/05-Supermatrix/${ortho_method}/HybSuite_${ortho_method}.fasta \
        --model GTR+G \
        --prefix ${output_dir}/07-Concatenated_analysis/${ortho_method}/02-Species_tree/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"  > /dev/null 2>&1
      Model=$(grep "Model:" ${output_dir}/07-Concatenated_analysis/${ortho_method}/02-Species_tree/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
      raxml_ng_cmd="raxml-ng --all --msa ${input} --model ${Model} --threads ${nt_raxml_ng} --prefix ${output}/RAxML-NG_${prefix}_${ortho_method} --bs-trees ${rng_bs_trees}"
      if [ "${rng_force}" = "TRUE" ]; then
        raxml_ng_cmd="${raxml_ng_cmd} --force perf_threads"
      fi
      if [ -s "${rng_constraint_tree}" ]; then
        raxml_ng_cmd="${raxml_ng_cmd} --tree-constraint ${rng_constraint_tree}"
      fi
      stage_cmd_main "${raxml_ng_cmd}"
      eval "${raxml_ng_cmd} > /dev/null 2>&1"
    fi

    ##02.2 Check if the user ran RAxML-NG successfully
    if [ ! -s "${output}/RAxML-NG_${prefix}_${ortho_method}.raxml.support" ]; then
      stage_error "Failed to run RAxML-NG."
      stage_error "HybSuite exits."
      stage_blank_main "" 
      exit 1
    else 
      stage_info_main "Successfully constructed the ${ortho_method} concatenation-based tree (RAxML-NG)." 
      stage_info_main "The ${ortho_method} concatenation-based tree (RAxML-NG) has been written to:"
      stage_info_main_success "${output}/RAxML-NG_${prefix}_${ortho_method}.raxml.support"
      stage_success "Finished."
      stage_blank_main ""
    fi
    ##03 reroot the tree via Newick Utilities
    if [ "${found_outgroup}" = "1" ]; then
      cd "${output}"
      stage_info_main "02-Using Newick Utilities to reroot the tree (RAxML-NG)..."
      outgroup_name=$(cat "${output_dir}"/hybsuite_checklists/Outgroup.txt|fmt)
      stage_cmd_main "nw_reroot ${output}/RAxML-NG_${prefix}_${ortho_method}.raxml.support ${outgroup_name} -l > ${output}/RAxML-NG_${prefix}_${ortho_method}.rr.tre"
      nw_reroot "${output}/RAxML-NG_${prefix}_${ortho_method}.raxml.support" "${outgroup_name}" -l > "${output}/RAxML-NG_${prefix}_${ortho_method}.rr.tre"
    
      if [ ! -s "${output}/RAxML-NG_${prefix}_${ortho_method}.rr.tre" ]; then
        stage_error "Failed to reroot the tree: ${output}/RAxML-NG_${prefix}_${ortho_method}.tre." 
        stage_error "Please check your alignments and trees produced by RAxML-NG." 
        stage_blank_main ""
      else
          stage_info_main_success "Successfully rerooting the ${ortho_method} concatenation-based tree (RAxML-NG)."
          stage_info_main_success "The final rooted ${ortho_method} concatenation-based tree (RAxML-NG) has been written to:"
          stage_info_main_success "${output}/RAxML-NG_${prefix}_${ortho_method}.rr.tre"
          stage_success "Finished."
          stage_blank_main ""
      fi
    else
      stage_info_main "No outgroup name is provided. The tree will not be rerooted."
      cp ${output}/RAxML-NG_${prefix}_${ortho_method}.raxml.support ${output}/RAxML-NG_${prefix}_${ortho_method}.no_rr.tre
      stage_info_main "The final unrooted ${ortho_method} concatenation-based tree (RAxML-NG) has been written to:"
      stage_info_main "${output}/RAxML-NG_${prefix}_${ortho_method}.no_rr.tre"
      stage_success "Finished."
      stage_blank_main ""
    fi
}
################===========================================================================

################===========================================================================
# Function gene_tree_iqtree_fasttree()
################===========================================================================
gene_tree_iqtree_fasttree() {
    local ortho_method="$1"
    # input:{output_dir}/06-Final_alignments/${ortho_method}
    local input="$2"
    # output: {output_dir}/08-Coalescent_analysis/${ortho_method}/01-Gene_trees
    local output="$3"
    
    rm -rf "${output}"
    mkdir -p "${output}"
    cd "${input}"
    temp_file="fasta_file_list.txt"
    find . -maxdepth 1 -type f -name "*.aln.trimmed.fasta" -exec basename {} \; > "$temp_file"
    total_sps=$(find . -maxdepth 1 -type f -name "*.aln.trimmed.fasta" | wc -l)
    # Initialize parallel environment
    init_parallel_env "$work_dir" "$total_sps" "$process" "${temp_file}" || exit 1
    if [ "${gene_tree}" = "1" ]; then
      gene_tree_tool="IQ-TREE"
      define_threads "iqtree"
    elif [ "${gene_tree}" = "2" ]; then
      gene_tree_tool="FastTree"
      define_threads "fasttree"
      export OMP_NUM_THREADS=${nt_fasttree}
    fi
    stage_info_main "====>> Running ${gene_tree_tool} to construct single gene trees (${process} in parallel) ====>>"
    while IFS= read -r file || [ -n "$file" ]; do
      filename=${file%.aln.trimmed.fasta}
      if [ "${process}" != "all" ]; then
        read -u1000
      fi
      {
        # Update start count
        update_start_count "$filename" "$stage_logfile"
        if [ "${gene_tree}" = "1" ]; then
          stage_cmd "${log_mode}" "iqtree -s ${input}/${filename}.aln.trimmed.fasta -m MFP -nt ${nt_iqtree} -bb ${gene_tree_bb} -pre ${paralogs_dir}/${ortho_method}/${filename}.aln.trimmed.fasta"
          iqtree -s "${input}/${filename}.aln.trimmed.fasta" -m MFP -nt ${nt_iqtree} -bb "${gene_tree_bb}" -pre "${output}/${filename}" > /dev/null 2>&1
          if [ -s "${output}/${filename}.treefile" ]; then
            mv "${output}/${filename}.treefile" "${output}/${filename}.tre"
            find "${output}" -maxdepth 1 -name "${filename}.*" ! -name "*.tre" ! -delete
          else
            record_failed_sample "$filename"
          fi
        elif [ "${gene_tree}" = "2" ]; then
          stage_cmd "${log_mode}" "FastTreeMP -nt -gtr -gamma -boot ${gene_tree_bb} ${input}/${filename}.aln.trimmed.fasta > ${output}/${filename}.tre"
          FastTreeMP -nt -gtr -gamma -boot "${gene_tree_bb}" "${input}/${filename}.aln.trimmed.fasta" > "${output}/${filename}.tre" 2>/dev/null
          if [ ! -s "${output}/${filename}.tre" ]; then
            record_failed_sample "$filename"
          fi
        fi
        # Update failed count
        update_finish_count "$filename" "$stage_logfile"
        if [ "${process}" != "all" ]; then
          echo >&1000
        fi
      } &
      if [ "${log_mode}" = "cmd" ] || [ "${log_mode}" = "full" ]; then
        if [ "${gene_tree}" = "1" ]; then
          display_only_failed_log "$stage_logfile" "Failed to construct single gene trees via IQ-Tree:"
        elif [ "${gene_tree}" = "2" ]; then
          display_only_failed_log "$stage_logfile" "Failed to construct single gene trees via FastTree:"
        fi
      fi
    done < "$temp_file"
    rm "$temp_file"
    wait
    echo
    # Display processing log
    if [ "${log_mode}" = "full" ]; then
      if [ "${gene_tree}" = "1" ]; then
        display_process_log "$stage_logfile" "Failed to construct single gene trees via IQ-Tree:"
      elif [ "${gene_tree}" = "2" ]; then
        display_process_log "$stage_logfile" "Failed to construct single gene trees via FastTree:"
      fi
    fi
    if ! find "${output}" -type f -name '*.tre' -size +0c -quit 2>/dev/null; then
      stage_error "Failed to construct single gene trees via IQ-Tree/FastTree."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
    stage_success "Finished."
}

################===========================================================================
# Function combine_gene_trees()
################===========================================================================
combine_gene_trees() {
    local ortho_method="$1"
    # input: {output_dir}/08-Coalescent_analysis/${ortho_method}/01-Gene_trees
    local input="$2"
    # output: {output_dir}/08-Coalescent_analysis/${ortho_method}/02-Combined_gene_trees
    local output="$3"
    
    rm -rf "${output}"
    mkdir -p "${output}"
    awk '1' ${input}/*.tre > ${output}/Combined_gene_trees.tre
    
    if [ -s "${output}/Combined_gene_trees.tre" ]; then
      stage_info_main "Successfully combining single gene trees into a combined gene tree."
      stage_info_main "The combined gene tree has been written to:"
      stage_info_main "${output}/Combined_gene_trees.tre"
      stage_success "Finished."
    else
      stage_error "Failed to combine single gene trees into a combined gene tree."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
}

################===========================================================================
# Function collapse_gene_trees()
################===========================================================================
collapse_gene_trees() {
  local input_combined_tree="$1"

  if [ "${collapse_threshold}" = "0" ]; then
    stage_info_main "Collapsing gene trees is disabled."
  else
    stage_info_main "Collapsing gene trees is enabled."
    stage_info_main "The collapsing threshold is ${collapse_threshold}."
    stage_cmd_main "nw_ed ${input_combined_tree} "i & b <=${collapse_threshold}" o > ${input_combined_tree}.collapsed"
    nw_ed ${input_combined_tree} "i & b <=${collapse_threshold}" o > ${input_combined_tree}.collapsed
    cp "${input_combined_tree}.collapsed" "${input_combined_tree}"
    rm -f ${input_combined_tree}.collapsed
    if [ -s "${input_combined_tree}" ]; then
      stage_info_main "The collapsed gene trees have been written to:"
      stage_info_main "${input_combined_tree}"
      stage_success "Finished."
      stage_blank_main ""
    else
      stage_warning "Failed to collapse gene trees."
      stage_warning "The original gene trees have been written to:"
      stage_warning "${input_combined_tree}"
      stage_blank_main ""
    fi
  fi
}

################===========================================================================
# Function run_astral4()
################===========================================================================
run_astral4() {
    local ortho_method="$1"
    # input: {output_dir}/08-Coalescent_analysis/${ortho_method}/02-Combined_gene_trees/Combined_gene_trees.tre
    local input_combined_tree="$2"
    # output: {output_dir}/08-Coalescent_analysis/${ortho_method}/03-Species_tree/ASTRAL-IV
    local output="$3"

    define_threads "astral4"
    rm -rf "${output}"
    mkdir -p "${output}"
    stage_info_main_light_purple "====>> ASTRAL-IV for ${ortho_method} orthogroups<<===="
    stage_info_main "01-Running ASTRAL-Ⅳ ..."
    stage_cmd "${log_mode}" "astral4 -t ${nt_astral4} -r ${astral4_r} -s ${astral4_s} -i ${input_combined_tree} -o ${output}/ASTRAL4_${prefix}_${ortho_method}.tre 2> ${output}/${prefix}_${ortho_method}_ASTRAL4.log"
    astral4 \
    -t "${nt_astral4}" \
    -r "${astral4_r}" \
    -s "${astral4_s}" \
    -i "${input_combined_tree}" \
    -o "${output}/ASTRAL4_${prefix}_${ortho_method}.tre" > "${output}/${prefix}_${ortho_method}_ASTRAL4.log" 2>&1
    if [ -s "${output}/ASTRAL4_${prefix}_${ortho_method}.tre" ]; then
      stage_info_main "Succeed to run ASTRAL-Ⅳ for ${ortho_method} orthogroups."
      stage_info_main "The ASTRAL-Ⅳ tree for ${ortho_method} orthogroups has been written to:"
      stage_info_main "${output}/ASTRAL4_${prefix}_${ortho_method}.tre"
      stage_success "Finished."
    else
      stage_error "Fail to run ASTRAL-Ⅳ for ${ortho_method} orthogroups."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi

    stage_info_main "02-Bootstrapping the ASTRAL-Ⅳ tree ..."
    java -jar ${dependencies_dir}/ASTRAL-master/Astral/astral.5.7.8.jar \
    -i "${input_combined_tree}" \
    -o "${output}/ASTRAL4_${prefix}_${ortho_method}.bootstrap.tre" \
    -q "${output}/ASTRAL4_${prefix}_${ortho_method}.tre" >> ${output}/ASTRAL4_${prefix}_${ortho_method}.log 2>&1

    if [ -s "${output}/ASTRAL4_${prefix}_${ortho_method}.bootstrap.tre" ]; then
      stage_info_main "Succeed to bootstrap the ASTRAL-Ⅳ tree."
      stage_info_main "The ASTRAL-Ⅳ tree with bootstrap values has been written to:"
      stage_info_main "${output}/ASTRAL4_${prefix}_${ortho_method}.bootstrap.tre"
      stage_success "Finished."
    else
      stage_error "Failed to bootstrap the ASTRAL-Ⅳ tree."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
    # Reroot the ASTRAL-IV tree
    if [ "${found_outgroup}" = "1" ]; then
      cd "${output}"
      stage_info_main "03-Using Newick Utilities to reroot the tree (ASTRAL-IV)..."
      outgroup_name=$(cat "${output_dir}"/hybsuite_checklists/Outgroup.txt|fmt)
      stage_cmd_main "nw_reroot ${output}/ASTRAL4_${prefix}_${ortho_method}.bootstrap.tre ${outgroup_name} -l > ${output}/ASTRAL4_${prefix}_${ortho_method}.bootstrap.rr.tre"
      nw_reroot "${output}/ASTRAL4_${prefix}_${ortho_method}.bootstrap.tre" "${outgroup_name}" -l > "${output}/ASTRAL4_${prefix}_${ortho_method}.bootstrap.rr.tre"
    
      if [ ! -s "${output}/ASTRAL4_${prefix}_${ortho_method}.bootstrap.rr.tre" ]; then
        stage_error "Failed to reroot the tree: ${output}/ASTRAL4_${prefix}_${ortho_method}.bootstrap.rr.tre." 
        stage_error "Please check your alignments and trees produced by ASTRAL-IV." 
        stage_blank_main ""
      else
          stage_info_main "Succeed to reroot the ASTRAL-IV tree."
          stage_info_main "The final rooted ASTRAL-IV tree with bootstrap values has been written to:"
          stage_info_main "${output}/ASTRAL4_${prefix}_${ortho_method}.bootstrap.rr.tre"
          stage_success "Finished."
      fi
    else
      stage_info_main "No outgroup name is provided. The tree will not be rerooted."
      cp ${output}/ASTRAL4_${prefix}_${ortho_method}.bootstrap.tre ${output}/ASTRAL4_${prefix}_${ortho_method}.bootstrap.no_rr.tre
      stage_info_main "The final unrooted ${ortho_method} concatenation-based tree (ASTRAL-IV) has been written to:"
      stage_info_main "${output}/ASTRAL4_${prefix}_${ortho_method}.bootstrap.no_rr.tre"
      stage_success "Finished."
    fi
  }
################===========================================================================

################===========================================================================
# Function run_astral_pro()
################===========================================================================
run_astral_pro() {
  # input: {output_dir}/08-Coalescent_analysis/ASTRAL-Pro/02-Combined_gene_trees/Combined_gene_trees.tre
  local input_combined_tree="$1"
  # output: {output_dir}/08-Coalescent_analysis/ASTRAL-Pro/03-Species_tree
  local output="$2"

  define_threads "astral_pro"
  rm -rf "${output}"
  mkdir -p "${output}"
  stage_info_main "01-Running ASTRAL-Pro ..."
  stage_cmd "${log_mode}" "astral-pro3 -t ${nt_astral_pro} -r ${astral_pro_r} -s ${astral_pro_s} -i ${input_combined_tree} -o ${output}/ASTRAL-Pro_${prefix}.tre 2> ${output}/ASTRAL-Pro_${prefix}.log"
  astral-pro3 \
  -t "${nt_astral_pro}" \
  -r "${astral_pro_r}" \
  -s "${astral_pro_s}" \
  -i "${input_combined_tree}" \
  -o "${output}/ASTRAL-Pro_${prefix}.tre" > "${output}/ASTRAL-Pro_${prefix}.log" 2>&1
  if [ -s "${output}/ASTRAL-Pro_${prefix}.tre" ]; then
    stage_info_main "Succeed to run ASTRAL-Pro for paralogs inclusion method."
    stage_info_main "The ASTRAL-Pro tree has been written to:"
    stage_info_main "${output}/ASTRAL-Pro_${prefix}.tre"
    stage_success "Finished."
  else
    stage_error "Failed to run ASTRAL-Pro for paralogs inclusion method."
    stage_error "HybSuite exits."
    stage_blank_main ""
    exit 1
  fi

  # Reroot the ASTRAL-Pro tree
  if [ "${found_outgroup}" = "1" ]; then
    cd "${output}"
    stage_info_main "02-Using Newick Utilities to reroot the tree (ASTRAL-Pro)..."
    outgroup_name=$(cat "${output_dir}"/hybsuite_checklists/Outgroup.txt|fmt)
    stage_cmd_main "nw_reroot ${output}/ASTRAL-Pro_${prefix}.tre ${outgroup_name} -l > ${output}/ASTRAL-Pro_${prefix}.rr.tre"
    nw_reroot "${output}/ASTRAL-Pro_${prefix}.tre" "${outgroup_name}" -l > "${output}/ASTRAL-Pro_${prefix}.rr.tre"
    
    if [ ! -s "${output}/ASTRAL-Pro_${prefix}.rr.tre" ]; then
      stage_error "Failed to reroot the tree: ${output}/ASTRAL-Pro_${prefix}.rr.tre." 
      stage_error "Please check your alignments and trees produced by ASTRAL-Pro." 
      stage_blank_main ""
    else
      stage_info_main "Succeed to reroot the ASTRAL-Pro tree."
      stage_info_main "The final rooted ASTRAL-Pro tree has been written to:"
      stage_info_main "${output}/ASTRAL-Pro_${prefix}.rr.tre"
      stage_success "Finished."
    fi
  else
    stage_info_main "No outgroup name is provided. The tree will not be rerooted."
    cp ${output}/ASTRAL-Pro_${prefix}.tre ${output}/ASTRAL-Pro_${prefix}.no_rr.tre
    stage_info_main "The final unrooted ASTRAL-Pro tree has been written to:"
    stage_info_main "${output}/ASTRAL-Pro_${prefix}.no_rr.tre"
    stage_success "Finished."
  fi
}

################===========================================================================
# Function count_species()
################===========================================================================
count_species() {
  local fasta_dir="$1"

  temp_file="${fasta_dir}/species_list.txt"
  for fasta_file in "$fasta_dir"/*.fasta; do
    if [ -f "$fasta_file" ]; then
        grep "^>" "$fasta_file" | sort | uniq >> "$temp_file"
    fi
  done
  total_sps_num=$(sort "$temp_file" | uniq | wc -l)
  rm "$temp_file"
}



################===========================================================================
# Function run_wastral()
################===========================================================================
run_wastral() {
  local ortho_method="$1"
  # input: {output_dir}/08-Coalescent_analysis/${ortho_method}/02-Combined_gene_trees/Combined_gene_trees.tre
  local input_combined_tree="$2"
  # output: {output_dir}/08-Coalescent_analysis/${ortho_method}/03-Species_tree/wASTRAL
  local output="$3"
  # alignment_dir: {output_dir}/06-Final_alignments/${ortho_method}/
  local alignment_dir="$4"

  rm -rf ${output}
  mkdir -p ${output}
  define_threads "wastral"
  count_species "${alignment_dir}"
  
  stage_info_main_light_purple "====>> wASTRAL for ${ortho_method} orthogroups <<===="
  stage_info_main "01-Running wASTRAL ..."
  # if the number of species is less than 2000, run wastral
  if [ ${total_sps_num} -lt 2000 ]; then
    # 01-run wastral
    stage_cmd_main "wastral --mode ${wastral_mode} -t ${nt_wastral} -r ${wastral_r} -s ${wastral_s} -o ${output}/wASTRAL_${prefix}_${ortho_method}.tre ${input_combined_tree} 2> ${output}/wASTRAL_${prefix}_${ortho_method}.log"
    wastral --mode "${wastral_mode}" -t "${nt_wastral}" \
    -r "${wastral_r}" -s "${wastral_s}" \
    -o "${output}/wASTRAL_${prefix}_${ortho_method}.tre" \
    "${input_combined_tree}" 2> "${output}/wASTRAL_${prefix}_${ortho_method}.log"
  # if the number of species is more than 2000, run wastral_precise
  else
    # 01-run wastral
    stage_cmd_main "wastral_precise --mode ${wastral_mode} -t ${nt_wastral} -r ${wastral_r} -s ${wastral_s} -o ${output}/wASTRAL_${prefix}_${ortho_method}.tre ${input_combined_tree} 2> ${output}/wASTRAL_${prefix}_${ortho_method}.log"
    wastral_precise --mode ${wastral_mode} -t ${nt_wastral} \
    -r ${wastral_r} -s ${wastral_s} \
    -o "${output}/wASTRAL_${prefix}_${ortho_method}.tre" \
    "${input_combined_tree}" 2> ${output}/wASTRAL_${prefix}_${ortho_method}.log 2>&1
  fi
      
  if [ -s "${output}/wASTRAL_${prefix}_${ortho_method}.tre" ]; then
    stage_info_main "Succeed to run wASTRAL"
    stage_info_main "The wASTRAL tree has been written to:"
    stage_info_main "${output}/wASTRAL_${prefix}_${ortho_method}.tre"
    stage_success "Finished."
  else
    stage_error "Fail to run wASTRAL."
    stage_blank_main ""
  fi
  # 02-Rerooting the wASTRAL tree
  if [ "${found_outgroup}" = "1" ]; then
    cd "${output}"
    stage_info_main "02-Using Newick Utilities to reroot the tree (wASTRAL)..."
    outgroup_name=$(cat "${output_dir}"/hybsuite_checklists/Outgroup.txt|fmt)
    stage_cmd_main "nw_reroot ${output}/wASTRAL_${prefix}_${ortho_method}.tre ${outgroup_name} -l > ${output}/wASTRAL_${prefix}_${ortho_method}.rr.tre"
    nw_reroot "${output}/wASTRAL_${prefix}_${ortho_method}.tre" "${outgroup_name}" -l > "${output}/wASTRAL_${prefix}_${ortho_method}.rr.tre"
    
    if [ ! -s "${output}/wASTRAL_${prefix}_${ortho_method}.rr.tre" ]; then
      stage_error "Failed to reroot the tree: ${output}/wASTRAL_${prefix}_${ortho_method}.rr.tre." 
      stage_error "Please check your alignments and trees produced by wASTRAL." 
      stage_blank_main ""
    else
      stage_info_main "Succeed to reroot the wASTRAL tree."
      stage_info_main "The final rooted wASTRAL tree has been written to:"
      stage_info_main "${output}/wASTRAL_${prefix}_${ortho_method}.rr.tre"
      stage_success "Finished."
    fi
  else
    stage_info_main "No outgroup name is provided. The tree will not be rerooted."
    cp ${output}/wASTRAL_${prefix}_${ortho_method}.tre ${output}/wASTRAL_${prefix}_${ortho_method}.no_rr.tre
    stage_info_main "The final unrooted ${ortho_method} concatenation-based tree (wASTRAL) has been written to:"
    stage_info_main "${output}/wASTRAL_${prefix}_${ortho_method}.no_rr.tre"
    stage_success "Finished."
  fi
}
################===========================================================================

################===========================================================================
# Function run_phypartspiecharts()
################===========================================================================
run_phyparts_piecharts() {
  local suffix="$1"
  local sp_tree_method="$2"
  local input_gene_trees="$3"
  local input_sp_tree="$4"
  # output: ${output_dir}/08-Coalescent_analysis/${ortho_method}/05-PhyParts_PieCharts
  local output="$5"
    
  if [ "${run_phyparts}" = "TRUE" ]; then
    if [ -d "${output}" ]; then
      rm -rf "${output}"
    fi
    mkdir -p "${output}"
    stage_info_main "Running PhyPartsPieCharts for ${sp_tree_method} coalescent-based tree ..."
    stage_cmd "${log_mode}" "java -jar ${dependencies_dir}/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d ${input_gene_trees} -m ${input_sp_tree} -o ${output}/ASTRAL_PhyParts"
    java -jar ${dependencies_dir}/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar \
    -a 1 -v -d ${input_gene_trees} \
    -m ${input_sp_tree} \
    -o ${output}/${sp_tree_method}_PhyParts > /dev/null 2>&1
              
    phyparts_number=$(find ${input_gene_trees} -type f -name "*.tre" | wc -l)
    cd "${output}"
    python3 ${script_dir}/modified_phypartspiecharts.py \
    ${input_sp_tree} \
    ${sp_tree_method}_PhyParts "${phyparts_number}" \
    --output "${output}/${sp_tree_method}_phypartspiecharts_${suffix}.svg" \
    --to_csv \
    --tree_type "${phypartspiecharts_tree_type}" \
    --show_num_mode "${phypartspiecharts_num_mode}" \
    --stat "${output}/${sp_tree_method}_phypartspiecharts_${suffix}.tsv" \
    --threads "${nt}" > /dev/null 2>&1
      
    stage_cmd "${log_mode}" "python3 ${script_dir}/modified_phypartspiecharts.py ${input_sp_tree} ${sp_tree_method}_PhyParts ${phyparts_number} --output ${output}/${sp_tree_method}_phypartspiecharts_${suffix}.svg --to_csv --tree_type ${phypartspiecharts_tree_type} --show_num_mode ${phypartspiecharts_num_mode} --stat ${output}/${sp_tree_method}_phypartspiecharts_${suffix}.tsv --threads ${nt}"
    if [ -s "${output}/${sp_tree_method}_phypartspiecharts_${suffix}.svg" ]; then
      stage_success "Finished."
      stage_blank_main ""
    else
      stage_error "Failed to run modified_phypartspiecharts.py for ${sp_tree_method} results."
      stage_blank_main ""
    fi
  fi
}
################===========================================================================

################===========================================================================
# Function run_phyparts_astral4_wastral()
################===========================================================================
run_phyparts_piecharts_astral4() {
  local ortho_method="$1"

  if [ "${run_phyparts}" = "TRUE" ] && [ "${run_astral4}" = "TRUE" ]; then
    if [ -s "${output_dir}/08-Coalescent_analysis/${ortho_method}/03-Species_tree/ASTRAL-IV/ASTRAL4_${prefix}_${ortho_method}.bootstrap.rr.tre" ]; then
      stage_info_main "01-Rerooting the gene trees via Reroot_genetrees.R ..."
      reroot_gene_trees "${output_dir}/08-Coalescent_analysis/${ortho_method}/01-Gene_trees" "${output_dir}/08-Coalescent_analysis/${ortho_method}/04-Rerooted_gene_trees"
      if ! find "${output_dir}/08-Coalescent_analysis/${ortho_method}/04-Rerooted_gene_trees" -type f -name "*.rr.tre" | grep -q .; then
        stage_error "Failed to reroot the gene trees via Reroot_genetrees.R."
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      fi
      stage_info_main "02-Running PhyPartsPieCharts and modified_phypartspiecharts.py ..."
      run_phyparts_piecharts "${prefix}_${ortho_method}" "ASTRAL-IV" "${output_dir}/08-Coalescent_analysis/${ortho_method}/04-Rerooted_gene_trees" "${output_dir}/08-Coalescent_analysis/${ortho_method}/03-Species_tree/ASTRAL-IV/ASTRAL4_${prefix}_${ortho_method}.bootstrap.rr.tre" "${output_dir}/08-Coalescent_analysis/${ortho_method}/05-PhyParts_PieCharts/ASTRAL-IV"
    elif [ -s "${output_dir}/08-Coalescent_analysis/${ortho_method}/03-Species_tree/ASTRAL-IV/ASTRAL4_${prefix}_${ortho_method}.bootstrap.no_rr.tre" ]; then
      stage_info_main "01-Rerooting the gene trees via Reroot_genetrees.R ..."
      stage_info_main "No outgroup found, skipping rerooting step"
      stage_info_main "02-Running PhyPartsPieCharts and modified_phypartspiecharts.py ..."
      run_phyparts_piecharts "${prefix}_${ortho_method}" "ASTRAL-IV" "${output_dir}/08-Coalescent_analysis/${ortho_method}/01-Gene_trees" "${output_dir}/08-Coalescent_analysis/${ortho_method}/03-Species_tree/ASTRAL-IV/ASTRAL4_${prefix}_${ortho_method}.bootstrap.no_rr.tre" "${output_dir}/08-Coalescent_analysis/${ortho_method}/05-PhyParts_PieCharts/ASTRAL-IV"
    fi
  fi
}

################===========================================================================
# Function run_phyparts_piecharts_wastral()
################===========================================================================
run_phyparts_piecharts_wastral() {
  local ortho_method="$1"

  if [ "${run_phyparts}" = "TRUE" ] && [ "${run_wastral}" = "TRUE" ]; then
    if [ -s "${output_dir}/08-Coalescent_analysis/${ortho_method}/03-Species_tree/wASTRAL/wASTRAL_${prefix}_${ortho_method}.rr.tre" ]; then
      stage_info_main "01-Rerooting the gene trees via Reroot_genetrees.R ..."
      reroot_gene_trees "${output_dir}/08-Coalescent_analysis/${ortho_method}/01-Gene_trees" "${output_dir}/08-Coalescent_analysis/${ortho_method}/04-Rerooted_gene_trees"
      if ! find "${output_dir}/08-Coalescent_analysis/${ortho_method}/04-Rerooted_gene_trees" -type f -name "*.rr.tre" | grep -q .; then
        stage_error "Failed to reroot the gene trees via Reroot_genetrees.R."
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      fi
      stage_info_main "02-Running PhyPartsPieCharts and modified_phypartspiecharts.py ..."
      run_phyparts_piecharts "${prefix}_${ortho_method}" "wASTRAL" "${output_dir}/08-Coalescent_analysis/${ortho_method}/04-Rerooted_gene_trees" "${output_dir}/08-Coalescent_analysis/${ortho_method}/03-Species_tree/wASTRAL/wASTRAL_${prefix}_${ortho_method}.rr.tre" "${output_dir}/08-Coalescent_analysis/${ortho_method}/05-PhyParts_PieCharts/wASTRAL"
    elif [ -s "${output_dir}/08-Coalescent_analysis/${ortho_method}/03-Species_tree/wASTRAL/wASTRAL_${prefix}_${ortho_method}.no_rr.tre" ]; then
      stage_info_main "01-Rerooting the gene trees via Reroot_genetrees.R ..."
      stage_info_main "No outgroup found, skipping rerooting step"
      stage_info_main "02-Running PhyPartsPieCharts and modified_phypartspiecharts.py ..."
      run_phyparts_piecharts "${prefix}_${ortho_method}" "wASTRAL" "${output_dir}/08-Coalescent_analysis/${ortho_method}/01-Gene_trees" "${output_dir}/08-Coalescent_analysis/${ortho_method}/03-Species_tree/wASTRAL/wASTRAL_${prefix}_${ortho_method}.no_rr.tre" "${output_dir}/08-Coalescent_analysis/${ortho_method}/05-PhyParts_PieCharts/wASTRAL"
    fi
  fi
}
################===========================================================================

################===========================================================================
# Function run_phyparts_piecharts_astral_pro()
################===========================================================================
run_phyparts_piecharts_astral_pro() {
  if [ "${run_phyparts}" = "TRUE" ] && [ "${run_astral_pro}" = "TRUE" ]; then
    if [ -s "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/03-Species_tree/ASTRAL-Pro_${prefix}.rr.tre" ]; then
      stage_info_main "01-Rerooting the gene trees via Reroot_genetrees.R ..."
      reroot_gene_trees "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees" "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/04-Rerooted_gene_trees"
      if ! find "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/04-Rerooted_gene_trees" -type f -name "*.rr.tre" | grep -q .; then
        stage_error "Failed to reroot the gene trees via Reroot_genetrees.R."
        stage_error "HybSuite exits."
        stage_blank_main ""
        exit 1
      fi
      stage_info_main "02-Running PhyPartsPieCharts and modified_phypartspiecharts.py ..."
      run_phyparts_piecharts "${prefix}" "ASTRAL-Pro" "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/04-Rerooted_gene_trees" "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/03-Species_tree/ASTRAL-Pro_${prefix}.rr.tre" "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/05-PhyParts_PieCharts/ASTRAL-Pro"
    elif [ -s "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/03-Species_tree/ASTRAL-Pro_${prefix}.no_rr.tre" ]; then
      stage_info_main "01-Rerooting the gene trees via Reroot_genetrees.R ..."
      stage_info_main "No outgroup found, skipping rerooting step"
      stage_info_main "02-Running PhyPartsPieCharts and modified_phypartspiecharts.py ..."
      run_phyparts_piecharts "${prefix}" "ASTRAL-Pro" "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees" "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/03-Species_tree/ASTRAL-Pro_${prefix}.no_rr.tre" "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/05-PhyParts_PieCharts/ASTRAL-Pro"
    fi
  fi
}

################===========================================================================
# Function concatenated_analysis()
################===========================================================================
concatenated_analysis() {
  local ortho_method="$1"
  
  if [ "${run_iqtree}" = "TRUE" ] || [ "${run_raxml}" = "TRUE" ] || [ "${run_raxml_ng}" = "TRUE" ]; then
    stage_info_main "====>> concatenation analysis for ${ortho_method} alignments <<===="
    stage_info_main_blue "Step 1: Concatenating alignments ..."
    concatenation "${ortho_method}" "${paralogs_dir}/${ortho_method}"
    stage_info_main_blue "Step 2: Species tree inference ..."
    run_modeltest_ng "${ortho_method}" "${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix/${prefix}_${ortho_method}.fasta" "${output_dir}/07-Concatenated_analysis/${ortho_method}/02-Species_tree/${prefix}_${ortho_method}_ModelTest_NG.txt"
    if [ "${run_iqtree}" = "TRUE" ]; then
      run_sp_tree_iqtree "${ortho_method}" "${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix/${prefix}_${ortho_method}.fasta" "${output_dir}/07-Concatenated_analysis/${ortho_method}/02-Species_tree/IQ-TREE/IQ-TREE_${prefix}_${ortho_method}"
    fi
    if [ "${run_raxml}" = "TRUE" ]; then
      run_sp_tree_raxml "${ortho_method}" "${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix/${prefix}_${ortho_method}.fasta" "${output_dir}/07-Concatenated_analysis/${ortho_method}/02-Species_tree/RAxML"
    fi
    if [ "${run_raxml_ng}" = "TRUE" ]; then
      run_sp_tree_raxml_ng "${ortho_method}" "${output_dir}/07-Concatenated_analysis/${ortho_method}/01-Supermatrix/${prefix}_${ortho_method}.fasta" "${output_dir}/07-Concatenated_analysis/${ortho_method}/02-Species_tree/RAxML-NG"
    fi
  fi
}
################===========================================================================

################===========================================================================
# Function coalescent_analysis()
################===========================================================================
coalescent_analysis() {
  local ortho_method="$1"

  if [ "${run_astral4}" = "TRUE" ] || [ "${run_wastral}" = "TRUE" ]; then
    stage_info_main_purple "====>> Coalescent analysis on ${ortho_method} alignments <<===="
    # Step 1: Preparing gene trees
    stage_info_main_blue "Step 1: Preparing gene trees ..."
    gene_tree_iqtree_fasttree "${ortho_method}" "${paralogs_dir}/${ortho_method}" "${output_dir}/08-Coalescent_analysis/${ortho_method}/01-Gene_trees"
    # Step 2: Recombining gene trees
    stage_info_main_blue "Step 2: Combining gene trees ..."
    combine_gene_trees "${ortho_method}" "${output_dir}/08-Coalescent_analysis/${ortho_method}/01-Gene_trees" "${output_dir}/08-Coalescent_analysis/${ortho_method}/02-Combined_gene_trees"
    # Step 3: Collapsing gene trees
    stage_info_main_blue "Step 3: Collapsing gene trees ..."
    collapse_gene_trees "${output_dir}/08-Coalescent_analysis/${ortho_method}/02-Combined_gene_trees/Combined_gene_trees.tre"
    # Step 4: Species tree inference
    stage_info_main_blue "Step 4: Species tree inference ..."
    if [ "${run_astral4}" = "TRUE" ]; then
      run_astral4 "${ortho_method}" "${output_dir}/08-Coalescent_analysis/${ortho_method}/02-Combined_gene_trees/Combined_gene_trees.tre" "${output_dir}/08-Coalescent_analysis/${ortho_method}/03-Species_tree/ASTRAL-IV"
    fi
    if [ "${run_wastral}" = "TRUE" ]; then
      run_wastral "${ortho_method}" "${output_dir}/08-Coalescent_analysis/${ortho_method}/02-Combined_gene_trees/Combined_gene_trees.tre" "${output_dir}/08-Coalescent_analysis/${ortho_method}/03-Species_tree/wASTRAL" "${paralogs_dir}/${ortho_method}"
    fi
    # Step 4: Run PhyPartsPieCharts and modified_phypartspiecharts.py
    stage_info_main_blue "Step 5 (optional): Gene-species tree concordance analysis ..."
    if [ "${run_astral4}" = "TRUE" ]; then
      stage_info_main_light_purple "====>> Gene-species tree concordance analysis on ASTRAL-IV results <<===="
      run_phyparts_piecharts_astral4 "${ortho_method}"
    fi
    if [ "${run_wastral}" = "TRUE" ]; then
      stage_info_main_light_purple "====>> Gene-species tree concordance analysis on wASTRAL results <<===="
      run_phyparts_piecharts_wastral "${ortho_method}"
    fi
  fi
}

################===========================================================================
# Function reroot_gene_trees()
################===========================================================================
reroot_gene_trees() {
  local input_gene_trees="$1"
  local output="$2"

  rm -rf "${output}"
  mkdir -p "${output}"
  cd "${input_gene_trees}"
  temp_file="treefile_list.txt"
  find . -maxdepth 1 -type f -name "*.tre" -exec basename {} \; > "$temp_file"
  total_sps=$(wc -l "$temp_file" | awk '{print $1}')
  # Initialize parallel environment
  init_parallel_env "$work_dir" "$total_sps" "$process" "${temp_file}" || exit 1
  stage_info_main "====>> Rerooting ${total_sps} single-gene trees via Reroot_genetrees.R (${process} in parallel) ====>>"
  if [ "${found_outgroup}" = "1" ]; then
    outgroup_name=$(cat "${output_dir}"/hybsuite_checklists/Outgroup.txt|fmt)
    outgroup_name2="\"$outgroup_name\""
    while IFS= read -r line || [ -n "$line" ]; do
      if [ "${process}" != "all" ]; then
        read -u1000
      fi
      {
      Genename=$(basename "$line" .tre)
      update_start_count "$Genename" "$stage_logfile"
      # Dynamically build the parameters of the nw reroot command
      cmd="Rscript ${script_dir}/Reroot_genetree.R ${Genename} ${input_gene_trees} ${output} ${outgroup_name2}"
      stage_cmd "${log_mode}" "${cmd}"
      eval "${cmd}" > /dev/null 2>&1
      if [ ! -s "${output}/${Genename}.rr.tre" ]; then
        record_failed_sample "$Genename"
      else
        update_finish_count "$Genename" "$stage_logfile"
      fi
      if [ "${process}" != "all" ]; then
          echo >&1000
      fi
      } &
      if [ "${log_mode}" = "cmd" ] || [ "${log_mode}" = "full" ]; then
          display_only_failed_log "$stage_logfile" "Failed to reroot single gene trees:"
      fi
    done < "${temp_file}"
    wait
    echo
    if [ "${log_mode}" = "full" ]; then
      display_process_log "$stage_logfile" "Failed to reroot single-gene trees:"
    fi
  else
    stage_info_main "No outgroup found, skipping rerooting step"
  fi
}

###################################################################################################
#Running the main functions #######################################################################
###################################################################################################
if [ "${run_iqtree}" = "TRUE" ] || [ "${run_raxml}" = "TRUE" ] || [ "${run_raxml_ng}" = "TRUE" ]; then
  stage_info_main "Executing concatenated analysis ..."
  if [ "${HRS}" = "TRUE" ]; then
    concatenated_analysis "HRS"
  fi
  if [ "${RLWP}" = "TRUE" ]; then
    concatenated_analysis "RLWP"
  fi
  if [ "${LS}" = "TRUE" ]; then
    concatenated_analysis "LS"
  fi
  if [ "${MO}" = "TRUE" ]; then
    concatenated_analysis "MO"
  fi
  if [ "${MI}" = "TRUE" ]; then
    concatenated_analysis "MI"
  fi
  if [ "${RT}" = "TRUE" ]; then
    concatenated_analysis "RT"
  fi
  if [ "${one_to_one}" = "TRUE" ]; then
    concatenated_analysis "1to1"
  fi
fi
if [ "${run_astral4}" = "TRUE" ] || [ "${run_wastral}" = "TRUE" ]; then
  stage_info_main "Executing coalescent analysis ..."
  if [ "${HRS}" = "TRUE" ]; then
    coalescent_analysis "HRS"
  fi
  if [ "${RLWP}" = "TRUE" ]; then
    coalescent_analysis "RLWP"
  fi
  if [ "${LS}" = "TRUE" ]; then
    coalescent_analysis "LS"
  fi
  if [ "${MO}" = "TRUE" ]; then
    coalescent_analysis "MO"
  fi
  if [ "${MI}" = "TRUE" ]; then
    coalescent_analysis "MI"
  fi
  if [ "${RT}" = "TRUE" ]; then
    coalescent_analysis "RT"
  fi
  if [ "${one_to_one}" = "TRUE" ]; then
    coalescent_analysis "1to1"
  fi
fi

if [ "${run_astral_pro}" = "TRUE" ]; then
  stage_info_main_light_purple "====>> Paralogs inclusion coalescent analysis (ASTRAL-Pro) <<===="
  if find "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input" -type f -name '*.tre' -size +0c -quit 2>/dev/null; then
    #################===========================================================================
    # Step 1: Preparing fasta files and single gene trees for ASTRAL-Pro
    stage_info_main_blue "Step 1: Preparing single gene trees for ASTRAL-Pro"
    #################===========================================================================
    stage_info_main "Skipped preparing single gene trees for ASTRAL-Pro, since the paralogs gene trees habe been generated in stage 3."
    rm -rf "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/"
    mkdir -p "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/"
    cp "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input"/*.tre "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/"
    sed -i -E 's/\|[^:]*:/:/g; s/\|//g' "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/"*.tre

    #################===========================================================================
    stage_info_main_blue "Step 2: Combining gene trees for ASTRAL-Pro"
    #################===========================================================================
    rm -rf "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/02-Combined_gene_trees/"
    mkdir -p "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/02-Combined_gene_trees/"
    awk '1' "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/"*.tre > "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/02-Combined_gene_trees/Combined_gene_trees.tre"
    if [ ! -s "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/02-Combined_gene_trees/Combined_gene_trees.tre" ]; then
      stage_error "Failed to combine gene trees for ASTRAL-Pro."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    else
      stage_info_main_success "Finished."
    fi
    #################===========================================================================
    stage_info_main_blue "Step 3: Collapsing gene trees for ASTRAL-Pro"
    #################===========================================================================
    collapse_gene_trees "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/02-Combined_gene_trees/Combined_gene_trees.tre"
    #################===========================================================================
    stage_info_main_blue "Step 4: Running ASTRAL-Pro"
    #################===========================================================================
    run_astral_pro "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/02-Combined_gene_trees/Combined_gene_trees.tre" "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/03-Species_tree"
    #################===========================================================================
    # Step 5: Running PhyPartsPieCharts and modified_phypartspiecharts.py
    #################===========================================================================
    stage_info_main_blue "Step 5: Running PhyPartsPieCharts and modified_phypartspiecharts.py"
    run_phyparts_piecharts_astral_pro
  else
    #################===========================================================================
    # Step 1: Preparing fasta files and single gene trees for ASTRAL-Pro
    stage_info_main_blue "Step 1: Preparing single gene trees for ASTRAL-Pro"
    #################===========================================================================
    # 01-MSA and trimming
    cd "${paralogs_dir}"
    define_threads "mafft"
    define_threads "trimal"
    rm -rf "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/"
    mkdir -p "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/"
    temp_file="fasta_file_list.txt"
    find . -maxdepth 1 -type f -name "*.fasta" -exec basename {} \; > "$temp_file"
    total_sps=$(find . -maxdepth 1 -type f -name "*.fasta" | wc -l)
    # Initialize parallel environment
    init_parallel_env "$work_dir" "$total_sps" "$process" "${temp_file}" || exit 1
    if [ "${gene_tree}" = "1" ]; then
      gene_tree_tool="IQ-TREE"
      define_threads "iqtree"
    elif [ "${gene_tree}" = "2" ]; then
      gene_tree_tool="FastTree"
      define_threads "fasttree"
      export OMP_NUM_THREADS=${nt_fasttree}
    fi
    if [ "${trim_tool}" = "1" ]; then
      trim_tool_tool="trimAl"
      define_threads "trimal"
    elif [ "${trim_tool}" = "2" ]; then
      trim_tool_tool="HMMCleaner"
    fi
    
    stage_info_main "====>> Running MAFFT, ${trim_tool_tool} and ${gene_tree_tool} for ${total_sps} putative paralog files (${process} in parallel) ====>>"
    while IFS= read -r file || [ -n "$file" ]; do
      filename=${file%.fasta}
      genename=${file%_paralogs_all.fasta}
      if [ "${process}" != "all" ]; then
        read -u1000
      fi
      {
        # Update start count
        update_start_count "$genename" "$stage_logfile"
        sed -i "s/ single_hit/|single_hit/g;s/ multi/|multi/g;s/ NODE_/|NODE_/g;s/\.[0-9]\+|NODE_/|NODE_/g;s/\.main|NODE_/|NODE_/g" "${file}"
        # Run MAFFT  
        run_mafft "${file}" "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln.fasta" "${nt_mafft}"
        remove_n "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln.fasta"
        if [ "${replace_n}" = "TRUE" ]; then
          replace_n "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln.fasta"
        fi
        if [ "${trim_tool}" = "1" ]; then
          run_trimal "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln.fasta" "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln.trimmed.fasta" "${trimal_mode}" \
          "${trimal_gapthreshold}" "${trimal_simthreshold}" "${trimal_cons}" "${trimal_block}" "${trimal_resoverlap}" "${trimal_seqoverlap}" \
          "${trimal_w}" "${trimal_gw}" "${trimal_sw}"
        fi
        if [ "${trim_tool}" = "2" ]; then
          run_hmmcleaner "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln.fasta" "${hmmcleaner_cost}"
          if [ -s "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln_hmm.fasta" ]; then
            update_finish_count "$genename" "$stage_logfile"
            mv "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln_hmm.fasta" "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln.trimmed.fasta"
            rm -f "${output_dir}/03-Paralogs_handling/PhyloPyPruner/Input/${filename}.aln_hmm"*
          else
            record_failed_sample "$genename"
          fi
        fi
          
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
        { print $0 }' "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln.trimmed.fasta" > "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln.trimmed.temp" && \
        mv "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln.trimmed.temp" "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln.trimmed.fasta"
        if [ ! -s "./${filename}.aln.trimmed.fasta" ]; then
          record_failed_sample "$genename"
        fi
        if [ "${gene_tree}" = "1" ]; then
          stage_cmd "${log_mode}" "iqtree -s ${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln.trimmed.fasta -m MFP -nt ${nt_iqtree} -bb ${gene_tree_bb} -pre ${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln.trimmed.fasta"
          iqtree -s "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln.trimmed.fasta" -m MFP -nt ${nt_iqtree} -bb "${gene_tree_bb}" -pre "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln.trimmed.fasta" > /dev/null 2>&1
          if [ -s "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln.trimmed.fasta.treefile" ]; then
            mv "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln.trimmed.fasta.treefile" "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln.trimmed.fasta.tre"
            find . -maxdepth 1 -name "${filename}.aln.trimmed.fasta*" ! -name "*.tre" ! -name "*.fasta" -delete
          else
            record_failed_sample "$genename"
          fi
        elif [ "${gene_tree}" = "2" ]; then
          stage_cmd "${log_mode}" "FastTreeMP -nt -gtr -gamma -boot ${gene_tree_bb} ${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln.trimmed.fasta > ./${filename}.aln.trimmed.fasta.tre"
          FastTreeMP -nt -gtr -gamma -boot "${gene_tree_bb}" "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln.trimmed.fasta" > "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln.trimmed.fasta.tre" 2>/dev/null
          if [ ! -s "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/${filename}.aln.trimmed.fasta.tre" ]; then
            record_failed_sample "$genename"
          fi
        fi
        rm "${file}" "${filename}.aln.fasta" 2>/dev/null
        # Update failed count
        update_finish_count "$genename" "$stage_logfile"
        if [ "${process}" != "all" ]; then
          echo >&1000
        fi
      } &
      if [ "${log_mode}" = "cmd" ] || [ "${log_mode}" = "full" ]; then
        display_only_failed_log "$stage_logfile" "Failed to prepare single gene trees for ASTRAL-Pro:"
      fi
    done < "$temp_file"
    rm "$temp_file"
    wait
    echo
    # Display processing log
    if [ "${log_mode}" = "full" ]; then
      display_process_log "$stage_logfile" "Failed to prepare single gene trees for ASTRAL-Pro:"
    fi
    rm -f "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/"*.fasta
    if ! find "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/" -type f -name '*.aln.trimmed.fasta.tre' -size +0c -quit 2>/dev/null; then
      stage_error "Failed to run FastTree or IQ-TREE."
      stage_error "HybSuite exits."
      stage_blank_main ""
      exit 1
    fi
    stage_success "Finished."
    stage_blank_main ""
    #################===========================================================================
    # Step 2: Combining gene trees for ASTRAL-Pro
    stage_info_main_blue "Step 2: Combining gene trees for ASTRAL-Pro"
    #################===========================================================================
    cd "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/"
    rm -rf "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/02-Combined_gene_trees/"
    mkdir -p "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/02-Combined_gene_trees/"
    sed -i -E 's/\|[^:]*:/:/g; s/\|//g' "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/"*.tre
    awk '1' "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/01-Gene_trees/"*.tre > "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/02-Combined_gene_trees/Combined_gene_trees.tre"
    if [ ! -s "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/02-Combined_gene_trees/Combined_gene_trees.tre" ]; then
      stage_info_main "The combined gene trees for ASTRAL-Pro have been written to:"
      stage_info_main "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/02-Combined_gene_trees/Combined_gene_trees.tre"
      stage_success "Finished."
      stage_blank_main ""
    else
      stage_error "Failed to combine gene trees."
      stage_error "HybSuite exits."
      stage_error "Please check your alignments and trees produced by FastTree or IQ-TREE."
      stage_blank_main ""
      exit 1
    fi
    #################===========================================================================
    # Step 3: Collapsing gene trees
    stage_info_main_blue "Step 3: Collapsing gene trees"
    #################===========================================================================
    collapse_gene_trees "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/02-Combined_gene_trees/Combined_gene_trees.tre"
    #################===========================================================================
    # Step 4: Running ASTRAL-Pro
    stage_info_main_blue "Step 4: Running ASTRAL-Pro"
    #################===========================================================================
    run_astral_pro "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/02-Combined_gene_trees/Combined_gene_trees.tre" "${output_dir}/08-Coalescent_analysis/ASTRAL-Pro/03-Species_tree"
  fi
fi

############################################################################################
# End of Stage 5
stage_success "Successfully finishing the Stage 5: Species tree inference."
stage_info_main_success "The resulting files have been saved in:"
if { [ "${run_iqtree}" = "TRUE" ] || [ "${run_raxml}" = "TRUE" ] || [ "${run_raxml_ng}" = "TRUE" ]; } && \
   { [ "${run_astral4}" = "TRUE" ] || [ "${run_wastral}" = "TRUE" ] || [ "${run_astral_pro}" = "TRUE" ]; }; then
  stage_info_main_success "(1) ${output_dir}/07-Concatenated_analysis/"
  stage_info_main_success "(2) ${output_dir}/08-Coalescent_analysis/"
elif [ "${run_iqtree}" = "FALSE" ] && [ "${run_raxml}" = "FALSE" ] && [ "${run_raxml_ng}" = "FALSE" ] && \
     { [ "${run_astral4}" = "TRUE" ] || [ "${run_wastral}" = "TRUE" ] || [ "${run_astral_pro}" = "TRUE" ]; }; then
  stage_info_main_success "${output_dir}/08-Coalescent_analysis/"
elif { [ "${run_iqtree}" = "TRUE" ] || [ "${run_raxml}" = "TRUE" ] || [ "${run_raxml_ng}" = "TRUE" ]; } && \
     [ "${run_astral4}" = "FALSE" ] && [ "${run_wastral}" = "FALSE" ] && [ "${run_astral_pro}" = "FALSE" ]; then
  stage_info_main_success "${output_dir}/07-Concatenated_analysis/"
fi

stage_info_main_success "Reports have been saved in:"
stage_info_main_success "${output_dir}/hybsuite_reports/"
stage_info_main_success "The logfile has been saved in:"
stage_info_main_success "${output_dir}/hybsuite_logs/hybsuite_${current_time}.log"
# Clean up environment
cleanup_parallel_env "$work_dir"
stage_info_main_success "Thank you for using HybSuite! Enjoy your research!"
stage_blank_main ""
exit 0
fi
############################################################################################
