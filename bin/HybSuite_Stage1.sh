#!usr/bin/bash
#!/bin/bash
# Script Name: HybSuite.sh
# Author: Yuxuan Liu
#===> Preparation and HybSuite Checking <===#
#Options setting
###set the run name:
current_time=$(date +"%Y-%m-%d %H:%M:%S")
function display_help {
  echo "################################################################################"
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
  echo "            /_/         HybSuite_Stage1.sh"
  echo ""
  echo "HybSuite_Stage1.sh is a bash script which is used to construct your NGS dataset."
  sed -n '6,$p' ../config/HybSuite_Stage1_help.txt
}

# Function to display the version number
function display_version {
  echo "################################################################################"
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
  echo "            /_/         HybSuite_Stage1.sh"
  echo "                        Version: 1.1.0"
  echo ""
  echo "HybSuite_Stage1.sh is a bash script which is used to construct your NGS dataset."
  echo "################################################################################"
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
done < ../config/HybSuite_Stage1_options_list.txt

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
  echo "################################################################################"
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
  echo "            /_/         HybSuite_Stage1.sh"
  echo ""
  echo "HybSuite_Stage1.sh is a bash script which is used to construct your NGS dataset."
  echo "################################################################################"
  echo ""
echo "[HybSuite-CMD]:     $0 $@"
if [[ $# -eq 0 ]]; then
  echo ""
  echo "[HybSuite-WARNING]: You didn't set any options ."
  echo "                    Please set necessary options to run HybSuite. (use -h to check options)"
  echo "                    HybSuite_Stage1 exits."
  echo ""
  exit 1
fi

if [[ $# -eq 0 ]]; then
  echo "[HybSuite-WARNING]: Except the first option, you didn't set any other required options."
  echo "                    Please set required options to run HybSuite. (use -h to check options)"
  echo "                    HybSuite_Stage1 exits."
  echo ""
  exit 1
fi

while [[ $# -gt 1 ]]; do
    if [[ "$1" != -* ]]; then
        echo "[HybSuite-ERROR]:   Invalid option '$1'. Options should start with '-'."
        echo "                    HybSuite_Stage1 exits."
        echo ""
        exit 1 
    fi
    case "$1" in
        -*)
            option="${1/-/}"
            vars=($(awk '{print $1}' ${script_dir}/../config/HybSuite_Stage1_options_list.txt))
            #echo "                    -$option: $2"
            if [[ "$2" = -* ]]; then
              option2="${2/-/}"
              if [[ " ${vars[*]} " == *" $option2 "* ]]; then
                echo ""
                echo "[HybSuite-WARNING]: The argument for option $1 is not permitted to start with '-'"
                echo "                    Please change your argument for the option $1."
                echo "[HybSuite-WARNING]: Or you didn't specify any argument for the option $1."
                echo "                    Please specify an argument for the option $1."
                echo "                    HybSuite_Stage1 exits."
                echo ""
                exit 1
              fi
            fi  
            if [[ -z "$2" ]]; then
              echo ""
              echo "[HybSuite-ERROR]:   You didn't specify any argument for the option $1 "
              echo "                    Please specify an argument for the option $1."
              echo "                    HybSuite_Stage1 exits."
              echo ""
              exit 1
            fi
            if [[ " ${vars[*]} " == *" $option "* ]]; then
              if [ "${2: -1}" = "/" ]; then
                eval "${option}=\"${2%/}\""
              else
                eval "${option}=\"$2\""
              fi
              eval "found_${option}=true"
              echo "$option" >> ./Option-list.txt
              shift 2
            else
              echo ""
              echo "[HybSuite-ERROR]:   -$option is an invalid option."
              echo "                    Please check the help document and use right options."
              echo "                    HybSuite_Stage1 exits."
              echo ""
              exit 1
            fi
            ;;
        *)
            shift
            ;;
    esac
done
cut -f 1 ${script_dir}/../config/HybSuite_Stage1_options_list.txt > ./Option-all-list.txt
sort ./Option-all-list.txt ./Option-list.txt|uniq -u > ./Option-default-list.txt

while read -r line; do
    default_var="Default_${line}"
    default_value="${!default_var}"
    eval "default_value=${default_value}"
    eval "${line}=\"${default_value}\""
done < ./Option-default-list.txt
rm ./Option*

if [ -s "${i}/SRR_Spname.txt" ]; then
  sed -i '/^$/d' "${i}/SRR_Spname.txt"
fi
if [ -s "${i}/My_Spname.txt" ]; then
  sed -i '/^$/d' "${i}/My_Spname.txt"
fi

cd ${i}
###01 The SRA_toolkit will be used to download the species list of its public data (NCBI_Spname_list.txt) and the species list of the newly added, uncleaned original sequencing data (My_Spname.txt). Merge all new species lists with uncleaned data (All_new_Spname.txt)
> "${o}/All_Spname_list.txt"
if [ -s "./SRR_Spname.txt" ]; then
  cut -f 1 ./SRR_Spname.txt > ${o}/NCBI_SRR_list.txt
  cut -f 2 ./SRR_Spname.txt > ${o}/NCBI_Spname_list.txt
  if [ ! -s "./My_Spname.txt" ]; then
    cp ${o}/NCBI_Spname_list.txt ${o}/All_Spname_list.txt
  fi
fi
if [ -s "${i}/My_Spname.txt" ]; then
  if [ ! -s "${i}/SRR_Spname.txt" ]; then
    cp ./My_Spname.txt ${o}/All_Spname_list.txt
  else
    sed -e '$a\' "${o}/NCBI_Spname_list.txt" > "${o}/NCBI_Spname_list2.txt"
    sed -e '$a\' ${i}/My_Spname.txt > ${i}/My_Spname2.txt
    cat ${o}/NCBI_Spname_list2.txt ${i}/My_Spname2.txt > ${o}/All_Spname2.txt
    sed '/^$/d' ${o}/All_Spname2.txt > ${o}/All_Spname_list.txt
    rm ${o}/All_Spname2.txt
    rm ${o}/NCBI_Spname_list2.txt
    rm ${i}/My_Spname2.txt
  fi
fi
### Preparation for logs
stage0_info() {
  echo "[HybSuite-INFO]:    $1" | tee -a "${o}/HybSuite_Checking_${current_time}.log"
}
stage0_info2() {
  echo "[HybSuite-INFO]:$1" | tee -a "${o}/HybSuite_Checking_${current_time}.log"
}
stage0_warning() {
  echo "[HybSuite-WARNING]: $1" | tee -a "${o}/HybSuite_Checking_${current_time}.log"
}
stage0_attention() {
  echo "[ATTENTION]:        $1" | tee -a "${o}/HybSuite_Checking_${current_time}.log"
}
stage0_error() {
  echo "[HybSuite-ERROR]:   $1" | tee -a "${o}/HybSuite_Checking_${current_time}.log"
}
stage0_cmd() {
  echo "[HybSuite-CMD]:     $1" | tee -a "${o}/HybSuite_Checking_${current_time}.log"
}
stage0_blank() {
  echo "$1" | tee -a "${o}/HybSuite_Checking_${current_time}.log"
}
stage0_blank2() {
  echo "                    $1" | tee -a "${o}/HybSuite_Checking_${current_time}.log"
}
#HybSuite CHECKING
#Step 1: Check necessary options
if [ "${skip_checking}" != "TRUE" ]; then
  stage0_blank ""
  stage0_info "<<<======= HybSuite CHECKING =======>>>"
  stage0_info "HybSuite will provide tips with [ATTENTION]."
  stage0_info "HybSuite will alert you to incorrect arguments with [HybSuite-WARNING]:."
  stage0_info "HybSuite will notify you of missing software with [HybSuite-ERROR], and then it will exit."
  stage0_blank ""
  stage0_info2 " => Step 1: Check necessary options" 
  stage0_info "Check if you have entered all necessary options ... "
  ###Verify if the user has entered the necessary parameters
  if [ "${i}" = "_____" ] || [ "${conda1}" = "_____" ] || [ "${o}" = "_____" ]; then
    stage0_info "After checking:"
    stage0_error "You haven't set all the necessary options."
    stage0_blank "                    All required options must be set."
    stage0_blank "                    Including: "
    stage0_blank "                    -i"
    stage0_blank "                    -o"
    stage0_blank "                    -conda1"
    stage0_blank ""
    stage0_blank "                    HybSuite_Stage1 exits."
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

  if [ ! -s "${i}/SRR_Spname.txt" ] && [ ! -s "${i}/My_Spname.txt" ]; then
    stage0_info "After checking:"
    stage0_warning "You need to put at least one type of data (public/your own) in ${i}."
    stage0_blank "                    HybSuite_Stage1 exits."
    stage0_blank ""
    exit 1
  fi

  if [ -s "${i}/My_Spname.txt" ] && [ ! -e "${my_raw_data}" ]; then
    stage0_info "After checking:"
    stage0_warning "You need to specify the right pathway to your own raw data by -my_raw_data."
    stage0_blank "                    HybSuite_Stage1 exits."
    stage0_blank ""
    exit 1
  fi

  if [ ! -s "${i}/My_Spname.txt" ] && [ -e "${my_raw_data}" ]; then
    stage0_info "After checking:"
    stage0_warning "You need to offer the species list of your own raw data in ${i}/My_Spname.txt."
    stage0_blank "                    HybSuite_Stage1 exits."
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
          stage0_blank "                    HybSuite_Stage1 exits."
          stage0_blank ""
  				first_iteration=false
  				exit 1
  			fi
  		fi
  	done < ./My_Spname.txt
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
      stage0_blank "                    HybSuite_Stage1 exits."
      stage0_blank ""
      exit 1
    elif ! conda list -n "${conda1}" | grep -q "^sra-tools\b" && command -v prefetch >/dev/null 2>&1 && ! command -v fasterq-dump >/dev/null 2>&1; then
      stage0_info "No software 'sra-tools' is in the '${conda1}' conda environment, but it will be OK if you have installed SraToolKit on your system."
      stage0_error "It seems that you have downloaded SraToolKit on your system, but fasterq-dump hasn't been configured."
      stage0_blank "                    Please configure fasterq-dump."
      stage0_blank "                    HybSuite_Stage1 exits."
      stage0_blank ""
      exit 1
    elif ! conda list -n "${conda1}" | grep -q "^sra-tools\b" && ! command -v prefetch >/dev/null 2>&1 && command -v fasterq-dump >/dev/null 2>&1; then
      stage0_info "No software 'sra-tools' is in the '${conda1}' conda environment, but it will be OK if you have installed SraToolKit on your system."
      stage0_error "It seems that you have downloaded SraToolKit on your system, but prefetch hasn't been configured."
      stage0_blank "                    Please configure prefetch."
      stage0_blank "                    HybSuite_Stage1 exits."
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
    if [ -e "${o}/02-Downloaded_clean_data/" ]; then
      cd ${o}/02-Downloaded_clean_data/
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
        stage0_blank "                    HybSuite_Stage1 exits."
        stage0_blank ""
        exit 1
      else
        stage0_info "PASS"
        stage0_blank ""
      fi
    fi
  }

  trap '' SIGPIPE
  #run to dataset
  # conda1
  stage0_info "Check ${conda1} environment."
  stage0_info "Check dependencies in ${conda1} conda environment ... "
  # conda1: sra-tools
  check_sra_tools
  # conda1: pigz
  check_pigz

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

  if [ ! -s "./SRR_Spname.txt" ]; then 
    stage0_attention "You haven't prepared the SRR_Spname.txt for HybSuite(HybSuite)."
    stage0_info "It means that you only want to use your own data rather than data from NCBI."
    stage0_blank "                    It doesn't matter. HybSuite will keep running by only using your own data."
  fi

  if [ -s "./My_Spname.txt" ] && [ "$my_raw_data" = "_____" ]; then 
    stage0_attention "You haven't prepared any information about your own data for HybSuite(HybSuite)."
    stage0_blank "                    It means you plan to only use sra data from NCBI to reconstruct your phylogenetic trees. "
    stage0_blank "                    It is fine and don't worry! HybSuite will keep running by only using public data."
  fi
  stage0_info "Well done!"
  stage0_blank "                    All arguments are valid."
  stage0_blank "                    Moving on to the next step ..."
  stage0_blank ""
fi

if [ "${skip_checking}" != "TRUE" ]; then
  stage0_info2 " => Step 5: Check Species checklists"
  all_sp_num=$(grep -c '_' < ${o}/All_Spname_list.txt)
  all_genus_num=$(awk -F '_' '{print $1}' ${o}/All_Spname_list.txt|sort|uniq|grep -o '[A-Z]' | wc -l )
  awk -F '_' '{print $1}' ${o}/All_Spname_list.txt|sort|uniq > ./All_Genus_name_list.txt
  if [ -s "${i}/SRR_Spname.txt" ]; then
    SRR_sp_num=$(grep -c '_' < ${o}/NCBI_Spname_list.txt)
    SRR_genus_num=$(awk -F '_' '{print $1}' ${o}/NCBI_Spname_list.txt|sort|uniq|grep -o '[A-Z]' | wc -l)
  fi
  if [ -s "${i}/My_Spname.txt" ]; then
    Add_sp_num=$(grep -c '_' < ${o}/My_Spname.txt)
    Add_genus_num=$(awk -F '_' '{print $1}' ${i}/My_Spname.txt|sort|uniq|grep -o '[A-Z]'|wc -l)
  fi
  if [ -s "${i}/Other_seqs_Spname.txt" ]; then
    Other_sp_num=$(grep -c '_' < ${o}/Other_seqs_Spname.txt)
    Other_genus_num=$(awk -F '_' '{print $1}' ${o}/Other_seqs_Spname.txt|sort|uniq|grep -o '[A-Z]'|wc -l)
  fi
  if [ -s "./NCBI_Spname_list.txt" ]; then
    rm ${o}/NCBI_Spname_list.txt
  fi
fi

if [ "${skip_checking}" != "TRUE" ]; then
  stage0_info "After checking:"
  stage0_info "Your dataset includes ${all_sp_num} taxon which belong to ${all_genus_num} genera"
  stage0_info "(1) Taxonomy:"

  while IFS= read -r line || [ -n "$line" ]; do
    num=$(grep -c "$line" ${o}/All_Spname_list.txt)
    stage0_blank "                    ${num} species belong to the genus ${line}"
  done < ${o}/All_Genus_name_list.txt
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
  
  # Read the answer entered by the user
  stage0_info "All in all, the final results will be output to ${o}/"
  stage0_blank ""
  stage0_info2 " => According to the above feedbacks,"
  stage0_blank "                    proceed to run HybSuite? ([y]/n)"
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
    stage0_blank "                    HybSuite_Stage1 exits."
    stage0_blank ""
    exit 1
  else
    stage0_blank ""
    stage0_error "Sorry, ${answer} is not a valid answer."
    stage0_blank "                    Please input y (yes) or n (no)."
    stage0_blank "                    HybSuite_Stage1 exits."
    stage0_blank ""
    exit 1
  fi
fi

#===> Stage 1 NGS dataset construction <===#
stage1_info() {
  echo "[HybSuite-INFO]:    $1" | tee -a "${o}/Stage1_NGS_dataset_construction_${current_time}.log"
}
stage1_error() {
  echo "[HybSuite-ERROR]:   $1" | tee -a "${o}/Stage1_NGS_dataset_construction_${current_time}.log"
}
stage1_cmd() {
  echo "[HybSuite-CMD]:     $1" | tee -a "${o}/Stage1_NGS_dataset_construction_${current_time}.log"
}
stage1_blank() {
  echo "$1" | tee -a "${o}/Stage1_NGS_dataset_construction_${current_time}.log"
}
database_chars="01-Downloaded_raw_data/01-Raw-reads_sra 01-Downloaded_raw_data/02-Raw-reads_fastq_gz 02-Downloaded_clean_data 03-My_clean_data"
for dir in ${database_chars}; do
    mkdir -p "${o}/${dir}"
done
#1. Use sratoolkit to batch download sra data, then use fasterq-dump to convert the original sra data to fastq/fastq.gz format, and decide whether to delete sra data according to the parameters provided by the user
if [ -s "${o}/Stage1_NGS_database_construction_${current_time}.log" ]; then
  rm "${o}/Stage1_NGS_database_construction_${current_time}.log"
fi
stage1_blank ""
stage1_info "<<<======= Stage1 NGS dataset construction=======>>>"
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
    stage1_blank "                    HybSuite_Stage1 exits."
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
if [ -e "${o}/NCBI_SRR_list.txt" ]; then
  while IFS= read -r line || [ -n "$line" ]; do
    srr=$(echo "${line}" | awk '{print $1}')
    spname=$(echo "${line}" | awk '{print $2}')
    #if the user choose the format of downloading as fastq.gz
    if [ "$download_format" = "fastq_gz" ]; then
      if ([ ! -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq.gz" ] && [ ! -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq.gz" ]) \
      && [ ! -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq.gz" ] \
      && ([ ! -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq" ] && [ ! -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq" ]) \
      && [ ! -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq" ]; then
        # prefetch
        stage1_info "Downloading $srr.sra ... "
        prefetch "$srr" -O ${o}/01-Downloaded_raw_data/01-Raw-reads_sra/
        stage1_cmd "prefetch \"$srr\" -O ${o}/01-Downloaded_raw_data/01-Raw-reads_sra/" \
       
        if [ -s ${o}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}.sra ]; then
          stage1_info "Successfully download $srr.sra" \
         
        else 
          stage1_error "Fail to download $srr.sra" \
         
        fi
        
        # fasterq-dump
        fasterq-dump ${o}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra -e ${nt_fasterq_dump} -p -O ${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/
        stage1_cmd "fasterq-dump ${o}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra -e ${nt_fasterq_dump} -p -O ${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/" \
       
       
        # pigz for single-ended
        if [ -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq" ]; then
          stage1_info "Successfully transform ${srr}.sra to ${srr}.fastq via fasterq-dump" \
       
          pigz -p ${nt_pigz} ${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq
          stage1_cmd "pigz -p ${nt_pigz} ${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq"
          if [ -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq.gz" ]; then
            stage1_info "Successfully comprass ${srr}.fastq to ${srr}.fastq.gz via pigz, using ${nt_pigz} threads" \
         
          else
            stage1_error "Fail to comprass ${srr}.fastq to ${srr}.fastq.gz via pigz"
          fi
        fi
        
        # pigz for paired-end
        if [ -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq" ] && [ -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq" ]; then
          stage1_info "Successfully transform ${srr}.sra to ${srr}_1.fastq and ${srr}_2.fastq via fasterq-dump"
          pigz -p ${nt_pigz} ${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq
          pigz -p ${nt_pigz} ${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq
          stage1_cmd "pigz -p ${nt_pigz} ${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq
                    pigz -p ${nt_pigz} ${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq"
          if [ -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq.gz" ] && [ -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq.gz" ]; then
            stage1_info "Successfully comprass ${srr}_1.fastq and ${srr}_2.fastq via pigz, using ${nt_pigz} threads"
          else
            stage1_error "Fail to comprass ${srr}_1.fastq and ${srr}_2.fastq via pigz"
          fi
        fi
        
        #remove srr files
        if [ "$rm_sra" != "FALSE" ]; then
          rm -r ${o}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}
          stage1_cmd "rm -r ${o}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}"
          stage1_info "Remove ${o}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}."          
        fi
      else
        stage1_info "Skip downloading $srr since it exists."
      fi
      
      #rename the files
      if [ -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq.gz" ] && [ -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq.gz" ]; then
        mv "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq.gz" "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq.gz"
        stage1_info "Successfully rename ${srr}_1.fastq.gz to ${spname}_1.fastq.gz in ${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/"
        mv "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq.gz" "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq.gz"
        stage1_info "Successfully rename ${srr}_2.fastq.gz to ${spname}_2.fastq.gz in ${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/"
        stage1_info "Successfully download paired-end raw data (fastq.gz) of the species ${spname} from NCBI."
        stage1_blank ""
      fi
      if [ -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq.gz" ]; then
        mv "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq.gz" "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq.gz"
        stage1_info "Successfully rename ${srr}.fastq.gz to ${spname}.fastq.gz in ${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/"
        stage1_info "Successfully download single-end raw data (fastq.gz) of the species ${spname} from NCBI."
        stage1_blank ""
      fi
    fi
    #if the user choose the format of downloading as fastq
    if [ "$download_format" = "fastq" ]; then
      if ([ ! -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq.gz" ] && [ ! -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq.gz" ]) \
      && [ ! -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq.gz" ] \
      && ([ ! -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq" ] && [ ! -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq" ]) \
      && [ ! -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq" ]; then
        # prefetch
        stage1_info "Downloading $srr.sra ... "
        prefetch "$srr" -O ${o}/01-Downloaded_raw_data/01-Raw-reads_sra/
        stage1_cmd "prefetch \"$srr\" -O ${o}/01-Downloaded_raw_data/01-Raw-reads_sra/" \
       
        if [ -s ${o}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}.sra ]; then
          stage1_info "Successfully download $srr.sra" \
         
        else 
          stage1_error "Fail to download $srr.sra" \
         
        fi
        
        # fasterq-dump
        fasterq-dump ${o}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra -e ${nt_fasterq_dump} -p -O ${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/
        stage1_cmd "fasterq-dump ${o}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra -e ${nt_fasterq_dump} -p -O ${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/" \
       
      else
        stage1_info "Skip downloading ${srr}(${spname}) since it exits."
      fi
      #rename the files
      if [ -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq" ] && [ -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq" ]; then
        mv "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq" "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq"
        stage1_info "Successfully rename ${srr}_1.fastq to ${spname}_1.fastq in ${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/"
        mv "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq" "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq"
        stage1_info "Successfully rename ${srr}_2.fastq to ${spname}_2.fastq in ${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/"
        stage1_info "Successfully download paired-end raw data (fastq) of the species ${spname} from NCBI."
        stage1_blank ""
      fi
      if [ -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq" ]; then
        mv "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq" "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq"
        stage1_info "Successfully rename ${srr}.fastq to ${spname}.fastq in ${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/"
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
cd ${o}
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
    if ([ -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq" ] && [ -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq" ]) \
    || ([ -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq.gz" ] && [ -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq.gz" ]); then
      if [ -s "${o}/02-Downloaded_clean_data/${spname}_1_clean.paired.fq.gz" ] && [ -s "${o}/02-Downloaded_clean_data/${spname}_2_clean.paired.fq.gz" ]; then
        stage1_info "Trimmomatic: Skip ${spname} as it's already been trimmed." > /dev/null
      else
        files1=(${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.f*)
        files2=(${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.f*)
        if [ ${#files1[@]} -gt 0 ] && [ ${#files2[@]} -gt 0 ]; then
          java -jar ${script_dir}/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar PE \
          -threads ${nt_trimmomatic} \
          -phred33 \
          ${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.f* ${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.f* \
          ./02-Downloaded_clean_data/${spname}_1_clean.paired.fq.gz ./02-Downloaded_clean_data/${spname}_1_clean.unpaired.fq.gz \
          ./02-Downloaded_clean_data/${spname}_2_clean.paired.fq.gz ./02-Downloaded_clean_data/${spname}_2_clean.unpaired.fq.gz \
          ILLUMINACLIP:${script_dir}/../dependencies/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10 \
          SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} \
          LEADING:${trimmomatic_leading_quality} \
          TRAILING:${trimmomatic_trailing_quality} \
          MINLEN:${trimmomatic_min_length} > /dev/null 2>&1
          
          stage1_cmd "java -jar ${script_dir}/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads ${nt_trimmomatic} -phred33 ${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.f* ${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.f* ./02-Downloaded_clean_data/${spname}_1_clean.paired.fq.gz ./02-Downloaded_clean_data/${spname}_1_clean.unpaired.fq.gz ./02-Downloaded_clean_data/${spname}_2_clean.paired.fq.gz ./02-Downloaded_clean_data/${spname}_2_clean.unpaired.fq.gz ILLUMINACLIP:${script_dir}/../dependencies/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} LEADING:${trimmomatic_leading_quality} TRAILING:${trimmomatic_trailing_quality} MINLEN:${trimmomatic_min_length}" > /dev/null     
  
          trfilename="${o}/02-Downloaded_clean_data/${spname}_2_clean.paired.fq.gz"  
          trfilesize=$(stat -c %s "$trfilename")
          if [ "$trfilesize" -lt 1024 ]; then
            rm ${o}/02-Downloaded_clean_data/${spname}_*_clean.paired.fq.gz
            stage1_error "Trimmomatic didn't produce any results about ${spname}." > /dev/null
          else
            stage1_info "Successfully trim adapters of the raw data for ${spname}, producing clean data ${spname}_1_clean.paired.fq.gz and ${spname}_2_clean.paired.fq.gz." > /dev/null
          fi
        fi
      fi
    fi
    #for single-ended
    if [ -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq" ] \
    || [ -s "${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq.gz" ]; then
      if [ -s "${o}/02-Downloaded_clean_data/${spname}_clean.single.fq.gz" ]; then
        stage1_info "Trimmomatic: Skip ${spname} as it's already been trimmed." > /dev/null 
      else  
        files3=(${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.f*)
        if [ ${#files3[@]} -gt 0 ]; then
          java -jar ${script_dir}/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar SE \
          -threads ${nt_trimmomatic} \
          -phred33 \
          ${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.f* \
          ${o}/02-Downloaded_clean_data/${spname}_clean.single.fq.gz \
          ILLUMINACLIP:${script_dir}/../dependencies/Trimmomatic-0.39/adapters/TruSeq3-SE.fa:2:30:10 \
          SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} \
          LEADING:${trimmomatic_leading_quality} \
          TRAILING:${trimmomatic_trailing_quality} \
          MINLEN:${trimmomatic_min_length} > /dev/null 2>&1
          
          stage1_cmd "     java -jar ${script_dir}/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar SE -threads ${nt_trimmomatic} -phred33 ${o}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.f* ${o}/02-Downloaded_clean_data/${spname}_clean.single.fq.gz ILLUMINACLIP:${script_dir}/../dependencies/Trimmomatic-0.39/adapters/TruSeq3-SE.fa:2:30:10 SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} LEADING:${trimmomatic_leading_quality} TRAILING:${trimmomatic_trailing_quality} MINLEN:${trimmomatic_min_length}" > /dev/null
          trfilename="${o}/02-Downloaded_clean_data/${spname}_clean.single.fq.gz" 
          trfilesize=$(stat -c %s "$trfilename") 
          if [ "$trfilesize" -lt 1024 ]; then
            rm ${o}/02-Downloaded_clean_data/${spname}_clean.single.fq.gz
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
      if [ -s "${o}/03-My_clean_data/${spname}_1_clean.paired.fq.gz" ] && [ -s "${o}/03-My_clean_data/${spname}_2_clean.paired.fq.gz" ]; then
        stage1_info "Trimmomatic: Skip ${spname} as it's already been trimmed." > /dev/null
      else
        files1=(${my_raw_data}/${spname}_1.f*)
        files2=(${my_raw_data}/${spname}_2.f*)
        if [ ${#files1[@]} -gt 0 ] && [ ${#files2[@]} -gt 0 ]; then
          java -jar ${script_dir}/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar PE \
          -threads ${nt_trimmomatic} \
          -phred33 \
          ${my_raw_data}/${spname}_1.f* ${my_raw_data}/${spname}_2.f* \
          ${o}/03-My_clean_data/${spname}_1_clean.paired.fq.gz ${o}/03-My_clean_data/${spname}_1_clean.unpaired.fq.gz \
          ${o}/03-My_clean_data/${spname}_2_clean.paired.fq.gz ${o}/03-My_clean_data/${spname}_2_clean.unpaired.fq.gz \
          ILLUMINACLIP:${script_dir}/../dependencies/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10 \
          SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} \
          LEADING:${trimmomatic_leading_quality} \
          TRAILING:${trimmomatic_trailing_quality} \
          MINLEN:${trimmomatic_min_length} > /dev/null 2>&1
          stage1_cmd "java -jar ${script_dir}/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads ${nt_trimmomatic} -phred33 ${my_raw_data}/${spname}_1.f* ${my_raw_data}/${spname}_2.f* ${o}/03-My_clean_data/${spname}_1_clean.paired.fq.gz ${o}/03-My_clean_data/${spname}_1_clean.unpaired.fq.gz ${o}/03-My_clean_data/${spname}_2_clean.paired.fq.gz ${o}/03-My_clean_data/${spname}_2_clean.unpaired.fq.gz ILLUMINACLIP:${script_dir}/../dependencies/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} LEADING:${trimmomatic_leading_quality} TRAILING:${trimmomatic_trailing_quality} MINLEN:${trimmomatic_min_length}" > /dev/null
          
          trfilename="${o}/03-My_clean_data/${spname}_1_clean.paired.fq.gz" 
          trfilesize=$(stat -c %s "$trfilename") 
          if [ "$trfilesize" -lt 1024 ]; then
            rm ${o}/03-My_clean_data/${spname}_*_clean.paired.fq.gz
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
      if [ -s "${o}/03-My_clean_data/${spname}_clean.single.fq.gz" ]; then
        stage1_info "Trimmomatic: Skip ${spname} as it's already been trimmed." > /dev/null  
      else  
        files3=(${my_raw_data}/${spname}.f*)
        if [ ${#files3[@]} -gt 0 ]; then
          java -jar ${script_dir}/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar SE \
          -threads ${nt_trimmomatic} \
          -phred33 \
          ${my_raw_data}/${spname}.f* \
          ${o}/03-My_clean_data/${spname}_clean.single.fq.gz \
          ILLUMINACLIP:${script_dir}/../dependencies/Trimmomatic-0.39/adapters/TruSeq3-SE.fa:2:30:10 \
          SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} \
          LEADING:${trimmomatic_leading_quality} \
          TRAILING:${trimmomatic_trailing_quality} \
          MINLEN:${trimmomatic_min_length} > /dev/null 2>&1
          stage1_cmd "java -jar ${script_dir}/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar SE -threads ${nt_trimmomatic} -phred33 ${my_raw_data}/${spname}.f* ${o}/03-My_clean_data/${spname}_clean.single.fq.gz ILLUMINACLIP:${script_dir}/../dependencies/Trimmomatic-0.39/adapters/TruSeq3-SE.fa:2:30:10 SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} LEADING:${trimmomatic_leading_quality} TRAILING:${trimmomatic_trailing_quality} MINLEN:${trimmomatic_min_length}" > /dev/null
          
          trfilename="${o}/03-My_clean_data/${spname}_clean.single.fq.gz" 
          trfilesize=$(stat -c %s "$trfilename")
          if [ "$trfilesize" -lt 1024 ]; then
            rm ${o}/03-My_clean_data/${spname}_clean.single.fq.gz
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
stage1_blank "                    The NGS raw data and clean data have been output to ${o}"
stage1_blank "                    Enjoy your results!"
stage1_blank ""
