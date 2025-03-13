#!/bin/bash
# Script Name: HybSuite.sh
# Author: Yuxuan Liu
#===> Preparation and HybSuite Checking <===#
#Options setting
###set the run name:
current_time=$(date +"%Y-%m-%d_%H:%M:%S")
function display_help {
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
  sed -n '1,$p' $script_dir/../config/HybSuite_help.txt
}

# Function to display the version number
function display_version {
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

# Read the variable list file and set the default values
# Obtain the script path
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Switch to the script path
while IFS= read -r line || [ -n "$line" ]; do
  var=$(echo "${line}" | awk '{print $1}')
  default=$(echo "${line}" | awk '{print $2}')
  eval "${var}=''"
  eval "Default_${var}='${default}'"
  eval "found_${var}=false"
done < "${script_dir}/../config/HybSuite_options_list.txt"

# Parse command line arguments and set variables
# Set conditional statements so that options "-h" and "-v" are in play
if [[ "$1" = "-h" || "$1" = "--help" ]]; then
    display_help
    exit 1
fi
if [[ "$1" = "-v" || "$1" = "--version" ]]; then
    display_version
    exit 1
fi

#Print welcome phrases
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
  echo "================================================================================="
  echo "HybSuite User input command:"
  echo "$0 $@"
  echo "================================================================================="
  echo ""
if [[ $# -eq 0 ]]; then
  echo ""
  echo "[HybSuite-WARNING]: You didn't set any options ."
  echo "                    Please set necessary options to run HybSuite. (use -h to check options)"
  echo "                    HybSuite exits."
  echo ""
  exit 1
fi
full_pipeline=false
run_to_stage1=false
run_to_stage2=false
run_to_stage3=false
run_to_stage4=false

if [ "$1" != "--run_to_stage1" ] && [ "$1" != "--run_to_stage2" ] && [ "$1" != "--run_to_stage3" ] && [ "$1" != "--run_to_stage4" ] && [ "$1" != "--full_pipeline" ]; then
    echo "[HybSuite-ERROR]:   Invalid first option '$1'."
    echo "                    To specify which stage the script runs to, "
    echo "                    the first option must be one of '--full_pipeline', '--run_to_stage1', '--run_to_stage2', '--run_to_stage3', '--run_to_stage4', or '--full_pipeline'."
    echo "                    HybSuite exits."
    echo ""
    exit 1
else
    if [[ "$1" == "--full_pipeline" ]]; then
      full_pipeline=true
    elif [[ "$1" == "--run_to_stage1" ]]; then
      run_to_stage1=true
    elif [[ "$1" == "--run_to_stage2" ]]; then
      run_to_stage2=true
    elif [[ "$1" == "--run_to_stage3" ]]; then
      run_to_stage3=true
    elif [[ "$1" == "--run_to_stage4" ]]; then
      run_to_stage4=true
    fi
fi
if [[ $# -eq 1 ]]; then
  echo "[HybSuite-WARNING]: Except the first option, you didn't set any other required options."
  echo "                    Please set required options to run HybSuite. (use -h to check options)"
  echo "                    HybSuite exits."
  echo ""
  exit 1
fi
if [[ "$2" = "--full_pipeline" || "$2" = "--run_to_stage1" || "$2" = "--run_to_stage2" || "$2" = "--run_to_stage3" || "$2" = "--run_to_stage4" ]]; then
    echo "[HybSuite-ERROR]:   Sorry, you can't specify the stage to run to more than once!"
    echo "                    Please specify one of '--full_pipeline', '--run_to_stage1', '--run_to_stage2', '--run_to_stage3', or '--run_to_stage4' only once!"
    echo "                    HybSuite exits."
    echo ""
    exit 1
fi

while [[ $# -gt 1 ]]; do
    if [[ "$2" != -* ]]; then
        echo "[HybSuite-ERROR]:   Invalid option '$2'. Options should start with '-'."
        echo "                    HybSuite exits."
        echo ""
        exit 1 
    fi
    case "$2" in
        -*)
            option="${2/-/}"
            vars=($(awk '{print $1}' ${script_dir}/../config/HybSuite_options_list.txt))
            #echo "                    -$option: $3"
            if [[ "$3" = -* ]]; then
              option3="${3/-/}"
              if [[ " ${vars[*]} " == *" $option3 "* ]]; then
                echo ""
                echo "[HybSuite-WARNING]: The argument for option $2 is not permitted to start with '-'"
                echo "                    Please change your argument for the option $2."
                echo "[HybSuite-WARNING]: Or you didn't specify any argument for the option $2."
                echo "                    Please specify an argument for the option $2."
                echo "                    HybSuite exits."
                echo ""
                exit 1
              fi
            fi  
            if [[ -z "$3" ]]; then
              echo ""
              echo "[HybSuite-ERROR]:   You didn't specify any argument for the option $2 "
              echo "                    Please specify an argument for the option $2."
              echo "                    HybSuite exits."
              echo ""
              exit 1
            fi
            if [[ " ${vars[*]} " == *" $option "* ]]; then
              if [ "${3: -1}" = "/" ]; then
                eval "${option}=\"${3%/}\""
              else
                eval "${option}=\"$3\""
              fi
              eval "found_${option}=true"
              echo "$option" >> $script_dir/../config/Option-list.txt
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
            shift
            ;;
    esac
done
cut -f 1 $script_dir/../config/HybSuite_options_list.txt > $script_dir/../config/Option-all-list.txt
sort $script_dir/../config/Option-all-list.txt $script_dir/../config/Option-list.txt|uniq -u > $script_dir/../config/Option-default-list.txt

while read -r line; do
    default_var="Default_${line}"
    default_value="${!default_var}"
    eval "default_value=${default_value}"
    eval "${line}=\"${default_value}\""
    #echo "                    Default argument for -${line}: ${default_value}"
done < "$script_dir/../config/Option-default-list.txt"
rm "$script_dir"/../config/Option*

for var in i o d eas_dir t other_seqs my_raw_data iqtree_constraint_tree raxml_constraint_tree rng_constraint_tree; do
  if [ ! -z "${!var}" ] && [ "${!var}" != "_____" ]; then
    if [[ ! "${!var}" =~ ^/ ]]; then
      abs_path=$(readlink -f "${!var}")
      eval "${var}=${abs_path}"
    fi
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
fi
if echo "${OI}" | grep -q "b"; then
  run_paragone="TRUE"
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
  local stage_log_file="$2"
    
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

#################===========================================================================
conda_activate_0() {
    local conda="$1"

    # Check whether conda is available
    if ! command -v conda &>/dev/null; then
        stage0_error "Conda command not found. Please install Conda or ensure it's in your PATH."
        exit 1
    fi

    # Secure access to the current conda environment (compatible with set-u)
    local current_env="${CONDA_DEFAULT_ENV:-}"

    # Defines the function to load the conda hook
    load_conda_hook() {
        local current_shell=$(basename "$SHELL")
        case "$current_shell" in
            bash)
                eval "$(conda shell.bash hook)"
                stage0_info "Bash shell detected. Conda hook loaded."
                ;;
            zsh)
                eval "$(conda shell.zsh hook)"
                stage0_info "Zsh shell detected. Conda hook loaded."
                ;;
            sh)
                eval "$(conda shell.sh hook)"
                stage0_info "Sh shell detected. Conda hook loaded."
                ;;
            fish)
                eval "(conda shell.fish hook)"
                stage0_info "Fish shell detected. Conda hook loaded."
                ;;
            *)
                stage0_error "Unsupported shell: $current_shell"
                exit 1
                ;;
        esac
    }
	# main logic
    if [ "$current_env" = "$conda" ]; then
        stage0_info "Already in conda environment ${conda}. Skipping activation."
        stage0_blank ""
        return 0
    fi

    # Situations where an environment needs to be activated
    stage0_info "Activating conda environment: ${conda}"

    # Turn off Strict mode temporarily
    set +u
    load_conda_hook

    # Execute activation command
    conda activate "${conda}"
    stage0_info "conda activate ${conda}"

    # Verify activation result
    current_env="${CONDA_DEFAULT_ENV:-}"
    if [ "$current_env" = "$conda" ]; then
        stage0_info "Successfully activated ${conda} environment"
        stage0_blank ""
    else
        stage0_error "Failed to activate ${conda} environment"
        stage0_info ""
        exit 1
    fi
}
#################===========================================================================

############################################################################################
# Preparation
############################################################################################

mkdir -p "${o}/00-logs_and_reports/logs"
#################===========================================================================
# Function: Output information to log file
stage0_info() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "${o}/00-logs_and_reports/logs/HybSuite_Checking_${current_time}.log"
}
stage0_error() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "${o}/00-logs_and_reports/logs/HybSuite_Checking_${current_time}.log"
}
stage0_warning() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WARNING] $1" | tee -a "${o}/00-logs_and_reports/logs/HybSuite_Checking_${current_time}.log"
}
stage0_attention() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ATTENTION] $1" | tee -a "${o}/00-logs_and_reports/logs/HybSuite_Checking_${current_time}.log"
}
stage0_cmd() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [CMD] $1" | tee -a "${o}/00-logs_and_reports/logs/HybSuite_Checking_${current_time}.log"
}
stage0_blank() {
  echo "$1" | tee -a "${o}/00-logs_and_reports/logs/HybSuite_Checking_${current_time}.log"
}
#################===========================================================================

