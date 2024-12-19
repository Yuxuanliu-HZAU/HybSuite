#!/bin/bash
# Script Name: HybSuite.sh
# Author: Yuxuan Liu
#===> Preparation and HybSuite Checking <===#
#Options setting
###set the run name:
current_time=$(date +"%Y-%m-%d %H:%M:%S")
function display_help {
  echo "=======> HybSuite v. 1.1.0 released on 10.20.2024 by The Sun Lab. <==============="
  echo "Welcome to use HybSuite.sh! "
  echo "HybSuite is an integrated pipeline which is used to do phylogenomic analysis efficiently via NGS data."
  echo "Helping to reconstruct phylogenetic trees from NGS raw data by one single run."
  echo "=================================================================================="
  echo "Developed by: Yuxuan Liu.
Contributors: Miao Sun, Yiying Wang, Xueqin Wang, Liguo Zhang, Tao Xiong , Xiaotong Niu, Xinru Zhang, Xiaowen Ma, Tianxiang Li.
Latest version: https://github.com/Yuxuanliu-HZAU/HybSuite.git
If you have any questions/problems/suggestions，please visit: https://github.com/Yuxuanliu-HZAU/HybSuite"
  echo "Or contact me via email: 1281096224@qq.com."
  echo "=================================================================================="
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
  echo ""
  sed -n '6,$p' ../config/HybSuite_help.txt
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
cd "$script_dir" || { echo "Error: Failed to change directory."; exit 1; }
while IFS= read -r line || [ -n "$line" ]; do
  var=$(echo "${line}" | awk '{print $1}')
  default=$(echo "${line}" | awk '{print $2}')
  eval "${var}=''"
  eval "Default_${var}='${default}'"
  eval "found_${var}=false"
done < ../config/HybSuite_vars_list.txt

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
  echo "=======> HybSuite v. 1.1.0 released on 10.20.2024 by The Sun Lab. <==============="
  echo "Welcome to use HybSuite.sh! "
  echo "HybSuite is a bash script which is used to resolve phylogenomic issues on the basis of HybPiper."
  echo "It will help you reconstruct phylogenetic trees from NGS data by only one run, using HybPiper and ParaGone to find ortholog genes."
  echo "=================================================================================="
  echo "Developed by: Yuxuan Liu.
Contributors: Miao Sun, Yiying Wang, Xueqin Wang, Liguo Zhang, Tao Xiong , Xiaotong Niu, Xinru Zhang, Xiaowen Ma, Tianxiang Li.
Latest version: https://github.com/Yuxuanliu-HZAU/HybSuite.git
If you have any questions/problems/suggestions，please visit: https://github.com/Yuxuanliu-HZAU/HybSuite"
  echo "Or contact me via email: 1281096224@qq.com."
  echo "=================================================================================="
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
  echo ""
echo "[HybSuite-CMD]:     $0 $@"
#echo "[HybSuite-INFO]:    HybSuite was called with these options:"
if [[ $# -eq 0 ]]; then
  echo ""
  echo "[HybSuite-WARNING]: You didn't set any options ."
  echo "                    Please set necessary options to run HybSuite. (use -h to check options)"
  echo "                    HybSuite exits."
  echo ""
  exit 1
fi
run_all=false
run_to_database=false
run_to_hybpiper=false
run_to_alignments=false
run_to_trees=false

if [[ "$1" != "--run_all" && "$1" != "--run_to_database" && "$1" != "--run_to_hybpiper" && "$1" != "--run_to_alignments" && "$1" != "--run_to_trees" ]]; then
    echo "[HybSuite-ERROR]:   Invalid first option '$1'."
    echo "                    To specify which stage the script runs to, "
    echo "                    the first option must be one of '--run_all', '--run_to_database', '--run_to_hybpiper', '--run_to_alignments', or '--run_to_trees'."
    echo "                    HybSuite exits."
    echo ""
    exit 1
else
    if [[ "$1" == "--run_all" ]]; then
      run_all=true
    elif [[ "$1" == "--run_to_database" ]]; then
      run_to_database=true
    elif [[ "$1" == "--run_to_hybpiper" ]]; then
      run_to_hybpiper=true
    elif [[ "$1" == "--run_to_alignments" ]]; then
      run_to_alignments=true
    elif [[ "$1" == "--run_to_trees" ]]; then
      run_to_trees=true
    fi
fi
if [[ $# -eq 1 ]]; then
  echo "[HybSuite-WARNING]: Except the first option, you didn't set any other required options."
  echo "                    Please set required options to run HybSuite. (use -h to check options)"
  echo "                    HybSuite exits."
  echo ""
  exit 1
fi
if [[ "$2" = "--run_all" || "$2" = "--run_to_database" || "$2" = "--run_to_hybpiper" || "$2" = "--run_to_alignments" || "$2" = "--run_to_trees" ]]; then
    echo "[HybSuite-ERROR]:   Sorry, you can't specify the stage to run to more than once!"
    echo "                    Please specify one of '--run_all', '--run_to_database', '--run_to_hybpiper', '--run_to_alignments', or '--run_to_trees' only once!"
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
            vars=($(awk '{print $1}' ${script_dir}/../config/HybSuite_vars_list.txt))
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
              echo "$option" >> ./Option-list.txt
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
cut -f 1 ../config/HybSuite_vars_list.txt > ./Option-all-list.txt
sort ./Option-all-list.txt ./Option-list.txt|uniq -u > ./Option-default-list.txt

while read -r line; do
    default_var="Default_${line}"
    default_value="${!default_var}"
    eval "default_value=${default_value}"
    eval "${line}=\"${default_value}\""
    #echo "                    Default argument for -${line}: ${default_value}"
done < ./Option-default-list.txt
rm ./Option*

# Define OI and tree
HRS="FALSE"
RAPP="FALSE"
MO="FALSE"
MI="FALSE"
RT="FALSE"
one_to_one="FALSE"

if echo "${OI}" | grep -q "1"; then
  HRS="TRUE"
fi
if echo "${OI}" | grep -q "2"; then
  RAPP="TRUE"
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
  run_paragone="TRUE"
fi
if echo "${OI}" | grep -q "b"; then
  run_phylopypruner="TRUE"
fi
if [ "${OI}" = "all" ]; then
  HRS="TRUE"
  RAPP="TRUE"
  LS="TRUE"
  MO="TRUE"
  MI="TRUE"
  RT="TRUE"
  one_to_one="TRUE"
  run_paragone="TRUE"
fi
if ([ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "${one_to_one}" = "TRUE" ]) && [ "${run_paragone}" = "FALSE" ] && [ "${run_phylopypruner}" = "FALSE" ]; then
  run_paragone="TRUE"
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

# Define skipping running
run_hybpiper_stats_to_paralog="TRUE"
add_other_seqs="TRUE"
skip_paragone="FALSE"
if echo "${skip_running}" | grep -q "1"; then
  run_hybpiper_stats_to_paralog="FALSE"
fi
if echo "${skip_running}" | grep -q "2"; then
  add_other_seqs="FALSE"
fi
if echo "${skip_running}" | grep -q "3"; then
  skip_paragone="TRUE"
fi

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

#Preparation
mkdir -p "${o}/00-logs_and_reports/logs"
stage0_info() {
  echo "[HybSuite-INFO]:    $1" | tee -a "${o}/00-logs_and_reports/logs/HybSuite_Checking_${current_time}.log"
}
stage0_info2() {
  echo "[HybSuite-INFO]:$1" | tee -a "${o}/00-logs_and_reports/logs/HybSuite_Checking_${current_time}.log"
}
stage0_warning() {
  echo "[HybSuite-WARNING]: $1" | tee -a "${o}/00-logs_and_reports/logs/HybSuite_Checking_${current_time}.log"
}
stage0_attention() {
  echo "[ATTENTION]:        $1" | tee -a "${o}/00-logs_and_reports/logs/HybSuite_Checking_${current_time}.log"
}
stage0_error() {
  echo "[HybSuite-ERROR]:   $1" | tee -a "${o}/00-logs_and_reports/logs/HybSuite_Checking_${current_time}.log"
}
stage0_cmd() {
  echo "[HybSuite-CMD]:     $1" | tee -a "${o}/00-logs_and_reports/logs/HybSuite_Checking_${current_time}.log"
}
stage0_blank() {
  echo "$1" | tee -a "${o}/00-logs_and_reports/logs/HybSuite_Checking_${current_time}.log"
}
stage0_blank2() {
  echo "                    $1" | tee -a "${o}/00-logs_and_reports/logs/HybSuite_Checking_${current_time}.log"
}

#HybSuite CHECKING
#Step 1: Check necessary options
if [ "${skip_checking}" != "TRUE" ]; then
  stage0_blank ""
  stage0_info "<<<======= HybSuite CHECKING =======>>>"
  stage0_info "HybSuite will provide tips with [ATTENTION]."
  stage0_info "HybSuite will alert you to incorrect arguments with [HybSuite-WARNING]:."
  stage0_info "HybSuite will notify you of missing software with [ERROR], and then it will exit."
  stage0_blank ""
  stage0_info2 " => Step 1: Check necessary options" 
  stage0_info "Check if you have entered all necessary options ... "
  ###Verify if the user has entered the necessary parameters
  if [ "${i}" = "_____" ] || [ "${conda1}" = "_____" ] || [ "${conda2}" = "_____" ] || [ "${t}" = "_____" ]; then
    stage0_info "After checking:"
    stage0_error "You haven't set all the necessary options."
    stage0_blank "                    All required options must be set."
    stage0_blank "                    Including: "
    stage0_blank "                    -i"
    stage0_blank "                    -t"
    stage0_blank "                    -conda1"
    stage0_blank "                    -conda2"
    stage0_blank ""
    stage0_blank "                    HybSuite exits."
    stage0_blank ""
    exit 1
  fi
  stage0_info "Well done!"
  stage0_blank "                    You have entered all required options."
  stage0_blank ""
  if [ -s "${i}/SRR_Spname.txt" ]; then
    sed -i '/^$/d' "${i}/SRR_Spname.txt"
  fi
  if [ -s "${i}/My_Spname.txt" ]; then
    sed -i '/^$/d' "${i}/My_Spname.txt"
  fi
#Step 2: Check the <input directory> and files
  ######################################################
  ### Step 2: Check the <input directory> and files ####
  ######################################################
  stage0_info2 " => Step 2: Check the <input directory> and files" 
  stage0_info "Check if you have prepared the right input directory and files ... "
  if [ ! -s "${t}" ]; then
    stage0_info "After checking:"
    stage0_warning "The target file  (reference for HybPiper) you specified doesn't exist."
    stage0_blank "                    HybSuite exits."
    stage0_blank ""
    exit 1
  fi

  if [ ! -s "${i}/SRR_Spname.txt" ] && [ ! -s "${i}/My_Spname.txt" ]; then
    stage0_info "After checking:"
    stage0_warning "You need to put at least one type of data (public/your own) in ${i}."
    stage0_blank "                    HybSuite exits."
    stage0_blank ""
    exit 1
  fi

  if [ -s "${i}/My_Spname.txt" ] && [ ! -e "${my_raw_data}" ]; then
    stage0_info "After checking:"
    stage0_warning "You need to specify the right pathway to your own raw data by -my_raw_data."
    stage0_blank "                    HybSuite exits."
    stage0_blank ""
    exit 1
  fi

  if [ ! -s "${i}/My_Spname.txt" ] && [ -e "${my_raw_data}" ]; then
    stage0_info "After checking:"
    stage0_warning "You need to offer the species list of your own raw data in ${i}/My_Spname.txt."
    stage0_blank "                    HybSuite exits."
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
  				stage0_warning "Option: -my_raw_data : The pathway to or the format of your own new raw data(format: fastq) of the species ${add_sp_names} is wrong."
  				stage0_blank "                    Please use -h to check the correct format you need to offer."
          stage0_blank "                    HybSuite exits."
          stage0_blank ""
  				first_iteration=false
  				exit 1
  			fi
  		fi
  	done < ./My_Spname.txt
  fi

  # Checking Outgroup.txt and outgroups
  if [ ! -s "${i}/Outgroup.txt" ]; then
    stage0_info "After checking:"
    stage0_warning "You need to provide at least one species name of your outgroups in ${i}/Outgroup.txt."
    stage0_blank "                    HybSuite exits."
    stage0_blank ""
    exit 1
  fi
  if [ "${other_seqs}" != "_____" ]; then
    > "${i}"/Other_seqs_Spname.txt
    for file in "${other_seqs}"/*.fasta; do
      add_sp=$(basename "${file}" .fasta)  # 提取文件名，去掉路径和扩展名
      echo "${add_sp}" >> "${i}"/Other_seqs_Spname.txt
    done
  fi
  if [ -s "./SRR_Spname.txt" ]; then
    cut -f 2 ./SRR_Spname.txt > ./NCBI_Spname_list.txt
  fi
  while IFS= read -r line || [ -n "$line" ]; do
    if [ -s "./My_Spname.txt" ]; then
      if grep -qF "$line" "./My_Spname.txt"; then
        stage0_info "Well done! Outgroup species '$line' exists in ${i}/My_Spname.txt"
      fi
    elif [ -s "./SRR_Spname.txt" ]; then
      if grep -qF "$line" "./NCBI_Spname_list.txt"; then
        stage0_info "Well done! Outgroup species '$line' exists in ${i}/SRR_Spname.txt"
      fi
    elif [ "${other_seqs}" != "_____" ] && grep -qF "^$line$" "${i}"/Other_seqs_Spname.txt; then
      stage0_info "Well done! The sequence of Outgroup species '$line' exists in ${other_seqs}"
    else
      stage0_warning "Your My_Spname.txt and SRR_Spname.txt don't contain any outgroup species."
    	stage0_blank "                    Please add your outgroup species names from ${i}/Outgroup.txt to either ${i}/SRR_Spname.txt or ${i}/My_Spname.txt."
      stage0_blank "                    HybSuite exits."
      stage0_blank ""
      exit 1
    fi
  done < "./Outgroup.txt"
  if [ -s "./Other_seqs_Spname.txt" ]; then
    rm ./Other_seqs_Spname.txt
  fi
  # Deliever congratulations messages
  stage0_blank ""
  stage0_info "Well done!"
  stage0_blank "                    You have prepared all necessary folders and files."
  stage0_blank "                    Moving on to the next step ..."
  stage0_blank ""
#Step 3: Check dependencies
  ###################################
  ### Step 3: Check dependencies ####
  ###################################
  stage0_info2 " => Step 3: Check dependencies" 
  ###Verify if all conda environments have the required dependency software installed
  stage0_info "Check if all conda environments have the required dependency softwares installed ... "
  # sra-tools
  check_sra() {
    stage0_info "You plan to download NGS raw data, so software 'sra-tools' must exist in your conda environment ${conda1}."
    stage0_info "Or both fasterq-dump and prefetch should have been figured and added to the system's environment variables."
    stage0_info "Check if fasterq-dump has been configured or sra-tools has been installed in ${conda1} environment... "
    if ! conda list -n "${conda1}" | grep -q "^sra-tools\b" && ! command -v prefetch >/dev/null 2>&1 && ! command -v fasterq-dump >/dev/null 2>&1; then
      stage0_error "No software 'sra-tools' is found in ${conda1} conda environment."
      stage0_error "Or dependency fasterq-dump and prefetch haven't been configured and added to the system's environment variables."
      stage0_blank "                    You should install software 'sra-tools' in ${conda1} conda environment."
      stage0_blank "                    Or you can search for more information on https://github.com/glarue/fasterq_dump."
      stage0_blank "                    Recommended Command:"
      stage0_blank "                    mamba install bioconda::sra-tools -y"
      stage0_blank "                    HybSuite exits."
      stage0_blank ""
      exit 1
    elif ! conda list -n "${conda1}" | grep -q "^sra-tools\b" && command -v prefetch >/dev/null 2>&1 && ! command -v fasterq-dump >/dev/null 2>&1; then
      stage0_info "No software 'sra-tools' is in the '${conda1}' conda environment, but it will be OK if you have installed SraToolKit on your system."
      stage0_error "It seems that you have downloaded SraToolKit on your system, but fasterq-dump hasn't been configured."
      stage0_blank "                    Please configure fasterq-dump."
      stage0_blank "                    HybSuite exits."
      stage0_blank ""
      exit 1
    elif ! conda list -n "${conda1}" | grep -q "^sra-tools\b" && ! command -v prefetch >/dev/null 2>&1 && command -v fasterq-dump >/dev/null 2>&1; then
      stage0_info "No software 'sra-tools' is in the '${conda1}' conda environment, but it will be OK if you have installed SraToolKit on your system."
      stage0_error "It seems that you have downloaded SraToolKit on your system, but prefetch hasn't been configured."
      stage0_blank "                    Please configure prefetch."
      stage0_blank "                    HybSuite exits."
      stage0_blank ""
      exit 1
    else
      stage0_info "PASS"
      stage0_info "Well done!"
      stage0_info "Both 'prefetch' and 'fasterq-dump' are ready."
      stage0_info "Moving on to the next step ..."
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
        stage0_info "All species in ${i}/SRR_Spname.txt have been downloaded before."
        stage0_blank "                    So skip checking 'preftch' and 'fasterq-dump'."
      fi
      rm ./Existed_dd_list.txt
      rm ./Dd_list_final.txt
    else
      check_sra
    fi
  else
    stage0_info "PASS"
  fi
  }

  check_pigz() {
    if [ "$download_format" = "fastq_gz" ] && [ -s "${i}/SRR_Spname.txt" ]; then
      stage0_info "You plan to download NGS data with fq.gz format to do downstream analysis, so 'pigz' must exist in conda environment ${conda1}."
      if ! conda list -n "${conda1}" | grep -q "^pigz\b"; then
        stage0_error "However, no software 'pigz' exists in the conda environment ${conda1}."
        stage0_blank "                    You need to install 'pigz' in the conda environment ${conda1}."
        stage0_blank "                    Recommended Command:"
        stage0_blank "                    mamba install conda-forge::pigz -y"
        stage0_blank "                    HybSuite exits."
        stage0_blank ""
        exit 1
      else
        stage0_info "PASS"
        stage0_blank ""
      fi
    fi
  }
  
  check_hybpiper() {
    stage0_info "You plan to run HybPiper pipeline, so software 'HybPiper' must exist in your conda environment ${conda1}."
    if ! conda list -n "${conda1}" | grep -q "^hybpiper\b"; then
      stage0_warning "There is no software named HybPiper in the conda environment ${conda1}."
      stage0_blank "                    You should install the software HybPiper in the conda environment ${conda1}."
      stage0_blank "                    Recommended Command:"
      stage0_blank "                    mamba install bioconda::hybpiper -y"
      stage0_blank "                    HybSuite exits."
      stage0_blank ""
      exit 1
    else
      stage0_info "PASS"
      stage0_blank ""
    fi
  }
  
  check_paragone() {
    stage0_info "Check dependencies in ${conda2} conda environment ... "
    if ([ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "$one_to_one" = "TRUE" ]) && [ "${run_paragone}" = "TRUE" ]; then
      stage0_info "You plan to run MI/MO/RT/1to1 via ParaGone, so 'paragone' must exist in conda environment ${conda1}."
      if ! conda list -n "${conda2}" | tee /dev/null | grep -q "^paragone\b"; then
        stage0_error "However, no software ParaGone in the conda environment ${conda2}."
        stage0_blank "                    You should install the software ParaGone in the conda environment ${conda2}."
        stage0_blank "                    Recommended Command:"
        stage0_blank "                    mamba install bioconda::paragone -y"
        stage0_blank "                    HybSuite exits."
        stage0_blank ""
        exit 1
      else
        stage0_info "PASS"
        stage0_blank ""
      fi
    fi
  }

  check_modeltest_ng() {
    if [ "${run_modeltest_ng}" != "TRUE" ]; then
      stage0_info "You plan to use Modeltest-NG to get the best evolution model, so 'modeltest-ng' must exist in conda environment ${conda1}."
      if ! conda list -n "${conda1}" | grep -q "^modeltest-ng\b"; then
        stage0_error "However, no software 'modeltest-ng' is in the conda environment ${conda1}."
        stage0_blank "                    You need to install 'modeltest-ng' in the conda environment ${conda1}."
        stage0_blank "                    Recommended Command:"
        stage0_blank "                    mamba install bioconda::modeltest-ng -y"
        stage0_blank "                    HybSuite exits."
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
      stage0_info "You plan to run iqtree, so software 'iqtree' must exist in your conda environment ${conda1}."
      stage0_info "Check IQ-TREE... "
      if ! conda list -n "${conda1}" | grep -q "^iqtree\b"; then
        stage0_error "However, no software 'iqtree' is in the conda environment ${conda1}."
        stage0_blank "                    You should install the software 'iqtree' in ${conda1} environment."
        stage0_blank "                    Recommended Command:"
        stage0_blank "                    mamba install bioconda::iqtree -y"
        stage0_blank "                    HybSuite exits."
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
      stage0_info "You plan to run raxml, so software 'raxml' must exist in your conda environment ${conda1}."
      stage0_info "Check RAxML... "
      if ! conda list -n "${conda1}" | grep -q "^raxml\b"; then
        stage0_error "However, no software 'raxml' is in the conda environment ${conda1}."
        stage0_blank "                    You should install the software 'raxml' in ${conda1} environment."
        stage0_blank "                    Recommended Command:"
        stage0_blank "                    mamba install bioconda::raxml -y"
        stage0_blank "                    HybSuite exits."
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
      stage0_info "You plan to run raxml-ng, so software 'raxml-ng' must exist in your conda environment ${conda1}."
      stage0_info "Check RAxML-NG... "
      if ! conda list -n "${conda1}" | grep -q "^raxml-ng\b"; then
        stage0_error "However, no software 'raxml-ng' is in the conda environment ${conda1}."
        stage0_blank "                    You should install the software 'raxml-ng' in ${conda1} environment."
        stage0_blank "                    Recommended Command:"
        stage0_blank "                    mamba install bioconda::raxml-ng -y"
        stage0_blank "                    HybSuite exits."
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
      stage0_info "Check wASTRAL ... "
      if [ ! -s "${wastral_dir}/bin/wastral" ]; then
        stage0_error "You plan to run wASTRAL,"
        stage0_blank "                    so software 'wASTRAL' must have been installed in ${wastral_dir} (specified by option -wastral_dir)."
        stage0_blank "                    However, no software 'wASTRAL' has been installed or you didn't specify a right directory for wastral."
        stage0_info "You should install the software 'wASTRAL' and add its root directory to the system environment variables."
        stage0_blank "                    HybSuite exits."
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
      stage0_info "Check 'newick_utils' in ${conda1} environment ..."
      if ! grep -q "^newick_utils\b" <(conda list -n "${conda1}"); then
        stage0_error "You plan to run wASTRAL/ASTRAL-III,"
        stage0_blank "                    so software 'newick_utils' must have been installed in ${conda1} environment (specified by option -conda1)."
        stage0_blank "                    However, no software 'newick_utils' exists in the conda environment ${conda1}."
        stage0_info "You should install the software 'newick_utils' in ${conda1} environment (specified by -conda1)."
        stage0_blank "                    HybSuite exits."
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
      stage0_info "Check R package 'phytools' in ${conda1} environment ..."
      current_shell=$(basename "$SHELL")
      case "$current_shell" in
        bash)
          eval "$(conda shell.bash hook)"
          stage0_info "Bash shell detected. Conda hook loaded."
          ;;
        zsh)
          eval "$(conda shell.zsh hook)"
          echo "Zsh shell detected. Conda hook loaded."
          ;;
        sh)
          eval "$(conda shell.sh hook)"
          echo "Sh shell detected. Conda hook loaded."
          ;;
        fish)
          eval "(conda shell.fish hook)"
          echo "Fish shell detected. Conda hook loaded."
        ;;
      esac
      conda activate "${conda1}"
      if [ "$CONDA_DEFAULT_ENV" != "${conda1}" ]; then
        stage0_error "Fail to check R package 'phytools' in ${conda1} environment"
        stage0_blank "                    Because HybSuite can't activate conda environment ${conda1}."
        stage0_blank "                    Try to run Hybsuite directly in ${conda1} environment."
        stage0_blank "                    HybSuite exits."
        stage0_blank ""
        exit 1
      fi
      if Rscript -e "if (!requireNamespace('phytools', quietly = TRUE)) { quit(status = 1) }"; then
        stage0_info "PASS: R package 'phytools' is installed."
        stage0_blank ""
      else
        stage0_error "You plan to run wASTRAL/ASTRAL-III,"
        stage0_blank "                    so R package 'phytools' must be installed in the ${conda1} environment."
        stage0_blank "                    Please install 'phytools' using install.packages('phytools')."
        stage0_blank "                    HybSuite exits."
        stage0_blank ""
        exit 1
      fi
    fi
  }
  
  check_r_ape() {
    if [ "${run_astral}" = "TRUE" ] || [ "${run_wastral}" = "TRUE" ]; then
      stage0_info "Check R package 'ape' in ${conda1} environment ..."
      if Rscript -e "if (!requireNamespace('ape', quietly = TRUE)) { quit(status = 1) }"; then
        stage0_info "PASS: R package 'ape' is installed."
        stage0_blank ""
      else
        stage0_error "You plan to run wASTRAL/ASTRAL-III,"
        stage0_blank "                    so R package 'ape' must be installed in the ${conda1} environment."
        stage0_blank "                    Please install 'ape' using install.packages('ape')."
        stage0_blank "                    HybSuite exits."
        stage0_blank ""
        exit 1
      fi
    fi
  }

  check_py_phylopypruner() {
    if ([ "$LS" = "TRUE" ] || [ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "$one_to_one" = "TRUE" ]) && [ "${run_phylopypruner}" = "TRUE" ]; then
      stage0_info "Check python dependency 'phylopypruner' in ${conda1} environment ..."
      if pip show "phylopypruner" >/dev/null 2>&1; then
        stage0_info "PASS: Python package 'phylopypruner' has been installed."
        stage0_blank ""
        stage0_info "You plan to run PhyloPyPruner, so software 'fasttree' must exist in your conda environment ${conda1}."
        stage0_info "Check fasttree... "
        if ! conda list -n "${conda1}" | grep -q "^fasttree\b"; then
          stage0_error "However, no software 'fasttree' exists in the conda environment ${conda1}."
          stage0_blank "                    You should install the software 'fasttree' in ${conda1} environment."
          stage0_blank "                    Recommended Command:"
          stage0_blank "                    mamba install bioconda::fasttree -y"
          stage0_blank "                    HybSuite exits."
          stage0_blank ""
          exit 1
        else
          stage0_info "PASS"
          stage0_blank ""
        fi
      else
        stage0_error "Python package 'phylopypruner' hasn't been installed."
        stage0_blank "                    Recommended Command:"
        stage0_blank "                    pip install phylopypruner"
        stage0_blank "                    HybSuite exits."
        stage0_blank ""
        exit 1
      fi
    fi
  }

  check_py_ete3() {
  if [ "${run_astral}" = "TRUE" ] || [ "${run_wastral}" = "TRUE" ]; then
    stage0_info "Check python dependency 'ete3' in ${conda1} environment ..."
    if pip show "ete3" >/dev/null 2>&1; then
      stage0_info "PASS: Python package 'ete3' is installed."
      stage0_blank ""
    else
      stage0_error "Python package 'ete3' is not installed."
      stage0_blank "                    Recommended Command:"
      stage0_blank "                    pip install ete3"
      stage0_blank "                    HybSuite exits."
      stage0_blank ""
      exit 1
    fi
  fi
  }

  check_py_PyQt5() {
  if [ "${run_astral}" = "TRUE" ] || [ "${run_wastral}" = "TRUE" ]; then
    stage0_info "Check python dependency 'PyQt5' in ${conda1} environment ..."
    if pip show "PyQt5" >/dev/null 2>&1; then
      stage0_info "PASS: Python package 'PyQt5' is installed."
      stage0_blank ""
    else
      stage0_error "Python package 'PyQt5' is not installed."
      stage0_blank "                    Recommended Command:"
      stage0_blank "                    pip install PyQt5"
      stage0_blank "                    HybSuite exits."
      stage0_blank ""
      exit 1
    fi
  fi
  }
    
  check_r() {
  if [ "${run_astral}" = "TRUE" ] || [ "${run_wastral}" = "TRUE" ]; then
    if ! grep -q "^r\b" <(conda list -n "${conda1}"); then
        stage0_error "However, 'r' is not installed in the conda environment ${conda1}."
        stage0_blank "                    You need to install 'r' in the conda environment ${conda1}."
        stage0_blank "                    Recommended Command:"
        stage0_blank "                    mamba install r -y"
        stage0_blank "                    HybSuite exits."
        stage0_blank ""
        exit 1
    else
        stage0_info "PASS"
        stage0_blank ""
    fi
  fi
  }

  #run to database
  if [ "${run_to_database}" = "true" ]; then
    # conda1
    stage0_info "You plan to only run stage1, so HybSuite will only check ${conda1} environment."
    stage0_info "Check dependencies in ${conda1} conda environment ... "
    # conda1: sra-tools
    check_sra_tools
    # conda1: pigz
    check_pigz
  fi
  
  #run to hybpiper
  if [ "${run_to_hybpiper}" = "true" ]; then
    #conda1
    stage0_info "Check dependencies in ${conda1} conda environment ... "
    # conda1: sra-tools
    check_sra_tools
    # conda1: pigz
    check_pigz
    # conda1: hybpiper
    check_hybpiper
  fi

  trap '' SIGPIPE
  #run to alignments
  if [ "${run_to_alignments}" = "true" ]; then
    #conda1
    stage0_info "Check dependencies in ${conda1} conda environment ... "
    chars="hybpiper phyx trimal mafft"
    for dir in ${chars}; do
      if ! grep -q "^${dir}\b" <(conda list -n "${conda1}"); then
        stage0_info "You plan to run from stage1 to stage3, so 'hybpiper', 'phyx', 'trimal', and 'mafft' must exist in conda environment ${conda1}."
        stage0_error "However, no software ${dir} is in the conda environment ${conda1}."
        stage0_blank "                    You should install software ${dir} in ${conda1} environment."
        stage0_blank "                    HybSuite exits."
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
  fi

  #run to trees
  #conda1
  if [ "${run_to_trees}" = "true" ]; then
    #conda1
    stage0_info "Check dependencies in ${conda1} conda environment ... "
    chars="hybpiper phyx trimal mafft r python"
    for dir in ${chars}; do
      if ! grep -q "^${dir}\b" <(conda list -n "${conda1}"); then
        stage0_info "You plan to run from stage1 to stage4, so 'hybpiper', 'phyx', 'trimal', 'mafft', 'r', 'python' must exist in conda environment ${conda1}."
        stage0_error "However, no software ${dir} is in the conda environment ${conda1}."
        stage0_blank "                    You should install the software ${dir} in ${conda1} environment."
        stage0_blank "                    HybSuite exits."
        stage0_blank ""
        exit 1
      fi
    done
    stage0_blank ""
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
    # conda1: hybpiper
    check_hybpiper
    # conda1: phylopypruner
    check_py_phylopypruner
    # conda2: paragone
    check_paragone
    # wastral
    check_wastral
    check_r
    check_r_phytools
    check_r_ape
    check_py_PyQt5
    check_py_ete3
  fi

  #run all
  #conda1
  if [ "${run_all}" = "true" ]; then
    #conda1
    stage0_info "Check dependencies in ${conda1} conda environment ... "
    chars="hybpiper phyx trimal mafft r python"
    for dir in ${chars}; do
      if ! grep -q "^${dir}\b" <(conda list -n "${conda1}"); then
        stage0_info "You plan to run all stages, so 'hybpiper', 'phyx', 'trimal', 'mafft', 'r', 'python' must exist in conda environment ${conda1}."
        stage0_error "However, no software ${dir} is in the conda environment ${conda1}."
        stage0_blank "                    You should install the software ${dir} in ${conda1} environment."
        stage0_blank "                    HybSuite exits."
        stage0_blank ""
        exit 1
      fi
    done
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
    # wastral
    check_wastral
    check_r
    check_r_phytools
    check_r_ape
    check_py_PyQt5
    check_py_ete3
  fi

  stage0_info "Well done!"
  stage0_blank "                    You have installed all dependencies in conda environments."
  stage0_blank "                    Moving on to the next step ..."
  stage0_blank ""
#Step 4: Check if all arguments are valid
  #################################################
  ### Step 4: Check if all arguments are valid ####
  #################################################
  stage0_info2 " => Step 4: Check if all arguments are valid" 
  stage0_info "Check if all arguments are valid ..."

  if [ "${eas_dir}" != "${o}/01-HybPiper_results/01-assemble" ]; then
    if [ ! -e "$(dirname "${eas_dir}")" ]; then
      stage0_info "After verifing:"
      stage0_warning "The folder containing existed sequences generated by command 'hybpiper assemble' doesn't exist now."
      stage0_blank "                    Please check your parameters set by the option -eas . "
      stage0_blank "                    HybSuite exits."
      stage0_blank ""
      exit 1
    fi
  fi

  if [ ! -e "./SRR_Spname.txt" ]; then 
    stage0_attention "You haven't prepared the SRR_Spname.txt for HybSuite(HybSuite)."
    stage0_info "It means that you only want to use your own data rather than data from NCBI."
    stage0_blank "                    It doesn't matter. HybSuite will keep running by only using your own data."
  fi

  if [ ! -s "./My_Spname.txt" ] && [ "$my_raw_data" = "_____" ]; then 
    stage0_attention "You haven't prepared any information about your own data for HybSuite(HybSuite)."
    stage0_blank "                    It means you plan to only use sra data from NCBI to reconstruct your phylogenetic trees. "
    stage0_blank "                    It is fine and don't worry! HybSuite will keep running by only using public data."
  fi

  if (( $(echo "${sp_coverage} >= 0" | bc -l) )) && (( $(echo "${sp_coverage} <= 1" | bc -l) )); then
    stage0_blank ""
  else
    stage0_blank ""
    stage0_info "After checking:"
    stage0_warning "The value of -sp_coverage should be larger than 0 and smaller than 1."
    stage0_blank "                    Please correct it . "
    stage0_blank "                    HybSuite exits."
    stage0_blank ""
    exit 1
  fi
  
  if (( $(echo "${gene_coverage} >= 0" | bc -l) )) && (( $(echo "${gene_coverage} <= 1" | bc -l) )); then
    stage0_blank ""
  else
    stage0_blank ""
    stage0_info "After checking:"
    stage0_warning "The value of -gene_coverage should be larger than 0 and smaller than 1."
    stage0_blank "                    Please correct it . "
    stage0_blank "                    HybSuite exits."
    stage0_blank ""
    exit 1
  fi
  stage0_info "Well done!"
  stage0_blank "                    All arguments are valid."
  stage0_blank "                    Moving on to the next step ..."
  stage0_blank ""
fi
#Step 5: Check Species checklists
#########################################
### Step 5: Check Species checklists ####
#########################################
cd ${i}
###01 The SRA_toolkit will be used to download the species list of its public data (NCBI_Spname_list.txt) and the species list of the newly added, uncleaned original sequencing data (My_Spname.txt). Merge all new species lists with uncleaned data (All_new_Spname.txt)
> ./All_Spname_list.txt
if [ -s "./SRR_Spname.txt" ]; then
  cut -f 1 ./SRR_Spname.txt > ./NCBI_SRR_list.txt
  cut -f 2 ./SRR_Spname.txt > ./NCBI_Spname_list.txt
  if [ ! -s "./My_Spname.txt" ]; then
    cp ./NCBI_Spname_list.txt ./All_Spname_list.txt
  fi
fi
if [ -s "./My_Spname.txt" ]; then
  if [ ! -s "./SRR_Spname.txt" ]; then
    cp ./My_Spname.txt ./All_Spname_list.txt
  else
    sed -e '$a\' "./NCBI_Spname_list.txt" > "./NCBI_Spname_list2.txt"
    sed -e '$a\' ./My_Spname.txt > ./My_Spname2.txt
    cat ./NCBI_Spname_list2.txt ./My_Spname2.txt > ./All_Spname2.txt
    sed '/^$/d' ./All_Spname2.txt > ./All_Spname_list.txt
    rm ./All_Spname2.txt
    rm ./NCBI_Spname_list2.txt
    rm ./My_Spname2.txt
  fi
fi
if [ "${other_seqs}" != "_____" ]; then
  > "${i}"/Other_seqs_Spname.txt
  for file in "${other_seqs}"/*.fasta; do
    add_sp=$(basename "${file}" .fasta)
    echo "${add_sp}" >> ./All_Spname_list.txt
  done
fi

if [ "${skip_checking}" != "TRUE" ]; then
  stage0_info2 " => Step 5: Check Species checklists"
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
  stage0_info "You plan to construct phylogenetic trees of ${all_sp_num} taxon which belong to ${all_genus_num} genera"
  stage0_info "(1) Taxonomy:"

  while IFS= read -r line || [ -n "$line" ]; do
    num=$(grep -c "$line" ./All_Spname_list.txt)
    stage0_blank "                    ${num} species belong to the genus ${line}"
  done < ./All_Genus_name_list.txt
  ref_num=$(grep -c '>' "${t}")
  stage0_info "(2) Data sources:"
  if [ -s "${i}/SRR_Spname.txt" ]; then
    stage0_blank "                    Downloaded raw data: ${SRR_sp_num} species belonging to ${SRR_genus_num} genera."
  else
    stage0_blank "                    Downloaded raw data: SRR_Spname.txt was not provided."
  fi
  if [ -s "${i}/My_Spname.txt" ]; then
    stage0_blank "                    Your own raw data: ${Add_sp_num} species belonging to ${Add_genus_num} genera."
  else
    stage0_blank "                    Your own raw data: My_Spname.txt was not provided."
  fi
  if [ -s "${i}/Other_seqs_Spname.txt" ]; then
    stage0_blank "                    Your other single-copy genes data: ${Other_sp_num} species belonging to ${Other_genus_num} genera."
  else
    stage0_blank "                    Your other single-copy genes data: Other single-copy gene alignments were not provided."
  fi
  stage0_blank ""
  if [ "${other_seqs}" != "_____" ]; then
    rm ./Other_seqs_Spname.txt
  fi
#Step 6: Check '-OI' and '-tree' options
  ################################################
  ### Step 6: Check '-OI' and '-tree' options ####
  ################################################
  stage0_info2 " => Step 6: Check '-OI' and '-tree' options"
  stage0_info "According to your command:"
  
  stage0_info "The chosen Ortholog Inference methods:  "
  if [ "${HRS}" = "TRUE" ]; then
    stage0_blank "                    HRS"
  fi
  if [ "${RAPP}" = "TRUE" ]; then
    stage0_blank "                    RAPP"
  fi
  if [ "${LS}" = "TRUE" ]; then
    stage0_blank "                    LS"
  fi
  if [ "${MI}" = "TRUE" ]; then
    stage0_blank "                    MI"
  fi
  if [ "${MO}" = "TRUE" ]; then
    stage0_blank "                    MO"
  fi
  if [ "${RT}" = "TRUE" ]; then
    stage0_blank "                    RT"
  fi
  if [ "${one_to_one}" = "TRUE" ]; then
    stage0_blank "                    1to1"
  fi

  stage0_info "Software choices for constructing phylogenetic trees:  "
  if [ "${run_iqtree}" = "TRUE" ]; then
    stage0_blank "                    IQ-TREE"
  fi
  if [ "${run_raxml}" = "TRUE" ]; then
    stage0_blank "                    RAxML"
  fi
  if [ "${run_raxml_ng}" = "TRUE" ]; then
    stage0_blank "                    RAxML-NG"
  fi
  if [ "${run_astral}" = "TRUE" ]; then
    stage0_blank "                    ASTRAL-III"
  fi
  if [ "${run_wastral}" = "TRUE" ]; then
    stage0_blank "                    wASTRAL"
  fi
  if [ "${tree}" = "0" ]; then
    stage0_blank "                    None"
  fi
  stage0_blank ""
#Step 7: Check the target file
  ######################################
  ### Step 7: Check the target file ####
  ######################################
  stage0_info2 " => Step 7: Check the target file"
  stage0_info "After checking,"
  stage0_info "The target file is (specified by '-t'):" 
  stage0_blank "                    ${t}"
  stage0_blank "                    It contains ${ref_num} sequences"
  stage0_blank ""
  stage0_info "All in all, the final results will be output to ${o}/"
  stage0_blank ""
  stage0_info2 " => According to the above feedbacks,"
  stage0_blank "                    proceed to run HybSuite? ([y]/n)"

  # Read the answer entered by the user
  read answer
  answer_HybSuite=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
  # Check the user's answers
  if [ "$answer_HybSuite" = "y" ]; then
    stage0_blank ""
    stage0_info "Fantastic! HybSuite will run according to your request ..."
    stage0_blank "                    Let's start it, good luck!"
    stage0_blank ""
  elif [ "$answer_HybSuite" = "n" ]; then
    stage0_blank ""
    stage0_warning "It might be something dosen't satisfy your needs."
    stage0_blank "                    You can adjust the parameter settings or correct the filenames."
    stage0_blank "                    HybSuite exits."
    stage0_blank ""
    exit 1
  else
    stage0_blank ""
    stage0_error "Sorry, ${answer} is not a valid answer."
    stage0_blank "                    Please input y (yes) or n (no)."
    stage0_blank "                    HybSuite exits."
    stage0_blank ""
    exit 1
  fi
fi

#===> Preparation: Folder creation and switching of conda environment <===#
#Create Folders：
###01 Create the desired folder
echo "[HybSuite-INFO]:    <<<======= Preparation: Create desired folders =======>>>"
echo "                    Finish"
if [ -s "${i}/SRR_Spname.txt" ]; then
  sed -i '/^$/d' "${i}/SRR_Spname.txt"
fi
if [ -s "${i}/My_Spname.txt" ]; then
  sed -i '/^$/d' "${i}/My_Spname.txt"
fi
#run to database and other stages
if [ "${run_to_database}" = "true" ] || [ "${run_all}" = "true" ] || [ "${run_to_hybpiper}" = "true" ] || [ "${run_to_alignments}" = "true" ] || [ "${run_to_trees}" = "true" ]; then
  database_chars="01-Downloaded_raw_data/01-Raw-reads_sra 01-Downloaded_raw_data/02-Raw-reads_fastq_gz 02-Downloaded_clean_data 03-My_clean_data"
  for dir in ${database_chars}; do
      mkdir -p "${d}/${dir}"
  done
  logs_chars="00-logs_and_reports/logs 00-logs_and_reports/species_checklists"
  for dir in ${logs_chars}; do
      mkdir -p "${o}/${dir}"
  done
fi

#run to hybpiper
if [ "${run_to_hybpiper}" = "true" ]; then
  database_chars="01-Downloaded_raw_data/01-Raw-reads_sra 01-Downloaded_raw_data/02-Raw-reads_fastq_gz 02-Downloaded_clean_data 03-My_clean_data"
  for dir in ${database_chars}; do
      mkdir -p "${d}/${dir}"
  done
  logs_chars="00-logs_and_reports/logs 00-logs_and_reports/species_checklists"
  for dir in ${logs_chars}; do
      mkdir -p "${o}/${dir}"
  done
  
  hybpiper_chars="01-HybPiper_results/01-assemble 01-HybPiper_results/02-stats 01-HybPiper_results/03-recovery_heatmap 01-HybPiper_results/04-retrieve_sequences 01-HybPiper_results/05-paralogs_all_fasta 01-HybPiper_results/06-paralogs_reports"
  for dir in ${hybpiper_chars}; do
    mkdir -p "${o}/${dir}"
  done
fi

#run to alignments
if [ "${run_to_alignments}" = "true" ]; then
  database_chars="01-Downloaded_raw_data/01-Raw-reads_sra 01-Downloaded_raw_data/02-Raw-reads_fastq_gz 02-Downloaded_clean_data 03-My_clean_data"
  for dir in ${database_chars}; do
      mkdir -p "${d}/${dir}"
  done
  logs_chars="00-logs_and_reports/logs 00-logs_and_reports/species_checklists"
  for dir in ${logs_chars}; do
      mkdir -p "${o}/${dir}"
  done
  
  hybpiper_chars="01-HybPiper_results/01-assemble 01-HybPiper_results/02-stats 01-HybPiper_results/03-recovery_heatmap 01-HybPiper_results/04-retrieve_sequences 01-HybPiper_results/05-paralogs_all_fasta 01-HybPiper_results/06-paralogs_reports"
  for dir in ${hybpiper_chars}; do
    mkdir -p "${o}/${dir}"
  done
fi

#run to trees
if [ "${run_to_trees}" = "true" ]; then
  database_chars="01-Downloaded_raw_data/01-Raw-reads_sra 01-Downloaded_raw_data/02-Raw-reads_fastq_gz 02-Downloaded_clean_data 03-My_clean_data"
  for dir in ${database_chars}; do
      mkdir -p "${d}/${dir}"
  done
  logs_chars="00-logs_and_reports/logs 00-logs_and_reports/species_checklists"
  for dir in ${logs_chars}; do
      mkdir -p "${o}/${dir}"
  done
  
  hybpiper_chars="01-HybPiper_results/01-assemble 01-HybPiper_results/02-stats 01-HybPiper_results/03-recovery_heatmap 01-HybPiper_results/04-retrieve_sequences 01-HybPiper_results/05-paralogs_all_fasta 01-HybPiper_results/06-paralogs_reports"
  for dir in ${hybpiper_chars}; do
    mkdir -p "${o}/${dir}"
  done
  
  trees_chars="03-Supermatrix 04-ModelTest-NG 05-Concatenated_trees 06-Coalescent-based_trees"
  if [ "${HRS}" = "TRUE" ]; then
    for dir in ${trees_chars}; do
      mkdir -p "${o}/${dir}/HRS"
    done
  fi
  if [ "${RAPP}" = "TRUE" ]; then
    for dir in ${trees_chars}; do
      mkdir -p "${o}/${dir}/RAPP"
    done
  fi
  if [ "${LS}" = "TRUE" ]; then
    for dir in ${trees_chars}; do
      mkdir -p "${o}/${dir}/LS"
    done
  fi
  if [ "${MO}" = "TRUE" ]; then
    for dir in ${trees_chars}; do
      mkdir -p "${o}/${dir}/MO"
    done
  fi
  if [ "${RT}" = "TRUE" ]; then
    for dir in ${trees_chars}; do
      mkdir -p "${o}/${dir}/RT"
    done
  fi
  if [ "${MI}" = "TRUE" ]; then
    for dir in ${trees_chars}; do
      mkdir -p "${o}/${dir}/MI"
    done
  fi
  if [ "${one_to_one}" = "TRUE" ]; then
    for dir in ${trees_chars}; do
      mkdir -p "${o}/${dir}/1to1"
    done
  fi
fi

#run all
if [ "${run_all}" = "true" ]; then
  database_chars="01-Downloaded_raw_data/01-Raw-reads_sra 01-Downloaded_raw_data/02-Raw-reads_fastq_gz 02-Downloaded_clean_data 03-My_clean_data"
  for dir in ${database_chars}; do
      mkdir -p "${d}/${dir}"
  done
  logs_chars="00-logs_and_reports/logs 00-logs_and_reports/species_checklists"
  for dir in ${logs_chars}; do
      mkdir -p "${o}/${dir}"
  done
  
  hybpiper_chars="01-HybPiper_results/01-assemble 01-HybPiper_results/02-stats 01-HybPiper_results/03-recovery_heatmap 01-HybPiper_results/04-retrieve_sequences 01-HybPiper_results/05-paralogs_all_fasta 01-HybPiper_results/06-paralogs_reports"
  for dir in ${hybpiper_chars}; do
    mkdir -p "${o}/${dir}"
  done
  
  trees_chars="03-Supermatrix 04-ModelTest-NG 05-Concatenated_trees 06-Coalescent-based_trees"
  if [ "${HRS}" = "TRUE" ]; then
    for dir in ${trees_chars}; do
      mkdir -p "${o}/${dir}/HRS"
    done
  fi
  if [ "${RAPP}" = "TRUE" ]; then
    for dir in ${trees_chars}; do
      mkdir -p "${o}/${dir}/RAPP"
    done
  fi
  if [ "${MO}" = "TRUE" ]; then
    for dir in ${trees_chars}; do
      mkdir -p "${o}/${dir}/MO"
    done
  fi
  if [ "${RT}" = "TRUE" ]; then
    for dir in ${trees_chars}; do
      mkdir -p "${o}/${dir}/RT"
    done
  fi
  if [ "${MI}" = "TRUE" ]; then
    for dir in ${trees_chars}; do
      mkdir -p "${o}/${dir}/MI"
    done
  fi
  if [ "${one_to_one}" = "TRUE" ]; then
    for dir in ${trees_chars}; do
      mkdir -p "${o}/${dir}/1to1"
    done
  fi
  
  mkdir -p "${o}/07-Trees_tests"
fi

#Move the species checklists.
#logfile="${o}/00-logs_and_reports/logs/HybSuite_${current_time}_log.txt"
#exec > >(tee -a "$logfile") 2>&1

if [ -s "${i}/NCBI_SRR_list.txt" ]; then
  mv ${i}/NCBI_SRR_list.txt ${o}/00-logs_and_reports/species_checklists/
fi

if [ -s "${i}/All_Spname_list.txt" ]; then
  mv ${i}/All_Spname_list.txt ${o}/00-logs_and_reports/species_checklists/
fi

if [ -s "${i}/NCBI_Spname_list.txt" ]; then
  mv ${i}/NCBI_Spname_list.txt ${o}/00-logs_and_reports/species_checklists/
fi


#===> Stage 1 NGS dataset construction <===#
stage1_info() {
  echo "[HybSuite-INFO]:    $1" | tee -a "${o}/00-logs_and_reports/logs/Stage1_NGS_dataset_construction_${current_time}.log"
}
stage1_error() {
  echo "[HybSuite-ERROR]:   $1" | tee -a "${o}/00-logs_and_reports/logs/Stage1_NGS_dataset_construction_${current_time}.log"
}
stage1_cmd() {
  echo "[HybSuite-CMD]:     $1" | tee -a "${o}/00-logs_and_reports/logs/Stage1_NGS_dataset_construction_${current_time}.log"
}
stage1_blank() {
  echo "$1" | tee -a "${o}/00-logs_and_reports/logs/Stage1_NGS_dataset_construction_${current_time}.log"
}
#1. Use sratoolkit to batch download sra data, then use fasterq-dump to convert the original sra data to fastq/fastq.gz format, and decide whether to delete sra data according to the parameters provided by the user
if [ -s "${o}/00-logs_and_reports/logs/Stage1_NGS_database_construction_${current_time}.log" ]; then
  rm "${o}/00-logs_and_reports/logs/Stage1_NGS_database_construction_${current_time}.log"
fi
stage1_blank ""
stage1_info "<<<======= Stage1 NGS database construction=======>>>"
stage1_info "Preparation: Activate conda environment ${conda1}..."
#source activate
if [ -z "$CONDA_DEFAULT_ENV" ]; then
  stage1_info "You didn't activate any conda environment, so HybSuite will help you activate ${conda1} environment." 
  current_shell=$(basename "$SHELL")
  case "$current_shell" in
    bash)
        eval "$(conda shell.bash hook)"
        stage1_info "Bash shell detected. Conda hook loaded."
        ;;
    zsh)
        eval "$(conda shell.zsh hook)"
        echo "Zsh shell detected. Conda hook loaded."
        ;;
    sh)
        eval "$(conda shell.sh hook)"
        echo "Sh shell detected. Conda hook loaded."
        ;;
    fish)
        eval "(conda shell.fish hook)"
        echo "Fish shell detected. Conda hook loaded."
        ;;
  esac
  conda activate "${conda1}"
  stage1_cmd "conda activate ${conda1}" 
  if [ "$CONDA_DEFAULT_ENV" = "${conda1}" ]; then
    stage1_info "Successfully activate ${conda1} conda environment"
    stage1_blank "                    PASS" 
    stage1_blank ""
  else
    stage1_error "Fail to activate ${conda1} conda environment"
  fi
else
  stage1_info "You are now in conda environment ${conda1}, so HybSuite will skip activating ${conda1} conda environment." 
  stage1_blank ""
fi
if [ "${CONDA_DEFAULT_ENV}" != "${conda1}" ]; then
  stage1_info "You didn't activate conda environment ${conda1}, so HybSuite will help you activate ${conda1} environment." 
  current_shell=$(basename "$SHELL")
  case "$current_shell" in
    bash)
        eval "$(conda shell.bash hook)"
        stage1_info "Bash shell detected. Conda hook loaded."
        ;;
    zsh)
        eval "$(conda shell.zsh hook)"
        echo "Zsh shell detected. Conda hook loaded."
        ;;
    sh)
        eval "$(conda shell.sh hook)"
        echo "Sh shell detected. Conda hook loaded."
        ;;
    fish)
        eval "(conda shell.fish hook)"
        echo "Fish shell detected. Conda hook loaded."
        ;;
  esac
  conda activate "${conda1}"
  stage1_cmd "conda activate ${conda1}" 
  if [ "$CONDA_DEFAULT_ENV" = "${conda1}" ]; then
    stage1_info "Successfully activate ${conda1} conda environment"
    stage1_blank "                    PASS" 
    stage1_blank ""
  else
    stage1_error "Fail to activate ${conda1} conda environment"
    stage1_blank "                    HybSuite exits."
    stage1_blank ""
    exit 1
  fi
else 
  current_shell=$(basename "$SHELL")
  case "$current_shell" in
    bash)
        eval "$(conda shell.bash hook)"
        stage1_info "Bash shell detected. Conda hook loaded."
        ;;
    zsh)
        eval "$(conda shell.zsh hook)"
        echo "Zsh shell detected. Conda hook loaded."
        ;;
    sh)
        eval "$(conda shell.sh hook)"
        echo "Sh shell detected. Conda hook loaded."
        ;;
    fish)
        eval "(conda shell.fish hook)"
        echo "Fish shell detected. Conda hook loaded."
        ;;
  esac
  stage1_info "You are now in conda environment ${conda1}, so HybSuite will skip activating ${conda1} conda environment."
  stage1_blank ""
fi

stage1_info "Step1: Download NGS raw data from NCBI via SRAToolKit (sra-tools) ..."
stage1_info "Already downloaded sequences will not be downloaded again !!!"
if [ -e "${o}/00-logs_and_reports/species_checklists/NCBI_SRR_list.txt" ]; then
  while IFS= read -r line || [ -n "$line" ]; do
    srr=$(echo "${line}" | awk '{print $1}')
    spname=$(echo "${line}" | awk '{print $2}')
    #if the user choose the format of downloading as fastq.gz
    if [ "$download_format" = "fastq_gz" ]; then
      if ([ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq.gz" ] && [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq.gz" ]) \
      && [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq.gz" ] \
      && ([ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq" ] && [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq" ]) \
      && [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq" ]; then
        # prefetch
        stage1_info "Downloading $srr.sra ... "
        prefetch "$srr" -O ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/
        stage1_cmd "prefetch \"$srr\" -O ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/" \
       
        if [ -s ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}.sra ]; then
          stage1_info "Successfully download $srr.sra" \
         
        else 
          stage1_error "Fail to download $srr.sra" \
         
        fi
        
        # fasterq-dump
        fasterq-dump ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra -e ${nt_fasterq_dump} -p -O ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/
        stage1_cmd "fasterq-dump ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra -e ${nt_fasterq_dump} -p -O ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/" \
       
       
        # pigz for single-ended
        if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq" ]; then
          stage1_info "Successfully transform ${srr}.sra to ${srr}.fastq via fasterq-dump" \
       
          pigz -p ${nt_pigz} ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq
          stage1_cmd "pigz -p ${nt_pigz} ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq"
          if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq.gz" ]; then
            stage1_info "Successfully comprass ${srr}.fastq to ${srr}.fastq.gz via pigz, using ${nt_pigz} threads" \
         
          else
            stage1_error "Fail to comprass ${srr}.fastq to ${srr}.fastq.gz via pigz"
          fi
        fi
        
        # pigz for pair-ended
        if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq" ] && [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq" ]; then
          stage1_info "Successfully transform ${srr}.sra to ${srr}_1.fastq and ${srr}_2.fastq via fasterq-dump"
          pigz -p ${nt_pigz} ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq
          pigz -p ${nt_pigz} ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq
          stage1_cmd "pigz -p ${nt_pigz} ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq
                    pigz -p ${nt_pigz} ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq"
          if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq.gz" ] && [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq.gz" ]; then
            stage1_info "Successfully comprass ${srr}_1.fastq and ${srr}_2.fastq via pigz, using ${nt_pigz} threads"
          else
            stage1_error "Fail to comprass ${srr}_1.fastq and ${srr}_2.fastq via pigz"
          fi
        fi
        
        #remove the srr files
        if [ "$rm_sra" != "FALSE" ]; then
          rm -r ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}
          stage1_cmd "rm -r ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}"
          stage1_info "Remove ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}."          
        fi
      else
        stage1_info "Skip downloading $srr since it exists."
      fi
      
      #rename the files
      if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq.gz" ] && [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq.gz" ]; then
        mv "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq.gz" "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq.gz"
        stage1_info "Successfully rename ${srr}_1.fastq.gz to ${spname}_1.fastq.gz in ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/"
        mv "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq.gz" "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq.gz"
        stage1_info "Successfully rename ${srr}_2.fastq.gz to ${spname}_2.fastq.gz in ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/"
        stage1_info "Successfully download paired-end raw data (fastq.gz) of the species ${spname} from NCBI."
        stage1_blank ""
      fi
      if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq.gz" ]; then
        mv "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq.gz" "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq.gz"
        stage1_info "Successfully rename ${srr}.fastq.gz to ${spname}.fastq.gz in ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/"
        stage1_info "Successfully download single-end raw data (fastq.gz) of the species ${spname} from NCBI."
        stage1_blank ""
      fi
    fi
    #if the user choose the format of downloading as fastq
    if [ "$download_format" = "fastq" ]; then
      if ([ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq.gz" ] && [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq.gz" ]) \
      && [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq.gz" ] \
      && ([ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq" ] && [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq" ]) \
      && [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq" ]; then
        # prefetch
        stage1_info "Downloading $srr.sra ... "
        prefetch "$srr" -O ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/
        stage1_cmd "prefetch \"$srr\" -O ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/" \
       
        if [ -s ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}.sra ]; then
          stage1_info "Successfully download $srr.sra" \
         
        else 
          stage1_error "Fail to download $srr.sra" \
         
        fi
        
        # fasterq-dump
        fasterq-dump ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra -e ${nt_fasterq_dump} -p -O ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/
        stage1_cmd "fasterq-dump ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra -e ${nt_fasterq_dump} -p -O ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/" \
       
      else
        stage1_info "Skip downloading ${srr}(${spname}) since it exits."
      fi
      #rename the files
      if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq" ] && [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq" ]; then
        mv "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq" "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq"
        stage1_info "Successfully rename ${srr}_1.fastq to ${spname}_1.fastq in ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/"
        mv "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq" "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq"
        stage1_info "Successfully rename ${srr}_2.fastq to ${spname}_2.fastq in ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/"
        stage1_info "Successfully download paired-end raw data (fastq) of the species ${spname} from NCBI."
        stage1_blank ""
      fi
      if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq" ]; then
        mv "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq" "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq"
        stage1_info "Successfully rename ${srr}.fastq to ${spname}.fastq in ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/"
        stage1_info "Successfully download single-end raw data (fastq) of the species ${spname} from NCBI."
        stage1_blank ""
      fi
    fi
  done < ${i}/SRR_Spname.txt
fi
#2. Filter NGS raw data via trimmomatic
#Trimmomatic for SRR_Spname.txt
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#2.1 Raw data filtering of NCBI public data (premise: the user provides SRR_Spname.txt and opts not to use the existing clean.paired.fq file)
stage1_info "Step2: Remove adapters of raw data via Trimmomatic-0.39 ..."
stage1_info "Sequences that have already had adapters removed will not be trimmed for adapters again!!!"
cd ${d}
if [ -s "${i}/SRR_Spname.txt" ]; then
  total_sps=$(awk 'END {print NR}' "${i}/SRR_Spname.txt")
  j=0
  stage1_info "<<==== Running Trimmomatic-0.39 for NCBI public data ====>>"
  while IFS= read -r line || [ -n "$line" ]; do
    j=$((j + 1))
    progress=$((j * 100 / total_sps))
    printf "\r[HybSuite-INFO]:    Trimmomatic-0.39: ${j}/${total_sps} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress"
    spname=$(echo "${line}" | awk '{print $2}')
    #for pair-ended
    if ([ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq" ] && [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq" ]) \
    || ([ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq.gz" ] && [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq.gz" ]); then
      if [ -s "${d}/02-Downloaded_clean_data/${spname}_1_clean.paired.fq.gz" ] && [ -s "${d}/02-Downloaded_clean_data/${spname}_2_clean.paired.fq.gz" ]; then
        stage1_info "Trimmomatic: Skip ${spname} as it's already been trimmed." > /dev/null
      else
        files1=(${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.f*)
        files2=(${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.f*)
        if [ ${#files1[@]} -gt 0 ] && [ ${#files2[@]} -gt 0 ]; then
          java -jar ${script_dir}/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar PE \
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
          
          stage1_cmd "java -jar ${script_dir}/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads ${nt_trimmomatic} -phred33 ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.f* ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.f* ./02-Downloaded_clean_data/${spname}_1_clean.paired.fq.gz ./02-Downloaded_clean_data/${spname}_1_clean.unpaired.fq.gz ./02-Downloaded_clean_data/${spname}_2_clean.paired.fq.gz ./02-Downloaded_clean_data/${spname}_2_clean.unpaired.fq.gz ILLUMINACLIP:${script_dir}/../dependencies/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} LEADING:${trimmomatic_leading_quality} TRAILING:${trimmomatic_trailing_quality} MINLEN:${trimmomatic_min_length}" > /dev/null     
  
          trfilename="${d}/02-Downloaded_clean_data/${spname}_2_clean.paired.fq.gz"  
          trfilesize=$(stat -c %s "$trfilename")
          if [ "$trfilesize" -lt 1024 ]; then
            rm ${d}/02-Downloaded_clean_data/${spname}_*_clean.paired.fq.gz
            stage1_error "Trimmomatic didn't produce any results about ${spname}." > /dev/null
          else
            stage1_info "Successfully trim adapters of the raw data for ${spname}, producing clean data ${spname}_1_clean.paired.fq.gz and ${spname}_2_clean.paired.fq.gz." > /dev/null
          fi
        fi
      fi
    fi
    #for single-ended
    if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq" ] \
    || [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq.gz" ]; then
      if [ -s "${d}/02-Downloaded_clean_data/${spname}_clean.single.fq.gz" ]; then
        stage1_info "Trimmomatic: Skip ${spname} as it's already been trimmed." > /dev/null 
      else  
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
          
          stage1_cmd "     java -jar ${script_dir}/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar SE -threads ${nt_trimmomatic} -phred33 ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.f* ${d}/02-Downloaded_clean_data/${spname}_clean.single.fq.gz ILLUMINACLIP:${script_dir}/../dependencies/Trimmomatic-0.39/adapters/TruSeq3-SE.fa:2:30:10 SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} LEADING:${trimmomatic_leading_quality} TRAILING:${trimmomatic_trailing_quality} MINLEN:${trimmomatic_min_length}" > /dev/null
          trfilename="${d}/02-Downloaded_clean_data/${spname}_clean.single.fq.gz" 
          trfilesize=$(stat -c %s "$trfilename") 
          if [ "$trfilesize" -lt 1024 ]; then
            rm ${d}/02-Downloaded_clean_data/${spname}_clean.single.fq.gz
            stage1_error "Trimmomatic didn't produce any results about ${spname}." > /dev/null
          else
            stage1_info "Successfully trim adapters of the raw data for ${spname}, producing clean data ${spname}_clean.paired.fq.gz." > /dev/null
          fi
        fi
      fi
    fi
  done < ${i}/SRR_Spname.txt
  echo
fi
#Trimmomatic for My_Spname.txt
#2.2 Filter the new self-test data (fastq format) (provided that the user provides My_Spname.txt and specifies the file path in the my_raw_data option)
if [ -s "${i}/My_Spname.txt" ] && [ "$my_raw_data" != "_____" ]; then
	total_sps=$(awk 'END {print NR}' "${i}/My_Spname.txt")
  j=0
  stage1_info "<<==== Running Trimmomatic-0.39 for your own data ====>>"
  while IFS= read -r spname || [[ -n $spname ]]; do
		j=$((j + 1))
    progress=$((j * 100 / total_sps))
    printf "\r[HybSuite-INFO]:    Trimmomatic-0.39: ${j}/${total_sps} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress"
    #for pair-ended
    if ([ -s "${my_raw_data}/${spname}_1.fastq" ] && [ -s "${my_raw_data}/${spname}_2.fastq" ]) \
    || ([ -s "${my_raw_data}/${spname}_1.fq" ] && [ -s "${my_raw_data}/${spname}_2.fq" ]) \
    || ([ -s "${my_raw_data}/${spname}_1.fastq.gz" ] && [ -s "${my_raw_data}/${spname}_2.fastq.gz" ]) \
    || ([ -s "${my_raw_data}/${spname}_1.fq.gz" ] && [ -s "${my_raw_data}/${spname}_2.fq.gz" ]); then
      if [ -s "${d}/03-My_clean_data/${spname}_1_clean.paired.fq.gz" ] && [ -s "${d}/03-My_clean_data/${spname}_2_clean.paired.fq.gz" ]; then
        stage1_info "Trimmomatic: Skip ${spname} as it's already been trimmed." > /dev/null
      else
        files1=(${my_raw_data}/${spname}_1.f*)
        files2=(${my_raw_data}/${spname}_2.f*)
        if [ ${#files1[@]} -gt 0 ] && [ ${#files2[@]} -gt 0 ]; then
          java -jar ${script_dir}/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar PE \
          -threads ${nt_trimmomatic} \
          -phred33 \
          ${my_raw_data}/${spname}_1.f* ${my_raw_data}/${spname}_2.f* \
          ${d}/03-My_clean_data/${spname}_1_clean.paired.fq.gz ${d}/03-My_clean_data/${spname}_1_clean.unpaired.fq.gz \
          ${d}/03-My_clean_data/${spname}_2_clean.paired.fq.gz ${d}/03-My_clean_data/${spname}_2_clean.unpaired.fq.gz \
          ILLUMINACLIP:${script_dir}/../dependencies/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10 \
          SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} \
          LEADING:${trimmomatic_leading_quality} \
          TRAILING:${trimmomatic_trailing_quality} \
          MINLEN:${trimmomatic_min_length} > /dev/null 2>&1
          stage1_cmd "java -jar ${script_dir}/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads ${nt_trimmomatic} -phred33 ${my_raw_data}/${spname}_1.f* ${my_raw_data}/${spname}_2.f* ${d}/03-My_clean_data/${spname}_1_clean.paired.fq.gz ${d}/03-My_clean_data/${spname}_1_clean.unpaired.fq.gz ${d}/03-My_clean_data/${spname}_2_clean.paired.fq.gz ${d}/03-My_clean_data/${spname}_2_clean.unpaired.fq.gz ILLUMINACLIP:${script_dir}/../dependencies/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} LEADING:${trimmomatic_leading_quality} TRAILING:${trimmomatic_trailing_quality} MINLEN:${trimmomatic_min_length}" > /dev/null
          
          trfilename="${d}/03-My_clean_data/${spname}_1_clean.paired.fq.gz" 
          trfilesize=$(stat -c %s "$trfilename") 
          if [ "$trfilesize" -lt 1024 ]; then
            rm ${d}/03-My_clean_data/${spname}_*_clean.paired.fq.gz
            stage1_error "Trimmomatic didn't produce any results about ${spname}." > /dev/null
          else
            stage1_info "Successfully trim adapters of the raw data for ${spname}, producing clean data ${spname}_1_clean.paired.fq.gz and ${spname}_2_clean.paired.fq.gz." > /dev/null
          fi
        fi
      fi
    fi
    #for single-ended
    if [ -s "${my_raw_data}/${spname}.fastq" ] \
    || [ -s "${my_raw_data}/${spname}.fq" ] \
    || [ -s "${my_raw_data}/${spname}.fastq.gz" ] \
    || [ -s "${my_raw_data}/${spname}.fq.gz" ]; then
      if [ -s "${d}/03-My_clean_data/${spname}_clean.single.fq.gz" ]; then
        stage1_info "Trimmomatic: Skip ${spname} as it's already been trimmed." > /dev/null  
      else  
        files3=(${my_raw_data}/${spname}.f*)
        if [ ${#files3[@]} -gt 0 ]; then
          java -jar ${script_dir}/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar SE \
          -threads ${nt_trimmomatic} \
          -phred33 \
          ${my_raw_data}/${spname}.f* \
          ${d}/03-My_clean_data/${spname}_clean.single.fq.gz \
          ILLUMINACLIP:${script_dir}/../dependencies/Trimmomatic-0.39/adapters/TruSeq3-SE.fa:2:30:10 \
          SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} \
          LEADING:${trimmomatic_leading_quality} \
          TRAILING:${trimmomatic_trailing_quality} \
          MINLEN:${trimmomatic_min_length} > /dev/null 2>&1
          stage1_cmd "java -jar ${script_dir}/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar SE -threads ${nt_trimmomatic} -phred33 ${my_raw_data}/${spname}.f* ${d}/03-My_clean_data/${spname}_clean.single.fq.gz ILLUMINACLIP:${script_dir}/../dependencies/Trimmomatic-0.39/adapters/TruSeq3-SE.fa:2:30:10 SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} LEADING:${trimmomatic_leading_quality} TRAILING:${trimmomatic_trailing_quality} MINLEN:${trimmomatic_min_length}" > /dev/null
          
          trfilename="${d}/03-My_clean_data/${spname}_clean.single.fq.gz" 
          trfilesize=$(stat -c %s "$trfilename")
          if [ "$trfilesize" -lt 1024 ]; then
            rm ${d}/03-My_clean_data/${spname}_clean.single.fq.gz
            stage1_error "Trimmomatic didn't produce any results about ${spname}." > /dev/null
          else
            stage1_info "Successfully trim adapters of the raw data for ${spname}, producing clean data ${spname}_clean.paired.fq.gz." > /dev/null
          fi
        fi
      fi
    fi
  done < ${i}/My_Spname.txt
  echo
fi
stage1_info "Successfully finish running stage1: 'NGS database construction'. "
stage1_blank "                    The NGS raw data and clean data have been output to ${d}"
stage1_blank "                    Now moving on to the next stage ..."
if [ "${run_to_database}" = "true" ]; then
  stage1_info "You set '--run_to_database' to specify HybSuite to run only stage1."
  stage1_blank "                    Consequently, HybSuite will stop and exit right now."
  stage1_blank "                    HybSuite exits."
  stage1_blank ""
  exit 1
fi

#===> Stage 2 HybPiper pipeline <===#
#Preparation
stage2_info() {
  echo "[HybSuite-INFO]:    $1" | tee -a "${o}/00-logs_and_reports/logs/Stage2_HybPiper_pipeline_${current_time}.log"
}
stage2_error() {
  echo "[HybSuite-ERROR]:   $1" | tee -a "${o}/00-logs_and_reports/logs/Stage2_HybPiper_pipeline_${current_time}.log"
}
stage2_cmd() {
  echo "[HybSuite-CMD]:     $1" | tee -a "${o}/00-logs_and_reports/logs/Stage2_HybPiper_pipeline_${current_time}.log"
}
stage2_blank() {
  echo "$1" | tee -a "${o}/00-logs_and_reports/logs/Stage2_HybPiper_pipeline_${current_time}.log"
}

#(1) Change working directory and conda environment
cd ${o}/01-HybPiper_results
if [ -s "${o}/00-logs_and_reports/logs/Stage2_HybPiper_pipeline_${current_time}.log" ]; then
  rm "${o}/00-logs_and_reports/logs/Stage2_HybPiper_pipeline_${current_time}.log"
fi
stage2_blank ""
stage2_info "<<<======= Stage2 HybPiper pipeline =======>>>"
conda activate "${conda1}"
stage2_cmd "conda activate ${conda1}"
if [ "$CONDA_DEFAULT_ENV" = "${conda1}" ]; then
  stage2_info "Successfully activate ${conda1} conda environment"
  stage2_blank "                    PASS" 
  stage2_blank ""
else
  stage2_error "Fail to activate ${conda1} conda environment"
  stage2_blank "                    HybSuite exits."
  stage2_blank ""
  exit 1
fi
#(2) hybpiper assemble
###01 Genes capture of public data using HybPiper (i.e. gene capture only for new species in the SRR_Spname.txt list) (provided that the user provides SRR_Spname.txt)
stage2_info "Step1: Run 'hybpiper assemble'..."
if [ -s "${i}/SRR_Spname.txt" ]; then
  total_sps=$(awk 'END {print NR}' "${i}/SRR_Spname.txt")
  j=0
  stage2_info "<<==== Running 'hybpiper assemble' for public data ====>>"
  while IFS= read -r line || [ -n "$line" ]; do
    j=$((j + 1))
    progress=$((j * 100 / total_sps))
    printf "\r[HybSuite-INFO]:    hybpiper assemble: ${j}/${total_sps} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress"
    Sp_name=$(echo "${line}" | awk '{print $2}')
    stage2_info "For the sample '${Sp_name}': " > /dev/null
    if [ ! -s "${eas_dir}/${Sp_name}/genes_with_seqs.txt" ]; then
      if [ -e "${eas_dir}/${Sp_name}" ]; then
        rm -rf "${eas_dir}"/"${Sp_name}"/*
        stage2_info "'hybpiper assemble' hasn't been finished, so it will restart." > /dev/null
      fi
      cd ${o}/01-HybPiper_results/01-assemble/
      if [ -d "${Spname}" ] && [ ! -s "${Spname}/${Spname}_chimera_check_performed.txt" ]; then
        echo "True" > "${Spname}/${Spname}_chimera_check_performed.txt"
      fi
      #for paired-end
      if ([ -s "${d}/02-Downloaded_clean_data/${Sp_name}_1_clean.paired.fq.gz" ] && [ -s "${d}/02-Downloaded_clean_data/${Sp_name}_2_clean.paired.fq.gz" ]) \
      && [ ! -s "${d}/02-Downloaded_clean_data/${Sp_name}_clean.single.fq.gz" ]; then
        #01: for protein reference sequence
        #use diamond to map reads
        if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "diamond" ]; then
          hybpiper assemble "-t_${hybpiper_tt}" ${t} \
          -r ${d}/02-Downloaded_clean_data/${Sp_name}_1_clean.paired.fq.gz ${d}/02-Downloaded_clean_data/${Sp_name}_2_clean.paired.fq.gz \
          -o ${eas_dir} \
          --prefix ${Sp_name} \
          --diamond \
          --cpu ${nt_hybpiper} > /dev/null
          stage2_cmd "hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/02-Downloaded_clean_data/${Sp_name}_1_clean.paired.fq.gz ${d}/02-Downloaded_clean_data/${Sp_name}_2_clean.paired.fq.gz -o ${eas_dir} --prefix ${Sp_name} --diamond --cpu ${nt_hybpiper}" > /dev/null 
        fi
        #use BLASTx (default) to map reads
        if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "blast" ]; then
          hybpiper assemble "-t_${hybpiper_tt}" ${t} \
          -r ${d}/02-Downloaded_clean_data/${Sp_name}_1_clean.paired.fq.gz ${d}/02-Downloaded_clean_data/${Sp_name}_2_clean.paired.fq.gz \
          -o ${eas_dir} \
          --prefix ${Sp_name} \
          --cpu ${nt_hybpiper} > /dev/null
          stage2_cmd "hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/02-Downloaded_clean_data/${Sp_name}_1_clean.paired.fq.gz ${d}/02-Downloaded_clean_data/${Sp_name}_2_clean.paired.fq.gz -o ${eas_dir} --prefix ${Sp_name} --cpu ${nt_hybpiper}" > /dev/null
        fi
        #02: for nucleotide reference sequence
        if [ "${hybpiper_tt}" = "dna" ]; then
          hybpiper assemble "-t_${hybpiper_tt}" ${t} \
          -r ${d}/02-Downloaded_clean_data/${Sp_name}_1_clean.paired.fq.gz ${d}/02-Downloaded_clean_data/${Sp_name}_2_clean.paired.fq.gz \
          -o ${eas_dir} \
          --prefix ${Sp_name} \
          --bwa \
          --cpu ${nt_hybpiper} > /dev/null
          stage2_cmd "hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/02-Downloaded_clean_data/${Sp_name}_1_clean.paired.fq.gz ${d}/02-Downloaded_clean_data/${Sp_name}_2_clean.paired.fq.gz -o ${eas_dir} --prefix ${Sp_name} --bwa --cpu ${nt_hybpiper}" > /dev/null
        fi
        if [ -s "${eas_dir}/${Sp_name}/genes_with_seqs.txt" ]; then
          gene_number=$(wc -l < "${eas_dir}/${Sp_name}/genes_with_seqs.txt")
          stage2_info "Successfully assemble ${gene_number} genes for ${Sp_name} via HybPiper." > /dev/null
          stage2_blank "" > /dev/null
        fi
      fi
      #for single-end
      if ([ ! -s "${d}/02-Downloaded_clean_data/${Sp_name}_1_clean.paired.fq.gz" ] && [ ! -s "${d}/02-Downloaded_clean_data/${Sp_name}_2_clean.paired.fq.gz" ]) \
      && [ -s "${d}/02-Downloaded_clean_data/${Sp_name}_clean.single.fq.gz" ]; then
        #01: for protein reference sequence
        #01-1: use diamond to map reads
        if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "diamond" ]; then
          hybpiper assemble "-t_${hybpiper_tt}" ${t} \
          -r ${d}/02-Downloaded_clean_data/${Sp_name}_clean.single.fq.gz \
          -o ${eas_dir} \
          --prefix ${Sp_name} \
          --diamond \
          --cpu ${nt_hybpiper} > /dev/null
          stage2_cmd "hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/02-Downloaded_clean_data/${Sp_name}_clean.single.fq.gz -o ${eas_dir} --prefix ${Sp_name} --diamond --cpu ${nt_hybpiper}" > /dev/null
        fi
        #01-2: use BLASTx (default) to map reads
        if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "blast" ]; then
          hybpiper assemble "-t_${hybpiper_tt}" ${t} \
          -r ${d}/02-Downloaded_clean_data/${Sp_name}_clean.single.fq.gz \
          -o ${eas_dir} \
          --prefix ${Sp_name} \
          --cpu ${nt_hybpiper} > /dev/null
          stage2_cmd "hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/02-Downloaded_clean_data/${Sp_name}_clean.single.fq.gz -o ${eas_dir} --prefix ${Sp_name} --cpu ${nt_hybpiper}" > /dev/null
        fi
        #02: for nucleotide reference sequence
        if [ "${hybpiper_tt}" = "dna" ]; then
          hybpiper assemble "-t_${hybpiper_tt}" ${t} \
          -r ${d}/02-Downloaded_clean_data/${Sp_name}_clean.single.fq.gz \
          -o ${eas_dir} \
          --prefix ${Sp_name} \
          --bwa \
          --cpu ${nt_hybpiper} > /dev/null
          stage2_cmd "hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/02-Downloaded_clean_data/${Sp_name}_clean.single.fq.gz -o ${eas_dir} --prefix ${Sp_name} --bwa --cpu ${nt_hybpiper}" > /dev/null
        fi
        if [ -s "${eas_dir}/${Sp_name}/genes_with_seqs.txt" ]; then
          gene_number=$(wc -l < "${eas_dir}/${Sp_name}/genes_with_seqs.txt")
          stage2_info "Successfully assemble ${gene_number} genes for ${Sp_name} via HybPiper." > /dev/null
          stage2_blank "" > /dev/null
        fi
      fi
    else
      stage2_info "Skip ${Sp_name}'s genes, because they have been assembled by HybPiper." > /dev/null
      stage2_blank "" > /dev/null
    fi
  done < ${i}/SRR_Spname.txt
  echo
fi

###02 Capture self-test data using HybPiper (that is, gene capture only for new species in the My_Spname.txt list) (provided that the user provides My_Spname.txt and specifies -my_raw_data)
if [ -s "${i}/My_Spname.txt" ]; then
  total_sps=$(awk 'END {print NR}' "${i}/My_Spname.txt")
  j=0
  stage2_info "<<==== Running 'hybpiper assemble' for your own data ====>>"
  while IFS= read -r Sp_name || [[ -n ${Sp_name} ]]; do
    j=$((j + 1))
    progress=$((j * 100 / total_sps))
    printf "\r[HybSuite-INFO]:    hybpiper assemble: ${j}/${total_sps} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress"
    stage2_info "For the sample '${Sp_name}': " > /dev/null
    if [ ! -s "${eas_dir}/${Sp_name}/genes_with_seqs.txt" ]; then
      if [ -e "${eas_dir}/${Sp_name}" ]; then
        rm -rf "${eas_dir}"/"${Sp_name}"/*
        stage2_info "'hybpiper assemble' hasn't been finished, so it will restart." > /dev/null
      fi
      #handle the issue of HybPiper version's changing
      if [ -d "${Sp_name}" ] && [ ! -s "${Sp_name}/${Sp_name}_chimera_check_performed.txt" ]; then
        echo "True" > "${Sp_name}/${Sp_name}_chimera_check_performed.txt"
      fi
      #for paired-end
      if ([ -s "${d}/03-My_clean_data/${Sp_name}_1_clean.paired.fq.gz" ] && [ -s "${d}/03-My_clean_data/${Sp_name}_2_clean.paired.fq.gz" ]) \
      && [ ! -s "${d}/03-My_clean_data/${Sp_name}_clean.single.fq.gz" ]; then
        #01: for protein reference sequence
        #use diamond to map reads
        if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "diamond" ]; then
          hybpiper assemble "-t_${hybpiper_tt}" ${t} \
          -r ${d}/03-My_clean_data/${Sp_name}_1_clean.paired.fq.gz ${d}/03-My_clean_data/${Sp_name}_2_clean.paired.fq.gz \
          -o ${eas_dir} \
          --prefix ${Sp_name} \
          --diamond \
          --cpu ${nt_hybpiper} > /dev/null
          stage2_cmd "hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/03-My_clean_data/${Sp_name}_1_clean.paired.fq.gz ${d}/03-My_clean_data/${Sp_name}_2_clean.paired.fq.gz -o ${eas_dir} --prefix ${Sp_name} --diamond --cpu ${nt_hybpiper}" > /dev/null
        fi
        #use BLASTx (default) to map reads
        if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "blast" ]; then
          hybpiper assemble "-t_${hybpiper_tt}" ${t} \
          -r ${d}/03-My_clean_data/${Sp_name}_1_clean.paired.fq.gz ${d}/03-My_clean_data/${Sp_name}_2_clean.paired.fq.gz \
          -o ${eas_dir} \
          --prefix ${Sp_name} \
          --cpu ${nt_hybpiper}  > /dev/null
          stage2_cmd "hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/03-My_clean_data/${Sp_name}_1_clean.paired.fq.gz ${d}/03-My_clean_data/${Sp_name}_2_clean.paired.fq.gz -o ${eas_dir} --prefix ${Sp_name} --cpu ${nt_hybpiper}" > /dev/null
        fi
        #02: for nucleotide reference sequence
        if [ "${hybpiper_tt}" = "dna" ]; then
          hybpiper assemble "-t_${hybpiper_tt}" ${t} \
          -r ${d}/03-My_clean_data/${Sp_name}_1_clean.paired.fq.gz ${d}/03-My_clean_data/${Sp_name}_2_clean.paired.fq.gz \
          -o ${eas_dir} \
          --prefix ${Sp_name} \
          --bwa \
          --cpu ${nt_hybpiper} > /dev/null
          stage2_cmd "hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/03-My_clean_data/${Sp_name}_1_clean.paired.fq.gz ${d}/03-My_clean_data/${Sp_name}_2_clean.paired.fq.gz -o ${eas_dir} --prefix ${Sp_name} --bwa --cpu ${nt_hybpiper}" > /dev/null
        fi
        if [ -s "${eas_dir}/${Sp_name}/genes_with_seqs.txt" ]; then
          gene_number=$(wc -l < "${eas_dir}/${Sp_name}/genes_with_seqs.txt")
          stage2_info "Successfully assemble ${gene_number} genes for ${Sp_name} via HybPiper." > /dev/null
          stage2_blank "" > /dev/null
        fi
      fi
      #for single-end
      if ([ ! -s "${d}/03-My_clean_data/${Sp_name}_1_clean.paired.fq.gz" ] && [ ! -s "${d}/03-My_clean_data/${Sp_name}_2_clean.paired.fq.gz" ]) \
      && [ -s "${d}/03-My_clean_data/${Sp_name}_clean.single.fq.gz" ]; then
        #01: for protein reference sequence
        #01-1: use diamond to map reads
        if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "diamond" ]; then
          hybpiper assemble "-t_${hybpiper_tt}" ${t} \
          -r ${d}/03-My_clean_data/${Sp_name}_clean.single.fq.gz \
          -o ${eas_dir} \
          --prefix ${Sp_name} \
          --diamond \
          --cpu ${nt_hybpiper} > /dev/null
          stage2_cmd "hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/03-My_clean_data/${Sp_name}_clean.single.fq.gz -o ${eas_dir} --prefix ${Sp_name} --diamond --cpu ${nt_hybpiper}" > /dev/null
        fi
        #01-2: use BLASTx (default) to map reads
        if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "blast" ]; then
          hybpiper assemble "-t_${hybpiper_tt}" ${t} \
          -r ${d}/03-My_clean_data/${Sp_name}_clean.single.fq.gz \
          -o ${eas_dir} \
          --prefix ${Sp_name} \
          --cpu ${nt_hybpiper} > /dev/null
          stage2_cmd "hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/03-My_clean_data/${Sp_name}_clean.single.fq.gz -o ${eas_dir} --prefix ${Sp_name} --cpu ${nt_hybpiper}" > /dev/null
        fi
        #02: for nucleotide reference sequence
        if [ "${hybpiper_tt}" = "dna" ]; then
          hybpiper assemble "-t_${hybpiper_tt}" ${t} \
          -r ${d}/03-My_clean_data/${Sp_name}_clean.single.fq.gz \
          -o ${eas_dir} \
          --prefix ${Sp_name} \
          --bwa \
          --cpu ${nt_hybpiper} > /dev/null
          stage2_cmd "hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/03-My_clean_data/${Sp_name}_clean.single.fq.gz -o ${eas_dir} --prefix ${Sp_name} --bwa --cpu ${nt_hybpiper}" > /dev/null
        fi
        if [ -s "${eas_dir}/${Sp_name}/genes_with_seqs.txt" ]; then
          gene_number=$(wc -l < "${eas_dir}/${Sp_name}/genes_with_seqs.txt")
          stage2_info "Successfully assemble ${gene_number} genes for ${Sp_name} via HybPiper." > /dev/null
          stage2_blank "" > /dev/null
        fi
      fi
    else
      stage2_info "Skip ${Sp_name}'s genes, because they have been assembled by HybPiper." > /dev/null
      stage2_blank "" > /dev/null
    fi
  done < ${i}/My_Spname.txt
  echo
fi
echo ""
#(3) Filter by gene coverage
stage2_info "Step2: Filter species by gene coverage ..."
cd ${eas_dir}
mkdir -p "${o}/00-logs_and_reports/HybSuite_reports/HybPiper_Species_with_low_gene_coverage"
> ${o}/00-logs_and_reports/HybSuite_reports/HybPiper_Species_with_low_gene_coverage/Species_with_low_gene_coverage_list.txt
grep '>' ${t} | awk -F'-' '{print $2}' | sort | uniq > ${o}/00-logs_and_reports/HybSuite_reports/Ref_gene_name_list.txt
stage2_info "Species with low gene coverage are as follows:"
for file in *; do
  if [ -d "${file}" ] && [ -f "${file}/genes_with_seqs.txt" ]; then
    num_gene_with_seqs=$(wc -l < "${file}/genes_with_seqs.txt")
    num_gene_with_seqs=$(wc -l < "${file}/genes_with_seqs.txt")
    Total_ref_genes=$(wc -l < "${o}/00-logs_and_reports/HybSuite_reports/Ref_gene_name_list.txt")
    num_gene_with_seqs_filter=$(echo "${Total_ref_genes} * ${gene_coverage}" | bc)
    if (( $(echo "$num_gene_with_seqs < $num_gene_with_seqs_filter" | bc -l) )); then
      mv "${file}" "${o}/00-logs_and_reports/HybSuite_reports/HybPiper_Species_with_low_gene_coverage/"
      echo "${file}" >> "${o}/00-logs_and_reports/HybSuite_reports/HybPiper_Species_with_low_gene_coverage/Species_with_low_gene_coverage_list.txt"
      stage2_blank "                    ${file}"
    fi
  fi
done
stage2_info "You can check the namelist of these species in:"
stage2_blank "                    ${o}/00-logs_and_reports/HybSuite_reports/HybPiper_Species_with_low_gene_coverage/Species_with_low_gene_coverage_list.txt"
stage2_info "The 'hybpiper assemble' results of these species have been moved to:"
stage2_blank "                    ${o}/00-logs_and_reports/HybSuite_reports/HybPiper_Species_with_low_gene_coverage/"
stage2_blank ""
#(4) hybpiper stats to paralog retriever
if [ "${run_hybpiper_stats_to_paralog}" = "FALSE" ]; then
  stage2_info "Skip running hybpiper step3-6."
  else
  if [ -s "${eas_dir}/HybPiper_namelist.txt" ]; then
    cp ${eas_dir}/HybPiper_namelist.txt ${eas_dir}/HybPiper_namelist_old.txt
  fi
  cp ${o}/00-logs_and_reports/species_checklists/All_Spname_list.txt  ${eas_dir}/HybPiper_namelist.txt             
  cd ${eas_dir}

  stage2_info "Step3: Run 'hybpiper stats' ..."
  stage2_cmd "hybpiper stats "-t_${hybpiper_tt}" ${t} ${hybpiper_rs} ${o}/00-logs_and_reports/species_checklists/All_Spname_list.txt"
  hybpiper stats "-t_${hybpiper_tt}" ${t} ${hybpiper_rs} ${o}/00-logs_and_reports/species_checklists/All_Spname_list.txt > /dev/null
  if [ -s "./seq_lengths.tsv" ]; then
    stage2_info "Successfully finish running 'hybpiper stats'. "
    stage2_info "A sequence length table has been written to file: ${o}/01-HybPiper_results/02-stats/seq_lengths.tsv"
    stage2_blank ""
  else
    stage2_error "Fail to run 'hybpiper stats'."
    stage2_info "HybSuite exits."
    stage2_blank ""
    exit 1
  fi

  stage2_info "Step4: Run 'hybpiper recovery_heatmap' ..."
  stage2_cmd "hybpiper recovery_heatmap seq_lengths.tsv --heatmap_dpi ${hybpiper_heatmap_dpi}"
  hybpiper recovery_heatmap seq_lengths.tsv --heatmap_dpi ${hybpiper_heatmap_dpi} > /dev/null
  if [ -s "./recovery_heatmap.png" ]; then
    stage2_info "Successfully finish running 'hybpiper recovery_heatmap'. "
    stage2_info "A recovery heatmap has been written to file: ${o}/01-HybPiper_results/03-recovery_heatmap/recovery_heatmap.png"
    stage2_blank ""
  else
    stage2_error "Fail to run 'hybpiper recovery_heatmap'."
    stage2_info "HybSuite exits."
    stage2_blank ""
    exit 1
  fi
  mv seq_lengths.tsv ${o}/01-HybPiper_results/02-stats/
  mv hybpiper_stats.tsv ${o}/01-HybPiper_results/02-stats/
  mv recovery_heatmap.png ${o}/01-HybPiper_results/03-recovery_heatmap/

  stage2_info "Step5: Run 'hybpiper retrieve_sequences' ..."
  if [ -d "${o}/01-HybPiper_results/04-retrieve_sequences/" ]; then
    rm -rf "${o}/01-HybPiper_results/04-retrieve_sequences/"
  fi
  mkdir -p "${o}/01-HybPiper_results/04-retrieve_sequences/"
  if [ "${hybpiper_tr}" = "dna" ]; then
    stage2_cmd "hybpiper retrieve_sequences "-t_${hybpiper_tt}" ${t} dna --sample_names ${o}/00-logs_and_reports/species_checklists/All_Spname_list.txt --fasta_dir ${o}/01-HybPiper_results/04-retrieve_sequences"
    hybpiper retrieve_sequences "-t_${hybpiper_tt}" ${t} dna \
    --sample_names ${o}/00-logs_and_reports/species_checklists/All_Spname_list.txt \
    --fasta_dir ${o}/01-HybPiper_results/04-retrieve_sequences > /dev/null
    if find "${o}/01-HybPiper_results/04-retrieve_sequences" -type f -name "*.FNA" -size +0c | grep -q . 2>/dev/null; then
      stage2_info "Successfully finish running 'hybpiper retrieve_sequences'. "
      stage2_blank ""
    else
      stage2_error "Fail to run 'hybpiper retrieve_sequences'."
      stage2_info "HybSuite exits."
      stage2_blank ""
      exit 1
    fi
  fi
  if [ "${hybpiper_tr}" = "aa" ]; then
    stage2_cmd "hybpiper retrieve_sequences "-t_${hybpiper_tt}" ${t} aa --sample_names ${o}/00-logs_and_reports/species_checklists/All_Spname_list.txt --fasta_dir ${o}/01-HybPiper_results/04-retrieve_sequences"
    hybpiper retrieve_sequences "-t_${hybpiper_tt}" ${t} aa \
    --sample_names ${o}/00-logs_and_reports/species_checklists/All_Spname_list.txt \
    --fasta_dir ${o}/01-HybPiper_results/04-retrieve_sequences > /dev/null
    if find "${o}/01-HybPiper_results/04-retrieve_sequences" -type f -name "*.AA" -size +0c | grep -q . 2>/dev/null; then
      stage2_info "Successfully finish running 'hybpiper retrieve_sequences'. "
      stage2_blank ""
    else
      stage2_error "Fail to run 'hybpiper retrieve_sequences'."
      stage2_info "HybSuite exits."
      stage2_blank ""
      exit 1
    fi
  fi

  stage2_info "Step6: Run 'hybpiper paralog_retriever' ..."
  if [ -d "${o}/01-HybPiper_results/05-paralogs_all_fasta/" ]; then
    rm -rf "${o}/01-HybPiper_results/05-paralogs_all_fasta/"
  fi
  mkdir -p "${o}/01-HybPiper_results/05-paralogs_all_fasta/"
  stage2_cmd "hybpiper paralog_retriever ${o}/00-logs_and_reports/species_checklists/All_Spname_list.txt "-t_${hybpiper_tt}" ${t} --fasta_dir_all ${o}/01-HybPiper_results/05-paralogs_all_fasta --heatmap_dpi ${hybpiper_heatmap_dpi}"
  hybpiper paralog_retriever ${o}/00-logs_and_reports/species_checklists/All_Spname_list.txt "-t_${hybpiper_tt}" ${t} \
  --fasta_dir_all ${o}/01-HybPiper_results/05-paralogs_all_fasta \
  --heatmap_dpi ${hybpiper_heatmap_dpi} > /dev/null
  if [ ! -s "./paralog_report.tsv" ] && [ ! -s "./paralog_heatmap.png" ] && [ ! -s "./paralogs_above_threshold_report.txt" ]; then
    stage2_error "Fail to run 'hybpiper paralog_retriever'."
    stage2_info "HybSuite exits."
    stage2_blank ""
    exit 1
  else
    stage2_info "Successfully finish running 'hybpiper paralog_retriever'. "
    stage2_blank ""
  fi
  mv paralog_report.tsv ${o}/01-HybPiper_results/06-paralogs_reports
  mv paralog_heatmap.png ${o}/01-HybPiper_results/06-paralogs_reports
  mv paralogs_above_threshold_report.txt ${o}/01-HybPiper_results/06-paralogs_reports
  find "${o}/01-HybPiper_results/05-paralogs_all_fasta/" -type f -empty -delete
fi
#(5) Add other sequences (-other_seqs)
if [ "${other_seqs}" != "_____" ] && [ "${add_other_seqs}" = "TRUE" ]; then
  stage2_blank ""
  stage2_info "<<==== Adding other single copy orthologs ====>>"
  stage2_info "You set option: -other_seqs, so HybSuite will add these sequences and view them directly as single copy orthologs"
  cd "${other_seqs}"
  mkdir -p ${o}/02-Alignments/Other_single_hit_seqs/
  > ${o}/00-logs_and_reports/species_checklists/Other_seqs_Spname_list.txt

  if ls ${o}/02-Alignments/Other_single_hit_seqs/*.fasta 1> /dev/null 2>&1; then
    rm ${o}/02-Alignments/Other_single_hit_seqs/*.fasta
  fi
  for file in *.fasta; do
    add_sp="${file%.fasta}"
    stage2_info "For ${add_sp}:"
    echo ${add_sp} >> ${o}/00-logs_and_reports/species_checklists/Other_seqs_Spname_list.txt
    total_genes=$(awk 'END {print NR}' "${o}/00-logs_and_reports/HybSuite_reports/Ref_gene_name_list.txt")
    j=0
    last_progress=-1
    while IFS= read -r add_gene || [ -n "$add_gene" ]; do
      sed -e "s|^.*[gene=${add_gene}].*$|>${add_gene} single_hit|g" "${file}" > "${add_sp}_${add_gene}_single_hit.fa"
      sed -e "s|>${add_gene}.*$|>${add_gene} single_hit|g" "${file}" > "${add_sp}_${add_gene}_single_hit.fa"
      awk -v gene=">${add_gene} single_hit" '/^>/ {if (print_flag) print ""; print_flag=0} $0 ~ gene {print_flag=1} print_flag {print} END {if (print_flag) print ""}' \
      "${add_sp}_${add_gene}_single_hit.fa" >> "${o}/01-HybPiper_results/05-paralogs_all_fasta/${add_gene}_paralogs_all.fasta" 
      awk -v gene=">${add_gene} single_hit" '/^>/ {if (print_flag) print ""; print_flag=0} $0 ~ gene {print_flag=1} print_flag {print} END {if (print_flag) print ""}' \
      "${add_sp}_${add_gene}_single_hit.fa" >> "${o}/02-Alignments/Other_single_hit_seqs/${add_gene}.fasta"
      awk -v gene=">${add_gene} single_hit" '/^>/ {if (print_flag) print ""; print_flag=0} $0 ~ gene {print_flag=1} print_flag {print} END {if (print_flag) print ""}' \
      "${add_sp}_${add_gene}_single_hit.fa" >> "${o}/01-HybPiper_results/04-retrieve_sequences/${add_gene}.FNA"
      sed -i "s|${add_gene}|${add_sp}|g;/^$/d" "${o}/01-HybPiper_results/05-paralogs_all_fasta/${add_gene}_paralogs_all.fasta" > /dev/null
      sed -i "s|${add_gene}|${add_sp}|g;/^$/d" "${o}/02-Alignments/Other_single_hit_seqs/${add_gene}.fasta" > /dev/null
      sed -i "s|${add_gene}|${add_sp}|g;/^$/d" "${o}/01-HybPiper_results/04-retrieve_sequences/${add_gene}.FNA" > /dev/null
      j=$((j + 1))
      progress=$((j * 100 / total_genes))
      if (( progress % 20 == 0 && progress != last_progress )); then
        last_progress=$progress
        printf "\r[HybSuite-INFO]:    Adding genes: ${j}/${total_genes} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress" | tee -a "${o}/00-logs_and_reports/logs/Stage2_HybPiper_pipeline_${current_time}.log"
      else
        printf "\r[HybSuite-INFO]:    Adding genes: ${j}/${total_genes} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress"
      fi
    done < "${o}/00-logs_and_reports/HybSuite_reports/Ref_gene_name_list.txt"
    echo
    find . -type f -name "*.fa" -exec rm -f {} +
  done
  cd "${o}"/01-HybPiper_results/05-paralogs_all_fasta/
  for file in *.fasta; do
    line_length=60 
    {
    while read -r line; do
    if [ "${line:0:1}" = ">" ]; then
      if [ -n "$sequence" ]; then
        echo "$sequence" | fold -w $line_length >> "${file}_temp"
      fi
      echo "$line" >> "${file}_temp"
      sequence=""
    else
      sequence="${sequence}${line}"
    fi
    done
    if [ -n "$sequence" ]; then
      echo "$sequence" | fold -w $line_length >> "${file}_temp"
    fi
    } < "${file}"
    mv "${file}_temp" "${file}"
  done
  cd "${o}"/01-HybPiper_results/04-retrieve_sequences/
  for file in *.FNA; do
    line_length=60
    {
    while read -r line; do
    if [ "${line:0:1}" = ">" ]; then
      if [ -n "$sequence" ]; then
        echo "$sequence" | fold -w $line_length >> "${file}_temp"
      fi
      echo "$line" >> "${file}_temp"
      sequence=""
    else
      sequence="${sequence}${line}"
    fi
    done
    if [ -n "$sequence" ]; then
      echo "$sequence" | fold -w $line_length >> "${file}_temp"
    fi
    } < "${file}"
    mv "${file}_temp" "${file}"
  done
fi
if [ -s "${o}/00-logs_and_reports/species_checklists/Other_seqs_Spname_list.txt" ]; then
  cp "${o}/00-logs_and_reports/species_checklists/All_Spname_list.txt" "${o}/00-logs_and_reports/species_checklists/All_Spname_list2.txt"
  cat "${o}/00-logs_and_reports/species_checklists/All_Spname_list2.txt" "${o}/00-logs_and_reports/species_checklists/Other_seqs_Spname_list.txt" \
  > "${o}/00-logs_and_reports/species_checklists/All_Spname_list.txt"
  rm "${o}/00-logs_and_reports/species_checklists/All_Spname_list2.txt"
fi
#(6) Conclusion
if [ -s "${o}/01-HybPiper_results/06-paralogs_reports/paralog_heatmap.png" ]; then
  stage2_info "Successfully finish the stage2: 'HybPiper pipeline'."
  stage2_blank "                    The resulting files have been saved in ${o}/01-HybPiper_results"
  stage2_info "Moving on to the next stage..."
else
  stage2_error "Fail to finish the stage2: 'HybPiper pipeline'. Please check your input files."
  stage2_blank ""
  stage2_blank "                    HybSuite exits."
  stage2_blank ""
  exit 1
fi

if [ "${run_to_hybpiper}" = "true" ]; then
  stage2_blank ""
  stage2_info "Congratulations! You have finished stage1 and stage2."
  stage2_blank ""
  stage2_blank "                    HybSuite exits."
  stage2_blank ""
  exit 1
fi

#===> Stage 3 Orthologs Inference <===#
#0. Preparation
stage3_info() {
  echo "[HybSuite-INFO]:    $1" | tee -a "${o}/00-logs_and_reports//logs/Stage3_Orthologs_inference_${current_time}.log"
}
stage3_error() {
  echo "[HybSuite-ERROR]:   $1" | tee -a "${o}/00-logs_and_reports//logs/Stage3_Orthologs_inference_${current_time}.log"
}
stage3_cmd() {
  echo "[HybSuite-CMD]:     $1" | tee -a "${o}/00-logs_and_reports//logs/Stage3_Orthologs_inference_${current_time}.log"
}
stage3_blank() {
  echo "$1" | tee -a "${o}/00-logs_and_reports//logs/Stage3_Orthologs_inference_${current_time}.log"
}

if [ -s "${o}/00-logs_and_reports/logs/Stage3_Orthologs_inference_${current_time}.log" ]; then
  rm "${o}/00-logs_and_reports/logs/Stage3_Orthologs_inference_${current_time}.log"
fi
stage3_blank ""
stage3_info "<<<======= Stage3 Orthologs inference =======>>>"
# Change the conda environment
eval "$(conda shell.bash hook)"
conda activate ${conda1}
stage3_cmd "conda activate ${conda1}" 
if [ "$CONDA_DEFAULT_ENV" = "${conda1}" ]; then
  stage3_info "Successfully activate ${conda1} conda environment"
  stage3_blank "                    PASS" 
  stage3_blank ""
else
  stage3_error "Fail to activate ${conda1} conda environment"
  stage3_blank "                    HybSuite exits."
  stage3_blank ""
exit 1
fi

#Preparation: Filter alignments by species coverage
if (([ "$LS" = "TRUE" ] || [ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "${one_to_one}" = "TRUE" ]) && [ "${run_paragone}" = "TRUE" ]) || [ "${RAPP}" = "TRUE" ]; then
  stage3_info "Optional Step: Filter all paralogs sequences by species coverage for RAPP/LS/MI/MO/RT/1to1 algorithm..."
  mkdir -p "${o}/00-logs_and_reports/HybSuite_reports/HybPiper_Genes_with_low_species_coverage"
  cd "${o}/01-HybPiper_results/05-paralogs_all_fasta"
  mkdir -p "${o}/02-Alignments/Filtered_all_paralogs"
  > ${o}/00-logs_and_reports/HybSuite_reports/HybPiper_Genes_with_low_species_coverage/Genes_with_low_species_coverage.txt
  for file in *.fasta; do
    filename=${file%_paralogs_all.fasta}
    count_cover=$(grep '>' ${file} | sed 's/\..*$//g;s/ single_hit//g;s/ multi_hit_stitched_contig_comprising_.*$//g' | sort| uniq | wc -l)
    count_sp=$(grep -c '.' "${o}/00-logs_and_reports/species_checklists/All_Spname_list.txt")
    count_sp_filter=$(echo "${count_sp} * ${sp_coverage}" | bc)
    if (( $(echo "$count_cover >= $count_sp_filter" | bc -l) )); then
      cp ${file} "${o}/02-Alignments/Filtered_all_paralogs/" 
      sed -i 's/_R_//g' "${o}/02-Alignments/Filtered_all_paralogs/${file}"
    else
      cp ${file} "${o}/00-logs_and_reports/HybSuite_reports/HybPiper_Genes_with_low_species_coverage"
      stage3_info "Sequence ${file} has been filterd because it can only cover less than ${sp_coverage} of all species."
      echo ${filename} >> ${o}/00-logs_and_reports/HybSuite_reports/HybPiper_Genes_with_low_species_coverage/Genes_with_low_species_coverage.txt
    fi  
  done
  stage3_info "Finish"
fi
mkdir -p "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports
#1. HRS
# Batch multiple sequence alignment using mafft (only gene sets with data are selected for running mafft alignment):
if [ "${HRS}" = "TRUE" ]; then
  stage3_blank ""
  stage3_info "Optional Part: Run HRS (HybPiper retrieved sequences) ..."
  stage3_info "You choose HRS method, so HybSuite will directly align sequences which are retrived by HybPiper."
  if [ -d "${o}/02-Alignments/HRS/" ]; then
    rm -rf "${o}/02-Alignments/HRS"/*
  fi
  # (1) Filter genes
  ### 00 Create necessary directories and change working directories
  mkdir -p "${o}/02-Alignments/HRS/01_filtered_genes"
  cd ${o}/01-HybPiper_results/04-retrieve_sequences
  ### 01 Select the gene set that covers more than n * species
  stage3_info "Step1: Filter genes with lower than ${sp_coverage} species coverage ..."
  for sample in *.FNA; do
    # Count the number of lines containing ">" in each file 
    count_cover=$(grep -c '>' "$sample")
    count_sp=$(grep -c '.' "${eas_dir}/HybPiper_namelist.txt")
    count_sp_filter=$(echo "${count_sp} * ${sp_coverage}" | bc)

    if (( $(echo "$count_cover >= $count_sp_filter" | bc -l) )); then
      cp ${sample} "${o}/02-Alignments/HRS/01_filtered_genes/" 
      sed -i 's/_R_//g' "${o}/02-Alignments/HRS/01_filtered_genes/${sample}"
    else
      stage3_info "${sample} has been filterd because it can only cover less than ${sp_coverage} of all species." > /dev/null
    fi  
  done
  stage3_info "Finish"
  
  # (2) MAFFT
  ### 00 Make necessary directories and change working directories
  if [ ! -e "${o}/02-Alignments/HRS/02_alignments_mafft" ]; then
    mkdir -p "${o}/02-Alignments/HRS/02_alignments_mafft"
  else
    if [ "$(ls -A "${o}/02-Alignments/HRS/02_alignments_mafft")" ]; then
      rm ${o}/02-Alignments/HRS/02_alignments_mafft/*
    fi
  fi
  cd "${o}/02-Alignments/HRS/01_filtered_genes/"
  ### 01 Sort the contents of files A and B and save them to a temporary file
  sort ${eas_dir}/HybPiper_namelist_old.txt > sorted_fileA.txt
  sort ${eas_dir}/HybPiper_namelist.txt > sorted_fileB.txt
  ### 02 Compare the sorted files
  if diff -q sorted_fileA.txt sorted_fileB.txt >/dev/null && [ "$run_mafft" = "FALSE" ]; then
    stage3_info "HybSuite will not run mafft again because the sequences have been aligned."
  else
  stage3_info "Step2: Run MAFFT to produce HRS alignments"
  ### 03 Align the genes datasets which contain at least one species' sequence
    first_iteration=true
    stage3_info "<<==== Running MAFFT to produce HRS alignments ====>>"
    total_sps=$(find . -maxdepth 1 -type f -name "*.FNA" | wc -l)
    j=0
    for sample in *.FNA; do
      file_path="${sample}"
      if [ -s "$file_path" ]; then 
        if [ "$mafft" = "auto" ]; then
          mafft --quiet --auto \
          --thread "${nt_mafft}" \
          ./${sample} > ${o}/02-Alignments/HRS/02_alignments_mafft/${sample}
          stage3_cmd "mafft --quiet --auto --thread ${nt_mafft} ./${sample} > ${o}/02-Alignments/HRS/01_filtered_genes/${sample}" > /dev/null
          sed -i 's/_R_//g' ${o}/02-Alignments/HRS/02_alignments_mafft/${sample}
        else
          mafft-linsi --quiet --adjustdirectionaccurately \
          --thread "${nt_mafft}" \
          --op 3 \
          --ep 0.123 \
          "./${sample}" > "${o}/02-Alignments/HRS/02_alignments_mafft/${sample}"
          stage3_cmd "mafft-linsi --quiet --adjustdirectionaccurately --thread ${nt_mafft} --op 3 --ep 0.123 ./${sample} > ${o}/02-Alignments/HRS/01_filtered_genes/${sample}" > /dev/null
          sed -i 's/_R_//g' ${o}/02-Alignments/HRS/02_alignments_mafft/${sample}
        fi
      else
        if [ "$first_iteration" = true ]; then
          stage3_blank "" > /dev/null
          stage3_info "Attention:" > /dev/null
          first_iteration=false
        fi
        stage3_info "The dataset does not contain genes ${sample} for any of the species."  > /dev/null
      fi
      j=$((j + 1))
      progress=$((j * 100 / total_sps))
      printf "\r[HybSuite-INFO]:    MAFFT: ${j}/${total_sps} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress"
    done
    echo
  fi

 ### 04 Remove "single*" and "multi*"
  cd ${o}/02-Alignments/HRS/02_alignments_mafft/
  stage3_info "Step3: Rename the title of every sequence"
  for sample in *.FNA; do
    if [ -s "${sample}" ]; then
      sed -i 's/ single_hit//g;s/ multi_hit_stitched_contig_comprising_.*_hits//g' "${sample}"
    else
      stage3_error "There is no sequence prepared to run MAFFT."
      stage3_info "HybSuite exits."
      exit 1
    fi
  done
  stage3_info "Finish producing HRS alignments"
fi

#2. RAPP (optional)
if [ "${RAPP}" = "TRUE" ]; then
  stage3_blank ""
  stage3_info "Optional Part: Run RAPP (Remove all putative paralogs) ..."
  ### 01 Make necessary directories and change working directories
  if [ -d "${o}/02-Alignments/RAPP/" ]; then
    rm -rf "${o}/02-Alignments/RAPP"/*
  fi
  chars="01_seqs_with_only_paralog_warnings 02_seqs_without_paralog_warnings 01_seqs_with_only_paralog_warnings/gene_titles_list 02_seqs_without_paralog_warnings/gene_titles_list 03_seqs_with_single_or_multi_hit/single_hit_titles 03_seqs_with_single_or_multi_hit/multi_hit_titles 04_alignments_mafft 05_alignments_trimal"
  for dir in ${chars}; do  
    mkdir -p "${o}/02-Alignments/RAPP/${dir}" 
  done
  cd ${o}/02-Alignments/Filtered_all_paralogs
  
  ### 02 remove all putative paralogs (RAPP)
  stage3_info "Step1: Remove all putative paralogs (RAPP)"
  total_sps=$(find . -maxdepth 1 -type f -name "*.fasta" | wc -l)
  j=0
  stage3_info "<<==== Running RAPP ====>>"
  for file in *.fasta; do
    new_file=$(echo "$file" | sed 's/_paralogs_all.fasta//g')
    grep '_length_' "${file}" | grep '>' | sed -e 's/>//g' > ${o}/02-Alignments/RAPP/01_seqs_with_only_paralog_warnings/gene_titles_list/gene_${new_file}_titles_seqs_with_only_paralog_warnings.txt
    grep -v '_length_' "${file}" | grep '>' | sed -e 's/>//g' > ${o}/02-Alignments/RAPP/02_seqs_without_paralog_warnings/gene_titles_list/gene_${new_file}_titles_seqs_without_paralog_warnings.txt
    grep 'multi_hit' "${file}" | grep '>' | sed -e 's/>//g' > ${o}/02-Alignments/RAPP/03_seqs_with_single_or_multi_hit/multi_hit_titles/gene_${new_file}_titles_multi_hit.txt
    grep 'single_hit' "${file}" | grep '>' | sed -e 's/>//g' > ${o}/02-Alignments/RAPP/03_seqs_with_single_or_multi_hit/single_hit_titles/gene_${new_file}_titles_single_hit.txt
    awk 'NR==1 {print $0; next} $0 ~ /^>/ {print "\n" $0; next} {printf $0}' \
    ${file} > "${o}/02-Alignments/RAPP/${new_file}.fasta"
    # seqs with only paralog warnings
    grep -A 1 'NODE_' "${o}/02-Alignments/RAPP/${new_file}.fasta" > "${o}/02-Alignments/RAPP/01_seqs_with_only_paralog_warnings/gene_${new_file}_seqs_with_only_paralog_warnings.fasta"  
    sed -i '/^--$/d' "${o}/02-Alignments/RAPP/01_seqs_with_only_paralog_warnings/gene_${new_file}_seqs_with_only_paralog_warnings.fasta"
    # seqs without paralog warnings
    if [ "${RAPP_mode}" = "seqs" ]; then
      grep -A 1 -E ' multi_hit| single_hit' "${o}/02-Alignments/RAPP/${new_file}.fasta" > "${o}/02-Alignments/RAPP/02_seqs_without_paralog_warnings/gene_${new_file}_seqs_without_paralog_warnings.fasta"
      sed -i '/^--$/d' "${o}/02-Alignments/RAPP/02_seqs_without_paralog_warnings/gene_${new_file}_seqs_without_paralog_warnings.fasta"
    fi
    if [ "${RAPP_mode}" = "loci" ]; then
      if ! grep -q ' NODE_' "${o}/02-Alignments/RAPP/${new_file}.fasta"; then
        grep -A 1 -E ' multi_hit| single_hit' "${o}/02-Alignments/RAPP/${new_file}.fasta" > "${o}/02-Alignments/RAPP/02_seqs_without_paralog_warnings/gene_${new_file}_seqs_without_paralog_warnings.fasta"
        sed -i '/^--$/d' "${o}/02-Alignments/RAPP/02_seqs_without_paralog_warnings/gene_${new_file}_seqs_without_paralog_warnings.fasta"
      fi
    fi
    # single_hit
    if [ -d "${o}/01-HybPiper_results/01-assemble/paralogs_no_chimeras" ]; then
      mv "${o}/01-HybPiper_results/01-assemble/paralogs_no_chimeras" "${o}/02-Alignments/RAPP/03_seqs_with_single_or_multi_hit/"
    fi
    rm "${o}/02-Alignments/RAPP/${new_file}.fasta"
    j=$((j + 1))
    progress=$((j * 100 / total_sps))
    printf "\r[HybSuite-INFO]:    RAPP: ${j}/${total_sps} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress"
  done
  echo
  find "${o}/02-Alignments/RAPP/01_seqs_with_only_paralog_warnings/" -type f -empty -delete
  find "${o}/02-Alignments/RAPP/02_seqs_without_paralog_warnings/" -type f -empty -delete
  find "${o}/02-Alignments/RAPP/03_seqs_with_single_or_multi_hit/" -type f -empty -delete
  sed -i 's/\.[0-9]\+ NODE.*$//g;s/\.main NODE.*$//g;s/ single_hit//g;s/ multi_hit_stitched_contig_comprising_.*_hits//g' "${o}/02-Alignments/RAPP/02_seqs_without_paralog_warnings"/*.fasta
  ### 03 Multiple alignments maffting
  ### 03-1 Sort the contents of files A and B and save them to a temporary file
  cd "${o}/02-Alignments/RAPP/02_seqs_without_paralog_warnings"
  sort ${eas_dir}/HybPiper_namelist_old.txt > sorted_fileA.txt
  sort ${eas_dir}/HybPiper_namelist.txt > sorted_fileB.txt
  ### 03-2 Compare the sorted files
  if diff -q sorted_fileA.txt sorted_fileB.txt >/dev/null && [ "$run_mafft" = "FALSE" ]; then
    stage3_info "HybSuite will not run mafft again because the sequences have been aligned."
  else
  stage3_info "Step2: Run MAFFT to produce RAPP alignments ... "
  ### 03-3 Align the genes datasets which contain at least one species' sequence
    first_iteration=true
    stage3_info "<<==== Running MAFFT to produce RAPP alignments ====>>"
    total_sps=$(find . -maxdepth 1 -type f -name "*.fasta" | wc -l)
    j=0
    for sample in *.fasta; do
      file_path="${sample}"
      if [ -s "$file_path" ]; then
        if [ "$mafft" = "auto" ]; then
          mafft --quiet --auto \
          --thread "${nt_mafft}" \
          ./${sample} > ${o}/02-Alignments/RAPP/04_alignments_mafft/${sample}
          stage3_cmd "mafft --quiet --auto --thread ${nt_mafft} ./${sample} > ${o}/02-Alignments/RAPP/04_alignments_mafft/${sample}" > /dev/null
          sed -i 's/_R_//g' ${o}/02-Alignments/RAPP/04_alignments_mafft/${sample}
        else
          mafft-linsi --quiet --adjustdirectionaccurately \
          --thread "${nt_mafft}" \
          --op 3 \
          --ep 0.123 \
          ./${sample} > ${o}/02-Alignments/RAPP/04_alignments_mafft/${sample}
          stage3_cmd "mafft-linsi --quiet --adjustdirectionaccurately --thread ${nt_mafft} --op 3 --ep 0.123 ./${sample} > ${o}/02-Alignments/RAPP/04_alignments_mafft/${sample}" > /dev/null
          sed -i 's/_R_//g' ${o}/02-Alignments/RAPP/04_alignments_mafft/${sample}
        fi
      else
        if [ "$first_iteration" = true ]; then
          stage3_blank ""  > /dev/null
          stage3_info "Attention:" > /dev/null
          first_iteration=false
        fi
        stage3_info "The dataset does not contain genes ${sample} for any of the species."  > /dev/null
      fi
      j=$((j + 1))
      progress=$((j * 100 / total_sps))
      printf "\r[HybSuite-INFO]:    MAFFT: ${j}/${total_sps} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress"
    done
    echo
  fi
  if [ -e "${o}/02-Alignments/RAPP/02_seqs_without_paralog_warnings/sorted_fileA.txt" ]; then
    rm "${o}/02-Alignments/RAPP/02_seqs_without_paralog_warnings"/sorted_fileA.txt
    rm "${o}/02-Alignments/RAPP/02_seqs_without_paralog_warnings"/sorted_fileB.txt
  fi
  stage3_info "Finish producing RAPP alignments."
fi

#3. ParaGone (optional)
if ([ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "${one_to_one}" = "TRUE" ]) && [ "${run_paragone}" = "TRUE" ] && [ "${skip_paragone}" = "FALSE" ]; then
  stage3_blank ""
  stage3_info "Optional Part: Run ParaGone (MO/MI/RT/1to1) ... "
  if [ "${MO}" = "TRUE" ]; then
    stage3_info "You choose MO algorithm, so HybSuite will run MO algorithm via ParaGone."
  fi
  if [ "${MI}" = "TRUE" ]; then
    stage3_info "You choose MI algorithm, so HybSuite will run MI algorithm via ParaGone."
  fi
  if [ "${RT}" = "TRUE" ]; then
    stage3_info "You choose RT algorithm, so HybSuite will runn RT algorithm via ParaGone."
  fi
  if [ "${one_to_one}" = "TRUE" ]; then
    stage3_info "You choose 1to1 algorithm, so HybSuite will extract 1to1 final alignments from the folder of MO alignments."
  fi
  #Preparation: Logs
  stage3_info "Preparation: Activate conda environment ${conda2}"
  stage3_cmd "conda activate ${conda2}"
  conda activate "${conda2}"
  if [ "$CONDA_DEFAULT_ENV" = "${conda2}" ]; then
    stage3_info "Successfully activate ${conda2} conda environment"
    stage3_blank "                    PASS" 
  else
    stage3_error "Fail to activate ${conda2} conda environment"
    stage3_blank "                    HybSuite exits."
    stage3_blank ""
    exit 1
  fi
  # Preparation: Directories and reminders
  mkdir -p ${o}/02-Alignments/ParaGone-results
  # Preparation: remove existed files
  if [ "$(ls -A "${o}/02-Alignments/ParaGone-results")" ]; then
    rm -r "${o}/02-Alignments/ParaGone-results"/*
  fi
  # Preparation: Outgroup processing
  cd ${o}/02-Alignments/ParaGone-results
  outgroup_args=""
  while IFS= read -r line || [ -n "$line" ]; do
    outgroup_args="$outgroup_args --internal_outgroup $line"
  done < ${i}/Outgroup.txt

  # Preparation: change species names to correct ones for running ParaGone 
  for file in "${o}/02-Alignments/Filtered_all_paralogs/"*; do
    sed -i "s/_var\._/_var_/g"  "${file}"
    sed -i "s/_subsp\._/_subsp_/g" "${file}"
    sed -i "s/_f\._/_f_/g" "${file}"
  done
  
  cd "${o}/02-Alignments/ParaGone-results"
  # ParaGone Step1
  stage3_blank ""
  stage3_info "Run ParaGone step1 ... "
  stage3_cmd "paragone check_and_align "${o}/02-Alignments/Filtered_all_paralogs"${outgroup_args} --pool ${paragone_pool} --threads ${nt_paragone}"
  paragone check_and_align "${o}/02-Alignments/Filtered_all_paralogs"${outgroup_args} --pool ${paragone_pool} --threads ${nt_paragone} > /dev/null 2>&1
    
  # ParaGone Step2
  if [ "${paragone_tree}" = "iqtree" ]; then
    stage3_blank ""
    stage3_info "Run ParaGone step2 ... "
    stage3_cmd "paragone alignment_to_tree 04_alignments_trimmed_cleaned --pool ${paragone_pool} --threads ${nt_paragone}"
    paragone alignment_to_tree 04_alignments_trimmed_cleaned --pool ${paragone_pool} --threads ${nt_paragone} > /dev/null 2>&1
  elif [ "${paragone_tree}" = "fasttree" ]; then
    stage3_blank ""
    stage3_info "Run ParaGone step2 ..."
    stage3_cmd "paragone alignment_to_tree 04_alignments_trimmed_cleaned --use_fasttree --pool ${paragone_pool} --threads ${nt_paragone}"
    paragone alignment_to_tree 04_alignments_trimmed_cleaned --use_fasttree --pool ${paragone_pool} --threads ${nt_paragone} > /dev/null 2>&1
  fi
  
  # ParaGone Step3
  # --use_fasttree
  stage3_blank ""
  stage3_info "Run ParaGone step3 ... "
  stage3_cmd "paragone qc_trees_and_extract_fasta 04_alignments_trimmed_cleaned --treeshrink_q_value ${paragone_treeshrink_q_value} --cut_deep_paralogs_internal_branch_length_cutoff ${paragone_cutoff_value}"
  paragone qc_trees_and_extract_fasta 04_alignments_trimmed_cleaned \
  --treeshrink_q_value ${paragone_treeshrink_q_value} \
  --cut_deep_paralogs_internal_branch_length_cutoff ${paragone_cutoff_value} > /dev/null 2>&1
  
  # ParaGone Step4
  if [ "${paragone_tree}" = "iqtree" ]; then
    stage3_blank ""
    stage3_info "Run ParaGone step4 ... "
    stage3_cmd "paragone align_selected_and_tree 04_alignments_trimmed_cleaned --pool ${paragone_pool} --threads ${nt_paragone}"
    paragone align_selected_and_tree 04_alignments_trimmed_cleaned --pool ${paragone_pool} --threads ${nt_paragone} > /dev/null 2>&1
  elif [ "${paragone_tree}" = "fasttree" ]; then
    stage3_blank ""
    stage3_info "Run ParaGone step4 ... "
    stage3_cmd "paragone align_selected_and_tree 04_alignments_trimmed_cleaned --use_fasttree --pool ${paragone_pool} --threads ${nt_paragone}"
    paragone align_selected_and_tree 04_alignments_trimmed_cleaned --pool ${paragone_pool} --threads ${nt_paragone} > /dev/null 2>&1
  fi
  
  # ParaGone Step5
  stage3_blank ""
  stage3_info "Run ParaGone step5 ... "
  stage3_cmd "paragone prune_paralogs --mo --rt --mi"
  paragone prune_paralogs --mo --rt --mi > /dev/null 2>&1
  
  # ParaGone Step6
  if [ "${paragone_keep_files}" = "TRUE" ]; then
    stage3_blank ""
    stage3_info "Run ParaGone step6 ... "
    stage3_cmd "paragone final_alignments --mo --rt --mi --pool ${paragone_pool} --threads ${nt_paragone} --keep_intermediate_files"
    paragone final_alignments --mo --rt --mi --pool ${paragone_pool} --threads ${nt_paragone} --keep_intermediate_files > /dev/null 2>&1
  else
    stage3_blank ""
    stage3_info "Run ParaGone step6 ... "
    stage3_cmd "paragone final_alignments --mo --rt --mi --pool ${paragone_pool} --threads ${nt_paragone}"
    paragone final_alignments --mo --rt --mi --pool ${paragone_pool} --threads ${nt_paragone} > /dev/null 2>&1
  fi
  for file in ${o}/02-Alignments/ParaGone-results/23_MO_final_alignments/*; do
    sed -i "s/_var_/_var\._/g"  "${file}"
    sed -i "s/_subsp_/_subsp\._/g" "${file}"
    sed -i "s/_f_/_f\._/g" "${file}"
  done
  for file in ${o}/02-Alignments/ParaGone-results/24_MI_final_alignments/*; do
    sed -i "s/_var_/_var\._/g"  "${file}"
    sed -i "s/_subsp_/_subsp\._/g" "${file}"
    sed -i "s/_f_/_f\._/g" "${file}"
  done
  for file in ${o}/02-Alignments/ParaGone-results/25_RT_final_alignments/*; do
    sed -i "s/_var_/_var\._/g"  "${file}"
    sed -i "s/_subsp_/_subsp\._/g" "${file}"
    sed -i "s/_f_/_f\._/g" "${file}"
  done
  if [ "${one_to_one}" = "TRUE" ]; then
    cd ${o}/02-Alignments/ParaGone-results/23_MO_final_alignments
    mkdir -p ${o}/02-Alignments/ParaGone-results/HybSuite_1to1_final_alignments
    files=$(find . -maxdepth 1 -type f -name "*1to1*")
    total_sps=$(find . -maxdepth 1 -type f -name "*1to1*" | wc -l)
    j=0
    stage3_info "<<==== Extracting 1to1 alignments ====>>"
    for file in $files; do
      j=$((j + 1 ))
      cp "$file" "../HybSuite_1to1_final_alignments"
      progress=$((j * 100 / total_sps))
      printf "\r[HybSuite-INFO]:    Extract 1to1 alignments: ${j}/${total_sps} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress"
    done
    echo
  fi
  stage3_info "Successfully extract 1to1 final alignments."
  for file in ${o}/02-Alignments/ParaGone-results/HybSuite_1to1_final_alignments/*; do
    sed -i "s/_var_/_var\._/g"  "${file}"
    sed -i "s/_subsp_/_subsp\._/g" "${file}"
    sed -i "s/_f_/_f\._/g" "${file}"
  done
  for file in "${o}/02-Alignments/Filtered_all_paralogs"/*; do
    sed -i "s/_var_/_var\._/g"  "${file}"
    sed -i "s/_subsp_/_subsp\._/g" "${file}"
    sed -i "s/_f_/_f\._/g" "${file}"
  done
  #back to conda1
  stage3_info "Going back to ${conda1} conda environment ..."
  stage3_cmd "conda activate ${conda1}"
  conda deactivate
  conda activate ${conda1} 
  if [ "${CONDA_DEFAULT_ENV}" = "${conda1}" ]; then
    stage3_info "Successfully go back to ${conda1} conda environment"
    echo "                    PASS"
    stage3_blank ""
  fi
  stage3_info "Successfully finish running ParaGone."
fi
#4. phylopypruner (optional)
if [ "$LS" = "TRUE" ] || { ([ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "${one_to_one}" = "TRUE" ]) && [ "${run_phylopypruner}" = "TRUE" ]; }; then
  if [ -d "${o}/02-Alignments/phylopypruner/phylopypruner_input" ]; then
    rm -r "${o}/02-Alignments/phylopypruner/phylopypruner_input"
  fi
  mkdir -p "${o}"/02-Alignments/phylopypruner/phylopypruner_input
  cd ${o}/02-Alignments/phylopypruner
  find "./" -type f -name "*.fasta" -exec rm -f {} \;
  cp ${o}/02-Alignments/Filtered_all_paralogs/*.fasta ${o}/02-Alignments/phylopypruner
  stage3_blank ""
  stage3_info "<<==== Preparing fasta files and single gene trees for PhyloPyPruner ====>> "
  # 1.MAFFT
  total_sps=$(find . -maxdepth 1 -type f -name "*.fasta" | wc -l)
  j=0
  for file in *.fasta; do
    j=$((j + 1))
    filename=${file%.fasta}
    genename=${file%_paralogs_all.fasta}
    grep '>' ${file}|sed 's/>//g' > ${genename}_sqlist.txt
    awk -F' ' '{print $1}' ${genename}_sqlist.txt > ${genename}_splist.txt
    awk '{print $0 "\t" NR}' ${genename}_splist.txt > ${genename}_sp_id_list.txt
    sed -i "s/ single_hit/@single_hit/g;s/ multi/@multi/g;s/ NODE_/@NODE_/g;s/\.[0-9]\+@NODE_/@NODE_/g;s/\.main@NODE_/@NODE_/g" ${file}
    mafft --quiet --auto --thread "${nt_mafft}" "${file}" > ${filename}_mafft.fasta
    rm "${file}" "${genename}"*.txt 
    if [ ! -s "${filename}_mafft.fasta" ]; then
      stage3_error "Fail to run MAFFT for ${file}." > /dev/null
    fi
    progress=$((j * 100 / total_sps))
    printf "\r[HybSuite-INFO]:    1.MAFFT: ${j}/${total_sps} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress"
  done
  echo
  if find ./ -type f -name '*_mafft.fasta' -size +0c | grep -q . >/dev/null; then
    continue
  else
    stage3_error "Fail to run MAFFT."
    stage3_info "HybSuite exits."
    stage3_blank ""
    exit 1
  fi
  #2.TrimAl
  total_sps=$(find . -maxdepth 1 -type f -name "*_mafft.fasta" | wc -l)
  j=0
  for file in *_mafft.fasta; do
    j=$((j + 1))
    genename=${file%_paralogs_all_mafft.fasta}
    trimal -in ${file} -out ./phylopypruner_input/phylopypruner_${genename}.fasta -automated1 > /dev/null 2>&1
    printf "\r[HybSuite-INFO]:    2.TrimAl: ${j}/${total_sps} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress"
    rm "${file}" 
    if [ ! -s "./phylopypruner_input/phylopypruner_${genename}.fasta" ]; then
      stage3_error "Fail to run TrimAl for ${file}" > /dev/null
      stage3_info "HybSuite exits." > /dev/null
      stage3_blank "" > /dev/null
    fi
  done
  echo
  #3.FastTree
  total_sps=$(find ./phylopypruner_input/ -maxdepth 1 -type f -name "phylopypruner_*.fasta" | wc -l)
  j=0
  for file in ./phylopypruner_input/phylopypruner_*.fasta; do
    genename=$(basename "$file" .fasta)
    genename=${genename#phylopypruner_}
    j=$((j + 1))
    FastTree -nt -gamma ${file} > ./phylopypruner_input/phylopypruner_${genename}.tre 2>/dev/null
    if [ ! -s "./phylopypruner_input/phylopypruner_${genename}.tre" ]; then
      stage3_error "Fail to run FastTree for ${o}/02-Alignments/phylopypruner/phylopypruner_input/phylopypruner_${genename}.fasta" > /dev/null
      stage3_blank "" > /dev/null
    fi
    progress=$((j * 100 / total_sps))
    printf "\r[HybSuite-INFO]:    3.FastTree: ${j}/${total_sps} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress"
  done
  echo
  
  # LS
  if [ "$LS" = "TRUE" ]; then
    stage3_blank ""
    stage3_info "Running phylopypruner by choosing LS algorithum ..."
    mkdir -p "${o}/02-Alignments/phylopypruner/phylopypruner_output_LS"
    find "${o}/02-Alignments/phylopypruner/phylopypruner_output_LS/" -mindepth 1 -type f -exec rm -f {} +
    find "${o}/02-Alignments/phylopypruner/phylopypruner_output_LS/" -mindepth 1 -type d -exec rm -r {} +
    phylopypruner --overwrite --no-supermatrix \
    --threads ${nt_phylopypruner} \
    --dir ${o}/02-Alignments/phylopypruner/phylopypruner_input \
    --output "${o}/02-Alignments/phylopypruner/phylopypruner_output_LS" \
    --prune LS \
    --trim-lb "${pp_trim_lb}" \
    --min-taxa "${pp_min_taxa}" \
    --min-len "${pp_min_len}" \
    --min-gene-occupancy "${pp_min_gene_occupancy}" \
    --min-otu-occupancy "${pp_min_otu_occupancy}" > /dev/null 2>&1
    stage3_cmd "phylopypruner --overwrite --no-supermatrix --threads ${nt_phylopypruner} --dir ${o}/02-Alignments/phylopypruner/phylopypruner_input --output "${o}/02-Alignments/phylopypruner/phylopypruner_output_LS" --prune LS --trim-lb "${pp_trim_lb}" --min-taxa "${pp_min_taxa}" --min-len "${pp_min_len}" --min-gene-occupancy "${pp_min_gene_occupancy}" --min-otu-occupancy "${pp_min_otu_occupancy}""
    mv "${o}"/02-Alignments/phylopypruner/phylopypruner_output_LS/phylopypruner_output/* "${o}"/02-Alignments/phylopypruner/phylopypruner_output_LS/
    rm -r "${o}"/02-Alignments/phylopypruner/phylopypruner_output_LS/phylopypruner_output
    if [ "$(ls -A "${o}/02-Alignments/phylopypruner/phylopypruner_output_LS/output_alignments")" ]; then
      stage3_info "Successfully finish running phylopypruner for LS."
    else
      stage3_error "Fail to run phylopypruner for LS."
      stage3_blank "                    HybSuite exits."
      stage3_blank ""
      exit 1
    fi
  fi

  # MI
  if [ "$MI" = "TRUE" ] && [ "${run_paragone}" = "FALSE" ]; then
    stage3_blank ""
    stage3_info "Running phylopypruner by choosing MI algorithum ..."
    mkdir -p "${o}/02-Alignments/phylopypruner/phylopypruner_output_MI"
    find "${o}/02-Alignments/phylopypruner/phylopypruner_output_MI/" -mindepth 1 -type f -exec rm -f {} +
    find "${o}/02-Alignments/phylopypruner/phylopypruner_output_MI/" -mindepth 1 -type d -exec rm -r {} +
    phylopypruner --overwrite --no-supermatrix \
    --threads ${nt_phylopypruner} \
    --dir ${o}/02-Alignments/phylopypruner/phylopypruner_input \
    --output "${o}/02-Alignments/phylopypruner/phylopypruner_output_MI" \
    --prune MI \
    --trim-lb "${pp_trim_lb}" \
    --min-taxa "${pp_min_taxa}" \
    --min-len "${pp_min_len}" \
    --min-gene-occupancy "${pp_min_gene_occupancy}" \
    --min-otu-occupancy "${pp_min_otu_occupancy}" > /dev/null 2>&1
    stage3_cmd "phylopypruner --overwrite --no-supermatrix --threads ${nt_phylopypruner} --dir ${o}/02-Alignments/phylopypruner/phylopypruner_input --output "${o}/02-Alignments/phylopypruner/phylopypruner_output_MI" --prune MI --trim-lb "${pp_trim_lb}" --min-taxa "${pp_min_taxa}" --min-len "${pp_min_len}" --min-gene-occupancy "${pp_min_gene_occupancy}" --min-otu-occupancy "${pp_min_otu_occupancy}""
    mv "${o}"/02-Alignments/phylopypruner/phylopypruner_output_MI/phylopypruner_output/* "${o}"/02-Alignments/phylopypruner/phylopypruner_output_MI/
    rm -r "${o}"/02-Alignments/phylopypruner/phylopypruner_output_MI/phylopypruner_output
    if [ "$(ls -A "${o}/02-Alignments/phylopypruner/phylopypruner_output_MI/output_alignments")" ]; then
      stage3_info "Successfully finish running phylopypruner for MI."
    else
      stage3_error "Fail to run phylopypruner for MI."
      stage3_blank "                    HybSuite exits."
      stage3_blank ""
      exit 1
    fi
  fi

  # MO
  if [ "$MO" = "TRUE" ] && [ "${run_paragone}" = "FALSE" ]; then
    stage3_blank ""
    stage3_info "Running phylopypruner by choosing MO algorithum ..."
    outgroup_args=""
    while IFS= read -r line || [ -n "$line" ]; do
      outgroup_args="$outgroup_args $line"
    done < ${i}/Outgroup.txt
    mkdir -p "${o}/02-Alignments/phylopypruner/phylopypruner_output_MO"
    find "${o}/02-Alignments/phylopypruner/phylopypruner_output_MO/" -mindepth 1 -type f -exec rm -f {} +
    find "${o}/02-Alignments/phylopypruner/phylopypruner_output_MO/" -mindepth 1 -type d -exec rm -r {} +
    phylopypruner --overwrite --no-supermatrix \
    --threads ${nt_phylopypruner} \
    --dir ${o}/02-Alignments/phylopypruner/phylopypruner_input \
    --output "${o}/02-Alignments/phylopypruner/phylopypruner_output_MO" \
    --outgroup${outgroup_args} \
    --prune MO \
    --trim-lb "${pp_trim_lb}" \
    --min-taxa "${pp_min_taxa}" \
    --min-len "${pp_min_len}" \
    --min-gene-occupancy "${pp_min_gene_occupancy}" \
    --min-otu-occupancy "${pp_min_otu_occupancy}" > /dev/null 2>&1
    stage3_cmd "phylopypruner --overwrite --no-supermatrix --threads ${nt_phylopypruner} --dir ${o}/02-Alignments/phylopypruner/phylopypruner_input --output ${o}/02-Alignments/phylopypruner/phylopypruner_output_MO --outgroup${outgroup_args} --prune MO --trim-lb ${pp_trim_lb} --min-taxa ${pp_min_taxa} --min-len ${pp_min_len} --min-gene-occupancy ${pp_min_gene_occupancy} --min-otu-occupancy ${pp_min_otu_occupancy}"
    mv "${o}"/02-Alignments/phylopypruner/phylopypruner_output_MO/phylopypruner_output/* "${o}"/02-Alignments/phylopypruner/phylopypruner_output_MO/
    # rm -r "${o}"/02-Alignments/phylopypruner/phylopypruner_output_MO/phylopypruner_output
    if [ "$(ls -A "${o}/02-Alignments/phylopypruner/phylopypruner_output_MO/output_alignments")" ]; then
      stage3_info "Successfully finish running phylopypruner for MO."
    else
      stage3_error "Fail to run phylopypruner for MO."
      stage3_blank "                    HybSuite exits."
      stage3_blank ""
      exit 1
    fi
  fi

  # RT
  if [ "$RT" = "TRUE" ] && [ "${run_paragone}" = "FALSE" ]; then
    stage3_blank ""
    stage3_info "Running phylopypruner by choosing RT algorithum ..."
    outgroup_args=""
    while IFS= read -r line || [ -n "$line" ]; do
      outgroup_args="$outgroup_args $line"
    done < ${i}/Outgroup.txt
    mkdir -p "${o}/02-Alignments/phylopypruner/phylopypruner_output_RT"
    find "${o}/02-Alignments/phylopypruner/phylopypruner_output_RT/" -mindepth 1 -type f -exec rm -f {} +
    find "${o}/02-Alignments/phylopypruner/phylopypruner_output_RT/" -mindepth 1 -type d -exec rm -r {} +
    phylopypruner --overwrite --no-supermatrix \
    --threads ${nt_phylopypruner} \
    --dir ${o}/02-Alignments/phylopypruner/phylopypruner_input \
    --output "${o}/02-Alignments/phylopypruner/phylopypruner_output_RT" \
    --outgroup${outgroup_args} \
    --prune RT \
    --trim-lb "${pp_trim_lb}" \
    --min-taxa "${pp_min_taxa}" \
    --min-len "${pp_min_len}" \
    --min-gene-occupancy "${pp_min_gene_occupancy}" \
    --min-otu-occupancy "${pp_min_otu_occupancy}" > /dev/null 2>&1
    stage3_cmd "phylopypruner --overwrite --no-supermatrix --threads ${nt_phylopypruner} --dir ${o}/02-Alignments/phylopypruner/phylopypruner_input --output "${o}/02-Alignments/phylopypruner/phylopypruner_output_RT" --prune RT --trim-lb "${pp_trim_lb}" --min-taxa "${pp_min_taxa}" --min-len "${pp_min_len}" --min-gene-occupancy "${pp_min_gene_occupancy}" --min-otu-occupancy "${pp_min_otu_occupancy}""
    mv "${o}"/02-Alignments/phylopypruner/phylopypruner_output_RT/phylopypruner_output/* "${o}"/02-Alignments/phylopypruner/phylopypruner_output_RT/
    rm -r "${o}"/02-Alignments/phylopypruner/phylopypruner_output_RT/phylopypruner_output
    if [ "$(ls -A "${o}/02-Alignments/phylopypruner/phylopypruner_output_RT/output_alignments")" ]; then
      stage3_info "Successfully finish running phylopypruner for RT."
    else
      stage3_error "Fail to run phylopypruner for RT."
      stage3_blank "                    HybSuite exits."
      stage3_blank ""
      exit 1
    fi
  fi

  # 1to1
  if [ "$one_to_one" = "TRUE" ] && [ "${run_paragone}" = "FALSE" ]; then
    stage3_blank ""
    stage3_info "Running phylopypruner by choosing 1to1 algorithum ..."
    mkdir -p "${o}/02-Alignments/phylopypruner/phylopypruner_output_1to1"
    find "${o}/02-Alignments/phylopypruner/phylopypruner_output_1to1/" -mindepth 1 -type f -exec rm -f {} +
    find "${o}/02-Alignments/phylopypruner/phylopypruner_output_1to1/" -mindepth 1 -type d -exec rm -r {} +
    phylopypruner --overwrite --no-supermatrix \
    --threads ${nt_phylopypruner} \
    --dir ${o}/02-Alignments/phylopypruner/phylopypruner_input \
    --output "${o}/02-Alignments/phylopypruner/phylopypruner_output_1to1" \
    --prune 1to1 \
    --trim-lb "${pp_trim_lb}" \
    --min-taxa "${pp_min_taxa}" \
    --min-len "${pp_min_len}" \
    --min-gene-occupancy "${pp_min_gene_occupancy}" \
    --min-otu-occupancy "${pp_min_otu_occupancy}" > /dev/null 2>&1
    stage3_cmd "phylopypruner --overwrite --no-supermatrix --threads ${nt_phylopypruner} --dir ${o}/02-Alignments/phylopypruner/phylopypruner_input --output "${o}/02-Alignments/phylopypruner/phylopypruner_output_1to1" --prune 1to1 --trim-lb "${pp_trim_lb}" --min-taxa "${pp_min_taxa}" --min-len "${pp_min_len}" --min-gene-occupancy "${pp_min_gene_occupancy}" --min-otu-occupancy "${pp_min_otu_occupancy}""
    mv "${o}"/02-Alignments/phylopypruner/phylopypruner_output_1to1/phylopypruner_output/* "${o}"/02-Alignments/phylopypruner/phylopypruner_output_1to1/
    rm -r "${o}"/02-Alignments/phylopypruner/phylopypruner_output_1to1/phylopypruner_output
    if [ "$(ls -A "${o}/02-Alignments/phylopypruner/phylopypruner_output_1to1/output_alignments")" ]; then
      stage3_info "Successfully finish running phylopypruner for 1to1."
    else
      stage3_error "Fail to run phylopypruner for 1to1."
      stage3_blank "                    HybSuite exits."
      stage3_blank ""
      exit 1
    fi
  fi
fi

#5. Trim and concatenate alignments into supermatrix
#Preparation
if [ "${run_paragone}" = "TRUE" ]; then
  stage3_cmd "conda activate ${conda1}"
  conda deactivate
  conda activate ${conda1} 
  if [ "${CONDA_DEFAULT_ENV}" = "${conda1}" ]; then
    stage3_info "Successfully activate ${conda1} conda environment"
    echo "                    PASS"
    stage3_blank ""
  fi
fi
#(1) HRS
if [ "${HRS}" = "TRUE" ]; then
# (1) TrimAl
  ### 00 Create new necessary directories and change working directories
  mkdir -p "${o}/02-Alignments/HRS/03_alignments_trimal"
  if [ "$(ls -A "${o}/02-Alignments/HRS/03_alignments_trimal")" ]; then
    rm "${o}/02-Alignments/HRS/03_alignments_trimal/*"
  fi
  cd ${o}/02-Alignments/HRS/02_alignments_mafft
  
  ### 01 Judge if HybSuite should run trimal sccording to the settings by users
  stage3_info "==> Trim HRS alignments and concatenate them into the supermatrix... <==" 
  if diff -q ${o}/02-Alignments/HRS/01_filtered_genes/sorted_fileA.txt ${o}/02-Alignments/HRS/01_filtered_genes/sorted_fileB.txt >/dev/null && ls ${o}/02-Alignments/HRS/Genes_trimal/*.FNA 1> /dev/null 2>&1 && [ "$run_trimal_again" = "FALSE" ]; then
    stage3_info "HybSuite will not run trimal again because the same sequences have been trimmed."
  elif ! find . -maxdepth 1 -name "*.FNA" -size +0c 1> /dev/null 2>&1; then
    stage3_error "There are no sequences prepared to run trimal or some FNA files are empty."
    exit 1
  else
    stage3_info "Running TrimAl ..."
  fi

  ### 02 run TrimAl in batch mode
  total_sps=$(find . -maxdepth 1 -type f -name "*.FNA" | wc -l)
  j=0
  for sample in *.FNA; do 
    j=$((j + 1))
    progress=$((j * 100 / total_sps))
    printf "\r[HybSuite-INFO]:    Running TrimAl for HRS alignments: ${j}/${total_sps} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress"
    if [ "$replace_n" = "TRUE" ]; then
      sed -e '/^>/! s/n/-/g'  ${sample} > "Without_n_${sample}"
      if [ "${trimal_function}" = "automated1" ]; then
        trimal -in "Without_n_${sample}" -out ${o}/02-Alignments/HRS/03_alignments_trimal/${sample} -automated1 > /dev/null 2>&1
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "Without_n_${sample}" -out ${o}/02-Alignments/HRS/03_alignments_trimal/${sample} -gt ${trimal_gt} > /dev/null 2>&1
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "Without_n_${sample}" -out ${o}/02-Alignments/HRS/03_alignments_trimal/${sample} -gappyout > /dev/null 2>&1
      fi 
    else
      if [ "${trimal_function}" = "automated1" ]; then
        trimal -in "${sample}" -out ${o}/02-Alignments/HRS/03_alignments_trimal/${sample} -automated1 > /dev/null 2>&1
        stage3_cmd "trimal -in "${sample}" -out ${o}/02-Alignments/HRS/03_alignments_trimal/${sample} -automated1" > /dev/null   
        stage3_info "Succeed in trimming the alignment of ${sample}." > /dev/null
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "${sample}" -out ${o}/02-Alignments/HRS/03_alignments_trimal/${sample} -gt ${trimal_gt} > /dev/null 2>&1
        stage3_cmd "trimal -in "${sample}" -out ${o}/02-Alignments/HRS/03_alignments_trimal/${sample} -gt ${trimal_gt}" > /dev/null
        stage3_info "Succeed in trimming the alignment of ${sample}." > /dev/null
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "${sample}" -out ${o}/02-Alignments/HRS/03_alignments_trimal/${sample} -gappyout > /dev/null 2>&1
        stage3_cmd "trimal -in "${sample}" -out ${o}/02-Alignments/HRS/03_alignments_trimal/${sample} -gt ${trimal_gt}" > /dev/null
        stage3_info "Succeed in trimming the alignment of ${sample}." > /dev/null
      fi 
    fi   
  done
  echo
  rm ${o}/02-Alignments/HRS/01_filtered_genes/sorted_fileA.txt
  rm ${o}/02-Alignments/HRS/01_filtered_genes/sorted_fileB.txt

 # (2) run AMAS.py to check every alignments
  stage3_blank ""
  stage3_info "Running AMAS.py to check HRS alignments ... "
  stage3_cmd "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i "${o}"/02-Alignments/HRS/03_alignments_trimal/*.FNA -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_HRS_raw.table"
  python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
  summary -f fasta -d dna -i "${o}"/02-Alignments/HRS/03_alignments_trimal/*.FNA \
  -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_HRS_raw.table > /dev/null 2>&1
  if [ -s "${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_HRS_raw.table" ]; then
    stage3_info "Successfully run AMAS.py to check every HRS alignments."
    stage3_info "Wrote AMAS summaries to file ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_HRS_raw.table"
  else
    stage3_error "Fail to run AMAS.py to check every HRS alignments."
  fi

 # (3) remove alignments with no parsimony informative sites
  stage3_blank ""
  stage3_info "Removing alignments with no parsimony informative sites..."
  if [ -d "${o}/03-Supermatrix/HRS" ]; then
    rm -rf "${o}/03-Supermatrix/HRS"
  fi
  mkdir -p "${o}/03-Supermatrix/HRS"
  awk '$9==0 {print $1}' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_HRS_raw.table > "${o}"/03-Supermatrix/HRS/List-Removed_alignments_for_concatenation.txt
  awk '$9!=0 {print $1}' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_HRS_raw.table > "${o}"/03-Supermatrix/HRS/List-Filtered_alignments_for_concatenation.txt
  awk '$9!=0 {print $0}' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_HRS_raw.table > "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_HRS_final_filtered.table
  while IFS= read -r line || [ -n "$line" ]; do
    mv "${o}"/02-Alignments/HRS/03_alignments_trimal/"${line}" "${o}"/02-Alignments/HRS/03_alignments_trimal/"${line}.removed"
    stage3_info "Filter ${line}"
  done < "${o}"/03-Supermatrix/HRS/List-Removed_alignments_for_concatenation.txt
  num_filtered_aln=$(wc -l < "${o}"/03-Supermatrix/HRS/List-Removed_alignments_for_concatenation.txt)
  stage3_info "Successfully remove ${num_filtered_aln} HRS alignments with no parsimony informative sites."

 # (4) concatenate trimmed alignments
  stage3_blank ""
  stage3_info "concatenating HRS alignments into supermatrix... "
  stage3_cmd "pxcat -s ${o}/02-Alignments/HRS/03_alignments_trimal/*.FNA -p ${o}/03-Supermatrix/HRS/partition.txt -o ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta"
  pxcat \
  -s ${o}/02-Alignments/HRS/03_alignments_trimal/*.FNA \
  -p ${o}/03-Supermatrix/HRS/partition.txt \
  -o ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta
  sed -i 's/AA, /DNA, /g' "${o}/03-Supermatrix/HRS/partition.txt"
  if [ -s "${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta" ]; then
    stage3_info "Successfully concatenate HRS alignments into the supermatrix."
  else
    stage3_error "Fail to concatenate HRS alignments into the supermatrix."
  fi

 # (5) run AMAS.py to check the supermatrix
  stage3_blank ""
  stage3_info "Running AMAS.py to check HRS supermatrix ... "
  stage3_cmd "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta -o ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_HRS_supermatrix.table"
  python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
  summary -f fasta -d dna -i ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta \
  -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_HRS_supermatrix.table > /dev/null 2>&1
  awk 'NR==2' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_HRS_supermatrix.table >> "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_HRS_raw.table
  awk 'NR==2' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_HRS_supermatrix.table >> "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_HRS_final_filtered.table
  if [ -s "${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_HRS_supermatrix.table" ]; then
    stage3_info "Successfully run AMAS.py to check HRS supermatrix."
    stage3_info "Results have been output to ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_HRS_raw.table"
  else
    stage3_error "Fail to run AMAS.py to check HRS supermatrix."
  fi
  rm "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_HRS_supermatrix.table
fi
#(2) RAPP
if [ "${RAPP}" = "TRUE" ]; then
stage3_info "Trim RAPP alignments and concatenate them into the supermatrix..." 
# (1) TrimAl
  if [ "${run_trimal}" = "TRUE" ]; then
    cd "${o}/02-Alignments/RAPP/04_alignments_mafft/"
    total_sps=$(find . -maxdepth 1 -type f -name "*.f*" | wc -l)
    j=0
    stage3_info "==> Trim RAPP alignments and concatenate them into the supermatrix... <=="
    for sample in *.f*; do 
    j=$((j + 1))
    progress=$((j * 100 / total_sps))
    printf "\r[HybSuite-INFO]:    Running TrimAl for RAPP alignments: ${j}/${total_sps} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress"
    if [ "$replace_n" = "TRUE" ]; then
      sed -e '/^>/! s/n/-/g'  ${sample} > "Without_n_${sample}"
      if [ "${trimal_function}" = "automated1" ]; then
        trimal -in "Without_n_${sample}" -out ${o}/02-Alignments/RAPP/05_alignments_trimal/${sample} -automated1 > /dev/null 2>&1
        stage3_cmd "trimal -in Without_n_${sample} -out ${o}/02-Alignments/RAPP/05_alignments_trimal/${sample} -automated1" > /dev/null
        stage3_info "Succeed in trimming the alignment of Without_n_${sample}." > /dev/null
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "Without_n_${sample}" -out ${o}/02-Alignments/RAPP/05_alignments_trimal/${sample} -gt ${trimal_gt} > /dev/null 2>&1
        stage3_cmd "trimal -in Without_n_${sample} -out ${o}/02-Alignments/RAPP/05_alignments_trimal/${sample} -gt ${trimal_gt}" > /dev/null
        stage3_info "Succeed in trimming the alignment of Without_n_${sample}." > /dev/null
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "Without_n_${sample}" -out ${o}/02-Alignments/RAPP/05_alignments_trimal/${sample} -gappyout > /dev/null 2>&1
        stage3_cmd "trimal -in Without_n_${sample} -out ${o}/02-Alignments/RAPP/05_alignments_trimal/${sample} -gappyout" > /dev/null
        stage3_info "Succeed in trimming the alignment of Without_n_${sample}." > /dev/null
      fi 
    else
      if [ "${trimal_function}" = "automated1" ]; then
        trimal -in "${sample}" -out ${o}/02-Alignments/RAPP/05_alignments_trimal/${sample} -automated1 > /dev/null 2>&1
        stage3_cmd "trimal -in ${sample} -out ${o}/02-Alignments/RAPP/05_alignments_trimal/${sample} -automated1" > /dev/null
        stage3_info "Succeed in trimming the alignment of ${sample}." > /dev/null
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "${sample}" -out ${o}/02-Alignments/RAPP/05_alignments_trimal/${sample} -gt ${trimal_gt} > /dev/null 2>&1
        stage3_cmd "trimal -in ${sample} -out ${o}/02-Alignments/RAPP/05_alignments_trimal/${sample} -gt ${trimal_gt}" > /dev/null
        stage3_info "Succeed in trimming the alignment of ${sample}." > /dev/null 
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "${sample}" -out ${o}/02-Alignments/RAPP/05_alignments_trimal/${sample} -gappyout > /dev/null 2>&1
        stage3_cmd "trimal -in ${sample} -out ${o}/02-Alignments/RAPP/05_alignments_trimal/${sample} -gappyout" > /dev/null
        stage3_info "Succeed in trimming the alignment of ${sample}." > /dev/null
      fi 
    fi   
    done
    echo
  fi
  
# (2) run AMAS.py to check every alignments
  stage3_blank ""
  stage3_info "Running AMAS.py to check RAPP alignments ... "
  stage3_cmd "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i "${o}"/02-Alignments/RAPP/05_alignments_trimal/*.fasta -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RAPP_raw.table"
  python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
  summary -f fasta -d dna -i "${o}"/02-Alignments/RAPP/05_alignments_trimal/*.fasta \
  -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RAPP_raw.table > /dev/null 2>&1
  if [ -s "${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RAPP_raw.table" ]; then
    stage3_info "Successfully run AMAS.py to check every RAPP alignments."
    stage3_info "Wrote AMAS summaries to file ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RAPP_raw.table"
  else
    stage3_error "Fail to run AMAS.py to check every RAPP alignments."
  fi

 # (3) remove alignments with no parsimony informative sites
  stage3_blank ""
  stage3_info "Removing alignments with no parsimony informative sites..."
  if [ -d "${o}/03-Supermatrix/RAPP" ]; then
    rm -rf "${o}/03-Supermatrix/RAPP"
  fi
  mkdir -p "${o}/03-Supermatrix/RAPP"
  awk '$9==0 {print $1}' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RAPP_raw.table > "${o}"/03-Supermatrix/RAPP/List-Removed_alignments_for_concatenation.txt
  awk '$9!=0 {print $1}' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RAPP_raw.table > "${o}"/03-Supermatrix/RAPP/List-Filtered_alignments_for_concatenation.txt
  awk '$9!=0 {print $0}' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RAPP_raw.table > "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RAPP_final_filtered.table
  while IFS= read -r line || [ -n "$line" ]; do
    mv "${o}"/02-Alignments/RAPP/05_alignments_trimal/"${line}" "${o}"/02-Alignments/RAPP/05_alignments_trimal/"${line}.removed"
    stage3_info "Filter ${line}"
  done < "${o}"/03-Supermatrix/RAPP/List-Removed_alignments_for_concatenation.txt
  num_filtered_aln=$(wc -l < "${o}"/03-Supermatrix/RAPP/List-Removed_alignments_for_concatenation.txt)
  stage3_info "Successfully remove ${num_filtered_aln} RAPP alignments with no parsimony informative sites."

 # (4) concatenate trimmed alignments
  stage3_blank ""
  stage3_info "concatenating RAPP alignments into supermatrix... "
  stage3_cmd "pxcat -s ${o}/02-Alignments/RAPP/05_alignments_trimal/*.fasta -p ${o}/03-Supermatrix/RAPP/partition.txt -o ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta"
  pxcat \
  -s ${o}/02-Alignments/RAPP/05_alignments_trimal/*.fasta \
  -p ${o}/03-Supermatrix/RAPP/partition.txt \
  -o ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta
  sed -i 's/AA, /DNA, /g' "${o}/03-Supermatrix/RAPP/partition.txt"
  if [ -s "${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta" ]; then
    stage3_info "Successfully concatenate RAPP alignments to the supermatrix."
  else
    stage3_error "Fail to concatenate RAPP alignments to the supermatrix."
  fi

 # (5) run AMAS.py to check the supermatrix
  stage3_blank ""
  stage3_info "Running AMAS.py to check RAPP supermatrix ... "
  stage3_cmd "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta -o ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RAPP_supermatrix.table"
  python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
  summary -f fasta -d dna -i ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta \
  -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RAPP_supermatrix.table > /dev/null 2>&1
  awk 'NR==2' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RAPP_supermatrix.table >> "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RAPP_raw.table
  awk 'NR==2' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RAPP_supermatrix.table >> "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RAPP_final_filtered.table
  if [ -s "${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RAPP_supermatrix.table" ]; then
    stage3_info "Successfully run AMAS.py to check RAPP supermatrix."
    stage3_info "Results have been output to ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RAPP_raw.table"
  else
    stage3_error "Fail to run AMAS.py to check RAPP supermatrix."
  fi
  rm "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RAPP_supermatrix.table
fi
#(3) LS
if [ "${LS}" = "TRUE" ]; then
# (1) move alignments
  mkdir -p "${o}/02-Alignments/LS"
  cd "${o}/02-Alignments/phylopypruner/phylopypruner_output_LS/output_alignments"
  find "${o}/02-Alignments/LS/" -type f -name "*.fasta" -exec rm -f {} \;
  find "${o}/02-Alignments/LS/" -type f -name "*.removed" -exec rm -f {} \;
  for file in *.fasta; do
    cp ${file} ${o}/02-Alignments/LS/${file}
    sed -i 's/@.*$//g' ${o}/02-Alignments/LS/${file}
  done
# (2) run AMAS.py to check every alignments
  stage3_blank ""
  stage3_info "Running AMAS.py to check LS alignments ... "
  stage3_cmd "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i "${o}"/02-Alignments/LS/*.fasta -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_LS_raw.table"
  python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
  summary -f fasta -d dna -i "${o}"/02-Alignments/LS/phylopypruner_*.fasta \
  -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_LS_raw.table > /dev/null 2>&1
  if [ -s "${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_LS_raw.table" ]; then
    stage3_info "Successfully run AMAS.py to check every LS alignments."
    stage3_info "Wrote AMAS summaries to file ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_LS_raw.table"
  else
    stage3_error "Fail to run AMAS.py to check every LS alignments."
  fi
# (3) remove alignments with no parsimony informative sites
  stage3_blank ""
  stage3_info "Removing alignments with no parsimony informative sites..."
  if [ -d "${o}/03-Supermatrix/LS" ]; then
    rm -rf "${o}/03-Supermatrix/LS"
  fi
  mkdir -p "${o}/03-Supermatrix/LS"
  awk '$9==0 {print $1}' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_LS_raw.table > "${o}"/03-Supermatrix/LS/List-Removed_alignments_for_concatenation.txt
  awk '$9!=0 {print $1}' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_LS_raw.table > "${o}"/03-Supermatrix/LS/List-Filtered_alignments_for_concatenation.txt
  awk '$9!=0 {print $0}' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_LS_raw.table > "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_LS_final_filtered.table
  while IFS= read -r line || [ -n "$line" ]; do
    mv "${o}"/02-Alignments/LS/"${line}" "${o}"/02-Alignments/LS/"${line}.removed"
    stage3_info "Filter ${line}"
  done < "${o}/03-Supermatrix/LS/List-Removed_alignments_for_concatenation.txt"
  num_filtered_aln=$(wc -l < "${o}"/03-Supermatrix/LS/List-Removed_alignments_for_concatenation.txt)
  stage3_info "Successfully remove ${num_filtered_aln} LS alignments with no parsimony informative sites."
# (4) concatenate trimmed alignments
  stage3_blank "" 
  stage3_info "Concatenating LS alignments into supermatrix..."
  stage3_cmd "pxcat -s ${o}/02-Alignments/LS/phylopypruner_*.fasta -p ${o}/03-Supermatrix/LS/partition.txt -o ${o}/03-Supermatrix/LS/${prefix}_LS.fasta"
  pxcat \
  -s ${o}/02-Alignments/LS/phylopypruner_*.fasta \
  -p ${o}/03-Supermatrix/LS/partition.txt \
  -o ${o}/03-Supermatrix/LS/${prefix}_LS.fasta
  sed -i 's/AA, /DNA, /g' "${o}/03-Supermatrix/LS/partition.txt"
  if [ -s "${o}/03-Supermatrix/LS/${prefix}_LS.fasta" ]; then
    stage3_info "Successfully concatenate LS alignments to the supermatrix."
  else
    stage3_error "Fail to concatenate LS alignments into the supermatrix."
    stage3_info "HybSuite exits"
    stage3_blank ""
    exit 1
  fi
 # (5) run AMAS.py to check the supermatrix
  stage3_blank ""
  stage3_info "Running AMAS.py to check LS supermatrix ... "
  stage3_cmd "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${o}/03-Supermatrix/LS/${prefix}_LS.fasta -o ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_LS_supermatrix.table"
  python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
  summary -f fasta -d dna -i ${o}/03-Supermatrix/LS/${prefix}_LS.fasta \
  -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_LS_supermatrix.table > /dev/null 2>&1
  awk 'NR==2' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_LS_supermatrix.table >> "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_LS_raw.table
  awk 'NR==2' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_LS_supermatrix.table >> "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_LS_final_filtered.table
  if [ -s "${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_LS_supermatrix.table" ]; then
    stage3_info "Successfully run AMAS.py to check LS supermatrix."
    stage3_info "Results have been output to ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_LS_raw.table"
  else
    stage3_error "Fail to run AMAS.py to check LS supermatrix."
  fi
  rm "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_LS_supermatrix.table
fi
#(4) MI
if [ "${MI}" = "TRUE" ]; then
  stage3_blank "" 
  stage3_info "Trim MI alignments and concatenate them into the supermatrix..." 
  mkdir -p "${o}/02-Alignments/MI/"
# (1) TrimAl
  if [ "${run_trimal}" = "TRUE" ] && [ "${run_phylopypruner}" = "FALSE" ] && [ "${run_paragone}" = "TRUE" ]; then
    cd "${o}/02-Alignments/ParaGone-results/24_MI_final_alignments"
    total_sps=$(find . -maxdepth 1 -type f -name "*.fasta" | wc -l)
    j=0
    stage3_info "==> Trim MI alignments and concatenate them into the supermatrix... <=="
    find "${o}/02-Alignments/MI/" -type f -name "*" -exec rm -f {} \;
    for sample in *.fasta; do 
    j=$((j + 1))
    progress=$((j * 100 / total_sps))
    printf "\r[HybSuite-INFO]:    Running TrimAl for MI alignments: ${j}/${total_sps} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress"
    if [ "$replace_n" = "TRUE" ]; then
      sed -e '/^>/! s/n/-/g'  ${sample} > "Without_n_${sample}"
      if [ "${trimal_function}" = "automated1" ]; then
        trimal -in "Without_n_${sample}" -out "${o}/02-Alignments/MI/trimmed_${sample}" -automated1 > /dev/null 2>&1
        stage3_cmd "trimal -in Without_n_${sample} -out ${o}/02-Alignments/MI/trimmed_${sample} -automated1" > /dev/null
        stage3_info "Succeed in trimming the alignment of Without_n_${sample}." > /dev/null
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "Without_n_${sample}" -out "${o}/02-Alignments/MI/trimmed_${sample}" -gt ${trimal_gt} > /dev/null 2>&1
        stage3_cmd "trimal -in Without_n_${sample} -out ${o}/02-Alignments/MI/trimmed_${sample} -gt ${trimal_gt}" > /dev/null
        stage3_info "Succeed in trimming the alignment of Without_n_${sample}." > /dev/null
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "Without_n_${sample}" -out "${o}/02-Alignments/MI/trimmed_${sample}" -gappyout > /dev/null 2>&1
        stage3_cmd "trimal -in Without_n_${sample} -out ${o}/02-Alignments/MI/trimmed_${sample} -gappyout" > /dev/null
        stage3_info "Succeed in trimming the alignment of Without_n_${sample}." > /dev/null
      fi 
    else
      if [ "${trimal_function}" = "automated1" ]; then
        trimal -in "${sample}" -out "${o}/02-Alignments/MI/trimmed_${sample}" -automated1 > /dev/null 2>&1
        stage3_cmd "trimal -in ${sample} -out ${o}/02-Alignments/MI/trimmed_${sample} -automated1" > /dev/null
        stage3_info "Succeed in trimming the alignment of ${sample}." > /dev/null
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "${sample}" -out "${o}/02-Alignments/MI/trimmed_${sample}" -gt ${trimal_gt} > /dev/null 2>&1
        stage3_cmd "trimal -in ${sample} -out ${o}/02-Alignments/MI/trimmed_${sample} -gt ${trimal_gt}" > /dev/null
        stage3_info "Succeed in trimming the alignment of ${sample}." > /dev/null
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "${sample}" -out "${o}/02-Alignments/MI/trimmed_${sample}" -gappyout > /dev/null 2>&1
        stage3_cmd "trimal -in ${sample} -out ${o}/02-Alignments/MI/trimmed_${sample} -gappyout" > /dev/null
        stage3_info "Succeed in trimming the alignment of ${sample}." > /dev/null
      fi 
    fi   
    done
    echo
  fi
  if [ "${run_phylopypruner}" = "TRUE" ]; then
    cd "${o}/02-Alignments/phylopypruner/phylopypruner_output_MI/output_alignments"
    for file in *.fasta; do
      cp ${file} ${o}/02-Alignments/MI/${file}
      sed -i 's/@.*$//g' ${o}/02-Alignments/MI/${file}
    done
  fi
  
# (2) run AMAS.py to check every alignments
  if [ "${run_phylopypruner}" = "FALSE" ]; then
    stage3_blank ""
    stage3_info "Running AMAS.py to check MI alignments ... "
    stage3_cmd "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i "${o}"/02-Alignments/MI/*.fasta -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MI_raw.table"
    python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
    summary -f fasta -d dna -i "${o}"/02-Alignments/MI/trimmed_*.fasta \
    -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MI_raw.table > /dev/null 2>&1
    if [ -s "${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MI_raw.table" ]; then
      stage3_info "Successfully run AMAS.py to check every MI alignments."
      stage3_info "Wrote AMAS summaries to file ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MI_raw.table"
    else
      stage3_error "Fail to run AMAS.py to check every MI alignments."
    fi
  else
    stage3_blank ""
    stage3_info "Running AMAS.py to check MI alignments ... "
    stage3_cmd "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i "${o}"/02-Alignments/MI/*.fasta -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MI_raw.table"
    python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
    summary -f fasta -d dna -i "${o}"/02-Alignments/MI/phylopypruner_*.fasta \
    -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MI_raw.table > /dev/null 2>&1
    if [ -s "${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MI_raw.table" ]; then
      stage3_info "Successfully run AMAS.py to check every MI alignments."
      stage3_info "Wrote AMAS summaries to file ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MI_raw.table"
    else
      stage3_error "Fail to run AMAS.py to check every MI alignments."
    fi
  fi

# (3) remove alignments with no parsimony informative sites
  stage3_blank ""
  stage3_info "Removing alignments with no parsimony informative sites..."
  if [ -d "${o}/03-Supermatrix/MI" ]; then
    rm -rf "${o}/03-Supermatrix/MI"
  fi
  mkdir -p "${o}/03-Supermatrix/MI"
  awk '$9==0 {print $1}' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MI_raw.table > "${o}"/03-Supermatrix/MI/List-Removed_alignments_for_concatenation.txt
  awk '$9!=0 {print $1}' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MI_raw.table > "${o}"/03-Supermatrix/MI/List-Filtered_alignments_for_concatenation.txt
  awk '$9!=0 {print $0}' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MI_raw.table > "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MI_final_filtered.table
  while IFS= read -r line || [ -n "$line" ]; do
    mv "${o}"/02-Alignments/MI/"${line}" "${o}"/02-Alignments/MI/"${line}.removed"
    stage3_info "Filter ${line}"
  done < "${o}"/03-Supermatrix/MI/List-Removed_alignments_for_concatenation.txt
  num_filtered_aln=$(wc -l < "${o}"/03-Supermatrix/MI/List-Removed_alignments_for_concatenation.txt)
  stage3_info "Successfully remove ${num_filtered_aln} MI alignments with no parsimony informative sites."

# (4) concatenate trimmed alignments
  stage3_blank ""
  stage3_info "Concatenating MI alignments into supermatrix ... "
  if [ "${run_phylopypruner}" = "FALSE" ]; then
    stage3_cmd "pxcat -s ${o}/02-Alignments/MI/trimmed_*.fasta -p ${o}/03-Supermatrix/MI/partition.txt -o ${o}/03-Supermatrix/MI/${prefix}_MI.fasta"
    pxcat \
    -s ${o}/02-Alignments/MI/trimmed_*.fasta \
    -p ${o}/03-Supermatrix/MI/partition.txt \
    -o ${o}/03-Supermatrix/MI/${prefix}_MI.fasta
    sed -i 's/AA, /DNA, /g' "${o}/03-Supermatrix/MI/partition.txt"
    if [ -s "${o}/03-Supermatrix/MI/${prefix}_MI.fasta" ]; then
      stage3_info "Successfully concatenate MI alignments to the supermatrix."
    else
      stage3_error "Fail to concatenate MI alignments to the supermatrix."
      stage3_info "HybSuite exits"
      stage3_blank ""
      exit 1
    fi
  else
    stage3_cmd "pxcat -s ${o}/02-Alignments/MI/phylopypruner_*.fasta -p ${o}/03-Supermatrix/MI/partition.txt -o ${o}/03-Supermatrix/MI/${prefix}_MI.fasta"
    pxcat \
    -s ${o}/02-Alignments/MI/phylopypruner_*.fasta \
    -p ${o}/03-Supermatrix/MI/partition.txt \
    -o ${o}/03-Supermatrix/MI/${prefix}_MI.fasta
    sed -i 's/AA, /DNA, /g' "${o}/03-Supermatrix/MI/partition.txt"
    if [ -s "${o}/03-Supermatrix/MI/${prefix}_MI.fasta" ]; then
      stage3_info "Successfully concatenate MI alignments to the supermatrix."
    else
      stage3_error "Fail to concatenate MI alignments into the supermatrix."
      stage3_info "HybSuite exits"
      stage3_blank ""
      exit 1
    fi
  fi  
# (5) run AMAS.py to check the supermatrix
  stage3_blank ""
  stage3_info "Running AMAS.py to check MI supermatrix ... "
  stage3_cmd "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${o}/03-Supermatrix/MI/${prefix}_MI.fasta -o ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MI_supermatrix.table"
  python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
  summary -f fasta -d dna -i ${o}/03-Supermatrix/MI/${prefix}_MI.fasta \
  -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MI_supermatrix.table > /dev/null 2>&1
  awk 'NR==2' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MI_supermatrix.table >> "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MI_raw.table
  awk 'NR==2' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MI_supermatrix.table >> "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MI_final_filtered.table
  if [ -s "${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MI_supermatrix.table" ]; then
    stage3_info "Successfully run AMAS.py to check MI supermatrix."
    stage3_info "Results have been output to ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MI_raw.table"
  else
    stage3_error "Fail to run AMAS.py to check MI supermatrix."
  fi
  rm "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MI_supermatrix.table
fi
#(5) MO
if [ "${MO}" = "TRUE" ]; then
  stage3_blank "" 
  stage3_info "Trim MO alignments and concatenate them into the supermatrix..." 
  mkdir -p "${o}/02-Alignments/MO/"
# (1) TrimAl
  if [ "${run_trimal}" = "TRUE" ] && [ "${run_phylopypruner}" = "FALSE" ] && [ "${run_paragone}" = "TRUE" ]; then
    cd "${o}/02-Alignments/ParaGone-results/23_MO_final_alignments"
    total_sps=$(find . -maxdepth 1 -type f -name "*.fasta" | wc -l)
    j=0
    stage3_info "==> Trim MO alignments and concatenate them into the supermatrix... <=="
    find "${o}/02-Alignments/MO/" -type f -name "*" -exec rm -f {} \;
    for sample in *.fasta; do 
    j=$((j + 1))
    progress=$((j * 100 / total_sps))
    printf "\r[HybSuite-INFO]:    Running TrimAl for MO alignments: ${j}/${total_sps} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress"
    if [ "$replace_n" = "TRUE" ]; then
      sed -e '/^>/! s/n/-/g'  ${sample} > "Without_n_${sample}"
      if [ "${trimal_function}" = "automated1" ]; then
        trimal -in "Without_n_${sample}" -out "${o}/02-Alignments/MO/trimmed_${sample}" -automated1 > /dev/null 2>&1
        stage3_cmd "trimal -in Without_n_${sample} -out ${o}/02-Alignments/MO/trimmed_${sample} -automated1" > /dev/null
        stage3_info "Succeed in trimming the alignment of Without_n_${sample}." > /dev/null
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "Without_n_${sample}" -out "${o}/02-Alignments/MO/trimmed_${sample}" -gt ${trimal_gt} > /dev/null 2>&1
        stage3_cmd "trimal -in Without_n_${sample} -out ${o}/02-Alignments/MO/trimmed_${sample} -gt ${trimal_gt}" > /dev/null
        stage3_info "Succeed in trimming the alignment of Without_n_${sample}." > /dev/null
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "Without_n_${sample}" -out "${o}/02-Alignments/MO/trimmed_${sample}" -gappyout > /dev/null 2>&1
        stage3_cmd "trimal -in Without_n_${sample} -out ${o}/02-Alignments/MO/trimmed_${sample} -gappyout" > /dev/null
        stage3_info "Succeed in trimming the alignment of Without_n_${sample}." > /dev/null
      fi 
    else
      if [ "${trimal_function}" = "automated1" ]; then
        trimal -in "${sample}" -out "${o}/02-Alignments/MO/trimmed_${sample}" -automated1 > /dev/null 2>&1
        stage3_cmd "trimal -in ${sample} -out ${o}/02-Alignments/MO/trimmed_${sample} -automated1" > /dev/null
        stage3_info "Succeed in trimming the alignment of ${sample}." > /dev/null
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "${sample}" -out "${o}/02-Alignments/MO/trimmed_${sample}" -gt ${trimal_gt} > /dev/null 2>&1
        stage3_cmd "trimal -in ${sample} -out ${o}/02-Alignments/MO/trimmed_${sample} -gt ${trimal_gt}" > /dev/null
        stage3_info "Succeed in trimming the alignment of ${sample}." > /dev/null
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "${sample}" -out "${o}/02-Alignments/MO/trimmed_${sample}" -gappyout > /dev/null 2>&1
        stage3_cmd "trimal -in ${sample} -out ${o}/02-Alignments/MO/trimmed_${sample} -gappyout" > /dev/null
        stage3_info "Succeed in trimming the alignment of ${sample}." > /dev/null
      fi 
    fi   
    done
    echo
  fi
  if [ "${run_phylopypruner}" = "TRUE" ]; then
    cd "${o}/02-Alignments/phylopypruner/phylopypruner_output_MO/output_alignments"
    for file in *.fasta; do
      cp ${file} ${o}/02-Alignments/MO/${file}
      sed -i 's/@.*$//g' ${o}/02-Alignments/MO/${file}
    done
  fi
  
# (2) run AMAS.py to check every alignments
  if [ "${run_phylopypruner}" = "FALSE" ]; then
    stage3_blank ""
    stage3_info "Running AMAS.py to check MO alignments ... "
    stage3_cmd "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i "${o}"/02-Alignments/MO/*.fasta -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MO_raw.table"
    python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
    summary -f fasta -d dna -i "${o}"/02-Alignments/MO/trimmed_*.fasta \
    -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MO_raw.table > /dev/null 2>&1
    if [ -s "${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MO_raw.table" ]; then
      stage3_info "Successfully run AMAS.py to check every MO alignments."
      stage3_info "Wrote AMAS summaries to file ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MO_raw.table"
    else
      stage3_error "Fail to run AMAS.py to check every MO alignments."
    fi
  else
    stage3_blank ""
    stage3_info "Running AMAS.py to check MO alignments ... "
    stage3_cmd "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i "${o}"/02-Alignments/MO/*.fasta -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MO_raw.table"
    python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
    summary -f fasta -d dna -i "${o}"/02-Alignments/MO/phylopypruner_*.fasta \
    -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MO_raw.table > /dev/null 2>&1
    if [ -s "${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MO_raw.table" ]; then
      stage3_info "Successfully run AMAS.py to check every MO alignments."
      stage3_info "Wrote AMAS summaries to file ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MO_raw.table"
    else
      stage3_error "Fail to run AMAS.py to check every MO alignments."
    fi
  fi

# (3) remove alignments with no parsimony informative sites
  stage3_blank ""
  stage3_info "Removing alignments with no parsimony informative sites..."
  if [ -d "${o}/03-Supermatrix/MO" ]; then
    rm -rf "${o}/03-Supermatrix/MO"
  fi
  mkdir -p "${o}/03-Supermatrix/MO"
  awk '$9==0 {print $1}' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MO_raw.table > "${o}"/03-Supermatrix/MO/List-Removed_alignments_for_concatenation.txt
  awk '$9!=0 {print $1}' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MO_raw.table > "${o}"/03-Supermatrix/MO/List-Filtered_alignments_for_concatenation.txt
  awk '$9!=0 {print $0}' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MO_raw.table > "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MO_final_filtered.table
  while IFS= read -r line || [ -n "$line" ]; do
    mv "${o}"/02-Alignments/MO/"${line}" "${o}"/02-Alignments/MO/"${line}.removed"
    stage3_info "Filter ${line}"
  done < "${o}"/03-Supermatrix/MO/List-Removed_alignments_for_concatenation.txt
  num_filtered_aln=$(wc -l < "${o}"/03-Supermatrix/MO/List-Removed_alignments_for_concatenation.txt)
  stage3_info "Successfully remove ${num_filtered_aln} MO alignments with no parsimony informative sites."

# (4) concatenate trimmed alignments
  stage3_blank ""
  stage3_info "Concatenating MO alignments into supermatrix ... "
  if [ "${run_phylopypruner}" = "FALSE" ]; then
    stage3_cmd "pxcat -s ${o}/02-Alignments/MO/trimmed_*.fasta -p ${o}/03-Supermatrix/MO/partition.txt -o ${o}/03-Supermatrix/MO/${prefix}_MO.fasta"
    pxcat \
    -s ${o}/02-Alignments/MO/trimmed_*.fasta \
    -p ${o}/03-Supermatrix/MO/partition.txt \
    -o ${o}/03-Supermatrix/MO/${prefix}_MO.fasta
    sed -i 's/AA, /DNA, /g' "${o}/03-Supermatrix/MO/partition.txt"
    if [ -s "${o}/03-Supermatrix/MO/${prefix}_MO.fasta" ]; then
      stage3_info "Successfully concatenate MO alignments to the supermatrix."
    else
      stage3_error "Fail to concatenate MO alignments to the supermatrix."
      stage3_info "HybSuite exits"
      stage3_blank ""
      exit 1
    fi
  else
    stage3_cmd "pxcat -s ${o}/02-Alignments/MO/phylopypruner_*.fasta -p ${o}/03-Supermatrix/MO/partition.txt -o ${o}/03-Supermatrix/MO/${prefix}_MO.fasta"
    pxcat \
    -s ${o}/02-Alignments/MO/phylopypruner_*.fasta \
    -p ${o}/03-Supermatrix/MO/partition.txt \
    -o ${o}/03-Supermatrix/MO/${prefix}_MO.fasta
    sed -i 's/AA, /DNA, /g' "${o}/03-Supermatrix/MO/partition.txt"
    if [ -s "${o}/03-Supermatrix/MO/${prefix}_MO.fasta" ]; then
      stage3_info "Successfully concatenate MO alignments to the supermatrix."
    else
      stage3_error "Fail to concatenate MO alignments into the supermatrix."
      stage3_info "HybSuite exits"
      stage3_blank ""
      exit 1
    fi
  fi  
# (5) run AMAS.py to check the supermatrix
  stage3_blank ""
  stage3_info "Running AMAS.py to check MO supermatrix ... "
  stage3_cmd "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${o}/03-Supermatrix/MO/${prefix}_MO.fasta -o ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MO_supermatrix.table"
  python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
  summary -f fasta -d dna -i ${o}/03-Supermatrix/MO/${prefix}_MO.fasta \
  -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MO_supermatrix.table > /dev/null 2>&1
  awk 'NR==2' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MO_supermatrix.table >> "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MO_raw.table
  awk 'NR==2' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MO_supermatrix.table >> "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MO_final_filtered.table
  if [ -s "${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MO_supermatrix.table" ]; then
    stage3_info "Successfully run AMAS.py to check MO supermatrix."
    stage3_info "Results have been output to ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MO_raw.table"
  else
    stage3_error "Fail to run AMAS.py to check MO supermatrix."
  fi
  rm "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_MO_supermatrix.table
fi
#(6) RT
if [ "${RT}" = "TRUE" ]; then
  stage3_blank "" 
  stage3_info "Trim RT alignments and concatenate them into the supermatrix..." 
  mkdir -p "${o}/02-Alignments/RT/"
# (1) TrimAl
  if [ "${run_trimal}" = "TRUE" ] && [ "${run_phylopypruner}" = "FALSE" ]; then
    cd "${o}/02-Alignments/ParaGone-results/25_RT_final_alignments"
    total_sps=$(find . -maxdepth 1 -type f -name "*.fasta" | wc -l)
    j=0
    stage3_info "==> Trim RT alignments and concatenate them into the supermatrix... <=="
    find "${o}/02-Alignments/RT/" -type f -name "*" -exec rm -f {} \;
    for sample in *.fasta; do 
    j=$((j + 1))
    progress=$((j * 100 / total_sps))
    printf "\r[HybSuite-INFO]:    Running TrimAl for RT alignments: ${j}/${total_sps} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress"
    if [ "$replace_n" = "TRUE" ]; then
      sed -e '/^>/! s/n/-/g'  ${sample} > "Without_n_${sample}"
      if [ "${trimal_function}" = "automated1" ]; then
        trimal -in "Without_n_${sample}" -out "${o}/02-Alignments/RT/trimmed_${sample}" -automated1 > /dev/null 2>&1
        stage3_cmd "trimal -in Without_n_${sample} -out ${o}/02-Alignments/RT/trimmed_${sample} -automated1" > /dev/null
        stage3_info "Succeed in trimming the alignment of Without_n_${sample}." > /dev/null
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "Without_n_${sample}" -out "${o}/02-Alignments/RT/trimmed_${sample}" -gt ${trimal_gt} > /dev/null 2>&1
        stage3_cmd "trimal -in Without_n_${sample} -out ${o}/02-Alignments/RT/trimmed_${sample} -gt ${trimal_gt}" > /dev/null
        stage3_info "Succeed in trimming the alignment of Without_n_${sample}." > /dev/null
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "Without_n_${sample}" -out "${o}/02-Alignments/RT/trimmed_${sample}" -gappyout > /dev/null 2>&1
        stage3_cmd "trimal -in Without_n_${sample} -out ${o}/02-Alignments/RT/trimmed_${sample} -gappyout" > /dev/null
        stage3_info "Succeed in trimming the alignment of Without_n_${sample}." > /dev/null
      fi 
    else
      if [ "${trimal_function}" = "automated1" ]; then
        trimal -in "${sample}" -out "${o}/02-Alignments/RT/trimmed_${sample}" -automated1 > /dev/null 2>&1
        stage3_cmd "trimal -in ${sample} -out ${o}/02-Alignments/RT/trimmed_${sample} -automated1" > /dev/null
        stage3_info "Succeed in trimming the alignment of ${sample}." > /dev/null
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "${sample}" -out "${o}/02-Alignments/RT/trimmed_${sample}" -gt ${trimal_gt} > /dev/null 2>&1
        stage3_cmd "trimal -in ${sample} -out ${o}/02-Alignments/RT/trimmed_${sample} -gt ${trimal_gt}" > /dev/null
        stage3_info "Succeed in trimming the alignment of ${sample}." > /dev/null
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "${sample}" -out "${o}/02-Alignments/RT/trimmed_${sample}" -gappyout > /dev/null 2>&1
        stage3_cmd "trimal -in ${sample} -out ${o}/02-Alignments/RT/trimmed_${sample} -gappyout" > /dev/null
        stage3_info "Succeed in trimming the alignment of ${sample}." > /dev/null
      fi 
    fi   
    done
    echo
  fi
  if [ "${run_phylopypruner}" = "TRUE" ]; then
    cd "${o}/02-Alignments/phylopypruner/phylopypruner_output_RT/output_alignments"
    for file in *.fasta; do
      cp ${file} ${o}/02-Alignments/RT/${file}
      sed -i 's/@.*$//g' ${o}/02-Alignments/RT/${file}
    done
  fi
  
# (2) run AMAS.py to check every alignments
  if [ "${run_phylopypruner}" = "FALSE" ]; then
    stage3_blank ""
    stage3_info "Running AMAS.py to check RT alignments ... "
    stage3_cmd "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i "${o}"/02-Alignments/RT/*.fasta -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RT_raw.table"
    python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
    summary -f fasta -d dna -i "${o}"/02-Alignments/RT/trimmed_*.fasta \
    -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RT_raw.table > /dev/null 2>&1
    if [ -s "${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RT_raw.table" ]; then
      stage3_info "Successfully run AMAS.py to check every RT alignments."
      stage3_info "Wrote AMAS summaries to file ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RT_raw.table"
    else
      stage3_error "Fail to run AMAS.py to check every RT alignments."
    fi
  else
    stage3_blank ""
    stage3_info "Running AMAS.py to check RT alignments ... "
    stage3_cmd "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i "${o}"/02-Alignments/RT/*.fasta -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RT_raw.table"
    python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
    summary -f fasta -d dna -i "${o}"/02-Alignments/RT/phylopypruner_*.fasta \
    -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RT_raw.table > /dev/null 2>&1
    if [ -s "${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RT_raw.table" ]; then
      stage3_info "Successfully run AMAS.py to check every RT alignments."
      stage3_info "Wrote AMAS summaries to file ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RT_raw.table"
    else
      stage3_error "Fail to run AMAS.py to check every RT alignments."
    fi
  fi

# (3) remove alignments with no parsimony informative sites
  stage3_blank ""
  stage3_info "Removing alignments with no parsimony informative sites..."
  if [ -d "${o}/03-Supermatrix/RT" ]; then
    rm -rf "${o}/03-Supermatrix/RT"
  fi
  mkdir -p "${o}/03-Supermatrix/RT"
  awk '$9==0 {print $1}' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RT_raw.table > "${o}"/03-Supermatrix/RT/List-Removed_alignments_for_concatenation.txt
  awk '$9!=0 {print $1}' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RT_raw.table > "${o}"/03-Supermatrix/RT/List-Filtered_alignments_for_concatenation.txt
  awk '$9!=0 {print $0}' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RT_raw.table > "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RT_final_filtered.table
  while IFS= read -r line || [ -n "$line" ]; do
    mv "${o}"/02-Alignments/RT/"${line}" "${o}"/02-Alignments/RT/"${line}.removed"
    stage3_info "Filter ${line}"
  done < "${o}"/03-Supermatrix/RT/List-Removed_alignments_for_concatenation.txt
  num_filtered_aln=$(wc -l < "${o}"/03-Supermatrix/RT/List-Removed_alignments_for_concatenation.txt)
  stage3_info "Successfully remove ${num_filtered_aln} RT alignments with no parsimony informative sites."

# (4) concatenate trimmed alignments
  stage3_blank ""
  stage3_info "Concatenating RT alignments into supermatrix ... "
  if [ "${run_phylopypruner}" = "FALSE" ]; then
    stage3_cmd "pxcat -s ${o}/02-Alignments/RT/trimmed_*.fasta -p ${o}/03-Supermatrix/RT/partition.txt -o ${o}/03-Supermatrix/RT/${prefix}_RT.fasta"
    pxcat \
    -s ${o}/02-Alignments/RT/trimmed_*.fasta \
    -p ${o}/03-Supermatrix/RT/partition.txt \
    -o ${o}/03-Supermatrix/RT/${prefix}_RT.fasta
    sed -i 's/AA, /DNA, /g' "${o}/03-Supermatrix/RT/partition.txt"
    if [ -s "${o}/03-Supermatrix/RT/${prefix}_RT.fasta" ]; then
      stage3_info "Successfully concatenate RT alignments to the supermatrix."
    else
      stage3_error "Fail to concatenate RT alignments to the supermatrix."
      stage3_info "HybSuite exits"
      stage3_blank ""
      exit 1
    fi
  else
    stage3_cmd "pxcat -s ${o}/02-Alignments/RT/phylopypruner_*.fasta -p ${o}/03-Supermatrix/RT/partition.txt -o ${o}/03-Supermatrix/RT/${prefix}_RT.fasta"
    pxcat \
    -s ${o}/02-Alignments/RT/phylopypruner_*.fasta \
    -p ${o}/03-Supermatrix/RT/partition.txt \
    -o ${o}/03-Supermatrix/RT/${prefix}_RT.fasta
    sed -i 's/AA, /DNA, /g' "${o}/03-Supermatrix/RT/partition.txt"
    if [ -s "${o}/03-Supermatrix/RT/${prefix}_RT.fasta" ]; then
      stage3_info "Successfully concatenate RT alignments to the supermatrix."
    else
      stage3_error "Fail to concatenate RT alignments into the supermatrix."
      stage3_info "HybSuite exits"
      stage3_blank ""
      exit 1
    fi
  fi  
# (5) run AMAS.py to check the supermatrix
  stage3_blank ""
  stage3_info "Running AMAS.py to check RT supermatrix ... "
  stage3_cmd "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${o}/03-Supermatrix/RT/${prefix}_RT.fasta -o ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RT_supermatrix.table"
  python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
  summary -f fasta -d dna -i ${o}/03-Supermatrix/RT/${prefix}_RT.fasta \
  -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RT_supermatrix.table > /dev/null 2>&1
  awk 'NR==2' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RT_supermatrix.table >> "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RT_raw.table
  awk 'NR==2' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RT_supermatrix.table >> "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RT_final_filtered.table
  if [ -s "${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RT_supermatrix.table" ]; then
    stage3_info "Successfully run AMAS.py to check RT supermatrix."
    stage3_info "Results have been output to ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RT_raw.table"
  else
    stage3_error "Fail to run AMAS.py to check RT supermatrix."
  fi
  rm "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_RT_supermatrix.table
fi
#(7) 1to1
if [ "${one_to_one}" = "TRUE" ]; then
  stage3_blank "" 
  stage3_info "Trim 1to1 alignments and concatenate them into the supermatrix..." 
  mkdir -p "${o}/02-Alignments/1to1/"
# (1) TrimAl
  if [ "${run_trimal}" = "TRUE" ] && [ "${run_phylopypruner}" = "FALSE" ]; then
    cd "${o}/02-Alignments/ParaGone-results/HybSuite_1to1_final_alignments"
    total_sps=$(find . -maxdepth 1 -type f -name "*.fasta" | wc -l)
    j=0
    stage3_info "==> Trim 1to1 alignments and concatenate them into the supermatrix... <=="
    find "${o}/02-Alignments/1to1/" -type f -name "*" -exec rm -f {} \;
    for sample in *.fasta; do 
    j=$((j + 1))
    progress=$((j * 100 / total_sps))
    printf "\r[HybSuite-INFO]:    Running TrimAl for 1to1 alignments: ${j}/${total_sps} [%-50s] %d%%" "$(printf "#%.0s" $(seq 1 $((progress / 2))))" "$progress"
    if [ "$replace_n" = "TRUE" ]; then
      sed -e '/^>/! s/n/-/g'  ${sample} > "Without_n_${sample}"
      if [ "${trimal_function}" = "automated1" ]; then
        trimal -in "Without_n_${sample}" -out "${o}/02-Alignments/1to1/trimmed_${sample}" -automated1 > /dev/null 2>&1
        stage3_cmd "trimal -in Without_n_${sample} -out ${o}/02-Alignments/1to1/trimmed_${sample} -automated1" > /dev/null
        stage3_info "Succeed in trimming the alignment of Without_n_${sample}." > /dev/null
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "Without_n_${sample}" -out "${o}/02-Alignments/1to1/trimmed_${sample}" -gt ${trimal_gt} > /dev/null 2>&1
        stage3_cmd "trimal -in Without_n_${sample} -out ${o}/02-Alignments/1to1/trimmed_${sample} -gt ${trimal_gt}" > /dev/null
        stage3_info "Succeed in trimming the alignment of Without_n_${sample}." > /dev/null
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "Without_n_${sample}" -out "${o}/02-Alignments/1to1/trimmed_${sample}" -gappyout > /dev/null 2>&1
        stage3_cmd "trimal -in Without_n_${sample} -out ${o}/02-Alignments/1to1/trimmed_${sample} -gappyout" > /dev/null
        stage3_info "Succeed in trimming the alignment of Without_n_${sample}." > /dev/null
      fi 
    else
      if [ "${trimal_function}" = "automated1" ]; then
        trimal -in "${sample}" -out "${o}/02-Alignments/1to1/trimmed_${sample}" -automated1 > /dev/null 2>&1
        stage3_cmd "trimal -in ${sample} -out ${o}/02-Alignments/1to1/trimmed_${sample} -automated1" > /dev/null
        stage3_info "Succeed in trimming the alignment of ${sample}." > /dev/null
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "${sample}" -out "${o}/02-Alignments/1to1/trimmed_${sample}" -gt ${trimal_gt} > /dev/null 2>&1
        stage3_cmd "trimal -in ${sample} -out ${o}/02-Alignments/1to1/trimmed_${sample} -gt ${trimal_gt}" > /dev/null
        stage3_info "Succeed in trimming the alignment of ${sample}." > /dev/null
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "${sample}" -out "${o}/02-Alignments/1to1/trimmed_${sample}" -gappyout > /dev/null 2>&1
        stage3_cmd "trimal -in ${sample} -out ${o}/02-Alignments/1to1/trimmed_${sample} -gappyout" > /dev/null
        stage3_info "Succeed in trimming the alignment of ${sample}." > /dev/null
      fi 
    fi   
    done
    echo
  fi
  if [ "${run_phylopypruner}" = "TRUE" ]; then
    cd "${o}/02-Alignments/phylopypruner/phylopypruner_output_1to1/output_alignments"
    for file in *.fasta; do
      cp ${file} ${o}/02-Alignments/1to1/${file}
      sed -i 's/@.*$//g' ${o}/02-Alignments/1to1/${file}
    done
  fi
  
# (2) run AMAS.py to check every alignments
  if [ "${run_phylopypruner}" = "FALSE" ]; then
    stage3_blank ""
    stage3_info "Running AMAS.py to check 1to1 alignments ... "
    stage3_cmd "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i "${o}"/02-Alignments/1to1/*.fasta -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_1to1_raw.table"
    python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
    summary -f fasta -d dna -i "${o}"/02-Alignments/1to1/trimmed_*.fasta \
    -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_1to1_raw.table > /dev/null 2>&1
    if [ -s "${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_1to1_raw.table" ]; then
      stage3_info "Successfully run AMAS.py to check every 1to1 alignments."
      stage3_info "Wrote AMAS summaries to file ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_1to1_raw.table"
    else
      stage3_error "Fail to run AMAS.py to check every 1to1 alignments."
    fi
  else
    stage3_blank ""
    stage3_info "Running AMAS.py to check 1to1 alignments ... "
    stage3_cmd "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i "${o}"/02-Alignments/1to1/*.fasta -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_1to1_raw.table"
    python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
    summary -f fasta -d dna -i "${o}"/02-Alignments/1to1/phylopypruner_*.fasta \
    -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_1to1_raw.table > /dev/null 2>&1
    if [ -s "${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_1to1_raw.table" ]; then
      stage3_info "Successfully run AMAS.py to check every 1to1 alignments."
      stage3_info "Wrote AMAS summaries to file ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_1to1_raw.table"
    else
      stage3_error "Fail to run AMAS.py to check every 1to1 alignments."
    fi
  fi

# (3) remove alignments with no parsimony informative sites
  stage3_blank ""
  stage3_info "Removing alignments with no parsimony informative sites..."
  if [ -d "${o}/03-Supermatrix/1to1" ]; then
    rm -rf "${o}/03-Supermatrix/1to1"
  fi
  mkdir -p "${o}/03-Supermatrix/1to1"
  awk '$9==0 {print $1}' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_1to1_raw.table > "${o}"/03-Supermatrix/1to1/List-Removed_alignments_for_concatenation.txt
  awk '$9!=0 {print $1}' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_1to1_raw.table > "${o}"/03-Supermatrix/1to1/List-Filtered_alignments_for_concatenation.txt
  awk '$9!=0 {print $0}' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_1to1_raw.table > "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_1to1_final_filtered.table
  while IFS= read -r line || [ -n "$line" ]; do
    mv "${o}"/02-Alignments/1to1/"${line}" "${o}"/02-Alignments/1to1/"${line}.removed"
    stage3_info "Filter ${line}"
  done < "${o}"/03-Supermatrix/1to1/List-Removed_alignments_for_concatenation.txt
  num_filtered_aln=$(wc -l < "${o}"/03-Supermatrix/1to1/List-Removed_alignments_for_concatenation.txt)
  stage3_info "Successfully remove ${num_filtered_aln} 1to1 alignments with no parsimony informative sites."

# (4) concatenate trimmed alignments
  stage3_blank ""
  stage3_info "Concatenating 1to1 alignments into supermatrix ... "
  if [ "${run_phylopypruner}" = "FALSE" ]; then
    stage3_cmd "pxcat -s ${o}/02-Alignments/1to1/trimmed_*.fasta -p ${o}/03-Supermatrix/1to1/partition.txt -o ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta"
    pxcat \
    -s ${o}/02-Alignments/1to1/trimmed_*.fasta \
    -p ${o}/03-Supermatrix/1to1/partition.txt \
    -o ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta
    sed -i 's/AA, /DNA, /g' "${o}/03-Supermatrix/1to1/partition.txt"
    if [ -s "${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta" ]; then
      stage3_info "Successfully concatenate 1to1 alignments to the supermatrix."
    else
      stage3_error "Fail to concatenate 1to1 alignments to the supermatrix."
      stage3_info "HybSuite exits"
      stage3_blank ""
      exit 1
    fi
  else
    stage3_cmd "pxcat -s ${o}/02-Alignments/1to1/phylopypruner_*.fasta -p ${o}/03-Supermatrix/1to1/partition.txt -o ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta"
    pxcat \
    -s ${o}/02-Alignments/1to1/phylopypruner_*.fasta \
    -p ${o}/03-Supermatrix/1to1/partition.txt \
    -o ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta
    sed -i 's/AA, /DNA, /g' "${o}/03-Supermatrix/1to1/partition.txt"
    if [ -s "${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta" ]; then
      stage3_info "Successfully concatenate 1to1 alignments to the supermatrix."
    else
      stage3_error "Fail to concatenate 1to1 alignments into the supermatrix."
      stage3_info "HybSuite exits"
      stage3_blank ""
      exit 1
    fi
  fi  
# (5) run AMAS.py to check the supermatrix
  stage3_blank ""
  stage3_info "Running AMAS.py to check 1to1 supermatrix ... "
  stage3_cmd "python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta -o ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_1to1_supermatrix.table"
  python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
  summary -f fasta -d dna -i ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta \
  -o "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_1to1_supermatrix.table > /dev/null 2>&1
  awk 'NR==2' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_1to1_supermatrix.table >> "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_1to1_raw.table
  awk 'NR==2' "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_1to1_supermatrix.table >> "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_1to1_final_filtered.table
  if [ -s "${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_1to1_supermatrix.table" ]; then
    stage3_info "Successfully run AMAS.py to check 1to1 supermatrix."
    stage3_info "Results have been output to ${o}/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_1to1_raw.table"
  else
    stage3_error "Fail to run AMAS.py to check 1to1 supermatrix."
  fi
  rm "${o}"/00-logs_and_reports/HybSuite_reports/AMAS_reports/AMAS_reports_1to1_supermatrix.table
fi

#6. Conclusion
stage3_info "Successfully finish the stage3: 'Orthologs inference'."
stage3_blank "                    The resulting files have been saved in ${o}/02-Alignments and ${o}/03-Supermatrix."
stage3_info "Moving on to the next stage..."
stage3_blank ""

if [ "${run_to_alignments}" = "true" ]; then
  stage3_info "Congratulations! You have finished stage1, stage2, and stage3."
  stage3_blank ""
  stage3_blank "                    HybSuite exits."
  stage3_blank ""
  exit 1
fi

#===> Stage 4 Phylogenetic trees inference <===#
#Preparation
stage4_info() {
  echo "[HybSuite-INFO]:    $1" | tee -a "${o}/00-logs_and_reports/logs/Stage4_Phylogenetic_trees_inference_${current_time}.log"
}
stage4_error() {
  echo "[HybSuite-ERROR]:   $1" | tee -a "${o}/00-logs_and_reports/logs/Stage4_Phylogenetic_trees_inference_${current_time}.log"
}
stage4_cmd() {
  echo "[HybSuite-CMD]:     $1" | tee -a "${o}/00-logs_and_reports/logs/Stage4_Phylogenetic_trees_inference_${current_time}.log"
}
stage4_blank() {
  echo "$1" | tee -a "${o}/00-logs_and_reports/logs/Stage4_Phylogenetic_trees_inference_${current_time}.log"
}

if [ -s "${o}/00-logs_and_reports/logs/Stage4_Phylogenetic_trees_inference_${current_time}.log" ]; then
  rm "${o}/00-logs_and_reports/logs/Stage4_Phylogenetic_trees_inference_${current_time}.log"
fi
stage4_blank ""
stage4_info "<<<======= Stage4 Phylogenetic trees inference =======>>>"
#1. ModelTest-NG (Optional)
#Preparation
if [ "${run_modeltest_ng}" = "TRUE" ]; then
  stage4_info "<<==== ModelTest-NG ====>>"
fi
#(1) HRS
if [ "${run_modeltest_ng}" = "TRUE" ]; then
  if [ "${HRS}" = "TRUE" ]; then
    ###00-Set the directory
    cd ${o}/03-Supermatrix/HRS
    if [ ! -s "${o}/04-ModelTest-NG/HRS/${prefix}_modeltest.txt.ckp" ]; then
      rm "${o}/04-ModelTest-NG/HRS/${prefix}_modeltest.txt.*"
    fi
    ###01-Use modeltest-ng
    modeltest-ng -d nt \
    --force \
    -p ${nt_modeltest_ng} \
    -i ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta \
    -o ${o}/04-ModelTest-NG/HRS/${prefix}_modeltest.txt \
    -T raxml > /dev/null 2>&1
    stage4_info "Running ModelTest-NG for the HRS supermatrix ... "
    stage4_cmd "modeltest-ng -d nt --force -p ${nt_modeltest_ng} -i ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta -o ${o}/04-ModelTest-NG/HRS/${prefix}_modeltest.txt -T raxml"
    stage4_blank ""
    ###02-According to the result, assign different variables to the suggested commands for each tree building software
    HRS_iqtree=$(grep -n 'iqtree' ${o}/04-ModelTest-NG/HRS/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*iqtree/iqtree/g')
    HRS_raxml_ng_mtest=$(grep -n 'raxml-ng' ${o}/04-ModelTest-NG/HRS/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxml-ng/raxml-ng/g')
    HRS_raxmlHPC_mtest=$(grep -n 'raxmlHPC' ${o}/04-ModelTest-NG/HRS/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxmlHPC/raxmlHPC-PTHREADS/g; s/ -n .*$//')
  fi
fi
#(2) RAPP
if [ "${run_modeltest_ng}" = "TRUE" ]; then
  if [ "${RAPP}" = "TRUE" ]; then
    ###00-Set the directory
    cd ${o}/03-Supermatrix/RAPP
    if [ ! -s "${o}/04-ModelTest-NG/RAPP/${prefix}_modeltest.txt.ckp" ]; then
      rm "${o}/04-ModelTest-NG/RAPP/${prefix}_modeltest.txt.*"
    fi
    ###01-Use modeltest-ng
    modeltest-ng -d nt \
    --force \
    -p ${nt_modeltest_ng} \
    -i ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta \
    -o ${o}/04-ModelTest-NG/RAPP/${prefix}_modeltest.txt \
    -T raxml > /dev/null 2>&1
    stage4_info "Running ModelTest-NG for the RAPP supermatrix ... "
    stage4_cmd "modeltest-ng -d nt --force -p ${nt_modeltest_ng} -i ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta -o ${o}/04-ModelTest-NG/RAPP/${prefix}_modeltest.txt -T raxml"
    stage4_blank ""
    ###02-According to the result, assign different variables to the suggested commands for each tree building software
    RAPP_iqtree=$(grep -n 'iqtree' ${o}/04-ModelTest-NG/RAPP/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*iqtree/iqtree/g')
    RAPP_raxml_ng_mtest=$(grep -n 'raxml-ng' ${o}/04-ModelTest-NG/RAPP/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxml-ng/raxml-ng/g')
    RAPP_raxmlHPC_mtest=$(grep -n 'raxmlHPC' ${o}/04-ModelTest-NG/RAPP/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxmlHPC/raxmlHPC-PTHREADS/g; s/ -n .*//')
  fi
fi
#(3) LS
if [ "${run_modeltest_ng}" = "TRUE" ]; then
  if [ "${LS}" = "TRUE" ]; then
    ###00-Set the directory
    cd ${o}/03-Supermatrix/LS
    if [ ! -s "${o}/04-ModelTest-NG/LS/${prefix}_modeltest.txt.ckp" ]; then
      rm "${o}/04-ModelTest-NG/LS/${prefix}_modeltest.txt.*"
    fi
    ###01-Use modeltest-ng
    modeltest-ng -d nt \
    --force \
    -p ${nt_modeltest_ng} \
    -i ${o}/03-Supermatrix/LS/${prefix}_LS.fasta \
    -o ${o}/04-ModelTest-NG/LS/${prefix}_modeltest.txt \
    -T raxml > /dev/null 2>&1
    stage4_info "Running ModelTest-NG for the LS supermatrix ... "
    stage4_cmd "modeltest-ng -d nt --force -p ${nt_modeltest_ng} -i ${o}/03-Supermatrix/LS/${prefix}_LS.fasta -o ${o}/04-ModelTest-NG/LS/${prefix}_modeltest.txt -T raxml"
    stage4_blank ""
    ###02-According to the result, assign different variables to the suggested commands for each tree building software
    LS_iqtree=$(grep -n 'iqtree' ${o}/04-ModelTest-NG/LS/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*iqtree/iqtree/g')
    LS_raxml_ng_mtest=$(grep -n 'raxml-ng' ${o}/04-ModelTest-NG/LS/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxml-ng/raxml-ng/g')
    LS_raxmlHPC_mtest=$(grep -n 'raxmlHPC' ${o}/04-ModelTest-NG/LS/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxmlHPC/raxmlHPC-PTHREADS/g; s/ -n .*//')
  fi
fi
#(4) MO
if [ "${run_modeltest_ng}" = "TRUE" ]; then
  if [ "${MO}" = "TRUE" ]; then
    ###00-Set the directory
    cd ${o}/03-Supermatrix/MO
    if [ ! -s "${o}/04-ModelTest-NG/MO/${prefix}_modeltest.txt.ckp" ]; then
      rm "${o}/04-ModelTest-NG/MO/${prefix}_modeltest.txt.*"
    fi
    ###01-Use modeltest-ng
    modeltest-ng -d nt \
    --force \
    -p ${nt_modeltest_ng} \
    -i ${o}/03-Supermatrix/MO/${prefix}_MO.fasta \
    -o ${o}/04-ModelTest-NG/MO/${prefix}_modeltest.txt \
    -T raxml > /dev/null 2>&1
    stage4_info "Running ModelTest-NG for the MO supermatrix ... "
    stage4_cmd "modeltest-ng -d nt --force -p ${nt_modeltest_ng} -i ${o}/03-Supermatrix/MO/${prefix}_MO.fasta -o ${o}/04-ModelTest-NG/MO/${prefix}_modeltest.txt -T raxml"
    stage4_blank ""
    ###02-According to the result, assign different variables to the suggested commands for each tree building software
    MO_iqtree=$(grep -n 'iqtree' ${o}/04-ModelTest-NG/MO/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*iqtree/iqtree/g')
    MO_raxml_ng_mtest=$(grep -n 'raxml-ng' ${o}/04-ModelTest-NG/MO/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxml-ng/raxml-ng/g')
    MO_raxmlHPC_mtest=$(grep -n 'raxmlHPC' ${o}/04-ModelTest-NG/MO/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxmlHPC/raxmlHPC-PTHREADS/g; s/ -n .*//')
  fi
fi
#(5) MI
if [ "${run_modeltest_ng}" = "TRUE" ]; then
  if [ "${MI}" = "TRUE" ]; then
    ###00-Set the directory
    cd ${o}/03-Supermatrix/MI
    if [ ! -s "${o}/04-ModelTest-NG/MI/${prefix}_modeltest.txt.ckp" ]; then
      rm "${o}/04-ModelTest-NG/MI/${prefix}_modeltest.txt.*"
    fi
    ###01-Use modeltest-ng
    modeltest-ng -d nt \
    --force \
    -p ${nt_modeltest_ng} \
    -i ${o}/03-Supermatrix/MI/${prefix}_MI.fasta \
    -o ${o}/04-ModelTest-NG/MI/${prefix}_modeltest.txt \
    -T raxml > /dev/null 2>&1
    stage4_info "Running ModelTest-NG for the MI supermatrix ... "
    stage4_cmd "modeltest-ng -d nt --force -p ${nt_modeltest_ng} -i ${o}/03-Supermatrix/MI/${prefix}_MI.fasta -o ${o}/04-ModelTest-NG/MI/${prefix}_modeltest.txt -T raxml"
    stage4_blank ""
    ###02-According to the result, assign different variables to the suggested commands for each tree building software
    MI_iqtree=$(grep -n 'iqtree' ${o}/04-ModelTest-NG/MI/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*iqtree/iqtree/g')
    MI_raxml_ng_mtest=$(grep -n 'raxml-ng' ${o}/04-ModelTest-NG/MI/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxml-ng/raxml-ng/g')
    MI_raxmlHPC_mtest=$(grep -n 'raxmlHPC' ${o}/04-ModelTest-NG/MI/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxmlHPC/raxmlHPC-PTHREADS/g; s/ -n .*//')
  fi
fi
#(6) RT
if [ "${run_modeltest_ng}" = "TRUE" ]; then
  if [ "${RT}" = "TRUE" ]; then
    ###00-Set the directory
    cd ${o}/03-Supermatrix/RT
    if [ ! -s "${o}/04-ModelTest-NG/RT/${prefix}_modeltest.txt.ckp" ]; then
      rm "${o}/04-ModelTest-NG/RT/${prefix}_modeltest.txt.*"
    fi
    ###01-Use modeltest-ng
    modeltest-ng -d nt \
    --force \
    -p ${nt_modeltest_ng} \
    -i ${o}/03-Supermatrix/RT/${prefix}_RT.fasta \
    -o ${o}/04-ModelTest-NG/RT/${prefix}_modeltest.txt \
    -T raxml > /dev/null 2>&1
    stage4_info "Running ModelTest-NG for the RT supermatrix ... "
    stage4_cmd "modeltest-ng -d nt --force -p ${nt_modeltest_ng} -i ${o}/03-Supermatrix/RT/${prefix}_RT.fasta -o ${o}/04-ModelTest-NG/RT/${prefix}_modeltest.txt -T raxml"
    stage4_blank ""
    ###02-According to the result, assign different variables to the suggested commands for each tree building software
    RT_iqtree=$(grep -n 'iqtree' ${o}/04-ModelTest-NG/RT/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*iqtree/iqtree/g')
    RT_raxml_ng_mtest=$(grep -n 'raxml-ng' ${o}/04-ModelTest-NG/RT/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxml-ng/raxml-ng/g')
    RT_raxmlHPC_mtest=$(grep -n 'raxmlHPC' ${o}/04-ModelTest-NG/RT/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxmlHPC/raxmlHPC-PTHREADS/g; s/ -n .*//')
  fi
fi
#(7) 1to1
if [ "${run_modeltest_ng}" = "TRUE" ]; then
  if [ "${one_to_one}" = "TRUE" ]; then
    ###00-Set the directory
    cd ${o}/03-Supermatrix/1to1
    if [ ! -s "${o}/04-ModelTest-NG/1to1/${prefix}_modeltest.txt.ckp" ]; then
      rm "${o}/04-ModelTest-NG/1to1/${prefix}_modeltest.txt.*"
    fi
    ###01-Use modeltest-ng
    modeltest-ng -d nt \
    --force \
    -p ${nt_modeltest_ng} \
    -i ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta \
    -o ${o}/04-ModelTest-NG/1to1/${prefix}_modeltest.txt \
    -T raxml > /dev/null 2>&1
    stage4_info "Running ModelTest-NG for the 1to1 supermatrix..."
    stage4_cmd "modeltest-ng -d nt --force -p ${nt_modeltest_ng} -i ${o}/03-Supermatrix/RT/${prefix}_RT.fasta -o ${o}/04-ModelTest-NG/RT/${prefix}_modeltest.txt -T raxml"
    stage4_blank ""
    ###02-According to the result, assign different variables to the suggested commands for each tree building software
    one_to_one_iqtree=$(grep -n 'iqtree' ${o}/04-ModelTest-NG/1to1/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*iqtree/iqtree/g')
    one_to_one_raxml_ng_mtest=$(grep -n 'raxml-ng' ${o}/04-ModelTest-NG/1to1/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxml-ng/raxml-ng/g')
    one_to_one_raxmlHPC_mtest=$(grep -n 'raxmlHPC' ${o}/04-ModelTest-NG/1to1/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxmlHPC/raxmlHPC-PTHREADS/g; s/ -n .*//')
  fi
fi
#2. Construct concatenation-based trees (IQTREE, RAxML, or RAxML-NG)
#Preparation
if [ "${run_iqtree}" = "TRUE" ] || [ "${run_raxml}" = "TRUE" ] || [ "${run_raxml_ng}" = "TRUE" ]; then
  stage4_info "<<==== Constructing Concatenation-based trees (IQTREE, RAxML, or RAxML-NG) ====>>"
fi
#01-HRS #############################
if [ "${HRS}" = "TRUE" ]; then
  stage4_info "<=== HRS alignments ===>"
fi
#(1) IQ-TREE
if [ "${run_iqtree}" = "TRUE" ]; then
  if [ "${HRS}" = "TRUE" ]; then 
  ##01-1 Set the directory
    mkdir -p ${o}/05-Concatenated_trees/HRS/IQTREE
    cd ${o}/05-Concatenated_trees/HRS/IQTREE
    stage4_info "Running IQTREE for HRS alignments..." 
  ##01-2 run IQTREE
    if [ "$(ls -A "${o}/05-Concatenated_trees/HRS/IQTREE/")" ]; then
      rm ${o}/05-Concatenated_trees/HRS/IQTREE/IQTREE*
    fi
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${HRS_iqtree} -B ${iqtree_bb} --undo \
          --seed 12345 -T ${nt_iqtree} -pre IQTREE_${prefix}_HRS \
          -p ${o}/03-Supermatrix/HRS/partition.txt
          stage4_cmd "${HRS_iqtree} -B ${iqtree_bb} --undo --seed 12345 -T ${nt_iqtree} -pre IQTREE_${prefix}_HRS -p ${o}/03-Supermatrix/HRS/partition.txt" 
        else
          ${HRS_iqtree} -B ${iqtree_bb} --undo \
          --seed 12345 -T ${nt_iqtree} -pre IQTREE_${prefix}_HRS -g "${iqtree_constraint_tree}" \
          -p ${o}/03-Supermatrix/HRS/partition.txt
          stage4_cmd "${HRS_iqtree} -B ${iqtree_bb} --undo --seed 12345 -T ${nt_iqtree} -pre IQTREE_${prefix}_HRS -g ${iqtree_constraint_tree} -p ${o}/03-Supermatrix/HRS/partition.txt" 
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${HRS_iqtree} -B ${iqtree_bb} --undo \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_HRS
          stage4_cmd "${HRS_iqtree} -B ${iqtree_bb} --undo --seed 12345 -T ${nt_iqtree} -pre IQTREE_${prefix}_HRS" 
        else
          ${HRS_iqtree} -B ${iqtree_bb} --undo \
          --seed 12345 -T ${nt_iqtree} -pre IQTREE_${prefix}_HRS -g "${iqtree_constraint_tree}"
          stage4_cmd "${HRS_iqtree} -B ${iqtree_bb} --undo --seed 12345 -T ${nt_iqtree} -pre IQTREE_${prefix}_HRS -g ${iqtree_constraint_tree}" 
        fi
      fi
    else
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta --undo \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/HRS/partition.txt -m MFP \
          -pre IQTREE_${prefix}_HRS
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta --undo --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/HRS/partition.txt -m MFP -pre IQTREE_${prefix}_HRS" 
        else
          iqtree -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta --undo \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/HRS/partition.txt -m MFP \
          -pre IQTREE_${prefix}_HRS -g "${iqtree_constraint_tree}"
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta --undo --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/HRS/partition.txt -m MFP -pre IQTREE_${prefix}_HRS -g ${iqtree_constraint_tree}" 
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta --undo \
          --seed 12345 -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_HRS
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta --undo --seed 12345 -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_HRS" 
        else
          iqtree -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta --undo \
          --seed 12345 -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_HRS -g "${iqtree_constraint_tree}"
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta --undo --seed 12345 -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_HRS -g ${iqtree_constraint_tree}" 
        fi
      fi
    fi
  ##01-3 Check if IQ-TREE was successfully ran.
    if [ ! -s "IQTREE_${prefix}_HRS.treefile" ]; then
      stage4_error "fail to run IQ-TREE." 
      stage4_blank "                    HybSuite exits." 
      stage4_blank "" 
      exit 1
    else 
      stage4_info "Successfully finish running IQ-TREE." 
    fi
  ##01-4 reroot the tree via phyx
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./IQTREE_${prefix}_HRS.treefile -g "
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      if [[ $x -eq 1 ]]; then
        eval "og_params=\"\${og$x}\""
      else
        eval "og_params+=\",\${og$x}\""
      fi
    done
    cmd+="${og_params}"
# Run pxrr
    stage4_info "Use phyx to reroot the tree (IQTREE)..." 
    stage4_cmd "$cmd > ./IQTREE_rr_${prefix}_HRS.tre ..."
    eval "$cmd > ./IQTREE_rr_${prefix}_HRS.tre"
    if [ ! -s "./IQTREE_rr_${prefix}_HRS.tre" ]; then
      stage4_error "Fail to reroot the tree: " 
      stage4_blank "                    ${o}/05-Concatenated_trees/HRS/IQTREE/IQTREE_${prefix}_HRS.treefile." 
      stage4_info "Please check your alignments and trees produced by IQTREE." 
      stage4_blank ""
    else
      stage4_info "Successfully reroot the IQ-TREE tree." 
      stage4_info "Successfully finish all the IQ-TREE pipeline for HRS alignments." 
      stage4_info "Now moving on to the next step..." 
      stage4_blank "" 
    fi
  fi
fi

#(2) RAxML
if [ "${run_raxml}" = "TRUE" ]; then
  if [ "${HRS}" = "TRUE" ]; then
##02-1 Set the directory
    cd ${o}/03-Supermatrix/HRS
    mkdir -p ${o}/05-Concatenated_trees/HRS/RAxML
    stage4_info "Running RAxML for HRS alignments..." 
##02-2 Run RAxML
    if [ "$(ls -A "${o}/05-Concatenated_trees/HRS/RAxML/")" ]; then
      rm ${o}/05-Concatenated_trees/HRS/RAxML/RAxML*
    fi
##02-2.1 If the user enables the Add Restriction tree feature (add the --tree-constraint < constraint tree path > parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      raxmlHPC="${HRS_raxmlHPC_mtest} -f a -T ${nt_raxml} -p 12345 -x 67890 -# ${raxml_bb} -n ${prefix}_HRS.tre -w ${o}/05-Concatenated_trees/HRS/RAxML"
      if [ "${raxml_constraint_tree}" != "_____" ]; then
        ${raxmlHPC} -g ${raxml_constraint_tree}
        stage4_cmd "${raxmlHPC} -g ${raxml_constraint_tree}" 
      else
        ${raxmlHPC}
        stage4_cmd "${raxmlHPC}"
      fi
    else
      if [ "${raxml_constraint_tree}" = "_____" ]; then
        raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta \
        -m ${raxml_m} -f a \
        -T ${nt_raxml} \
        -p 12345 \
        -x 67890 \
        -# 1000 \
        -n "${prefix}_HRS.tre" -w ${o}/05-Concatenated_trees/HRS/RAxML
        stage4_cmd "raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta -m ${raxml_m} -f a -T ${nt_raxml} -p 12345 -x 67890 -# 1000 -n ${prefix}_HRS.tre -w ${o}/05-Concatenated_trees/HRS/RAxML" 
      else
        raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta \
        -m ${raxml_m} -f a \
        -T ${nt_raxml} \
        -p 12345 \
        -x 67890 \
        -# 1000 \
        -n "${prefix}_HRS.tre" -w ${o}/05-Concatenated_trees/HRS/RAxML \
        -g ${raxml_constraint_tree}
        stage4_cmd "raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta -m ${raxml_m} -f a -T ${nt_raxml} -p 12345 -x 67890 -# 1000 -n ${prefix}_HRS.tre -w ${o}/05-Concatenated_trees/HRS/RAxML -g ${raxml_constraint_tree}" 
      fi
    fi
    if [ ! -s "${o}/05-Concatenated_trees/HRS/RAxML/RAxML_bestTree.${prefix}_HRS.tre" ]; then
      stage4_error "Fail to run RAxML." 
      stage4_blank "                    HybSuite exits." 
      stage4_blank "" 
      exit 1
    else 
      stage4_info "Successfully finish running RAxML."
    fi
##02-3 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/HRS/RAxML/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./RAxML_bipartitions.${prefix}_HRS.tre -g "
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      if [[ $x -eq 1 ]]; then
        eval "og_params=\"\${og$x}\""
      else
        eval "og_params+=\",\${og$x}\""
      fi
    done
    cmd+="${og_params}"
# Run pxrr
    stage4_info "Use phyx to reroot the tree (RAxML)..." 
    eval "$cmd > ./RAxML_rr_${prefix}_HRS.tre"
    stage4_cmd "$cmd > ./RAxML_rr_${prefix}_HRS.tre ..."
# Check if the user ran phyx successfully
    if [ ! -s "./RAxML_rr_${prefix}_HRS.tre" ]; then
      stage4_error "Fail to reroot the tree: " 
      stage4_blank "                    ${o}/05-Concatenated_trees/HRS/RAxML/RAxML_bipartitions.${prefix}_HRS.tre." 
      stage4_info "Please check your alignments and trees produced by RAxML." 
      stage4_blank ""
    else
      stage4_info "Successfully reroot the RAxML tree." 
      stage4_info "Successfully finish all the RAxML pipeline for HRS alignments..." 
      stage4_cmd "Now moving on to the next step..."
      stage4_blank "" 
    fi
  fi
fi

#(3) RAxML-NG
if [ "${run_raxml_ng}" != "FALSE" ] && [ "${run_raxml_ng}" != "False" ]; then
  if [ "${HRS}" = "TRUE" ]; then
##01 Set the directory
    mkdir -p ${o}/05-Concatenated_trees/HRS/RAxML-NG
##02 Run RAxML-NG
    stage4_info "Running RAxML-NG for HRS alignments..."  
##02.1 If the user sets the rng_force parameter to TRUE, the Ignore Thread warning feature is enabled (add the --force perf_threads parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ] && [ ! -s "${rng_constraint_tree}" ]; then
      raxml_ng="${HRS_raxml_ng_mtest} --all --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/HRS/RAxML-NG/RAxML-NG_${prefix}_HRS --bs-trees ${rng_bs_trees}"
      if [ "${rng_force}" = "TRUE" ]; then
          ${raxml_ng} --force perf_threads
          stage4_cmd "${raxml_ng} --force perf_threads"
      else
          ${raxml_ng}
          stage4_cmd "${raxml_ng}"
      fi
    fi
    
    if [ "${run_modeltest_ng}" = "FALSE" ] && [ ! -s "${rng_constraint_tree}" ]; then
      if [ "${rng_force}" = "TRUE" ]; then
        raxml-ng --parse --msa ${o}/03-Supermatrix/HRS/HybSuite_HRS.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/HRS/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/HRS/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/HRS/RAxML-NG/RAxML-NG_${prefix}_HRS \
        --bs-trees ${rng_bs_trees} \
        --force perf_threads
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/HRS/RAxML-NG/RAxML-NG_${prefix}_HRS --bs-trees ${rng_bs_trees} --force perf_threads --partition ${o}/01-Supermatrix/03-Supermatrix/HRS/partition.txt"
      else
        raxml-ng --parse --msa ${o}/03-Supermatrix/HRS/HybSuite_HRS.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/HRS/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/HRS/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/HRS/RAxML-NG/RAxML-NG_${prefix}_HRS \
        --bs-trees ${rng_bs_trees}
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/HRS/RAxML-NG/RAxML-NG_${prefix}_HRS --bs-trees ${rng_bs_trees}"
      fi
    fi

    if [ "${run_modeltest_ng}" = "TRUE" ] && [ -s "${rng_constraint_tree}" ]; then
      raxml_ng="${HRS_raxml_ng_mtest} --all --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/HRS/RAxML-NG/RAxML-NG_${prefix}_HRS --bs-trees ${rng_bs_trees}"
      if [ "${rng_force}" = "TRUE" ]; then
          ${raxml_ng} --force perf_threads --tree-constraint ${rng_constraint_tree}
          stage4_cmd "${raxml_ng} --force perf_threads --tree-constraint ${rng_constraint_tree}"
      else
          ${raxml_ng} --tree-constraint ${rng_constraint_tree}
          stage4_cmd "${raxml_ng} --tree-constraint ${rng_constraint_tree}"
      fi
    fi
    
    if [ "${run_modeltest_ng}" = "FALSE" ] && [ -s "${rng_constraint_tree}" ]; then
      if [ "${rng_force}" = "TRUE" ]; then
        raxml-ng --parse --msa ${o}/03-Supermatrix/HRS/HybSuite_HRS.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/HRS/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/HRS/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta \
        --tree-constraint ${rng_constraint_tree} \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/HRS/RAxML-NG/RAxML-NG_${prefix}_HRS \
        --bs-trees ${rng_bs_trees} \
        --force perf_threads
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta --tree-constraint ${rng_constraint_tree} --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/HRS/RAxML-NG/RAxML-NG_${prefix}_HRS --bs-trees ${rng_bs_trees} --force perf_threads --partition ${o}/01-Supermatrix/03-Supermatrix/HRS/partition.txt"
      else
        raxml-ng --parse --msa ${o}/03-Supermatrix/HRS/HybSuite_HRS.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/HRS/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/HRS/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta \
        --tree-constraint ${rng_constraint_tree} \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/HRS/RAxML-NG/RAxML-NG_${prefix}_HRS \
        --bs-trees ${rng_bs_trees}
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta --tree-constraint ${rng_constraint_tree} --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/HRS/RAxML-NG/RAxML-NG_${prefix}_HRS --bs-trees ${rng_bs_trees}"
      fi
    fi

##02.3 Check if the user ran RAxML-NG successfully
    if [ ! -s "${o}/05-Concatenated_trees/HRS/RAxML-NG/RAxML-NG_${prefix}_HRS.raxml.support" ]; then
      stage4_error "Fail to run RAxML-NG."
      stage4_cmd "HybSuite exits."
      stage4_blank "" 
      exit 1
    else 
      stage4_info "Successfully finish running RAxML-NG." 
    fi
##03 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/HRS/RAxML-NG/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./RAxML-NG_${prefix}_HRS.raxml.support -g "
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      if [[ $x -eq 1 ]]; then
        eval "og_params=\"\${og$x}\""
      else
        eval "og_params+=\",\${og$x}\""
      fi
    done
    cmd+="${og_params}"  
# Run pxrr
    stage4_info "Use phyx to reroot the tree (RAxML-NG)..."
    stage4_cmd "$cmd > ./RAxML-NG_rr_${prefix}_HRS.tre ..."
    eval "$cmd > ./RAxML-NG_rr_${prefix}_HRS.tre"
    if [ ! -s "./RAxML-NG_rr_${prefix}_HRS.tre" ]; then
      echo "[HybSuite-WARNING]: Fail to reroot the tree: " 
      echo "                    ${o}/05-Concatenated_trees/HRS/RAxML-NG/RAxML-NG_${prefix}_HRS.tre." 
      stage4_info "Please check your alignments and trees produced by RAxML-NG." 
      stage4_blank ""
    else
      stage4_info "Successfully reroot the RAxML-NG tree for HRS alignments."
      stage4_info "Successfully finish all the RAxML-NG pipeline for HRS alignments..."
      stage4_cmd "Now moving on to the next step..."
      stage4_blank "" 
    fi
  fi
fi

#02-RAPP #######################
if [ "${RAPP}" = "TRUE" ]; then
  stage4_info "<=== RAPP alignments ===>"
fi
#(1) IQ-TREE
if [ "${run_iqtree}" = "TRUE" ]; then
  if [ "${RAPP}" = "TRUE" ]; then 
  ##01-1 Set the directory
    mkdir -p ${o}/05-Concatenated_trees/RAPP/IQTREE
    cd ${o}/05-Concatenated_trees/RAPP/IQTREE
    stage4_info "Running IQTREE for RAPP alignments..." 
  ##01-2 run IQTREE
    if [ "$(ls -A "${o}/05-Concatenated_trees/RAPP/IQTREE/")" ]; then
      rm ${o}/05-Concatenated_trees/RAPP/IQTREE/IQTREE*
    fi
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${RAPP_iqtree} -B ${iqtree_bb} --undo \
          --seed 12345 -T ${nt_iqtree} -pre IQTREE_${prefix}_RAPP \
          -p ${o}/03-Supermatrix/RAPP/partition.txt
          stage4_cmd "${RAPP_iqtree} -B ${iqtree_bb} --undo -T ${nt_iqtree} -pre IQTREE_${prefix}_RAPP -p ${o}/03-Supermatrix/RAPP/partition.txt" 
        else
          ${RAPP_iqtree} -B ${iqtree_bb} --undo \
          --seed 12345 -T ${nt_iqtree} -pre IQTREE_${prefix}_RAPP -g "${iqtree_constraint_tree}" \
          -p ${o}/03-Supermatrix/RAPP/partition.txt
          stage4_cmd "${RAPP_iqtree} -B ${iqtree_bb} --undo -T ${nt_iqtree} -pre IQTREE_${prefix}_RAPP -g ${iqtree_constraint_tree} -p ${o}/03-Supermatrix/RAPP/partition.txt" 
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${RAPP_iqtree} -B ${iqtree_bb} --undo \
          --seed 12345 -T ${nt_iqtree} -pre IQTREE_${prefix}_RAPP
          stage4_cmd "${RAPP_iqtree} -B ${iqtree_bb} --undo -T ${nt_iqtree} -pre IQTREE_${prefix}_RAPP" 
        else
          ${RAPP_iqtree} -B ${iqtree_bb} --undo \
          --seed 12345 -T ${nt_iqtree} -pre IQTREE_${prefix}_RAPP -g "${iqtree_constraint_tree}"
          stage4_cmd "${RAPP_iqtree} -B ${iqtree_bb} --undo -T ${nt_iqtree} -pre IQTREE_${prefix}_RAPP -g ${iqtree_constraint_tree}" 
        fi
      fi
    else
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta --undo \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/RAPP/partition.txt -m MFP \
          -pre IQTREE_${prefix}_RAPP
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta --undo --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/RAPP/partition.txt -m MFP -pre IQTREE_${prefix}_RAPP" 
        else
          iqtree -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta --undo \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/RAPP/partition.txt -m MFP \
          -pre IQTREE_${prefix}_RAPP -g "${iqtree_constraint_tree}"
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta --undo --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/RAPP/partition.txt -m MFP -pre IQTREE_${prefix}_RAPP -g ${iqtree_constraint_tree}" 
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta --undo \
          --seed 12345 -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_RAPP
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta --undo -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_RAPP" 
        else
          iqtree -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta --undo \
          --seed 12345 -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_RAPP -g "${iqtree_constraint_tree}"
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta --undo -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_RAPP -g ${iqtree_constraint_tree}" 
        fi
      fi
    fi
  ##01-3 Check if IQ-TREE was successfully ran.
    if [ ! -s "IQTREE_${prefix}_RAPP.treefile" ]; then
      stage4_error "fail to run IQ-TREE." 
      stage4_blank "                    HybSuite exits." 
      stage4_blank "" 
      exit 1
    else 
      stage4_info "Successfully finish running IQ-TREE." 
    fi
  ##01-4 reroot the tree via phyx
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./IQTREE_${prefix}_RAPP.treefile -g "
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      if [[ $x -eq 1 ]]; then
        eval "og_params=\"\${og$x}\""
      else
        eval "og_params+=\",\${og$x}\""
      fi
    done
    cmd+="${og_params}"
# Run pxrr
    stage4_info "Use phyx to reroot the tree (IQTREE)..." 
    stage4_cmd "$cmd > ./IQTREE_rr_${prefix}_RAPP.tre ..."
    eval "$cmd > ./IQTREE_rr_${prefix}_RAPP.tre"
    if [ ! -s "./IQTREE_rr_${prefix}_RAPP.tre" ]; then
      stage4_error "Fail to reroot the tree: " 
      stage4_blank "                    ${o}/05-Concatenated_trees/RAPP/IQTREE/IQTREE_${prefix}_RAPP.treefile." 
      stage4_info "Please check your alignments and trees produced by IQTREE." 
      stage4_blank ""
    else
      stage4_info "Successfully reroot the IQ-TREE tree." 
      stage4_info "Successfully finish all the IQ-TREE pipeline for RAPP alignments." 
      stage4_info "Now moving on to the next step..." 
      stage4_blank "" 
    fi
  fi
fi

#(2) RAxML
if [ "${run_raxml}" = "TRUE" ]; then
  if [ "${RAPP}" = "TRUE" ]; then
##02-1 Set the directory
    cd ${o}/03-Supermatrix/RAPP
    mkdir -p ${o}/05-Concatenated_trees/RAPP/RAxML
    stage4_info "Running RAxML for RAPP alignments..." 
##02-2 Run RAxML
    if [ "$(ls -A "${o}/05-Concatenated_trees/RAPP/RAxML/")" ]; then
        rm ${o}/05-Concatenated_trees/RAPP/RAxML/RAxML*
    fi
##02-2.1 If the user enables the Add Restriction tree feature (add the --tree-constraint < constraint tree path > parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      raxmlHPC="${RAPP_raxmlHPC_mtest} -f a -T ${nt_raxml} -p 12345 -x 67890 -# ${raxml_bb} -n ${prefix}_RAPP.tre -w ${o}/05-Concatenated_trees/RAPP/RAxML"
      if [ "${raxml_constraint_tree}" != "_____" ]; then
        ${raxmlHPC} -g ${raxml_constraint_tree}
        stage4_cmd "${raxmlHPC} -g ${raxml_constraint_tree}" 
      else
        ${raxmlHPC}
        stage4_cmd "${raxmlHPC}" 
      fi
    else
      if [ "${raxml_constraint_tree}" = "_____" ]; then
        raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta \
        -m ${raxml_m} -f a \
        -T ${nt_raxml} \
        -p 12345 \
        -x 67890 \
        -# 1000 \
        -n "${prefix}_RAPP.tre" -w ${o}/05-Concatenated_trees/RAPP/RAxML
        stage4_cmd "raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta -m ${raxml_m} -f a -T ${nt_raxml} -p 12345 -x 67890 -# 1000 -n ${prefix}_RAPP.tre -w ${o}/05-Concatenated_trees/RAPP/RAxML" 
      else
        raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta \
        -m ${raxml_m} -f a \
        -T ${nt_raxml} \
        -p 12345 \
        -x 67890 \
        -# 1000 \
        -n "${prefix}_RAPP.tre" -w ${o}/05-Concatenated_trees/RAPP/RAxML \
        -g ${raxml_constraint_tree}
        stage4_cmd "raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta -m ${raxml_m} -f a -T ${nt_raxml} -p 12345 -x 67890 -# 1000 -n ${prefix}_RAPP.tre -w ${o}/05-Concatenated_trees/RAPP/RAxML -g ${raxml_constraint_tree}" 
      fi
    fi
    if [ ! -s "${o}/05-Concatenated_trees/RAPP/RAxML/RAxML_bestTree.${prefix}_RAPP.tre" ]; then
      stage4_error "Fail to run RAxML." 
      stage4_blank "                    HybSuite exits." 
      stage4_blank "" 
      exit 1
    else 
      stage4_info "Successfully finish running RAxML." 
    fi
##02-3 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/RAPP/RAxML/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./RAxML_bipartitions.${prefix}_RAPP.tre -g "
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      if [[ $x -eq 1 ]]; then
        eval "og_params=\"\${og$x}\""
      else
        eval "og_params+=\",\${og$x}\""
      fi
    done
    cmd+="${og_params}"
# Run pxrr
    stage4_info "Use phyx to reroot the tree (RAxML)..." 
    eval "$cmd > ./RAxML_rr_${prefix}_RAPP.tre"
    stage4_cmd "$cmd > ./RAxML_rr_${prefix}_RAPP.tre ..."
# Check if the user ran phyx successfully
    if [ ! -s "./RAxML_rr_${prefix}_RAPP.tre" ]; then
      stage4_error "Fail to reroot the tree: " 
      stage4_blank "                    ${o}/05-Concatenated_trees/RAPP/RAxML/RAxML_bipartitions.${prefix}_RAPP.tre." 
      stage4_info "Please check your alignments and trees produced by RAxML." 
      stage4_blank ""
    else
      stage4_info "Successfully reroot the RAxML tree." 
      stage4_info "Successfully finish all the RAxML pipeline for RAPP alignments..." 
      stage4_info "Now moving on to the next step..."
      stage4_blank "" 
    fi
  fi
fi

#(3) RAxML-NG
if [ "${run_raxml_ng}" != "FALSE" ] && [ "${run_raxml_ng}" != "False" ]; then
  if [ "${RAPP}" = "TRUE" ]; then
##01 Set the directory
    mkdir -p ${o}/05-Concatenated_trees/RAPP/RAxML-NG
##02 Run RAxML-NG
    stage4_info "Running RAxML-NG for RAPP alignments..."  
##02.1 If the user sets the rng_force parameter to TRUE, the Ignore Thread warning feature is enabled (add the --force perf_threads parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ] && [ ! -s "${rng_constraint_tree}" ]; then
      raxml_ng="${RAPP_raxml_ng_mtest} --all --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/RAPP/RAxML-NG/RAxML-NG_${prefix}_RAPP --bs-trees ${rng_bs_trees}"
      if [ "${rng_force}" = "TRUE" ]; then
          ${raxml_ng} --force perf_threads
          stage4_cmd "${raxml_ng} --force perf_threads"
      else
          ${raxml_ng}
          stage4_cmd "${raxml_ng}"
      fi
    fi
    
    if [ "${run_modeltest_ng}" = "FALSE" ] && [ ! -s "${rng_constraint_tree}" ]; then
      if [ "${rng_force}" = "TRUE" ]; then
        raxml-ng --parse --msa ${o}/03-Supermatrix/RAPP/HybSuite_RAPP.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/RAPP/RAxML-NG/raxml_ng_test --threads ${nt_raxml}
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/RAPP/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/RAPP/RAxML-NG/RAxML-NG_${prefix}_RAPP \
        --bs-trees ${rng_bs_trees} \
        --force perf_threads
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/RAPP/RAxML-NG/RAxML-NG_${prefix}_RAPP --bs-trees ${rng_bs_trees} --force perf_threads --partition ${o}/01-Supermatrix/03-Supermatrix/RAPP/partition.txt"
      else
        raxml-ng --parse --msa ${o}/03-Supermatrix/RAPP/HybSuite_RAPP.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/RAPP/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/RAPP/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/RAPP/RAxML-NG/RAxML-NG_${prefix}_RAPP \
        --bs-trees ${rng_bs_trees}
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/RAPP/RAxML-NG/RAxML-NG_${prefix}_RAPP --bs-trees ${rng_bs_trees}"
      fi
    fi

    if [ "${run_modeltest_ng}" = "TRUE" ] && [ -s "${rng_constraint_tree}" ]; then
      raxml_ng="${RAPP_raxml_ng_mtest} --all --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/RAPP/RAxML-NG/RAxML-NG_${prefix}_RAPP --bs-trees ${rng_bs_trees}"
      if [ "${rng_force}" = "TRUE" ]; then
          ${raxml_ng} --force perf_threads --tree-constraint ${rng_constraint_tree}
          stage4_cmd "${raxml_ng} --force perf_threads --tree-constraint ${rng_constraint_tree}"
      else
          ${raxml_ng} --tree-constraint ${rng_constraint_tree}
          stage4_cmd "${raxml_ng} --tree-constraint ${rng_constraint_tree}"
      fi
    fi
    
    if [ "${run_modeltest_ng}" = "FALSE" ] && [ -s "${rng_constraint_tree}" ]; then
      if [ "${rng_force}" = "TRUE" ]; then
        raxml-ng --parse --msa ${o}/03-Supermatrix/RAPP/HybSuite_RAPP.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/RAPP/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/RAPP/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta \
        --tree-constraint ${rng_constraint_tree} \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/RAPP/RAxML-NG/RAxML-NG_${prefix}_RAPP \
        --bs-trees ${rng_bs_trees} \
        --force perf_threads
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta --tree-constraint ${rng_constraint_tree} --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/RAPP/RAxML-NG/RAxML-NG_${prefix}_RAPP --bs-trees ${rng_bs_trees} --force perf_threads --partition ${o}/01-Supermatrix/03-Supermatrix/RAPP/partition.txt"
      else
        raxml-ng --parse --msa ${o}/03-Supermatrix/RAPP/HybSuite_RAPP.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/RAPP/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/RAPP/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta \
        --tree-constraint ${rng_constraint_tree} \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/RAPP/RAxML-NG/RAxML-NG_${prefix}_RAPP \
        --bs-trees ${rng_bs_trees}
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta --tree-constraint ${rng_constraint_tree} --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/RAPP/RAxML-NG/RAxML-NG_${prefix}_RAPP --bs-trees ${rng_bs_trees}"
      fi
    fi

##02.3 Check if the user ran RAxML-NG successfully
    if [ ! -s "${o}/05-Concatenated_trees/RAPP/RAxML-NG/RAxML-NG_${prefix}_RAPP.raxml.support" ]; then
      stage4_error "Fail to run RAxML-NG."
      stage4_cmd "HybSuite exits."
      stage4_blank "" 
      exit 1
    else 
      stage4_info "Successfully finish running RAxML-NG." 
    fi
##03 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/RAPP/RAxML-NG/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./RAxML-NG_${prefix}_RAPP.raxml.support -g "
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      if [[ $x -eq 1 ]]; then
        eval "og_params=\"\${og$x}\""
      else
        eval "og_params+=\",\${og$x}\""
      fi
    done
    cmd+="${og_params}"  
# Run pxrr
    stage4_info "Use phyx to reroot the tree (RAxML-NG)..."
    stage4_cmd "$cmd > ./RAxML-NG_rr_${prefix}_RAPP.tre ..."
    eval "$cmd > ./RAxML-NG_rr_${prefix}_RAPP.tre"
    if [ ! -s "./RAxML-NG_rr_${prefix}_RAPP.tre" ]; then
      echo "[HybSuite-WARNING]: Fail to reroot the tree: " 
      echo "                    ${o}/05-Concatenated_trees/RAPP/RAxML-NG/RAxML-NG_${prefix}_RAPP.tre." 
      stage4_info "Please check your alignments and trees produced by RAxML-NG." 
      stage4_blank ""
    else
      stage4_info "Successfully reroot the RAxML-NG tree for RAPP alignments."
      stage4_info "Successfully finish all the RAxML-NG pipeline for RAPP alignments..."
      stage4_cmd "Now moving on to the next step..."
      stage4_blank "" 
    fi
  fi
fi

#03-LS #######################
if [ "${LS}" = "TRUE" ]; then
  stage4_info "<=== LS alignments ===>"
fi
#(1) IQ-TREE
if [ "${run_iqtree}" = "TRUE" ]; then
  if [ "${LS}" = "TRUE" ]; then 
  ##01-1 Set the directory
    mkdir -p ${o}/05-Concatenated_trees/LS/IQTREE
    cd ${o}/05-Concatenated_trees/LS/IQTREE
    stage4_info "Running IQTREE for LS alignments..." 
  ##01-2 run IQTREE
    if [ "$(ls -A "${o}/05-Concatenated_trees/LS/IQTREE/")" ]; then
        rm ${o}/05-Concatenated_trees/LS/IQTREE/IQTREE*
    fi
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${LS_iqtree} -B ${iqtree_bb} --undo \
          --seed 12345 -T ${nt_iqtree} -pre IQTREE_${prefix}_LS \
          -p ${o}/03-Supermatrix/LS/partition.txt
          stage4_cmd "${LS_iqtree} -B ${iqtree_bb} --undo --seed 12345 -T ${nt_iqtree} -pre IQTREE_${prefix}_LS -p ${o}/03-Supermatrix/LS/partition.txt" 
        else
          ${LS_iqtree} -B ${iqtree_bb} --undo \
          --seed 12345 -T ${nt_iqtree} -pre IQTREE_${prefix}_LS -g "${iqtree_constraint_tree}" \
          -p ${o}/03-Supermatrix/LS/partition.txt
          stage4_cmd "${LS_iqtree} -B ${iqtree_bb} --undo --seed 12345 -T ${nt_iqtree} -pre IQTREE_${prefix}_LS -g ${iqtree_constraint_tree} -p ${o}/03-Supermatrix/LS/partition.txt" 
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${LS_iqtree} -B ${iqtree_bb} --undo \
          --seed 12345 -T ${nt_iqtree} -pre IQTREE_${prefix}_LS
          stage4_cmd "${LS_iqtree} -B ${iqtree_bb} --undo --seed 12345 -T ${nt_iqtree} -pre IQTREE_${prefix}_LS" 
        else
          ${LS_iqtree} -B ${iqtree_bb} --undo \
          --seed 12345 -T ${nt_iqtree} -pre IQTREE_${prefix}_LS -g "${iqtree_constraint_tree}"
          stage4_cmd "${LS_iqtree} -B ${iqtree_bb} --undo --seed 12345 -T ${nt_iqtree} -pre IQTREE_${prefix}_LS -g ${iqtree_constraint_tree}" 
        fi
      fi
    else
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/LS/${prefix}_LS.fasta --undo \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/LS/partition.txt -m MFP \
          -pre IQTREE_${prefix}_LS
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/LS/${prefix}_LS.fasta --undo --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/LS/partition.txt -m MFP -pre IQTREE_${prefix}_LS" 
        else
          iqtree -s ${o}/03-Supermatrix/LS/${prefix}_LS.fasta --undo \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/LS/partition.txt -m MFP \
          -pre IQTREE_${prefix}_LS -g "${iqtree_constraint_tree}"
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/LS/${prefix}_LS.fasta --undo --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/LS/partition.txt -m MFP -pre IQTREE_${prefix}_LS -g ${iqtree_constraint_tree}" 
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/LS/${prefix}_LS.fasta --undo \
          -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_LS
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/LS/${prefix}_LS.fasta --undo --seed 12345 -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_LS" 
        else
          iqtree -s ${o}/03-Supermatrix/LS/${prefix}_LS.fasta --undo \
          -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_LS -g "${iqtree_constraint_tree}"
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/LS/${prefix}_LS.fasta --undo --seed 12345 -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_LS -g ${iqtree_constraint_tree}" 
        fi
      fi
    fi
  ##01-3 Check if IQ-TREE was successfully ran.
    if [ ! -s "IQTREE_${prefix}_LS.treefile" ]; then
      stage4_error "fail to run IQ-TREE." 
      stage4_blank "                    HybSuite exits." 
      stage4_blank "" 
      exit 1
    else 
      stage4_info "Successfully finish running IQ-TREE." 
    fi
  ##01-4 reroot the tree via phyx
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./IQTREE_${prefix}_LS.treefile -g "
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      if [[ $x -eq 1 ]]; then
        eval "og_params=\"\${og$x}\""
      else
        eval "og_params+=\",\${og$x}\""
      fi
    done
    cmd+="${og_params}"
# Run pxrr
    stage4_info "Use phyx to reroot the tree (IQTREE)..." 
    stage4_cmd "$cmd > ./IQTREE_rr_${prefix}_LS.tre ..."
    eval "$cmd > ./IQTREE_rr_${prefix}_LS.tre"
    if [ ! -s "./IQTREE_rr_${prefix}_LS.tre" ]; then
      stage4_error "Fail to reroot the tree: " 
      stage4_blank "                    ${o}/05-Concatenated_trees/LS/IQTREE/IQTREE_${prefix}_LS.treefile." 
      stage4_info "Please check your alignments and trees produced by IQTREE." 
      stage4_blank ""
    else
      stage4_info "Successfully reroot the IQ-TREE tree." 
      stage4_info "Successfully finish all the IQ-TREE pipeline for LS alignments." 
      stage4_info "Now moving on to the next step..." 
      stage4_blank "" 
    fi
  fi
fi
#(2) RAxML
if [ "${run_raxml}" = "TRUE" ]; then
  if [ "${LS}" = "TRUE" ]; then
##02-1 Set the directory
    cd ${o}/03-Supermatrix/LS
    mkdir -p ${o}/05-Concatenated_trees/LS/RAxML
    stage4_info "Running RAxML for LS alignments..." 
##02-2 Run RAxML
    if [ "$(ls -A "${o}/05-Concatenated_trees/LS/RAxML/")" ]; then
        rm ${o}/05-Concatenated_trees/LS/RAxML/RAxML*
    fi
##02-2.1 If the user enables the Add Restriction tree feature (add the --tree-constraint < constraint tree path > parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      raxmlHPC="${LS_raxmlHPC_mtest} -f a -T ${nt_raxml} -p 12345 -x 67890 -# ${raxml_bb} -n ${prefix}_LS.tre -w ${o}/05-Concatenated_trees/LS/RAxML"
      if [ "${raxml_constraint_tree}" != "_____" ]; then
        ${raxmlHPC} -g ${raxml_constraint_tree}
        stage4_cmd "${raxmlHPC} -g ${raxml_constraint_tree}" 
      else
        ${raxmlHPC}
        stage4_cmd "${raxmlHPC}" 
      fi
    else
      if [ "${raxml_constraint_tree}" = "_____" ]; then
        raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/LS/${prefix}_LS.fasta \
        -m ${raxml_m} -f a \
        -T ${nt_raxml} \
        -p 12345 \
        -x 67890 \
        -# 1000 \
        -n "${prefix}_LS.tre" -w ${o}/05-Concatenated_trees/LS/RAxML
        stage4_cmd "raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/LS/${prefix}_LS.fasta -m ${raxml_m} -f a -x -T ${nt_raxml} -p 12345 -x 67890 -# 1000 -n ${prefix}_LS.tre -w ${o}/05-Concatenated_trees/LS/RAxML" 
      else
        raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/LS/${prefix}_LS.fasta \
        -m ${raxml_m} -f a \
        -T ${nt_raxml} \
        -p 12345 \
        -x 67890 \
        -# 1000 \
        -n "${prefix}_LS.tre" -w ${o}/05-Concatenated_trees/LS/RAxML \
        -g ${raxml_constraint_tree}
        stage4_cmd "raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/LS/${prefix}_LS.fasta -m ${raxml_m} -f a -x -T ${nt_raxml} -p 12345 -x 67890 -# 1000 -n ${prefix}_LS.tre -w ${o}/05-Concatenated_trees/LS/RAxML -g ${raxml_constraint_tree}" 
      fi
    fi
    if [ ! -s "${o}/05-Concatenated_trees/LS/RAxML/RAxML_bestTree.${prefix}_LS.tre" ]; then
      stage4_error "Fail to run RAxML." 
      stage4_blank "                    HybSuite exits." 
      stage4_blank "" 
      exit 1
    else 
      stage4_info "Successfully finish running RAxML." 
    fi
##02-3 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/LS/RAxML/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./RAxML_bipartitions.${prefix}_LS.tre -g "
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      if [[ $x -eq 1 ]]; then
        eval "og_params=\"\${og$x}\""
      else
        eval "og_params+=\",\${og$x}\""
      fi
    done
    cmd+="${og_params}"
# Run pxrr
    stage4_info "Use phyx to reroot the tree (RAxML)..." 
    eval "$cmd > ./RAxML_rr_${prefix}_LS.tre"
    stage4_cmd "$cmd > ./RAxML_rr_${prefix}_LS.tre ..."
# Check if the user ran phyx successfully
    if [ ! -s "./RAxML_rr_${prefix}_LS.tre" ]; then
      stage4_error "Fail to reroot the tree: " 
      stage4_blank "                    ${o}/05-Concatenated_trees/LS/RAxML/RAxML_bipartitions.${prefix}_LS.tre." 
      stage4_info "Please check your alignments and trees produced by RAxML." 
      stage4_blank ""
    else
      stage4_info "Successfully reroot the RAxML tree." 
      stage4_info "Successfully finish all the RAxML pipeline for LS alignments..." 
      stage4_info "Now moving on to the next step..."
      stage4_blank "" 
    fi
  fi
fi
#(3) RAxML-NG
if [ "${run_raxml_ng}" != "FALSE" ] && [ "${run_raxml_ng}" != "False" ]; then
  if [ "${LS}" = "TRUE" ]; then
##01 Set the directory
    mkdir -p ${o}/05-Concatenated_trees/LS/RAxML-NG
##02 Run RAxML-NG
    stage4_info "Running RAxML-NG for LS alignments..."  
##02.1 If the user sets the rng_force parameter to TRUE, the Ignore Thread warning feature is enabled (add the --force perf_threads parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ] && [ ! -s "${rng_constraint_tree}" ]; then
      raxml_ng="${LS_raxml_ng_mtest} --all --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/LS/RAxML-NG/RAxML-NG_${prefix}_LS --bs-trees ${rng_bs_trees}"
      if [ "${rng_force}" = "TRUE" ]; then
          ${raxml_ng} --force perf_threads
          stage4_cmd "${raxml_ng} --force perf_threads"
      else
          ${raxml_ng}
          stage4_cmd "${raxml_ng}"
      fi
    fi
    
    if [ "${run_modeltest_ng}" = "FALSE" ] && [ ! -s "${rng_constraint_tree}" ]; then
      if [ "${rng_force}" = "TRUE" ]; then
        raxml-ng --parse --msa ${o}/03-Supermatrix/LS/HybSuite_LS.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/LS/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/LS/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/LS/${prefix}_LS.fasta \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/LS/RAxML-NG/RAxML-NG_${prefix}_LS \
        --bs-trees ${rng_bs_trees} \
        --force perf_threads
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/LS/${prefix}_LS.fasta --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/LS/RAxML-NG/RAxML-NG_${prefix}_LS --bs-trees ${rng_bs_trees} --force perf_threads --partition ${o}/01-Supermatrix/03-Supermatrix/LS/partition.txt"
      else
        raxml-ng --parse --msa ${o}/03-Supermatrix/LS/HybSuite_LS.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/LS/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/LS/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/LS/${prefix}_LS.fasta \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/LS/RAxML-NG/RAxML-NG_${prefix}_LS \
        --bs-trees ${rng_bs_trees}
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/LS/${prefix}_LS.fasta --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/LS/RAxML-NG/RAxML-NG_${prefix}_LS --bs-trees ${rng_bs_trees}"
      fi
    fi

    if [ "${run_modeltest_ng}" = "TRUE" ] && [ -s "${rng_constraint_tree}" ]; then
      raxml_ng="${LS_raxml_ng_mtest} --all --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/LS/RAxML-NG/RAxML-NG_${prefix}_LS --bs-trees ${rng_bs_trees}"
      if [ "${rng_force}" = "TRUE" ]; then
          ${raxml_ng} --force perf_threads --tree-constraint ${rng_constraint_tree}
          stage4_cmd "${raxml_ng} --force perf_threads --tree-constraint ${rng_constraint_tree}"
      else
          ${raxml_ng} --tree-constraint ${rng_constraint_tree}
          stage4_cmd "${raxml_ng} --tree-constraint ${rng_constraint_tree}"
      fi
    fi
    
    if [ "${run_modeltest_ng}" = "FALSE" ] && [ -s "${rng_constraint_tree}" ]; then
      if [ "${rng_force}" = "TRUE" ]; then
        raxml-ng --parse --msa ${o}/03-Supermatrix/LS/HybSuite_LS.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/LS/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/LS/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/LS/${prefix}_LS.fasta \
        --tree-constraint ${rng_constraint_tree} \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/LS/RAxML-NG/RAxML-NG_${prefix}_LS \
        --bs-trees ${rng_bs_trees} \
        --force perf_threads
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/LS/${prefix}_LS.fasta --tree-constraint ${rng_constraint_tree} --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/LS/RAxML-NG/RAxML-NG_${prefix}_LS --bs-trees ${rng_bs_trees} --force perf_threads --partition ${o}/01-Supermatrix/03-Supermatrix/LS/partition.txt"
      else
        raxml-ng --parse --msa ${o}/03-Supermatrix/LS/HybSuite_LS.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/LS/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/LS/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/LS/${prefix}_LS.fasta \
        --tree-constraint ${rng_constraint_tree} \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/LS/RAxML-NG/RAxML-NG_${prefix}_LS \
        --bs-trees ${rng_bs_trees}
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/LS/${prefix}_LS.fasta --tree-constraint ${rng_constraint_tree} --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/LS/RAxML-NG/RAxML-NG_${prefix}_LS --bs-trees ${rng_bs_trees}"
      fi
    fi

##02.3 Check if the user ran RAxML-NG successfully
    if [ ! -s "${o}/05-Concatenated_trees/LS/RAxML-NG/RAxML-NG_${prefix}_LS.raxml.support" ]; then
      stage4_error "Fail to run RAxML-NG."
      stage4_cmd "HybSuite exits."
      stage4_blank "" 
      exit 1
    else 
      stage4_info "Successfully finish running RAxML-NG." 
    fi
##03 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/LS/RAxML-NG/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./RAxML-NG_${prefix}_LS.raxml.support -g "
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      if [[ $x -eq 1 ]]; then
        eval "og_params=\"\${og$x}\""
      else
        eval "og_params+=\",\${og$x}\""
      fi
    done
    cmd+="${og_params}"  
# Run pxrr
    stage4_info "Use phyx to reroot the tree (RAxML-NG)..."
    stage4_cmd "$cmd > ./RAxML-NG_rr_${prefix}_LS.tre ..."
    eval "$cmd > ./RAxML-NG_rr_${prefix}_LS.tre"
    if [ ! -s "./RAxML-NG_rr_${prefix}_LS.tre" ]; then
      echo "[HybSuite-WARNING]: Fail to reroot the tree: " 
      echo "                    ${o}/05-Concatenated_trees/LS/RAxML-NG/RAxML-NG_${prefix}_LS.tre." 
      stage4_info "Please check your alignments and trees produced by RAxML-NG." 
      stage4_blank ""
    else
      stage4_info "Successfully reroot the RAxML-NG tree for LS alignments."
      stage4_info "Successfully finish all the RAxML-NG pipeline for LS alignments..."
      stage4_cmd "Now moving on to the next step..."
      stage4_blank "" 
    fi
  fi
fi

#04-MI #######################
if [ "${MI}" = "TRUE" ]; then
  stage4_info "<=== MI alignments ===>"
fi
#(1) IQ-TREE
if [ "${run_iqtree}" = "TRUE" ]; then
  if [ "${MI}" = "TRUE" ]; then 
  ##01-1 Set the directory
    mkdir -p ${o}/05-Concatenated_trees/MI/IQTREE
    cd ${o}/05-Concatenated_trees/MI/IQTREE
    stage4_info "Running IQTREE for MI alignments..." 
  ##01-2 run IQTREE
    if [ "$(ls -A "${o}/05-Concatenated_trees/MI/IQTREE/")" ]; then
        rm ${o}/05-Concatenated_trees/MI/IQTREE/IQTREE*
    fi
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${MI_iqtree} -B ${iqtree_bb} --undo \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_MI \
          -p ${o}/03-Supermatrix/MI/partition.txt
          stage4_cmd "${MI_iqtree} -B ${iqtree_bb} --undo -T ${nt_iqtree} -pre IQTREE_${prefix}_MI -p ${o}/03-Supermatrix/MI/partition.txt" 
        else
          ${MI_iqtree} -B ${iqtree_bb} --undo \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_MI -g "${iqtree_constraint_tree}" \
          -p ${o}/03-Supermatrix/MI/partition.txt
          stage4_cmd "${MI_iqtree} -B ${iqtree_bb} --undo -T ${nt_iqtree} -pre IQTREE_${prefix}_MI -g ${iqtree_constraint_tree} -p ${o}/03-Supermatrix/MI/partition.txt" 
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${MI_iqtree} -B ${iqtree_bb} --undo \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_MI
          stage4_cmd "${MI_iqtree} -B ${iqtree_bb} --undo -T ${nt_iqtree} -pre IQTREE_${prefix}_MI" 
        else
          ${MI_iqtree} -B ${iqtree_bb} --undo \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_MI -g "${iqtree_constraint_tree}"
          stage4_cmd "${MI_iqtree} -B ${iqtree_bb} --undo -T ${nt_iqtree} -pre IQTREE_${prefix}_MI -g ${iqtree_constraint_tree}" 
        fi
      fi
    else
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta --undo \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/MI/partition.txt -m MFP \
          -pre IQTREE_${prefix}_MI
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta --undo --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/MI/partition.txt -m MFP -pre IQTREE_${prefix}_MI" 
        else
          iqtree -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta --undo \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/MI/partition.txt -m MFP \
          -pre IQTREE_${prefix}_MI -g "${iqtree_constraint_tree}"
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta --undo --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/MI/partition.txt -m MFP -pre IQTREE_${prefix}_MI -g ${iqtree_constraint_tree}" 
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta --undo \
          -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_MI
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta --undo -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_MI" 
        else
          iqtree -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta --undo \
          -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_MI -g "${iqtree_constraint_tree}"
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta --undo -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_MI -g ${iqtree_constraint_tree}" 
        fi
      fi
    fi
  ##01-3 Check if IQ-TREE was successfully ran.
    if [ ! -s "IQTREE_${prefix}_MI.treefile" ]; then
      stage4_error "fail to run IQ-TREE." 
      stage4_blank "                    HybSuite exits." 
      stage4_blank "" 
      exit 1
    else 
      stage4_info "Successfully finish running IQ-TREE." 
    fi
  ##01-4 reroot the tree via phyx
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./IQTREE_${prefix}_MI.treefile -g "
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      if [[ $x -eq 1 ]]; then
        eval "og_params=\"\${og$x}\""
      else
        eval "og_params+=\",\${og$x}\""
      fi
    done
    cmd+="${og_params}"
# Run pxrr
    stage4_info "Use phyx to reroot the tree (IQTREE)..." 
    stage4_cmd "$cmd > ./IQTREE_rr_${prefix}_MI.tre ..."
    eval "$cmd > ./IQTREE_rr_${prefix}_MI.tre"
    if [ ! -s "./IQTREE_rr_${prefix}_MI.tre" ]; then
      stage4_error "Fail to reroot the tree: " 
      stage4_blank "                    ${o}/05-Concatenated_trees/MI/IQTREE/IQTREE_${prefix}_MI.treefile." 
      stage4_info "Please check your alignments and trees produced by IQTREE." 
      stage4_blank ""
    else
      stage4_info "Successfully reroot the IQ-TREE tree." 
      stage4_info "Successfully finish all the IQ-TREE pipeline for MI alignments." 
      stage4_info "Now moving on to the next step..." 
      stage4_blank "" 
    fi
  fi
fi

#(2) RAxML
if [ "${run_raxml}" = "TRUE" ]; then
  if [ "${MI}" = "TRUE" ]; then
##02-1 Set the directory
    cd ${o}/03-Supermatrix/MI
    mkdir -p ${o}/05-Concatenated_trees/MI/RAxML
    stage4_info "Running RAxML for MI alignments..." 
##02-2 Run RAxML
    if [ "$(ls -A "${o}/05-Concatenated_trees/MI/RAxML/")" ]; then
        rm ${o}/05-Concatenated_trees/MI/RAxML/RAxML*
    fi
##02-2.1 If the user enables the Add Restriction tree feature (add the --tree-constraint < constraint tree path > parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      raxmlHPC="${MI_raxmlHPC_mtest} -f a -T ${nt_raxml} -p 12345 -x 67890 -# ${raxml_bb} -n ${prefix}_MI.tre -w ${o}/05-Concatenated_trees/MI/RAxML"
      if [ "${raxml_constraint_tree}" != "_____" ]; then
        ${raxmlHPC} -g ${raxml_constraint_tree}
        stage4_cmd "${raxmlHPC} -g ${raxml_constraint_tree}" 
      else
        ${raxmlHPC}
        stage4_cmd "${raxmlHPC}" 
      fi
    else
      if [ "${raxml_constraint_tree}" = "_____" ]; then
        raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta \
        -m ${raxml_m} -f a \
        -T ${nt_raxml} \
        -p 12345 \
        -x 67890 \
        -# 1000 \
        -n "${prefix}_MI.tre" -w ${o}/05-Concatenated_trees/MI/RAxML
        stage4_cmd "raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta -m ${raxml_m} -f a -x -T ${nt_raxml} -p 12345 -x 67890 -# 1000 -n ${prefix}_MI.tre -w ${o}/05-Concatenated_trees/MI/RAxML" 
      else
        raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta \
        -m ${raxml_m} -f a \
        -T ${nt_raxml} \
        -p 12345 \
        -x 67890 \
        -# 1000 \
        -n "${prefix}_MI.tre" -w ${o}/05-Concatenated_trees/MI/RAxML \
        -g ${raxml_constraint_tree}
        stage4_cmd "raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta -m ${raxml_m} -f a -x -T ${nt_raxml} -p 12345 -x 67890 -# 1000 -n ${prefix}_MI.tre -w ${o}/05-Concatenated_trees/MI/RAxML -g ${raxml_constraint_tree}" 
      fi
    fi
    if [ ! -s "${o}/05-Concatenated_trees/MI/RAxML/RAxML_bestTree.${prefix}_MI.tre" ]; then
      stage4_error "Fail to run RAxML." 
      stage4_blank "                    HybSuite exits." 
      stage4_blank "" 
      exit 1
    else 
      stage4_info "Successfully finish running RAxML." 
    fi
##02-3 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/MI/RAxML/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./RAxML_bipartitions.${prefix}_MI.tre -g "
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      if [[ $x -eq 1 ]]; then
        eval "og_params=\"\${og$x}\""
      else
        eval "og_params+=\",\${og$x}\""
      fi
    done
    cmd+="${og_params}"
# Run pxrr
    stage4_info "Use phyx to reroot the tree (RAxML)..." 
    eval "$cmd > ./RAxML_rr_${prefix}_MI.tre"
    stage4_cmd "$cmd > ./RAxML_rr_${prefix}_MI.tre ..."
# Check if the user ran phyx successfully
    if [ ! -s "./RAxML_rr_${prefix}_MI.tre" ]; then
      stage4_error "Fail to reroot the tree: " 
      stage4_blank "                    ${o}/05-Concatenated_trees/MI/RAxML/RAxML_bipartitions.${prefix}_MI.tre." 
      stage4_info "Please check your alignments and trees produced by RAxML." 
      stage4_blank ""
    else
      stage4_info "Successfully reroot the RAxML tree." 
      stage4_info "Successfully finish all the RAxML pipeline for MI alignments..." 
      stage4_info "Now moving on to the next step..."
      stage4_blank "" 
    fi
  fi
fi

#(3) RAxML-NG
if [ "${run_raxml_ng}" != "FALSE" ] && [ "${run_raxml_ng}" != "False" ]; then
  if [ "${MI}" = "TRUE" ]; then
##01 Set the directory
    mkdir -p ${o}/05-Concatenated_trees/MI/RAxML-NG
##02 Run RAxML-NG
    stage4_info "Running RAxML-NG for MI alignments..."  
##02.1 If the user sets the rng_force parameter to TRUE, the Ignore Thread warning feature is enabled (add the --force perf_threads parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ] && [ ! -s "${rng_constraint_tree}" ]; then
      raxml_ng="${MI_raxml_ng_mtest} --all --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/MI/RAxML-NG/RAxML-NG_${prefix}_MI --bs-trees ${rng_bs_trees}"
      if [ "${rng_force}" = "TRUE" ]; then
          ${raxml_ng} --force perf_threads
          stage4_cmd "${raxml_ng} --force perf_threads"
      else
          ${raxml_ng}
          stage4_cmd "${raxml_ng}"
      fi
    fi
    
    if [ "${run_modeltest_ng}" = "FALSE" ] && [ ! -s "${rng_constraint_tree}" ]; then
      if [ "${rng_force}" = "TRUE" ]; then
        raxml-ng --parse --msa ${o}/03-Supermatrix/MI/HybSuite_MI.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/MI/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/MI/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/MI/${prefix}_MI.fasta \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/MI/RAxML-NG/RAxML-NG_${prefix}_MI \
        --bs-trees ${rng_bs_trees} \
        --force perf_threads
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/MI/${prefix}_MI.fasta --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/MI/RAxML-NG/RAxML-NG_${prefix}_MI --bs-trees ${rng_bs_trees} --force perf_threads --partition ${o}/01-Supermatrix/03-Supermatrix/MI/partition.txt"
      else
        raxml-ng --parse --msa ${o}/03-Supermatrix/MI/HybSuite_MI.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/MI/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/MI/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/MI/${prefix}_MI.fasta \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/MI/RAxML-NG/RAxML-NG_${prefix}_MI \
        --bs-trees ${rng_bs_trees}
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/MI/${prefix}_MI.fasta --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/MI/RAxML-NG/RAxML-NG_${prefix}_MI --bs-trees ${rng_bs_trees}"
      fi
    fi

    if [ "${run_modeltest_ng}" = "TRUE" ] && [ -s "${rng_constraint_tree}" ]; then
      raxml_ng="${MI_raxml_ng_mtest} --all --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/MI/RAxML-NG/RAxML-NG_${prefix}_MI --bs-trees ${rng_bs_trees}"
      if [ "${rng_force}" = "TRUE" ]; then
          ${raxml_ng} --force perf_threads --tree-constraint ${rng_constraint_tree}
          stage4_cmd "${raxml_ng} --force perf_threads --tree-constraint ${rng_constraint_tree}"
      else
          ${raxml_ng} --tree-constraint ${rng_constraint_tree}
          stage4_cmd "${raxml_ng} --tree-constraint ${rng_constraint_tree}"
      fi
    fi
    
    if [ "${run_modeltest_ng}" = "FALSE" ] && [ -s "${rng_constraint_tree}" ]; then
      if [ "${rng_force}" = "TRUE" ]; then
        raxml-ng --parse --msa ${o}/03-Supermatrix/MI/HybSuite_MI.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/MI/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/MI/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/MI/${prefix}_MI.fasta \
        --tree-constraint ${rng_constraint_tree} \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/MI/RAxML-NG/RAxML-NG_${prefix}_MI \
        --bs-trees ${rng_bs_trees} \
        --force perf_threads
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/MI/${prefix}_MI.fasta --tree-constraint ${rng_constraint_tree} --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/MI/RAxML-NG/RAxML-NG_${prefix}_MI --bs-trees ${rng_bs_trees} --force perf_threads --partition ${o}/01-Supermatrix/03-Supermatrix/MI/partition.txt"
      else
        raxml-ng --parse --msa ${o}/03-Supermatrix/MI/HybSuite_MI.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/MI/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/MI/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/MI/${prefix}_MI.fasta \
        --tree-constraint ${rng_constraint_tree} \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/MI/RAxML-NG/RAxML-NG_${prefix}_MI \
        --bs-trees ${rng_bs_trees}
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/MI/${prefix}_MI.fasta --tree-constraint ${rng_constraint_tree} --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/MI/RAxML-NG/RAxML-NG_${prefix}_MI --bs-trees ${rng_bs_trees}"
      fi
    fi

##02.3 Check if the user ran RAxML-NG successfully
    if [ ! -s "${o}/05-Concatenated_trees/MI/RAxML-NG/RAxML-NG_${prefix}_MI.raxml.support" ]; then
      stage4_error "Fail to run RAxML-NG."
      stage4_cmd "HybSuite exits."
      stage4_blank "" 
      exit 1
    else 
      stage4_info "Successfully finish running RAxML-NG." 
    fi
##03 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/MI/RAxML-NG/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./RAxML-NG_${prefix}_MI.raxml.support -g "
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      if [[ $x -eq 1 ]]; then
        eval "og_params=\"\${og$x}\""
      else
        eval "og_params+=\",\${og$x}\""
      fi
    done
    cmd+="${og_params}"  
# Run pxrr
    stage4_info "Use phyx to reroot the tree (RAxML-NG)..."
    stage4_cmd "$cmd > ./RAxML-NG_rr_${prefix}_MI.tre ..."
    eval "$cmd > ./RAxML-NG_rr_${prefix}_MI.tre"
    if [ ! -s "./RAxML-NG_rr_${prefix}_MI.tre" ]; then
      echo "[HybSuite-WARNING]: Fail to reroot the tree: " 
      echo "                    ${o}/05-Concatenated_trees/MI/RAxML-NG/RAxML-NG_${prefix}_MI.tre." 
      stage4_info "Please check your alignments and trees produced by RAxML-NG." 
      stage4_blank ""
    else
      stage4_info "Successfully reroot the RAxML-NG tree for MI alignments."
      stage4_info "Successfully finish all the RAxML-NG pipeline for MI alignments..."
      stage4_cmd "Now moving on to the next step..."
      stage4_blank "" 
    fi
  fi
fi

#05-MO #######################
#(1) IQ-TREE
if [ "${run_iqtree}" = "TRUE" ]; then
  if [ "${MO}" = "TRUE" ]; then 
  ##01-1 Set the directory
    mkdir -p ${o}/05-Concatenated_trees/MO/IQTREE
    cd ${o}/05-Concatenated_trees/MO/IQTREE
    stage4_info "Running IQTREE for MO alignments..." 
  ##01-2 run IQTREE
    if [ "$(ls -A "${o}/05-Concatenated_trees/MO/IQTREE/")" ]; then
        rm ${o}/05-Concatenated_trees/MO/IQTREE/IQTREE*
    fi
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${MO_iqtree} -B ${iqtree_bb} --undo \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_MO \
          -p ${o}/03-Supermatrix/MO/partition.txt
          stage4_cmd "${MO_iqtree} -B ${iqtree_bb} --undo -T ${nt_iqtree} -pre IQTREE_${prefix}_MO -p ${o}/03-Supermatrix/MO/partition.txt" 
        else
          ${MO_iqtree} -B ${iqtree_bb} --undo \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_MO -g "${iqtree_constraint_tree}" \
          -p ${o}/03-Supermatrix/MO/partition.txt
          stage4_cmd "${MO_iqtree} -B ${iqtree_bb} --undo -T ${nt_iqtree} -pre IQTREE_${prefix}_MO -g ${iqtree_constraint_tree} -p ${o}/03-Supermatrix/MO/partition.txt" 
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${MO_iqtree} -B ${iqtree_bb} --undo \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_MO
          stage4_cmd "${MO_iqtree} -B ${iqtree_bb} --undo -T ${nt_iqtree} -pre IQTREE_${prefix}_MO" 
        else
          ${MO_iqtree} -B ${iqtree_bb} --undo \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_MO -g "${iqtree_constraint_tree}"
          stage4_cmd "${MO_iqtree} -B ${iqtree_bb} --undo -T ${nt_iqtree} -pre IQTREE_${prefix}_MO -g ${iqtree_constraint_tree}" 
        fi
      fi
    else
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta --undo \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/MO/partition.txt -m MFP \
          -pre IQTREE_${prefix}_MO
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta --undo --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/MO/partition.txt -m MFP -pre IQTREE_${prefix}_MO" 
        else
          iqtree -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta --undo \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/MO/partition.txt -m MFP \
          -pre IQTREE_${prefix}_MO -g "${iqtree_constraint_tree}"
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta --undo --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/MO/partition.txt -m MFP -pre IQTREE_${prefix}_MO -g ${iqtree_constraint_tree}" 
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta --undo \
          -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_MO
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta --undo -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_MO" 
        else
          iqtree -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta --undo \
          -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_MO -g "${iqtree_constraint_tree}"
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta --undo -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_MO -g ${iqtree_constraint_tree}" 
        fi
      fi
    fi
  ##01-3 Check if IQ-TREE was successfully ran.
    if [ ! -s "IQTREE_${prefix}_MO.treefile" ]; then
      stage4_error "fail to run IQ-TREE." 
      stage4_blank "                    HybSuite exits." 
      stage4_blank "" 
      exit 1
    else 
      stage4_info "Successfully finish running IQ-TREE." 
    fi
  ##01-4 reroot the tree via phyx
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./IQTREE_${prefix}_MO.treefile -g "
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      if [[ $x -eq 1 ]]; then
        eval "og_params=\"\${og$x}\""
      else
        eval "og_params+=\",\${og$x}\""
      fi
    done
    cmd+="${og_params}"
# Run pxrr
    stage4_info "Use phyx to reroot the tree (IQTREE)..." 
    stage4_cmd "$cmd > ./IQTREE_rr_${prefix}_MO.tre ..."
    eval "$cmd > ./IQTREE_rr_${prefix}_MO.tre"
    if [ ! -s "./IQTREE_rr_${prefix}_MO.tre" ]; then
      stage4_error "Fail to reroot the tree: " 
      stage4_blank "                    ${o}/05-Concatenated_trees/MO/IQTREE/IQTREE_${prefix}_MO.treefile." 
      stage4_info "Please check your alignments and trees produced by IQTREE." 
      stage4_blank ""
    else
      stage4_info "Successfully reroot the IQ-TREE tree." 
      stage4_info "Successfully finish all the IQ-TREE pipeline for MO alignments." 
      stage4_info "Now moving on to the next step..." 
      stage4_blank "" 
    fi
  fi
fi

#(2) RAxML
if [ "${run_raxml}" = "TRUE" ]; then
  if [ "${MO}" = "TRUE" ]; then
##02-1 Set the directory
    cd ${o}/03-Supermatrix/MO
    mkdir -p ${o}/05-Concatenated_trees/MO/RAxML
    stage4_info "Running RAxML for MO alignments..." 
##02-2 Run RAxML
    if [ "$(ls -A "${o}/05-Concatenated_trees/MO/RAxML/")" ]; then
        rm ${o}/05-Concatenated_trees/MO/RAxML/RAxML*
    fi
##02-2.1 If the user enables the Add Restriction tree feature (add the --tree-constraint < constraint tree path > parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      raxmlHPC="${MO_raxmlHPC_mtest} -f a -T ${nt_raxml} -p 12345 -x 67890 -# ${raxml_bb} -n ${prefix}_MO.tre -w ${o}/05-Concatenated_trees/MO/RAxML"
      if [ "${raxml_constraint_tree}" != "_____" ]; then
        ${raxmlHPC} -g ${raxml_constraint_tree}
        stage4_cmd "${raxmlHPC} -g ${raxml_constraint_tree}" 
      else
        ${raxmlHPC}
        stage4_cmd "${raxmlHPC}" 
      fi
    else
      if [ "${raxml_constraint_tree}" = "_____" ]; then
        raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta \
        -m ${raxml_m} -f a \
        -T ${nt_raxml} \
        -p 12345 \
        -x 67890 \
        -# 1000 \
        -n "${prefix}_MO.tre" -w ${o}/05-Concatenated_trees/MO/RAxML
        stage4_cmd "raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta -m ${raxml_m} -f a -T ${nt_raxml} -p 12345 -x 67890 -# 1000 -n ${prefix}_MO.tre -w ${o}/05-Concatenated_trees/MO/RAxML" 
      else
        raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta \
        -m ${raxml_m} -f a \
        -T ${nt_raxml} \
        -p 12345 \
        -x 67890 \
        -# 1000 \
        -n "${prefix}_MO.tre" -w ${o}/05-Concatenated_trees/MO/RAxML \
        -g ${raxml_constraint_tree}
        stage4_cmd "raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta -m ${raxml_m} -f a -x -T ${nt_raxml} -p 12345 -x 67890 -# 1000 -n ${prefix}_MO.tre -w ${o}/05-Concatenated_trees/MO/RAxML -g ${raxml_constraint_tree}" 
      fi
    fi
    if [ ! -s "${o}/05-Concatenated_trees/MO/RAxML/RAxML_bestTree.${prefix}_MO.tre" ]; then
      stage4_error "Fail to run RAxML." 
      stage4_blank "                    HybSuite exits." 
      stage4_blank "" 
      exit 1
    else 
      stage4_info "Successfully finish running RAxML." 
    fi
##02-3 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/MO/RAxML/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./RAxML_bipartitions.${prefix}_MO.tre -g "
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      if [[ $x -eq 1 ]]; then
        eval "og_params=\"\${og$x}\""
      else
        eval "og_params+=\",\${og$x}\""
      fi
    done
    cmd+="${og_params}"
# Run pxrr
    stage4_info "Use phyx to reroot the tree (RAxML)..." 
    eval "$cmd > ./RAxML_rr_${prefix}_MO.tre"
    stage4_cmd "$cmd > ./RAxML_rr_${prefix}_MO.tre ..."
# Check if the user ran phyx successfully
    if [ ! -s "./RAxML_rr_${prefix}_MO.tre" ]; then
      stage4_error "Fail to reroot the tree: " 
      stage4_blank "                    ${o}/05-Concatenated_trees/MO/RAxML/RAxML_bipartitions.${prefix}_MO.tre." 
      stage4_info "Please check your alignments and trees produced by RAxML." 
      stage4_blank ""
    else
      stage4_info "Successfully reroot the RAxML tree." 
      stage4_info "Successfully finish all the RAxML pipeline for MO alignments..." 
      stage4_info "Now moving on to the next step..."
      stage4_blank "" 
    fi
  fi
fi
#(3) RAxML-NG
if [ "${run_raxml_ng}" != "FALSE" ] && [ "${run_raxml_ng}" != "False" ]; then
  if [ "${MO}" = "TRUE" ]; then
##01 Set the directory
    mkdir -p ${o}/05-Concatenated_trees/MO/RAxML-NG
##02 Run RAxML-NG
    stage4_info "Running RAxML-NG for MO alignments..."  
##02.1 If the user sets the rng_force parameter to TRUE, the Ignore Thread warning feature is enabled (add the --force perf_threads parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ] && [ ! -s "${rng_constraint_tree}" ]; then
      raxml_ng="${MO_raxml_ng_mtest} --all --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/MO/RAxML-NG/RAxML-NG_${prefix}_MO --bs-trees ${rng_bs_trees}"
      if [ "${rng_force}" = "TRUE" ]; then
          ${raxml_ng} --force perf_threads
          stage4_cmd "${raxml_ng} --force perf_threads"
      else
          ${raxml_ng}
          stage4_cmd "${raxml_ng}"
      fi
    fi
    
    if [ "${run_modeltest_ng}" = "FALSE" ] && [ ! -s "${rng_constraint_tree}" ]; then
      if [ "${rng_force}" = "TRUE" ]; then
        raxml-ng --parse --msa ${o}/03-Supermatrix/MO/HybSuite_MO.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/MO/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/MO/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/MO/${prefix}_MO.fasta \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/MO/RAxML-NG/RAxML-NG_${prefix}_MO \
        --bs-trees ${rng_bs_trees} \
        --force perf_threads
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/MO/${prefix}_MO.fasta --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/MO/RAxML-NG/RAxML-NG_${prefix}_MO --bs-trees ${rng_bs_trees} --force perf_threads --partition ${o}/01-Supermatrix/03-Supermatrix/MO/partition.txt"
      else
        raxml-ng --parse --msa ${o}/03-Supermatrix/MO/HybSuite_MO.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/MO/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/MO/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/MO/${prefix}_MO.fasta \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/MO/RAxML-NG/RAxML-NG_${prefix}_MO \
        --bs-trees ${rng_bs_trees}
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/MO/${prefix}_MO.fasta --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/MO/RAxML-NG/RAxML-NG_${prefix}_MO --bs-trees ${rng_bs_trees}"
      fi
    fi

    if [ "${run_modeltest_ng}" = "TRUE" ] && [ -s "${rng_constraint_tree}" ]; then
      raxml_ng="${MO_raxml_ng_mtest} --all --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/MO/RAxML-NG/RAxML-NG_${prefix}_MO --bs-trees ${rng_bs_trees}"
      if [ "${rng_force}" = "TRUE" ]; then
          ${raxml_ng} --force perf_threads --tree-constraint ${rng_constraint_tree}
          stage4_cmd "${raxml_ng} --force perf_threads --tree-constraint ${rng_constraint_tree}"
      else
          ${raxml_ng} --tree-constraint ${rng_constraint_tree}
          stage4_cmd "${raxml_ng} --tree-constraint ${rng_constraint_tree}"
      fi
    fi
    
    if [ "${run_modeltest_ng}" = "FALSE" ] && [ -s "${rng_constraint_tree}" ]; then
      if [ "${rng_force}" = "TRUE" ]; then
        raxml-ng --parse --msa ${o}/03-Supermatrix/MO/HybSuite_MO.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/MO/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/MO/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/MO/${prefix}_MO.fasta \
        --tree-constraint ${rng_constraint_tree} \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/MO/RAxML-NG/RAxML-NG_${prefix}_MO \
        --bs-trees ${rng_bs_trees} \
        --force perf_threads
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/MO/${prefix}_MO.fasta --tree-constraint ${rng_constraint_tree} --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/MO/RAxML-NG/RAxML-NG_${prefix}_MO --bs-trees ${rng_bs_trees} --force perf_threads --partition ${o}/01-Supermatrix/03-Supermatrix/MO/partition.txt"
      else
        raxml-ng --parse --msa ${o}/03-Supermatrix/MO/HybSuite_MO.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/MO/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/MO/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/MO/${prefix}_MO.fasta \
        --tree-constraint ${rng_constraint_tree} \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/MO/RAxML-NG/RAxML-NG_${prefix}_MO \
        --bs-trees ${rng_bs_trees}
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/MO/${prefix}_MO.fasta --tree-constraint ${rng_constraint_tree} --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/MO/RAxML-NG/RAxML-NG_${prefix}_MO --bs-trees ${rng_bs_trees}"
      fi
    fi

##02.3 Check if the user ran RAxML-NG successfully
    if [ ! -s "${o}/05-Concatenated_trees/MO/RAxML-NG/RAxML-NG_${prefix}_MO.raxml.support" ]; then
      stage4_error "Fail to run RAxML-NG."
      stage4_cmd "HybSuite exits."
      stage4_blank "" 
      exit 1
    else 
      stage4_info "Successfully finish running RAxML-NG." 
    fi
##03 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/MO/RAxML-NG/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./RAxML-NG_${prefix}_MO.raxml.support -g "
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      if [[ $x -eq 1 ]]; then
        eval "og_params=\"\${og$x}\""
      else
        eval "og_params+=\",\${og$x}\""
      fi
    done
    cmd+="${og_params}"  
# Run pxrr
    stage4_info "Use phyx to reroot the tree (RAxML-NG)..."
    stage4_cmd "$cmd > ./RAxML-NG_rr_${prefix}_MO.tre ..."
    eval "$cmd > ./RAxML-NG_rr_${prefix}_MO.tre"
    if [ ! -s "./RAxML-NG_rr_${prefix}_MO.tre" ]; then
      echo "[HybSuite-WARNING]: Fail to reroot the tree: " 
      echo "                    ${o}/05-Concatenated_trees/MO/RAxML-NG/RAxML-NG_${prefix}_MO.tre." 
      stage4_info "Please check your alignments and trees produced by RAxML-NG." 
      stage4_blank ""
    else
      stage4_info "Successfully reroot the RAxML-NG tree for MO alignments."
      stage4_info "Successfully finish all the RAxML-NG pipeline for MO alignments..."
      stage4_cmd "Now moving on to the next step..."
      stage4_blank "" 
    fi
  fi
fi


#06-RT #######################
if [ "${RT}" = "TRUE" ]; then
  stage4_info "<=== RT alignments ===>"
fi
#(1) IQ-TREE
if [ "${run_iqtree}" = "TRUE" ]; then
  if [ "${RT}" = "TRUE" ]; then 
  ##01-1 Set the directory
    mkdir -p ${o}/05-Concatenated_trees/RT/IQTREE
    cd ${o}/05-Concatenated_trees/RT/IQTREE
    stage4_info "Running IQTREE for RT alignments..." 
  ##01-2 run IQTREE
    if [ "$(ls -A "${o}/05-Concatenated_trees/RT/IQTREE/")" ]; then
        rm ${o}/05-Concatenated_trees/RT/IQTREE/IQTREE*
    fi
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${RT_iqtree} -B ${iqtree_bb} --undo \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_RT \
          -p ${o}/03-Supermatrix/RT/partition.txt
          stage4_cmd "${RT_iqtree} -B ${iqtree_bb} --undo -T ${nt_iqtree} -pre IQTREE_${prefix}_RT -p ${o}/03-Supermatrix/RT/partition.txt" 
        else
          ${RT_iqtree} -B ${iqtree_bb} --undo \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_RT -g "${iqtree_constraint_tree}" \
          -p ${o}/03-Supermatrix/RT/partition.txt
          stage4_cmd "${RT_iqtree} -B ${iqtree_bb} --undo -T ${nt_iqtree} -pre IQTREE_${prefix}_RT -g ${iqtree_constraint_tree} -p ${o}/03-Supermatrix/RT/partition.txt" 
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${RT_iqtree} -B ${iqtree_bb} --undo \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_RT
          stage4_cmd "${RT_iqtree} -B ${iqtree_bb} --undo -T ${nt_iqtree} -pre IQTREE_${prefix}_RT" 
        else
          ${RT_iqtree} -B ${iqtree_bb} --undo \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_RT -g "${iqtree_constraint_tree}"
          stage4_cmd "${RT_iqtree} -B ${iqtree_bb} --undo -T ${nt_iqtree} -pre IQTREE_${prefix}_RT -g ${iqtree_constraint_tree}" 
        fi
      fi
    else
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta --undo \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/RT/partition.txt -m MFP \
          -pre IQTREE_${prefix}_RT
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta --undo --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/RT/partition.txt -m MFP -pre IQTREE_${prefix}_RT" 
        else
          iqtree -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta --undo \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/RT/partition.txt -m MFP \
          -pre IQTREE_${prefix}_RT -g "${iqtree_constraint_tree}"
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta --undo --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/RT/partition.txt -m MFP -pre IQTREE_${prefix}_RT -g ${iqtree_constraint_tree}" 
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta --undo \
          --seed 12345 -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_RT
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta --undo --seed 12345 -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_RT" 
        else
          iqtree -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta --undo \
          --seed 12345 -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_RT -g "${iqtree_constraint_tree}"
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta --undo --seed 12345 -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_RT -g ${iqtree_constraint_tree}" 
        fi
      fi
    fi
  ##01-3 Check if IQ-TREE was successfully ran.
    if [ ! -s "IQTREE_${prefix}_RT.treefile" ]; then
      stage4_error "fail to run IQ-TREE." 
      stage4_blank "                    HybSuite exits." 
      stage4_blank "" 
      exit 1
    else 
      stage4_info "Successfully finish running IQ-TREE." 
    fi
  ##01-4 reroot the tree via phyx
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./IQTREE_${prefix}_RT.treefile -g "
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      if [[ $x -eq 1 ]]; then
        eval "og_params=\"\${og$x}\""
      else
        eval "og_params+=\",\${og$x}\""
      fi
    done
    cmd+="${og_params}"
# Run pxrr
    stage4_info "Use phyx to reroot the tree (IQTREE)..." 
    stage4_cmd "$cmd > ./IQTREE_rr_${prefix}_RT.tre ..."
    eval "$cmd > ./IQTREE_rr_${prefix}_RT.tre"
    if [ ! -s "./IQTREE_rr_${prefix}_RT.tre" ]; then
      stage4_error "Fail to reroot the tree: " 
      stage4_blank "                    ${o}/05-Concatenated_trees/RT/IQTREE/IQTREE_${prefix}_RT.treefile." 
      stage4_info "Please check your alignments and trees produced by IQTREE." 
      stage4_blank ""
    else
      stage4_info "Successfully reroot the IQ-TREE tree." 
      stage4_info "Successfully finish all the IQ-TREE pipeline for RT alignments." 
      stage4_info "Now moving on to the next step..." 
      stage4_blank "" 
    fi
  fi
fi

#(2) RAxML
if [ "${run_raxml}" = "TRUE" ]; then
  if [ "${RT}" = "TRUE" ]; then
##02-1 Set the directory
    cd ${o}/03-Supermatrix/RT
    mkdir -p ${o}/05-Concatenated_trees/RT/RAxML
    stage4_info "Running RAxML for RT alignments..." 
##02-2 Run RAxML
    if [ "$(ls -A "${o}/05-Concatenated_trees/RT/RAxML/")" ]; then
        rm ${o}/05-Concatenated_trees/RT/RAxML/RAxML*
    fi
##02-2.1 If the user enables the Add Restriction tree feature (add the --tree-constraint < constraint tree path > parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      raxmlHPC="${RT_raxmlHPC_mtest} -f a -T ${nt_raxml} -p 12345 -x 67890 -# ${raxml_bb} -n ${prefix}_RT.tre -w ${o}/05-Concatenated_trees/RT/RAxML"
      if [ "${raxml_constraint_tree}" != "_____" ]; then
        ${raxmlHPC} -g ${raxml_constraint_tree}
        stage4_cmd "${raxmlHPC} -g ${raxml_constraint_tree}" 
      else
        ${raxmlHPC}
        stage4_cmd "${raxmlHPC}" 
      fi
    else
      if [ "${raxml_constraint_tree}" = "_____" ]; then
        raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta \
        -m ${raxml_m} -f a \
        -T ${nt_raxml} \
        -p 12345 \
        -x 67890 \
        -# 1000 \
        -n "${prefix}_RT.tre" -w ${o}/05-Concatenated_trees/RT/RAxML
        stage4_cmd "raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta -m ${raxml_m} -f a -x -T ${nt_raxml} -p 12345 -x 67890 -# 1000 -n ${prefix}_RT.tre -w ${o}/05-Concatenated_trees/RT/RAxML" 
      else
        raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta \
        -m ${raxml_m} -f a \
        -T ${nt_raxml} \
        -p 12345 \
        -x 67890 \
        -# 1000 \
        -n "${prefix}_RT.tre" -w ${o}/05-Concatenated_trees/RT/RAxML \
        -g ${raxml_constraint_tree}
        stage4_cmd "raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta -m ${raxml_m} -f a -x -T ${nt_raxml} -p 12345 -x 67890 -# 1000 -n ${prefix}_RT.tre -w ${o}/05-Concatenated_trees/RT/RAxML -g ${raxml_constraint_tree}" 
      fi
    fi
    if [ ! -s "${o}/05-Concatenated_trees/RT/RAxML/RAxML_bestTree.${prefix}_RT.tre" ]; then
      stage4_error "Fail to run RAxML." 
      stage4_blank "                    HybSuite exits." 
      stage4_blank "" 
      exit 1
    else 
      stage4_info "Successfully finish running RAxML." 
    fi
##02-3 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/RT/RAxML/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./RAxML_bipartitions.${prefix}_RT.tre -g "
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      if [[ $x -eq 1 ]]; then
        eval "og_params=\"\${og$x}\""
      else
        eval "og_params+=\",\${og$x}\""
      fi
    done
    cmd+="${og_params}"
# Run pxrr
    stage4_info "Use phyx to reroot the tree (RAxML)..." 
    eval "$cmd > ./RAxML_rr_${prefix}_RT.tre"
    stage4_cmd "$cmd > ./RAxML_rr_${prefix}_RT.tre ..."
# Check if the user ran phyx successfully
    if [ ! -s "./RAxML_rr_${prefix}_RT.tre" ]; then
      stage4_error "Fail to reroot the tree: " 
      stage4_blank "                    ${o}/05-Concatenated_trees/RT/RAxML/RAxML_bipartitions.${prefix}_RT.tre." 
      stage4_info "Please check your alignments and trees produced by RAxML." 
      stage4_blank ""
    else
      stage4_info "Successfully reroot the RAxML tree." 
      stage4_info "Successfully finish all the RAxML pipeline for RT alignments..." 
      stage4_info "Now moving on to the next step..."
      stage4_blank "" 
    fi
  fi
fi

#(3) RAxML-NG
if [ "${run_raxml_ng}" != "FALSE" ] && [ "${run_raxml_ng}" != "False" ]; then
  if [ "${RT}" = "TRUE" ]; then
##01 Set the directory
    mkdir -p ${o}/05-Concatenated_trees/RT/RAxML-NG
##02 Run RAxML-NG
    stage4_info "Running RAxML-NG for RT alignments..."  
##02.1 If the user sets the rng_force parameter to TRUE, the Ignore Thread warning feature is enabled (add the --force perf_threads parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ] && [ ! -s "${rng_constraint_tree}" ]; then
      raxml_ng="${RT_raxml_ng_mtest} --all --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/RT/RAxML-NG/RAxML-NG_${prefix}_RT --bs-trees ${rng_bs_trees}"
      if [ "${rng_force}" = "TRUE" ]; then
          ${raxml_ng} --force perf_threads
          stage4_cmd "${raxml_ng} --force perf_threads"
      else
          ${raxml_ng}
          stage4_cmd "${raxml_ng}"
      fi
    fi
    
    if [ "${run_modeltest_ng}" = "FALSE" ] && [ ! -s "${rng_constraint_tree}" ]; then
      if [ "${rng_force}" = "TRUE" ]; then
        raxml-ng --parse --msa ${o}/03-Supermatrix/RT/HybSuite_RT.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/RT/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/RT/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/RT/${prefix}_RT.fasta \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/RT/RAxML-NG/RAxML-NG_${prefix}_RT \
        --bs-trees ${rng_bs_trees} \
        --force perf_threads
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/RT/${prefix}_RT.fasta --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/RT/RAxML-NG/RAxML-NG_${prefix}_RT --bs-trees ${rng_bs_trees} --force perf_threads --partition ${o}/01-Supermatrix/03-Supermatrix/RT/partition.txt"
      else
        raxml-ng --parse --msa ${o}/03-Supermatrix/RT/HybSuite_RT.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/RT/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/RT/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/RT/${prefix}_RT.fasta \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/RT/RAxML-NG/RAxML-NG_${prefix}_RT \
        --bs-trees ${rng_bs_trees}
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/RT/${prefix}_RT.fasta --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/RT/RAxML-NG/RAxML-NG_${prefix}_RT --bs-trees ${rng_bs_trees}"
      fi
    fi

    if [ "${run_modeltest_ng}" = "TRUE" ] && [ -s "${rng_constraint_tree}" ]; then
      raxml_ng="${RT_raxml_ng_mtest} --all --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/RT/RAxML-NG/RAxML-NG_${prefix}_RT --bs-trees ${rng_bs_trees}"
      if [ "${rng_force}" = "TRUE" ]; then
          ${raxml_ng} --force perf_threads --tree-constraint ${rng_constraint_tree}
          stage4_cmd "${raxml_ng} --force perf_threads --tree-constraint ${rng_constraint_tree}"
      else
          ${raxml_ng} --tree-constraint ${rng_constraint_tree}
          stage4_cmd "${raxml_ng} --tree-constraint ${rng_constraint_tree}"
      fi
    fi
    
    if [ "${run_modeltest_ng}" = "FALSE" ] && [ -s "${rng_constraint_tree}" ]; then
      if [ "${rng_force}" = "TRUE" ]; then
        raxml-ng --parse --msa ${o}/03-Supermatrix/RT/HybSuite_RT.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/RT/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/RT/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/RT/${prefix}_RT.fasta \
        --tree-constraint ${rng_constraint_tree} \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/RT/RAxML-NG/RAxML-NG_${prefix}_RT \
        --bs-trees ${rng_bs_trees} \
        --force perf_threads
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/RT/${prefix}_RT.fasta --tree-constraint ${rng_constraint_tree} --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/RT/RAxML-NG/RAxML-NG_${prefix}_RT --bs-trees ${rng_bs_trees} --force perf_threads --partition ${o}/01-Supermatrix/03-Supermatrix/RT/partition.txt"
      else
        raxml-ng --parse --msa ${o}/03-Supermatrix/RT/HybSuite_RT.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/RT/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/RT/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/RT/${prefix}_RT.fasta \
        --tree-constraint ${rng_constraint_tree} \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/RT/RAxML-NG/RAxML-NG_${prefix}_RT \
        --bs-trees ${rng_bs_trees}
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/RT/${prefix}_RT.fasta --tree-constraint ${rng_constraint_tree} --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/RT/RAxML-NG/RAxML-NG_${prefix}_RT --bs-trees ${rng_bs_trees}"
      fi
    fi

##02.3 Check if the user ran RAxML-NG successfully
    if [ ! -s "${o}/05-Concatenated_trees/RT/RAxML-NG/RAxML-NG_${prefix}_RT.raxml.support" ]; then
      stage4_error "Fail to run RAxML-NG."
      stage4_cmd "HybSuite exits."
      stage4_blank "" 
      exit 1
    else 
      stage4_info "Successfully finish running RAxML-NG." 
    fi
##03 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/RT/RAxML-NG/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./RAxML-NG_${prefix}_RT.raxml.support -g "
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      if [[ $x -eq 1 ]]; then
        eval "og_params=\"\${og$x}\""
      else
        eval "og_params+=\",\${og$x}\""
      fi
    done
    cmd+="${og_params}"  
# Run pxrr
    stage4_info "Use phyx to reroot the tree (RAxML-NG)..."
    stage4_cmd "$cmd > ./RAxML-NG_rr_${prefix}_RT.tre ..."
    eval "$cmd > ./RAxML-NG_rr_${prefix}_RT.tre"
    if [ ! -s "./RAxML-NG_rr_${prefix}_RT.tre" ]; then
      echo "[HybSuite-WARNING]: Fail to reroot the tree: " 
      echo "                    ${o}/05-Concatenated_trees/RT/RAxML-NG/RAxML-NG_${prefix}_RT.tre." 
      stage4_info "It's OK because you use RT method, leading to the removal of outgroups." 
      stage4_blank ""
    else
      stage4_info "Successfully reroot the RAxML-NG tree for RT alignments."
      stage4_info "Successfully finish all the RAxML-NG pipeline for RT alignments..."
      stage4_cmd "Now moving on to the next step..."
      stage4_blank "" 
    fi
  fi
fi



#07-1to1 #######################
if [ "${one_to_one}" = "TRUE" ]; then
  stage4_info "<=== 1to1 alignments ===>"
fi
#(1) IQ-TREE
if [ "${run_iqtree}" = "TRUE" ]; then
  if [ "${one_to_one}" = "TRUE" ]; then 
  ##01-1 Set the directory
    mkdir -p ${o}/05-Concatenated_trees/1to1/IQTREE
    cd ${o}/05-Concatenated_trees/1to1/IQTREE
    stage4_info "Running IQTREE for 1to1 alignments..." 
  ##01-2 run IQ-TREE
    if [ "$(ls -A "${o}/05-Concatenated_trees/1to1/IQTREE/")" ]; then
        rm ${o}/05-Concatenated_trees/1to1/IQTREE/IQTREE*
    fi
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${one_to_one_iqtree} -B ${iqtree_bb} --undo \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_1to1 \
          -p ${o}/03-Supermatrix/1to1/partition.txt
          stage4_cmd "${one_to_one_iqtree} -B ${iqtree_bb} --undo -T ${nt_iqtree} -pre IQTREE_${prefix}_1to1 -p ${o}/03-Supermatrix/1to1/partition.txt" 
        else
          ${one_to_one_iqtree} -B ${iqtree_bb} --undo \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_1to1 -g "${iqtree_constraint_tree}" \
          -p ${o}/03-Supermatrix/1to1/partition.txt
          stage4_cmd "${one_to_one_iqtree} -B ${iqtree_bb} --undo -T ${nt_iqtree} -pre IQTREE_${prefix}_1to1 -g ${iqtree_constraint_tree} -p ${o}/03-Supermatrix/1to1/partition.txt" 
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${one_to_one_iqtree} -B ${iqtree_bb} --undo \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_1to1
          stage4_cmd "${one_to_one_iqtree} -B ${iqtree_bb} --undo -T ${nt_iqtree} -pre IQTREE_${prefix}_1to1" 
        else
          ${one_to_one_iqtree} -B ${iqtree_bb} --undo \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_1to1 -g "${iqtree_constraint_tree}"
          stage4_cmd "${one_to_one_iqtree} -B ${iqtree_bb} --undo -T ${nt_iqtree} -pre IQTREE_${prefix}_1to1 -g ${iqtree_constraint_tree}" 
        fi
      fi
    else
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta --undo \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/1to1/partition.txt -m MFP \
          -pre IQTREE_${prefix}_1to1
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta --undo --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/1to1/partition.txt -m MFP -pre IQTREE_${prefix}_1to1" 
        else
          iqtree -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta --undo \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/1to1/partition.txt -m MFP \
          -pre IQTREE_${prefix}_1to1 -g "${iqtree_constraint_tree}"
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta --undo --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/1to1/partition.txt -m MFP -pre IQTREE_${prefix}_1to1 -g ${iqtree_constraint_tree}" 
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta --undo \
          -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_1to1
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta --undo -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_1to1" 
        else
          iqtree -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta --undo \
          -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_1to1 -g "${iqtree_constraint_tree}"
          stage4_cmd "iqtree -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta --undo -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_1to1 -g ${iqtree_constraint_tree}" 
        fi
      fi
    fi
  ##01-3 Check if IQ-TREE was successfully ran.
    if [ ! -s "IQTREE_${prefix}_1to1.treefile" ]; then
      stage4_error "fail to run IQ-TREE." 
      stage4_blank "                    HybSuite exits." 
      stage4_blank "" 
      exit 1
    else 
      stage4_info "Successfully finish running IQ-TREE." 
    fi
  ##01-4 reroot the tree via phyx
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./IQTREE_${prefix}_1to1.treefile -g "
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      if [[ $x -eq 1 ]]; then
        eval "og_params=\"\${og$x}\""
      else
        eval "og_params+=\",\${og$x}\""
      fi
    done
    cmd+="${og_params}"
# Run pxrr
    stage4_info "Use phyx to reroot the tree (IQTREE)..." 
    stage4_cmd "$cmd > ./IQTREE_rr_${prefix}_1to1.tre ..."
    eval "$cmd > ./IQTREE_rr_${prefix}_1to1.tre"
    if [ ! -s "./IQTREE_rr_${prefix}_1to1.tre" ]; then
      stage4_error "Fail to reroot the tree: " 
      stage4_blank "                    ${o}/05-Concatenated_trees/1to1/IQTREE/IQTREE_${prefix}_1to1.treefile." 
      stage4_info "Please check your alignments and trees produced by IQTREE." 
      stage4_blank ""
    else
      stage4_info "Successfully reroot the IQ-TREE tree." 
      stage4_info "Successfully finish all the IQ-TREE pipeline for 1to1 alignments." 
      stage4_info "Now moving on to the next step..." 
      stage4_blank "" 
    fi
  fi
fi

#(2) RAxML
if [ "${run_raxml}" = "TRUE" ]; then
  if [ "${one_to_one}" = "TRUE" ]; then
##02-1 Set the directory
    cd ${o}/03-Supermatrix/1to1
    mkdir -p ${o}/05-Concatenated_trees/1to1/RAxML
    stage4_info "Running RAxML for 1to1 alignments..." 
##02-2 Run RAxML
    if [ "$(ls -A "${o}/05-Concatenated_trees/1to1/RAxML/")" ]; then
        rm ${o}/05-Concatenated_trees/1to1/RAxML/RAxML*
    fi
##02-2.1 If the user enables the Add Restriction tree feature (add the --tree-constraint < constraint tree path > parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      raxmlHPC="${one_to_one_raxmlHPC_mtest} -f a -T ${nt_raxml} -p 12345 -x 67890 -# ${raxml_bb} -n ${prefix}_1to1.tre -w ${o}/05-Concatenated_trees/1to1/RAxML"
      if [ "${raxml_constraint_tree}" != "_____" ]; then
        ${raxmlHPC} -g ${raxml_constraint_tree}
        stage4_cmd "${raxmlHPC} -g ${raxml_constraint_tree}" 
      else
        ${raxmlHPC}
        stage4_cmd "${raxmlHPC}" 
      fi
    else
      if [ "${raxml_constraint_tree}" = "_____" ]; then
        raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta \
        -m ${raxml_m} -f a \
        -T ${nt_raxml} \
        -p 12345 \
        -x 67890 \
        -# 1000 \
        -n "${prefix}_1to1.tre" -w ${o}/05-Concatenated_trees/1to1/RAxML
        stage4_cmd "raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta -m ${raxml_m} -f a -x -T ${nt_raxml} -p 12345 -x 67890 -# 1000 -n ${prefix}_1to1.tre -w ${o}/05-Concatenated_trees/1to1/RAxML" 
      else
        raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta \
        -m ${raxml_m} -f a \
        -T ${nt_raxml} \
        -p 12345 \
        -x 67890 \
        -# 1000 \
        -n "${prefix}_1to1.tre" -w ${o}/05-Concatenated_trees/1to1/RAxML \
        -g ${raxml_constraint_tree}
        stage4_cmd "raxmlHPC-PTHREADS -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta -m ${raxml_m} -f a -x -T ${nt_raxml} -p 12345 -x 67890 -# 1000 -n ${prefix}_1to1.tre -w ${o}/05-Concatenated_trees/1to1/RAxML -g ${raxml_constraint_tree}" 
      fi
    fi
    if [ ! -s "${o}/05-Concatenated_trees/1to1/RAxML/RAxML_bestTree.${prefix}_1to1.tre" ]; then
      stage4_error "Fail to run RAxML." 
      stage4_blank "                    HybSuite exits." 
      stage4_blank "" 
      exit 1
    else 
      stage4_info "Successfully finish running RAxML." 
    fi
##02-3 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/1to1/RAxML/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./RAxML_bipartitions.${prefix}_1to1.tre -g "
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      if [[ $x -eq 1 ]]; then
        eval "og_params=\"\${og$x}\""
      else
        eval "og_params+=\",\${og$x}\""
      fi
    done
    cmd+="${og_params}"
# Run pxrr
    stage4_info "Use phyx to reroot the tree (RAxML)..." 
    eval "$cmd > ./RAxML_rr_${prefix}_1to1.tre"
    stage4_cmd "$cmd > ./RAxML_rr_${prefix}_1to1.tre ..."
# Check if the user ran phyx successfully
    if [ ! -s "./RAxML_rr_${prefix}_1to1.tre" ]; then
      stage4_error "Fail to reroot the tree: " 
      stage4_blank "                    ${o}/05-Concatenated_trees/1to1/RAxML/RAxML_bipartitions.${prefix}_1to1.tre." 
      stage4_info "Please check your alignments and trees produced by RAxML." 
      stage4_blank ""
    else
      stage4_info "Successfully reroot the RAxML tree." 
      stage4_info "Successfully finish all the RAxML pipeline for 1to1 alignments..." 
      stage4_info "Now moving on to the next step..."
      stage4_blank "" 
    fi
  fi
fi

#(3) RAxML-NG
if [ "${run_raxml_ng}" != "FALSE" ] && [ "${run_raxml_ng}" != "False" ]; then
  if [ "${one_to_one}" = "TRUE" ]; then
##01 Set the directory
    mkdir -p ${o}/05-Concatenated_trees/1to1/RAxML-NG
##02 Run RAxML-NG
    stage4_info "Running RAxML-NG for 1to1 alignments..."  
##02.1 If the user sets the rng_force parameter to TRUE, the Ignore Thread warning feature is enabled (add the --force perf_threads parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ] && [ ! -s "${rng_constraint_tree}" ]; then
      raxml_ng="${one_to_one_raxml_ng_mtest} --all --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/1to1/RAxML-NG/RAxML-NG_${prefix}_1to1 --bs-trees ${rng_bs_trees}"
      if [ "${rng_force}" = "TRUE" ]; then
          ${raxml_ng} --force perf_threads
          stage4_cmd "${raxml_ng} --force perf_threads"
      else
          ${raxml_ng}
          stage4_cmd "${raxml_ng}"
      fi
    fi
    
    if [ "${run_modeltest_ng}" = "FALSE" ] && [ ! -s "${rng_constraint_tree}" ]; then
      if [ "${rng_force}" = "TRUE" ]; then
        raxml-ng --parse --msa ${o}/03-Supermatrix/1to1/HybSuite_1to1.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/1to1/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/1to1/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/1to1/RAxML-NG/RAxML-NG_${prefix}_1to1 \
        --bs-trees ${rng_bs_trees} \
        --force perf_threads
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/1to1/RAxML-NG/RAxML-NG_${prefix}_1to1 --bs-trees ${rng_bs_trees} --force perf_threads --partition ${o}/01-Supermatrix/03-Supermatrix/1to1/partition.txt"
      else
        raxml-ng --parse --msa ${o}/03-Supermatrix/1to1/HybSuite_1to1.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/1to1/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/1to1/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/1to1/RAxML-NG/RAxML-NG_${prefix}_1to1 \
        --bs-trees ${rng_bs_trees}
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/1to1/RAxML-NG/RAxML-NG_${prefix}_1to1 --bs-trees ${rng_bs_trees}"
      fi
    fi

    if [ "${run_modeltest_ng}" = "TRUE" ] && [ -s "${rng_constraint_tree}" ]; then
      raxml_ng="${one_to_one_raxml_ng_mtest} --all --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/1to1/RAxML-NG/RAxML-NG_${prefix}_1to1 --bs-trees ${rng_bs_trees}"
      if [ "${rng_force}" = "TRUE" ]; then
          ${raxml_ng} --force perf_threads --tree-constraint ${rng_constraint_tree}
          stage4_cmd "${raxml_ng} --force perf_threads --tree-constraint ${rng_constraint_tree}"
      else
          ${raxml_ng} --tree-constraint ${rng_constraint_tree}
          stage4_cmd "${raxml_ng} --tree-constraint ${rng_constraint_tree}"
      fi
    fi
    
    if [ "${run_modeltest_ng}" = "FALSE" ] && [ -s "${rng_constraint_tree}" ]; then
      if [ "${rng_force}" = "TRUE" ]; then
        raxml-ng --parse --msa ${o}/03-Supermatrix/1to1/HybSuite_1to1.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/1to1/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/1to1/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta \
        --tree-constraint ${rng_constraint_tree} \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/1to1/RAxML-NG/RAxML-NG_${prefix}_1to1 \
        --bs-trees ${rng_bs_trees} \
        --force perf_threads
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta --tree-constraint ${rng_constraint_tree} --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/1to1/RAxML-NG/RAxML-NG_${prefix}_1to1 --bs-trees ${rng_bs_trees} --force perf_threads --partition ${o}/01-Supermatrix/03-Supermatrix/1to1/partition.txt"
      else
        raxml-ng --parse --msa ${o}/03-Supermatrix/1to1/HybSuite_1to1.fasta \
        --model GTR+G \
        --prefix ${o}/05-Concatenated_trees/1to1/RAxML-NG/raxml_ng_test --threads "${nt_raxml}"
        Model=$(grep "Model:" ${o}/05-Concatenated_trees/1to1/RAxML-NG/raxml_ng_test.raxml.log|cut -f2 -d' ')
        raxml-ng --all --msa ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta \
        --tree-constraint ${rng_constraint_tree} \
        --model ${Model} \
        --threads ${nt_raxml_ng} \
        --prefix ${o}/05-Concatenated_trees/1to1/RAxML-NG/RAxML-NG_${prefix}_1to1 \
        --bs-trees ${rng_bs_trees}
        stage4_cmd "raxml-ng --all --msa ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta --tree-constraint ${rng_constraint_tree} --model ${Model} --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/1to1/RAxML-NG/RAxML-NG_${prefix}_1to1 --bs-trees ${rng_bs_trees}"
      fi
    fi

##02.3 Check if the user ran RAxML-NG successfully
    if [ ! -s "${o}/05-Concatenated_trees/1to1/RAxML-NG/RAxML-NG_${prefix}_1to1.raxml.support" ]; then
      stage4_error "Fail to run RAxML-NG."
      stage4_cmd "HybSuite exits."
      stage4_blank "" 
      exit 1
    else 
      stage4_info "Successfully finish running RAxML-NG." 
    fi
##03 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/1to1/RAxML-NG/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="pxrr -s -t ./RAxML-NG_${prefix}_1to1.raxml.support -g "
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      if [[ $x -eq 1 ]]; then
        eval "og_params=\"\${og$x}\""
      else
        eval "og_params+=\",\${og$x}\""
      fi
    done
    cmd+="${og_params}"  
# Run pxrr
    stage4_info "Use phyx to reroot the tree (RAxML-NG)..."
    stage4_cmd "$cmd > ./RAxML-NG_rr_${prefix}_1to1.tre ..."
    eval "$cmd > ./RAxML-NG_rr_${prefix}_1to1.tre"
    if [ ! -s "./RAxML-NG_rr_${prefix}_1to1.tre" ]; then
      echo "[HybSuite-WARNING]: Fail to reroot the tree: " 
      echo "                    ${o}/05-Concatenated_trees/1to1/RAxML-NG/RAxML-NG_${prefix}_1to1.tre." 
      stage4_info "Please check your alignments and trees produced by RAxML-NG." 
      stage4_blank ""
    else
      stage4_info "Successfully reroot the RAxML-NG tree for 1to1 alignments."
      stage4_info "Successfully finish all the RAxML-NG pipeline for 1to1 alignments..."
      stage4_cmd "Now moving on to the next step..."
      stage4_blank "" 
    fi
  fi
fi

#3. Construct coalescent-based trees (ASTRAL or wASTRAL)
if [ "${run_astral}" = "TRUE" ] || [ "${run_wastral}" = "TRUE" ]; then
  stage4_info "<<==== Constructing coalescent-based trees (ASTRAL or wASTRAL) ====>>"
fi
#01-HRS #############################
if ([ "${run_astral}" = "TRUE" ] || [ "${run_wastral}" = "TRUE" ]) && [ "${HRS}" = "TRUE" ]; then
  stage4_info "<=== HRS alignments ===>"
  mkdir -p ${o}/06-Coalescent-based_trees/HRS/01-gene_trees
  > ${o}/06-Coalescent-based_trees/HRS/gene_with_mt_5_seqs.txt
  > ${o}/06-Coalescent-based_trees/HRS/gene_with_lt_5_seqs.txt
  cd ${o}/02-Alignments/HRS/03_alignments_trimal
  for Gene in *.F*A; do 
    if [ $(grep -c '^>' "${Gene}") -ge 5 ]; then
    echo "$Gene" >> ${o}/06-Coalescent-based_trees/HRS/gene_with_mt_5_seqs.txt
    else
    echo "$Gene" >> ${o}/06-Coalescent-based_trees/HRS/gene_with_lt_5_seqs.txt
    fi
  done
  sed -i 's/\.FNA//g' ${o}/06-Coalescent-based_trees/HRS/gene_with_mt_5_seqs.txt
  sed -i 's/\.FNA//g' ${o}/06-Coalescent-based_trees/HRS/gene_with_lt_5_seqs.txt

  ###################################
  #01：Construct gene trees via RAxML
  ###################################
  stage4_info "ASTRAL/wASTRAL Step1: constructing gene trees via RAxML"
  while IFS= read -r Genename || [[ -n $Genename ]]; do
    mkdir -p "${o}/06-Coalescent-based_trees/HRS/01-gene_trees/${Genename}"
    if [ -s "${o}/06-Coalescent-based_trees/HRS/01-gene_trees/${Genename}/RAxML_bestTree.${Genename}.tre" ] && [ "${run_astral_step1_again}" = "FALSE" ]; then
    	stag4_info "Skip constructing single-gene tree for gene ${Genename}."
    else
      if [ -s "${o}/06-Coalescent-based_trees/HRS/01-gene_trees/${Genename}/RAxML_info.${Genename}.tre" ]; then
        rm ${o}/06-Coalescent-based_trees/HRS/01-gene_trees/${Genename}/*
      fi
      raxmlHPC-PTHREADS -T "${nt_raxml}" -f a \
    	-s ${o}/02-Alignments/HRS/03_alignments_trimal/${Genename}.FNA \
    	-k -x "$RANDOM" \
    	-m GTRGAMMA \
    	-p "$RANDOM" \
    	-n "${Genename}.tre" \
    	-w ${o}/06-Coalescent-based_trees/HRS/01-gene_trees/${Genename}/ \
    	-N 100
      stage4_cmd "raxmlHPC -f a -T ${nt_astral} -s ${o}/02-Alignments/HRS/03_alignments_trimal/${Genename}.FNA -k -x $RANDOM -m GTRGAMMA -p $RANDOM -n ${Genename}.tre -w ${o}/06-Coalescent-based_trees/HRS/01-gene_trees/${Genename} -N 100"
      if [ ! -s "${o}/06-Coalescent-based_trees/HRS/01-gene_trees/${Genename}/RAxML_bestTree.${Genename}.tre" ]; then
        stage4_error "Fail to run single gene tree for gene ${Genename}."
      else
        stage4_info "Finish constructing single gene tree for gene ${Genename}."
      fi
    fi
  done < ${o}/06-Coalescent-based_trees/HRS/gene_with_mt_5_seqs.txt
  stage4_info "ASTRAL/wASTRAL step1 has been finished, now moving on to the ASTRAL/wASTRAL step2..."

  #############################################
  #02：Reroot the gene trees via mad(R) or phyx
  #############################################
  stage4_blank ""
  stage4_info "ASTRAL/wASTRAL Step2: Reroot single-gene trees via mad(R) and phyx"
  mkdir -p "${o}/06-Coalescent-based_trees/HRS/02-rerooted_gene_trees"
  rm ${o}/06-Coalescent-based_trees/HRS/02-rerooted_gene_trees/*_rr.tre > /dev/null 2>&1
  > ${o}/06-Coalescent-based_trees/HRS/Final_ASTRAL_gene_list.txt
  while IFS= read -r Genename || [[ -n $Genename ]]; do
  if [ -s "${o}/06-Coalescent-based_trees/HRS/02-rerooted_gene_trees/${Genename}_rr.tre" ] && [ "${run_astral_step2}" = "FALSE" ]; then
    stage4_info "Skip using phyx or mad to construct single-gene trees."
  else
    stage4_info "Run Reroot_genetree_phyx_mad.R..."
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="Rscript ${script_dir}/Reroot_genetree_phyx_mad.R ${Genename} ${o}/06-Coalescent-based_trees/HRS"
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      eval "og_params=\" \${og$x}\""
    done
    cmd+="${og_params}"
    ${cmd}
    stage4_cmd "${cmd}"
    if [ ! -s "${o}/06-Coalescent-based_trees/HRS/02-rerooted_gene_trees/${Genename}_rr.tre" ]; then
      stage4_error "Fail to reroot single-gene tree for gene ${Genename}."
      stage4_blank ""
    else
      echo ${Genename} >> "${o}/06-Coalescent-based_trees/HRS/Final_ASTRAL_gene_list.txt"
      stage4_info "Successfully rerooting single-gene tree for gene ${Genename}."
      stage4_blank ""
    fi
  fi
  done < ${o}/06-Coalescent-based_trees/HRS/gene_with_mt_5_seqs.txt
  stage4_info "ASTRAL/wASTRAL step2 has been finished, now moving on to the ASTRAL/wASTRAL step3..."

  #03：Merge all tree files
  stage4_blank ""
  stage4_info "ASTRAL/wASTRAL Step3: Merge all tree files"
  mkdir -p ${o}/06-Coalescent-based_trees/HRS/03-combined_gene_trees
  > ${o}/06-Coalescent-based_trees/HRS/03-combined_gene_trees/${prefix}_HRS_combined.tre
  cat ${o}/06-Coalescent-based_trees/HRS/02-rerooted_gene_trees/*_rr.tre >> ${o}/06-Coalescent-based_trees/HRS/03-combined_gene_trees/${prefix}_HRS_combined.tre
  cd "${o}/06-Coalescent-based_trees/HRS/03-combined_gene_trees"
  stage4_info "ASTRAL/wASTRAL step3 has been finished, now moving on to the ASTRAL/wASTRAL step4..."
  
  ##################################
  #04：Run ASTRAL-Ⅲ or /and wASTRAL
  ##################################
  # ASTRAL ##################
  if [ "${run_astral}" = "TRUE" ]; then
    stage4_blank ""
    stage4_info "ASTRAL/wASTRAL Step4: Run ASTRAL-Ⅲ"
    mkdir -p ${o}/06-Coalescent-based_trees/HRS/04-ASTRAL_final_trees
    java -jar ${script_dir}/../dependencies/ASTRAL-master/Astral/astral.5.7.8.jar \
    -i ${o}/06-Coalescent-based_trees/HRS/03-combined_gene_trees/${prefix}_HRS_combined.tre \
    -o ${o}/06-Coalescent-based_trees/HRS/04-ASTRAL_final_trees/ASTRAL_${prefix}_HRS.tre 2> ${o}/00-logs_and_reports/logs/ASTRAL_${prefix}_HRS.log
    stage4_cmd "java -jar ${script_dir}/../dependencies/ASTRAL-master/Astral/astral.5.7.8.jar -i   -i ${o}/06-Coalescent-based_trees/HRS/03-combined_gene_trees/${prefix}_HRS_combined.tre -o ${o}/06-Coalescent-based_trees/HRS/04-ASTRAL_final_trees/ASTRAL_${prefix}_HRS.tre 2> ${o}/00-logs_and_reports/logs/${prefix}_HRS_ASTRAL.log"
    if [ -s "${o}/06-Coalescent-based_trees/HRS/04-ASTRAL_final_trees/ASTRAL_${prefix}_HRS.tre" ]; then
      stage4_info "Succeed to run ASTRAL-Ⅲ."
    else
      stage4_error "Fail to run ASTRAL-Ⅲ."
      stage4_blank ""
    fi
  fi
  # wASTRAL #################
  if [ "${run_wastral}" = "TRUE" ]; then
    stage4_blank ""
    stage4_info "ASTRAL/wASTRAL Step4: Run wASTRAL"
    mkdir -p ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees
    cd ${wastral_dir}
    # if the number of species is less than 2000, run wastral
    if [ $(wc -l < ${o}/06-Coalescent-based_trees/HRS/Final_ASTRAL_gene_list.txt) -lt 2000 ]; then
      bin/wastral --mode ${wastral_mode} -t ${nt_wastral} \
      -r ${wastral_R} -s ${wastral_S} \
      -o ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/wASTRAL_${prefix}_HRS.tre \
      ${o}/06-Coalescent-based_trees/HRS/03-combined_gene_trees/${prefix}_HRS_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_HRS.log
      stage4_cmd "bin/wastral --mode ${wastral_mode} -t ${nt_wastral} -r ${wastral_R} -s ${wastral_S} -o ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/wASTRAL_${prefix}_HRS.tre ${o}/06-Coalescent-based_trees/HRS/03-combined_gene_trees/${prefix}_HRS_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_HRS.log"
      bin/wastral -S ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/wASTRAL_${prefix}_HRS.tre > ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_HRS.tre
      stage4_cmd "bin/wastral -S ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/wASTRAL_${prefix}_HRS.tre > ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_HRS.tre"
    # if the number of species is more than 2000, run wastral
    else
      bin/wastral_precise --mode ${wastral_mode} -t ${nt_wastral} \
      -r ${wastral_R} -s ${wastral_S} \
      -o ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/wASTRAL_${prefix}_HRS.tre \
      ${o}/06-Coalescent-based_trees/HRS/03-combined_gene_trees/${prefix}_HRS_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_HRS.log
      stage4_cmd "bin/wastral_precise --mode ${wastral_mode} -t ${nt_wastral} -r ${wastral_R} -s ${wastral_S} -o ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/wASTRAL_${prefix}_HRS.tre ${o}/06-Coalescent-based_trees/HRS/03-combined_gene_trees/${prefix}_HRS_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_HRS.log"
      bin/wastral_precise -S ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/wASTRAL_${prefix}_HRS.tre > ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_HRS.tre
      bin/wastral_precise -S ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/wASTRAL_${prefix}_HRS.tre > ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_HRS.tre
      stage4_cmd "bin/wastral_precise -S ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/wASTRAL_${prefix}_HRS.tre > ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_HRS.tre"
    fi
      
    if [ -s "${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_HRS.tre" ]; then
      stage4_info "Succeed to run wASTRAL"
    else
      stage4_error "Fail to run wASTRAL."
      stage4_blank ""
    fi
  fi
  stage4_info "ASTRAL/wASTRAL step4 has been finished, now moving on to the ASTRAL/wASTRAL step5..."

  ############################################################
  #05：Caculate the branch length for ASTRAL results via RAxMl
  ############################################################
    stage4_blank ""
    stage4_info "ASTRAL Step5: Caculate the branch length via RAxMl"
  # ASTRAL ############
  if [ "${run_astral}" = "TRUE" ]; then
  # Delete existed RAxML files
    if [ -s "${o}/06-Coalescent-based_trees/HRS/04-ASTRAL_final_trees/RAxML_info.ASTRAL_${prefix}_HRS_bl.tre" ]; then
      rm ${o}/06-Coalescent-based_trees/HRS/04-ASTRAL_final_trees/RAxML*
    fi
  # run RAxML
    raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/HRS/04-ASTRAL_final_trees/ASTRAL_${prefix}_HRS.tre -m GTRGAMMA \
    -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta \
    -n ASTRAL_${prefix}_HRS_bl.tre \
    -w ${o}/06-Coalescent-based_trees/HRS/04-ASTRAL_final_trees \
    -N 100
    stage4_cmd "raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/HRS/04-ASTRAL_final_trees/${prefix}_HRS_ASTRAL.tre -m GTRGAMMA -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta -n ASTRAL_${prefix}_HRS_bl.tre -w ${o}/06-Coalescent-based_trees/HRS/04-ASTRAL_final_trees -N 100"
    cd ${o}/06-Coalescent-based_trees/HRS/04-ASTRAL_final_trees
    nw_reroot ${o}/06-Coalescent-based_trees/HRS/04-ASTRAL_final_trees/RAxML_result.ASTRAL_${prefix}_HRS_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/HRS/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_HRS.tre
    stage4_cmd "nw_reroot ${o}/06-Coalescent-based_trees/HRS/04-ASTRAL_final_trees/RAxML_result.ASTRAL_${prefix}_HRS_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/HRS/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_HRS.tre"
    if [ -s "${o}/06-Coalescent-based_trees/HRS/04-ASTRAL_final_trees/RAxML_result.ASTRAL_${prefix}_HRS_bl.tre" ]; then
      stage4_info "ASTRAL step5 has been finished, now moving on to the ASTRAL step6..."
    else
      stage4_error "Fail to calculate the branch length via RAxML."
      stage4_blank ""
    fi
  fi
  # wASTRAL ##############
  if [ "${run_wastral}" = "TRUE" ]; then
  # Delete existed RAxML files
    if [ -s "${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/RAxML_info.wASTRAL_${prefix}_HRS_bl.tre" ]; then
      rm ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/RAxML*
    fi
  # run RAxML
    raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_HRS.tre -m GTRGAMMA \
    -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta \
    -n wASTRAL_${prefix}_HRS_bl.tre \
    -w ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees \
    -N 100
    stage4_cmd "raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/${prefix}_HRS_wASTRAL.tre -m GTRGAMMA -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta -n wASTRAL_${prefix}_HRS_bl.tre -w ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees -N 100"
    cd ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees
    nw_reroot ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/RAxML_result.wASTRAL_${prefix}_HRS_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_HRS.tre
    stage4_cmd "nw_reroot ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/RAxML_result.wASTRAL_${prefix}_HRS_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_HRS.tre"
    if [ -s "${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/RAxML_result.wASTRAL_${prefix}_HRS_bl.tre" ]; then
      stage4_info "ASTRAL/wASTRAL step5 has been finished, now moving on to the ASTRAL/wASTRAL step6..."
    else
      stage4_error "Fail to calculate the branch length via RAxML."
      stage4_blank ""
    fi
  fi
  
  ###########################
  #06: Run PhyParts_PieCharts
  ###########################
  stage4_blank ""
  stage4_info "ASTRAL/wASTRAL Step6: Run PhyPartsPieCharts"
  mkdir -p ${o}/06-Coalescent-based_trees/HRS/05-PhyParts_PieCharts
  cd ${o}/06-Coalescent-based_trees/HRS/05-PhyParts_PieCharts
  # ASTRAL ############
  if [ "${run_astral}" = "TRUE" ]; then
    java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar \
    -a 1 -v -d ${o}/06-Coalescent-based_trees/HRS/02-rerooted_gene_trees \
    -m ${o}/06-Coalescent-based_trees/HRS/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_HRS.tre \
    -o ${o}/06-Coalescent-based_trees/HRS/05-PhyParts_PieCharts/ASTRAL_PhyParts &> /dev/null
    stage4_cmd "java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d ${o}/06-Coalescent-based_trees/HRS/02-rerooted_gene_trees -m ${o}/06-Coalescent-based_trees/HRS/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_HRS.tre -o ${o}/06-Coalescent-based_trees/HRS/05-PhyParts_PieCharts/ASTRAL_PhyParts"
    
    phyparts_number=$(find ${o}/06-Coalescent-based_trees/HRS/02-rerooted_gene_trees -type f -name "*_rr.tre" | wc -l)
    python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py \
    ${o}/06-Coalescent-based_trees/HRS/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_HRS.tre \
    ASTRAL_PhyParts ${phyparts_number} \
    --svg_name ASTRAL_PhyPartsPieCharts_${prefix}_HRS.svg \
    --to_csv
  
    stage4_cmd "python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py ${o}/06-Coalescent-based_trees/HRS/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_HRS.tre ASTRAL_PhyParts ${phyparts_number} --svg_name PhypartsPiecharts_${prefix}_HRS.svg --to_csv"
    if [ -s "${o}/06-Coalescent-based_trees/HRS/05-PhyParts_PieCharts/ASTRAL_PhyPartsPieCharts_${prefix}_HRS.svg" ]; then
      stage4_info "ASTRAL step6 has been finished."
    else
      stage4_error "Fail to run phypartspiecharts.py."
      stage4_blank ""
    fi
  fi
  # wASTRAL #################
  if [ "${run_wastral}" = "TRUE" ]; then
    java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar \
    -a 1 -v -d ${o}/06-Coalescent-based_trees/HRS/02-rerooted_gene_trees \
    -m ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_HRS.tre \
    -o ${o}/06-Coalescent-based_trees/HRS/05-PhyParts_PieCharts/wASTRAL_PhyParts &> /dev/null
    stage4_cmd "java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d ${o}/06-Coalescent-based_trees/HRS/02-rerooted_gene_trees -m ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_HRS.tre -o ${o}/06-Coalescent-based_trees/HRS/05-PhyParts_PieCharts/wASTRAL_PhyParts"
    
    phyparts_number=$(find ${o}/06-Coalescent-based_trees/HRS/02-rerooted_gene_trees -type f -name "*_rr.tre" | wc -l)
    python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py \
    ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_HRS.tre \
    wASTRAL_PhyParts ${phyparts_number} \
    --svg_name wASTRAL_PhyPartsPieCharts_${prefix}_HRS.svg \
    --to_csv
  
    stage4_cmd "python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py ${o}/06-Coalescent-based_trees/HRS/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_HRS.tre wASTRAL_PhyParts ${phyparts_number} --svg_name PhypartsPiecharts_${prefix}_HRS.svg --to_csv"
    if [ -s "${o}/06-Coalescent-based_trees/HRS/05-PhyParts_PieCharts/wASTRAL_PhyPartsPieCharts_${prefix}_HRS.svg" ]; then
      stage4_info "ASTRAL/wASTRAL step6 has been finished."
    else
      stage4_error "Fail to run phypartspiecharts.py."
      stage4_blank ""
    fi
  fi
  ##############################
  #07: ASTRAL/wASTRAL conclusion
  ##############################
  stage4_blank ""
  stage4_info "All steps of running ASTRAL/wASTRAL for HRS alignments have been finished"
  stage4_blank "                    Now moving on to running ASTRAL for alignments produced by other algorithms..."
  stage4_blank ""
fi
#02-RAPP #############################
if ([ "${run_astral}" = "TRUE" ] || [ "${run_wastral}" = "TRUE" ]) && [ "${RAPP}" = "TRUE" ]; then
  stage4_info "<=== RAPP alignments ===>"
  mkdir -p ${o}/06-Coalescent-based_trees/RAPP/01-gene_trees
  > ${o}/06-Coalescent-based_trees/RAPP/gene_with_mt_5_seqs.txt
  > ${o}/06-Coalescent-based_trees/RAPP/gene_with_lt_5_seqs.txt
  cd ${o}/02-Alignments/RAPP/05_alignments_trimal
  for Gene in *.fasta; do 
    if [ $(grep -c '^>' "${Gene}") -ge 5 ]; then
    echo "$Gene" >> ${o}/06-Coalescent-based_trees/RAPP/gene_with_mt_5_seqs.txt
    else
    echo "$Gene" >> ${o}/06-Coalescent-based_trees/RAPP/gene_with_lt_5_seqs.txt
    fi
  done
  sed -i 's/\.fasta//g' ${o}/06-Coalescent-based_trees/RAPP/gene_with_mt_5_seqs.txt
  sed -i 's/\.fasta//g' ${o}/06-Coalescent-based_trees/RAPP/gene_with_lt_5_seqs.txt

  ###################################
  #01：Construct gene trees via RAxML
  ###################################
  stage4_info "ASTRAL/wASTRAL Step1: constructing gene trees via RAxML"
  while IFS= read -r Genename || [[ -n $Genename ]]; do
    mkdir -p "${o}/06-Coalescent-based_trees/RAPP/01-gene_trees/${Genename}"
    if [ -s "${o}/06-Coalescent-based_trees/RAPP/01-gene_trees/${Genename}/RAxML_bestTree.${Genename}.tre" ] && [ "${run_astral_step1_again}" = "FALSE" ]; then
    	stag4_info "Skip constructing single-gene tree for gene ${Genename}."
    else
      if [ -s "${o}/06-Coalescent-based_trees/RAPP/01-gene_trees/${Genename}/RAxML_info.${Genename}.tre" ]; then
        rm ${o}/06-Coalescent-based_trees/RAPP/01-gene_trees/${Genename}/*
      fi
      raxmlHPC-PTHREADS -T "${nt_raxml}" -f a \
    	-s ${o}/02-Alignments/RAPP/05_alignments_trimal/${Genename}.fasta \
    	-k -x "$RANDOM" \
    	-m GTRGAMMA \
    	-p "$RANDOM" \
    	-n "${Genename}.tre" \
    	-w ${o}/06-Coalescent-based_trees/RAPP/01-gene_trees/${Genename}/ \
    	-N 100
      stage4_cmd "raxmlHPC -f a -T ${nt_astral} -s ${o}/02-Alignments/RAPP/05_alignments_trimal/${Genename}.fasta -k -x $RANDOM -m GTRGAMMA -p $RANDOM -n ${Genename}.tre -w ${o}/06-Coalescent-based_trees/RAPP/01-gene_trees/${Genename} -N 100"
      if [ ! -s "${o}/06-Coalescent-based_trees/RAPP/01-gene_trees/${Genename}/RAxML_bestTree.${Genename}.tre" ]; then
        stage4_error "Fail to run single gene tree for gene ${Genename}."
      else
        stage4_info "Finish constructing single gene tree for gene ${Genename}."
      fi
    fi
  done < ${o}/06-Coalescent-based_trees/RAPP/gene_with_mt_5_seqs.txt
  stage4_info "ASTRAL/wASTRAL step1 has been finished, now moving on to the ASTRAL/wASTRAL step2..."

  #############################################
  #02：Reroot the gene trees via mad(R) or phyx
  #############################################
  stage4_blank ""
  stage4_info "ASTRAL/wASTRAL Step2: Reroot single-gene trees via mad(R) and phyx"
  mkdir -p ${o}/06-Coalescent-based_trees/RAPP/02-rerooted_gene_trees
  rm ${o}/06-Coalescent-based_trees/RAPP/02-rerooted_gene_trees/*_rr.tre > /dev/null 2>&1
  > ${o}/06-Coalescent-based_trees/RAPP/Final_ASTRAL_gene_list.txt
  while IFS= read -r Genename || [[ -n $Genename ]]; do
  if [ -s "${o}/06-Coalescent-based_trees/RAPP/02-rerooted_gene_trees/${Genename}_rr.tre" ] && [ "${run_astral_step2}" = "FALSE" ]; then
    stage4_info "Skip using phyx or mad to construct single-gene trees."
  else
    stage4_info "Run Reroot_genetree_phyx_mad.R..."
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="Rscript ${script_dir}/Reroot_genetree_phyx_mad.R ${Genename} ${o}/06-Coalescent-based_trees/RAPP"
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      eval "og_params=\" \${og$x}\""
    done
    cmd+="${og_params}"
    ${cmd}
    stage4_cmd "${cmd}"
    if [ ! -s "${o}/06-Coalescent-based_trees/RAPP/02-rerooted_gene_trees/${Genename}_rr.tre" ]; then
      stage4_error "Fail to reroot single-gene tree for gene ${Genename}."
      stage4_blank ""
    else
      echo ${Genename} >> "${o}/06-Coalescent-based_trees/RAPP/Final_ASTRAL_gene_list.txt"
      stage4_info "Successfully rerooting single-gene tree for gene ${Genename}."
      stage4_blank ""
    fi
  fi
  done < ${o}/06-Coalescent-based_trees/RAPP/gene_with_mt_5_seqs.txt
  stage4_info "ASTRAL/wASTRAL step2 has been finished, now moving on to the ASTRAL/wASTRAL step3..."

  #03：Merge all tree files
  stage4_blank ""
  stage4_info "ASTRAL/wASTRAL Step3: Merge all tree files"
  mkdir -p ${o}/06-Coalescent-based_trees/RAPP/03-combined_gene_trees
  > ${o}/06-Coalescent-based_trees/RAPP/03-combined_gene_trees/${prefix}_RAPP_combined.tre
  cat ${o}/06-Coalescent-based_trees/RAPP/02-rerooted_gene_trees/*_rr.tre >> ${o}/06-Coalescent-based_trees/RAPP/03-combined_gene_trees/${prefix}_RAPP_combined.tre
  cd "${o}/06-Coalescent-based_trees/RAPP/03-combined_gene_trees"
  stage4_info "ASTRAL/wASTRAL step3 has been finished, now moving on to the ASTRAL/wASTRAL step4..."
  
  ##################################
  #04：Run ASTRAL-Ⅲ or /and wASTRAL
  ##################################
  # ASTRAL ##################
  if [ "${run_astral}" = "TRUE" ]; then
    stage4_blank ""
    stage4_info "ASTRAL/wASTRAL Step4: Run ASTRAL-Ⅲ"
    mkdir -p ${o}/06-Coalescent-based_trees/RAPP/04-ASTRAL_final_trees
    java -jar ${script_dir}/../dependencies/ASTRAL-master/Astral/astral.5.7.8.jar \
    -i ${o}/06-Coalescent-based_trees/RAPP/03-combined_gene_trees/${prefix}_RAPP_combined.tre \
    -o ${o}/06-Coalescent-based_trees/RAPP/04-ASTRAL_final_trees/ASTRAL_${prefix}_RAPP.tre 2> ${o}/00-logs_and_reports/logs/ASTRAL_${prefix}_RAPP.log
    stage4_cmd "java -jar ${script_dir}/../dependencies/ASTRAL-master/Astral/astral.5.7.8.jar -i   -i ${o}/06-Coalescent-based_trees/RAPP/03-combined_gene_trees/${prefix}_RAPP_combined.tre -o ${o}/06-Coalescent-based_trees/RAPP/04-ASTRAL_final_trees/ASTRAL_${prefix}_RAPP.tre 2> ${o}/00-logs_and_reports/logs/${prefix}_RAPP_ASTRAL.log"
    if [ -s "${o}/06-Coalescent-based_trees/RAPP/04-ASTRAL_final_trees/ASTRAL_${prefix}_RAPP.tre" ]; then
      stage4_info "Succeed to run ASTRAL-Ⅲ."
    else
      stage4_error "Fail to run ASTRAL-Ⅲ."
      stage4_blank ""
    fi
  fi
  # wASTRAL #################
  if [ "${run_wastral}" = "TRUE" ]; then
    stage4_blank ""
    stage4_info "ASTRAL/wASTRAL Step4: Run wASTRAL"
    mkdir -p ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees
    cd ${wastral_dir}
    # if the number of species is less than 2000, run wastral
    if [ $(wc -l < ${o}/06-Coalescent-based_trees/RAPP/Final_ASTRAL_gene_list.txt) -lt 2000 ]; then
      bin/wastral --mode ${wastral_mode} -t ${nt_wastral} \
      -r ${wastral_R} -s ${wastral_S} \
      -o ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/wASTRAL_${prefix}_RAPP.tre \
      ${o}/06-Coalescent-based_trees/RAPP/03-combined_gene_trees/${prefix}_RAPP_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_RAPP.log
      stage4_cmd "bin/wastral --mode ${wastral_mode} -t ${nt_wastral} -r ${wastral_R} -s ${wastral_S} -o ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/wASTRAL_${prefix}_RAPP.tre ${o}/06-Coalescent-based_trees/RAPP/03-combined_gene_trees/${prefix}_RAPP_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_RAPP.log"
      bin/wastral -S ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/wASTRAL_${prefix}_RAPP.tre > ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_RAPP.tre
      stage4_cmd "bin/wastral -S ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/wASTRAL_${prefix}_RAPP.tre > ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_RAPP.tre"
    # if the number of species is more than 2000, run wastral
    else
      bin/wastral_precise --mode ${wastral_mode} -t ${nt_wastral} \
      -r ${wastral_R} -s ${wastral_S} \
      -o ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/wASTRAL_${prefix}_RAPP.tre \
      ${o}/06-Coalescent-based_trees/RAPP/03-combined_gene_trees/${prefix}_RAPP_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_RAPP.log
      stage4_cmd "bin/wastral_precise --mode ${wastral_mode} -t ${nt_wastral} -r ${wastral_R} -s ${wastral_S} -o ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/wASTRAL_${prefix}_RAPP.tre ${o}/06-Coalescent-based_trees/RAPP/03-combined_gene_trees/${prefix}_RAPP_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_RAPP.log"
      bin/wastral_precise -S ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/wASTRAL_${prefix}_RAPP.tre > ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_RAPP.tre
      bin/wastral_precise -S ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/wASTRAL_${prefix}_RAPP.tre > ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_RAPP.tre
      stage4_cmd "bin/wastral_precise -S ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/wASTRAL_${prefix}_RAPP.tre > ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_RAPP.tre"
    fi
      
    if [ -s "${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_RAPP.tre" ]; then
      stage4_info "Succeed to run wASTRAL"
    else
      stage4_error "Fail to run wASTRAL."
      stage4_blank ""
    fi
  fi
  stage4_info "ASTRAL/wASTRAL step4 has been finished, now moving on to the ASTRAL/wASTRAL step5..."

  ############################################################
  #05：Caculate the branch length for ASTRAL results via RAxMl
  ############################################################
    stage4_blank ""
    stage4_info "ASTRAL Step5: Caculate the branch length via RAxMl"
  # ASTRAL ############
  if [ "${run_astral}" = "TRUE" ]; then
  # Delete existed RAxML files
    if [ -s "${o}/06-Coalescent-based_trees/RAPP/04-ASTRAL_final_trees/RAxML_info.ASTRAL_${prefix}_RAPP_bl.tre" ]; then
      rm ${o}/06-Coalescent-based_trees/RAPP/04-ASTRAL_final_trees/RAxML*
    fi
  # run RAxML
    raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/RAPP/04-ASTRAL_final_trees/ASTRAL_${prefix}_RAPP.tre -m GTRGAMMA \
    -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta \
    -n ASTRAL_${prefix}_RAPP_bl.tre \
    -w ${o}/06-Coalescent-based_trees/RAPP/04-ASTRAL_final_trees \
    -N 100
    stage4_cmd "raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/RAPP/04-ASTRAL_final_trees/${prefix}_RAPP_ASTRAL.tre -m GTRGAMMA -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta -n ASTRAL_${prefix}_RAPP_bl.tre -w ${o}/06-Coalescent-based_trees/RAPP/04-ASTRAL_final_trees -N 100"
    cd ${o}/06-Coalescent-based_trees/RAPP/04-ASTRAL_final_trees
    nw_reroot ${o}/06-Coalescent-based_trees/RAPP/04-ASTRAL_final_trees/RAxML_result.ASTRAL_${prefix}_RAPP_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/RAPP/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_RAPP.tre
    stage4_cmd "nw_reroot ${o}/06-Coalescent-based_trees/RAPP/04-ASTRAL_final_trees/RAxML_result.ASTRAL_${prefix}_RAPP_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/RAPP/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_RAPP.tre"
    if [ -s "${o}/06-Coalescent-based_trees/RAPP/04-ASTRAL_final_trees/RAxML_result.ASTRAL_${prefix}_RAPP_bl.tre" ]; then
      stage4_info "ASTRAL step5 has been finished, now moving on to the ASTRAL step6..."
    else
      stage4_error "Fail to calculate the branch length via RAxML."
      stage4_blank ""
    fi
  fi
  # wASTRAL ##############
  if [ "${run_wastral}" = "TRUE" ]; then
  # Delete existed RAxML files
    if [ -s "${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/RAxML_info.wASTRAL_${prefix}_RAPP_bl.tre" ]; then
      rm ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/RAxML*
    fi
  # run RAxML
    raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_RAPP.tre -m GTRGAMMA \
    -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta \
    -n wASTRAL_${prefix}_RAPP_bl.tre \
    -w ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees \
    -N 100
    stage4_cmd "raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/${prefix}_RAPP_wASTRAL.tre -m GTRGAMMA -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta -n wASTRAL_${prefix}_RAPP_bl.tre -w ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees -N 100"
    cd ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees
    nw_reroot ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/RAxML_result.wASTRAL_${prefix}_RAPP_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_RAPP.tre
    stage4_cmd "nw_reroot ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/RAxML_result.wASTRAL_${prefix}_RAPP_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_RAPP.tre"
    if [ -s "${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/RAxML_result.wASTRAL_${prefix}_RAPP_bl.tre" ]; then
      stage4_info "ASTRAL/wASTRAL step5 has been finished, now moving on to the ASTRAL/wASTRAL step6..."
    else
      stage4_error "Fail to calculate the branch length via RAxML."
      stage4_blank ""
    fi
  fi
  
  ###########################
  #06: Run PhyParts_PieCharts
  ###########################
  stage4_blank ""
  stage4_info "ASTRAL/wASTRAL Step6: Run PhyPartsPieCharts"
  mkdir -p ${o}/06-Coalescent-based_trees/RAPP/05-PhyParts_PieCharts
  cd ${o}/06-Coalescent-based_trees/RAPP/05-PhyParts_PieCharts
  # ASTRAL ############
  if [ "${run_astral}" = "TRUE" ]; then
    java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar \
    -a 1 -v -d ${o}/06-Coalescent-based_trees/RAPP/02-rerooted_gene_trees \
    -m ${o}/06-Coalescent-based_trees/RAPP/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_RAPP.tre \
    -o ${o}/06-Coalescent-based_trees/RAPP/05-PhyParts_PieCharts/ASTRAL_PhyParts &> /dev/null
    stage4_cmd "java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d ${o}/06-Coalescent-based_trees/RAPP/02-rerooted_gene_trees -m ${o}/06-Coalescent-based_trees/RAPP/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_RAPP.tre -o ${o}/06-Coalescent-based_trees/RAPP/05-PhyParts_PieCharts/ASTRAL_PhyParts"
    
    phyparts_number=$(find ${o}/06-Coalescent-based_trees/RAPP/02-rerooted_gene_trees -type f -name "*_rr.tre" | wc -l)
    python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py \
    ${o}/06-Coalescent-based_trees/RAPP/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_RAPP.tre \
    ASTRAL_PhyParts ${phyparts_number} \
    --svg_name ASTRAL_PhyPartsPieCharts_${prefix}_RAPP.svg \
    --to_csv
  
    stage4_cmd "python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py ${o}/06-Coalescent-based_trees/RAPP/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_RAPP.tre ASTRAL_PhyParts ${phyparts_number} --svg_name PhypartsPiecharts_${prefix}_RAPP.svg --to_csv"
    if [ -s "${o}/06-Coalescent-based_trees/RAPP/05-PhyParts_PieCharts/ASTRAL_PhyPartsPieCharts_${prefix}_RAPP.svg" ]; then
      stage4_info "ASTRAL step6 has been finished."
    else
      stage4_error "Fail to run phypartspiecharts.py."
      stage4_blank ""
    fi
  fi
  # wASTRAL #################
  if [ "${run_wastral}" = "TRUE" ]; then
    java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar \
    -a 1 -v -d ${o}/06-Coalescent-based_trees/RAPP/02-rerooted_gene_trees \
    -m ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_RAPP.tre \
    -o ${o}/06-Coalescent-based_trees/RAPP/05-PhyParts_PieCharts/wASTRAL_PhyParts &> /dev/null
    stage4_cmd "java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d ${o}/06-Coalescent-based_trees/RAPP/02-rerooted_gene_trees -m ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_RAPP.tre -o ${o}/06-Coalescent-based_trees/RAPP/05-PhyParts_PieCharts/wASTRAL_PhyParts"
    
    phyparts_number=$(find ${o}/06-Coalescent-based_trees/RAPP/02-rerooted_gene_trees -type f -name "*_rr.tre" | wc -l)
    python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py \
    ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_RAPP.tre \
    wASTRAL_PhyParts ${phyparts_number} \
    --svg_name wASTRAL_PhyPartsPieCharts_${prefix}_RAPP.svg \
    --to_csv
  
    stage4_cmd "python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py ${o}/06-Coalescent-based_trees/RAPP/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_RAPP.tre wASTRAL_PhyParts ${phyparts_number} --svg_name PhypartsPiecharts_${prefix}_RAPP.svg --to_csv"
    if [ -s "${o}/06-Coalescent-based_trees/RAPP/05-PhyParts_PieCharts/wASTRAL_PhyPartsPieCharts_${prefix}_RAPP.svg" ]; then
      stage4_info "ASTRAL/wASTRAL step6 has been finished."
    else
      stage4_error "Fail to run phypartspiecharts.py."
      stage4_blank ""
    fi
  fi
  ##############################
  #07: ASTRAL/wASTRAL conclusion
  ##############################
  stage4_blank ""
  stage4_info "All steps of running ASTRAL/wASTRAL for RAPP alignments have been finished"
  stage4_blank "                    Now moving on to running ASTRAL for alignments produced by other algorithms..."
  stage4_blank ""
fi
#03-LS #############################
if ([ "${run_astral}" = "TRUE" ] || [ "${run_wastral}" = "TRUE" ]) && [ "${LS}" = "TRUE" ]; then
  stage4_info "<=== LS alignments ===>"
  mkdir -p ${o}/06-Coalescent-based_trees/LS/01-gene_trees
  > ${o}/06-Coalescent-based_trees/LS/gene_with_mt_5_seqs.txt
  > ${o}/06-Coalescent-based_trees/LS/gene_with_lt_5_seqs.txt
  cd ${o}/02-Alignments/LS/
  for Gene in *.fasta; do 
    if [ $(grep -c '^>' "${Gene}") -ge 5 ]; then
    echo "$Gene" >> ${o}/06-Coalescent-based_trees/LS/gene_with_mt_5_seqs.txt
    else
    echo "$Gene" >> ${o}/06-Coalescent-based_trees/LS/gene_with_lt_5_seqs.txt
    fi
  done
  sed -i 's/\.fasta//g' ${o}/06-Coalescent-based_trees/LS/gene_with_mt_5_seqs.txt
  sed -i 's/\.fasta//g' ${o}/06-Coalescent-based_trees/LS/gene_with_lt_5_seqs.txt

  ###################################
  #01：Construct gene trees via RAxML
  ###################################
  stage4_info "ASTRAL/wASTRAL Step1: constructing gene trees via RAxML"
  while IFS= read -r Genename || [[ -n $Genename ]]; do
    mkdir -p "${o}/06-Coalescent-based_trees/LS/01-gene_trees/${Genename}"
    if [ -s "${o}/06-Coalescent-based_trees/LS/01-gene_trees/${Genename}/RAxML_bestTree.${Genename}.tre" ] && [ "${run_astral_step1_again}" = "FALSE" ]; then
    	stag4_info "Skip constructing single-gene tree for gene ${Genename}."
    else
      if [ -s "${o}/06-Coalescent-based_trees/LS/01-gene_trees/${Genename}/RAxML_info.${Genename}.tre" ]; then
        rm ${o}/06-Coalescent-based_trees/LS/01-gene_trees/${Genename}/*
      fi
      raxmlHPC-PTHREADS -T "${nt_raxml}" -f a \
    	-s ${o}/02-Alignments/LS/${Genename}.fasta \
    	-k -x "$RANDOM" \
    	-m GTRGAMMA \
    	-p "$RANDOM" \
    	-n "${Genename}.tre" \
    	-w ${o}/06-Coalescent-based_trees/LS/01-gene_trees/${Genename}/ \
    	-N 100
      stage4_cmd "raxmlHPC -f a -T ${nt_astral} -s ${o}/02-Alignments/LS/${Genename}.fasta -k -x $RANDOM -m GTRGAMMA -p $RANDOM -n ${Genename}.tre -w ${o}/06-Coalescent-based_trees/LS/01-gene_trees/${Genename} -N 100"
      if [ ! -s "${o}/06-Coalescent-based_trees/LS/01-gene_trees/${Genename}/RAxML_bestTree.${Genename}.tre" ]; then
        stage4_error "Fail to run single gene tree for gene ${Genename}."
      else
        stage4_info "Finish constructing single gene tree for gene ${Genename}."
      fi
    fi
  done < ${o}/06-Coalescent-based_trees/LS/gene_with_mt_5_seqs.txt
  stage4_info "ASTRAL/wASTRAL step1 has been finished, now moving on to the ASTRAL/wASTRAL step2..."

  #############################################
  #02：Reroot the gene trees via mad(R) or phyx
  #############################################
  stage4_blank ""
  stage4_info "ASTRAL/wASTRAL Step2: Reroot single-gene trees via mad(R) and phyx"
  mkdir -p ${o}/06-Coalescent-based_trees/LS/02-rerooted_gene_trees
  rm ${o}/06-Coalescent-based_trees/LS/02-rerooted_gene_trees/*_rr.tre > /dev/null 2>&1
  > ${o}/06-Coalescent-based_trees/LS/Final_ASTRAL_gene_list.txt
  while IFS= read -r Genename || [[ -n $Genename ]]; do
  if [ -s "${o}/06-Coalescent-based_trees/LS/02-rerooted_gene_trees/${Genename}_rr.tre" ] && [ "${run_astral_step2}" = "FALSE" ]; then
    stage4_info "Skip using phyx or mad to construct single-gene trees."
  else
    stage4_info "Run Reroot_genetree_phyx_mad.R..."
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="Rscript ${script_dir}/Reroot_genetree_phyx_mad.R ${Genename} ${o}/06-Coalescent-based_trees/LS"
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      eval "og_params=\" \${og$x}\""
    done
    cmd+="${og_params}"
    ${cmd}
    stage4_cmd "${cmd}"
    if [ ! -s "${o}/06-Coalescent-based_trees/LS/02-rerooted_gene_trees/${Genename}_rr.tre" ]; then
      stage4_error "Fail to reroot single-gene tree for gene ${Genename}."
      stage4_blank ""
    else
      echo ${Genename} >> "${o}/06-Coalescent-based_trees/LS/Final_ASTRAL_gene_list.txt"
      stage4_info "Successfully rerooting single-gene tree for gene ${Genename}."
      stage4_blank ""
    fi
  fi
  done < ${o}/06-Coalescent-based_trees/LS/gene_with_mt_5_seqs.txt
  stage4_info "ASTRAL/wASTRAL step2 has been finished, now moving on to the ASTRAL/wASTRAL step3..."

  #03：Merge all tree files
  stage4_blank ""
  stage4_info "ASTRAL/wASTRAL Step3: Merge all tree files"
  mkdir -p ${o}/06-Coalescent-based_trees/LS/03-combined_gene_trees
  > ${o}/06-Coalescent-based_trees/LS/03-combined_gene_trees/${prefix}_LS_combined.tre
  cat ${o}/06-Coalescent-based_trees/LS/02-rerooted_gene_trees/*_rr.tre >> ${o}/06-Coalescent-based_trees/LS/03-combined_gene_trees/${prefix}_LS_combined.tre
  cd "${o}/06-Coalescent-based_trees/LS/03-combined_gene_trees"
  stage4_info "ASTRAL/wASTRAL step3 has been finished, now moving on to the ASTRAL/wASTRAL step4..."
  
  ##################################
  #04：Run ASTRAL-Ⅲ or /and wASTRAL
  ##################################
  # ASTRAL ##################
  if [ "${run_astral}" = "TRUE" ]; then
    stage4_blank ""
    stage4_info "ASTRAL/wASTRAL Step4: Run ASTRAL-Ⅲ"
    mkdir -p ${o}/06-Coalescent-based_trees/LS/04-ASTRAL_final_trees
    java -jar ${script_dir}/../dependencies/ASTRAL-master/Astral/astral.5.7.8.jar \
    -i ${o}/06-Coalescent-based_trees/LS/03-combined_gene_trees/${prefix}_LS_combined.tre \
    -o ${o}/06-Coalescent-based_trees/LS/04-ASTRAL_final_trees/ASTRAL_${prefix}_LS.tre 2> ${o}/00-logs_and_reports/logs/ASTRAL_${prefix}_LS.log
    stage4_cmd "java -jar ${script_dir}/../dependencies/ASTRAL-master/Astral/astral.5.7.8.jar -i   -i ${o}/06-Coalescent-based_trees/LS/03-combined_gene_trees/${prefix}_LS_combined.tre -o ${o}/06-Coalescent-based_trees/LS/04-ASTRAL_final_trees/ASTRAL_${prefix}_LS.tre 2> ${o}/00-logs_and_reports/logs/${prefix}_LS_ASTRAL.log"
    if [ -s "${o}/06-Coalescent-based_trees/LS/04-ASTRAL_final_trees/ASTRAL_${prefix}_LS.tre" ]; then
      stage4_info "Succeed to run ASTRAL-Ⅲ."
    else
      stage4_error "Fail to run ASTRAL-Ⅲ."
      stage4_blank ""
    fi
  fi
  # wASTRAL #################
  if [ "${run_wastral}" = "TRUE" ]; then
    stage4_blank ""
    stage4_info "ASTRAL/wASTRAL Step4: Run wASTRAL"
    mkdir -p ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees
    cd ${wastral_dir}
    # if the number of species is less than 2000, run wastral
    if [ $(wc -l < ${o}/06-Coalescent-based_trees/LS/Final_ASTRAL_gene_list.txt) -lt 2000 ]; then
      bin/wastral --mode ${wastral_mode} -t ${nt_wastral} \
      -r ${wastral_R} -s ${wastral_S} \
      -o ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/wASTRAL_${prefix}_LS.tre \
      ${o}/06-Coalescent-based_trees/LS/03-combined_gene_trees/${prefix}_LS_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_LS.log
      stage4_cmd "bin/wastral --mode ${wastral_mode} -t ${nt_wastral} -r ${wastral_R} -s ${wastral_S} -o ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/wASTRAL_${prefix}_LS.tre ${o}/06-Coalescent-based_trees/LS/03-combined_gene_trees/${prefix}_LS_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_LS.log"
      bin/wastral -S ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/wASTRAL_${prefix}_LS.tre > ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_LS.tre
      stage4_cmd "bin/wastral -S ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/wASTRAL_${prefix}_LS.tre > ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_LS.tre"
    # if the number of species is more than 2000, run wastral
    else
      bin/wastral_precise --mode ${wastral_mode} -t ${nt_wastral} \
      -r ${wastral_R} -s ${wastral_S} \
      -o ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/wASTRAL_${prefix}_LS.tre \
      ${o}/06-Coalescent-based_trees/LS/03-combined_gene_trees/${prefix}_LS_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_LS.log
      stage4_cmd "bin/wastral_precise --mode ${wastral_mode} -t ${nt_wastral} -r ${wastral_R} -s ${wastral_S} -o ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/wASTRAL_${prefix}_LS.tre ${o}/06-Coalescent-based_trees/LS/03-combined_gene_trees/${prefix}_LS_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_LS.log"
      bin/wastral_precise -S ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/wASTRAL_${prefix}_LS.tre > ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_LS.tre
      bin/wastral_precise -S ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/wASTRAL_${prefix}_LS.tre > ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_LS.tre
      stage4_cmd "bin/wastral_precise -S ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/wASTRAL_${prefix}_LS.tre > ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_LS.tre"
    fi
      
    if [ -s "${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_LS.tre" ]; then
      stage4_info "Succeed to run wASTRAL"
    else
      stage4_error "Fail to run wASTRAL."
      stage4_blank ""
    fi
  fi
  stage4_info "ASTRAL/wASTRAL step4 has been finished, now moving on to the ASTRAL/wASTRAL step5..."

  ############################################################
  #05：Caculate the branch length for ASTRAL results via RAxMl
  ############################################################
    stage4_blank ""
    stage4_info "ASTRAL Step5: Caculate the branch length via RAxMl"
  # ASTRAL ############
  if [ "${run_astral}" = "TRUE" ]; then
  # Delete existed RAxML files
    if [ -s "${o}/06-Coalescent-based_trees/LS/04-ASTRAL_final_trees/RAxML_info.ASTRAL_${prefix}_LS_bl.tre" ]; then
      rm ${o}/06-Coalescent-based_trees/LS/04-ASTRAL_final_trees/RAxML*
    fi
  # run RAxML
    raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/LS/04-ASTRAL_final_trees/ASTRAL_${prefix}_LS.tre -m GTRGAMMA \
    -s ${o}/03-Supermatrix/LS/${prefix}_LS.fasta \
    -n ASTRAL_${prefix}_LS_bl.tre \
    -w ${o}/06-Coalescent-based_trees/LS/04-ASTRAL_final_trees \
    -N 100
    stage4_cmd "raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/LS/04-ASTRAL_final_trees/${prefix}_LS_ASTRAL.tre -m GTRGAMMA -s ${o}/03-Supermatrix/LS/${prefix}_LS.fasta -n ASTRAL_${prefix}_LS_bl.tre -w ${o}/06-Coalescent-based_trees/LS/04-ASTRAL_final_trees -N 100"
    cd ${o}/06-Coalescent-based_trees/LS/04-ASTRAL_final_trees
    nw_reroot ${o}/06-Coalescent-based_trees/LS/04-ASTRAL_final_trees/RAxML_result.ASTRAL_${prefix}_LS_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/LS/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_LS.tre
    stage4_cmd "nw_reroot ${o}/06-Coalescent-based_trees/LS/04-ASTRAL_final_trees/RAxML_result.ASTRAL_${prefix}_LS_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/LS/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_LS.tre"
    if [ -s "${o}/06-Coalescent-based_trees/LS/04-ASTRAL_final_trees/RAxML_result.ASTRAL_${prefix}_LS_bl.tre" ]; then
      stage4_info "ASTRAL step5 has been finished, now moving on to the ASTRAL step6..."
    else
      stage4_error "Fail to calculate the branch length via RAxML."
      stage4_blank ""
    fi
  fi
  # wASTRAL ##############
  if [ "${run_wastral}" = "TRUE" ]; then
  # Delete existed RAxML files
    if [ -s "${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/RAxML_info.wASTRAL_${prefix}_LS_bl.tre" ]; then
      rm ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/RAxML*
    fi
  # run RAxML
    raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_LS.tre -m GTRGAMMA \
    -s ${o}/03-Supermatrix/LS/${prefix}_LS.fasta \
    -n wASTRAL_${prefix}_LS_bl.tre \
    -w ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees \
    -N 100
    stage4_cmd "raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/${prefix}_LS_wASTRAL.tre -m GTRGAMMA -s ${o}/03-Supermatrix/LS/${prefix}_LS.fasta -n wASTRAL_${prefix}_LS_bl.tre -w ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees -N 100"
    cd ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees
    nw_reroot ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/RAxML_result.wASTRAL_${prefix}_LS_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_LS.tre
    stage4_cmd "nw_reroot ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/RAxML_result.wASTRAL_${prefix}_LS_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_LS.tre"
    if [ -s "${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/RAxML_result.wASTRAL_${prefix}_LS_bl.tre" ]; then
      stage4_info "ASTRAL/wASTRAL step5 has been finished, now moving on to the ASTRAL/wASTRAL step6..."
    else
      stage4_error "Fail to calculate the branch length via RAxML."
      stage4_blank ""
    fi
  fi
  
  ###########################
  #06: Run PhyParts_PieCharts
  ###########################
  stage4_blank ""
  stage4_info "ASTRAL/wASTRAL Step6: Run PhyPartsPieCharts"
  mkdir -p ${o}/06-Coalescent-based_trees/LS/05-PhyParts_PieCharts
  cd ${o}/06-Coalescent-based_trees/LS/05-PhyParts_PieCharts
  # ASTRAL ############
  if [ "${run_astral}" = "TRUE" ]; then
    java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar \
    -a 1 -v -d ${o}/06-Coalescent-based_trees/LS/02-rerooted_gene_trees \
    -m ${o}/06-Coalescent-based_trees/LS/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_LS.tre \
    -o ${o}/06-Coalescent-based_trees/LS/05-PhyParts_PieCharts/ASTRAL_PhyParts &> /dev/null
    stage4_cmd "java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d ${o}/06-Coalescent-based_trees/LS/02-rerooted_gene_trees -m ${o}/06-Coalescent-based_trees/LS/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_LS.tre -o ${o}/06-Coalescent-based_trees/LS/05-PhyParts_PieCharts/ASTRAL_PhyParts"
    
    phyparts_number=$(find ${o}/06-Coalescent-based_trees/LS/02-rerooted_gene_trees -type f -name "*_rr.tre" | wc -l)
    python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py \
    ${o}/06-Coalescent-based_trees/LS/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_LS.tre \
    ASTRAL_PhyParts ${phyparts_number} \
    --svg_name ASTRAL_PhyPartsPieCharts_${prefix}_LS.svg \
    --to_csv
  
    stage4_cmd "python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py ${o}/06-Coalescent-based_trees/LS/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_LS.tre ASTRAL_PhyParts ${phyparts_number} --svg_name PhypartsPiecharts_${prefix}_LS.svg --to_csv"
    if [ -s "${o}/06-Coalescent-based_trees/LS/05-PhyParts_PieCharts/ASTRAL_PhyPartsPieCharts_${prefix}_LS.svg" ]; then
      stage4_info "ASTRAL step6 has been finished."
    else
      stage4_error "Fail to run phypartspiecharts.py."
      stage4_blank ""
    fi
  fi
  # wASTRAL #################
  if [ "${run_wastral}" = "TRUE" ]; then
    java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar \
    -a 1 -v -d ${o}/06-Coalescent-based_trees/LS/02-rerooted_gene_trees \
    -m ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_LS.tre \
    -o ${o}/06-Coalescent-based_trees/LS/05-PhyParts_PieCharts/wASTRAL_PhyParts &> /dev/null
    stage4_cmd "java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d ${o}/06-Coalescent-based_trees/LS/02-rerooted_gene_trees -m ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_LS.tre -o ${o}/06-Coalescent-based_trees/LS/05-PhyParts_PieCharts/wASTRAL_PhyParts"
    
    phyparts_number=$(find ${o}/06-Coalescent-based_trees/LS/02-rerooted_gene_trees -type f -name "*_rr.tre" | wc -l)
    python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py \
    ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_LS.tre \
    wASTRAL_PhyParts ${phyparts_number} \
    --svg_name wASTRAL_PhyPartsPieCharts_${prefix}_LS.svg \
    --to_csv
  
    stage4_cmd "python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py ${o}/06-Coalescent-based_trees/LS/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_LS.tre wASTRAL_PhyParts ${phyparts_number} --svg_name PhypartsPiecharts_${prefix}_LS.svg --to_csv"
    if [ -s "${o}/06-Coalescent-based_trees/LS/05-PhyParts_PieCharts/wASTRAL_PhyPartsPieCharts_${prefix}_LS.svg" ]; then
      stage4_info "ASTRAL/wASTRAL step6 has been finished."
    else
      stage4_error "Fail to run phypartspiecharts.py."
      stage4_blank ""
    fi
  fi
  ##############################
  #07: ASTRAL/wASTRAL conclusion
  ##############################
  stage4_blank ""
  stage4_info "All steps of running ASTRAL/wASTRAL for LS alignments have been finished"
  stage4_blank "                    Now moving on to running ASTRAL for alignments produced by other algorithms..."
  stage4_blank ""
fi
#04-MI #############################
if ([ "${run_astral}" = "TRUE" ] || [ "${run_wastral}" = "TRUE" ]) && [ "${MI}" = "TRUE" ]; then
  stage4_info "<=== MI alignments ===>"
  mkdir -p ${o}/06-Coalescent-based_trees/MI/01-gene_trees
  > ${o}/06-Coalescent-based_trees/MI/gene_with_mt_5_seqs.txt
  > ${o}/06-Coalescent-based_trees/MI/gene_with_lt_5_seqs.txt
  cd ${o}/02-Alignments/MI/
  for Gene in *.fasta; do 
    if [ $(grep -c '^>' "${Gene}") -ge 5 ]; then
    echo "$Gene" >> ${o}/06-Coalescent-based_trees/MI/gene_with_mt_5_seqs.txt
    else
    echo "$Gene" >> ${o}/06-Coalescent-based_trees/MI/gene_with_lt_5_seqs.txt
    fi
  done
  sed -i 's/\.fasta//g' ${o}/06-Coalescent-based_trees/MI/gene_with_mt_5_seqs.txt
  sed -i 's/\.fasta//g' ${o}/06-Coalescent-based_trees/MI/gene_with_lt_5_seqs.txt

  ###################################
  #01：Construct gene trees via RAxML
  ###################################
  stage4_info "ASTRAL/wASTRAL Step1: constructing gene trees via RAxML"
  while IFS= read -r Genename || [ -n "$Genename" ]; do
    mkdir -p "${o}/06-Coalescent-based_trees/MI/01-gene_trees/${Genename}"
    if [ -s "${o}/06-Coalescent-based_trees/MI/01-gene_trees/${Genename}/RAxML_bestTree.${Genename}.tre" ] && [ "${run_astral_step1_again}" = "FALSE" ]; then
    	stag4_info "Skip constructing single-gene tree for gene ${Genename}."
    else
      if [ -s "${o}/06-Coalescent-based_trees/MI/01-gene_trees/${Genename}/RAxML_info.${Genename}.tre" ]; then
        rm ${o}/06-Coalescent-based_trees/MI/01-gene_trees/${Genename}/*
      fi
      raxmlHPC-PTHREADS -T "${nt_raxml}" -f a \
    	-s ${o}/02-Alignments/MI/${Genename}.fasta \
    	-k -x "$RANDOM" \
    	-m GTRGAMMA \
    	-p "$RANDOM" \
    	-n "${Genename}.tre" \
    	-w ${o}/06-Coalescent-based_trees/MI/01-gene_trees/${Genename}/ \
    	-N 100
      stage4_cmd "raxmlHPC -f a -T ${nt_astral} -s ${o}/02-Alignments/MI/${Genename}.fasta -k -x $RANDOM -m GTRGAMMA -p $RANDOM -n ${Genename}.tre -w ${o}/06-Coalescent-based_trees/MI/01-gene_trees/${Genename} -N 100"
      if [ ! -s "${o}/06-Coalescent-based_trees/MI/01-gene_trees/${Genename}/RAxML_bestTree.${Genename}.tre" ]; then
        stage4_error "Fail to run single gene tree for gene ${Genename}."
      else
        stage4_info "Finish constructing single gene tree for gene ${Genename}."
      fi
    fi
  done < ${o}/06-Coalescent-based_trees/MI/gene_with_mt_5_seqs.txt
  stage4_info "ASTRAL/wASTRAL step1 has been finished, now moving on to the ASTRAL/wASTRAL step2..."

  #############################################
  #02：Reroot the gene trees via mad(R) or phyx
  #############################################
  stage4_blank ""
  stage4_info "ASTRAL/wASTRAL Step2: Reroot single-gene trees via mad(R) and phyx"
  mkdir -p ${o}/06-Coalescent-based_trees/MI/02-rerooted_gene_trees
  rm ${o}/06-Coalescent-based_trees/MI/02-rerooted_gene_trees/*_rr.tre > /dev/null 2>&1
  > ${o}/06-Coalescent-based_trees/MI/Final_ASTRAL_gene_list.txt
  while IFS= read -r Genename || [[ -n $Genename ]]; do
  if [ -s "${o}/06-Coalescent-based_trees/MI/02-rerooted_gene_trees/${Genename}_rr.tre" ] && [ "${run_astral_step2}" = "FALSE" ]; then
    stage4_info "Skip using phyx or mad to construct single-gene trees."
  else
    stage4_info "Run Reroot_genetree_phyx_mad.R..."
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="Rscript ${script_dir}/Reroot_genetree_phyx_mad.R ${Genename} ${o}/06-Coalescent-based_trees/MI"
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      eval "og_params=\" \${og$x}\""
    done
    cmd+="${og_params}"
    ${cmd}
    stage4_cmd "${cmd}"
    if [ ! -s "${o}/06-Coalescent-based_trees/MI/02-rerooted_gene_trees/${Genename}_rr.tre" ]; then
      stage4_error "Fail to reroot single-gene tree for gene ${Genename}."
      stage4_blank ""
    else
      echo ${Genename} >> "${o}/06-Coalescent-based_trees/MI/Final_ASTRAL_gene_list.txt"
      stage4_info "Successfully rerooting single-gene tree for gene ${Genename}."
      stage4_blank ""
    fi
  fi
  done < ${o}/06-Coalescent-based_trees/MI/gene_with_mt_5_seqs.txt
  stage4_info "ASTRAL/wASTRAL step2 has been finished, now moving on to the ASTRAL/wASTRAL step3..."

  #03：Merge all tree files
  stage4_blank ""
  stage4_info "ASTRAL/wASTRAL Step3: Merge all tree files"
  mkdir -p ${o}/06-Coalescent-based_trees/MI/03-combined_gene_trees
  > ${o}/06-Coalescent-based_trees/MI/03-combined_gene_trees/${prefix}_MI_combined.tre
  cat ${o}/06-Coalescent-based_trees/MI/02-rerooted_gene_trees/*_rr.tre >> ${o}/06-Coalescent-based_trees/MI/03-combined_gene_trees/${prefix}_MI_combined.tre
  cd "${o}/06-Coalescent-based_trees/MI/03-combined_gene_trees"
  stage4_info "ASTRAL/wASTRAL step3 has been finished, now moving on to the ASTRAL/wASTRAL step4..."
  
  ##################################
  #04：Run ASTRAL-Ⅲ or /and wASTRAL
  ##################################
  # ASTRAL ##################
  if [ "${run_astral}" = "TRUE" ]; then
    stage4_blank ""
    stage4_info "ASTRAL/wASTRAL Step4: Run ASTRAL-Ⅲ"
    mkdir -p ${o}/06-Coalescent-based_trees/MI/04-ASTRAL_final_trees
    java -jar ${script_dir}/../dependencies/ASTRAL-master/Astral/astral.5.7.8.jar \
    -i ${o}/06-Coalescent-based_trees/MI/03-combined_gene_trees/${prefix}_MI_combined.tre \
    -o ${o}/06-Coalescent-based_trees/MI/04-ASTRAL_final_trees/ASTRAL_${prefix}_MI.tre 2> ${o}/00-logs_and_reports/logs/ASTRAL_${prefix}_MI.log
    stage4_cmd "java -jar ${script_dir}/../dependencies/ASTRAL-master/Astral/astral.5.7.8.jar -i   -i ${o}/06-Coalescent-based_trees/MI/03-combined_gene_trees/${prefix}_MI_combined.tre -o ${o}/06-Coalescent-based_trees/MI/04-ASTRAL_final_trees/ASTRAL_${prefix}_MI.tre 2> ${o}/00-logs_and_reports/logs/${prefix}_MI_ASTRAL.log"
    if [ -s "${o}/06-Coalescent-based_trees/MI/04-ASTRAL_final_trees/ASTRAL_${prefix}_MI.tre" ]; then
      stage4_info "Succeed to run ASTRAL-Ⅲ."
    else
      stage4_error "Fail to run ASTRAL-Ⅲ."
      stage4_blank ""
    fi
  fi
  # wASTRAL #################
  if [ "${run_wastral}" = "TRUE" ]; then
    stage4_blank ""
    stage4_info "ASTRAL/wASTRAL Step4: Run wASTRAL"
    mkdir -p ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees
    cd ${wastral_dir}
    # if the number of species is less than 2000, run wastral
    if [ $(wc -l < ${o}/06-Coalescent-based_trees/MI/Final_ASTRAL_gene_list.txt) -lt 2000 ]; then
      bin/wastral --mode ${wastral_mode} -t ${nt_wastral} \
      -r ${wastral_R} -s ${wastral_S} \
      -o ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/wASTRAL_${prefix}_MI.tre \
      ${o}/06-Coalescent-based_trees/MI/03-combined_gene_trees/${prefix}_MI_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_MI.log
      stage4_cmd "bin/wastral --mode ${wastral_mode} -t ${nt_wastral} -r ${wastral_R} -s ${wastral_S} -o ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/wASTRAL_${prefix}_MI.tre ${o}/06-Coalescent-based_trees/MI/03-combined_gene_trees/${prefix}_MI_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_MI.log"
      bin/wastral -S ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/wASTRAL_${prefix}_MI.tre > ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_MI.tre
      stage4_cmd "bin/wastral -S ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/wASTRAL_${prefix}_MI.tre > ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_MI.tre"
    # if the number of species is more than 2000, run wastral
    else
      bin/wastral_precise --mode ${wastral_mode} -t ${nt_wastral} \
      -r ${wastral_R} -s ${wastral_S} \
      -o ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/wASTRAL_${prefix}_MI.tre \
      ${o}/06-Coalescent-based_trees/MI/03-combined_gene_trees/${prefix}_MI_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_MI.log
      stage4_cmd "bin/wastral_precise --mode ${wastral_mode} -t ${nt_wastral} -r ${wastral_R} -s ${wastral_S} -o ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/wASTRAL_${prefix}_MI.tre ${o}/06-Coalescent-based_trees/MI/03-combined_gene_trees/${prefix}_MI_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_MI.log"
      bin/wastral_precise -S ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/wASTRAL_${prefix}_MI.tre > ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_MI.tre
      bin/wastral_precise -S ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/wASTRAL_${prefix}_MI.tre > ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_MI.tre
      stage4_cmd "bin/wastral_precise -S ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/wASTRAL_${prefix}_MI.tre > ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_MI.tre"
    fi
      
    if [ -s "${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_MI.tre" ]; then
      stage4_info "Succeed to run wASTRAL"
    else
      stage4_error "Fail to run wASTRAL."
      stage4_blank ""
    fi
  fi
  stage4_info "ASTRAL/wASTRAL step4 has been finished, now moving on to the ASTRAL/wASTRAL step5..."

  ############################################################
  #05：Caculate the branch length for ASTRAL results via RAxMl
  ############################################################
    stage4_blank ""
    stage4_info "ASTRAL Step5: Caculate the branch length via RAxMl"
  # ASTRAL ############
  if [ "${run_astral}" = "TRUE" ]; then
  # Delete existed RAxML files
    if [ -s "${o}/06-Coalescent-based_trees/MI/04-ASTRAL_final_trees/RAxML_info.ASTRAL_${prefix}_MI_bl.tre" ]; then
      rm ${o}/06-Coalescent-based_trees/MI/04-ASTRAL_final_trees/RAxML*
    fi
  # run RAxML
    raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/MI/04-ASTRAL_final_trees/ASTRAL_${prefix}_MI.tre -m GTRGAMMA \
    -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta \
    -n ASTRAL_${prefix}_MI_bl.tre \
    -w ${o}/06-Coalescent-based_trees/MI/04-ASTRAL_final_trees \
    -N 100
    stage4_cmd "raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/MI/04-ASTRAL_final_trees/${prefix}_MI_ASTRAL.tre -m GTRGAMMA -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta -n ASTRAL_${prefix}_MI_bl.tre -w ${o}/06-Coalescent-based_trees/MI/04-ASTRAL_final_trees -N 100"
    cd ${o}/06-Coalescent-based_trees/MI/04-ASTRAL_final_trees
    nw_reroot ${o}/06-Coalescent-based_trees/MI/04-ASTRAL_final_trees/RAxML_result.ASTRAL_${prefix}_MI_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/MI/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_MI.tre
    stage4_cmd "nw_reroot ${o}/06-Coalescent-based_trees/MI/04-ASTRAL_final_trees/RAxML_result.ASTRAL_${prefix}_MI_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/MI/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_MI.tre"
    if [ -s "${o}/06-Coalescent-based_trees/MI/04-ASTRAL_final_trees/RAxML_result.ASTRAL_${prefix}_MI_bl.tre" ]; then
      stage4_info "ASTRAL step5 has been finished, now moving on to the ASTRAL step6..."
    else
      stage4_error "Fail to calculate the branch length via RAxML."
      stage4_blank ""
    fi
  fi
  # wASTRAL ##############
  if [ "${run_wastral}" = "TRUE" ]; then
  # Delete existed RAxML files
    if [ -s "${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/RAxML_info.wASTRAL_${prefix}_MI_bl.tre" ]; then
      rm ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/RAxML*
    fi
  # run RAxML
    raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_MI.tre -m GTRGAMMA \
    -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta \
    -n wASTRAL_${prefix}_MI_bl.tre \
    -w ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees \
    -N 100
    stage4_cmd "raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/${prefix}_MI_wASTRAL.tre -m GTRGAMMA -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta -n wASTRAL_${prefix}_MI_bl.tre -w ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees -N 100"
    cd ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees
    nw_reroot ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/RAxML_result.wASTRAL_${prefix}_MI_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_MI.tre
    stage4_cmd "nw_reroot ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/RAxML_result.wASTRAL_${prefix}_MI_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_MI.tre"
    if [ -s "${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/RAxML_result.wASTRAL_${prefix}_MI_bl.tre" ]; then
      stage4_info "ASTRAL/wASTRAL step5 has been finished, now moving on to the ASTRAL/wASTRAL step6..."
    else
      stage4_error "Fail to calculate the branch length via RAxML."
      stage4_blank ""
    fi
  fi
  
  ###########################
  #06: Run PhyParts_PieCharts
  ###########################
  stage4_blank ""
  stage4_info "ASTRAL/wASTRAL Step6: Run PhyPartsPieCharts"
  mkdir -p ${o}/06-Coalescent-based_trees/MI/05-PhyParts_PieCharts
  cd ${o}/06-Coalescent-based_trees/MI/05-PhyParts_PieCharts
  # ASTRAL ############
  if [ "${run_astral}" = "TRUE" ]; then
    java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar \
    -a 1 -v -d ${o}/06-Coalescent-based_trees/MI/02-rerooted_gene_trees \
    -m ${o}/06-Coalescent-based_trees/MI/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_MI.tre \
    -o ${o}/06-Coalescent-based_trees/MI/05-PhyParts_PieCharts/ASTRAL_PhyParts &> /dev/null
    stage4_cmd "java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d ${o}/06-Coalescent-based_trees/MI/02-rerooted_gene_trees -m ${o}/06-Coalescent-based_trees/MI/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_MI.tre -o ${o}/06-Coalescent-based_trees/MI/05-PhyParts_PieCharts/ASTRAL_PhyParts"
    
    phyparts_number=$(find ${o}/06-Coalescent-based_trees/MI/02-rerooted_gene_trees -type f -name "*_rr.tre" | wc -l)
    python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py \
    ${o}/06-Coalescent-based_trees/MI/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_MI.tre \
    ASTRAL_PhyParts ${phyparts_number} \
    --svg_name ASTRAL_PhyPartsPieCharts_${prefix}_MI.svg \
    --to_csv
  
    stage4_cmd "python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py ${o}/06-Coalescent-based_trees/MI/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_MI.tre ASTRAL_PhyParts ${phyparts_number} --svg_name PhypartsPiecharts_${prefix}_MI.svg --to_csv"
    if [ -s "${o}/06-Coalescent-based_trees/MI/05-PhyParts_PieCharts/ASTRAL_PhyPartsPieCharts_${prefix}_MI.svg" ]; then
      stage4_info "ASTRAL step6 has been finished."
    else
      stage4_error "Fail to run phypartspiecharts.py."
      stage4_blank ""
    fi
  fi
  # wASTRAL #################
  if [ "${run_wastral}" = "TRUE" ]; then
    java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar \
    -a 1 -v -d ${o}/06-Coalescent-based_trees/MI/02-rerooted_gene_trees \
    -m ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_MI.tre \
    -o ${o}/06-Coalescent-based_trees/MI/05-PhyParts_PieCharts/wASTRAL_PhyParts &> /dev/null
    stage4_cmd "java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d ${o}/06-Coalescent-based_trees/MI/02-rerooted_gene_trees -m ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_MI.tre -o ${o}/06-Coalescent-based_trees/MI/05-PhyParts_PieCharts/wASTRAL_PhyParts"
    
    phyparts_number=$(find ${o}/06-Coalescent-based_trees/MI/02-rerooted_gene_trees -type f -name "*_rr.tre" | wc -l)
    python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py \
    ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_MI.tre \
    wASTRAL_PhyParts ${phyparts_number} \
    --svg_name wASTRAL_PhyPartsPieCharts_${prefix}_MI.svg \
    --to_csv
  
    stage4_cmd "python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py ${o}/06-Coalescent-based_trees/MI/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_MI.tre wASTRAL_PhyParts ${phyparts_number} --svg_name PhypartsPiecharts_${prefix}_MI.svg --to_csv"
    if [ -s "${o}/06-Coalescent-based_trees/MI/05-PhyParts_PieCharts/wASTRAL_PhyPartsPieCharts_${prefix}_MI.svg" ]; then
      stage4_info "ASTRAL/wASTRAL step6 has been finished."
    else
      stage4_error "Fail to run phypartspiecharts.py."
      stage4_blank ""
    fi
  fi
  ##############################
  #07: ASTRAL/wASTRAL conclusion
  ##############################
  stage4_blank ""
  stage4_info "All steps of running ASTRAL/wASTRAL for MI alignments have been finished"
  stage4_blank "                    Now moving on to running ASTRAL for alignments produced by other algorithms..."
  stage4_blank ""
fi
#05-MO #############################
if ([ "${run_astral}" = "TRUE" ] || [ "${run_wastral}" = "TRUE" ]) && [ "${MO}" = "TRUE" ]; then
  stage4_info "<=== MO alignments ===>"
  mkdir -p ${o}/06-Coalescent-based_trees/MO/01-gene_trees
  > ${o}/06-Coalescent-based_trees/MO/gene_with_mt_5_seqs.txt
  > ${o}/06-Coalescent-based_trees/MO/gene_with_lt_5_seqs.txt
  cd ${o}/02-Alignments/MO/
  for Gene in *.fasta; do 
    if [ $(grep -c '^>' "${Gene}") -ge 5 ]; then
    echo "$Gene" >> ${o}/06-Coalescent-based_trees/MO/gene_with_mt_5_seqs.txt
    else
    echo "$Gene" >> ${o}/06-Coalescent-based_trees/MO/gene_with_lt_5_seqs.txt
    fi
  done
  sed -i 's/\.fasta//g' ${o}/06-Coalescent-based_trees/MO/gene_with_mt_5_seqs.txt
  sed -i 's/\.fasta//g' ${o}/06-Coalescent-based_trees/MO/gene_with_lt_5_seqs.txt

  ###################################
  #01：Construct gene trees via RAxML
  ###################################
  stage4_info "ASTRAL/wASTRAL Step1: constructing gene trees via RAxML"
  while IFS= read -r Genename || [[ -n $Genename ]]; do
    mkdir -p "${o}/06-Coalescent-based_trees/MO/01-gene_trees/${Genename}"
    if [ -s "${o}/06-Coalescent-based_trees/MO/01-gene_trees/${Genename}/RAxML_bestTree.${Genename}.tre" ] && [ "${run_astral_step1_again}" = "FALSE" ]; then
    	stag4_info "Skip constructing single-gene tree for gene ${Genename}."
    else
      if [ -s "${o}/06-Coalescent-based_trees/MO/01-gene_trees/${Genename}/RAxML_info.${Genename}.tre" ]; then
        rm ${o}/06-Coalescent-based_trees/MO/01-gene_trees/${Genename}/*
      fi
      raxmlHPC-PTHREADS -T "${nt_raxml}" -f a \
    	-s ${o}/02-Alignments/MO/${Genename}.fasta \
    	-k -x "$RANDOM" \
    	-m GTRGAMMA \
    	-p "$RANDOM" \
    	-n "${Genename}.tre" \
    	-w "${o}/06-Coalescent-based_trees/MO/01-gene_trees/${Genename}/" \
    	-N 100
      stage4_cmd "raxmlHPC -f a -T ${nt_astral} -s ${o}/02-Alignments/MO/${Genename}.fasta -k -x $RANDOM -m GTRGAMMA -p $RANDOM -n ${Genename}.tre -w ${o}/06-Coalescent-based_trees/MO/01-gene_trees/${Genename} -N 100"
      if [ ! -s "${o}/06-Coalescent-based_trees/MO/01-gene_trees/${Genename}/RAxML_bestTree.${Genename}.tre" ]; then
        stage4_error "Fail to run single gene tree for gene ${Genename}."
      else
        stage4_info "Finish constructing single gene tree for gene ${Genename}."
      fi
    fi
  done < ${o}/06-Coalescent-based_trees/MO/gene_with_mt_5_seqs.txt
  stage4_info "ASTRAL/wASTRAL step1 has been finished, now moving on to the ASTRAL/wASTRAL step2..."

  #############################################
  #02：Reroot the gene trees via mad(R) or phyx
  #############################################
  stage4_blank ""
  stage4_info "ASTRAL/wASTRAL Step2: Reroot single-gene trees via mad(R) and phyx"
  mkdir -p "${o}/06-Coalescent-based_trees/MO/02-rerooted_gene_trees"
  rm ${o}/06-Coalescent-based_trees/MO/02-rerooted_gene_trees/*_rr.tre > /dev/null 2>&1
  > ${o}/06-Coalescent-based_trees/MO/Final_ASTRAL_gene_list.txt
  while IFS= read -r Genename || [[ -n $Genename ]]; do
  if [ -s "${o}/06-Coalescent-based_trees/MO/02-rerooted_gene_trees/${Genename}_rr.tre" ] && [ "${run_astral_step2}" = "FALSE" ]; then
    stage4_info "Skip using phyx or mad to construct single-gene trees."
  else
    stage4_info "Run Reroot_genetree_phyx_mad.R..."
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="Rscript ${script_dir}/Reroot_genetree_phyx_mad.R ${Genename} ${o}/06-Coalescent-based_trees/MO"
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      eval "og_params=\" \${og$x}\""
    done
    cmd+="${og_params}"
    ${cmd}
    stage4_cmd "${cmd}"
    if [ ! -s "${o}/06-Coalescent-based_trees/MO/02-rerooted_gene_trees/${Genename}_rr.tre" ]; then
      stage4_error "Fail to reroot single-gene tree for gene ${Genename}."
      stage4_blank ""
    else
      echo ${Genename} >> "${o}/06-Coalescent-based_trees/MO/Final_ASTRAL_gene_list.txt"
      stage4_info "Successfully rerooting single-gene tree for gene ${Genename}."
      stage4_blank ""
    fi
  fi
  done < ${o}/06-Coalescent-based_trees/MO/gene_with_mt_5_seqs.txt
  stage4_info "ASTRAL/wASTRAL step2 has been finished, now moving on to the ASTRAL/wASTRAL step3..."

  #03：Merge all tree files
  stage4_blank ""
  stage4_info "ASTRAL/wASTRAL Step3: Merge all tree files"
  mkdir -p ${o}/06-Coalescent-based_trees/MO/03-combined_gene_trees
  > ${o}/06-Coalescent-based_trees/MO/03-combined_gene_trees/${prefix}_MO_combined.tre
  cat ${o}/06-Coalescent-based_trees/MO/02-rerooted_gene_trees/*_rr.tre >> ${o}/06-Coalescent-based_trees/MO/03-combined_gene_trees/${prefix}_MO_combined.tre
  cd "${o}/06-Coalescent-based_trees/MO/03-combined_gene_trees"
  stage4_info "ASTRAL/wASTRAL step3 has been finished, now moving on to the ASTRAL/wASTRAL step4..."
  
  ##################################
  #04：Run ASTRAL-Ⅲ or /and wASTRAL
  ##################################
  # ASTRAL ##################
  if [ "${run_astral}" = "TRUE" ]; then
    stage4_blank ""
    stage4_info "ASTRAL/wASTRAL Step4: Run ASTRAL-Ⅲ"
    mkdir -p ${o}/06-Coalescent-based_trees/MO/04-ASTRAL_final_trees
    java -jar ${script_dir}/../dependencies/ASTRAL-master/Astral/astral.5.7.8.jar \
    -i ${o}/06-Coalescent-based_trees/MO/03-combined_gene_trees/${prefix}_MO_combined.tre \
    -o ${o}/06-Coalescent-based_trees/MO/04-ASTRAL_final_trees/ASTRAL_${prefix}_MO.tre 2> ${o}/00-logs_and_reports/logs/ASTRAL_${prefix}_MO.log
    stage4_cmd "java -jar ${script_dir}/../dependencies/ASTRAL-master/Astral/astral.5.7.8.jar -i   -i ${o}/06-Coalescent-based_trees/MO/03-combined_gene_trees/${prefix}_MO_combined.tre -o ${o}/06-Coalescent-based_trees/MO/04-ASTRAL_final_trees/ASTRAL_${prefix}_MO.tre 2> ${o}/00-logs_and_reports/logs/${prefix}_MO_ASTRAL.log"
    if [ -s "${o}/06-Coalescent-based_trees/MO/04-ASTRAL_final_trees/ASTRAL_${prefix}_MO.tre" ]; then
      stage4_info "Succeed to run ASTRAL-Ⅲ."
    else
      stage4_error "Fail to run ASTRAL-Ⅲ."
      stage4_blank ""
    fi
  fi
  # wASTRAL #################
  if [ "${run_wastral}" = "TRUE" ]; then
    stage4_blank ""
    stage4_info "ASTRAL/wASTRAL Step4: Run wASTRAL"
    mkdir -p ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees
    cd ${wastral_dir}
    # if the number of species is less than 2000, run wastral
    if [ $(wc -l < ${o}/06-Coalescent-based_trees/MO/Final_ASTRAL_gene_list.txt) -lt 2000 ]; then
      bin/wastral --mode ${wastral_mode} -t ${nt_wastral} \
      -r ${wastral_R} -s ${wastral_S} \
      -o ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/wASTRAL_${prefix}_MO.tre \
      ${o}/06-Coalescent-based_trees/MO/03-combined_gene_trees/${prefix}_MO_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_MO.log
      stage4_cmd "bin/wastral --mode ${wastral_mode} -t ${nt_wastral} -r ${wastral_R} -s ${wastral_S} -o ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/wASTRAL_${prefix}_MO.tre ${o}/06-Coalescent-based_trees/MO/03-combined_gene_trees/${prefix}_MO_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_MO.log"
      bin/wastral -S ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/wASTRAL_${prefix}_MO.tre > ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_MO.tre
      stage4_cmd "bin/wastral -S ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/wASTRAL_${prefix}_MO.tre > ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_MO.tre"
    # if the number of species is more than 2000, run wastral
    else
      bin/wastral_precise --mode ${wastral_mode} -t ${nt_wastral} \
      -r ${wastral_R} -s ${wastral_S} \
      -o ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/wASTRAL_${prefix}_MO.tre \
      ${o}/06-Coalescent-based_trees/MO/03-combined_gene_trees/${prefix}_MO_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_MO.log
      stage4_cmd "bin/wastral_precise --mode ${wastral_mode} -t ${nt_wastral} -r ${wastral_R} -s ${wastral_S} -o ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/wASTRAL_${prefix}_MO.tre ${o}/06-Coalescent-based_trees/MO/03-combined_gene_trees/${prefix}_MO_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_MO.log"
      bin/wastral_precise -S ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/wASTRAL_${prefix}_MO.tre > ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_MO.tre
      bin/wastral_precise -S ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/wASTRAL_${prefix}_MO.tre > ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_MO.tre
      stage4_cmd "bin/wastral_precise -S ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/wASTRAL_${prefix}_MO.tre > ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_MO.tre"
    fi
      
    if [ -s "${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_MO.tre" ]; then
      stage4_info "Succeed to run wASTRAL"
    else
      stage4_error "Fail to run wASTRAL."
      stage4_blank ""
    fi
  fi
  stage4_info "ASTRAL/wASTRAL step4 has been finished, now moving on to the ASTRAL/wASTRAL step5..."

  ############################################################
  #05：Caculate the branch length for ASTRAL results via RAxMl
  ############################################################
    stage4_blank ""
    stage4_info "ASTRAL Step5: Caculate the branch length via RAxMl"
  # ASTRAL ############
  if [ "${run_astral}" = "TRUE" ]; then
  # Delete existed RAxML files
    if [ -s "${o}/06-Coalescent-based_trees/MO/04-ASTRAL_final_trees/RAxML_info.ASTRAL_${prefix}_MO_bl.tre" ]; then
      rm ${o}/06-Coalescent-based_trees/MO/04-ASTRAL_final_trees/RAxML*
    fi
  # run RAxML
    raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/MO/04-ASTRAL_final_trees/ASTRAL_${prefix}_MO.tre -m GTRGAMMA \
    -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta \
    -n ASTRAL_${prefix}_MO_bl.tre \
    -w ${o}/06-Coalescent-based_trees/MO/04-ASTRAL_final_trees \
    -N 100
    stage4_cmd "raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/MO/04-ASTRAL_final_trees/${prefix}_MO_ASTRAL.tre -m GTRGAMMA -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta -n ASTRAL_${prefix}_MO_bl.tre -w ${o}/06-Coalescent-based_trees/MO/04-ASTRAL_final_trees -N 100"
    cd ${o}/06-Coalescent-based_trees/MO/04-ASTRAL_final_trees
    nw_reroot ${o}/06-Coalescent-based_trees/MO/04-ASTRAL_final_trees/RAxML_result.ASTRAL_${prefix}_MO_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/MO/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_MO.tre
    stage4_cmd "nw_reroot ${o}/06-Coalescent-based_trees/MO/04-ASTRAL_final_trees/RAxML_result.ASTRAL_${prefix}_MO_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/MO/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_MO.tre"
    if [ -s "${o}/06-Coalescent-based_trees/MO/04-ASTRAL_final_trees/RAxML_result.ASTRAL_${prefix}_MO_bl.tre" ]; then
      stage4_info "ASTRAL step5 has been finished, now moving on to the ASTRAL step6..."
    else
      stage4_error "Fail to calculate the branch length via RAxML."
      stage4_blank ""
    fi
  fi
  # wASTRAL ##############
  if [ "${run_wastral}" = "TRUE" ]; then
  # Delete existed RAxML files
    if [ -s "${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/RAxML_info.wASTRAL_${prefix}_MO_bl.tre" ]; then
      rm ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/RAxML*
    fi
  # run RAxML
    raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_MO.tre -m GTRGAMMA \
    -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta \
    -n wASTRAL_${prefix}_MO_bl.tre \
    -w ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees \
    -N 100
    stage4_cmd "raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/${prefix}_MO_wASTRAL.tre -m GTRGAMMA -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta -n wASTRAL_${prefix}_MO_bl.tre -w ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees -N 100"
    cd ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees
    nw_reroot ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/RAxML_result.wASTRAL_${prefix}_MO_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_MO.tre
    stage4_cmd "nw_reroot ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/RAxML_result.wASTRAL_${prefix}_MO_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_MO.tre"
    if [ -s "${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/RAxML_result.wASTRAL_${prefix}_MO_bl.tre" ]; then
      stage4_info "ASTRAL/wASTRAL step5 has been finished, now moving on to the ASTRAL/wASTRAL step6..."
    else
      stage4_error "Fail to calculate the branch length via RAxML."
      stage4_blank ""
    fi
  fi
  
  ###########################
  #06: Run PhyParts_PieCharts
  ###########################
  stage4_blank ""
  stage4_info "ASTRAL/wASTRAL Step6: Run PhyPartsPieCharts"
  mkdir -p ${o}/06-Coalescent-based_trees/MO/05-PhyParts_PieCharts
  cd ${o}/06-Coalescent-based_trees/MO/05-PhyParts_PieCharts
  # ASTRAL ############
  if [ "${run_astral}" = "TRUE" ]; then
    java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar \
    -a 1 -v -d ${o}/06-Coalescent-based_trees/MO/02-rerooted_gene_trees \
    -m ${o}/06-Coalescent-based_trees/MO/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_MO.tre \
    -o ${o}/06-Coalescent-based_trees/MO/05-PhyParts_PieCharts/ASTRAL_PhyParts &> /dev/null
    stage4_cmd "java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d ${o}/06-Coalescent-based_trees/MO/02-rerooted_gene_trees -m ${o}/06-Coalescent-based_trees/MO/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_MO.tre -o ${o}/06-Coalescent-based_trees/MO/05-PhyParts_PieCharts/ASTRAL_PhyParts"
    
    phyparts_number=$(find ${o}/06-Coalescent-based_trees/MO/02-rerooted_gene_trees -type f -name "*_rr.tre" | wc -l)
    python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py \
    ${o}/06-Coalescent-based_trees/MO/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_MO.tre \
    ASTRAL_PhyParts ${phyparts_number} \
    --svg_name ASTRAL_PhyPartsPieCharts_${prefix}_MO.svg \
    --to_csv
  
    stage4_cmd "python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py ${o}/06-Coalescent-based_trees/MO/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_MO.tre ASTRAL_PhyParts ${phyparts_number} --svg_name PhypartsPiecharts_${prefix}_MO.svg --to_csv"
    if [ -s "${o}/06-Coalescent-based_trees/MO/05-PhyParts_PieCharts/ASTRAL_PhyPartsPieCharts_${prefix}_MO.svg" ]; then
      stage4_info "ASTRAL step6 has been finished."
    else
      stage4_error "Fail to run phypartspiecharts.py."
      stage4_blank ""
    fi
  fi
  # wASTRAL #################
  if [ "${run_wastral}" = "TRUE" ]; then
    java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar \
    -a 1 -v -d ${o}/06-Coalescent-based_trees/MO/02-rerooted_gene_trees \
    -m ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_MO.tre \
    -o ${o}/06-Coalescent-based_trees/MO/05-PhyParts_PieCharts/wASTRAL_PhyParts &> /dev/null
    stage4_cmd "java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d ${o}/06-Coalescent-based_trees/MO/02-rerooted_gene_trees -m ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_MO.tre -o ${o}/06-Coalescent-based_trees/MO/05-PhyParts_PieCharts/wASTRAL_PhyParts"
    
    phyparts_number=$(find ${o}/06-Coalescent-based_trees/MO/02-rerooted_gene_trees -type f -name "*_rr.tre" | wc -l)
    python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py \
    ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_MO.tre \
    wASTRAL_PhyParts ${phyparts_number} \
    --svg_name wASTRAL_PhyPartsPieCharts_${prefix}_MO.svg \
    --to_csv
  
    stage4_cmd "python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py ${o}/06-Coalescent-based_trees/MO/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_MO.tre wASTRAL_PhyParts ${phyparts_number} --svg_name PhypartsPiecharts_${prefix}_MO.svg --to_csv"
    if [ -s "${o}/06-Coalescent-based_trees/MO/05-PhyParts_PieCharts/wASTRAL_PhyPartsPieCharts_${prefix}_MO.svg" ]; then
      stage4_info "ASTRAL/wASTRAL step6 has been finished."
    else
      stage4_error "Fail to run phypartspiecharts.py."
      stage4_blank ""
    fi
  fi
  ##############################
  #07: ASTRAL/wASTRAL conclusion
  ##############################
  stage4_blank ""
  stage4_info "All steps of running ASTRAL/wASTRAL for MO alignments have been finished"
  stage4_blank "                    Now moving on to running ASTRAL for alignments produced by other algorithms..."
  stage4_blank ""
fi
#06-RT #############################
if ([ "${run_astral}" = "TRUE" ] || [ "${run_wastral}" = "TRUE" ]) && [ "${RT}" = "TRUE" ]; then
  stage4_info "<=== RT alignments ===>"
  mkdir -p ${o}/06-Coalescent-based_trees/RT/01-gene_trees
  > ${o}/06-Coalescent-based_trees/RT/gene_with_mt_5_seqs.txt
  > ${o}/06-Coalescent-based_trees/RT/gene_with_lt_5_seqs.txt
  cd ${o}/02-Alignments/RT
  for Gene in *.fasta; do 
    if [ $(grep -c '^>' "${Gene}") -ge 5 ]; then
    echo "$Gene" >> ${o}/06-Coalescent-based_trees/RT/gene_with_mt_5_seqs.txt
    else
    echo "$Gene" >> ${o}/06-Coalescent-based_trees/RT/gene_with_lt_5_seqs.txt
    fi
  done
  sed -i 's/\.fasta//g' ${o}/06-Coalescent-based_trees/RT/gene_with_mt_5_seqs.txt
  sed -i 's/\.fasta//g' ${o}/06-Coalescent-based_trees/RT/gene_with_lt_5_seqs.txt

  ###################################
  #01：Construct gene trees via RAxML
  ###################################
  stage4_info "ASTRAL/wASTRAL Step1: constructing gene trees via RAxML"
  while IFS= read -r Genename || [[ -n $Genename ]]; do
    mkdir -p "${o}/06-Coalescent-based_trees/RT/01-gene_trees/$Genename"
    if [ -s "${o}/06-Coalescent-based_trees/RT/01-gene_trees/${Genename}/RAxML_bestTree.${Genename}.tre" ] && [ "${run_astral_step1_again}" = "FALSE" ]; then
    	stag4_info "Skip constructing single-gene tree for gene ${Genename}."
    else
      if [ -s "${o}/06-Coalescent-based_trees/RT/01-gene_trees/${Genename}/RAxML_info.${Genename}.tre" ]; then
        rm ${o}/06-Coalescent-based_trees/RT/01-gene_trees/${Genename}/*
      fi
      raxmlHPC-PTHREADS -T "${nt_raxml}" -f a \
    	-s ${o}/02-Alignments/RT/${Genename}.fasta \
    	-k -x "$RANDOM" \
    	-m GTRGAMMA \
    	-p "$RANDOM" \
    	-n "${Genename}.tre" \
    	-w ${o}/06-Coalescent-based_trees/RT/01-gene_trees/${Genename}/ \
    	-N 100
      stage4_cmd "raxmlHPC -f a -T ${nt_astral} -s ${o}/02-Alignments/RT/${Genename}.fasta -k -x $RANDOM -m GTRGAMMA -p $RANDOM -n ${Genename}.tre -w ${o}/06-Coalescent-based_trees/RT/01-gene_trees/${Genename} -N 100"
      if [ ! -s "${o}/06-Coalescent-based_trees/RT/01-gene_trees/${Genename}/RAxML_bestTree.${Genename}.tre" ]; then
        stage4_error "Fail to run single gene tree for gene ${Genename}."
      else
        stage4_info "Finish constructing single gene tree for gene ${Genename}."
      fi
    fi
  done < ${o}/06-Coalescent-based_trees/RT/gene_with_mt_5_seqs.txt
  stage4_info "ASTRAL/wASTRAL step1 has been finished, now moving on to the ASTRAL/wASTRAL step2..."

  #############################################
  #02：Reroot the gene trees via mad(R) or phyx
  #############################################
  stage4_blank ""
  stage4_info "ASTRAL/wASTRAL Step2: Reroot single-gene trees via mad(R) and phyx"
  mkdir -p ${o}/06-Coalescent-based_trees/RT/02-rerooted_gene_trees
  rm ${o}/06-Coalescent-based_trees/RT/02-rerooted_gene_trees/*_rr.tre > /dev/null 2>&1
  > ${o}/06-Coalescent-based_trees/RT/Final_ASTRAL_gene_list.txt
  while IFS= read -r Genename || [[ -n $Genename ]]; do
  if [ -s "${o}/06-Coalescent-based_trees/RT/02-rerooted_gene_trees/${Genename}_rr.tre" ] && [ "${run_astral_step2}" = "FALSE" ]; then
    stage4_info "Skip using phyx or mad to construct single-gene trees."
  else
    stage4_info "Run Reroot_genetree_phyx_mad.R..."
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="Rscript ${script_dir}/Reroot_genetree_phyx_mad.R ${Genename} ${o}/06-Coalescent-based_trees/RT"
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      eval "og_params=\" \${og$x}\""
    done
    cmd+="${og_params}"
    ${cmd}
    stage4_cmd "${cmd}"
    if [ ! -s "${o}/06-Coalescent-based_trees/RT/02-rerooted_gene_trees/${Genename}_rr.tre" ]; then
      stage4_error "Fail to reroot single-gene tree for gene ${Genename}."
      stage4_blank ""
    else
      echo ${Genename} >> "${o}/06-Coalescent-based_trees/RT/Final_ASTRAL_gene_list.txt"
      stage4_info "Successfully rerooting single-gene tree for gene ${Genename}."
      stage4_blank ""
    fi
  fi
  done < ${o}/06-Coalescent-based_trees/RT/gene_with_mt_5_seqs.txt
  stage4_info "ASTRAL/wASTRAL step2 has been finished, now moving on to the ASTRAL/wASTRAL step3..."

  #03：Merge all tree files
  stage4_blank ""
  stage4_info "ASTRAL/wASTRAL Step3: Merge all tree files"
  mkdir -p ${o}/06-Coalescent-based_trees/RT/03-combined_gene_trees
  > ${o}/06-Coalescent-based_trees/RT/03-combined_gene_trees/${prefix}_RT_combined.tre
  cat ${o}/06-Coalescent-based_trees/RT/02-rerooted_gene_trees/*_rr.tre >> ${o}/06-Coalescent-based_trees/RT/03-combined_gene_trees/${prefix}_RT_combined.tre
  cd "${o}/06-Coalescent-based_trees/RT/03-combined_gene_trees"
  stage4_info "ASTRAL/wASTRAL step3 has been finished, now moving on to the ASTRAL/wASTRAL step4..."
  
  ##################################
  #04：Run ASTRAL-Ⅲ or /and wASTRAL
  ##################################
  # ASTRAL ##################
  if [ "${run_astral}" = "TRUE" ]; then
    stage4_blank ""
    stage4_info "ASTRAL/wASTRAL Step4: Run ASTRAL-Ⅲ"
    mkdir -p ${o}/06-Coalescent-based_trees/RT/04-ASTRAL_final_trees
    java -jar ${script_dir}/../dependencies/ASTRAL-master/Astral/astral.5.7.8.jar \
    -i ${o}/06-Coalescent-based_trees/RT/03-combined_gene_trees/${prefix}_RT_combined.tre \
    -o ${o}/06-Coalescent-based_trees/RT/04-ASTRAL_final_trees/ASTRAL_${prefix}_RT.tre 2> ${o}/00-logs_and_reports/logs/ASTRAL_${prefix}_RT.log
    stage4_cmd "java -jar ${script_dir}/../dependencies/ASTRAL-master/Astral/astral.5.7.8.jar -i   -i ${o}/06-Coalescent-based_trees/RT/03-combined_gene_trees/${prefix}_RT_combined.tre -o ${o}/06-Coalescent-based_trees/RT/04-ASTRAL_final_trees/ASTRAL_${prefix}_RT.tre 2> ${o}/00-logs_and_reports/logs/${prefix}_RT_ASTRAL.log"
    if [ -s "${o}/06-Coalescent-based_trees/RT/04-ASTRAL_final_trees/ASTRAL_${prefix}_RT.tre" ]; then
      stage4_info "Succeed to run ASTRAL-Ⅲ."
    else
      stage4_error "Fail to run ASTRAL-Ⅲ."
      stage4_blank ""
    fi
  fi
  # wASTRAL #################
  if [ "${run_wastral}" = "TRUE" ]; then
    stage4_blank ""
    stage4_info "ASTRAL/wASTRAL Step4: Run wASTRAL"
    mkdir -p ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees
    cd ${wastral_dir}
    # if the number of species is less than 2000, run wastral
    if [ $(wc -l < ${o}/06-Coalescent-based_trees/RT/Final_ASTRAL_gene_list.txt) -lt 2000 ]; then
      bin/wastral --mode ${wastral_mode} -t ${nt_wastral} \
      -r ${wastral_R} -s ${wastral_S} \
      -o ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/wASTRAL_${prefix}_RT.tre \
      ${o}/06-Coalescent-based_trees/RT/03-combined_gene_trees/${prefix}_RT_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_RT.log
      stage4_cmd "bin/wastral --mode ${wastral_mode} -t ${nt_wastral} -r ${wastral_R} -s ${wastral_S} -o ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/wASTRAL_${prefix}_RT.tre ${o}/06-Coalescent-based_trees/RT/03-combined_gene_trees/${prefix}_RT_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_RT.log"
      bin/wastral -S ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/wASTRAL_${prefix}_RT.tre > ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_RT.tre
      stage4_cmd "bin/wastral -S ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/wASTRAL_${prefix}_RT.tre > ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_RT.tre"
    # if the number of species is more than 2000, run wastral
    else
      bin/wastral_precise --mode ${wastral_mode} -t ${nt_wastral} \
      -r ${wastral_R} -s ${wastral_S} \
      -o ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/wASTRAL_${prefix}_RT.tre \
      ${o}/06-Coalescent-based_trees/RT/03-combined_gene_trees/${prefix}_RT_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_RT.log
      stage4_cmd "bin/wastral_precise --mode ${wastral_mode} -t ${nt_wastral} -r ${wastral_R} -s ${wastral_S} -o ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/wASTRAL_${prefix}_RT.tre ${o}/06-Coalescent-based_trees/RT/03-combined_gene_trees/${prefix}_RT_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_RT.log"
      bin/wastral_precise -S ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/wASTRAL_${prefix}_RT.tre > ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_RT.tre
      bin/wastral_precise -S ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/wASTRAL_${prefix}_RT.tre > ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_RT.tre
      stage4_cmd "bin/wastral_precise -S ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/wASTRAL_${prefix}_RT.tre > ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_RT.tre"
    fi
      
    if [ -s "${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_RT.tre" ]; then
      stage4_info "Succeed to run wASTRAL"
    else
      stage4_error "Fail to run wASTRAL."
      stage4_blank ""
    fi
  fi
  stage4_info "ASTRAL/wASTRAL step4 has been finished, now moving on to the ASTRAL/wASTRAL step5..."

  ############################################################
  #05：Caculate the branch length for ASTRAL results via RAxMl
  ############################################################
    stage4_blank ""
    stage4_info "ASTRAL Step5: Caculate the branch length via RAxMl"
  # ASTRAL ############
  if [ "${run_astral}" = "TRUE" ]; then
  # Delete existed RAxML files
    if [ -s "${o}/06-Coalescent-based_trees/RT/04-ASTRAL_final_trees/RAxML_info.ASTRAL_${prefix}_RT_bl.tre" ]; then
      rm ${o}/06-Coalescent-based_trees/RT/04-ASTRAL_final_trees/RAxML*
    fi
  # run RAxML
    raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/RT/04-ASTRAL_final_trees/ASTRAL_${prefix}_RT.tre -m GTRGAMMA \
    -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta \
    -n ASTRAL_${prefix}_RT_bl.tre \
    -w ${o}/06-Coalescent-based_trees/RT/04-ASTRAL_final_trees \
    -N 100
    stage4_cmd "raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/RT/04-ASTRAL_final_trees/${prefix}_RT_ASTRAL.tre -m GTRGAMMA -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta -n ASTRAL_${prefix}_RT_bl.tre -w ${o}/06-Coalescent-based_trees/RT/04-ASTRAL_final_trees -N 100"
    cd ${o}/06-Coalescent-based_trees/RT/04-ASTRAL_final_trees
    nw_reroot ${o}/06-Coalescent-based_trees/RT/04-ASTRAL_final_trees/RAxML_result.ASTRAL_${prefix}_RT_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/RT/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_RT.tre
    stage4_cmd "nw_reroot ${o}/06-Coalescent-based_trees/RT/04-ASTRAL_final_trees/RAxML_result.ASTRAL_${prefix}_RT_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/RT/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_RT.tre"
    if [ -s "${o}/06-Coalescent-based_trees/RT/04-ASTRAL_final_trees/RAxML_result.ASTRAL_${prefix}_RT_bl.tre" ]; then
      stage4_info "ASTRAL step5 has been finished, now moving on to the ASTRAL step6..."
    else
      stage4_error "Fail to calculate the branch length via RAxML."
      stage4_blank ""
    fi
  fi
  # wASTRAL ##############
  if [ "${run_wastral}" = "TRUE" ]; then
  # Delete existed RAxML files
    if [ -s "${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/RAxML_info.wASTRAL_${prefix}_RT_bl.tre" ]; then
      rm ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/RAxML*
    fi
  # run RAxML
    raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_RT.tre -m GTRGAMMA \
    -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta \
    -n wASTRAL_${prefix}_RT_bl.tre \
    -w ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees \
    -N 100
    stage4_cmd "raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/${prefix}_RT_wASTRAL.tre -m GTRGAMMA -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta -n wASTRAL_${prefix}_RT_bl.tre -w ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees -N 100"
    cd ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees
    nw_reroot ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/RAxML_result.wASTRAL_${prefix}_RT_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_RT.tre
    stage4_cmd "nw_reroot ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/RAxML_result.wASTRAL_${prefix}_RT_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_RT.tre"
    if [ -s "${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/RAxML_result.wASTRAL_${prefix}_RT_bl.tre" ]; then
      stage4_info "ASTRAL/wASTRAL step5 has been finished, now moving on to the ASTRAL/wASTRAL step6..."
    else
      stage4_error "Fail to calculate the branch length via RAxML."
      stage4_blank ""
    fi
  fi
  
  ###########################
  #06: Run PhyParts_PieCharts
  ###########################
  stage4_blank ""
  stage4_info "ASTRAL/wASTRAL Step6: Run PhyPartsPieCharts"
  mkdir -p ${o}/06-Coalescent-based_trees/RT/05-PhyParts_PieCharts
  cd ${o}/06-Coalescent-based_trees/RT/05-PhyParts_PieCharts
  # ASTRAL ############
  if [ "${run_astral}" = "TRUE" ]; then
    java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar \
    -a 1 -v -d ${o}/06-Coalescent-based_trees/RT/02-rerooted_gene_trees \
    -m ${o}/06-Coalescent-based_trees/RT/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_RT.tre \
    -o ${o}/06-Coalescent-based_trees/RT/05-PhyParts_PieCharts/ASTRAL_PhyParts &> /dev/null
    stage4_cmd "java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d ${o}/06-Coalescent-based_trees/RT/02-rerooted_gene_trees -m ${o}/06-Coalescent-based_trees/RT/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_RT.tre -o ${o}/06-Coalescent-based_trees/RT/05-PhyParts_PieCharts/ASTRAL_PhyParts"
    
    phyparts_number=$(find ${o}/06-Coalescent-based_trees/RT/02-rerooted_gene_trees -type f -name "*_rr.tre" | wc -l)
    python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py \
    ${o}/06-Coalescent-based_trees/RT/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_RT.tre \
    ASTRAL_PhyParts ${phyparts_number} \
    --svg_name ASTRAL_PhyPartsPieCharts_${prefix}_RT.svg \
    --to_csv
  
    stage4_cmd "python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py ${o}/06-Coalescent-based_trees/RT/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_RT.tre ASTRAL_PhyParts ${phyparts_number} --svg_name PhypartsPiecharts_${prefix}_RT.svg --to_csv"
    if [ -s "${o}/06-Coalescent-based_trees/RT/05-PhyParts_PieCharts/ASTRAL_PhyPartsPieCharts_${prefix}_RT.svg" ]; then
      stage4_info "ASTRAL step6 has been finished."
    else
      stage4_error "Fail to run phypartspiecharts.py."
      stage4_blank ""
    fi
  fi
  # wASTRAL #################
  if [ "${run_wastral}" = "TRUE" ]; then
    java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar \
    -a 1 -v -d ${o}/06-Coalescent-based_trees/RT/02-rerooted_gene_trees \
    -m ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_RT.tre \
    -o ${o}/06-Coalescent-based_trees/RT/05-PhyParts_PieCharts/wASTRAL_PhyParts &> /dev/null
    stage4_cmd "java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d ${o}/06-Coalescent-based_trees/RT/02-rerooted_gene_trees -m ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_RT.tre -o ${o}/06-Coalescent-based_trees/RT/05-PhyParts_PieCharts/wASTRAL_PhyParts"
    
    phyparts_number=$(find ${o}/06-Coalescent-based_trees/RT/02-rerooted_gene_trees -type f -name "*_rr.tre" | wc -l)
    python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py \
    ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_RT.tre \
    wASTRAL_PhyParts ${phyparts_number} \
    --svg_name wASTRAL_PhyPartsPieCharts_${prefix}_RT.svg \
    --to_csv
  
    stage4_cmd "python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py ${o}/06-Coalescent-based_trees/RT/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_RT.tre wASTRAL_PhyParts ${phyparts_number} --svg_name PhypartsPiecharts_${prefix}_RT.svg --to_csv"
    if [ -s "${o}/06-Coalescent-based_trees/RT/05-PhyParts_PieCharts/wASTRAL_PhyPartsPieCharts_${prefix}_RT.svg" ]; then
      stage4_info "ASTRAL/wASTRAL step6 has been finished."
    else
      stage4_error "Fail to run phypartspiecharts.py."
      stage4_blank ""
    fi
  fi
  ##############################
  #07: ASTRAL/wASTRAL conclusion
  ##############################
  stage4_blank ""
  stage4_info "All steps of running ASTRAL/wASTRAL for RT alignments have been finished"
  stage4_blank "                    Now moving on to running ASTRAL for alignments produced by other algorithms..."
  stage4_blank ""
fi
#07-1to1 #############################
if ([ "${run_astral}" = "TRUE" ] || [ "${run_wastral}" = "TRUE" ]) && [ "${one_to_one}" = "TRUE" ]; then
  stage4_info "<=== 1to1 alignments ===>"
  mkdir -p ${o}/06-Coalescent-based_trees/1to1/01-gene_trees
  > ${o}/06-Coalescent-based_trees/1to1/gene_with_mt_5_seqs.txt
  > ${o}/06-Coalescent-based_trees/1to1/gene_with_lt_5_seqs.txt
  cd ${o}/02-Alignments/1to1
  for Gene in *.fasta; do 
    if [ $(grep -c '^>' "${Gene}") -ge 5 ]; then
    echo "$Gene" >> ${o}/06-Coalescent-based_trees/1to1/gene_with_mt_5_seqs.txt
    else
    echo "$Gene" >> ${o}/06-Coalescent-based_trees/1to1/gene_with_lt_5_seqs.txt
    fi
  done
  sed -i 's/\.fasta//g' ${o}/06-Coalescent-based_trees/1to1/gene_with_mt_5_seqs.txt
  sed -i 's/\.fasta//g' ${o}/06-Coalescent-based_trees/1to1/gene_with_lt_5_seqs.txt

  #####################################
  #01：Construct gene trees via RAxML #
  #####################################
  stage4_info "ASTRAL/wASTRAL Step1: constructing gene trees via RAxML"
  while IFS= read -r Genename || [[ -n $Genename ]]; do
    mkdir -p "${o}/06-Coalescent-based_trees/1to1/01-gene_trees/$Genename"
    if [ -s "${o}/06-Coalescent-based_trees/1to1/01-gene_trees/${Genename}/RAxML_bestTree.${Genename}.tre" ] && [ "${run_astral_step1_again}" = "FALSE" ]; then
    	stag4_info "Skip constructing single-gene tree for gene ${Genename}."
    else
      if [ -s "${o}/06-Coalescent-based_trees/1to1/01-gene_trees/${Genename}/RAxML_info.${Genename}.tre" ]; then
        rm ${o}/06-Coalescent-based_trees/1to1/01-gene_trees/${Genename}/*
      fi
      raxmlHPC-PTHREADS -T "${nt_raxml}" -f a \
    	-s ${o}/02-Alignments/1to1/${Genename}.fasta \
    	-k -x "$RANDOM" \
    	-m GTRGAMMA \
    	-p "$RANDOM" \
    	-n "${Genename}.tre" \
    	-w ${o}/06-Coalescent-based_trees/1to1/01-gene_trees/${Genename}/ \
    	-N 100
      stage4_cmd "raxmlHPC -f a -T ${nt_astral} -s ${o}/02-Alignments/1to1/${Genename}.fasta -k -x $RANDOM -m GTRGAMMA -p $RANDOM -n ${Genename}.tre -w ${o}/06-Coalescent-based_trees/1to1/01-gene_trees/${Genename} -N 100"
      if [ ! -s "${o}/06-Coalescent-based_trees/1to1/01-gene_trees/${Genename}/RAxML_bestTree.${Genename}.tre" ]; then
        stage4_error "Fail to run single gene tree for gene ${Genename}."
      else
        stage4_info "Finish constructing single gene tree for gene ${Genename}."
      fi
    fi
  done < ${o}/06-Coalescent-based_trees/1to1/gene_with_mt_5_seqs.txt
  stage4_info "ASTRAL/wASTRAL step1 has been finished, now moving on to the ASTRAL/wASTRAL step2..."

  #############################################
  #02：Reroot the gene trees via mad(R) or phyx
  #############################################
  stage4_blank ""
  stage4_info "ASTRAL/wASTRAL Step2: Reroot single-gene trees via mad(R) and phyx"
  mkdir -p ${o}/06-Coalescent-based_trees/1to1/02-rerooted_gene_trees
  rm ${o}/06-Coalescent-based_trees/1to1/02-rerooted_gene_trees/*_rr.tre > /dev/null 2>&1
  > ${o}/06-Coalescent-based_trees/1to1/Final_ASTRAL_gene_list.txt
  while IFS= read -r Genename || [[ -n $Genename ]]; do
  if [ -s "${o}/06-Coalescent-based_trees/1to1/02-rerooted_gene_trees/${Genename}_rr.tre" ] && [ "${run_astral_step2}" = "FALSE" ]; then
    stage4_info "Skip using phyx or mad to construct single-gene trees."
  else
    stage4_info "Run Reroot_genetree_phyx_mad.R..."
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line || [ -n "$line" ]; do
      eval "og${counter}=\"${line}\""
      counter=$((counter + 1))
    done < ${i}/Outgroup.txt
# Dynamically build the parameters of the nw reroot command
    cmd="Rscript ${script_dir}/Reroot_genetree_phyx_mad.R ${Genename} ${o}/06-Coalescent-based_trees/1to1"
# Create a temporary variable to hold all og variables
    og_params=""
# Append all og variables to the temporary variable using the for loop
    for ((x=1; x<counter; x++)); do
      eval "og_params=\" \${og$x}\""
    done
    cmd+="${og_params}"
    ${cmd}
    stage4_cmd "${cmd}"
    if [ ! -s "${o}/06-Coalescent-based_trees/1to1/02-rerooted_gene_trees/${Genename}_rr.tre" ]; then
      stage4_error "Fail to reroot single-gene tree for gene ${Genename}."
      stage4_blank ""
    else
      echo ${Genename} >> "${o}/06-Coalescent-based_trees/1to1/Final_ASTRAL_gene_list.txt"
      stage4_info "Successfully rerooting single-gene tree for gene ${Genename}."
      stage4_blank ""
    fi
  fi
  done < ${o}/06-Coalescent-based_trees/1to1/gene_with_mt_5_seqs.txt
  stage4_info "ASTRAL/wASTRAL step2 has been finished, now moving on to the ASTRAL/wASTRAL step3..."

  #03：Merge all tree files
  stage4_blank ""
  stage4_info "ASTRAL/wASTRAL Step3: Merge all tree files"
  mkdir -p ${o}/06-Coalescent-based_trees/1to1/03-combined_gene_trees
  > ${o}/06-Coalescent-based_trees/1to1/03-combined_gene_trees/${prefix}_1to1_combined.tre
  cat ${o}/06-Coalescent-based_trees/1to1/02-rerooted_gene_trees/*_rr.tre >> ${o}/06-Coalescent-based_trees/1to1/03-combined_gene_trees/${prefix}_1to1_combined.tre
  cd "${o}/06-Coalescent-based_trees/1to1/03-combined_gene_trees"
  stage4_info "ASTRAL/wASTRAL step3 has been finished, now moving on to the ASTRAL/wASTRAL step4..."
  
  ##################################
  #04：Run ASTRAL-Ⅲ or /and wASTRAL
  ##################################
  # ASTRAL ##################
  if [ "${run_astral}" = "TRUE" ]; then
    stage4_blank ""
    stage4_info "ASTRAL/wASTRAL Step4: Run ASTRAL-Ⅲ"
    mkdir -p ${o}/06-Coalescent-based_trees/1to1/04-ASTRAL_final_trees
    java -jar ${script_dir}/../dependencies/ASTRAL-master/Astral/astral.5.7.8.jar \
    -i ${o}/06-Coalescent-based_trees/1to1/03-combined_gene_trees/${prefix}_1to1_combined.tre \
    -o ${o}/06-Coalescent-based_trees/1to1/04-ASTRAL_final_trees/ASTRAL_${prefix}_1to1.tre 2> ${o}/00-logs_and_reports/logs/ASTRAL_${prefix}_1to1.log
    stage4_cmd "java -jar ${script_dir}/../dependencies/ASTRAL-master/Astral/astral.5.7.8.jar -i   -i ${o}/06-Coalescent-based_trees/1to1/03-combined_gene_trees/${prefix}_1to1_combined.tre -o ${o}/06-Coalescent-based_trees/1to1/04-ASTRAL_final_trees/ASTRAL_${prefix}_1to1.tre 2> ${o}/00-logs_and_reports/logs/${prefix}_1to1_ASTRAL.log"
    if [ -s "${o}/06-Coalescent-based_trees/1to1/04-ASTRAL_final_trees/ASTRAL_${prefix}_1to1.tre" ]; then
      stage4_info "Succeed to run ASTRAL-Ⅲ."
    else
      stage4_error "Fail to run ASTRAL-Ⅲ."
      stage4_blank ""
    fi
  fi
  # wASTRAL #################
  if [ "${run_wastral}" = "TRUE" ]; then
    stage4_blank ""
    stage4_info "ASTRAL/wASTRAL Step4: Run wASTRAL"
    mkdir -p ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees
    cd ${wastral_dir}
    # if the number of species is less than 2000, run wastral
    if [ $(wc -l < ${o}/06-Coalescent-based_trees/1to1/Final_ASTRAL_gene_list.txt) -lt 2000 ]; then
      bin/wastral --mode ${wastral_mode} -t ${nt_wastral} \
      -r ${wastral_R} -s ${wastral_S} \
      -o ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/wASTRAL_${prefix}_1to1.tre \
      ${o}/06-Coalescent-based_trees/1to1/03-combined_gene_trees/${prefix}_1to1_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_1to1.log
      stage4_cmd "bin/wastral --mode ${wastral_mode} -t ${nt_wastral} -r ${wastral_R} -s ${wastral_S} -o ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/wASTRAL_${prefix}_1to1.tre ${o}/06-Coalescent-based_trees/1to1/03-combined_gene_trees/${prefix}_1to1_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_1to1.log"
      bin/wastral -S ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/wASTRAL_${prefix}_1to1.tre > ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_1to1.tre
      stage4_cmd "bin/wastral -S ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/wASTRAL_${prefix}_1to1.tre > ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_1to1.tre"
    # if the number of species is more than 2000, run wastral
    else
      bin/wastral_precise --mode ${wastral_mode} -t ${nt_wastral} \
      -r ${wastral_R} -s ${wastral_S} \
      -o ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/wASTRAL_${prefix}_1to1.tre \
      ${o}/06-Coalescent-based_trees/1to1/03-combined_gene_trees/${prefix}_1to1_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_1to1.log
      stage4_cmd "bin/wastral_precise --mode ${wastral_mode} -t ${nt_wastral} -r ${wastral_R} -s ${wastral_S} -o ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/wASTRAL_${prefix}_1to1.tre ${o}/06-Coalescent-based_trees/1to1/03-combined_gene_trees/${prefix}_1to1_combined.tre 2> ${o}/00-logs_and_reports/logs/wASTRAL_${prefix}_1to1.log"
      bin/wastral_precise -S ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/wASTRAL_${prefix}_1to1.tre > ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_1to1.tre
      bin/wastral_precise -S ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/wASTRAL_${prefix}_1to1.tre > ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_1to1.tre
      stage4_cmd "bin/wastral_precise -S ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/wASTRAL_${prefix}_1to1.tre > ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_1to1.tre"
    fi
      
    if [ -s "${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_1to1.tre" ]; then
      stage4_info "Succeed to run wASTRAL"
    else
      stage4_error "Fail to run wASTRAL."
      stage4_blank ""
    fi
  fi
  stage4_info "ASTRAL/wASTRAL step4 has been finished, now moving on to the ASTRAL/wASTRAL step5..."

  ############################################################
  #05：Caculate the branch length for ASTRAL results via RAxMl
  ############################################################
    stage4_blank ""
    stage4_info "ASTRAL Step5: Caculate the branch length via RAxMl"
  # ASTRAL ############
  if [ "${run_astral}" = "TRUE" ]; then
  # Delete existed RAxML files
    if [ -s "${o}/06-Coalescent-based_trees/1to1/04-ASTRAL_final_trees/RAxML_info.ASTRAL_${prefix}_1to1_bl.tre" ]; then
      rm ${o}/06-Coalescent-based_trees/1to1/04-ASTRAL_final_trees/RAxML*
    fi
  # run RAxML
    raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/1to1/04-ASTRAL_final_trees/ASTRAL_${prefix}_1to1.tre -m GTRGAMMA \
    -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta \
    -n ASTRAL_${prefix}_1to1_bl.tre \
    -w ${o}/06-Coalescent-based_trees/1to1/04-ASTRAL_final_trees \
    -N 100
    stage4_cmd "raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/1to1/04-ASTRAL_final_trees/${prefix}_1to1_ASTRAL.tre -m GTRGAMMA -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta -n ASTRAL_${prefix}_1to1_bl.tre -w ${o}/06-Coalescent-based_trees/1to1/04-ASTRAL_final_trees -N 100"
    cd ${o}/06-Coalescent-based_trees/1to1/04-ASTRAL_final_trees
    nw_reroot ${o}/06-Coalescent-based_trees/1to1/04-ASTRAL_final_trees/RAxML_result.ASTRAL_${prefix}_1to1_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/1to1/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_1to1.tre
    stage4_cmd "nw_reroot ${o}/06-Coalescent-based_trees/1to1/04-ASTRAL_final_trees/RAxML_result.ASTRAL_${prefix}_1to1_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/1to1/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_1to1.tre"
    if [ -s "${o}/06-Coalescent-based_trees/1to1/04-ASTRAL_final_trees/RAxML_result.ASTRAL_${prefix}_1to1_bl.tre" ]; then
      stage4_info "ASTRAL step5 has been finished, now moving on to the ASTRAL step6..."
    else
      stage4_error "Fail to calculate the branch length via RAxML."
      stage4_blank ""
    fi
  fi
  # wASTRAL ##############
  if [ "${run_wastral}" = "TRUE" ]; then
  # Delete existed RAxML files
    if [ -s "${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/RAxML_info.wASTRAL_${prefix}_1to1_bl.tre" ]; then
      rm ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/RAxML*
    fi
  # run RAxML
    raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/wASTRAL_bootstrap_${prefix}_1to1.tre -m GTRGAMMA \
    -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta \
    -n wASTRAL_${prefix}_1to1_bl.tre \
    -w ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees \
    -N 100
    stage4_cmd "raxmlHPC -f e -t ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/${prefix}_1to1_wASTRAL.tre -m GTRGAMMA -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta -n wASTRAL_${prefix}_1to1_bl.tre -w ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees -N 100"
    cd ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees
    nw_reroot ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/RAxML_result.wASTRAL_${prefix}_1to1_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_1to1.tre
    stage4_cmd "nw_reroot ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/RAxML_result.wASTRAL_${prefix}_1to1_bl.tre | nw_order -c n - > ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_1to1.tre"
    if [ -s "${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/RAxML_result.wASTRAL_${prefix}_1to1_bl.tre" ]; then
      stage4_info "ASTRAL/wASTRAL step5 has been finished, now moving on to the ASTRAL/wASTRAL step6..."
    else
      stage4_error "Fail to calculate the branch length via RAxML."
      stage4_blank ""
    fi
  fi
  
  ###########################
  #06: Run PhyParts_PieCharts
  ###########################
  stage4_blank ""
  stage4_info "ASTRAL/wASTRAL Step6: Run PhyPartsPieCharts"
  mkdir -p ${o}/06-Coalescent-based_trees/1to1/05-PhyParts_PieCharts
  cd ${o}/06-Coalescent-based_trees/1to1/05-PhyParts_PieCharts
  # ASTRAL ############
  if [ "${run_astral}" = "TRUE" ]; then
    java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar \
    -a 1 -v -d ${o}/06-Coalescent-based_trees/1to1/02-rerooted_gene_trees \
    -m ${o}/06-Coalescent-based_trees/1to1/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_1to1.tre \
    -o ${o}/06-Coalescent-based_trees/1to1/05-PhyParts_PieCharts/ASTRAL_PhyParts &> /dev/null
    stage4_cmd "java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d ${o}/06-Coalescent-based_trees/1to1/02-rerooted_gene_trees -m ${o}/06-Coalescent-based_trees/1to1/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_1to1.tre -o ${o}/06-Coalescent-based_trees/1to1/05-PhyParts_PieCharts/ASTRAL_PhyParts"
    
    phyparts_number=$(find ${o}/06-Coalescent-based_trees/1to1/02-rerooted_gene_trees -type f -name "*_rr.tre" | wc -l)
    python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py \
    ${o}/06-Coalescent-based_trees/1to1/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_1to1.tre \
    ASTRAL_PhyParts ${phyparts_number} \
    --svg_name ASTRAL_PhyPartsPieCharts_${prefix}_1to1.svg \
    --to_csv
  
    stage4_cmd "python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py ${o}/06-Coalescent-based_trees/1to1/04-ASTRAL_final_trees/ASTRAL_final_ordered_${prefix}_1to1.tre ASTRAL_PhyParts ${phyparts_number} --svg_name PhypartsPiecharts_${prefix}_1to1.svg --to_csv"
    if [ -s "${o}/06-Coalescent-based_trees/1to1/05-PhyParts_PieCharts/ASTRAL_PhyPartsPieCharts_${prefix}_1to1.svg" ]; then
      stage4_info "ASTRAL step6 has been finished."
    else
      stage4_error "Fail to run phypartspiecharts.py."
      stage4_blank ""
    fi
  fi
  # wASTRAL #################
  if [ "${run_wastral}" = "TRUE" ]; then
    java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar \
    -a 1 -v -d ${o}/06-Coalescent-based_trees/1to1/02-rerooted_gene_trees \
    -m ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_1to1.tre \
    -o ${o}/06-Coalescent-based_trees/1to1/05-PhyParts_PieCharts/wASTRAL_PhyParts &> /dev/null
    stage4_cmd "java -jar ${script_dir}/../dependencies/phypartspiecharts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar -a 1 -v -d ${o}/06-Coalescent-based_trees/1to1/02-rerooted_gene_trees -m ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_1to1.tre -o ${o}/06-Coalescent-based_trees/1to1/05-PhyParts_PieCharts/wASTRAL_PhyParts"
    
    phyparts_number=$(find ${o}/06-Coalescent-based_trees/1to1/02-rerooted_gene_trees -type f -name "*_rr.tre" | wc -l)
    python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py \
    ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_1to1.tre \
    wASTRAL_PhyParts ${phyparts_number} \
    --svg_name wASTRAL_PhyPartsPieCharts_${prefix}_1to1.svg \
    --to_csv
  
    stage4_cmd "python3 ${script_dir}/../dependencies/phypartspiecharts/phypartspiechart.py ${o}/06-Coalescent-based_trees/1to1/04-wASTRAL_final_trees/wASTRAL_final_ordered_${prefix}_1to1.tre wASTRAL_PhyParts ${phyparts_number} --svg_name PhypartsPiecharts_${prefix}_1to1.svg --to_csv"
    if [ -s "${o}/06-Coalescent-based_trees/1to1/05-PhyParts_PieCharts/wASTRAL_PhyPartsPieCharts_${prefix}_1to1.svg" ]; then
      stage4_info "ASTRAL/wASTRAL step6 has been finished."
    else
      stage4_error "Fail to run phypartspiecharts.py."
      stage4_blank ""
    fi
  fi
  ##############################
  #07: ASTRAL/wASTRAL conclusion
  ##############################
  stage4_blank ""
  stage4_info "All steps of running ASTRAL/wASTRAL for 1to1 alignments have been finished"
  stage4_blank "                    Now moving on to running ASTRAL for alignments produced by other algorithms..."
  stage4_blank ""
fi
#Conclusion
if [ "${run_to_trees}" = "true" ]; then
  stage4_info "Congratulations! The HybSuite pipeline stage1 to stage4 has been successfully finished."
  stage4_blank ""
  echo "                    HybSuite exits."
  stage4_blank ""
  exit 1
fi

#===> Stage 5 Conflicting quantification <===#