#HybSuite CHECKING
#Step 1: Check necessary options
if [ "${skip_checking}" != "TRUE" ]; then
  stage0_blank ""
  stage0_info "<<<======= HybSuite CHECKING =======>>>"
  stage0_info "HybSuite will provide tips with [ATTENTION]."
  stage0_info "HybSuite will alert you to incorrect arguments with [WARNING]."
  stage0_info "HybSuite will notify you of missing software with [ERROR], and then exit."
  stage0_blank ""
  stage0_info "=> Step 1: Check necessary options" 
  stage0_info "Check if you have entered all necessary options... "
  ###Verify if the user has entered the necessary parameters
  if [ "${run_to_stage1}" = "true" ]; then
    if [ "${i}" = "_____" ] || [ "${conda1}" = "_____" ]; then
      stage0_info "After checking:"
      stage0_error "You haven't set all the necessary options."
      stage0_error "All necessary options must be set."
      stage0_error "Including: "
      stage0_error "-i"
      stage0_error "-conda1"
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    fi
  else
    if [ "${i}" = "_____" ] || [ "${conda1}" = "_____" ] || [ "${conda2}" = "_____" ] || [ "${t}" = "_____" ]; then
      stage0_info "After checking:"
      stage0_error "You haven't set all the necessary options."
      stage0_error "All necessary options must be set."
      stage0_error "Including: "
      stage0_error "-i"
      stage0_error "-conda1"
      stage0_error "-conda2"
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
  
  if [ -s "${i}/SRR_Spname.txt" ]; then
    sed -i '/^$/d' "${i}/SRR_Spname.txt"
  fi
  if [ -s "${i}/My_Spname.txt" ]; then
    sed -i '/^$/d' "${i}/My_Spname.txt"
  fi

  ######################################################
  ### Step 2: Check the <input directory> and files ####
  ######################################################
  stage0_info "=> Step 2: Check the <input directory> and files" 
  stage0_info "Checking if the input directory and files are prepared correctly..."
  if [ ! -s "${t}" ] && [ "${run_to_stage1}" != "true" ]; then
    stage0_info "Check result:"
    stage0_error "The target file (reference for HybPiper) you specified does not exist."
    stage0_error "HybSuite exits."
    stage0_blank ""
    exit 1
  fi

  if [ ! -s "${i}/SRR_Spname.txt" ] && [ ! -s "${i}/My_Spname.txt" ]; then
    stage0_info "Check result:"
    stage0_error "At least one type of data (public/your own) must be provided in ${i}."
    stage0_error "HybSuite exits."
    stage0_blank ""
    exit 1
  fi

  if [ -s "${i}/My_Spname.txt" ] && [ ! -e "${my_raw_data}" ]; then
    stage0_info "Check result:"
    stage0_error "You need to specify the correct path to your raw data using '-my_raw_data'."
    stage0_error "HybSuite exits."
    stage0_blank ""
    exit 1
  fi

  if [ ! -s "${i}/My_Spname.txt" ] && [ -e "${my_raw_data}" ]; then
    stage0_info "Check result:"
    stage0_error "You need to provide the species list of your raw data in ${i}/My_Spname.txt."
    stage0_error "HybSuite exits."
    stage0_blank ""
    exit 1
  fi

  cd "${i}"
  if [ -s "./My_Spname.txt" ] && [ "$my_raw_data" != "_____" ]; then
    first_iteration=true
  	while IFS= read -r add_sp_names || [[ -n $add_sp_names ]]; do
  		if ([ ! -s "${my_raw_data}/${add_sp_names}_1.fq" ] || [ ! -s "${my_raw_data}/${add_sp_names}_2.fq" ]) && ([ ! -s "${my_raw_data}/${add_sp_names}_1.fastq" ] || [ ! -s "${my_raw_data}/${add_sp_names}_2.fastq" ]) \
      && ([ ! -s "${my_raw_data}/${add_sp_names}.fq" ] && [ ! -s "${my_raw_data}/${add_sp_names}.fastq" ]) && ([ ! -s "${my_raw_data}/${add_sp_names}_1.fq.gz" ] || [ ! -s "${my_raw_data}/${add_sp_names}_2.fq.gz" ]) && ([ ! -s "${my_raw_data}/${add_sp_names}_1.fastq.gz" ] || [ ! -s "${my_raw_data}/${add_sp_names}_2.fastq.gz" ]) \
      && ([ ! -s "${my_raw_data}/${add_sp_names}.fq.gz" ] && [ ! -s "${my_raw_data}/${add_sp_names}.fastq.gz" ]); then
  			if [ "$first_iteration" = true ]; then
  				stage0_error "Option: -my_raw_data: The path or format of your raw data (format: fastq) for species ${add_sp_names} is incorrect."
  				stage0_error "Please use -h to check the required format."
          stage0_error "HybSuite exits."
          stage0_blank ""
  				first_iteration=false
  				exit 1
  			fi
  		fi
  	done < ./My_Spname.txt
  fi

  # Checking Outgroup.txt and outgroups
  if [ ! -s "${i}/Outgroup.txt" ]; then
    stage0_info "Check result:"
    stage0_error "You must provide at least one outgroup species name in ${i}/Outgroup.txt."
    stage0_error "HybSuite exits."
    stage0_blank ""
    exit 1
  fi
  if [ "${other_seqs}" != "_____" ]; then
    > "${i}"/Other_seqs_Spname.txt
    for file in "${other_seqs}"/*.fasta; do
      add_sp=$(basename "${file}" .fasta)
      echo "${add_sp}" >> "${i}"/Other_seqs_Spname.txt
    done
  fi
  if [ -s "./SRR_Spname.txt" ]; then
    cut -f 2 ./SRR_Spname.txt > ./NCBI_Spname_list.txt
  fi
  while IFS= read -r line || [ -n "$line" ]; do
    if [ -s "./My_Spname.txt" ]; then
      if grep -qF "$line" "./My_Spname.txt"; then
        break
      fi
    elif [ -s "./SRR_Spname.txt" ]; then
      if grep -qF "$line" "./NCBI_Spname_list.txt"; then
        break
      fi
    elif [ "${other_seqs}" != "_____" ] && grep -qF "^$line$" "${i}"/Other_seqs_Spname.txt; then
      break
    else
      stage0_error "Your My_Spname.txt and SRR_Spname.txt do not contain any outgroup species."
      stage0_error "Please add your outgroup species names from ${i}/Outgroup.txt to either ${i}/SRR_Spname.txt or ${i}/My_Spname.txt."
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    fi
  done < "./Outgroup.txt"
  if [ -s "./Other_seqs_Spname.txt" ]; then
    rm ./Other_seqs_Spname.txt
  fi
  # Deliver congratulations messages
  stage0_info "Well done!"
  stage0_info "All necessary folders and files are prepared."
  stage0_info "Proceeding to the next step ..."
  stage0_blank ""
  
  ###################################
  ### Step 3: Check dependencies ####
  ###################################
  stage0_info "=> Step 3: Check dependencies" 
  stage0_info "Verifying required software in all conda environments..."
  conda_activate_0 "${conda1}"
  # sra-tools
  check_sra() {
    stage0_info "To download NGS raw data, 'sra-tools' must be installed in your conda environment ${conda1}."
    stage0_info "Alternatively, ensure that both fasterq-dump and prefetch are configured in your system's environment variables."
    stage0_info "Checking configuration of fasterq-dump and prefetch or installation of sra-tools in ${conda1} environment..."
    if ! conda list -n "${conda1}" 2>/dev/null | grep -q "^sra-tools\b" && ! command -v prefetch >/dev/null 2>&1 && ! command -v fasterq-dump >/dev/null 2>&1; then
      stage0_error "'sra-tools' is not found in the ${conda1} conda environment."
      stage0_error "Additionally, fasterq-dump and prefetch are not configured in the system's environment variables."
      stage0_error "Please install 'sra-tools' in the ${conda1} conda environment."
      stage0_error "For more information, visit https://github.com/glarue/fasterq_dump."
      stage0_error "Recommended Command:"
      stage0_error "mamba install bioconda::sra-tools -y"
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    elif ! conda list -n "${conda1}" 2>/dev/null | grep -q "^sra-tools\b" && command -v prefetch >/dev/null 2>&1 && ! command -v fasterq-dump >/dev/null 2>&1; then
      stage0_error "'sra-tools' is missing in the '${conda1}' conda environment, but SraToolKit is installed on your system."
      stage0_error "However, fasterq-dump is not configured."
      stage0_error "Please configure fasterq-dump."
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    elif ! conda list -n "${conda1}" 2>/dev/null | grep -q "^sra-tools\b" && ! command -v prefetch >/dev/null 2>&1 && command -v fasterq-dump >/dev/null 2>&1; then
      stage0_error "'sra-tools' is missing in the '${conda1}' conda environment, but SraToolKit is installed on your system."
      stage0_error "However, prefetch is not configured."
      stage0_error "Please configure prefetch."
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    else
      stage0_info "Both 'prefetch' and 'fasterq-dump' are ready."
      stage0_info "PASS"
      stage0_blank ""
    fi
  }

  check_sra_tools() {
  if [ -s "${i}/SRR_Spname.txt" ]; then
    if [ -e "${d}/02-Downloaded_clean_data/" ]; then
      cd ${d}/02-Downloaded_clean_data/
      > ./Dd_list.txt
      for file in *; do
        if [ -n "$file" ]; then
          if echo "$file" | grep -q "_1_"; then
            echo "${file%%_1_*}" >> ./Dd_list.txt
          elif echo "$file" | grep -q "_2_"; then
            echo "${file%%_2_*}" >> ./Dd_list.txt
          else
            echo "${file%%_clean*}" >> ./Dd_list.txt
          fi
        fi
      done
      sort ./Dd_list.txt | uniq > ./Dd_list_final.txt
      cut -f 2 "${i}/SRR_Spname.txt" | sort > ./Existed_dd_list.txt
      new_dd=$(comm -13 ./Existed_dd_list.txt ./Dd_list_final.txt)
      if [ -n "$new_dd" ]; then
        check_sra
      else
        stage0_info "All species listed in ${i}/SRR_Spname.txt have already been downloaded."
        stage0_info "Skipping checks for 'prefetch' and 'fasterq-dump'."
        stage0_info "PASS"
        stage0_blank ""
      fi
      rm ./Existed_dd_list.txt
      rm ./Dd_list_final.txt
    else
      check_sra
    fi
  fi
  }

  check_pigz() {
    if [ "$download_format" = "fastq_gz" ] && [ -s "${i}/SRR_Spname.txt" ]; then
      stage0_info "To download NGS data in fq.gz format, 'pigz' must be installed in conda environment ${conda1}."
      stage0_info "Checking pigz in conda environment ${conda1}..."
      if ! conda list -n "${conda1}" 2>/dev/null | grep -q "^pigz\b"; then
        stage0_error "'pigz' is not found in the conda environment ${conda1}."
        stage0_error "Please install 'pigz' in the conda environment ${conda1}."
        stage0_error "Recommended Command:"
        stage0_error "mamba install conda-forge::pigz -y"
        stage0_error "HybSuite exits."
        stage0_blank ""
        exit 1
      else
        stage0_info "PASS"
        stage0_blank ""
      fi
    fi
  }
  
  check_hybpiper() {
    stage0_blank ""
    stage0_info "To run the HybPiper pipeline, 'HybPiper' must be installed in your conda environment ${conda1}."
    stage0_info "Checking HybPiper in conda environment ${conda1}..."
    if ! conda list -n "${conda1}" 2>/dev/null | grep -q "^hybpiper\b"; then
      stage0_error "'HybPiper' is not found in the conda environment ${conda1}."
      stage0_error "Please install 'HybPiper' in the conda environment ${conda1}."
      stage0_error "Recommended Command:"
      stage0_error "mamba install bioconda::hybpiper -y"
      stage0_error "HybSuite exits."
      stage0_blank ""
      exit 1
    else
      stage0_info "PASS"
      stage0_blank ""
    fi
  }
  
  check_paragone() {
    if ([ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "$one_to_one" = "TRUE" ]) && [ "${run_paragone}" = "TRUE" ]; then
      stage0_blank ""
      conda_activate_0 "${conda2}"
      if [ "${run_paragone}" = "TRUE" ] && [ "${conda2}" = "_____" ]; then
        stage0_error "You didn't specify the conda environment for paragone via -conda2 option"
        stage0_error "HybSuite exits."
        stage0_blank ""
        exit 1
      fi
      stage0_info "To run MI/MO/RT/1to1 via ParaGone, 'paragone' must be installed in conda environment ${conda2}."
      stage0_info "Checking ParaGone in conda environment ${conda2}..."
      if ! conda list -n "${conda2}" 2>/dev/null | tee /dev/null | grep -q "^paragone\b"; then
        stage0_error "'ParaGone' is not found in the conda environment ${conda2}."
        stage0_error "Please install 'ParaGone' in the conda environment ${conda2}."
        stage0_error "Recommended Command:"
        stage0_error "mamba install bioconda::paragone -y"
        stage0_error "HybSuite exits."
        stage0_blank ""
        exit 1
      else
        stage0_info "PASS"
        stage0_blank ""
      fi
    fi
  }

  conda_activate_0 "${conda1}"
  check_modeltest_ng() {
    if [ "${run_modeltest_ng}" != "TRUE" ]; then
      stage0_blank ""
      stage0_info "To use Modeltest-NG for the best evolutionary model, 'modeltest-ng' must be installed in conda environment ${conda1}."
      stage0_info "Checking Modeltest-NG in conda environment ${conda1}..."
      if ! conda list -n "${conda1}" 2>/dev/null | grep -q "^modeltest-ng\b"; then
        stage0_error "'modeltest-ng' is not found in the conda environment ${conda1}."
        stage0_error "Please install 'modeltest-ng' in the conda environment ${conda1}."
        stage0_error "Recommended Command:"
        stage0_error "mamba install bioconda::modeltest-ng -y"
        stage0_error "HybSuite exits."
        stage0_blank ""
        exit 1
      else
        stage0_info "PASS"
        stage0_blank ""
      fi
    fi
  }

  check_iqtree() {
    if [ "${run_iqtree}" = "TRUE" ]; then
      stage0_blank ""
      stage0_info "To run iqtree, 'iqtree' must be installed in your conda environment ${conda1}."
      stage0_info "Checking IQ-TREE..."
      if ! conda list -n "${conda1}" 2>/dev/null | grep -q "^iqtree\b"; then
        stage0_error "'iqtree' is not found in the conda environment ${conda1}."
        stage0_error "Please install 'iqtree' in the conda environment ${conda1}."
        stage0_error "Recommended Command:"
        stage0_error "mamba install bioconda::iqtree -y"
        stage0_error "HybSuite exits."
        stage0_blank ""
        exit 1
      else
        stage0_info "PASS"
        stage0_blank ""
      fi
    fi
  }

  check_raxml() {
    if [ "${run_raxml}" = "TRUE" ]; then
      stage0_blank ""
      stage0_info "To run raxml, 'raxml' must be installed in your conda environment ${conda1}."
      stage0_info "Checking RAxML..."
      if ! conda list -n "${conda1}" 2>/dev/null | grep -q "^raxml\b"; then
        stage0_error "'raxml' is not found in the conda environment ${conda1}."
        stage0_error "Please install 'raxml' in the conda environment ${conda1}."
        stage0_error "Recommended Command:"
        stage0_error "mamba install bioconda::raxml -y"
        stage0_error "HybSuite exits."
        stage0_blank ""
        exit 1
      else
        stage0_info "PASS"
        stage0_blank ""
      fi
    fi
  }
  
  check_raxml_ng() {
    if [ "${run_raxml_ng}" = "TRUE" ]; then
      stage0_blank ""
      stage0_info "To run raxml-ng, 'raxml-ng' must be installed in your conda environment ${conda1}."
      stage0_info "Checking RAxML-NG..."
      if ! conda list -n "${conda1}" 2>/dev/null | grep -qE "\braxml-ng\b"; then
        stage0_error "'raxml-ng' is not found in the conda environment ${conda1}."
        stage0_error "Please install 'raxml-ng' in the conda environment ${conda1}."
        stage0_error "Recommended Command:"
        stage0_error "mamba install bioconda::raxml-ng -y"
        stage0_error "HybSuite exits."
        stage0_blank ""
        exit 1
      else
        stage0_info "PASS"
        stage0_blank ""
      fi
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
        stage0_info "PASS"
        stage0_blank ""
      fi
    fi
  }

  check_newick_utilis() {
    if [ "${run_astral}" = "TRUE" ] || [ "${run_wastral}" = "TRUE" ]; then
      stage0_blank ""
      stage0_info "To construct phylogenetic trees via coalescence-based methods, 'newick_utils' must be installed in ${conda1} environment."
      stage0_info "Checking 'newick_utils' in ${conda1} environment..."
      if ! grep -q "^newick_utils\b" <(conda list -n "${conda1}"); then
        stage0_error "To run wASTRAL/ASTRAL-III, 'newick_utils' must be installed in ${conda1} environment."
        stage0_error "'newick_utils' is not found in the conda environment ${conda1}."
        stage0_error "Please install 'newick_utils' in the ${conda1} environment."
        stage0_error "HybSuite exits."
        stage0_blank ""
        exit 1
      else
        stage0_info "PASS"
        stage0_blank ""
      fi
    fi
  }

  check_r_phytools() {
    if [ "${run_astral}" = "TRUE" ] || [ "${run_wastral}" = "TRUE" ]; then
      stage0_blank ""
      stage0_info "To construct phylogenetic trees via coalescence-based methods, 'phytools' must be installed in ${conda1} environment."
      stage0_info "Checking R package 'phytools' in ${conda1} environment..."
      if Rscript -e "if (!requireNamespace('phytools', quietly = TRUE)) { quit(status = 1) }"; then
        stage0_info "PASS"
        stage0_blank ""
      else
        stage0_error "To run wASTRAL/ASTRAL-III, 'phytools' must be installed in the ${conda1} environment."
        stage0_error "Please install 'phytools' using install.packages('phytools')."
        stage0_error "HybSuite exits."
        stage0_blank ""
        exit 1
      fi
    fi
  }
  
  check_r_ape() {
    if [ "${run_astral}" = "TRUE" ] || [ "${run_wastral}" = "TRUE" ]; then
      stage0_blank ""
      stage0_info "To construct phylogenetic trees via coalescence-based methods, 'ape' must be installed in ${conda1} environment."
      stage0_info "Checking R package 'ape' in ${conda1} environment..."
      if Rscript -e "if (!requireNamespace('ape', quietly = TRUE)) { quit(status = 1) }"; then
        stage0_info "PASS"
        stage0_blank ""
      else
        stage0_error "To run wASTRAL/ASTRAL-III, 'ape' must be installed in the ${conda1} environment."
        stage0_error "Please install 'ape' using install.packages('ape')."
        stage0_error "HybSuite exits."
        stage0_blank ""
        exit 1
      fi
    fi
  }

  check_py_install() {
  local pyinstall="$1"
  stage0_info "Checking Python package "${pyinstall}" in ${conda1} environment..."
  if pip show "${pyinstall}" >/dev/null 2>&1; then
    stage0_info "Python package "${pyinstall}" is installed."
    stage0_info "PASS"
    stage0_blank ""
  else
    stage0_error "Python package "${pyinstall}" is not installed."
    stage0_error "Recommended Command:"
    stage0_error "pip install pandas"
    stage0_error "HybSuite exits."
    stage0_blank ""
    exit 1
  fi
  }

  check_py_phylopypruner() {
    if ([ "$LS" = "TRUE" ] || [ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "$one_to_one" = "TRUE" ]) && [ "${run_phylopypruner}" = "TRUE" ]; then
      stage0_blank ""
      stage0_info "To run LS/MO/MI/RT/1to1 via PhyloPyPruner, 'phylopypruner' must be installed in ${conda1} environment."
      stage0_info "Checking Python package 'phylopypruner' in ${conda1} environment..."
      if pip show "phylopypruner" >/dev/null 2>&1; then
        stage0_info "PASS"
        stage0_blank ""
        stage0_info "To run PhyloPyPruner, 'fasttree' must be installed in your conda environment ${conda1}."
        stage0_info "Checking fasttree..."
        if ! conda list -n "${conda1}" 2>/dev/null | grep -q "^fasttree\b"; then
          stage0_error "'fasttree' is not found in the conda environment ${conda1}."
          stage0_error "Please install 'fasttree' in the conda environment ${conda1}."
          stage0_error "Recommended Command:"
          stage0_error "mamba install bioconda::fasttree -y"
          stage0_error "HybSuite exits."
          stage0_blank ""
          exit 1
        else
          stage0_info "PASS"
          stage0_blank ""
        fi
      else
        stage0_error "Python package 'phylopypruner' is not installed."
        stage0_error "Recommended Command:"
        stage0_error "pip install phylopypruner"
        stage0_error "HybSuite exits."
        stage0_blank ""
        exit 1
      fi
    fi
  }
    
  check_r() {
  if [ "${run_astral}" = "TRUE" ] || [ "${run_wastral}" = "TRUE" ]; then
    if ! grep -q "^r\b" <(conda list -n "${conda1}"); then
        stage0_error "'r' is not installed in the conda environment ${conda1}."
        stage0_error "Please install 'r' in the conda environment ${conda1}."
        stage0_error "Recommended Command:"
        stage0_error "mamba install r -y"
        stage0_error "HybSuite exits."
        stage0_blank ""
        exit 1
    else
        stage0_info "PASS"
        stage0_blank ""
    fi
  fi
  }

  #run to stage1
  if [ "${run_to_stage1}" = "true" ]; then
    # conda1
    stage0_info "Running stage 1, checking dependencies in ${conda1} environment..."
    # conda1: sra-tools
    check_sra_tools
    # conda1: pigz
    check_pigz
  fi
  
  #run to stage2
  if [ "${run_to_stage2}" = "true" ]; then
    #conda1
    stage0_info "Checking dependencies in ${conda1} environment..."
    # conda1: sra-tools
    check_sra_tools
    # conda1: pigz
    check_pigz
    # conda1: hybpiper
    check_hybpiper
    #check python/R
    check_py_install "pandas"
    check_py_install "seaborn"
    check_py_install "matplotlib"
    check_py_install "numpy"
  fi

  trap '' SIGPIPE
  #run to stage3
  if [ "${run_to_stage3}" = "true" ]; then
    #conda1
    stage0_info "Checking dependencies in ${conda1} environment..."
    chars="hybpiper phyx trimal mafft"
    for dir in ${chars}; do
      if ! grep -q "^${dir}\b" <(conda list -n "${conda1}"); then
        stage0_info "Running from stage 1 to stage 3, 'hybpiper', 'phylopypruner' or 'paragone' must be installed in conda environment ${conda1}."
        stage0_error "'${dir}' is not found in the conda environment ${conda1}."
        stage0_error "Please install '${dir}' in the ${conda1} environment."
        stage0_error "HybSuite exits."
        stage0_blank ""
        exit 1
      fi
    done
    stage0_blank ""
    # conda1: sra-tools
    check_sra_tools
    # conda1: pigz
    check_pigz
    # conda1: hybpiper
    check_hybpiper
    # conda1: phylopypruner
    check_py_phylopypruner
    # conda2: paragone
    check_paragone
    #check python/R
    check_py_install "pandas"
    check_py_install "seaborn"
    check_py_install "matplotlib"
    check_py_install "numpy"
  fi

  #run to trees
  #conda1
  if [ "${run_to_stage4}" = "true" ]; then
    #conda1
    stage0_info "Checking dependencies in ${conda1} environment..."
    # conda1: sra-tools
    check_sra_tools
    # conda1: pigz
    check_pigz
    # conda1: hybpiper
    check_hybpiper
    # conda1: phylopypruner
    check_py_phylopypruner
    # check dependencies in conda1
    # conda2: paragone
    check_paragone
    
    # check r/python
    check_r
    check_r_phytools
    check_r_ape
    check_py_install "pandas"
    check_py_install "seaborn"
    check_py_install "matplotlib"
    check_py_install "numpy"
  fi

  #run all
  #conda1
  if [ "${full_pipeline}" = "true" ]; then
    #conda1
    stage0_info "Checking dependencies in ${conda1} environment..."
    # conda1: sra-tools
    check_sra_tools
    # conda1: pigz
    check_pigz
    # conda1: modeltest-ng
    check_modeltest_ng
    # conda1: iqtree
    check_iqtree
    # conda1: raxml
    check_raxml
    # conda1: raxml-ng
    check_raxml_ng
    # conda1: HybPiper
    check_hybpiper
    # conda2: paragone
    check_paragone
    if [ "${run_wastral}" = "TRUE" ]; then
      # wastral
      check_wastral
    fi
    if [ "${run_wastral}" = "TRUE" ] || [ "${run_astral}" = "TRUE" ]; then
      check_py_install "PyQt5"
      check_py_install "ete3"
    fi
    # check r/python
    check_r
    check_r_phytools
    check_r_ape
    check_py_install "pandas"
    check_py_install "seaborn"
    check_py_install "matplotlib"
    check_py_install "numpy"
  fi

  stage0_info "Well done!"
  stage0_info "All dependencies have been successfully installed in conda environments."
  stage0_info "Proceeding to the next step..."
  stage0_blank ""
  
  #################################################
  ### Step 4: Validate All Arguments #############
  #################################################
  stage0_info "=> Step 4: Validating all arguments"
  if [ "${eas_dir}" != "${o}/01-Assembled_data" ]; then
    if [ ! -e "$(dirname "${eas_dir}")" ]; then
      stage0_info "Verification result:"
      stage0_error "The directory for sequences generated by 'hybpiper assemble' does not exist."
      stage0_error "Please check the -eas_dir parameter."
      stage0_error "HybSuite will exit."
      stage0_blank ""
      exit 1
    fi
  fi

  if [ ! -e "./SRR_Spname.txt" ]; then 
    stage0_attention "SRR_Spname.txt is not prepared for HybSuite."
    stage0_attention "This indicates you intend to use only your own data, not NCBI data."
    stage0_attention "That's fine. HybSuite will proceed using your data."
  fi

  if [ ! -s "./My_Spname.txt" ] && [ "$my_raw_data" = "_____" ]; then 
    stage0_attention "No information about your own data is provided for HybSuite."
    stage0_attention "This means you plan to use only NCBI SRA data for phylogenetic reconstruction."
    stage0_attention "It's okay! HybSuite will continue using public data."
  fi

  if (( $(echo "${min_sample_coverage} >= 0" | bc -l) )) && (( $(echo "${min_sample_coverage} <= 1" | bc -l) )); then
    sleep 1
  else
    stage0_info "Verifing -min_sample_coverage..."
    stage0_info "Validation result:"
    stage0_error "The -sample_coverage value must be greater than 0 and less than 1."
    stage0_error "Please correct it."
    stage0_error "HybSuite will exit."
    stage0_blank ""
    exit 1
  fi
  
  if (( $(echo "${min_locus_coverage} >= 0" | bc -l) )) && (( $(echo "${min_locus_coverage} <= 1" | bc -l) )); then
    sleep 1
  else
    stage0_info "Verifing -min_locus_coverage..."
    stage0_info "Validation result:"
    stage0_error "The -min_locus_coverage value must be greater than 0 and less than 1."
    stage0_error "Please correct it."
    stage0_error "HybSuite will exit."
    stage0_blank ""
    exit 1
  fi
  stage0_info "Well done!"
  stage0_info "All arguments are valid."
  stage0_info "Proceeding to the next step ..."
  stage0_blank ""
fi

#########################################
### Step 5: Check Species Checklists ####
#########################################
cd ${i}
###01 The SRA_toolkit will download the species list from public data (NCBI_Spname_list.txt) and the newly added uncleaned sequencing data (My_Spname.txt). Merge all species lists into (All_new_Spname.txt)
> ./All_Spname_list.txt
# Process NCBI SRA data if available
if [ -s "./SRR_Spname.txt" ]; then
  # Extract SRR IDs and species names from SRR_Spname.txt
  cut -f 1 ./SRR_Spname.txt > ./NCBI_SRR_list.txt
  cut -f 2 ./SRR_Spname.txt > ./NCBI_Spname_list.txt
  
  # If no custom data, use only NCBI data
  [ ! -s "./My_Spname.txt" ] && cp ./NCBI_Spname_list.txt ./All_Spname_list.txt
fi

# Process custom data if available 
if [ -s "./My_Spname.txt" ]; then
  if [ ! -s "./SRR_Spname.txt" ]; then
    # If no NCBI data, use only custom data
    cp ./My_Spname.txt ./All_Spname_list.txt
  else
    sed -e '$a\' "./NCBI_Spname_list.txt" > "./NCBI_Spname_list2.txt"
    sed -e '$a\' ./My_Spname.txt > ./My_Spname2.txt
    cat ./NCBI_Spname_list2.txt ./My_Spname2.txt | sed '/^$/d' > ./All_Spname_list.txt
    rm ./NCBI_Spname_list2.txt
    rm ./My_Spname2.txt
  fi
fi

# Add any additional sequences if specified
if [ "${other_seqs}" != "_____" ]; then
  # Extract species names from fasta files and append to list
  for file in "${other_seqs}"/*.fasta; do
    basename "${file}" .fasta >> ./All_Spname_list.txt
  done
fi

if [ "${skip_checking}" != "TRUE" ]; then
  stage0_info "=> Step 5: Check Species Checklists"
  all_sp_num=$(grep -c '_' < ./All_Spname_list.txt)
  all_genus_num=$(awk -F '_' '{print $1}' ./All_Spname_list.txt|sort|uniq|grep -o '[A-Z]' | wc -l )
  awk -F '_' '{print $1}' ./All_Spname_list.txt|sort|uniq > ./All_Genus_name_list.txt
  if [ -s "${i}/SRR_Spname.txt" ]; then
    SRR_sp_num=$(grep -c '_' < ./NCBI_Spname_list.txt)
    SRR_genus_num=$(awk -F '_' '{print $1}' ./NCBI_Spname_list.txt|sort|uniq|grep -o '[A-Z]' | wc -l)
  fi
  if [ -s "${i}/My_Spname.txt" ]; then
    Add_sp_num=$(grep -c '_' < ./My_Spname.txt)
    Add_genus_num=$(awk -F '_' '{print $1}' ./My_Spname.txt|sort|uniq|grep -o '[A-Z]'|wc -l)
  fi
  if [ -s "${i}/Other_seqs_Spname.txt" ]; then
    Other_sp_num=$(grep -c '_' < ./Other_seqs_Spname.txt)
    Other_genus_num=$(awk -F '_' '{print $1}' ./Other_seqs_Spname.txt|sort|uniq|grep -o '[A-Z]'|wc -l)
  fi
  if [ -s "./NCBI_Spname_list.txt" ]; then
    rm ./NCBI_Spname_list.txt
  fi
fi

if [ "${skip_checking}" != "TRUE" ]; then
  stage0_info "After checking:"
  stage0_info "You plan to construct phylogenetic trees for ${all_sp_num} taxa belonging to ${all_genus_num} genera."
  stage0_info "(1) Taxonomy:"

  while IFS= read -r line || [ -n "$line" ]; do
    num=$(grep -c "$line" ./All_Spname_list.txt)
    stage0_info "${num} species belong to the genus ${line}."
  done < ./All_Genus_name_list.txt
  stage0_info "(2) Data sources:"
  if [ -s "${i}/SRR_Spname.txt" ]; then
    stage0_info "Downloaded raw data: ${SRR_sp_num} species from ${SRR_genus_num} genera."
  else
    stage0_info "Downloaded raw data: SRR_Spname.txt not provided."
  fi
  if [ -s "${i}/My_Spname.txt" ]; then
    stage0_info "Your own raw data: ${Add_sp_num} species from ${Add_genus_num} genera."
  else
    stage0_info "Your own raw data: My_Spname.txt not provided."
  fi
  if [ -s "${i}/Other_seqs_Spname.txt" ]; then
    stage0_info "Your other single-copy genes data: ${Other_sp_num} species from ${Other_genus_num} genera."
  else
    stage0_info "Your other single-copy genes data: Other single-copy gene alignments not provided."
  fi
  stage0_blank ""
  if [ "${other_seqs}" != "_____" ]; then
    rm "${i}"/Other_seqs_Spname.txt
  fi
  
  ################################################
  ### Step 6: Check '-OI' and '-tree' options ####
  ################################################
  stage0_info "=> Step 6: Check '-OI' and '-tree' options"
  stage0_info "According to your command:"
  
  stage0_info "The chosen Ortholog Inference methods:  "
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

  stage0_info "Software choices for constructing phylogenetic trees:  "
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

  ######################################
  ### Step 7: Check the target file ####
  ######################################
  stage0_info "=> Step 7: Check the target sequence file"
  if [ "${run_to_stage1}" = "true" ]; then
    stage0_info "PASS"
  else
    if [ -s "${t}" ]; then
      ref_num=$(grep -c '>' "${t}")
      stage0_info "After checking,"
      stage0_info "The target file is (specified by '-t'):" 
      stage0_info "${t}"
      stage0_info "It contains ${ref_num} sequences"
      stage0_blank ""
    else
      stage0_info "The target file is not provided."
      stage0_info "HybSuite will exit."
      stage0_blank ""
      exit 1
    fi
  fi

  ######################################
  ### Step 8: Check threads ############
  ######################################
  stage0_info "=> Step 8 : Check threads"
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
  stage0_info "PASS"
 
  #Read the answer entered by the user
  stage0_info "All in all, the final results will be outputted to ${o}/"
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
#Create Folders：
###01 Create the desired folder
stage0_info "<<<======= Preparation: Create desired folders and define functions =======>>>"
mkdir -p "${o}/00-logs_and_reports/species_checklists"
stage0_info "Finish"
if [ -s "${i}/SRR_Spname.txt" ]; then
  sed -i '/^$/d' "${i}/SRR_Spname.txt"
fi
if [ -s "${i}/My_Spname.txt" ]; then
  sed -i '/^$/d' "${i}/My_Spname.txt"
fi

#Move the species checklists.
if [ -s "${i}/NCBI_SRR_list.txt" ]; then
  mv ${i}/NCBI_SRR_list.txt ${o}/00-logs_and_reports/species_checklists/
fi

if [ -s "${i}/All_Spname_list.txt" ]; then
  mv ${i}/All_Spname_list.txt ${o}/00-logs_and_reports/species_checklists/
fi

if [ -s "${i}/NCBI_Spname_list.txt" ]; then
  mv ${i}/NCBI_Spname_list.txt ${o}/00-logs_and_reports/species_checklists/
fi

# set the process
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
work_dir="${o}/00-logs_and_reports/logs"

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
          local actual_batch_num=0
          while IFS= read -r batch_line || [ -n "$batch_line" ]; do
              if [[ $batch_line == *"$sample"* ]]; then
                  actual_batch_num=$(echo "$batch_line" | cut -d':' -f1)
                  break
              fi
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
              if [[ $batch_line == *"$sample"* ]]; then
                  current_batch_num=$(echo "$batch_line" | cut -d':' -f1)
                  break
              fi
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
          $info_cmd "${log_mode}" "Processing log (by batches with all samples parallel processes)："
      else
          $info_cmd "${log_mode}" "Processing log (by batches with ${process} samples parallel processes)："
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

  conda_activate() {
    local stage="$1"
    local conda="$2"

    # Check whether conda is available
    if ! command -v conda &>/dev/null; then
        "${stage}"_error "Conda command not found. Please install Conda or ensure it's in your PATH."
        exit 1
    fi

    # Secure access to the current conda environment (compatible with set-u)
    local current_env="${CONDA_DEFAULT_ENV:-}"

    # Defines the function to load the conda hook
    load_conda_hook() {
        local current_shell=$(basename "$SHELL")
        case "$current_shell" in
            bash)
                eval "$(conda shell.bash hook)"
                "${stage}"_info "${log_mode}" "Bash shell detected. Conda hook loaded."
                ;;
            zsh)
                eval "$(conda shell.zsh hook)"
                "${stage}"_info "${log_mode}" "Zsh shell detected. Conda hook loaded."
                ;;
            sh)
                eval "$(conda shell.sh hook)"
                "${stage}"_info "${log_mode}" "Sh shell detected. Conda hook loaded."
                ;;
            fish)
                eval "(conda shell.fish hook)"  # Fish 需要特殊语法
                "${stage}"_info "${log_mode}" "Fish shell detected. Conda hook loaded."
                ;;
            *)
                "${stage}"_error "Unsupported shell: $current_shell"
                exit 1
                ;;
        esac
    }

    # main logic
    if [ "$current_env" = "$conda" ]; then
        "${stage}"_info "${log_mode}" "Already in conda environment ${conda}. Skipping activation."
        "${stage}"_blank_main ""
        return 0
    fi

    # Situations where an environment needs to be activated
    "${stage}"_info "${log_mode}" "Activating conda environment: ${conda}"

    # Turn off Strict mode temporarily
    set +u
    load_conda_hook

    # Execute activation command
    conda activate "${conda}"
    "${stage}"_cmd "${log_mode}" "conda activate ${conda}"

    # Verify activation result
    current_env="${CONDA_DEFAULT_ENV:-}"
    if [ "$current_env" = "$conda" ]; then
        "${stage}"_info "${log_mode}" "Successfully activated ${conda} environment"
        "${stage}"_blank "${log_mode}" ""
    else
        "${stage}"_error "Failed to activate ${conda} environment"
        "${stage}"_error "Current environment: ${current_env:-none}"
        "${stage}"_error "HybSuite exits."
        "${stage}"_blank_main ""
        exit 1
    fi
}

  stage0_blank ""
  # preparation: conda
  # source conda
  #################===========================================================================

if [ "${skip_stage1}" != "TRUE" ] && [ "${skip_stage12}" != "TRUE" ] && [ "${skip_stage123}" != "TRUE" ] && [ "${skip_stage1234}" != "TRUE" ]; then
  ############################################################################################
  #===> Stage 1 NGS dataset construction <===#################################################
  ############################################################################################

  #################===========================================================================
  mkdir -p "${o}/00-logs_and_reports/logs" "${o}/00-logs_and_reports/reports" "${o}/00-logs_and_reports/logs" "${d}/01-Downloaded_raw_data/01-Raw-reads_sra" "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz" "${d}/02-Downloaded_clean_data" "${d}/03-My_clean_data"
  #################===========================================================================

  #################===========================================================================
  # Function: Output information to log file
  stage1_info_main() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "${o}/00-logs_and_reports/logs/Stage1_NGS_dataset_construction_${current_time}.log"
  }
  stage1_info() {
    local log_mode="$1"
    local message="$2"
    if [ "${log_mode}" = "full" ]; then
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $message" | tee -a "${o}/00-logs_and_reports/logs/Stage1_NGS_dataset_construction_${current_time}.log"
    fi
  }
  stage1_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "${o}/00-logs_and_reports/logs/Stage1_NGS_dataset_construction_${current_time}.log"
  }
  stage1_cmd() {
    local log_mode="$1"
    local message="$2"
    
    if [ "${log_mode}" = "cmd" ] || [ "${log_mode}" = "full" ]; then
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] [CMD] $message" >> "${o}/00-logs_and_reports/logs/HybSuite_cmd_${current_time}.log"
    fi
  }
  stage1_blank_main() {
    echo "$1" | tee -a "${o}/00-logs_and_reports/logs/Stage1_NGS_dataset_construction_${current_time}.log"
  }
  stage1_blank() {
    local log_mode="$1"
    local message="$2"
    if [ "${log_mode}" = "full" ]; then
      echo "$message" | tee -a "${o}/00-logs_and_reports/logs/Stage1_NGS_dataset_construction_${current_time}.log"
    fi
  }
  stage1_logfile="${o}/00-logs_and_reports/logs/Stage1_NGS_dataset_construction_${current_time}.log"
  stage1_info_main "<<<======= Stage 1 NGS dataset construction=======>>>"
  #################===========================================================================

  #################===========================================================================
  #Preparation: Activate conda environment ${conda1}
  stage1_info "${log_mode}" "Preparation: Activate conda environment ${conda1}..."
  conda_activate "stage1" "${conda1}"
  #################===========================================================================

  ############################################################################################
  # Stage1-Step1: Download NGS raw data from NCBI via SRAToolKit (sra-tools) #################
  ############################################################################################
  # Use sratoolkit to batch download sra data, then use fasterq-dump to convert the original sra data to fastq/fastq.gz format, and decide whether to delete sra data according to the parameters provided by the user
  if [ -s "${i}/SRR_Spname.txt" ]; then
      # Define total samples number
      total_sps=$(awk 'NF' "${i}/SRR_Spname.txt" | wc -l)
      # Initialize parallel environment
      init_parallel_env "$work_dir" "$total_sps" "$process" "${i}/SRR_Spname.txt" || exit 1
      define_threads "pigz" "$stage1_logfile"
      define_threads "fasterq_dump" "$stage1_logfile"
      stage1_info_main "Step1: Downloading raw data for ${total_sps} samples with ${process_num} parallel processes from NCBI..."
      stage1_info_main "====>> Running sratoolkit to download raw data (${process} in parallel) ====>>"
      while IFS= read -r sample || [ -n "$sample" ]; do
          srr=$(echo "${sample}" | awk '{print $1}')
          spname=$(echo "${sample}" | awk '{print $2}')
          if [ "${process}" != "all" ]; then
              read -u1000
          fi
          # Here you can define skip conditions
          if [ "$download_format" = "fastq_gz" ]; then
              if ([ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq.gz" ] && [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq.gz" ]) \
              || [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq.gz" ]; then
                  record_skipped_sample "$spname" "Skipped downloading existing samples:" "$stage1_logfile"
                  if [ "${process}" != "all" ]; then
                      echo >&1000
                  fi
                  continue
              fi
          elif [ "$download_format" = "fastq" ]; then
              if ([ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq" ] && [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq" ]) \
              || [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq" ]; then
                  record_skipped_sample "$spname" "Skipped downloading existing samples:" "$stage1_logfile"
                  if [ "${process}" != "all" ]; then
                      echo >&1000
                  fi
                  continue
              fi
          fi
          {
              
              # Update start count
              update_start_count "$spname" "$stage1_logfile"

              # Your processing logic
              if [ "$download_format" = "fastq_gz" ]; then
                  # prefetch
                  prefetch "$srr" -O "${d}/01-Downloaded_raw_data/01-Raw-reads_sra/" > /dev/null 2>&1
                  # Check if failed
                  if [ ! -s "${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra" ]; then
                      record_failed_sample "$spname"
                      continue
                  fi

                  # fasterq-dump
                  fasterq-dump ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra -e ${nt_fasterq_dump} -p -O ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/ > /dev/null 2>&1
                  if [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq" ] && [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq" ] && [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq" ]; then
                      record_failed_sample "$spname"
                      continue
                  fi

                  # pigz for single-ended
                  if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq" ]; then
                      pigz -p ${nt_pigz} ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq > /dev/null 2>&1
                      if [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq.gz" ]; then
                          record_failed_sample "$spname"
                          continue
                      fi
                  fi

                  # pigz for pair-ended
                  if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq" ] && [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq" ]; then
                      pigz -p ${nt_pigz} ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq > /dev/null 2>&1
                      pigz -p ${nt_pigz} ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq > /dev/null 2>&1
                      if [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq.gz" ] && [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq.gz" ]; then
                          record_failed_sample "$spname"
                          continue
                      fi
                  fi

                  #remove the srr files
                  if [ "$rm_sra" != "FALSE" ]; then
                      rm -r ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}          
                  fi

                  #rename the files
                  if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq.gz" ] && [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq.gz" ]; then
                      mv "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq.gz" "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq.gz"
                      mv "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq.gz" "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq.gz"
                  fi
                  if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq.gz" ]; then
                      mv "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq.gz" "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq.gz"
                  fi
              fi
              #if the user choose the format of downloading as fastq
              if [ "$download_format" = "fastq" ]; then
                  # prefetch
                  prefetch "$srr" -O "${d}/01-Downloaded_raw_data/01-Raw-reads_sra/" > /dev/null 2>&1
                  # Check if failed
                  if [ ! -s "${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra" ]; then
                      record_failed_sample "$spname"
                      continue
                  fi

                  # fasterq-dump
                  fasterq-dump ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra -e ${nt_fasterq_dump} -p -O ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/ > /dev/null 2>&1
                  if [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq" ] && [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq" ] && [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq" ]; then
                      record_failed_sample "$spname"
                      continue
                  fi

                  #rename the files
                  if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq" ] && [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq" ]; then
                      mv "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq" "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq"
                      mv "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq" "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq"
                  fi
                  if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq" ]; then
                      mv "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq" "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq"
                  fi
              fi
              
              # Update finish count
              update_finish_count "$spname" "$stage1_logfile"
              
              if [ "${process}" != "all" ]; then
                  echo >&1000
              fi
          } &
      done < "${i}/SRR_Spname.txt"
      # Wait for all tasks to complete
      wait
      echo
      # Display processing log
      if [ "${log_mode}" = "full" ]; then
        display_process_log "$stage1_logfile" "stage1" "Failed to download raw data:"
      fi
      stage1_blank_main ""
  fi
  ############################################################################################

  ############################################################################################
  #Stage1-Step2: Remove the adapters via Trimmomatic #########################################
  ############################################################################################
  # Filter NGS raw data via trimmomatic
  # Raw data filtering of NCBI public data (premise: the user provides SRR_Spname.txt and opts not to use the existing clean.paired.fq file)
  stage1_info_main "Step2: Removing adapters of raw data via Trimmomatic-0.39 ..."
  cd ${d}
  define_threads "trimmomatic" "$stage1_logfile"
  if [ -s "${i}/SRR_Spname.txt" ]; then
      total_sps=$(awk 'NF' "${i}/SRR_Spname.txt" | wc -l)
      # Initialize parallel environment
      init_parallel_env "$work_dir" "$total_sps" "$process" "${i}/SRR_Spname.txt" || exit 1
      stage1_info_main "====>> Removing adapters for downloaded raw data of ${total_sps} samples (${process} in parallel) ====>>"
      stage1_info_main "Sequences that have already had adapters removed will not be trimmed for adapters again!!!"
      while IFS= read -r sample || [ -n "$sample" ]; do
          spname=$(echo "${sample}" | awk '{print $2}')
          # Skip samples that have already had adapters removed
          if { [ -s "${d}/02-Downloaded_clean_data/${spname}_1_clean.paired.fq.gz" ] && [ -s "${d}/02-Downloaded_clean_data/${spname}_2_clean.paired.fq.gz" ]; } || [ -s "${d}/02-Downloaded_clean_data/${spname}_clean.single.fq.gz" ]; then
              record_skipped_sample "$spname" "Skipped removing adapters for samples:" "$stage1_logfile"
              if [ "${process}" != "all" ]; then
                  echo >&1000
              fi
              continue
          fi
          if [ "${process}" != "all" ]; then
            read -u1000
          fi
          {
          # Update start count
          update_start_count "$spname" "$stage1_logfile"
          if ([ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq" ] && [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq" ]) \
          || ([ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq.gz" ] && [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq.gz" ]); then
              files1=(${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.f*)
              files2=(${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.f*)
              if [ ${#files1[@]} -gt 0 ] && [ ${#files2[@]} -gt 0 ]; then
                  java -jar "${script_dir}"/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar PE \
                      -threads ${nt_trimmomatic} \
                      -phred33 \
                      ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.f* ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.f* \
                      ./02-Downloaded_clean_data/${spname}_1_clean.paired.fq.gz ./02-Downloaded_clean_data/${spname}_1_clean.unpaired.fq.gz \
                      ./02-Downloaded_clean_data/${spname}_2_clean.paired.fq.gz ./02-Downloaded_clean_data/${spname}_2_clean.unpaired.fq.gz \
                      ILLUMINACLIP:${script_dir}/../dependencies/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10 \
                      SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} \
                      LEADING:${trimmomatic_leading_quality} \
                      TRAILING:${trimmomatic_trailing_quality} \
                      MINLEN:${trimmomatic_min_length} > /dev/null 2>&1
                  if [ ! -s "${d}/02-Downloaded_clean_data/${spname}_1_clean.paired.fq.gz" ] || [ ! -s "${d}/02-Downloaded_clean_data/${spname}_2_clean.paired.fq.gz" ]; then
                      record_failed_sample "$spname"
                      continue
                  fi
              fi
          fi
          #for single-ended
          if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq" ] \
          || [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq.gz" ]; then  
              files3=(${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.f*)
              if [ ${#files3[@]} -gt 0 ]; then
                  java -jar ${script_dir}/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar SE \
                      -threads ${nt_trimmomatic} \
                      -phred33 \
                      ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.f* \
                      ${d}/02-Downloaded_clean_data/${spname}_clean.single.fq.gz \
                      ILLUMINACLIP:${script_dir}/../dependencies/Trimmomatic-0.39/adapters/TruSeq3-SE.fa:2:30:10 \
                      SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} \
                      LEADING:${trimmomatic_leading_quality} \
                      TRAILING:${trimmomatic_trailing_quality} \
                      MINLEN:${trimmomatic_min_length} > /dev/null 2>&1

                  if [ ! -s "${d}/02-Downloaded_clean_data/${spname}_clean.single.fq.gz" ]; then
                      record_failed_sample "$spname"
                      continue
                  fi
              fi
          fi
          # Update finish count
          update_finish_count "$spname" "$stage1_logfile"
          if [ "${process}" != "all" ]; then
              echo >&1000
          fi
        } &
      done < "${i}/SRR_Spname.txt"
      wait
      echo
      # Display processing log
      if [ "${log_mode}" = "full" ]; then
        display_process_log "$stage1_logfile" "stage1" "Failed to remove adapters for samples:"
      fi
  fi

  if [ -s "${i}/My_Spname.txt" ] && [ -e "$my_raw_data" ]; then
    # Define total samples number
    total_sps=$(awk 'NF' "${i}My_Spname.txt" | wc -l)
    # Initialize parallel environment
    init_parallel_env "$work_dir" "$total_sps" "$process" "${i}/My_Spname.txt"
    stage1_info_main "Removing adapters for existing raw data of ${total_sps} samples..."
    stage1_info_main "Sequences that have already had adapters removed will not be trimmed for adapters again!!!"
    while IFS= read -r sample || [ -n "$sample" ]; do
      # Skip samples that have already had adapters removed
      if [ -s "${d}/02-Downloaded_clean_data/${sample}_1_clean.paired.fq.gz" ] && [ -s "${d}/02-Downloaded_clean_data/${sample}_2_clean.paired.fq.gz" ] || [ -s "${d}/02-Downloaded_clean_data/${sample}_clean.single.fq.gz" ]; then
        record_skipped_sample "$sample" "Skipped removing adapters for samples:" "$stage1_logfile"
        if [ "${process}" != "all" ]; then
            echo >&1000
        fi
        continue
      fi
      {
          # Update start count
          update_start_count "$sample" "$stage1_logfile"
          #for pair-ended
          if ([ -s "${my_raw_data}/${sample}_1.fastq" ] && [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${sample}_2.fastq" ]) \
          || ([ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${sample}_1.fastq.gz" ] && [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${sample}_2.fastq.gz" ]); then
              files1=(${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${sample}_1.f*)
              files2=(${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${sample}_2.f*)
              if [ ${#files1[@]} -gt 0 ] && [ ${#files2[@]} -gt 0 ]; then
                  java -jar ${script_dir}/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar PE \
                      -threads ${nt_trimmomatic} \
                      -phred33 \
                      ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${sample}_1.f* ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${sample}_2.f* \
                      ./02-Downloaded_clean_data/${sample}_1_clean.paired.fq.gz ./02-Downloaded_clean_data/${sample}_1_clean.unpaired.fq.gz \
                      ./02-Downloaded_clean_data/${sample}_2_clean.paired.fq.gz ./02-Downloaded_clean_data/${sample}_2_clean.unpaired.fq.gz \
                      ILLUMINACLIP:${script_dir}/../dependencies/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10 \
                      SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} \
                      LEADING:${trimmomatic_leading_quality} \
                      TRAILING:${trimmomatic_trailing_quality} \
                      MINLEN:${trimmomatic_min_length} > /dev/null 2>&1
                  if [ ! -s "${d}/02-Downloaded_clean_data/${sample}_1_clean.paired.fq.gz" ] || [ ! -s "${d}/02-Downloaded_clean_data/${sample}_2_clean.paired.fq.gz" ]; then
                      record_failed_sample "$sample"
                      continue
                  fi
              fi
          fi
          #for single-ended
          if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${sample}.fastq" ] \
          || [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${sample}.fastq.gz" ]; then  
              files3=(${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${sample}.f*)
              if [ ${#files3[@]} -gt 0 ]; then
                  java -jar ${script_dir}/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar SE \
                      -threads ${nt_trimmomatic} \
                      -phred33 \
                      ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${sample}.f* \
                      ${d}/02-Downloaded_clean_data/${sample}_clean.single.fq.gz \
                      ILLUMINACLIP:${script_dir}/../dependencies/Trimmomatic-0.39/adapters/TruSeq3-SE.fa:2:30:10 \
                      SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} \
                      LEADING:${trimmomatic_leading_quality} \
                      TRAILING:${trimmomatic_trailing_quality} \
                      MINLEN:${trimmomatic_min_length} > /dev/null 2>&1

                  if [ ! -s "${d}/02-Downloaded_clean_data/${sample}_clean.single.fq.gz" ]; then
                      record_failed_sample "$sample"
                      continue
                  fi
              fi
          fi
          # Update finish count
          update_finish_count "$sample" "$stage1_logfile"
          if [ "${process}" != "all" ]; then
              echo >&1000
          fi
      } &
    done < "${i}/My_Spname.txt"
    # Wait for all tasks to complete
    wait
    echo
    # Display processing log
    if [ "${log_mode}" = "full" ]; then
      display_process_log "$stage1_logfile" "stage1" "Failed to remove adapters for samples:"
    fi
  fi

  ############################################################################################
  # End of Stage 1
  stage1_info "${log_mode}" "Successfully finishing running stage1: 'NGS database construction'. "
  stage1_info "${log_mode}" "The NGS raw data and clean data have been output to ${d}"
  if [ "${run_to_stage1}" = "true" ]; then
    # Clean up environment
    cleanup_parallel_env "$work_dir"
    stage1_info "${log_mode}" "You set '--run_to_stage1' to specify HybSuite to run only stage 1."
    stage1_info "${log_mode}" "Consequently, HybSuite will stop and exit right now."
    stage1_info_main "Thank you for using HybSuite! Enjoy your research!"
    stage1_blank_main ""
    exit 1
  else
    stage1_info "${log_mode}" "Now moving on to the next stage ..."
    stage1_blank_main ""
  fi
  ############################################################################################
fi

############################################################################################
# Stage 2 Data assembly and filtered paralogs recovering ###################################
############################################################################################
if [ "${skip_stage12}" != "TRUE" ] && [ "${skip_stage123}" != "TRUE" ] && [ "${skip_stage1234}" != "TRUE" ]; then
  #################===========================================================================
  # 0.Preparation
  # (1) Function: Output information to log file
  stage2_info_main() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "${o}/00-logs_and_reports/logs/Stage2_Data_assembly_and_filtered_paralogs_recovering_${current_time}.log"
  }
  stage2_info() {
    local log_mode="$1"
    local message="$2"
    if [ "${log_mode}" = "full" ]; then
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $message" | tee -a "${o}/00-logs_and_reports/logs/Stage2_Data_assembly_and_filtered_paralogs_recovering_${current_time}.log"
    fi
  }
  stage2_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "${o}/00-logs_and_reports/logs/Stage2_Data_assembly_and_filtered_paralogs_recovering_${current_time}.log"
  }
  stage2_cmd_main() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [CMD] $1" | tee -a "${o}/00-logs_and_reports/logs/Stage2_Data_assembly_and_filtered_paralogs_recovering_${current_time}.log"
  }
  stage2_cmd() {
    local log_mode="$1"
    local message="$2"
    
    if [ "${log_mode}" = "cmd" ] || [ "${log_mode}" = "full" ]; then
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] [CMD] $message" >> "${o}/00-logs_and_reports/logs/HybSuite_cmd_${current_time}.log"
    fi
  }
  stage2_blank_main() {
    echo "$1" | tee -a "${o}/00-logs_and_reports/logs/Stage2_Data_assembly_and_filtered_paralogs_recovering_${current_time}.log"
  }
  stage2_blank() {
    local log_mode="$1"
    local message="$2"
    if [ "${log_mode}" = "full" ]; then
      echo "$message" | tee -a "${o}/00-logs_and_reports/logs/Stage2_Data_assembly_and_filtered_paralogs_recovering_${current_time}.log"
    fi
  }
  #################===========================================================================

  #################===========================================================================
  # (2) Change working directory and conda environment
  cd ${o}/01-Assembled_data
  stage2_info_main "<<<======= Stage 2 Data assembly and filtered paralogs recovering =======>>>"
  conda_activate "stage2" "${conda1}"
  # (3) Define log file
  stage2_logfile="${o}/00-logs_and_reports/logs/Stage2_Data_assembly_and_filtered_paralogs_recovering_${current_time}.log"
  # (4) Define threads
  define_threads "hybpiper" "${stage2_logfile}"
  stage2_blank "${log_mode}" ""
  #################===========================================================================

  #################===========================================================================
  # (5) Backup existing namelist file
  [ -s "${eas_dir}/Assembled_data_namelist.txt" ] && cp "${eas_dir}/Assembled_data_namelist.txt" "${eas_dir}/Old_assembled_data_namelist_${current_time}.txt"
  # (6) Create a new namelist file
  > "${eas_dir}/Assembled_data_namelist.txt"
  # (7) Process namelist based on input files
  if [ -s "${i}/SRR_Spname.txt" ] && [ ! -s "${i}/My_Spname.txt" ]; then
    # When only SRR data exists, use NCBI species list directly
    cp "${o}/00-logs_and_reports/species_checklists/NCBI_Spname_list.txt" "${eas_dir}/Assembled_data_namelist.txt"
  elif [ -s "${i}/My_Spname.txt" ] && [ ! -s "${i}/SRR_Spname.txt" ]; then
    # When only custom data exists, use My_Spname directly
    cp "${i}/My_Spname.txt" "${eas_dir}/Assembled_data_namelist.txt"
  elif [ -s "${i}/My_Spname.txt" ] && [ -s "${i}/SRR_Spname.txt" ]; then
    # When both types of data exist, merge the lists
    cat "${o}/00-logs_and_reports/species_checklists/NCBI_Spname_list.txt" "${i}/My_Spname.txt" | sed '/^$/d' > "${eas_dir}/Assembled_data_namelist.txt"
  fi
  #################===========================================================================


  ############################################################################################
  #Stage2-Step1: Data assembly ###############################################################
  ############################################################################################

  #################===========================================================================
  stage2_info_main "Step 1: Assembling data using 'hybpiper assemble'..."
  mkdir -p "${o}/01-Assembled_data/"
  cd "${eas_dir}"
  #################===========================================================================
  if [ -s "${eas_dir}/Assembled_data_namelist.txt" ]; then
    total_sps=$(awk 'END {print NR}' "${eas_dir}/Assembled_data_namelist.txt")
    init_parallel_env "$work_dir" "$total_sps" "$process" "${eas_dir}/Assembled_data_namelist.txt" || exit 1
    stage2_info_main "====>> Running 'hybpiper assemble' to assemble data (${process} in parallel) ====>>"
    while IFS= read -r Spname || [ -n "$Spname" ]; do
      # Here you can define skip conditions
      if [ -s "${eas_dir}/${Spname}/genes_with_seqs.txt" ]; then
          record_skipped_sample "$Spname" "Skipped data assembly for existing samples:" "$stage2_logfile"
          if [ "${process}" != "all" ]; then
            echo >&1000
          fi
          continue
      fi
      # Your processing logic
      if [ -e "${eas_dir}/${Spname}" ] && [ ! -e "${eas_dir}/${Spname}/genes_with_seqs.txt" ]; then
          rm -rf "${eas_dir}/${Spname}/*"
      fi
      if [ "${process}" != "all" ]; then
          read -u1000
      fi
      {
        # Update start count
        update_start_count "$Spname" "$stage2_logfile"
      
        # Run the loop
        if [ -d "${Spname}" ] && [ ! -s "${Spname}/${Spname}_chimera_check_performed.txt" ]; then
          echo "True" > "${Spname}/${Spname}_chimera_check_performed.txt"
        fi
        # For paired-end
        if ([ -s "${d}/02-Downloaded_clean_data/${Spname}_1_clean.paired.fq.gz" ] && [ -s "${d}/02-Downloaded_clean_data/${Spname}_2_clean.paired.fq.gz" ]) \
        && [ ! -s "${d}/02-Downloaded_clean_data/${Spname}_clean.single.fq.gz" ]; then
          # 01: for protein reference sequence
          # Use diamond to map reads
          if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "diamond" ]; then
              hybpiper assemble "-t_${hybpiper_tt}" ${t} \
              -r ${d}/02-Downloaded_clean_data/${Spname}_1_clean.paired.fq.gz ${d}/02-Downloaded_clean_data/${Spname}_2_clean.paired.fq.gz \
              -o ${eas_dir} \
              --prefix ${Spname} \
              --diamond \
              --cpu ${nt_hybpiper} > /dev/null 2>&1
          fi
          # Use BLASTx (default) to map reads
          if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "blast" ]; then
              hybpiper assemble "-t_${hybpiper_tt}" ${t} \
              -r ${d}/02-Downloaded_clean_data/${Spname}_1_clean.paired.fq.gz ${d}/02-Downloaded_clean_data/${Spname}_2_clean.paired.fq.gz \
              -o ${eas_dir} \
              --prefix ${Spname} \
              --cpu ${nt_hybpiper} > /dev/null 2>&1
          fi
          # 02: for nucleotide reference sequence
          if [ "${hybpiper_tt}" = "dna" ]; then
              hybpiper assemble "-t_${hybpiper_tt}" ${t} \
              -r ${d}/02-Downloaded_clean_data/${Spname}_1_clean.paired.fq.gz ${d}/02-Downloaded_clean_data/${Spname}_2_clean.paired.fq.gz \
              -o ${eas_dir} \
              --prefix ${Spname} \
              --bwa \
              --cpu ${nt_hybpiper} > /dev/null 2>&1
          fi
        fi
        # For single-end
        if ([ ! -s "${d}/02-Downloaded_clean_data/${Spname}_1_clean.paired.fq.gz" ] && [ ! -s "${d}/02-Downloaded_clean_data/${Spname}_2_clean.paired.fq.gz" ]) \
        && [ -s "${d}/02-Downloaded_clean_data/${Spname}_clean.single.fq.gz" ]; then
          # 01: for protein reference sequence
          # 01-1: use diamond to map reads
          if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "diamond" ]; then
              hybpiper assemble "-t_${hybpiper_tt}" ${t} \
              -r ${d}/02-Downloaded_clean_data/${Spname}_clean.single.fq.gz \
              -o ${eas_dir} \
              --prefix ${Spname} \
              --diamond \
              --cpu ${nt_hybpiper} > /dev/null 2>&1
          fi
          # 01-2: use BLASTx (default) to map reads
          if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "blast" ]; then
              hybpiper assemble "-t_${hybpiper_tt}" ${t} \
              -r ${d}/02-Downloaded_clean_data/${Spname}_clean.single.fq.gz \
              -o ${eas_dir} \
              --prefix ${Spname} \
              --cpu ${nt_hybpiper} > /dev/null 2>&1
          fi
          # 02: for nucleotide reference sequence
          if [ "${hybpiper_tt}" = "dna" ]; then
              hybpiper assemble "-t_${hybpiper_tt}" ${t} \
              -r ${d}/02-Downloaded_clean_data/${Spname}_clean.single.fq.gz \
              -o ${eas_dir} \
              --prefix ${Spname} \
              --bwa \
              --cpu ${nt_hybpiper} > /dev/null 2>&1
          fi
        fi
        if [ -s "${eas_dir}/${Spname}/genes_with_seqs.txt" ]; then
          update_finish_count "$Spname" "$stage2_logfile"
        else
            record_failed_sample "$Spname"
        fi
        if [ "${process}" != "all" ]; then
            echo >&1000
        fi
      } &
    done < "${eas_dir}/Assembled_data_namelist.txt"
    # Wait for all tasks to complete
    wait
    echo
    # Display processing log
    if [ "${log_mode}" = "full" ]; then
      display_process_log "$stage2_logfile" "stage2" "Failed to assemble data:"
    fi
    stage2_blank_main ""
  fi
  grep '>' ${t} | awk -F'-' '{print $NF}' | sort | uniq > "${o}/00-logs_and_reports/reports/Ref_gene_name_list.txt"

  ############################################################################################
  #Stage2-Step2: Recovering all original paralogs via HybPiper ###################################
  ############################################################################################

  #################===========================================================================
  if [ "$LS" = "TRUE" ] || [ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "${one_to_one}" = "TRUE" ] || [ "${RLWP}" = "TRUE" ]; then
    stage2_info_main "Step 2: Recovering all original paralogs via HybPiper..."
    if [ -d "${o}/02-All_paralogs/" ]; then
      rm -rf "${o}/02-All_paralogs/"
    fi
    mkdir -p "${o}/02-All_paralogs/01-Original_paralogs" "${o}/02-All_paralogs/02-Original_paralog_reports_and_heatmap"
    cd "${o}/02-All_paralogs/02-Original_paralog_reports_and_heatmap"
  #################===========================================================================
    stage2_cmd "${log_mode}" "hybpiper paralog_retriever ${eas_dir}/Assembled_data_namelist.txt "-t_${hybpiper_tt}" ${t} --fasta_dir_all ${o}/02-All_paralogs --hybpiper_dir ${eas_dir} --no_heatmap"
    hybpiper paralog_retriever ${eas_dir}/Assembled_data_namelist.txt "-t_${hybpiper_tt}" ${t} \
      --fasta_dir_all "${o}/02-All_paralogs/01-Original_paralogs" \
      --hybpiper_dir "${eas_dir}" \
      --no_heatmap > /dev/null 2>&1
    if [ ! -s "./paralog_report.tsv" ] && [ ! -s "./paralogs_above_threshold_report.txt" ]; then
      stage2_error "Fail to recover original paralogs via HybPiper."
      stage2_error "HybSuite exits."
      stage2_blank "${log_mode}" ""
      exit 1
    else
      stage2_info_main "Successfully finishing recovering original paralogs by running 'hybpiper paralog_retriever'. "
      stage2_blank "${log_mode}" ""
    fi
    rm ./paralog_report.tsv ./paralogs_above_threshold_report.txt
    find "${o}/02-All_paralogs/01-Original_paralogs/" -type f -empty -delete
    stage2_blank_main ""

  ############################################################################################
  #Stage2-Optional step: Adding additional sequences to the dataset ##########################
  ############################################################################################
    if [ "${other_seqs}" != "_____" ]; then
      stage2_info_main "Optional step: Adding other sequences with single copy orthologs ..."
      stage2_info_main "====>> Adding other sequences with single copy orthologs (${process} in parallel) ====>>"
      
      # 01-Remove the existing single copy orthologs
      if ls ${o}/00-logs_and_reports/reports/Other_single_hit_seqs/*.fasta 1> /dev/null 2>&1; then
        rm ${o}/00-logs_and_reports/reports/Other_single_hit_seqs/*.fasta
      fi
      mkdir -p ${o}/00-logs_and_reports/reports/Other_single_hit_seqs/
      cd "${other_seqs}"
      
      # 02-Create a species name list for the other single copy orthologs
      > ${o}/00-logs_and_reports/species_checklists/Other_seqs_Spname_list.txt
      total_sps=$(ls *.fasta | wc -l)
      for fasta_file in *.fasta; do
        spname="${fasta_file%.fasta}"
        echo "${spname}" >> ${o}/00-logs_and_reports/species_checklists/Other_seqs_Spname_list.txt
      done

      # 03-Initialize parallel environment
      init_parallel_env "$work_dir" "$total_sps" "$process" "${o}/00-logs_and_reports/species_checklists/Other_seqs_Spname_list.txt" || exit 1
      
      # 04-Run the main loop
      while IFS= read -r add_sp || [ -n "$add_sp" ]; do
        total_genes=$(awk 'END {print NR}' "${o}/00-logs_and_reports/reports/Ref_gene_name_list.txt")
        if [ "${process}" != "all" ]; then
              read -u1000
        fi
        {
        # Update start count
        update_start_count "$add_sp" "$stage2_logfile"
        while IFS= read -r add_gene || [ -n "$add_gene" ]; do
          sed -e "s|^.*[gene=${add_gene}].*$|>${add_gene} single_hit|g" "${file}" > "${add_sp}_${add_gene}_single_hit.fa"
          sed -e "s|>${add_gene}.*$|>${add_gene} single_hit|g" "${file}" > "${add_sp}_${add_gene}_single_hit.fa"
          awk -v gene=">${add_gene} single_hit" '/^>/ {if (print_flag) print ""; print_flag=0} $0 ~ gene {print_flag=1} print_flag {print} END {if (print_flag) print ""}' \
          "${add_sp}_${add_gene}_single_hit.fa" >> "${o}/02-All_paralogs/01-Original_paralogs/${add_gene}_paralogs_all.fasta" 
          awk -v gene=">${add_gene} single_hit" '/^>/ {if (print_flag) print ""; print_flag=0} $0 ~ gene {print_flag=1} print_flag {print} END {if (print_flag) print ""}' \
          "${add_sp}_${add_gene}_single_hit.fa" >> "${o}/00-logs_and_reports/reports/Other_single_hit_seqs/${add_gene}.fasta"
          sed -i "s|${add_gene}|${add_sp}|g;/^$/d" "${o}/02-All_paralogs/01-Original_paralogs/${add_gene}_paralogs_all.fasta" > /dev/null
          sed -i "s|${add_gene}|${add_sp}|g;/^$/d" "${o}/00-logs_and_reports/reports/Other_single_hit_seqs/${add_gene}.fasta" > /dev/null
        done < "${o}/00-logs_and_reports/reports/Ref_gene_name_list.txt"
        find . -type f -name "*.fa" -exec rm -f {} +
        # Update failed sample list
        if ! grep -q "${add_sp}" "${o}"/02-All_paralogs/01-Original_paralogs/*_paralogs_all.fasta; then
            record_failed_sample "$add_sp"
            continue
        fi
        # Update finish count
        update_finish_count "$add_sp" "$stage2_logfile"
        if [ "${process}" != "all" ]; then
              echo >&1000
        fi
        } &
      done < "${o}/00-logs_and_reports/species_checklists/Other_seqs_Spname_list.txt"
      wait
      echo
      # Display processing log
      if [ "${log_mode}" = "full" ]; then
        display_process_log "$stage2_logfile" "stage2" "Failed to add other sequences:"
      fi
      stage2_blank_main ""

      # 05-Formatting the output paralogs
      cd "${o}"/02-All_paralogs/01-Original_paralogs
      for file in *.fasta; do
        python "${script_dir}/Fasta_formatter.py" -i "${file}" -o "${file}" -nt "${nt}" --inter > /dev/null 2>&1
      done
    fi

  ############################################################################################
  #Stage2-Step3: Filtering paralogs by length, locus and sample coverage ######################
  ############################################################################################
  #################===========================================================================
    stage2_info_main "Step 3: Filtering paralogs by length, locus and sample coverage..."
    mkdir -p "${o}/02-All_paralogs/03-Filtered_paralogs" "${o}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap"
    cd "${eas_dir}"
  #################===========================================================================
    # 01-Filtering out paralogs with low length
    stage2_info_main "01-Filtering out paralogs with low length via 'filter_seqs_by_length.py'..."
    stage2_cmd "${log_mode}" "python ${script_dir}/filter_seqs_by_length.py -i ${o}/02-All_paralogs/01-Original_paralogs -or ${o}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_out_paralogs_with_low_length_info.tsv --output_dir ${o}/02-All_paralogs/03-Filtered_paralogs --ref ${t} --min_length ${min_length} --mean_length_ratio ${mean_length_ratio} --max_length_ratio ${max_length_ratio} --threads ${nt}"
    stage2_01="python ${script_dir}/filter_seqs_by_length.py \
    -i ${o}/02-All_paralogs/01-Original_paralogs \
    -or ${o}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_out_paralogs_with_low_length_info.tsv \
    --output_dir ${o}/02-All_paralogs/03-Filtered_paralogs \
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
    stage2_info_main "02-Filtering out taxa with low locus coverage and loci with low sample coverage via 'filter_seqs_by_sample_and_locus_coverage.py'..."
    stage2_cmd "${log_mode}" "python ${script_dir}/filter_seqs_by_sample_and_locus_coverage.py -i ${o}/02-All_paralogs/03-Filtered_paralogs --min_locus_coverage ${min_locus_coverage} --min_sample_coverage ${min_sample_coverage} --removed_samples_info ${o}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_out_samples_with_low_locus_coverage_info.tsv --removed_loci_info ${o}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_out_loci_with_low_sample_coverage_info.tsv --threads ${nt}"
    stage2_02="python ${script_dir}/filter_seqs_by_sample_and_locus_coverage.py \
    -i ${o}/02-All_paralogs/03-Filtered_paralogs \
    --min_locus_coverage ${min_locus_coverage} \
    --min_sample_coverage ${min_sample_coverage} \
    --removed_samples_info ${o}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_out_samples_with_low_locus_coverage_info.tsv \
    --removed_loci_info ${o}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_out_loci_with_low_sample_coverage_info.tsv \
    --threads ${nt}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage2_02}"
    else
      eval "${stage2_02} > /dev/null 2>&1"
    fi

    stage2_info "${log_mode}" "Finish"
    stage2_info "${log_mode}" "The information of filtered out paralog sequences with low length has been written to:"
    stage2_info "${log_mode}" "${o}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_out_paralogs_with_low_length_info.tsv"
    stage2_info "${log_mode}" "The information of filtered out taxa with low locus coverage has been written to:"
    stage2_info "${log_mode}" "${o}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_out_samples_with_low_locus_coverage_info.tsv"
    stage2_info "${log_mode}" "The information of filtered out loci with low sample coverage has been written to:"
    stage2_info "${log_mode}" "${o}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_out_loci_with_low_sample_coverage_info.tsv"
    stage2_blank_main ""
    ############################################################################################
    #Stage2-Step4: Producing the paralog report and plotting the paralog heatmap ###############
    ############################################################################################
    stage2_info_main "Step 4: Producing the paralog report and plotting the paralog heatmap..."
    # 01-Producing the paralogs report and plotting the paralogs heatmap for the unfiltered (original) paralogs
    stage2_info_main "01-Producing the paralogs report and plotting the paralogs heatmap for the unfiltered (original) paralogs..."
    stage2_cmd "${log_mode}" "python ${script_dir}/plot_paralog_heatmap.py -i ${o}/02-All_paralogs/01-Original_paralogs -oph ${o}/02-All_paralogs/02-Original_paralog_reports_and_heatmap/Original_paralog_heatmap.png -opr ${o}/02-All_paralogs/02-Original_paralog_reports_and_heatmap/Original_paralog_report.tsv -t ${nt} --show_values --color ${heatmap_color}"
    stage2_03="python ${script_dir}/plot_paralog_heatmap.py \
    -i ${o}/02-All_paralogs/01-Original_paralogs \
    -oph ${o}/02-All_paralogs/02-Original_paralog_reports_and_heatmap/Original_paralog_heatmap.png \
    -opr ${o}/02-All_paralogs/02-Original_paralog_reports_and_heatmap/Original_paralog_report.tsv \
    -t ${nt} \
    --show_values \
    --color ${heatmap_color}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage2_03}"
    else
      eval "${stage2_03} > /dev/null 2>&1"
    fi

    # 02-Producing the paralogs report and plotting the paralogs heatmap for the filtered paralogs
    stage2_info_main "02-Producing the paralogs report and plotting the paralogs heatmap for the filtered paralogs..."
    stage2_cmd "${log_mode}" "python ${script_dir}/plot_paralog_heatmap.py -i ${o}/02-All_paralogs/03-Filtered_paralogs -oph ${o}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_paralog_heatmap.png -opr ${o}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_paralog_report.tsv -t ${nt} --show_values --color ${heatmap_color}"
    stage2_04="python ${script_dir}/plot_paralog_heatmap.py \
    -i ${o}/02-All_paralogs/03-Filtered_paralogs \
    -oph ${o}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_paralog_heatmap.png \
    -opr ${o}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap/Filtered_paralog_report.tsv \
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
  stage2_info_main "Successfully finishing the stage2: 'Data assembly and filtered paralogs recovering'."
  stage2_info "${log_mode}" "The resulting files have been saved in ${o}/02-All_paralogs/04-Filtered_paralog_reports_and_heatmap"

  if [ "${run_to_stage2}" = "true" ]; then
    # Clean up environment
    cleanup_parallel_env "$work_dir"
    stage2_info "${log_mode}" "You set '--run_to_stage2' to specify HybSuite to run only stage 2."
    stage2_info "${log_mode}" "Consequently, HybSuite will stop and exit right now."
    stage2_info_main "Thank you for using HybSuite! Enjoy your research!"
    stage2_blank_main ""
    exit 1
  else
    stage2_info "${log_mode}" "Moving on to the next stage..."
    stage2_blank_main ""
  fi
  ############################################################################################
fi

############################################################################################
# Stage 3: Orthology inference #############################################################
############################################################################################
if [ "${skip_stage1234}" != "TRUE" ] && [ "${skip_stage123}" != "TRUE" ]; then
  #################===========================================================================
  # 0.Preparation
  # (1) Function: Output information to log file
  stage3_info_main() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "${o}/00-logs_and_reports/logs/Stage3_Orthology_inference_${current_time}.log"
  }
  stage3_info() {
    local log_mode="$1"
    local message="$2"
    if [ "${log_mode}" = "full" ]; then
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $message" | tee -a "${o}/00-logs_and_reports/logs/Stage3_Orthology_inference_${current_time}.log"
    fi
  }
  stage3_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "${o}/00-logs_and_reports/logs/Stage3_Orthology_inference_${current_time}.log"
  }
  stage3_cmd_main() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [CMD] $1" | tee -a "${o}/00-logs_and_reports/logs/Stage3_Orthology_inference_${current_time}.log"
  }
  stage3_cmd() {
    local log_mode="$1"
    local message="$2"
    if [ "${log_mode}" = "cmd" ] || [ "${log_mode}" = "full" ]; then
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] [CMD] $message" >> "${o}/00-logs_and_reports/logs/HybSuite_cmd_${current_time}.log"
    fi
  }
  stage3_blank_main() {
    echo "$1" | tee -a "${o}/00-logs_and_reports/logs/Stage3_Orthology_inference_${current_time}.log"
  }
  stage3_blank() {
    local log_mode="$1"
    local message="$2"
    if [ "${log_mode}" = "full" ]; then
      echo "$message" | tee -a "${o}/00-logs_and_reports/logs/Stage3_Orthology_inference_${current_time}.log"
    fi
  }
  stage3_logfile="${o}/00-logs_and_reports/logs/Stage3_Orthology_inference_${current_time}.log"
  stage3_info_main "<<<======= Stage 3 Orthology inference =======>>>"
  #################===========================================================================

  ############################################################################################
  #Stage3-Optional method: HRS ###############################################################
  ############################################################################################
  if [ "${HRS}" = "TRUE" ]; then
    stage3_info_main "Running optional method: HRS ..."
    if [ -d "${o}/03-Orthology_inference/HRS/" ]; then
      rm -rf "${o}/03-Orthology_inference/HRS/"
    fi
    mkdir -p "${o}/03-Orthology_inference/HRS/"
    #################===========================================================================

    # 01-Retrieving sequences
    #################===========================================================================
    stage3_info_main "Step 1: Retrieving sequences by running 'hybpiper retrieve_sequences' ..."
    mkdir -p "${o}/03-Orthology_inference/HRS/01-Original_HRS_sequences/"
    #################===========================================================================
    stage3_cmd "${log_mode}" "hybpiper retrieve_sequences "-t_${hybpiper_tt}" ${t} dna --sample_names ${eas_dir}/Assembled_data_namelist.txt --fasta_dir ${o}/03-Orthology_inference/HRS/01-Original_HRS_sequences/"
    hybpiper retrieve_sequences "-t_${hybpiper_tt}" ${t} dna \
    --hybpiper_dir "${eas_dir}" \
    --sample_names ${eas_dir}/Assembled_data_namelist.txt \
    --fasta_dir ${o}/03-Orthology_inference/HRS/01-Original_HRS_sequences/ > /dev/null 2>&1
    if find "${o}/03-Orthology_inference/HRS/01-Original_HRS_sequences/" -type f -name "*.FNA" -size +0c | grep -q . 2>/dev/null; then
      stage3_info_main "Finish"
      stage3_blank "${log_mode}" ""
    else
      stage3_error "Fail to retrieve sequences by running 'hybpiper retrieve_sequences'."
      stage3_error "HybSuite exits."
      stage3_blank_main ""
      exit 1
    fi

    # Optional step-Adding other sequences
    #################===========================================================================
    if [ "${other_seqs}" != "_____" ]; then
      stage3_info_main "Optional step: Adding other sequences ..." 
      stage3_info_main "====>> Adding other sequences (HRS) (${process} in parallel) ====>>"
    #################=========================================================================== 
      # 01-Remove the existing single copy orthologs
      if ls ${o}/00-logs_and_reports/reports/Other_single_hit_seqs/*.fasta 1> /dev/null 2>&1; then
        rm ${o}/00-logs_and_reports/reports/Other_single_hit_seqs/*.fasta
      fi
      mkdir -p "${o}/00-logs_and_reports/reports/Other_single_hit_seqs/"

      cd "${other_seqs}"
      
      # 02-Create a species name list for the other single copy orthologs
      > "${o}/00-logs_and_reports/species_checklists/Other_seqs_Spname_list.txt"
      total_sps=$(ls *.fasta | wc -l)
      for fasta_file in *.fasta; do
        spname="${fasta_file%.fasta}"
        echo "${spname}" >> "${o}/00-logs_and_reports/species_checklists/Other_seqs_Spname_list.txt"
      done

      # 03-Initialize parallel environment
      init_parallel_env "$work_dir" "$total_sps" "$process" "${o}/00-logs_and_reports/species_checklists/Other_seqs_Spname_list.txt" || exit 1
      
      # 04-Run the main loop
      while IFS= read -r add_sp || [ -n "$add_sp" ]; do
        total_genes=$(awk 'END {print NR}' "${o}/00-logs_and_reports/reports/Ref_gene_name_list.txt")
        if [ "${process}" != "all" ]; then
          read -u1000
        fi
        {
          # Update start count
          update_start_count "$add_sp" "$stage3_logfile"
          while IFS= read -r add_gene || [ -n "$add_gene" ]; do
            sed -e "s|^.*[gene=${add_gene}].*$|>${add_gene} single_hit|g" "${file}" > "${add_sp}_${add_gene}_single_hit.fa"
            sed -e "s|>${add_gene}.*$|>${add_gene} single_hit|g" "${file}" > "${add_sp}_${add_gene}_single_hit.fa" 
            awk -v gene=">${add_gene} single_hit" '/^>/ {if (print_flag) print ""; print_flag=0} $0 ~ gene {print_flag=1} print_flag {print} END {if (print_flag) print ""}' \
            "${add_sp}_${add_gene}_single_hit.fa" >> "${o}/00-logs_and_reports/reports/Other_single_hit_seqs/${add_gene}.fasta"
            sed -i "s|${add_gene} |${add_sp} |g;/^$/d" "${o}/00-logs_and_reports/reports/Other_single_hit_seqs/${add_gene}.fasta" > /dev/null 2>&1
            awk -v gene=">${add_gene} single_hit" '/^>/ {if (print_flag) print ""; print_flag=0} $0 ~ gene {print_flag=1} print_flag {print} END {if (print_flag) print ""}' \
            "${add_sp}_${add_gene}_single_hit.fa" >> "${o}/03-Orthology_inference/HRS/01-Original_HRS_sequences/${add_gene}.FNA"
            sed -i "s|${add_gene} |${add_sp} |g;/^$/d" "${o}/03-Orthology_inference/HRS/01-Original_HRS_sequences/${add_gene}.FNA" > /dev/null 2>&1
          done < "${o}/00-logs_and_reports/reports/Ref_gene_name_list.txt"
          find . -type f -name "*.fa" -exec rm -f {} +
          # Update failed sample list
          if ! grep -q "${add_sp}" "${o}"/03-Orthology_inference/HRS/01-Original_HRS_sequences/*.FNA; then
            record_failed_sample "$add_sp"
            continue
          fi
          # Update finish count
          update_finish_count "$add_sp" "$stage3_logfile"
          if [ "${process}" != "all" ]; then
            echo >&1000
          fi
        } &
      done < "${o}/00-logs_and_reports/species_checklists/Other_seqs_Spname_list.txt"
      wait
      echo
      # Display processing log
      if [ "${log_mode}" = "full" ]; then
        display_process_log "$stage3_logfile" "stage3" "Failed to add other sequences:"
      fi
      stage3_blank_main ""

      # 05-Formatting the output paralogs
      cd "${o}"/03-Orthology_inference/HRS/01-Original_HRS_sequences/
      for file in *.FNA; do
        python "${script_dir}/Fasta_formatter.py" -i "${file}" -o "${file}" -nt "${nt}" --inter > /dev/null 2>&1
      done
    fi

    # 05-Filtering all HRS sequences by length, locus and sample coverage
    #################===========================================================================
    stage3_info_main "Step 2: Filtering all HRS sequences by length, locus and sample coverage ..." 
    mkdir -p "${o}/03-Orthology_inference/HRS/03-Filtered_HRS_sequences/" "${o}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/"
    #################===========================================================================

    # 01-Filtering out paralogs with low length
    stage3_info_main "01-Filtering out paralogs with low length..."
    stage3_cmd "${log_mode}" "python ${script_dir}/filter_seqs_by_length.py -i ${o}/03-Orthology_inference/HRS/01-Original_HRS_sequences/ -or ${o}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_HRS_seqs_with_low_length_info.tsv --output_dir ${o}/03-Orthology_inference/HRS/03-Filtered_HRS_sequences/ --ref ${t} --min_length ${min_length} --mean_length_ratio ${mean_length_ratio} --max_length_ratio ${max_length_ratio} --threads ${nt}"
    stage3_HRS_01="python ${script_dir}/filter_seqs_by_length.py \
    -i ${o}/03-Orthology_inference/HRS/01-Original_HRS_sequences/ \
    -or ${o}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_HRS_seqs_with_low_length_info.tsv \
    --output_dir ${o}/03-Orthology_inference/HRS/03-Filtered_HRS_sequences/ \
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

    if [ -s "${o}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_HRS_seqs_with_low_length_info.tsv" ]; then
      stage3_info "${log_mode}" "The information of filtered out HRS sequences with low length has been written to:"
      stage3_info "${log_mode}" "${o}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_HRS_seqs_with_low_length_info.tsv"
    else
      stage3_error "Fail to filter out HRS sequences with low length."
    fi

    # 02-Filtering out taxa with low locus coverage and loci with low sample coverage
    stage3_info_main "02-Filtering out taxa with low locus coverage and loci with low sample coverage..."
    stage3_cmd "${log_mode}" "python ${script_dir}/filter_seqs_by_sample_and_locus_coverage.py -i ${o}/03-Orthology_inference/HRS/03-Filtered_HRS_sequences/ --min_locus_coverage ${min_locus_coverage} --min_sample_coverage ${min_sample_coverage} --removed_samples_info ${o}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_samples_with_low_locus_coverage_info.tsv --removed_loci_info ${o}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_loci_with_low_sample_coverage_info.tsv --threads ${nt}"
    stage3_HRS_02="python ${script_dir}/filter_seqs_by_sample_and_locus_coverage.py \
    -i ${o}/03-Orthology_inference/HRS/03-Filtered_HRS_sequences/ \
    --min_locus_coverage ${min_locus_coverage} \
    --min_sample_coverage ${min_sample_coverage} \
    --removed_samples_info ${o}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_samples_with_low_locus_coverage_info.tsv \
    --removed_loci_info ${o}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_loci_with_low_sample_coverage_info.tsv \
    --threads ${nt}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage3_HRS_02}"
    else
      eval "${stage3_HRS_02} > /dev/null 2>&1"
    fi

    if [ -s "${o}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_samples_with_low_locus_coverage_info.tsv" ]; then
      stage3_info "${log_mode}" "The information of filtered out taxa with low locus coverage has been written to:"
      stage3_info "${log_mode}" "${o}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_samples_with_low_locus_coverage_info.tsv"
    else
      stage3_error "Fail to filter out taxa with low locus coverage."
    fi
    if [ -s "${o}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_loci_with_low_sample_coverage_info.tsv" ]; then
      stage3_info "${log_mode}" "The information of filtered out loci with low sample coverage has been written to:"
      stage3_info "${log_mode}" "${o}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_out_loci_with_low_sample_coverage_info.tsv"
    else
      stage3_error "Fail to filter out loci with low sample coverage."
    fi
    stage3_info_main "Finish"
    stage3_blank "${log_mode}" ""

    # 01-Retrieving sequences
    #################===========================================================================
    stage3_info_main "Step 3: Getting the reports and heatmap ..."
    mkdir -p "${o}/03-Orthology_inference/HRS/02-Original_HRS_sequences_reports_and_heatmap/"
    #################===========================================================================
    # 01-Getting the reports and heatmap of the original HRS sequences
    stage3_info_main "01-Getting the reports and heatmap of the original HRS sequences..."
    stage3_cmd "${log_mode}" "python "${script_dir}/plot_recovery_heatmap.py" -i "${o}/03-Orthology_inference/HRS/01-Original_HRS_sequences/" -r "${t}" -osl "${o}/03-Orthology_inference/HRS/02-Original_HRS_sequences_reports_and_heatmap/Original_HRS_seq_lengths.tsv" -oh "${o}/03-Orthology_inference/HRS/02-Original_HRS_sequences_reports_and_heatmap/Original_HRS_heatmap" --threads "${nt}" --show_values --color "${heatmap_color}""
    stage3_HRS_03="python ${script_dir}/plot_recovery_heatmap.py \
    -i ${o}/03-Orthology_inference/HRS/01-Original_HRS_sequences/ \
    -r ${t} \
    -osl ${o}/03-Orthology_inference/HRS/02-Original_HRS_sequences_reports_and_heatmap/Original_HRS_seq_lengths.tsv \
    -oh ${o}/03-Orthology_inference/HRS/02-Original_HRS_sequences_reports_and_heatmap/Original_HRS_heatmap \
    --threads ${nt} \
    --color ${heatmap_color}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage3_HRS_03}"
    else
      eval "${stage3_HRS_03} > /dev/null 2>&1"
    fi

    if [ -s "${o}/03-Orthology_inference/HRS/02-Original_HRS_sequences_reports_and_heatmap/Original_HRS_heatmap.png" ]; then
      stage3_info "${log_mode}" "The reports and heatmap of the original HRS sequences have been written to:"
      stage3_info "${log_mode}" "${o}/03-Orthology_inference/HRS/02-Original_HRS_sequences_reports_and_heatmap/"
    else
      stage3_error "Fail to get the reports and heatmap of the original HRS sequences."
    fi

    # 02-Getting the reports and heatmap of the filtered HRS sequences
    stage3_info_main "02-Getting the reports and heatmap of the filtered HRS sequences..."
    stage3_cmd "${log_mode}" "python ${script_dir}/plot_recovery_heatmap.py -i ${o}/03-Orthology_inference/HRS/03-Filtered_HRS_sequences/ -r ${t} -osl ${o}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_HRS_seq_lengths.tsv -oh ${o}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_HRS_heatmap --threads ${nt} --show_values --color ${heatmap_color}"
    stage3_HRS_04="python ${script_dir}/plot_recovery_heatmap.py \
    -i ${o}/03-Orthology_inference/HRS/03-Filtered_HRS_sequences/ \
    -r ${t} \
    -osl ${o}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_HRS_seq_lengths.tsv \
    -oh ${o}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_HRS_heatmap \
    --threads ${nt} \
    --color ${heatmap_color}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage3_HRS_04}"
    else
      eval "${stage3_HRS_04} > /dev/null 2>&1"
    fi
    
    if [ -s "${o}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/Filtered_HRS_heatmap.png" ]; then
      stage3_info "${log_mode}" "The reports and heatmap of the filtered HRS sequences have been written to:"
      stage3_info "${log_mode}" "${o}/03-Orthology_inference/HRS/04-Filtered_HRS_sequences_reports_and_heatmap/"
    else
      stage3_error "Fail to get the reports and heatmap of the filtered HRS sequences."
    fi

    stage3_info_main "Congratulations! Finish producing HRS sequences in ${o}/03-Orthology_inference/HRS/03-Filtered_HRS_sequences/"
    stage3_blank_main ""
  fi

  ############################################################################################
  #Stage3-Optional method: RLWP ##############################################################
  ############################################################################################
  if [ "${RLWP}" = "TRUE" ]; then
    #################===========================================================================
    stage3_info_main "Running optional method: RLWP ..."
    if [ -d "${o}/03-Orthology_inference/RLWP/" ]; then
      rm -rf "${o}/03-Orthology_inference/RLWP/"
    fi
    mkdir -p "${o}/03-Orthology_inference/RLWP/"
    #################===========================================================================

    # 01-Retrieving sequences
    #################===========================================================================
    stage3_info_main "Step 1: Retrieving sequences by running 'hybpiper retrieve_sequences' ..."
    mkdir -p "${o}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/"
    #################===========================================================================
    stage3_cmd "${log_mode}" "hybpiper retrieve_sequences "-t_${hybpiper_tt}" ${t} dna --sample_names ${eas_dir}/Assembled_data_namelist.txt --fasta_dir ${o}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/"
    hybpiper retrieve_sequences "-t_${hybpiper_tt}" ${t} dna \
    --hybpiper_dir "${eas_dir}" \
    --sample_names ${eas_dir}/Assembled_data_namelist.txt \
    --fasta_dir ${o}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/ > /dev/null 2>&1
    if find "${o}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/" -type f -name "*.FNA" -size +0c | grep -q . 2>/dev/null; then
      stage3_info "${log_mode}" "Successfully retrieving sequences by running 'hybpiper retrieve_sequences'. "
      stage3_blank "${log_mode}" ""
    else
      stage3_error "Fail to retrieve sequences by running 'hybpiper retrieve_sequences'."
      stage3_error "HybSuite exits."
      stage3_blank_main ""
      exit 1
    fi

    # Optional step-Adding other sequences
    #################===========================================================================
    if [ "${other_seqs}" != "_____" ]; then
      stage3_blank_main ""
      stage3_info_main "Optional step: Adding other sequences ..." 
      stage3_info_main "====>> Adding other sequences (RLWP) (${process} in parallel) ====>>"
    #################=========================================================================== 
      # 01-Remove the existing single copy orthologs
      if ls ${o}/00-logs_and_reports/reports/Other_single_hit_seqs/*.fasta 1> /dev/null 2>&1; then
        rm ${o}/00-logs_and_reports/reports/Other_single_hit_seqs/*.fasta
      fi
      mkdir -p ${o}/00-logs_and_reports/reports/Other_single_hit_seqs/

      cd "${other_seqs}"
      
      # 02-Create a species name list for the other single copy orthologs
      > ${o}/00-logs_and_reports/species_checklists/Other_seqs_Spname_list.txt
      total_sps=$(ls *.fasta | wc -l)
      for fasta_file in *.fasta; do
        spname="${fasta_file%.fasta}"
        echo "${spname}" >> ${o}/00-logs_and_reports/species_checklists/Other_seqs_Spname_list.txt
      done

      # 03-Initialize parallel environment
      init_parallel_env "$work_dir" "$total_sps" "$process" "${o}/00-logs_and_reports/species_checklists/Other_seqs_Spname_list.txt" || exit 1
      
      # 04-Run the main loop
      while IFS= read -r add_sp || [ -n "$add_sp" ]; do
        total_genes=$(awk 'END {print NR}' "${o}/00-logs_and_reports/reports/Ref_gene_name_list.txt")
        if [ "${process}" != "all" ]; then
          read -u1000
        fi
        {
          # Update start count
          update_start_count "$add_sp" "$stage3_logfile"
          while IFS= read -r add_gene || [ -n "$add_gene" ]; do
            sed -e "s|^.*[gene=${add_gene}].*$|>${add_gene} single_hit|g" "${file}" > "${add_sp}_${add_gene}_single_hit.fa"
            sed -e "s|>${add_gene}.*$|>${add_gene} single_hit|g" "${file}" > "${add_sp}_${add_gene}_single_hit.fa" 
            awk -v gene=">${add_gene} single_hit" '/^>/ {if (print_flag) print ""; print_flag=0} $0 ~ gene {print_flag=1} print_flag {print} END {if (print_flag) print ""}' \
            "${add_sp}_${add_gene}_single_hit.fa" >> "${o}/00-logs_and_reports/reports/Other_single_hit_seqs/${add_gene}.fasta"
            sed -i "s|${add_gene} |${add_sp} |g;/^$/d" "${o}/00-logs_and_reports/reports/Other_single_hit_seqs/${add_gene}.fasta" > /dev/null 2>&1
            awk -v gene=">${add_gene} single_hit" '/^>/ {if (print_flag) print ""; print_flag=0} $0 ~ gene {print_flag=1} print_flag {print} END {if (print_flag) print ""}' \
            "${add_sp}_${add_gene}_single_hit.fa" >> "${o}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/${add_gene}.fasta"
            sed -i "s|${add_gene} |${add_sp} |g;/^$/d" "${o}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/${add_gene}.fasta" > /dev/null 2>&1
          done < "${o}/00-logs_and_reports/reports/Ref_gene_name_list.txt"
          find . -type f -name "*.fa" -exec rm -f {} +
          # Update failed sample list
          if ! grep -q "${add_sp}" "${o}"/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/*.FNA; then
            record_failed_sample "$add_sp"
            continue
          fi
          # Update finish count
          update_finish_count "$add_sp" "$stage3_logfile"
          if [ "${process}" != "all" ]; then
            echo >&1000
          fi
        } &
      done < "${o}/00-logs_and_reports/species_checklists/Other_seqs_Spname_list.txt"
      wait
      echo
      # Display processing log
      if [ "${log_mode}" = "full" ]; then
        display_process_log "$stage3_logfile" "stage3" "Failed to add other sequences:"
      fi
      stage3_blank "${log_mode}" ""

      # 05-Formatting the output sequences
      cd "${o}"/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/
      for file in *.FNA; do
        python "${script_dir}/Fasta_formatter.py" -i "${file}" -o "${file}" -nt "${nt}" --inter > /dev/null 2>&1
      done
    fi

    # 02-Removing loci with paralogues (RLWP)
    stage3_info_main "Step 2: Removing loci with paralogues (RLWP) via RLWP.py ..."
    mkdir -p "${o}/03-Orthology_inference/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/"
    stage3_cmd "${log_mode}" "python ${script_dir}/RLWP.py -i ${o}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/ -p ${o}/02-All_paralogs/02-Original_paralog_reports_and_heatmap/Original_paralog_report.tsv -s ${RLWP_samples_threshold} -or ${o}/03-Orthology_inference/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/RLWP_removed_loci_info.tsv --threads ${nt}"
    stage3_RLWP_1="python ${script_dir}/RLWP.py \
    -i ${o}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/ \
    -p ${o}/02-All_paralogs/02-Original_paralog_reports_and_heatmap/Original_paralog_report.tsv \
    -s ${RLWP_samples_threshold} \
    -or ${o}/03-Orthology_inference/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/RLWP_removed_loci_info.tsv \
    --threads ${nt}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage3_RLWP_1}"
    else
      eval "${stage3_RLWP_1} > /dev/null 2>&1"
    fi
    stage3_blank "${log_mode}" ""

    # 03-Filtering out RLWP sequences with low length, sample and locus coverage
    stage3_info_main "Step 3: Filtering out RLWP sequences with low length, sample and locus coverage..."
    mkdir -p "${o}/03-Orthology_inference/RLWP/03-Filtered_RLWP_sequences/" "${o}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/"

    stage3_info_main "01-Filtering out RLWP sequences with low length ..."
    stage3_cmd "${log_mode}" "python "${script_dir}/filter_seqs_by_length.py" -i "${o}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/" --output_report "${o}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_out_RLWP_seqs_with_low_length_info.tsv" --output_dir "${o}/03-Orthology_inference/RLWP/03-Filtered_RLWP_sequences/" --ref "${t}" --min_length "${min_length}" --mean_length_ratio "${mean_length_ratio}" --max_length_ratio "${max_length_ratio}" --threads "${nt}""
    stage3_RLWP_2="python ${script_dir}/filter_seqs_by_length.py \
    -i ${o}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/ \
    --output_report ${o}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_out_RLWP_seqs_with_low_length_info.tsv \
    --output_dir ${o}/03-Orthology_inference/RLWP/03-Filtered_RLWP_sequences/ \
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
    stage3_blank "${log_mode}" ""
    
    # 04-Filtering out taxa with low locus coverage and loci with low sample coverage
    stage3_info_main "02-Filtering out taxa with low sample and loci with low sample coverage ..."
    stage3_cmd "${log_mode}" "python "${script_dir}/filter_seqs_by_sample_and_locus_coverage.py" -i "${o}/03-Orthology_inference/RLWP/03-Filtered_RLWP_sequences/" --min_locus_coverage "${min_locus_coverage}" --min_sample_coverage "${min_sample_coverage}" --removed_samples_info "${o}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_out_samples_with_low_locus_coverage_info.tsv" --removed_loci_info "${o}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_out_loci_with_low_sample_coverage_info.tsv" --threads "${nt}""
    stage3_RLWP_3="python ${script_dir}/filter_seqs_by_sample_and_locus_coverage.py \
    -i ${o}/03-Orthology_inference/RLWP/03-Filtered_RLWP_sequences/ \
    --min_locus_coverage ${min_locus_coverage} \
    --min_sample_coverage ${min_sample_coverage} \
    --removed_samples_info ${o}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_out_samples_with_low_locus_coverage_info.tsv \
    --removed_loci_info ${o}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_out_loci_with_low_sample_coverage_info.tsv \
    --threads ${nt}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage3_RLWP_3}"
    else
      eval "${stage3_RLWP_3} > /dev/null 2>&1"
    fi
    stage3_blank "${log_mode}" ""

    # 05-Plotting the recovery heatmap
    #################===========================================================================
    stage3_info_main "Step 4: Plotting the recovery heatmap ..."

    # plot the recovery heatmap for original RLWP sequences
    stage3_info_main "01-Plotting the recovery heatmap for original RLWP sequences ..."
    stage3_cmd "${log_mode}" "python ${script_dir}/plot_recovery_heatmap.py -i ${o}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/ -r ${t} --output_heatmap ${o}/03-Orthology_inference/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/Original_RLWP_seqs_recovery_heatmap --output_seq_lengths ${o}/03-Orthology_inference/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/Original_RLWP_seqs_lengths.tsv --threads ${nt} --color ${heatmap_color}"
    stage3_RLWP_4="python ${script_dir}/plot_recovery_heatmap.py \
    -i ${o}/03-Orthology_inference/RLWP/01-Original_RLWP_sequences/ \
    -r ${t} \
    --output_heatmap ${o}/03-Orthology_inference/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/Original_RLWP_seqs_recovery_heatmap \
    --output_seq_lengths ${o}/03-Orthology_inference/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/Original_RLWP_seqs_lengths.tsv \
    --threads ${nt} \
    --color ${heatmap_color}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage3_RLWP_4}"
    else
      eval "${stage3_RLWP_4} > /dev/null 2>&1"
    fi
    if [ -s "${o}/03-Orthology_inference/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/Original_RLWP_seqs_lengths.tsv" ] && [ -s "${o}/03-Orthology_inference/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/Original_RLWP_seqs_recovery_heatmap.png" ]; then
      stage3_info "${log_mode}" "The recovery heatmap of original RLWP sequences has been written to: ${o}/03-Orthology_inference/RLWP/02-Original_RLWP_sequences_reports_and_heatmap/Original_RLWP_seqs_recovery_heatmap.png"
    else
      stage3_error "Fail to plot the recovery heatmap of original RLWP sequences."
    fi

    # plot the recovery heatmap for filtered RLWP sequences
    stage3_info_main "02-Plotting the recovery heatmap for filtered RLWP sequences ..."
    stage3_cmd "${log_mode}" "python ${script_dir}/plot_recovery_heatmap.py -i ${o}/03-Orthology_inference/RLWP/03-Filtered_RLWP_sequences/ -r ${t} --output_heatmap ${o}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_RLWP_seqs_recovery_heatmap --output_seq_lengths ${o}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_RLWP_seqs_lengths.tsv --threads ${nt} --color ${heatmap_color}"
    
    stage3_RLWP_5="python ${script_dir}/plot_recovery_heatmap.py \
    -i ${o}/03-Orthology_inference/RLWP/03-Filtered_RLWP_sequences/ \
    -r ${t} \
    --output_heatmap ${o}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_RLWP_seqs_recovery_heatmap \
    --output_seq_lengths ${o}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_RLWP_seqs_lengths.tsv \
    --threads ${nt} \
    --color ${heatmap_color}"
    if [ "${log_mode}" = "full" ]; then
      eval "${stage3_RLWP_5}"
    else
      eval "${stage3_RLWP_5} > /dev/null 2>&1"
    fi
    if [ -s "${o}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_RLWP_seqs_lengths.tsv" ] && [ -s "${o}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_RLWP_seqs_recovery_heatmap.png" ]; then
      stage3_info "${log_mode}" "The recovery heatmap of filtered RLWP sequences has been written to: ${o}/03-Orthology_inference/RLWP/04-Filtered_RLWP_sequences_reports_and_heatmap/Filtered_RLWP_seqs_recovery_heatmap.png"
    else
      stage3_error "Fail to plot the recovery heatmap of filtered RLWP sequences."
    fi

    stage3_info_main "Congratulations! Finish producing RLWP sequences in ${o}/03-Orthology_inference/RLWP/03-Filtered_RLWP_sequences/"
    stage3_blank_main ""
  fi

  ############################################################################################
  #Stage3-Optional method: LS/MI/MO/RT/1to1 for PhyloPyPruner ################################
  ############################################################################################
  run_mafft() {
      local input=$1
      local output=$2
      local algorithm=$3
      local adjustdirection=$4
      local threads=$5
      local mafft_cmd
      
      case "${algorithm}" in
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
              stage3_error "Unknown MAFFT algorithm: ${algorithm}"
              return 1
              ;;
      esac

      mafft_cmd="${mafft_cmd} --quiet"
      mafft_cmd="${mafft_cmd} --thread ${threads}"

      if [ "${algorithm}" = "linsi" ] && [ "${adjustdirection}" = "TRUE" ]; then
          mafft_cmd="${mafft_cmd} --adjustdirectionaccurately"
      fi

      mafft_cmd="${mafft_cmd} ${input} > ${output}"

      eval "${mafft_cmd}" 2>/dev/null

      if [ -s "${output}" ]; then
          return 0
      else
          stage3_error "MAFFT alignment failed"
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
              stage3_error "Invalid trimal mode: ${trimal_mode}. Please choose from nogaps, noallgaps, gappyout, strict, strictplus, automated1."
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

  #4. phylopypruner (optional)
  if [ "$LS" = "TRUE" ] || { ([ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "${one_to_one}" = "TRUE" ]) && [ "${run_phylopypruner}" = "TRUE" ]; }; then
    if [ -d "${o}/03-Orthology_inference/PhyloPyPruner/" ]; then
      rm -r "${o}/03-Orthology_inference/PhyloPyPruner/"
    fi
    mkdir -p "${o}"/03-Orthology_inference/PhyloPyPruner/Input
    cd ${o}/03-Orthology_inference/PhyloPyPruner/Input
    cp ${o}/02-All_paralogs/03-Filtered_paralogs/*.fasta ${o}/03-Orthology_inference/PhyloPyPruner/Input
    stage3_info_main "Optional step: LS/MI/MO/RT/1to1 for PhyloPyPruner"
    stage3_info_main "01-Preparing fasta files and single gene trees for PhyloPyPruner"
    # 1.MAFFT and TrimAl
    define_threads "mafft" "${stage3_logfile}"
    define_threads "trimal" "${stage3_logfile}"
    temp_file="fasta_file_list.txt"
    find . -maxdepth 1 -type f -name "*.fasta" -exec basename {} \; > "$temp_file"
    total_sps=$(find . -maxdepth 1 -type f -name "*.fasta" | wc -l)
    # Initialize parallel environment
    init_parallel_env "$work_dir" "$total_sps" "$process" "${temp_file}" || exit 1
    stage3_info_main "====>> Running MAFFT and TrimAl for ${total_sps} paralog files (${process} in parallel) ====>>"
    while IFS= read -r file || [ -n "$file" ]; do
      filename=${file%.fasta}
      genename=${file%_paralogs_all.fasta}
      if [ "${process}" != "all" ]; then
        read -u1000
      fi
      {
        # Update start count
        update_start_count "$genename" "$stage3_logfile"
        #grep '>' "${file}"|sed 's/>//g' > ${genename}_sqlist.txt
        #awk -F' ' '{print $1}' ${genename}_sqlist.txt > ${genename}_splist.txt
        #awk '{print $0 "\t" NR}' ${genename}_splist.txt > ${genename}_sp_id_list.txt
        sed -i "s/ single_hit/@single_hit/g;s/ multi/@multi/g;s/ NODE_/@NODE_/g;s/\.[0-9]\+@NODE_/@NODE_/g;s/\.main@NODE_/@NODE_/g" "${file}"
        # Run MAFFT
        run_mafft "${file}" "${filename}.aln.fasta" "${mafft_algorithm}" "${mafft_adjustdirection}" "${nt_mafft}"
        run_trimal "./${filename}.aln.fasta" "./${filename}.trimmed.aln.fasta" "${trimal_mode}" \
        "${trimal_gapthreshold}" "${trimal_simthreshold}" "${trimal_cons}" "${trimal_block}" "${trimal_resoverlap}" "${trimal_seqoverlap}" \
        "${trimal_w}" "${trimal_gw}" "${trimal_sw}"
        FastTree -nt -gamma "./${filename}.trimmed.aln.fasta" > "./${filename}.trimmed.aln.fasta.tre" 2>/dev/null
        rm "${file}" "${filename}.aln.fasta"
        # Update failed count
        if [ ! -s "./${filename}.trimmed.aln.fasta" ] || [ ! -s "./${filename}.trimmed.aln.fasta.tre" ]; then
          record_failed_sample "$genename"
          continue
        fi
        # Update finish count
        update_finish_count "$genename" "$stage3_logfile"
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
      display_process_log "$stage3_logfile" "stage3" "Failed to run MAFFT for paralog files:"
    fi
    stage3_blank_main ""
    if ! find ./ -type f -name '*trimmed.aln.fasta' -size +0c | grep -q . >/dev/null; then
      stage3_error "Fail to run MAFFT and TrimAl."
      stage3_error "HybSuite exits."
      stage3_blank_main ""
      exit 1
    fi
    if ! find ./ -type f -name '*trimmed.aln.fasta.tre' -size +0c | grep -q . >/dev/null; then
      stage3_error "Fail to run FastTree."
      stage3_error "HybSuite exits."
      stage3_blank_main ""
      exit 1
    fi

    define_threads "phylopypruner" "${stage3_logfile}"
    
    # Define the function to run PhyloPyPruner
    run_phylopypruner() {
        local method=$1
        local output_dir=$2
        local threads=$3
        local input_dir=$4
        local trim_lb=$5
        local min_taxa=$6
        local min_len=$7
        if [ "${method}" = "MO" ] || [ "${method}" = "RT" ]; then
          local outgroup=$8
        fi

        stage3_info_main "Running PhyloPyPruner via ${method} algorithum ..."
        
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
            stage3_cmd "${log_mode}" "${base_cmd}"
        else
            # Log the command without outgroup
            stage3_cmd "${log_mode}" "${base_cmd}"
        fi

        # Execute the command
        eval "${base_cmd}" > /dev/null 2>&1

        # Move the output files
        mv "${input_dir}/PhyloPyPruner/phylopypruner_output/" "${input_dir}/PhyloPyPruner/${output_dir}/"
        sed -i "s/@.*$//g" "${input_dir}/PhyloPyPruner/${output_dir}/output_alignments/"*.fasta

        # Check the running result
        if [ "$(ls -A "${input_dir}/PhyloPyPruner/${output_dir}/output_alignments")" ]; then
            stage3_info "${log_mode}" "Successfully finishing running PhyloPyPruner for ${method}."
            return 0
        else
            stage3_error "Fail to run PhyloPyPruner for ${method}."
            stage3_error "HybSuite exits."
            stage3_blank_main ""
            exit 1
        fi
    }

    # Run PhyloPyPruner for LS
    if [ "${LS}" = "TRUE" ]; then
        run_phylopypruner "LS" "Output_LS" "${nt_phylopypruner}" "${o}/03-Orthology_inference" "${pp_trim_lb}" "${pp_min_taxa}" "${min_length}" || exit 1
    fi

    # Run PhyloPyPruner for MI
    if [ "${MI}" = "TRUE" ]; then
        run_phylopypruner "MI" "Output_MI" "${nt_phylopypruner}" "${o}/03-Orthology_inference" "${pp_trim_lb}" "${pp_min_taxa}" "${min_length}" || exit 1
    fi

    # Run PhyloPyPruner for MO
    if [ "${MO}" = "TRUE" ]; then
        run_phylopypruner "MO" "Output_MO" "${nt_phylopypruner}" "${o}/03-Orthology_inference" "${pp_trim_lb}" "${pp_min_taxa}" "${min_length}" "${i}/Outgroup.txt" || exit 1
    fi

    # Run PhyloPyPruner for RT
    if [ "${RT}" = "TRUE" ]; then
        run_phylopypruner "RT" "Output_RT" "${nt_phylopypruner}" "${o}/03-Orthology_inference" "${pp_trim_lb}" "${pp_min_taxa}" "${min_length}" "${i}/Outgroup.txt" || exit 1
    fi
    
    # Run PhyloPyPruner for 1to1
    if [ "${one_to_one}" = "TRUE" ]; then
        run_phylopypruner "1to1" "Output_1to1" "${nt_phylopypruner}" "${o}/03-Orthology_inference" "${pp_trim_lb}" "${pp_min_taxa}" "${min_length}" || exit 1
    fi
  fi

  ############################################################################################
  #Stage3-Optional method: MO/MI/RT/1to1 for ParaGone ########################################
  ############################################################################################
  #ParaGone (optional)
  if ([ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "${one_to_one}" = "TRUE" ]) && [ "${run_paragone}" = "TRUE" ]; then
    stage3_blank "${log_mode}" ""
    stage3_info "${log_mode}" "Optional Part: Run ParaGone (MO/MI/RT/1to1) ... "
    
    #Preparation: conda
    stage3_info "${log_mode}" "Preparation: Activate conda environment ${conda2}"
    conda_activate "stage3" "${conda2}"
    
    # Preparation: remove existed files
    if [ -d "${o}/03-Orthology_inference/ParaGone" ]; then
      rm -rf "${o}/03-Orthology_inference/ParaGone"
    fi
    # Preparation: Directories and reminders
    mkdir -p ${o}/03-Orthology_inference/ParaGone
    # Preparation: Outgroup processing
    cd ${o}/03-Orthology_inference/ParaGone
    outgroup_args=""
    while IFS= read -r line || [ -n "$line" ]; do
      outgroup_args="$outgroup_args --internal_outgroup $line"
    done < ${i}/Outgroup.txt
    # Preparation: change species names to correct ones for running ParaGone 
    for file in "${o}/02-All_paralogs/03-Filtered_paralogs/"*; do
      sed -i "s/_var\._/_var_/g"  "${file}"
      sed -i "s/_subsp\._/_subsp_/g" "${file}"
      sed -i "s/_f\._/_f_/g" "${file}"
    done

    # Define threads
    define_threads "paragone" "${stage3_logfile}"

    # ParaGone fullpipeline
    run_paragone() {
      local input_dir=$1
      local paragone_pool=$2
      local nt_paragone=$3
      local outgroup_args=$4
      local paragone_treeshrink_q_value=$5
      local paragone_cutoff_value=$6
      local paragone_minimum_taxa=$7
      local paragone_min_tips=$8
      local MO=$9
      local MI=$10
      local RT=$11
      local one_to_one=$12
      local oi_tree=$13
      local mafft_algorithm=$14
      local trimal_mode=$15
      local trimal_gapthreshold=$16
      local trimal_simthreshold=$17
      local trimal_cons=$18
      local trimal_resoverlap=$19
      local trimal_seqoverlap=$20
      local trimal_w=$21
      local trimal_gw=$22
      local trimal_sw=$23
      
      stage3_blank "${log_mode}" ""
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

      paragone_cmd="paragone full_pipeline "${input_dir}"${outgroup_args} --pool ${paragone_pool} --threads ${nt_paragone} --treeshrink_q_value ${paragone_treeshrink_q_value} --cut_deep_paralogs_internal_branch_length_cutoff ${paragone_cutoff_value} --minimum_taxa ${paragone_minimum_taxa} --min_tips ${paragone_min_tips} --keep_intermediate_files --mafft_algorithm ${mafft_algorithm} --trimal_${trimal_mode}"

      if [ "${oi_tree}" = "fasttree" ]; then
        paragone_cmd="${paragone_cmd} --use_fasttree"
      fi
      if [ "${MO}" = "TRUE" ] || [ "${one_to_one}" = "TRUE" ]; then
        paragone_cmd="${paragone_cmd} --mo"
      fi
      if [ "${MI}" = "TRUE" ]; then
        paragone_cmd="${paragone_cmd} --mi"
      fi
      if [ "${RT}" = "TRUE" ]; then
        paragone_cmd="${paragone_cmd} --rt"
      fi
      if [ "${trimal_gapthreshold}" != "_____" ]; then
        paragone_cmd="${paragone_cmd} --trimal_gapthreshold ${trimal_gapthreshold}"
      fi
      if [ "${trimal_simthreshold}" != "_____" ]; then
        paragone_cmd="${paragone_cmd} --trimal_simthreshold ${trimal_simthreshold}"
      fi  
      if [ "${trimal_cons}" != "_____" ]; then
        paragone_cmd="${paragone_cmd} --trimal_cons ${trimal_cons}"
      fi
      if [ "${trimal_resoverlap}" != "_____" ]; then
        paragone_cmd="${paragone_cmd} --trimal_resoverlap ${trimal_resoverlap}"
      fi  
      if [ "${trimal_seqoverlap}" != "_____" ]; then
        paragone_cmd="${paragone_cmd} --trimal_seqoverlap ${trimal_seqoverlap}"
      fi
      if [ "${trimal_w}" != "_____" ]; then
        paragone_cmd="${paragone_cmd} --trimal_w ${trimal_w}"
      fi  
      if [ "${trimal_gw}" != "_____" ]; then
        paragone_cmd="${paragone_cmd} --trimal_gw ${trimal_gw}"
      fi  
      if [ "${trimal_sw}" != "_____" ]; then
        paragone_cmd="${paragone_cmd} --trimal_sw ${trimal_sw}"
      fi  
      
      stage3_cmd "${log_mode}" "${paragone_cmd}"
      eval "${paragone_cmd}" > /dev/null 2>&1

      if [ "${one_to_one}" = "TRUE" ]; then
        if [ ! -d "${o}/03-Orthology_inference/ParaGone/26_MO_final_alignments_trimmed" ]; then
          stage3_error "Fail to run ParaGone with MO method."
          stage3_error "HybSuite exits."
          stage3_blank_main ""
          exit 1
        fi
        cd ./26_MO_final_alignments_trimmed
        mkdir -p ../HybSuite_1to1_final_alignments_trimmed
        files=$(find . -maxdepth 1 -type f -name "*1to1*")
        total_sps=$(find . -maxdepth 1 -type f -name "*1to1*" | wc -l)
        j=0
        stage3_info_main "====>> Extracting 1to1 alignments ====>>"
        for file in $files; do
          j=$((j + 1 ))
          cp "$file" "../HybSuite_1to1_final_alignments_trimmed"
          progress=$((j * 100 / total_sps))
          printf "\r[$(date +%Y-%m-%d\ %H:%M:%S)] [INFO] Extracting 1to1 alignments: ${j}/${total_sps} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress"
        done
        echo
        for file in "${o}/03-Orthology_inference/ParaGone/HybSuite_1to1_final_alignments_trimmed/"*; do
          sed -i "s/_var_/_var\._/g"  "${file}"
          sed -i "s/_subsp_/_subsp\._/g" "${file}"
          sed -i "s/_f_/_f\._/g" "${file}"
        done
      fi
      if [ "${MO}" = "TRUE" ]; then
        if [ ! -d "${o}/03-Orthology_inference/ParaGone/26_MO_final_alignments_trimmed" ]; then
          stage3_error "Fail to run ParaGone with MO method."
          stage3_error "HybSuite exits."
          stage3_blank_main ""
          exit 1
        fi
        for file in ${o}/03-Orthology_inference/ParaGone/26_MO_final_alignments_trimmed/*; do
          sed -i "s/_var_/_var\._/g"  "${file}"
          sed -i "s/_subsp_/_subsp\._/g" "${file}"
          sed -i "s/_f_/_f\._/g" "${file}"
        done
      fi
      if [ "${MI}" = "TRUE" ]; then
        if [ ! -d "${o}/03-Orthology_inference/ParaGone/27_MI_final_alignments_trimmed" ]; then
          stage3_error "Fail to run ParaGone with MI method."
          stage3_error "HybSuite exits."
          stage3_blank_main ""
          exit 1
        fi
        for file in ${o}/03-Orthology_inference/ParaGone/27_MI_final_alignments_trimmed/*; do
          sed -i "s/_var_/_var\._/g"  "${file}"
          sed -i "s/_subsp_/_subsp\._/g" "${file}"
          sed -i "s/_f_/_f\._/g" "${file}"
        done
      fi
      if [ "${RT}" = "TRUE" ]; then
        if [ ! -d "${o}/03-Orthology_inference/ParaGone/28_RT_final_alignments_trimmed" ]; then
          stage3_error "Fail to run ParaGone with RT method."
          stage3_error "HybSuite exits."
          stage3_blank "${log_mode}" ""
          exit 1
        fi
        for file in ${o}/03-Orthology_inference/ParaGone/28_RT_final_alignments_trimmed/*; do
          sed -i "s/_var_/_var\._/g"  "${file}"
          sed -i "s/_subsp_/_subsp\._/g" "${file}"
          sed -i "s/_f_/_f\._/g" "${file}"
        done
      fi
    }
    
    cd "${o}/03-Orthology_inference/ParaGone"
    run_paragone "${o}/02-All_paralogs/03-Filtered_paralogs" "${paragone_pool}" "${nt_paragone}" \
    "${outgroup_args}" "${paragone_treeshrink_q_value}" "${paragone_cutoff_value}" "${paragone_minimum_taxa}" "${paragone_min_tips}" \
    "${MO}" "${MI}" "${RT}" "${one_to_one}" "${oi_tree}" "${mafft_algorithm}" "${trimal_mode}" "${trimal_gapthreshold}" "${trimal_simthreshold}" "${trimal_cons}" "${trimal_resoverlap}" "${trimal_seqoverlap}" "${trimal_w}" "${trimal_gw}" "${trimal_sw}"
  fi

  ############################################################################################
  # End of Stage 3
  stage3_info_main "Successfully finishing the stage3: 'Orthology inference'."
  stage3_info_main "The resulting files have been saved in ${o}/03-Orthology_inference/"

  if [ "${run_to_stage3}" = "true" ]; then
    # Clean up environment
    cleanup_parallel_env "$work_dir"
    stage3_info_main "You set '--run_to_stage3' to specify HybSuite to run only stage 3."
    stage3_info_main "Consequently, HybSuite will stop and exit right now."
    stage3_info_main "Thank you for using HybSuite! Enjoy your research!"
    stage3_blank_main ""
    exit 1
  else
    stage3_info "${log_mode}" "Moving on to the next stage..."
    stage3_blank_main ""
  fi
  ############################################################################################
fi

############################################################################################
# Stage 4: Sequence Alignment, Trimming, and Supermatrix Construction ######################
############################################################################################
if [ "${skip_stage1234}" != "TRUE" ]; then
  #################===========================================================================
  # 0.Preparation
  # (1) Function: Output information to log file
  stage4_info_main() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "${o}/00-logs_and_reports/logs/Stage4_Sequence_alignment_trimming_and_supermatrix_construction_${current_time}.log"
  }
  stage4_blank_main() {
    echo "$1" | tee -a "${o}/00-logs_and_reports/logs/Stage4_Sequence_alignment_trimming_and_supermatrix_construction_${current_time}.log"
  }
  stage4_info() {
    local log_mode="$1"
    local message="$2"
    if [ "${log_mode}" = "full" ]; then
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $message" | tee -a "${o}/00-logs_and_reports/logs/Stage4_Sequence_alignment_trimming_and_supermatrix_construction_${current_time}.log"
    fi
  }
  stage4_error() {
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $message" | tee -a "${o}/00-logs_and_reports/logs/Stage4_Sequence_alignment_trimming_and_supermatrix_construction_${current_time}.log"
  }
  stage4_cmd() {
    local log_mode="$1"
    local message="$2"
    
    if [ "${log_mode}" = "cmd" ] || [ "${log_mode}" = "full" ]; then
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] [CMD] $message" >> "${o}/00-logs_and_reports/logs/HybSuite_cmd_${current_time}.log"
    fi
  }
  stage4_blank() {
    local log_mode="$1"
    local message="$2"
    if [ "${log_mode}" = "full" ]; then
      echo "$message" | tee -a "${o}/00-logs_and_reports/logs/Stage4_Sequence_alignment_trimming_and_supermatrix_construction_${current_time}.log"
    fi
  }
  stage4_logfile="${o}/00-logs_and_reports/logs/Stage4_Sequence_alignment_trimming_and_supermatrix_construction_${current_time}.log"
  stage4_info_main "<<<======= Stage 4 Sequence Alignment, Trimming, and Supermatrix Construction =======>>>"
  #################===========================================================================

  ##############################################################################################
  #Stage4-Optional step: Running MAFFT and Trimal, constructing supermatrix for HRS sequences ##
  ##############################################################################################
  if [ "${HRS}" = "TRUE" ]; then
    stage4_info_main "Optional step: Running MAFFT and Trimal, constructing supermatrix for HRS sequences ..."
    #01-Running MAFFT and Trimal for HRS sequences
    stage4_info_main "01-Running MAFFT and Trimal for HRS sequences ..."
    cd ${o}/03-Orthology_inference/HRS/03-Filtered_HRS_sequences
    if [ -d "${o}/04-Alignments/HRS" ]; then
      rm -rf "${o}/04-Alignments/HRS"
    fi
    mkdir -p "${o}/04-Alignments/HRS"
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
      sed -e 's/ single_hit//g;s/ multi_hit_stitched_contig_comprising_.*_hits//g' "${file}" > "${o}/04-Alignments/HRS/${file_name}.fasta"
      run_mafft "${o}/04-Alignments/HRS/${file_name}.fasta" "${o}/04-Alignments/HRS/${file_name}.aln.fasta" "${mafft_algorithm}" "${mafft_adjustdirection}" "${nt_mafft}"
      run_trimal "${o}/04-Alignments/HRS/${file_name}.aln.fasta" "${o}/04-Alignments/HRS/${file_name}.trimmed.aln.fasta" "${trimal_mode}" \
      "${trimal_gapthreshold}" "${trimal_simthreshold}" "${trimal_cons}" "${trimal_block}" "${trimal_resoverlap}" "${trimal_seqoverlap}" \
      "${trimal_w}" "${trimal_gw}" "${trimal_sw}"
      rm "${o}/04-Alignments/HRS/${file_name}.aln.fasta" "${o}/04-Alignments/HRS/${file_name}.fasta"
      # Update failed count
      if [ ! -s "${o}/04-Alignments/HRS/${file_name}.trimmed.aln.fasta" ]; then
        record_failed_sample "$file_name"
		continue
      fi
      
      # Update finish count
      update_finish_count "$file_name" "$stage4_logfile"
      if [ "${process}" != "all" ]; then
        echo >&1000
      fi
      } &
    done < "$temp_file"
    wait
    echo
    # Display processing log
    if [ "${log_mode}" = "full" ]; then
      display_process_log "$stage4_logfile" "stage4" "Failed to run MAFFT and Trimal for HRS sequences:"
    fi
    stage4_blank "${log_mode}" ""
    rm -r "$temp_file"

    #02-Run AMAS.py to check every alignment
    mkdir -p "${o}/05-Supermatrix/HRS"
    stage4_info_main "02-Running AMAS.py to check every alignment ..."
    cd "${o}/04-Alignments/HRS/"
    stage4_cmd "${log_mode}" "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${o}/04-Alignments/HRS/*.trimmed.aln.fasta -o ${o}/05-Supermatrix/HRS/AMAS_reports_HRS_raw.tsv"
    python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
    summary -f fasta -d dna -i "${o}"/04-Alignments/HRS/*.trimmed.aln.fasta \
    -o "${o}"/05-Supermatrix/HRS/AMAS_reports_HRS_raw.tsv > /dev/null 2>&1
    if [ -s "${o}/05-Supermatrix/HRS/AMAS_reports_HRS_raw.tsv" ]; then
      stage4_info_main "Successfully running AMAS.py to check every HRS alignment."
      stage4_info_main "The AMAS summaries have been written to ${o}/05-Supermatrix/HRS/AMAS_reports_HRS_raw.tsv"
    else
      stage4_error "Fail to run AMAS.py to check every HRS alignment."
    fi

    #03-Remove alignments with no parsimony informative sites
    stage4_blank "${log_mode}" ""
    stage4_info_main "03-Removing alignments with no parsimony informative sites ..."
    awk '$9==0 {print $1}' "${o}/05-Supermatrix/HRS/AMAS_reports_HRS_raw.tsv" > "${o}"/05-Supermatrix/HRS/Removed_alignments_for_concatenation_list.txt
    awk '$9!=0 {print $1}' "${o}/05-Supermatrix/HRS/AMAS_reports_HRS_raw.tsv" > "${o}"/05-Supermatrix/HRS/Final_alignments_for_concatenation_list.txt
    awk '$9!=0 {print $0}' "${o}/05-Supermatrix/HRS/AMAS_reports_HRS_raw.tsv" > "${o}"/05-Supermatrix/HRS/AMAS_reports_HRS_final.tsv
    while IFS= read -r line || [ -n "$line" ]; do
      rm "${o}"/04-Alignments/HRS/"${line}"
      stage4_info "${log_mode}" "Remove alignment ${line}."
    done < "${o}"/05-Supermatrix/HRS/Removed_alignments_for_concatenation_list.txt
    awk '{print $0 "\tno_parsimony_informative_sites"}' "${o}/05-Supermatrix/HRS/Removed_alignments_for_concatenation_list.txt" > "${o}/05-Supermatrix/HRS/Removed_alignments_for_concatenation_list.txt"
    num_filtered_aln=$(wc -l < "${o}"/05-Supermatrix/HRS/Removed_alignments_for_concatenation_list.txt)
    stage4_info_main "Successfully removing ${num_filtered_aln} HRS alignments with no parsimony informative sites."

    #04-Concatenate trimmed alignments
    stage4_blank "${log_mode}" ""
    stage4_info_main "04-Concatenating HRS alignments into the supermatrix ... "
    stage4_cmd "${log_mode}" "pxcat -s ${o}/04-Alignments/HRS/*.trimmed.aln.fasta -p ${o}/05-Supermatrix/HRS/partition.txt -o ${o}/05-Supermatrix/HRS/${prefix}_HRS.fasta"
    pxcat \
    -s ${o}/04-Alignments/HRS/*.trimmed.aln.fasta \
    -p ${o}/05-Supermatrix/HRS/partition.txt \
    -o ${o}/05-Supermatrix/HRS/${prefix}_HRS.fasta
    sed -i 's/AA, /DNA, /g' "${o}/05-Supermatrix/HRS/partition.txt"
    if [ -s "${o}/05-Supermatrix/HRS/${prefix}_HRS.fasta" ]; then
      stage4_info_main "Successfully concatenating HRS alignments into the supermatrix."
    else
      stage4_error "Fail to concatenate HRS alignments into the supermatrix."
    fi

    #05-Run AMAS.py to check the HRS supermatrix
    stage4_blank "${log_mode}" ""
    stage4_info_main "05-Running AMAS.py to check the HRS supermatrix ... "
    stage4_cmd "${log_mode}" "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${o}/05-Supermatrix/HRS/${prefix}_HRS.fasta -o ${o}/05-Supermatrix/HRS/AMAS_reports_HRS_supermatrix.tsv"
    python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
    summary -f fasta -d dna -i ${o}/05-Supermatrix/HRS/${prefix}_HRS.fasta \
    -o "${o}"/05-Supermatrix/HRS/AMAS_reports_HRS_supermatrix.tsv > /dev/null 2>&1
    awk 'NR==2' "${o}"/05-Supermatrix/HRS/AMAS_reports_HRS_supermatrix.tsv >> "${o}"/05-Supermatrix/HRS/AMAS_reports_HRS_raw.tsv
    awk 'NR==2' "${o}"/05-Supermatrix/HRS/AMAS_reports_HRS_supermatrix.tsv >> "${o}"/05-Supermatrix/HRS/AMAS_reports_HRS_final.tsv
    if [ -s "${o}/05-Supermatrix/HRS/AMAS_reports_HRS_supermatrix.tsv" ]; then
      stage4_info_main "Successfully running AMAS.py to check the HRS supermatrix."
      stage4_info_main "The AMAS summary of the HRS supermatrix has been written to the last row of ${o}/05-Supermatrix/HRS/AMAS_reports_HRS_final.tsv"
    else
      stage4_error "Fail to run AMAS.py to check HRS supermatrix."
    fi
    rm "${o}"/05-Supermatrix/HRS/AMAS_reports_HRS_supermatrix.tsv
    stage4_blank_main ""
  fi

  ##############################################################################################
  #Stage4-Optional step: Running MAFFT and Trimal, constructing supermatrix for RLWP sequences #
  ##############################################################################################
  if [ "${RLWP}" = "TRUE" ]; then
    stage4_info_main "Optional step: Running MAFFT and Trimal, constructing supermatrix for RLWP sequences ..."
    #01-Running MAFFT and Trimal for RLWP sequences
    stage4_info_main "01-Running MAFFT and Trimal for RLWP sequences ..."
    cd ${o}/03-Orthology_inference/RLWP/03-Filtered_RLWP_sequences
    if [ -d "${o}/04-Alignments/RLWP" ]; then
      rm -rf "${o}/04-Alignments/RLWP"
    fi
    mkdir -p "${o}/04-Alignments/RLWP"
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
      sed -e 's/ single_hit//g;s/ multi_hit_stitched_contig_comprising_.*_hits//g' "${file}" > "${o}/04-Alignments/RLWP/${file_name}.fasta"
      run_mafft "${o}/04-Alignments/RLWP/${file_name}.fasta" "${o}/04-Alignments/RLWP/${file_name}.aln.fasta" "${mafft_algorithm}" "${mafft_adjustdirection}" "${nt_mafft}"
      run_trimal "${o}/04-Alignments/RLWP/${file_name}.aln.fasta" "${o}/04-Alignments/RLWP/${file_name}.trimmed.aln.fasta" "${trimal_mode}" \
      "${trimal_gapthreshold}" "${trimal_simthreshold}" "${trimal_cons}" "${trimal_block}" "${trimal_resoverlap}" "${trimal_seqoverlap}" \
      "${trimal_w}" "${trimal_gw}" "${trimal_sw}"
      rm "${o}/04-Alignments/RLWP/${file_name}.aln.fasta" "${o}/04-Alignments/RLWP/${file_name}.fasta"
      # Update failed count
      if [ ! -s "${o}/04-Alignments/RLWP/${file_name}.trimmed.aln.fasta" ]; then
        record_failed_sample "$file_name"
		continue
      fi
      
      # Update finish count
      update_finish_count "$file_name" "$stage4_logfile"
      if [ "${process}" != "all" ]; then
        echo >&1000
      fi
      } &
    done < "$temp_file"
    wait
    echo
    # Display processing log
    if [ "${log_mode}" = "full" ]; then
      display_process_log "$stage4_logfile" "stage4" "Failed to run MAFFT and Trimal for RLWP sequences:"
    fi
    stage4_blank "${log_mode}" ""
    rm -r "$temp_file"

    #02-Run AMAS.py to check every alignment
    mkdir -p "${o}/05-Supermatrix/RLWP"
    stage4_info_main "02-Running AMAS.py to check every alignment ..."
    cd "${o}/04-Alignments/RLWP/"
    stage4_cmd "${log_mode}" "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${o}/04-Alignments/RLWP/*.trimmed.aln.fasta -o ${o}/05-Supermatrix/RLWP/AMAS_reports_RLWP_raw.tsv"
    python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
    summary -f fasta -d dna -i "${o}"/04-Alignments/RLWP/*.trimmed.aln.fasta \
    -o "${o}"/05-Supermatrix/RLWP/AMAS_reports_RLWP_raw.tsv > /dev/null 2>&1
    if [ -s "${o}/05-Supermatrix/RLWP/AMAS_reports_RLWP_raw.tsv" ]; then
      stage4_info_main "Successfully running AMAS.py to check every RLWP alignment."
      stage4_info_main "The AMAS summaries have been written to ${o}/05-Supermatrix/RLWP/AMAS_reports_RLWP_raw.tsv"
    else
      stage4_error "Fail to run AMAS.py to check every RLWP alignment."
    fi

    #03-Remove alignments with no parsimony informative sites
    stage4_blank "${log_mode}" ""
    stage4_info_main "03-Removing alignments with no parsimony informative sites ..."
    awk '$9==0 {print $1}' "${o}/05-Supermatrix/RLWP/AMAS_reports_RLWP_raw.tsv" > "${o}"/05-Supermatrix/RLWP/Removed_alignments_for_concatenation_list.txt
    awk '$9!=0 {print $1}' "${o}/05-Supermatrix/RLWP/AMAS_reports_RLWP_raw.tsv" > "${o}"/05-Supermatrix/RLWP/Final_alignments_for_concatenation_list.txt
    awk '$9!=0 {print $0}' "${o}/05-Supermatrix/RLWP/AMAS_reports_RLWP_raw.tsv" > "${o}"/05-Supermatrix/RLWP/AMAS_reports_RLWP_final.tsv
    while IFS= read -r line || [ -n "$line" ]; do
      rm "${o}"/04-Alignments/RLWP/"${line}"
      stage4_info "${log_mode}" "Remove alignment ${line}."
    done < "${o}"/05-Supermatrix/RLWP/Removed_alignments_for_concatenation_list.txt
    awk '{print $0 "\tno_parsimony_informative_sites"}' "${o}/05-Supermatrix/RLWP/Removed_alignments_for_concatenation_list.txt" > "${o}/05-Supermatrix/RLWP/Removed_alignments_for_concatenation_list.txt"
    num_filtered_aln=$(wc -l < "${o}"/05-Supermatrix/RLWP/Removed_alignments_for_concatenation_list.txt)
    stage4_info_main "Successfully removing ${num_filtered_aln} RLWP alignments with no parsimony informative sites."

    #04-Concatenate trimmed alignments
    stage4_blank "${log_mode}" ""
    stage4_info_main "04-Concatenating RLWP alignments into the supermatrix ... "
    stage4_cmd "${log_mode}" "pxcat -s ${o}/04-Alignments/RLWP/*.trimmed.aln.fasta -p ${o}/05-Supermatrix/RLWP/partition.txt -o ${o}/05-Supermatrix/RLWP/${prefix}_RLWP.fasta"
    pxcat \
    -s ${o}/04-Alignments/RLWP/*.trimmed.aln.fasta \
    -p ${o}/05-Supermatrix/RLWP/partition.txt \
    -o ${o}/05-Supermatrix/RLWP/${prefix}_RLWP.fasta
    sed -i 's/AA, /DNA, /g' "${o}/05-Supermatrix/RLWP/partition.txt"
    if [ -s "${o}/05-Supermatrix/RLWP/${prefix}_RLWP.fasta" ]; then
      stage4_info_main "Successfully concatenating RLWP alignments into the supermatrix."
    else
      stage4_error "Fail to concatenate RLWP alignments into the supermatrix."
    fi

    #05-Run AMAS.py to check the RLWP supermatrix
    stage4_blank "${log_mode}" ""
    stage4_info_main "05-Running AMAS.py to check the RLWP supermatrix ... "
    stage4_cmd "${log_mode}" "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${o}/05-Supermatrix/RLWP/${prefix}_RLWP.fasta -o ${o}/05-Supermatrix/RLWP/AMAS_reports_RLWP_supermatrix.tsv"
    python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
    summary -f fasta -d dna -i ${o}/05-Supermatrix/RLWP/${prefix}_RLWP.fasta \
    -o "${o}"/05-Supermatrix/RLWP/AMAS_reports_RLWP_supermatrix.tsv > /dev/null 2>&1
    awk 'NR==2' "${o}"/05-Supermatrix/RLWP/AMAS_reports_RLWP_supermatrix.tsv >> "${o}"/05-Supermatrix/RLWP/AMAS_reports_RLWP_raw.tsv
    awk 'NR==2' "${o}"/05-Supermatrix/RLWP/AMAS_reports_RLWP_supermatrix.tsv >> "${o}"/05-Supermatrix/RLWP/AMAS_reports_RLWP_final.tsv
    if [ -s "${o}/05-Supermatrix/RLWP/AMAS_reports_RLWP_supermatrix.tsv" ]; then
      stage4_info_main "Successfully running AMAS.py to check the RLWP supermatrix."
      stage4_info_main "The AMAS summary of the RLWP supermatrix has been written to the last row of ${o}/05-Supermatrix/RLWP/AMAS_reports_RLWP_final.tsv"
    else
      stage4_error "Fail to run AMAS.py to check RLWP supermatrix."
    fi
    rm "${o}"/05-Supermatrix/RLWP/AMAS_reports_RLWP_supermatrix.tsv
    stage4_blank_main ""
  fi
  

  ###################################################################################################
  #Stage4-Optional step: Extracting PhyloPyPruner output, constructing supermatrix for orthogroups ##
  ###################################################################################################
  if [ "${LS}" = "TRUE" ] || [ "${MI}" = "TRUE" ] || [ "${MO}" = "TRUE" ] || [ "${RT}" = "TRUE" ] || [ "${one_to_one}" = "TRUE" ] && [ "${run_phylopypruner}" = "TRUE" ]; then
    stage4_info_main "Optional step: Extracting PhyloPyPruner output, constructing supermatrix for orthogroups ..."

    stage4_ortho_phylopypruner () {
      local ortho_method=$1
      local output_dir=$2
      local prefix=$3
      local nt=$4
      local min_sample_coverage=$5

      stage4_info_main "====>> ${ortho_method} ====>>"
      stage4_info_main "01-Extracting PhyloPyPruner ${ortho_method} output sequences ..."
      if [ -d "${o}/04-Alignments/${ortho_method}" ]; then
        rm -rf "${o}/04-Alignments/${ortho_method}"
      fi
      if [ -d "${o}/05-Supermatrix/${ortho_method}" ]; then
        rm -rf "${o}/05-Supermatrix/${ortho_method}"
      fi
      mkdir -p "${o}/04-Alignments/${ortho_method}" "${o}/05-Supermatrix/${ortho_method}"
      cp "${o}/03-Orthology_inference/PhyloPyPruner/Output_${ortho_method}/output_alignments/"*.fasta "${o}/04-Alignments/${ortho_method}/"
      cd "${o}/04-Alignments/${ortho_method}/"
      for fasta_file in "${o}/04-Alignments/${ortho_method}/"*.fasta; do
          new_name="${fasta_file/_paralogs_all.trimmed.aln/}"
          new_name="${new_name%.fasta}"
          new_name="${new_name/_pruned/}"
          new_name="${new_name}.trimmed.aln.fasta"
          mv "$fasta_file" "$new_name"
      done

      stage4_info_main "02-Removing ${ortho_method} orthogroups with <${min_sample_coverage} sample coverage ..."
      stage4_cmd "${log_mode}" "python ${script_dir}/filter_seqs_by_sample_and_locus_coverage.py -i ${o}/04-Alignments/${ortho_method}/ --min_sample_coverage ${min_sample_coverage} --removed_samples_info ${o}/04-Alignments/${ortho_method}/Removed_alignments_with_low_sample_coverage.txt -t ${nt}"
      stage4_02="python ${script_dir}/filter_seqs_by_sample_and_locus_coverage.py -i ${o}/04-Alignments/${ortho_method}/ --min_sample_coverage ${min_sample_coverage} --removed_samples_info ${o}/04-Alignments/${ortho_method}/Removed_alignments_with_low_sample_coverage.txt -t ${nt}"
      if [ "${log_mode}" = "full" ]; then
        eval "${stage4_02}"
      else
        eval "${stage4_02} > /dev/null 2>&1"
      fi

      stage4_info_main "03-Removing ${ortho_method} orthogroups with no parsimony informative sites ..."
      stage4_cmd "${log_mode}" "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${o}/04-Alignments/${ortho_method}/*.trimmed.aln.fasta -o ${o}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv"
      python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
      summary -f fasta -d dna -i "${o}/04-Alignments/${ortho_method}/"*.trimmed.aln.fasta -o "${o}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" > /dev/null 2>&1
      awk '$9==0 {print $1}' "${o}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" > "${o}/05-Supermatrix/${ortho_method}/Removed_alignments_for_concatenation_list.txt"
      awk '$9!=0 {print $1}' "${o}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" > "${o}/05-Supermatrix/${ortho_method}/Final_alignments_for_concatenation_list.txt"
      awk '$9!=0 {print $0}' "${o}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" > "${o}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_final.tsv"
      while IFS= read -r line || [ -n "$line" ]; do
        rm "${o}"/04-Alignments/${ortho_method}/"${line}"
      done < "${o}"/05-Supermatrix/${ortho_method}/Removed_alignments_for_concatenation_list.txt

      stage4_info_main "04-Concatenating ${ortho_method} orthogroups into the supermatrix ..."
      stage4_cmd "${log_mode}" "pxcat -s ${o}/04-Alignments/${ortho_method}/*.trimmed.aln.fasta -p ${o}/05-Supermatrix/${ortho_method}/partition.txt -o ${o}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}.fasta"
      pxcat -s "${o}/04-Alignments/${ortho_method}/"*.trimmed.aln.fasta -p ${o}/05-Supermatrix/${ortho_method}/partition.txt -o ${o}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}.fasta

      stage4_info_main "05-Running AMAS.py to check the ${ortho_method} supermatrix ..."
      stage4_cmd "${log_mode}" "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${o}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}.fasta -o ${o}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv"
      python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
      summary -f fasta -d dna -i "${o}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}.fasta" -o "${o}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" > /dev/null 2>&1
      awk 'NR==2' "${o}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" >> "${o}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_final.tsv"
      rm "${o}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv"
      sed -i 's/AA, /DNA, /g' "${o}/05-Supermatrix/${ortho_method}/partition.txt"
    }

    if [ "${LS}" = "TRUE" ]; then
      stage4_ortho_phylopypruner "LS" "Output_LS" "${prefix}" "${nt}" "${min_sample_coverage}"
    fi
    if [ "${MI}" = "TRUE" ]; then
      stage4_ortho_phylopypruner "MI" "Output_MI" "${prefix}" "${nt}" "${min_sample_coverage}"
    fi
    if [ "${MO}" = "TRUE" ]; then
      stage4_ortho_phylopypruner "MO" "Output_MO" "${prefix}" "${nt}" "${min_sample_coverage}"
    fi
    if [ "${RT}" = "TRUE" ]; then
      stage4_ortho_phylopypruner "RT" "Output_RT" "${prefix}" "${nt}" "${min_sample_coverage}"
    fi
    if [ "${one_to_one}" = "TRUE" ]; then
      stage4_ortho_phylopypruner "1to1" "Output_1to1" "${prefix}" "${nt}" "${min_sample_coverage}"
    fi
  fi
  stage4_blank_main ""
  
  ###################################################################################################
  #Stage4-Optional step: Extracting ParaGone output, constructing supermatrix for orthogroups #######
  ###################################################################################################
  if [ "${MO}" = "TRUE" ] || [ "${MI}" = "TRUE" ] || [ "${RT}" = "TRUE" ] || [ "${one_to_one}" = "TRUE" ] && [ "${run_paragone}" = "TRUE" ]; then
    stage4_info_main "Optional step: Extracting ParaGone output, constructing supermatrix for orthogroups ..."
    stage4_ortho_paragone () {
      local ortho_method=$1
      local output_dir=$2
      local prefix=$3
      local nt=$4
      local min_sample_coverage=$5
      
      stage4_info_main "01-Extracting ParaGone ${ortho_method} output sequences ..."
      mkdir -p "${o}/04-Alignments/${ortho_method}" "${o}/05-Supermatrix/${ortho_method}"
      cp "${o}/03-Orthology_inference/ParaGone/${output_dir}/"*.fasta "${o}/04-Alignments/${ortho_method}/"
      cd "${o}/04-Alignments/${ortho_method}/"
      for file in "${o}/04-Alignments/${ortho_method}/"*_paralogs_all.trimmed.aln_pruned.fasta; do
        new_filename="${file/.selected_stripped.aln.trimmed.fasta/.trimmed.aln.fasta}"
        mv "${file}" "${new_filename}"
      done
      
      stage4_info_main "02-Removing ${ortho_method} orthogroups with <${min_sample_coverage} sample coverage ..."
      stage4_cmd "${log_mode}" "python ${script_dir}/filter_seqs_by_sample_and_locus_coverage.py -i ${o}/04-Alignments/${ortho_method}/ -c ${min_sample_coverage} --removed_samples_info ${o}/04-Alignments/${ortho_method}/Removed_alignments_with_low_sample_coverage.txt -t ${nt}"
      stage4_02="python ${script_dir}/filter_seqs_by_sample_and_locus_coverage.py -i ${o}/04-Alignments/${ortho_method}/ --min_sample_coverage ${min_sample_coverage} --removed_samples_info ${o}/04-Alignments/${ortho_method}/Removed_alignments_with_low_sample_coverage.txt -t ${nt}"
      if [ "${log_mode}" = "full" ]; then
        eval "${stage4_02}"
      else
        eval "${stage4_02} > /dev/null 2>&1"
      fi

      stage4_info_main "03-Removing ${ortho_method} orthogroups with no parsimony informative sites ..."
      stage4_cmd "${log_mode}" "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${o}/04-Alignments/${ortho_method}/*.trimmed.aln.fasta -o ${o}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv"
      python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
      summary -f fasta -d dna -i "${o}/04-Alignments/${ortho_method}/*.trimmed.aln.fasta" -o "${o}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" > /dev/null 2>&1
      awk '$9==0 {print $1}' "${o}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" > "${o}/05-Supermatrix/${ortho_method}/Removed_alignments_for_concatenation_list.txt"
      awk '$9!=0 {print $1}' "${o}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" > "${o}/05-Supermatrix/${ortho_method}/Final_alignments_for_concatenation_list.txt"
      awk '$9!=0 {print $0}' "${o}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" > "${o}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_final.tsv"
      while IFS= read -r line || [ -n "$line" ]; do
        rm "${o}"/04-Alignments/${ortho_method}/"${line}"
      done < "${o}"/05-Supermatrix/${ortho_method}/Removed_alignments_for_concatenation_list.txt

      stage4_info_main "04-Concatenating ${ortho_method} orthogroups into the supermatrix ..."
      stage4_cmd "${log_mode}" "pxcat -s ${o}/04-Alignments/${ortho_method}/*.trimmed.aln.fasta -p ${o}/05-Supermatrix/${ortho_method}/partition.txt -o ${o}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}.fasta"
      pxcat -s "${o}/04-Alignments/${ortho_method}/*.trimmed.aln.fasta" -p "${o}/05-Supermatrix/${ortho_method}/partition.txt" -o "${o}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}.fasta"

      stage4_info_main "05-Running AMAS.py to check the ${ortho_method} supermatrix ..."
      stage4_cmd "${log_mode}" "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${o}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}.fasta -o ${o}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv"
      python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
      summary -f fasta -d dna -i "${o}/05-Supermatrix/${ortho_method}/${prefix}_${ortho_method}.fasta" -o "${o}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" > /dev/null 2>&1
      awk 'NR==2' "${o}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv" >> "${o}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_final.tsv"
      rm "${o}/05-Supermatrix/${ortho_method}/AMAS_reports_${ortho_method}_supermatrix.tsv"
    }

    if [ "${MO}" = "TRUE" ]; then
      stage4_ortho_paragone "MO" "26_MO_final_alignments_trimmed" "MO" "${nt}" "${min_sample_coverage}"
    fi
    if [ "${MI}" = "TRUE" ]; then
      stage4_ortho_paragone "MI" "27_MI_final_alignments_trimmed" "MI" "${nt}" "${min_sample_coverage}"
    fi
    if [ "${RT}" = "TRUE" ]; then
      stage4_ortho_paragone "RT" "28_RT_final_alignments_trimmed" "RT" "${nt}" "${min_sample_coverage}"
    fi
    if [ "${one_to_one}" = "TRUE" ]; then
      stage4_ortho_paragone "1to1" "HybSuite_1to1_final_alignments_trimmed" "1to1" "${nt}" "${min_sample_coverage}"
    fi
  fi
  stage4_blank "${log_mode}" ""
  ############################################################################################
  # End of Stage 4
  stage4_info_main "Successfully finishing the stage 4: Sequence alignment, trimming and supermatrix construction."
  stage4_info "${log_mode}" "The resulting files have been saved in ${o}/04-Alignments/ and ${o}/05-Supermatrix"

  if [ "${run_to_stage4}" = "true" ]; then
    # Clean up environment
    cleanup_parallel_env "$work_dir"
    stage4_info_main "You set '--run_to_stage4' to specify HybSuite to run to the stage 4."
    stage4_info_main "Consequently, HybSuite will stop and exit right now."
    stage4_info_main "Thank you for using HybSuite! Enjoy your research!"
    stage4_blank_main ""
    exit 1
  else
    stage4_info_main "Moving on to the next stage..."
    stage4_blank_main ""
  fi
  ############################################################################################
fi



############################################################################################
# Stage 5: Phylogenetic tree inference #####################################################
############################################################################################
if [ -d "${o}/06-ModelTest-NG" ]; then
    rm -rf "${o}/06-ModelTest-NG"
fi
mkdir -p "${o}/06-ModelTest-NG"
################===========================================================================
# 0.Preparation
# (1) Function: Output information to log file
stage5_info_main() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "${o}/00-logs_and_reports/logs/Stage5_Phylogenetic_tree_inference_${current_time}.log"
}
stage5_error() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "${o}/00-logs_and_reports/logs/Stage5_Phylogenetic_tree_inference_${current_time}.log"
}
stage5_blank_main() {
  echo "$1" | tee -a "${o}/00-logs_and_reports/logs/Stage5_Phylogenetic_tree_inference_${current_time}.log"
}
stage5_info() {
  local log_mode="$1"
  local message="$2"
  if [ "${log_mode}" = "full" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $message" | tee -a "${o}/00-logs_and_reports/logs/Stage5_Phylogenetic_tree_inference_${current_time}.log"
  fi
}
stage5_cmd() {
  local log_mode="$1"
  local message="$2"
  if [ "${log_mode}" = "cmd" ] || [ "${log_mode}" = "full" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [CMD] $message" >> "${o}/00-logs_and_reports/logs/HybSuite_cmd_${current_time}.log"
  fi
}
stage5_blank() {
  local log_mode="$1"
  local message="$2"
  if [ "${log_mode}" = "full" ]; then
    echo "$message" | tee -a "${o}/00-logs_and_reports/logs/Stage5_Phylogenetic_tree_inference_${current_time}.log"
  fi
}
stage5_logfile="${o}/00-logs_and_reports/logs/Stage5_Phylogenetic_tree_inference_${current_time}.log"

stage5_info_main "<<<======= Stage 5 Phylogenetic tree inference =======>>>"
#(2) activate conda environment
conda_activate "stage5" "${conda1}"
################===========================================================================

###################################################################################################
#Stage5-Optional step: Model Test #################################################################
###################################################################################################
#1. ModelTest-NG (Optional)
#Preparation
if [ "${run_modeltest_ng}" = "TRUE" ] && [ "${run_astral}" != "TRUE" ] && [ "${run_wastral}" != "TRUE" ]; then
  stage5_info_main "Optional step: Model Test"
  define_threads "modeltest_ng" "stage5_logfile"

  run_modeltest_ng() {
    local ortho_method="$1"
  
    if [ "${ortho_method}" = "1to1" ]; then
      ortho_method="one_to_one"
      ortho_method_dir="1to1"
    else
      ortho_method_dir="${ortho_method}"
    fi
    stage5_info_main "Running ModelTest-NG for the ${ortho_method_dir} supermatrix ... "
    mkdir -p "${o}/06-ModelTest-NG/${ortho_method_dir}"
    stage5_cmd "${log_mode}" "modeltest-ng -d nt --force -p ${nt_modeltest_ng} -i ${o}/05-Supermatrix/${ortho_method_dir}/${prefix}_${ortho_method_dir}.fasta -o ${o}/06-ModelTest-NG/${ortho_method_dir}/${prefix}_modeltest.txt -T raxml"
    modeltest-ng -d nt \
    --force \
    -p ${nt_modeltest_ng} \
    -i "${o}/05-Supermatrix/${ortho_method_dir}/${prefix}_${ortho_method_dir}.fasta" \
    -o "${o}/06-ModelTest-NG/${ortho_method_dir}/${prefix}_modeltest.txt" \
    -T raxml > /dev/null 2>&1
    stage5_blank "${log_mode}" ""
    ###02-According to the result, assign different variables to the suggested commands for each tree building software
    eval "${ortho_method}_iqtree=\$(grep -n 'iqtree' ${o}/06-ModelTest-NG/${ortho_method_dir}/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*iqtree/iqtree/g')"
    eval "${ortho_method}_raxml_ng_mtest=\$(grep -n 'raxml-ng' ${o}/06-ModelTest-NG/${ortho_method_dir}/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxml-ng/raxml-ng/g')"
    eval "${ortho_method}_raxmlHPC_mtest=\$(grep -n 'raxmlHPC' ${o}/06-ModelTest-NG/${ortho_method_dir}/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxmlHPC/raxmlHPC-PTHREADS/g; s/ -n .*$//')"
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
stage5_blank_main ""

###################################################################################################
#Stage5-Optional step: Constructing concatenation-based trees #####################################
###################################################################################################
#Preparation
if [ "${run_iqtree}" = "TRUE" ] || [ "${run_raxml}" = "TRUE" ] || [ "${run_raxml_ng}" = "TRUE" ]; then
  
  run_iqtree() {
    local ortho_method="$1"

    if [ -d "${o}/07-Concatenation-based_trees/${ortho_method}/IQ-TREE" ]; then
      rm -rf "${o}/07-Concatenation-based_trees/${ortho_method}/IQ-TREE"
    fi
    stage5_info_main "Optional step: Constructing concatenation-based trees for "${ortho_method}" supermatrix via IQ-TREE"
    define_threads "iqtree" "stage5_logfile"
    mkdir -p "${o}/07-Concatenation-based_trees/${ortho_method}/IQ-TREE"
    cd "${o}/05-Supermatrix/${ortho_method}"
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      if [ "${ortho_method}" = "1to1" ]; then
        ortho_method="one_to_one"
        ortho_method_dir="1to1"
      else
        ortho_method_dir="${ortho_method}"
      fi
      var_name="${ortho_method}_iqtree"
      eval "iqtree_cmd=\$$var_name"
      run_iqtree_cmd="${iqtree_cmd} -B ${iqtree_bb} --undo \
      --seed 12345 -T ${nt_iqtree} -pre ${o}/07-Concatenation-based_trees/${ortho_method_dir}/IQ-TREE/IQ-TREE_${prefix}_${ortho_method_dir}"
      if [ "${iqtree_partition}" = "TRUE" ]; then
        run_iqtree_cmd="${run_iqtree_cmd} -p ${o}/05-Supermatrix/${ortho_method_dir}/partition.txt"
      fi
      if [ "${iqtree_constraint_tree}" != "_____" ]; then
        run_iqtree_cmd="${run_iqtree_cmd} -g ${iqtree_constraint_tree}"
      fi
      if [ "${iqtree_alrt}" != "FALSE" ]; then
        run_iqtree_cmd="${run_iqtree_cmd} -alrt ${iqtree_alrt}"
      fi
      eval "${run_iqtree_cmd} > /dev/null 2>&1"
    else
      run_iqtree_cmd="iqtree -s ${o}/05-Supermatrix/${ortho_method_dir}/${prefix}_${ortho_method_dir}.fasta --undo \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -m MFP \
          -pre IQTREE_${prefix}_${ortho_method_dir} -g "${iqtree_constraint_tree}""
      if [ "${iqtree_partition}" = "TRUE" ]; then
        run_iqtree_cmd="${run_iqtree_cmd} -p ${o}/05-Supermatrix/${ortho_method_dir}/partition.txt"
      fi
      if [ "${iqtree_constraint_tree}" != "_____" ]; then
        run_iqtree_cmd="${run_iqtree_cmd} -g ${iqtree_constraint_tree}"
      fi
      if [ "${iqtree_alrt}" != "FALSE" ]; then
        run_iqtree_cmd="${run_iqtree_cmd} -alrt ${iqtree_alrt}"
      fi
      eval "${run_iqtree_cmd} > /dev/null 2>&1"
    fi
    if [ ! -s "${o}/07-Concatenation-based_trees/${ortho_method_dir}/IQ-TREE/IQ-TREE_${prefix}_${ortho_method_dir}.treefile" ]; then
      stage5_error "Fail to run IQ-TREE." 
      stage5_error "HybSuite exits." 
      stage5_blank_main ""
      exit 1
    else 
      stage5_info_main "Successfully constructing the ${ortho_mode_dir} concatenation-based tree (IQ-TREE)."
    fi
    cd "${o}/07-Concatenation-based_trees/${ortho_method_dir}/IQ-TREE/"
    ##01-4 reroot the tree via phyx
    counter=1
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
    cmd="pxrr -s -t ${o}/07-Concatenation-based_trees/${ortho_method_dir}/IQ-TREE/IQ-TREE_${prefix}_${ortho_method_dir}.treefile -g "
    x=1
    og_params=""
    while [ $x -lt $counter ]; do
        var_name="og$x"
        eval "current_og=\$$var_name"
        if [ $x -eq 1 ]; then
            og_params="$current_og"
        else
            og_params="${og_params},$current_og"
        fi
        x=$((x + 1))
    done
    cmd="${cmd}${og_params}"
    stage5_info "${log_mode}" "Use phyx to reroot the tree (IQTREE)..." 
    stage5_cmd "${log_mode}" "$cmd > ${o}/07-Concatenation-based_trees/${ortho_method_dir}/IQ-TREE/IQ-TREE_rr_${prefix}_${ortho_method_dir}.tre ..."
    eval "$cmd > ${o}/07-Concatenation-based_trees/${ortho_method_dir}/IQ-TREE/IQ-TREE_rr_${prefix}_${ortho_method_dir}.tre"
    if [ ! -s "${o}/07-Concatenation-based_trees/${ortho_method_dir}/IQ-TREE/IQ-TREE_rr_${prefix}_${ortho_method_dir}.tre" ]; then
      stage5_error "Fail to reroot the tree: ${o}/07-Concatenation-based_trees/${ortho_method_dir}/IQ-TREE/IQ-TREE_${prefix}_${ortho_method_dir}.treefile." 
      stage5_error "Please check your alignments and trees produced by IQ-TREE." 
      stage5_blank_main ""
    else
      stage5_info "${log_mode}" "Successfully rerooting the ${ortho_mode_dir} concatenation-based tree (IQ-TREE)."  
      stage5_info_main "Now moving on to the next step..." 
      stage5_blank_main "" 
    fi
  }

  run_raxml() {
    local ortho_method="$1"
    
    if [ -d "${o}/07-Concatenation-based_trees/${ortho_method}/RAxML" ]; then
      rm -rf "${o}/07-Concatenation-based_trees/${ortho_method}/RAxML"
    fi
    stage5_info_main "Optional step: Constructing concatenation-based trees for "${ortho_method}" supermatrix via RAxML"
    mkdir -p "${o}/07-Concatenation-based_trees/${ortho_method}/RAxML"
    cd "${o}/05-Supermatrix/${ortho_method}"
    define_threads "raxml" "stage5_logfile"
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      if [ "${ortho_method}" = "1to1" ]; then
        ortho_method="one_to_one"
        ortho_method_dir="1to1"
      else
        ortho_method_dir="${ortho_method}"
      fi
      var_name="${ortho_method}_raxmlHPC_mtest"
      eval "raxmlHPC_cmd=\$$var_name"
      run_raxmlHPC_cmd="${raxmlHPC_cmd} -f a -T ${nt_raxml} -p 12345 -x 67890 -# ${raxml_bb} -n ${prefix}_${ortho_method_dir}.tre -w ${o}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML"
      if [ "${raxml_constraint_tree}" != "_____" ]; then
        run_raxmlHPC_cmd="${run_raxmlHPC_cmd} -g ${raxml_constraint_tree}"
      fi
      stage5_cmd "${log_mode}" "${run_raxmlHPC_cmd}"
      eval "${run_raxmlHPC_cmd} > /dev/null 2>&1"
    else
      run_raxmlHPC_cmd="raxmlHPC-PTHREADS -s ${o}/05-Supermatrix/${ortho_method_dir}/${prefix}_${ortho_method_dir}.fasta -m ${raxml_m} -f a -T ${nt_raxml} -p 12345 -x 67890 -# ${raxml_bb} -n ${prefix}_${ortho_method_dir}.tre -w ${o}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML"
      if [ "${raxml_constraint_tree}" != "_____" ]; then
        run_raxmlHPC_cmd="${run_raxmlHPC_cmd} -g ${raxml_constraint_tree}"
      fi
      stage5_cmd "${log_mode}" "${run_raxmlHPC_cmd}"
      eval "${run_raxmlHPC_cmd} > /dev/null 2>&1"
    fi
    if [ ! -s "${o}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML/RAxML_bestTree.${prefix}_${ortho_method_dir}.tre" ]; then
      stage5_info_main "Fail to run RAxML." 
      stage5_info_main "HybSuite exits." 
      stage5_blank_main "" 
      exit 1
    else 
      stage5_info_main "Successfully constructing the ${ortho_mode_dir} concatenation-based tree (RAxML)."
    fi
    ##02-3 reroot the tree via phyx
    cd "${o}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML/"
    # Initializes the row counter
    counter=1
    # Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < "${i}/Outgroup.txt"
    # Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./RAxML_bipartitions.${prefix}_${ortho_method_dir}.tre -g "
    # Create a temporary variable to hold all og variables
    x=1
    og_params=""
    while [ $x -lt $counter ]; do
        var_name="og$x"
        eval "current_og=\$$var_name"
        if [ $x -eq 1 ]; then
            og_params="$current_og"
        else
            og_params="${og_params},$current_og"
        fi
        x=$((x + 1))
    done
    cmd="${cmd}${og_params}"
    # Run pxrr
    stage5_info "${log_mode}" "Use phyx to reroot the tree (RAxML)..." 
    eval "$cmd > ./RAxML_rr_${prefix}_${ortho_method_dir}.tre"
    stage5_cmd "${log_mode}" "$cmd > ./RAxML_rr_${prefix}_${ortho_method_dir}.tre ..."
    # Check if the user ran phyx successfully
    if [ ! -s "./RAxML_rr_${prefix}_${ortho_method_dir}.tre" ]; then
      stage5_error "${log_mode}" "Fail to reroot the tree: ${o}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML/RAxML_bipartitions.${prefix}_${ortho_method_dir}.tre." 
      stage5_error "${log_mode}" "Please check your alignments and trees produced by RAxML." 
      stage5_blank "${log_mode}" ""
    else
      stage5_info "${log_mode}" "Successfully rerooting the ${ortho_mode} concatenation-based tree (RAxML)." 
      stage5_info_main "Successfully finishing running RAxML for ${ortho_method_dir} supermatrix..." 
      stage5_info_main "Now moving on to the next step..."
      stage5_blank_main "" 
    fi
  }

  run_raxml_ng() {
    local ortho_method="$1"
    
    if [ -d "${o}/07-Concatenation-based_trees/${ortho_method}/RAxML-NG" ]; then
      rm -rf "${o}/07-Concatenation-based_trees/${ortho_method}/RAxML-NG"
    fi
    stage5_info_main "Optional step: Constructing concatenation-based trees for "${ortho_method}" supermatrix via RAxMl-NG"
    ##01 Set the directory
    mkdir -p "${o}/07-Concatenation-based_trees/${ortho_method}/RAxML-NG"
    cd "${o}/05-Supermatrix/${ortho_method}"
    ##02 Run RAxML-NG
    stage5_info_main "Running RAxML-NG for ${ortho_method} alignments..." 
    define_threads "raxml_ng" "stage5_logfile"
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
      raxml_ng_cmd="${raxml_ng_cmd} --all --threads ${nt_raxml_ng} --prefix ${o}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML-NG/RAxML-NG_${prefix}_${ortho_method_dir} --bs-trees ${rng_bs_trees}"
      if [ "${rng_force}" = "TRUE" ]; then
        raxml_ng_cmd="${raxml_ng_cmd} --force perf_threads"
      fi
      if [ -s "${rng_constraint_tree}" ]; then
        raxml_ng_cmd="${raxml_ng_cmd} --tree-constraint ${rng_constraint_tree}"
      fi
      stage5_cmd "${log_mode}" "${raxml_ng_cmd}"
      eval "${raxml_ng_cmd} > /dev/null 2>&1"
    else
      raxml-ng --parse --msa ${o}/05-Supermatrix/${ortho_method_dir}/HybSuite_${ortho_method_dir}.fasta \
        --model GTR+G \
        --prefix ${o}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
      Model=$(grep "Model:" ${o}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
      raxml_ng_cmd="raxml-ng --all --msa ${o}/05-Supermatrix/${ortho_method_dir}/${prefix}_${ortho_method_dir}.fasta --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML-NG/RAxML-NG_${prefix}_${ortho_method_dir} --bs-trees ${rng_bs_trees}"
      if [ "${rng_force}" = "TRUE" ]; then
        raxml_ng_cmd="${raxml_ng_cmd} --force perf_threads"
      fi
      if [ -s "${rng_constraint_tree}" ]; then
        raxml_ng_cmd="${raxml_ng_cmd} --tree-constraint ${rng_constraint_tree}"
      fi
      stage5_cmd "${log_mode}" "${raxml_ng_cmd}"
      eval "${raxml_ng_cmd} > /dev/null 2>&1"
    fi

    ##02.2 Check if the user ran RAxML-NG successfully
    if [ ! -s "${o}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML-NG/RAxML-NG_${prefix}_${ortho_method_dir}.raxml.support" ]; then
      stage5_error "Fail to run RAxML-NG."
      stage5_error "HybSuite exits."
      stage5_blank_main "" 
      exit 1
    else 
      stage5_info_main "Successfully constructing the ${ortho_mode_dir} concatenation-based tree (RAxML-NG)." 
    fi
    ##03 reroot the tree via phyx
    cd "${o}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML-NG/"
    # Initializes the row counter
    counter=1
    # Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < "${i}/Outgroup.txt"
    # Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./RAxML-NG_${prefix}_${ortho_method_dir}.raxml.support -g "
    # Append all og variables to the temporary variable using the for loop
    x=1
    og_params=""
    while [ $x -lt $counter ]; do
        var_name="og$x"
        eval "current_og=\$$var_name"
        if [ $x -eq 1 ]; then
            og_params="$current_og"
        else
            og_params="${og_params},$current_og"
        fi
        x=$((x + 1))
    done
    cmd="${cmd}${og_params}" 
    # Run pxrr
    stage5_info "${log_mode}" "Use phyx to reroot the tree (RAxML-NG)..."
    stage5_cmd "${log_mode}" "$cmd > ./RAxML-NG_rr_${prefix}_${ortho_method_dir}.tre ..."
    eval "$cmd > ./RAxML-NG_rr_${prefix}_${ortho_method_dir}.tre"
    if [ ! -s "./RAxML-NG_rr_${prefix}_${ortho_method_dir}.tre" ]; then
      stage5_error "Fail to reroot the tree: ${o}/07-Concatenation-based_trees/${ortho_method_dir}/RAxML-NG/RAxML-NG_${prefix}_${ortho_method_dir}.tre." 
      stage5_error "Please check your alignments and trees produced by RAxML-NG." 
      stage5_blank_main ""
    else
      stage5_info_main "Successfully rerooting the ${ortho_mode_dir} concatenation-based tree (RAxML-NG)."
      stage5_info_main "Now moving on to the next step..."
      stage5_blank_main "" 
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
  stage5_info_main "Optional step: Constructing coalescent-based trees (ASTRAL or wASTRAL)."
  counter=1
  while IFS= read -r line || [ -n "$line" ]; do
  eval "og${counter}=\"${line}\""
  counter=$((counter + 1))
  done < ${i}/Outgroup.txt
  
  x=1
  og_params=""
  while [ $x -lt $counter ]; do
    var_name="og$x"
    eval "current_og=\$$var_name"
    if [ $x -eq 1 ]; then
        og_params="$current_og"
    else
        og_params="${og_params},$current_og"
    fi
    x=$((x + 1))
  done
  
  reroot_and_sort_tree() {
    local input_tree="$1"
    local output_tree="$2"

    cmd="pxrr -s -t ${input_tree} -g "
    cmd="${cmd}${og_params}"
	  stage5_cmd "${log_mode}" "${cmd} | nw_order -c n - > ${output_tree}"
	  eval "${cmd} | nw_order -c n - > ${output_tree}"
  }
  
  run_raxml_sg() {
    local ortho_method="$1"
    local Genename="$2"

    mkdir -p ${o}/08-Coalescent-based_trees/${ortho_method}/01-Gene_trees/${Genename}
    stage5_cmd "${log_mode}" "raxmlHPC -f a -T ${nt_astral} -s ${Genename}.trimmed.aln.fasta -k -x $RANDOM -m GTRGAMMA -p $RANDOM -n ${Genename}.tre -w ${o}/08-Coalescent-based_trees/${ortho_method}/01-Gene_trees/${Genename} -N 100"

    raxmlHPC-PTHREADS -T "${nt_raxml}" -f a \
    	-s ${Genename}.trimmed.aln.fasta \
    	-k -x "$RANDOM" \
    	-m GTRGAMMA \
    	-p "$RANDOM" \
    	-n "${Genename}.tre" \
    	-w "${o}/08-Coalescent-based_trees/${ortho_method}/01-Gene_trees/${Genename}/" \
    	-N 100 > /dev/null 2>&1
  }

  run_astral() {
    local input_combined_tree="$1"
    local output_astral_prefix="$2"

    stage5_info_main "Running ASTRAL-Ⅲ ..."
    java -jar ${script_dir}/../dependencies/ASTRAL-master/Astral/astral.5.7.8.jar \
    -i "${input_combined_tree}" \
    -o "${output_astral_prefix}.tre" 2> ${o}/00-logs_and_reports/logs/ASTRAL_${prefix}_${ortho_method}.log
    stage5_cmd "${log_mode}" "java -jar ${script_dir}/../dependencies/ASTRAL-master/Astral/astral.5.7.8.jar -i ${input_combined_tree} -o ${output_astral_prefix}.tre 2> ${o}/00-logs_and_reports/logs/${prefix}_${ortho_method}_ASTRAL.log"
    if [ -s "${output_astral_prefix}.tre" ]; then
      stage5_info_main "Succeed to run ASTRAL-Ⅲ."
    else
      stage5_error "Fail to run ASTRAL-Ⅲ."
      stage5_blank_main ""
    fi
    # reroot and sort the ASTRAL tree
    reroot_and_sort_tree "${output_astral_prefix}.tre" "${output_astral_prefix}_sorted_rr.tre"
  }



  run_wastral() {
    local input_combined_tree="$1"
    local output_wastral_prefix="$2"
    local gene_list="$3"

    mkdir -p ${o}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree
    cd ${wastral_dir}
    define_threads "wastral" "stage5_logfile"
    # if the number of species is less than 2000, run wastral
    if [ $(wc -l < "${gene_list}") -lt 2000 ]; then
      # 01-run wastral
      stage5_cmd "${log_mode}" "bin/wastral --mode ${wastral_mode} -t ${nt_wastral} -r ${wastral_R} -s ${wastral_S} -o ${output_wastral_prefix}.tre ${input_combined_tree} 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_${ortho_method}.log"
      bin/wastral --mode "${wastral_mode}" -t "${nt_wastral}" \
      -r "${wastral_R}" -s "${wastral_S}" \
      -o "${output_wastral_prefix}.tre" \
      "${input_combined_tree}" 2> "${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_${ortho_method}.log"
      # 02-Add bootstrap value by wastral
      stage5_cmd "${log_mode}" "bin/wastral -S ${output_wastral_prefix}.tre > ${output_wastral_prefix}_bootstrap.tre"
      bin/wastral -S "${output_wastral_prefix}.tre" > "${output_wastral_prefix}_bootstrap.tre"
    # if the number of species is more than 2000, run wastral
    else
      # 01-run wastral
      stage5_cmd "${log_mode}" "bin/wastral_precise --mode ${wastral_mode} -t ${nt_wastral} -r ${wastral_R} -s ${wastral_S} -o ${output_wastral_prefix}.tre ${input_combined_tree} 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_${ortho_method}.log"
      bin/wastral_precise --mode ${wastral_mode} -t ${nt_wastral} \
      -r ${wastral_R} -s ${wastral_S} \
      -o "${output_wastral_prefix}.tre" \
      "${input_combined_tree}" 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_${ortho_method}.log
      # 02-Add bootstrap value by wastral
      stage5_cmd "${log_mode}" "bin/wastral_precise -S ${output_wastral_prefix}.tre > ${output_wastral_prefix}_bootstrap.tre"
      bin/wastral_precise -S "${output_wastral_prefix}.tre" > "${output_wastral_prefix}_bootstrap.tre"
    fi
      
    if [ -s "${o}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/wASTRAL_bootstrap_${prefix}_${ortho_method}.tre" ]; then
      stage5_info_main "Succeed to run wASTRAL"
    else
      stage5_error "Fail to run wASTRAL."
      stage5_blank_main ""
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
      cp "${o}/04-Alignments/${ortho_method}/${line}" "${bp_output_dir}"
    done < "${alignments_list}"
    pxcat -s "${bp_output_dir}"/*.trimmed.aln.fasta -p "${bp_output_dir2}/partition_recalculating_bl.txt" -o "${bp_output_dir2}/${supermatrix_name}"
    rm "${bp_output_dir}"/*.trimmed.aln.fasta

    # run RAxML
    stage5_cmd "${log_mode}" "raxmlHPC -f e -t ${o}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/${suffix}_${prefix}_${ortho_method}.tre -m GTRGAMMA -s ${bp_output_dir2}/${supermatrix_name} -n ${suffix}_${prefix}_${ortho_method}_bl.tre -w ${bp_output_dir2} -N 100"
    raxmlHPC -f e -t ${o}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/${suffix}_${prefix}_${ortho_method}.tre -m GTRGAMMA \
    -s "${bp_output_dir2}/${supermatrix_name}" \
    -n "${suffix}_${prefix}_${ortho_method}_bl.tre" \
    -w "${bp_output_dir2}" \
    -N 100 > /dev/null 2>&1
    cd "${bp_output_dir2}"
    # reroot the recalculated bl ASTRAL tree
    reroot_and_sort_tree "${bp_output_dir2}/RAxML_result.${suffix}_${prefix}_${ortho_method}_bl.tre" "${bp_output_dir2}/${suffix}_${prefix}_${ortho_method}_sorted_bl_rr.tre"
    if [ -s "${bp_output_dir2}/phyx.logfile" ]; then
      rm "${bp_output_dir2}/phyx.logfile"
    fi
    if [ -s "${bp_output_dir2}/RAxML_result.${suffix}_${prefix}_${ortho_method}_bl.tre" ]; then
      stage5_info_main "Finish"
    else
      stage5_error "Fail to calculate the branch length for ASTRAL tree via RAxML."
      stage5_blank_main ""
    fi
  }

  calculate_branch_length_sortadate() {
    local supermatrix_name="$1"
    local bp_output_dir="$2"
    local alignments_list="$3"
    local suffix="$4"
    
    # Construct the supermatrix for recalculating branch length
    while IFS= read -r line || [ -n "${line}" ]; do
      cp "${o}/04-Alignments/${ortho_method}/${line}" "${bp_output_dir}"
    done < "${alignments_list}"
    pxcat -s "${bp_output_dir}"/*.trimmed.aln.fasta -p "${bp_output_dir}/partition_recalculating_bl.txt" -o "${bp_output_dir}/${supermatrix_name}"
    rm "${bp_output_dir}"/*.trimmed.aln.fasta

    # run RAxML
    stage5_cmd "${log_mode}" "raxmlHPC -f e -t ${o}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/${suffix}_${prefix}_${ortho_method}.tre -m GTRGAMMA -s ${bp_output_dir}/${supermatrix_name} -n ${suffix}_sortadate_${prefix}_${ortho_method}_bl.tre -w ${bp_output_dir} -N 100"
    raxmlHPC -f e -t ${o}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/${suffix}_${prefix}_${ortho_method}.tre -m GTRGAMMA \
    -s "${bp_output_dir}/${supermatrix_name}" \
    -n "${suffix}_sortadate_${prefix}_${ortho_method}_bl.tre" \
    -w "${bp_output_dir}" \
    -N 100 > /dev/null 2>&1
    cd "${bp_output_dir}"
    # reroot the recalculated bl ASTRAL tree
    reroot_and_sort_tree "${bp_output_dir}/RAxML_result.${suffix}_sortadate_${prefix}_${ortho_method}_bl.tre" "${bp_output_dir}/${suffix}_sortadate_${prefix}_${ortho_method}_sorted_bl_rr.tre"
    if [ -s "${bp_output_dir}/phyx.logfile" ]; then
      rm "${bp_output_dir}/phyx.logfile"
    fi
    if [ -s "${bp_output_dir}/RAxML_result.${suffix}_sortadate_${prefix}_${ortho_method}_bl.tre" ]; then
      stage5_info_main "Succeed to run SortaDate for ASTRAL results and recalculate the branch length."
    else
      stage5_error "Fail to run SortaDate for wASTRAL results and recalculate the branch length."
      stage5_blank_main ""
    fi
  }


  run_phyparts_piecharts() {
    local ortho_method="$1"
    
    mkdir -p ${o}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts
    cd ${o}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts
    # ASTRAL ############
    if [ "${run_astral}" = "TRUE" ]; then
      stage5_info_main "Running PhyPartsPieCharts for ${ortho_method} coalescent-based tree (ASTRAL) ..."
      stage5_cmd "${log_mode}" "java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d ${o}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees -m ${o}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/ASTRAL_${prefix}_${ortho_method}_sorted_rr.tre -o ${o}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts/ASTRAL_PhyParts"
      java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar \
      -a 1 -v -d ${o}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees \
      -m ${o}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/ASTRAL_${prefix}_${ortho_method}_sorted_rr.tre \
      -o ${o}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts/ASTRAL_PhyParts &> /dev/null
            
      phyparts_number=$(find ${o}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees -type f -name "*_rr.tre" | wc -l)
      python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiecharts.py \
      ${o}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/ASTRAL_${prefix}_${ortho_method}_sorted_rr.tre \
      ASTRAL_PhyParts ${phyparts_number} \
      --svg_name ASTRAL_PhyPartsPieCharts_${prefix}_${ortho_method}.svg \
      --to_csv
    
      stage5_cmd "${log_mode}" "python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiecharts.py ${o}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/ASTRAL_${prefix}_${ortho_method}_sorted_rr.tre ASTRAL_PhyParts ${phyparts_number} --svg_name PhypartsPiecharts_${prefix}_${ortho_method}.svg --to_csv"
      if [ -s "${o}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts/ASTRAL_PhyPartsPieCharts_${prefix}_${ortho_method}.svg" ]; then
        stage5_info_main "Finish"
      else
        stage5_error "Fail to run phypartspiecharts.py."
        stage5_blank_main ""
      fi
    fi
    # wASTRAL #################
    if [ "${run_wastral}" = "TRUE" ]; then
      stage5_info_main "Running PhyPartsPieCharts for ${ortho_method} coalescent-based tree (wASTRAL) ..."
      stage5_cmd "${log_mode}" "java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d ${o}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees -m ${o}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/wASTRAL_${prefix}_${ortho_method}_sorted_rr.tre -o ${o}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts/wASTRAL_PhyParts"
      java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar \
      -a 1 -v -d ${o}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees \
      -m ${o}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/wASTRAL_${prefix}_${ortho_method}_sorted_rr.tre \
      -o ${o}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts/wASTRAL_PhyParts &> /dev/null
            
      phyparts_number=$(find ${o}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees -type f -name "*_rr.tre" | wc -l)
      python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiecharts.py \
      ${o}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/wASTRAL_${prefix}_${ortho_method}_sorted_rr.tre \
      wASTRAL_PhyParts ${phyparts_number} \
      --svg_name wASTRAL_PhyPartsPieCharts_${prefix}_${ortho_method}.svg \
      --to_csv
  
      stage5_cmd "${log_mode}" "python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiecharts.py ${o}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/wASTRAL_${prefix}_${ortho_method}_sorted_rr.tre wASTRAL_PhyParts ${phyparts_number} --svg_name PhypartsPiecharts_${prefix}_${ortho_method}.svg --to_csv"
      if [ -s "${o}/08-Coalescent-based_trees/${ortho_method}/06-PhyParts_PieCharts/wASTRAL_PhyPartsPieCharts_${prefix}_${ortho_method}.svg" ]; then
        stage5_info_main "Finish"
      else
        stage5_error "Fail to run phypartspiecharts.py."
        stage5_blank_main ""
      fi
    fi
  }

  run_sortadate(){
    local final_ASTRAL_rr_tree="${o}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/ASTRAL_${prefix}_${ortho_method}_sorted_rr.tre"
    local final_wASTRAL_rr_tree="${o}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/wASTRAL_${prefix}_${ortho_method}_bootstrap_sorted_rr.tre"
    local input_gene_rr_trees="${o}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees/"
    local sortadate_results_dir_astral="${o}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_ASTRAL_results"
    local sortadate_results_dir_wastral="${o}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_wASTRAL_results"

    stage5_info_main "Optional step: Running SortaDate to select clock-like genes to recalculate the branch length of ASTRAL and wASTRAL trees"

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
      stage5_cmd "${log_mode}" "python ${script_dir}/../dependencies/Sortadate/get_var_length.py ${input_gene_rr_trees} --flend _rr.tre --outf ${sortadate_results_dir_astral}/step1_result.txt --outg ${og_params}"
      python "${script_dir}/../dependencies/Sortadate/get_var_length.py" "${input_gene_rr_trees}" \
      --flend "_rr.tre" \
      --outf "${sortadate_results_dir_astral}/step1_result.txt" \
      --outg "${og_params}" > /dev/null 2>&1
      
      # sortadate step 02
      stage5_cmd "${log_mode}" "python ${script_dir}/../dependencies/Sortadate/get_bp_genetrees.py ${input_gene_rr_trees} ${final_ASTRAL_rr_tree} --flend _rr.tre --outf ${sortadate_results_dir_astral}/step1_result.txt"
      python "${script_dir}/../dependencies/Sortadate/get_bp_genetrees.py" "${input_gene_rr_trees}" "${final_ASTRAL_rr_tree}" \
      --flend _rr.tre \
      --outf "${sortadate_results_dir_astral}/step2_result.txt" > /dev/null 2>&1

      # sortadate step 03
      stage5_cmd "${log_mode}" "python ${script_dir}/../dependencies/Sortadate/combine_results.py ${sortadate_results_dir_astral}/step1_result.txt ${sortadate_results_dir_astral}/step2_result.txt --outf ${sortadate_results_dir_astral}/step3_result.txt"
      python "${script_dir}/../dependencies/Sortadate/combine_results.py" "${sortadate_results_dir_astral}/step1_result.txt" "${sortadate_results_dir_astral}/step2_result.txt" \
      --outf "${sortadate_results_dir_astral}/step3_result.txt" > /dev/null 2>&1

      # sortadate step 04
      stage5_cmd "${log_mode}" "python ${script_dir}/../dependencies/Sortadate/get_good_genes.py ${sortadate_results_dir_astral}/step3_result.txt --max ${sortadate_genes_num} --outf ${sortadate_results_dir_astral}/Selected_sortadate_alignments_for_dating_info.txt"
      python "${script_dir}/../dependencies/Sortadate/get_good_genes.py" "${sortadate_results_dir_astral}/step3_result.txt" \
      --max "${sortadate_genes_num}" \
      --outf "${sortadate_results_dir_astral}/Selected_sortadate_alignments_for_dating_info.txt" > /dev/null 2>&1
      rm "${sortadate_results_dir_astral}"/step*
      sed '1d' "${sortadate_results_dir_astral}/Selected_sortadate_alignments_for_dating_info.txt" | cut -f1 -d' ' | sed 's/_rr\.tre$/.trimmed.aln.fasta/g' > "${sortadate_results_dir_astral}/Selected_sortadate_alignments_for_dating_list.txt"
    fi
    if [ "${run_wastral}" = "TRUE" ]; then
      mkdir -p "${sortadate_results_dir_wastral}"
      # sortadate step 01
      stage5_cmd "${log_mod}" "python ${script_dir}/../dependencies/Sortadate/get_var_length.py ${input_gene_rr_trees} --flend _rr.tre --outf ${sortadate_results_dir_wastral}/step1_result.txt --outg ${og_params}"
      python "${script_dir}/../dependencies/Sortadate/get_var_length.py" "${input_gene_rr_trees}" \
      --flend "_rr.tre" \
      --outf "${sortadate_results_dir_wastral}/step1_result.txt" \
      --outg "${og_params}" > /dev/null 2>&1

      # sortadate step 02
      stage5_cmd "${log_mode}" "python ${script_dir}/../dependencies/Sortadate/get_bp_genetrees.py ${input_gene_rr_trees} ${final_wASTRAL_rr_tree} --flend _rr.tre --outf ${sortadate_results_dir_wastral}/step1_result.txt"
      python "${script_dir}/../dependencies/Sortadate/get_bp_genetrees.py" "${input_gene_rr_trees}" "${final_wASTRAL_rr_tree}" \
      --flend _rr.tre \
      --outf "${sortadate_results_dir_wastral}/step2_result.txt" > /dev/null 2>&1

      # sortadate step 03
      stage5_cmd "${log_mode}" "python ${script_dir}/../dependencies/Sortadate/combine_results.py ${sortadate_results_dir_wastral}/step1_result.txt ${sortadate_results_dir_wastral}/step2_result.txt --outf ${sortadate_results_dir_wastral}/step3_result.txt"
      python "${script_dir}/../dependencies/Sortadate/combine_results.py" "${sortadate_results_dir_wastral}/step1_result.txt" "${sortadate_results_dir_wastral}/step2_result.txt" \
      --outf "${sortadate_results_dir_wastral}/step3_result.txt" > /dev/null 2>&1

      # sortadate step 04
      stage5_cmd "${log_mode}" "python ${script_dir}/../dependencies/Sortadate/get_good_genes.py ${sortadate_results_dir_wastral}/step3_result.txt --max ${sortadate_genes_num} --outf ${sortadate_results_dir_wastral}/Selected_wASTRAL_alignments_for_dating_info.txt"
      python "${script_dir}/../dependencies/Sortadate/get_good_genes.py" "${sortadate_results_dir_wastral}/step3_result.txt" \
      --max "${sortadate_genes_num}" \
      --outf "${sortadate_results_dir_wastral}/Selected_wASTRAL_alignments_for_dating_info.txt" > /dev/null 2>&1
      rm "${sortadate_results_dir_wastral}"/step*
      sed '1d' "${sortadate_results_dir_wastral}/Selected_wASTRAL_alignments_for_dating_info.txt" | cut -f1 -d' ' | sed 's/_rr\.tre$/.trimmed.aln.fasta/g' > "${sortadate_results_dir_wastral}/Selected_sortadate_alignments_for_dating_list.txt"
    fi

  }

  run_coalescent_trees() {
    local ortho_method="$1"
    
    stage5_info_main "Infering ${ortho_method} coalescent-based tree ..."
    #############################################
    #01：Constructing single gene trees
    #############################################
    if [ "${skip_genetree_for_coalescent}" != "TRUE" ]; then
    if [ -d "${o}/08-Coalescent-based_trees/${ortho_method}" ]; then
      rm -rf "${o}/08-Coalescent-based_trees/${ortho_method}"
    fi
    mkdir -p ${o}/08-Coalescent-based_trees/${ortho_method}/01-Gene_trees
    > "${o}/08-Coalescent-based_trees/${ortho_method}/Removed_alignments_with_less_than_5_seqs_list.txt"
    > "${o}/08-Coalescent-based_trees/${ortho_method}/Final_alignments_for_coalscent_list.txt"
    cd ${o}/04-Alignments/${ortho_method}/
    define_threads "astral" "stage5_logfile"
    for Gene in *.trimmed.aln.fasta; do
      if [ $(grep -c '^>' "${Gene}") -lt 5 ]; then
        echo "$Gene" >> "${o}/08-Coalescent-based_trees/${ortho_method}/Removed_alignments_with_less_than_5_seqs_list.txt"
      else
        echo "$Gene" >> "${o}/08-Coalescent-based_trees/${ortho_method}/Final_alignments_for_coalscent_list.txt"
      fi
    done
    
    total_sps=$(awk 'NF' "${o}/08-Coalescent-based_trees/${ortho_method}/Final_alignments_for_coalscent_list.txt" | wc -l)
    init_parallel_env "$work_dir" "$total_sps" "$process" "${o}/08-Coalescent-based_trees/${ortho_method}/Final_alignments_for_coalscent_list.txt" || exit 1
    stage5_info_main "Step1: Constructing single gene trees for ${ortho_method} alignments"
    stage5_info_main "====>> Constructing single gene trees for ${ortho_method} alignments (${process} in parallel) ====>>"
    
    while IFS= read -r line || [ -n "$line" ]; do
      Genename=$(basename "$line" .trimmed.aln.fasta)
      if [ "${process}" != "all" ]; then
        read -u1000
      fi
      {
        update_start_count "$line" "$stage5_logfile"
        run_raxml_sg "${ortho_method}" "${Genename}"
        if [ ! -s "${o}/08-Coalescent-based_trees/${ortho_method}/01-Gene_trees/${Genename}/RAxML_bestTree.${Genename}.tre" ]; then
          record_failed_sample "$line"
		  continue
        else
          update_finish_count "$Genename" "$stage5_logfile"
        fi
        if [ "${process}" != "all" ]; then
            echo >&1000
        fi
      } &
    done < "${o}/08-Coalescent-based_trees/${ortho_method}/Final_alignments_for_coalscent_list.txt"
    wait
    echo
    if [ "${log_mode}" = "full" ]; then
      display_process_log "$stage5_logfile" "stage5" "Failed to construct single gene trees for ${ortho_method} alignments:"
    fi
    stage5_blank "${log_mode}" ""
    fi

    #############################################
    #02：Reroot the gene trees via mad(R) or phyx
    #############################################
    stage5_info_main "Step2: Rerooting single-gene trees via mad(R) and phyx"
    mkdir -p "${o}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees"
    total_sps=$(awk 'NF' "${o}/08-Coalescent-based_trees/${ortho_method}/Final_alignments_for_coalscent_list.txt" | wc -l)
    # Initialize parallel environment
    init_parallel_env "$work_dir" "$total_sps" "$process" "${o}/08-Coalescent-based_trees/${ortho_method}/Final_alignments_for_coalscent_list.txt" || exit 1
    stage5_info_main "====>> Rerooting single-gene trees via mad(R) and phyx (${process} in parallel) ====>>"
    while IFS= read -r line || [ -n "$line" ]; do
      if [ "${process}" != "all" ]; then
        read -u1000
      fi
      {
      Genename=$(basename "$line" .trimmed.aln.fasta)
      update_start_count "$Genename" "$stage5_logfile"
      # Initializes the row counter
      counter=1
      # Dynamically create variables og1, og2, og3...
      while IFS= read -r line || [ -n "$line" ]; do
        eval "og${counter}=\"${line}\""
        counter=$((counter + 1))
      done < "${i}/Outgroup.txt"
      # Dynamically build the parameters of the nw reroot command
      cmd="Rscript ${script_dir}/Reroot_genetree_phyx_mad.R ${Genename} ${o}/08-Coalescent-based_trees/${ortho_method}"
      # Create a temporary variable to hold all og variables
      j=1
      og_param=""
      while [ $j -lt $counter ]; do
          var_name="og$j"
          eval "current_ogs=\$$var_name"
          if [ $j -eq 1 ]; then
              og_param=" ${current_ogs}"
          else
              og_param="${og_params2} ${current_ogs}"
          fi
          j=$((j + 1))
      done
      cmd="${cmd}${og_param}"
      stage5_cmd "${log_mode}" "${cmd}"
      eval "${cmd}" > /dev/null 2>&1
      if [ ! -s "${o}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees/${Genename}_rr.tre" ]; then
        record_failed_sample "$Genename"
        continue
      else
        update_finish_count "$Genename" "$stage5_logfile"
        echo ${Genename} >> "${o}/08-Coalescent-based_trees/${ortho_method}/Final_genes_for_coalscent_list.txt"
      fi
      if [ "${process}" != "all" ]; then
          echo >&1000
      fi
    } &
    done < "${o}/08-Coalescent-based_trees/${ortho_method}/Final_alignments_for_coalscent_list.txt"
    wait
    echo
    if [ "${log_mode}" = "full" ]; then
      display_process_log "$stage5_logfile" "stage5" "Failed to reroot single-gene trees for ${ortho_method} alignments:"
    fi
    stage5_blank "${log_mode}" ""

    #############################################
    #03：Merge all tree files ###################
    #############################################
    stage5_info_main "Step3: Merge all tree files"
    mkdir -p ${o}/08-Coalescent-based_trees/${ortho_method}/03-Combined_gene_trees
    > ${o}/08-Coalescent-based_trees/${ortho_method}/03-Combined_gene_trees/${prefix}_${ortho_method}_combined.tre
    awk '1' ${o}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees/*_rr.tre >> ${o}/08-Coalescent-based_trees/${ortho_method}/03-Combined_gene_trees/${prefix}_${ortho_method}_combined.tre
    cd "${o}/08-Coalescent-based_trees/${ortho_method}/03-Combined_gene_trees"

    #############################################
    #04：Run ASTRAL or wASTRAL ##################
    #############################################
    # 01-Infer the ASTRAL coalescent-based tree 
    stage5_info_main "Step4: Run ASTRAL or wASTRAL"
    mkdir -p ${o}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree
    if [ "${run_astral}" = "TRUE" ]; then
      run_astral "${o}/08-Coalescent-based_trees/${ortho_method}/03-Combined_gene_trees/${prefix}_${ortho_method}_combined.tre" "${o}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/ASTRAL_${prefix}_${ortho_method}"
    fi
    if [ "${run_wastral}" = "TRUE" ]; then
      run_wastral "${o}/08-Coalescent-based_trees/${ortho_method}/03-Combined_gene_trees/${prefix}_${ortho_method}_combined.tre" "${o}/08-Coalescent-based_trees/${ortho_method}/04-Species_tree/wASTRAL_${prefix}_${ortho_method}.tre" "${o}/08-Coalescent-based_trees/${ortho_method}/Final_genes_for_coalscent_list.txt"
    fi

    ############################################################
    #05：Caculate the branch length for ASTRAL results via RAxMl
    ############################################################
    stage5_blank "${log_mode}" ""
    stage5_info_main "Step5: Recaculate the branch length via RAxMl"
    if [ -d "${o}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/" ]; then
      rm -rf "${o}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/"
    fi
    if [ "${run_astral}" = "TRUE" ]; then
      calculate_branch_length "Supermatrix_for_recalculating_bl.fasta" \
      "${o}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/alignments" \
      "${o}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree" \
      "${o}/08-Coalescent-based_trees/${ortho_method}/Final_alignments_for_coalscent_list.txt" \
      "ASTRAL"
    fi
    if [ "${run_wastral}" = "TRUE" ]; then
      calculate_branch_length "Supermatrix_for_recalculating_bl.fasta" \
      "${o}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/alignments" \
      "${o}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree" \
      "${o}/08-Coalescent-based_trees/${ortho_method}/Final_alignments_for_coalscent_list.txt" \
      "wASTRAL"
    fi
    if [ -d "${o}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/alignments" ]; then
      rm -rf "${o}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/alignments"
    fi

    ############################################################
    #Optional step：Run SortaDate to sort clock-like genes #####
    ############################################################
    if [ "${run_sortadate}" = "TRUE" ]; then
      run_sortadate "${o}/08-Coalescent-based_trees/${ortho_method}/02-Rerooted_gene_trees/" 
      if [ "${run_astral}" = "TRUE" ]; then
        calculate_branch_length_sortadate "Sortadate_supermatrix_for_recalculating_bl.fasta" \
        "${o}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_ASTRAL_results" \
        "${o}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_ASTRAL_results/Selected_sortadate_alignments_for_dating_list.txt" \
        "ASTRAL"
        if [ -s "${o}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_ASTRAL_results/ASTRAL_sortadate_${prefix}_${ortho_method}_sorted_bl_rr.tre" ]; then
          stage5_info "${log_mode}" "The sorted, rerooted, and recalculated branch length tree has been written to ${o}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_ASTRAL_results/ASTRAL_sortadate_${prefix}_${ortho_method}_sorted_bl_rr.tre"
        else
          stage5_error "Fail"
        fi
      fi
      if [ "${run_wastral}" = "TRUE" ]; then
        calculate_branch_length_sortadate "Sortadate_supermatrix_for_recalculating_bl.fasta" \
        "${o}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_wASTRAL_results" \
        "${o}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_wASTRAL_results/Selected_sortadate_alignments_for_dating_list.txt" \
        "wASTRAL"
        if [ -s "${o}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_wASTRAL_results/wASTRAL_sortadate_${prefix}_${ortho_method}_sorted_bl_rr.tre" ]; then
          stage5_info "${log_mode}" "The sorted, rerooted, and recalculated branch length tree has been written to ${o}/08-Coalescent-based_trees/${ortho_method}/05-Recalculated_bl_species_tree/SortaDate_ASTRAL_results/wASTRAL_sortadate_${prefix}_${ortho_method}_sorted_bl_rr.tre"
        else
          stage5_error "Fail to run SortaDate for wASTRAL results and recalculate the branch length."
        fi
      fi
    fi

    ############################################################
    #06: Run PhyParts_PieCharts
    ############################################################
    stage5_blank "${log_mode}" ""
    stage5_info_main "Step6: Run PhyParts_PieCharts"
    run_phyparts_piecharts "${ortho_method}"
    stage5_blank_main ""
  }
  conda_activate "stage5" "${conda1}"
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
stage5_info_main "Successfully finishing the stage 5: Phylogenetic tree inference."
stage5_info "${log_mode}" "The resulting files have been saved in ${o}/06-Modeltest-NG/ or ${o}/07-Concatenation-based_trees or 08-Coalescent-based_trees."

# Clean up environment
cleanup_parallel_env "$work_dir"
stage5_info_main "Thank you for using HybSuite! Enjoy your research!"
stage5_blank_main ""
exit 1
############################################################################################
