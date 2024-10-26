#!/usr/bin/bash
# Script Name: HybSuite.sh
# Author: Yuxuan Liu
#===> Preparation and HybSuite Checking <===#
#Options setting
###set the run name:
current_time=$(date +"%Y-%m-%d %H:%M:%S")
function display_help {
  echo ""
  echo "=======> HybSuite v. 1.1.0 released on 10.20.2024 by The Sun Lab. <==============="
  echo "Welcome to use HybSuite.sh! "
  echo "HybSuite is a bash script which is used to resolve phylogenomic issues on the basis of HybPiper."
  echo "It will help you reconstruct phylogenetic trees from NGS data by only one run, using HybPiper and ParaGone to find ortholog genes."
  echo "=================================================================================="
  echo "Developed by: Yuxuan Liu.
Contributors: Miao Sun, Yiying Wang, Xueqin Wang, Liguo Zhang, Tao Xiong , Xiaotong Niu, Xinru Zhang, Xiaowen Ma, Tianxiang Li.
Latest version: https://github.com/Yuxuanliu-HZAU/HybSuite.git
If you have any questions/problems/suggestions，please visit: https://github.com/Yuxuanliu-HZAU/HybSuite.git"
  echo "Or contact me via email: 1281096224@qq.com."
  echo "=================================================================================="
  echo ""
  echo "      >>>>  Only one run"
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
  echo "      >>>>  Only one run"
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
  echo "                        HybSuite Version: 1.1.0"
  echo ""
}

# Read the variable list file and set the default values
# Obtain the script path
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Switch to the script path
cd "$script_dir" || { echo "Error: Failed to change directory."; exit 1; }
while IFS= read -r line || [[ -n $line ]]; do
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
If you have any questions/problems/suggestions，please visit: https://github.com/Yuxuanliu-HZAU/HybSuite.git"
  echo "Or contact me via email: 1281096224@qq.com."
  echo "=================================================================================="
  echo ""
  echo "      >>>>  Only one run"
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
echo "[HybSuite-CMD]:     $0 $@"
echo "[HybSuite-INFO]:    HybSuite was called with these options:"
echo ""
if [[ $# -eq 0 ]]; then
  echo ""
  echo "[Warning]:          You didn't set any options ."
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
    echo "[Error]:            Invalid first option '$1'."
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
  echo "[Warning]:          Except the first option, you didn't set any other required options."
  echo "                    Please set required options to run HybSuite. (use -h to check options)"
  echo "                    HybSuite exits."
  echo ""
  exit 1
fi
if [[ "$2" = "--run_all" || "$2" = "--run_to_database" || "$2" = "--run_to_hybpiper" || "$2" = "--run_to_alignments" || "$2" = "--run_to_trees" ]]; then
    echo "[Error]:            Sorry, you can't specify the stage to run to more than once!"
    echo "                    Please specify one of '--run_all', '--run_to_database', '--run_to_hybpiper', '--run_to_alignments', or '--run_to_trees' only once!"
    echo "                    HybSuite exits."
    echo ""
    exit 1
fi

while [[ $# -gt 1 ]]; do
    if [[ "$2" != -* ]]; then
        echo "[Error]:            Invalid option '$2'. Options should start with '-'."
        echo "                    HybSuite exits."
        echo ""
        exit 1 
    fi
    case "$2" in
        -*)
            option="${2/-/}"
            vars=($(awk '{print $1}' ${script_dir}/../config/HybSuite_vars_list.txt))
            echo "                    -$option: $3"
            if [[ "$3" = -* ]]; then
              option3="${3/-/}"
              if [[ " ${vars[*]} " == *" $option3 "* ]]; then
                echo ""
                echo "[Warning]:          The argument for option $2 is not permitted to start with '-'"
                echo "                    Please change your argument for the option $2."
                echo "[Warning]:          Or you didn't specify any argument for the option $2."
                echo "                    Please specify an argument for the option $2."
                echo "                    HybSuite exits."
                echo ""
                exit 1
              fi
            fi  
            if [[ -z "$3" ]]; then
              echo ""
              echo "[Error]:            You didn't specify any argument for the option $2 "
              echo "                    Please specify an argument for the option $2."
              echo "                    HybSuite exits."
              echo ""
              exit 1
            fi
            if [[ " ${vars[*]} " == *" $option "* ]]; then
              eval "${option}=\"$3\""
              eval "found_${option}=true"
              echo "$option" >> ./Option-list.txt
              shift 2
            else
              echo ""
              echo "[Error]:            -$option is an invalid option."
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
    eval "${line}=\"$default_value\""
    echo "                    Default argument for -${line}: ${default_value}"
done < ./Option-default-list.txt
rm ./Option*

#Prompt and correct the parameters entered by the user:
if [ "${skip_checking}" != "TRUE" ]; then
  echo ""
  echo "[HybSuite-INFO]:    <<<======= HybSuite CHECKING =======>>>"
  echo "[HybSuite-INFO]:    HybSuite will inform you of some tips by [ATTENTION]."
  echo "[HybSuite-INFO]:    HybSuite will inform you of softwares which haven't been installed by [WARNING], after which HybSuite will exit."
  echo "[HybSuite-INFO]:    HybSuite will inform you of wrong arguments by [Warning], after which HybSuite will exit."
  echo ""
  echo "[HybSuite-INFO]:    <<===== Step1: Check necessary options =====>>" 
  echo "[HybSuite-INFO]:    Check if you have entered all necessary options ... "
  ###Verify if the user has entered the necessary parameters
  if [ "${i}" = "_____" ] || [ "${conda1}" = "_____" ] || [ "${conda2}" = "_____" ] || [ "${t}" = "_____" ]; then
    echo "[HybSuite-INFO]:    After verifing:"
    echo "[Warning]:          You need to set all required options."
    echo "                    Including: "
    echo "                    -i"
    echo "                    -t"
    echo "                    -conda1"
    echo "                    -conda2"
    if ([ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "$one_to_one" = "TRUE" ]) && [ "${conda3}" = "_____" ]; then
      echo "                    -conda3"
    fi
    echo "                    HybSuite exits."
    echo ""
    exit 1
  fi
  echo "[HybSuite-INFO]:    Well done!"
  echo "[HybSuite-INFO]:    You have entered all required options."
  echo "[HybSuite-INFO]:    Moving on to the next step ..."
  echo ""

  echo "[HybSuite-INFO]:    <<===== Step2: Check input directory and files  =====>>" 
  echo "[HybSuite-INFO]:    Check if you have prepared the right input directory and files ... "
  if [ ! -s "${t}" ]; then
    echo "[HybSuite-INFO]:    After checking:"
    echo "[Warning]:          The target file  (reference for HybPiper) you specified doesn't exist."
    echo "                    HybSuite exits."
    echo ""
    exit 1
  fi

  if [ ! -s "${i}/SRR_Spname.txt" ] && [ ! -s "${i}/My_Spname.txt" ]; then
    echo "[HybSuite-INFO]:    After checking:"
    echo "[Warning]:          You need to put at least one type of data (public/your own) in ${i}."
    echo "                    HybSuite exits."
    echo ""
    exit 1
  fi

  if [ -s "${i}/My_Spname.txt" ] && [ ! -e "${my_raw_data}" ]; then
    echo "[HybSuite-INFO]:    After checking:"
    echo "[Warning]:          You need to specify the right pathway to your own raw data by -my_raw_data."
    echo "                    HybSuite exits."
    echo ""
    exit 1
  fi

  if [ ! -s "${i}/My_Spname.txt" ] && [ -e "${my_raw_data}" ]; then
    echo "[HybSuite-INFO]:    After checking:"
    echo "[Warning]:          You need to offer the species list of your own raw data in ${i}/My_Spname.txt."
    echo "                    HybSuite exits."
    echo ""
    exit 1
  fi

  cd ${i}
  if [ -e "./My_Spname.txt" ] && [ "$my_raw_data" != "_____" ]; then
    first_iteration=true
  	while IFS= read -r add_sp_names || [[ -n $add_sp_names ]]; do
  		if ([ ! -s "${my_raw_data}/${add_sp_names}_1.fq" ] || [ ! -s "${my_raw_data}/${add_sp_names}_2.fq" ]) && ([ ! -s "${my_raw_data}/${add_sp_names}_1.fastq" ] || [ ! -s "${my_raw_data}/${add_sp_names}_2.fastq" ]) \
      && ([ ! -s "${my_raw_data}/${add_sp_names}.fq" ] && [ ! -s "${my_raw_data}/${add_sp_names}.fastq" ]) && ([ ! -s "${my_raw_data}/${add_sp_names}_1.fq.gz" ] || [ ! -s "${my_raw_data}/${add_sp_names}_2.fq.gz" ]) && ([ ! -s "${my_raw_data}/${add_sp_names}_1.fastq.gz" ] || [ ! -s "${my_raw_data}/${add_sp_names}_2.fastq.gz" ]) \
      && ([ ! -s "${my_raw_data}/${add_sp_names}.fq.gz" ] && [ ! -s "${my_raw_data}/${add_sp_names}.fastq.gz" ]); then
  			if [ "$first_iteration" = true ]; then
  				echo "[Warning]:          Option: -my_raw_data : The pathway to or the format of your own new raw data(format: fastq) of the species ${add_sp_names} is wrong."
  				echo "                    Please use -h to check the correct format you need to offer."
  				echo "                    HybSuite exits."
          echo ""
  				first_iteration=false
  				exit 1
  			fi
  		fi
  	done < ./My_Spname.txt
  fi

  # Checking Outgroup.txt
  if [ ! -s "${i}/Outgroup.txt" ]; then
    echo "[HybSuite-INFO]:    After checking:"
    echo "[Warning]:          You need to provide at least one species name of your outgroups in ${i}/Outgroup.txt."
    echo "                    HybSuite exits."
    echo ""
    exit 1
  fi
  while IFS= read -r line; do
    if [ -s "./SRR_Spname.txt" ] && [ -s "./My_Spname.txt" ]; then
      cut -f 2 ./SRR_Spname.txt > ./NCBI_Spname_list.txt
      if grep -q "^$line$" "./My_Spname.txt"; then
        echo "[HybSuite-INFO]:    Well done! Outgroup species '$line' exists in ${i}/My_Spname.txt"
      elif grep -q "^$line$" "./NCBI_Spname_list.txt"; then
        echo "[HybSuite-INFO]:    Well done! Outgroup species '$line' exists in ${i}/SRR_Spname.txt"
      else
        echo "[Warning]:          Your My_Spname.txt and SRR_Spname.txt don't contain any outgroup species."
    		echo "                    Please add your outgroup species names from ${i}/Outgroup.txt to either ${i}/SRR_Spname.txt or ${i}/My_Spname.txt."
    		echo "                    HybSuite exits."
        echo ""
        exit 1
      fi
      rm ./NCBI_Spname_list.txt
    fi
    if [ -s "./SRR_Spname.txt" ] && [ ! -s "./My_Spname.txt" ]; then
      cut -f 2 ./SRR_Spname.txt > ./NCBI_Spname_list.txt
      if grep -q "^$line$" "./NCBI_Spname_list.txt"; then
        echo "[HybSuite-INFO]:    Well done! Outgroup species '$line' exists in ${i}/SRR_Spname.txt"
      else
        echo "[Warning]:          You only offer SRR_Spname.txt in the input folder ${i}, but it doesn't contain any outgroup species."
    		echo "                    Please add your outgroup species names from ${i}/Outgroup.txt and thier corresponding SRR/ERR numbers to ${i}/SRR_Spname.txt."
    		echo "                    HybSuite exits."
        echo ""
        exit 1
      fi
      rm ./NCBI_Spname_list.txt
    fi
    if [ ! -s "./SRR_Spname.txt" ] && [ -s "./My_Spname.txt" ]; then
      if grep -q "^$line$" "./My_Spname.txt"; then
        echo "[HybSuite-INFO]:    Well done! Outgroup species '$line' exists in ${i}/My_Spname.txt"
      else
        echo "[Warning]:          You only offer My_Spname.txt in the input folder ${i}, but it doesn't contain any outgroup species."
    		echo "                    Please add your outgroup species names from ${i}/Outgroup.txt to ${i}/My_Spname.txt."
    		echo "                    HybSuite exits."
        echo ""
        exit 1
      fi
    fi    
  done < "./Outgroup.txt"

  # Deliever congratulations messages
  echo "[HybSuite-INFO]:    Well done!"
  echo "[HybSuite-INFO]:    You have prepared all necessary folders and files."
  echo "[HybSuite-INFO]:    Moving on to the next step ..."
  echo ""

  echo "[HybSuite-INFO]:    <<===== Step3: Check dependencies  =====>>" 
  ###Verify if all conda environments have the required dependency software installed
  echo "[HybSuite-INFO]:    Check if all conda environments have the required dependency softwares installed ... "
  #run to database
  if [ "${run_to_database}" = "true" ]; then
    #conda1
    echo "[HybSuite-INFO]:    Because you plan to only run stage1, HybSuite will only check ${conda1} environment."
    echo "[HybSuite-INFO]:    Check dependencies in ${conda1} conda environment ... "
    if [ "$download_format" = "fastq_gz" ] && [ -s "${i}/SRR_Spname.txt" ]; then
      echo "[HybSuite-INFO]:    You plan to download NGS data with fq.gz format to do downstream analysis, so 'pigz' must exist in conda environment ${conda1}."
      if ! grep -q "^pigz\b" <(conda list -n "${conda1}"); then
        echo "[Error]:            However, no software 'pigz' is in the conda environment ${conda1}."
        echo "                    You need to install 'pigz' in the conda environment ${conda1}."
        echo "[HybSuite-INFO]:    HybSuite exits."
        echo ""
        exit 1
      else
        echo "[HybSuite-INFO]:    PASS"
        echo ""
      fi
    fi
  fi
  
  #run to hybpiper
  if [ "${run_to_hybpiper}" = "true" ]; then
    #conda1
    echo "[HybSuite-INFO]:    Check dependencies in ${conda1} conda environment ... "
    if [ "$download_format" = "fastq_gz" ] && [ -s "${i}/SRR_Spname.txt" ]; then
      echo "[HybSuite-INFO]:    You plan to download NGS data with fq.gz format to do downstream analysis, so 'pigz' must exist in conda environment ${conda1}."
      if ! grep -q "^pigz\b" <(conda list -n "${conda1}"); then
        echo "[Error]:            However, no software 'pigz' is in the conda environment ${conda1}."
        echo "                    You need to install 'pigz' in the conda environment ${conda1}."
        echo "[HybSuite-INFO]:    HybSuite exits."
        echo ""
        exit 1
      else
        echo "[HybSuite-INFO]:    PASS"
        echo ""
      fi
    fi
    echo "[HybSuite-INFO]:    PASS"
    echo ""
    #conda2
    echo "[HybSuite-INFO]:    Check dependencies in ${conda2} conda environment ... "
    if ! grep -q "^hybpiper\b" <(conda list -n "${conda2}"); then
      echo "[Warning]:          There is no software named HybPiper in the conda environment ${conda2}."
      echo "                    You should install the software HybPiper in the conda environment ${conda2}."
      echo "                    HybSuite exits."
      echo ""
      exit 1
    else
      echo "[HybSuite-INFO]:    PASS"
      echo ""
    fi
  fi

  #run to alignments
  if [ "${run_to_alignments}" = "true" ]; then
    #conda1
    echo "[HybSuite-INFO]:    Check dependencies in ${conda1} conda environment ... "
    chars="phyx trimal mafft"
    for dir in ${chars}; do
      if ! grep -q "^${dir}\b" <(conda list -n "${conda1}"); then
        echo "[HybSuite-INFO]:    You plan to run from stage1 to stage3, so 'phyx', 'trimal', and 'mafft' must exist in conda environment ${conda1}."
        echo "[Error]:            However, no software ${dir} is in the conda environment ${conda1}."
        echo "                    You should install software ${dir} in ${conda1} environment."
        echo "                    HybSuite exits."
        echo ""
        exit 1
      fi
    done
    echo "[HybSuite-INFO]:    PASS"
    echo ""
    if [ "$download_format" = "fastq_gz" ] && [ -s "${i}/SRR_Spname.txt" ]; then
      echo "[HybSuite-INFO]:    Besides, You plan to download NGS data with fq.gz format to do downstream analysis, so 'pigz' must exist in conda environment ${conda1}."
      if ! grep -q "^pigz\b" <(conda list -n "${conda1}"); then
        echo "[Error]:            However, no software 'pigz' is in the conda environment ${conda1}."
        echo "                    You need to install 'pigz' in the conda environment ${conda1}."
        echo "                    HybSuite exits."
        echo ""
        exit 1
      else
        echo "[HybSuite-INFO]:    PASS"
        echo ""
      fi
    fi
    #conda2
    echo "[HybSuite-INFO]:    Check dependencies in ${conda2} conda environment ... "
    echo "[HybSuite-INFO]:    You plan to run HybPiper pipeline, so software 'HybPiper' must exist in your conda environment ${conda2}."
    if ! grep -q "^hybpiper\b" <(conda list -n "${conda2}"); then
      echo "[Warning]:          There is no software named HybPiper in the conda environment ${conda2}."
      echo "                    You should install the software HybPiper in the conda environment ${conda2}."
      echo "                    HybSuite exits."
      echo ""
      exit 1
    else
      echo "[HybSuite-INFO]:    PASS"
      echo ""
    fi
    #conda3
    echo "[HybSuite-INFO]:    Check dependencies in ${conda3} conda environment ... "
    if ([ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "$one_to_one" = "TRUE" ]); then
      echo "[HybSuite-INFO]:    You plan to run MI/MO/RT/1to1, so 'ParaGone' must exist in conda environment ${conda3}."
      if ! grep -q "^paragone\b" <(conda list -n "${conda3}"); then
        echo "[Error]:            However, no software ParaGone in the conda environment ${conda2}."
        echo "                    You should install the software ParaGone in the conda environment ${conda2}."
        echo "                    HybSuite exits."
        echo ""
        exit 1
      else
        echo "[HybSuite-INFO]:    PASS"
        echo ""
      fi
    fi
  fi

  #run to trees
  #conda1
  if [ "${run_to_trees}" = "true" ]; then
    #conda1
    echo "[HybSuite-INFO]:    Check dependencies in ${conda1} conda environment ... "
    echo "[HybSuite-INFO]:    You plan to run from stage1 to stage4, so 'phyx', 'trimal', 'mafft', 'r', 'python' must exist in conda environment ${conda1}."
    chars="phyx trimal mafft r python"
    for dir in ${chars}; do
      if ! grep -q "^${dir}\b" <(conda list -n "${conda1}"); then
        echo "[Error]:            However, no software ${dir} is in the conda environment ${conda1}."
        echo "                    You should install the software ${dir} in ${conda1} environment."
        echo "                    HybSuite exits."
        echo ""
        exit 1
      fi
    done
    if [ "${run_modeltest_ng}" != "TRUE" ]; then
      echo "[HybSuite-INFO]:    Plus, you plan to use Modeltest-NG to get the best evolution model, so 'modeltest-ng' must exist in conda environment ${conda1}."
      if ! grep -q "^modeltest-ng\b" <(conda list -n "${conda1}"); then
        echo "[Error]:            However, no software 'modeltest-ng' is in the conda environment ${conda1}."
        echo "                    You need to install 'modeltest-ng' in the conda environment ${conda1}."
        echo "                    HybSuite exits."
        echo ""
        exit 1
      else
        echo "[HybSuite-INFO]:    PASS"
        echo ""
      fi
    fi
    
    if [ "$download_format" = "fastq_gz" ] && [ -s "${i}/SRR_Spname.txt" ]; then
      echo "[HybSuite-INFO]:    Besides, you plan to download NGS data with fq.gz format to do downstream analysis, so 'pigz' must exist in conda environment ${conda1}."
      if ! grep -q "^pigz\b" <(conda list -n "${conda1}"); then
        echo "[Error]:            However, no software 'pigz' is in the conda environment ${conda1}."
        echo "                    You need to install 'pigz' in the conda environment ${conda1}."
        echo "                    HybSuite exits."
        echo ""
        exit 1
      else
        echo "[HybSuite-INFO]:    PASS"
        echo ""
      fi
    fi
    if [ "${run_iqtree}" = "TRUE" ]; then
      echo "[HybSuite-INFO]:    On top of that, you plan to run iqtree, so software 'iqtree' must exist in your conda environment ${conda1}."
      echo "[HybSuite-INFO]:    Check iqtree... "
      if ! grep -q "^iqtree\b" <(conda list -n "${conda1}"); then
        echo "[Error]:            However, no software 'iqtree' is in the conda environment ${conda1}."
        echo "                    You should install the software 'iqtree' in ${conda1} environment."
        echo "                    HybSuite exits."
        echo ""
        exit 1
      else
        echo "[HybSuite-INFO]:    PASS"
        echo ""
      fi
    fi
    if [ "${run_raxml}" = "TRUE" ]; then
      echo "[HybSuite-INFO]:    Futhermore, you plan to run raxml, so software 'raxml' must exist in your conda environment ${conda1}."
      echo "[HybSuite-INFO]:    Check raxml... "
      if ! grep -q "^raxml\b" <(conda list -n "${conda1}"); then
        echo "[Error]:            However, no software 'raxml' is in the conda environment ${conda1}."
        echo "                    You should install the software 'raxml' in ${conda1} environment."
        echo "                    HybSuite exits."
        echo ""
        exit 1
      else
        echo "[HybSuite-INFO]:    PASS"
        echo ""
      fi
    fi
    if [ "${run_raxml_ng}" = "TRUE" ]; then
      echo "[HybSuite-INFO]:    Plus, you plan to run raxml-ng, so software 'raxml-ng' must exist in your conda environment ${conda1}."
      echo "[HybSuite-INFO]:    Check raxml-ng... "
      if ! grep -q "^raxml-ng\b" <(conda list -n "${conda1}"); then
        echo "[Error]:            However, no software 'raxml-ng' is in the conda environment ${conda1}."
        echo "                    You should install the software 'raxml-ng' in ${conda1} environment."
        echo "                    HybSuite exits."
        echo ""
        exit 1
      else
        echo "[HybSuite-INFO]:    PASS"
        echo ""
      fi
    fi
    #conda2
    echo "[HybSuite-INFO]:    Check dependencies in ${conda2} conda environment ... "
    echo "[HybSuite-INFO]:    You plan to run HybPiper pipeline, so software 'HybPiper' must exist in your conda environment ${conda2}."
    if ! grep -q "^hybpiper\b" <(conda list -n "${conda2}"); then
      echo "[Warning]:          There is no software named HybPiper in the conda environment ${conda2}."
      echo "                    You should install the software HybPiper in the conda environment ${conda2}."
      echo "                    HybSuite exits."
      echo ""
      exit 1
    else
      echo "[HybSuite-INFO]:    PASS"
      echo ""
    fi
    #conda3
    echo "[HybSuite-INFO]:    Check dependencies in ${conda3} conda environment ... "
    if ([ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "$one_to_one" = "TRUE" ]); then
      echo "[HybSuite-INFO]:    You plan to run MI/MO/RT/1to1, so 'ParaGone' must exist in conda environment ${conda3}."
      if ! grep -q "^paragone\b" <(conda list -n "${conda3}"); then
        echo "[Error]:            However, no software ParaGone in the conda environment ${conda2}."
        echo "                    You should install the software ParaGone in the conda environment ${conda2}."
        echo "                    HybSuite exits."
        echo ""
        exit 1
      else
        echo "[HybSuite-INFO]:    PASS"
        echo ""
      fi
    fi
  fi

  #run all
  #conda1
  if [ "${run_all}" = "true" ]; then
    #conda1
    echo "[HybSuite-INFO]:    Check dependencies in ${conda1} conda environment ... "
    echo "[HybSuite-INFO]:    You plan to run all stages, so 'phyx', 'trimal', 'mafft', 'r', 'python' must exist in conda environment ${conda1}."
    chars="phyx trimal mafft r python"
    for dir in ${chars}; do
      if ! grep -q "^${dir}\b" <(conda list -n "${conda1}"); then
        echo "[Error]:            However, no software ${dir} is in the conda environment ${conda1}."
        echo "                    You should install the software ${dir} in ${conda1} environment."
        echo "                    HybSuite exits."
        echo ""
        exit 1
      fi
    done
    if [ "$download_format" = "fastq_gz" ] && [ -s "${i}/SRR_Spname.txt" ]; then
      echo "[HybSuite-INFO]:    Besides, you plan to download NGS data with fq.gz format to do downstream analysis, so 'pigz' must exist in conda environment ${conda1}."
      if ! grep -q "^pigz\b" <(conda list -n "${conda1}"); then
        echo "[Error]:            However, no software 'pigz' is in the conda environment ${conda1}."
        echo "                    You need to install 'pigz' in the conda environment ${conda1}."
        echo "                    HybSuite exits."
        echo ""
        exit 1
      else
        echo "[HybSuite-INFO]:    PASS"
        echo ""
      fi
    fi
    if [ "${run_iqtree}" = "TRUE" ]; then
      echo "[HybSuite-INFO]:    On top of that, you plan to run iqtree, so software 'iqtree' must exist in your conda environment ${conda1}."
      echo "[HybSuite-INFO]:    Check iqtree... "
      if ! grep -q "^iqtree\b" <(conda list -n "${conda1}"); then
        echo "[Error]:            However, no software 'iqtree' is in the conda environment ${conda1}."
        echo "                    You should install the software 'iqtree' in ${conda1} environment."
        echo "                    HybSuite exits."
        echo ""
        exit 1
      else
        echo "[HybSuite-INFO]:    PASS"
        echo ""
      fi
    fi
    if [ "${run_raxml}" = "TRUE" ]; then
      echo "[HybSuite-INFO]:    Futhermore, you plan to run raxml, so software 'raxml' must exist in your conda environment ${conda1}."
      echo "[HybSuite-INFO]:    Check raxml... "
      if ! grep -q "^raxml\b" <(conda list -n "${conda1}"); then
        echo "[Error]:            However, no software 'raxml' is in the conda environment ${conda1}."
        echo "                    You should install the software 'raxml' in ${conda1} environment."
        echo "                    HybSuite exits."
        echo ""
        exit 1
      else
        echo "[HybSuite-INFO]:    PASS"
        echo ""
      fi
    fi
    if [ "${run_raxml_ng}" = "TRUE" ]; then
      echo "[HybSuite-INFO]:    Plus, you plan to run raxml-ng, so software 'raxml-ng' must exist in your conda environment ${conda1}."
      echo "[HybSuite-INFO]:    Check raxml-ng... "
      if ! grep -q "^raxml-ng\b" <(conda list -n "${conda1}"); then
        echo "[Error]:            However, no software 'raxml-ng' is in the conda environment ${conda1}."
        echo "                    You should install the software 'raxml-ng' in ${conda1} environment."
        echo "                    HybSuite exits."
        echo ""
        exit 1
      else
        echo "[HybSuite-INFO]:    PASS"
        echo ""
      fi
    fi
    #conda2
    echo "[HybSuite-INFO]:    Check dependencies in ${conda2} conda environment ... "
    echo "[HybSuite-INFO]:    You plan to run HybPiper pipeline, so software 'HybPiper' must exist in your conda environment ${conda2}."
    if ! grep -q "^hybpiper\b" <(conda list -n "${conda2}"); then
      echo "[Warning]:          There is no software named HybPiper in the conda environment ${conda2}."
      echo "                    You should install the software HybPiper in the conda environment ${conda2}."
      echo "                    HybSuite exits."
      echo ""
      exit 1
    else
      echo "[HybSuite-INFO]:    PASS"
      echo ""
    fi
    #conda3
    echo "[HybSuite-INFO]:    Check dependencies in ${conda3} conda environment ... "
    if ([ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "$one_to_one" = "TRUE" ]); then
      echo "[HybSuite-INFO]:    You plan to run MI/MO/RT/1to1, so 'ParaGone' must exist in conda environment ${conda3}."
      if ! grep -q "^paragone\b" <(conda list -n "${conda3}"); then
        echo "[Error]:            However, no software ParaGone in the conda environment ${conda2}."
        echo "                    You should install the software ParaGone in the conda environment ${conda2}."
        echo "                    HybSuite exits."
        echo ""
        exit 1
      else
        echo "[HybSuite-INFO]:    PASS"
        echo ""
      fi
    fi
  fi

  echo "[HybSuite-INFO]:    Well done!"
  echo "[HybSuite-INFO]:    You have installed all dependencies in conda environments."
  echo "[HybSuite-INFO]:    Moving on to the next step ..."
  echo ""

  echo "[HybSuite-INFO]:    <<===== Step4: Check if preftch and fasterq-dump have been configured  =====>>" 
  ###Verify if all dependencies have been configured.
  if [ -s "${i}/SRR_Spname.txt" ]; then
    echo "[HybSuite-INFO]:    You plan to download NGS raw data, so software 'sra-tools' must exist in your conda environment ${conda1}."
    echo "[HybSuite-INFO]:    Or both fasterq-dump and prefetch should have been figured and added to the system's environment variables."
    echo "[HybSuite-INFO]:    Check if fasterq-dump has been configured or sra-tools has been installed in ${conda1} environment... "
    if ! grep -q "^sra-tools\b" <(conda list -n "${conda1}") && ! command -v prefetch >/dev/null 2>&1 && ! command -v fasterq-dump >/dev/null 2>&1; then
      echo "[ERROR]:            No software 'sra-tools' is found in ${conda1} conda environment."
      echo "[ERROR]:            Or dependency fasterq-dump and prefetch haven't been configured and added to the system's environment variables."
      echo "                    You should install software 'sra-tools' in ${conda1} conda environment."
      echo "                    Or you can search for more information on https://github.com/glarue/fasterq_dump."
      echo "                    HybSuite exits."
      echo ""
      exit 1
    elif ! grep -q "^sra-tools\b" <(conda list -n "${conda1}") && command -v prefetch >/dev/null 2>&1 && ! command -v fasterq-dump >/dev/null 2>&1; then
      echo "[HybSuite-INFO]:    No software 'sra-tools' is in the '${conda1}' conda environment, but it will be OK if you have installed SraToolKit on your system."
      echo "[ERROR]:            It seems that you have downloaded SraToolKit on your system, but fasterq-dump hasn't been configured."
      echo "                    Please configure fasterq-dump."
      echo "                    HybSuite exits."
      echo ""
      exit 1
    elif ! grep -q "^sra-tools\b" <(conda list -n "${conda1}") && ! command -v prefetch >/dev/null 2>&1 && command -v fasterq-dump >/dev/null 2>&1; then
      echo "[HybSuite-INFO]:    No software 'sra-tools' is in the '${conda1}' conda environment, but it will be OK if you have installed SraToolKit on your system."
      echo "[ERROR]:            It seems that you have downloaded SraToolKit on your system, but prefetch hasn't been configured."
      echo "                    Please configure prefetch."
      echo "                    HybSuite exits."
      echo ""
      exit 1
    else
      echo "[HybSuite-INFO]:    PASS"
      echo "[HybSuite-INFO]:    Well done!"
      echo "[HybSuite-INFO]:    Both prefetch and fasterq-dump are ready."
      echo "[HybSuite-INFO]:    Moving on to the next step ..."
    fi
  else
    echo "[HybSuite-INFO]:    PASS"
  fi

  ###Verify if all the options input by the user contain valid parameters
  echo ""
  echo "[HybSuite-INFO]:    <<===== Step5: Check if all arguments are valid =====>>" 
  echo "[HybSuite-INFO]:    Check if all arguments are valid ..."

  if [ "${eas_dir}" != "${o}/01-HybPiper_results/01-assemble" ]; then
    if [ ! -e "$(dirname "${eas_dir}")" ]; then
      echo "[HybSuite-INFO]:    After verifing:"
      echo "[Warning]:          The folder containing existed sequences generated by command 'hybpiper assemble' doesn't exist now."
      echo "                    Please check your parameters set by the option -eas . "
      echo "                    HybSuite exits."
      echo ""
      exit 1
    fi
  fi

  if [[ " ${i}" =~ .*/$ ]] || [[ "${my_raw_data}" =~ .*/$ ]] || [[ "${o}" =~ .*/$ ]] || [[ "${d}" =~ .*/$ ]]; then
    echo "[HybSuite-INFO]:    After verifing:"
    echo "[Warning]:          Remember, all the options in folder type mustn't have '/' in the end."
    echo "                    HybSuite exits."
    echo ""
    exit 1
  fi

  if [ ! -e "./SRR_Spname.txt" ]; then 
    echo "[ATTENTION]:        You haven't prepared the SRR_Spname.txt for HybSuite(HybSuite).\n  It means that you only want to use your own data rather than data from NCBI."
    echo "                    It doesn't matter. HybSuite will keep running by only using your own data."
    echo ""
  fi

  if [ ! -s "./My_Spname.txt" ] && [ "$my_raw_data" = "_____" ]; then 
    echo "[ATTENTION]:        You haven't prepared any information about your own data for HybSuite(HybSuite).\n  It means that you plan to only use sra data from NCBI to reconstruct your phylogenetic trees. "
    echo "                    It is fine and don't worry! HybSuite will keep running by only using public data."
  fi

  if (( $(echo "$spcover >= 0" | bc -l) )) && (( $(echo "$spcover <= 1" | bc -l) )); then
    echo ""
  else
    echo "[HybSuite-INFO]:    After verifing:"
    echo "[Warning]:          The value of -spcover should be larger than 0 and smaller than 1."
    echo "                    Please correct it . "
    echo "                    HybSuite exits."
    echo ""
    exit 1
  fi
  echo "[HybSuite-INFO]:    Well done!"
  echo "[HybSuite-INFO]:    All arguments are valid."
  echo "[HybSuite-INFO]:    Moving on to the next step ..."
  echo ""
  echo "[HybSuite-INFO]:    Congratulations! You have passed all verifings before running HybSuite."
  echo "[HybSuite-INFO]:    Now moving on to the preparation part ... "
  echo ""
fi

#The species list provided by the user is counted and the statistical result is given
echo "[HybSuite-INFO]:    <<<======= Step6: Produce and check Species checklists =======>>>"
cd ${i}
###01 The SRA_toolkit will be used to download the species list of its public data (NCBI_Spname_list.txt) and the species list of the newly added, uncleaned original sequencing data (My_Spname.txt). Merge all new species lists with uncleaned data (All_new_Spname.txt)
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

if [ "${skip_checking}" != "TRUE" ]; then
  ###02 The number and data type of each species in the species list provided by the user are calculated respectively, and assigned to the corresponding variables
  all_sp_num=$(grep -c '_' < ./All_Spname_list.txt)
  all_genus_num=$(awk -F '_' '{print $1}' ./All_Spname_list.txt|sort|uniq|grep -o '[A-Z]'|wc -l )
  awk -F '_' '{print $1}' ./All_Spname_list.txt|sort|uniq > ./All_Genus_name_list.txt
  if [ -s "${i}/SRR_Spname.txt" ]; then
  SRR_sp_num=$(grep -c '_' < ./NCBI_Spname_list.txt)
  SRR_genus_num=$(awk -F '_' '{print $1}' ./NCBI_Spname_list.txt|sort|uniq|grep -o '[A-Z]'|wc -l)
  fi
  if [ -s "${i}/My_Spname.txt" ]; then
  Add_sp_num=$(grep -c '_' < ./My_Spname.txt)
  Add_genus_num=$(awk -F '_' '{print $1}' ./My_Spname.txt|sort|uniq|grep -o '[A-Z]'|wc -l)
  fi
fi

#In combination with the species list provided by the user, the statistical result of the species list is given, and the prompt is given whether to continue to run HybSuite
if [ "${skip_checking}" != "TRUE" ]; then
  echo "[HybSuite-INFO]:    After checking:"
  echo "[HybSuite-INFO]:    HybSuite detects that you plan to reconstruct phylogenetic trees of ${all_sp_num} taxa which belong to ${all_genus_num} genera"
  echo "[HybSuite-INFO]:    (1) To be more specific, Among them,"

  while IFS= read -r line || [[ -n $line ]]; do
    num=$(grep -c "$line" ./All_Spname_list.txt)
    echo "[HybSuite-INFO]:    ${num} species belong to the genus ${line}"
  done < ./All_Genus_name_list.txt
  ref_num=$(grep -c '>' "${t}")
  echo "[HybSuite-INFO]:    (2) About data sources:"
  if [ -s "${i}/SRR_Spname.txt" ]; then
  echo "[HybSuite-INFO]:    ${SRR_sp_num} species belonging to ${SRR_genus_num} genera are downloaded from Genbank via Sratoolkit."
  fi
  if [ -s "${i}/My_Spname.txt" ]; then
  echo "[HybSuite-INFO]:    ${Add_sp_num} species belonging to ${Add_genus_num} genera are your own raw data which hasn't been cleaned."
  fi
  echo "[HybSuite-INFO]:    (3) Besides, you plan to use ${ref_num} sequences in the target file ${t} as reference."
  echo "[HybSuite-INFO]:    And then use HybPiper to capture orthologous genes."
  echo "[HybSuite-INFO]:    (4) The final results will be output to ${o}/"
  echo ""
  echo "[HybSuite-INFO]:    <<<======= Select whether to run HybSuite =======>>>"
  echo "[HybSuite-INFO]:    According to the above feedbacks, are you sure to run HybSuite? (y/n): "

  # Read the answer entered by the user
  read answer
  answer_HybSuite=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
  # Check the user's answers
  if [ "$answer_HybSuite" = "y" ]; then
    echo "[HybSuite-INFO]:    Fantastic! HybSuite will run according to your request ..."
  elif [ "$answer_HybSuite" = "n" ]; then
    echo ""
    echo "[Warning]:          It might be something dosen't satisfy your needs."
    echo "                    You can adjust the parameter settings or correct the filenames."
    echo "                    HybSuite exits."
    echo ""
    exit 1
  else
    echo "[HybSuite-INFO]:    Please input y (yes) or n (no)."
    echo "                    HybSuite exits."
    echo ""
    exit 1
  fi
fi

#===> Preparation.Folder creation and switching of conda environment <===#
#Create Folders：
###01 Create the desired folder
echo "[HybSuite-INFO]:    <<<======= Preparation: Create desired folders =======>>>"
echo "                    Finish"
#run to database and other stages
if [ "${run_to_database}" = "true" ] || [ "${run_all}" = "true" ] || [ "${run_to_hybpiper}" = "true" ] || [ "${run_to_alignments}" = "true" ] || [ "${run_to_trees}" = "true" ]; then
  database_chars="01-Downloaded_raw_data/01-Raw-reads_sra 01-Downloaded_raw_data/02-Raw-reads_fastq_gz 02-Downloaded_clean_data 03-My_clean_data"
  for dir in ${database_chars}; do
      mkdir -p "${d}/${dir}"
  done
  logs_chars="00-logs_and_checklists/logs 00-logs_and_checklists/species_checklists"
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
  logs_chars="00-logs_and_checklists/logs 00-logs_and_checklists/species_checklists"
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
  logs_chars="00-logs_and_checklists/logs 00-logs_and_checklists/species_checklists"
  for dir in ${logs_chars}; do
      mkdir -p "${o}/${dir}"
  done
  
  hybpiper_chars="01-HybPiper_results/01-assemble 01-HybPiper_results/02-stats 01-HybPiper_results/03-recovery_heatmap 01-HybPiper_results/04-retrieve_sequences 01-HybPiper_results/05-paralogs_all_fasta 01-HybPiper_results/06-paralogs_reports"
  for dir in ${hybpiper_chars}; do
    mkdir -p "${o}/${dir}"
  done
  
  if [ "${HRS}" = "TRUE" ]; then
    mkdir -p "${o}/02-Alignments/HRS"
  fi
  if [ "${RAPP}" = "TRUE" ]; then
    mkdir -p "${o}/02-Alignments/RAPP"
  fi
  if [ "${MO}" = "TRUE" ]; then
    mkdir -p "${o}/02-Alignments/MO"
  fi
  if [ "${MI}" = "TRUE" ]; then
    mkdir -p "${o}/02-Alignments/MI"
  fi
  if [ "${one_to_one}" = "TRUE" ]; then
    mkdir -p "${o}/02-Alignments/1to1"
  fi
fi

#run to trees
if [ "${run_to_trees}" = "true" ]; then
  database_chars="01-Downloaded_raw_data/01-Raw-reads_sra 01-Downloaded_raw_data/02-Raw-reads_fastq_gz 02-Downloaded_clean_data 03-My_clean_data"
  for dir in ${database_chars}; do
      mkdir -p "${d}/${dir}"
  done
  logs_chars="00-logs_and_checklists/logs 00-logs_and_checklists/species_checklists"
  for dir in ${logs_chars}; do
      mkdir -p "${o}/${dir}"
  done
  
  hybpiper_chars="01-HybPiper_results/01-assemble 01-HybPiper_results/02-stats 01-HybPiper_results/03-recovery_heatmap 01-HybPiper_results/04-retrieve_sequences 01-HybPiper_results/05-paralogs_all_fasta 01-HybPiper_results/06-paralogs_reports"
  for dir in ${hybpiper_chars}; do
    mkdir -p "${o}/${dir}"
  done
  
  if [ "${HRS}" = "TRUE" ]; then
    mkdir -p "${o}/02-Alignments/HRS"
  fi
  if [ "${RAPP}" = "TRUE" ]; then
    mkdir -p "${o}/02-Alignments/RAPP"
  fi
  if [ "${MO}" = "TRUE" ]; then
    mkdir -p "${o}/02-Alignments/MO"
  fi
  if [ "${MI}" = "TRUE" ]; then
    mkdir -p "${o}/02-Alignments/MI"
  fi
  if [ "${one_to_one}" = "TRUE" ]; then
    mkdir -p "${o}/02-Alignments/1to1"
  fi
  
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
fi

#run all
if [ "${run_all}" = "true" ]; then
  database_chars="01-Downloaded_raw_data/01-Raw-reads_sra 01-Downloaded_raw_data/02-Raw-reads_fastq_gz 02-Downloaded_clean_data 03-My_clean_data"
  for dir in ${database_chars}; do
      mkdir -p "${d}/${dir}"
  done
  logs_chars="00-logs_and_checklists/logs 00-logs_and_checklists/species_checklists"
  for dir in ${logs_chars}; do
      mkdir -p "${o}/${dir}"
  done
  
  hybpiper_chars="01-HybPiper_results/01-assemble 01-HybPiper_results/02-stats 01-HybPiper_results/03-recovery_heatmap 01-HybPiper_results/04-retrieve_sequences 01-HybPiper_results/05-paralogs_all_fasta 01-HybPiper_results/06-paralogs_reports"
  for dir in ${hybpiper_chars}; do
    mkdir -p "${o}/${dir}"
  done
  
  if [ "${HRS}" = "TRUE" ]; then
    mkdir -p "${o}/02-Alignments/HRS"
  fi
  if [ "${RAPP}" = "TRUE" ]; then
    mkdir -p "${o}/02-Alignments/RAPP"
  fi
  if [ "${MO}" = "TRUE" ]; then
    mkdir -p "${o}/02-Alignments/MO"
  fi
  if [ "${MI}" = "TRUE" ]; then
    mkdir -p "${o}/02-Alignments/MI"
  fi
  if [ "${one_to_one}" = "TRUE" ]; then
    mkdir -p "${o}/02-Alignments/1to1"
  fi
  
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
#Activate the conda1 environment

#Move the species checklists.
#logfile="${o}/00-logs_and_checklists/logs/HybSuite_${current_time}_log.txt"
#exec > >(tee -a "$logfile") 2>&1

if [ -s "${i}/NCBI_SRR_list.txt" ]; then
  mv ${i}/NCBI_SRR_list.txt ${o}/00-logs_and_checklists/species_checklists/
fi

if [ -s "${i}/All_Spname_list.txt" ]; then
  mv ${i}/All_Spname_list.txt ${o}/00-logs_and_checklists/species_checklists/
fi

if [ -s "${i}/NCBI_Spname_list.txt" ]; then
  mv ${i}/NCBI_Spname_list.txt ${o}/00-logs_and_checklists/species_checklists/
fi


#===> Stage1 NGS database construction <===#
#1. Use sratoolkit to batch download sra data, then use fasterq-dump to convert the original sra data to fastq/fastq.gz format, and decide whether to delete sra data according to the parameters provided by the user
if [ -s "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt" ]; then
  rm "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
fi
echo ""
echo "[HybSuite-INFO]:    <<<======= Stage1 NGS database construction=======>>>" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
echo "[HybSuite-INFO]:    <<<======= Preparation: Activate conda environment ${conda1} =======>>>" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
#source activate
if [ -z "$CONDA_DEFAULT_ENV" ]; then
  echo "[HybSuite-INFO]:    You didn't activate any conda environment, so HybSuite will help you activate ${conda1} environment."  | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
  eval "$(conda shell.bash hook)"
  conda activate "${conda1}"
  echo "[CMD]:              conda activate ${conda1}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
  if [ "$CONDA_DEFAULT_ENV" = "${conda1}" ]; then
    echo "[HybSuite-INFO]:    Successfully activate ${conda1} conda environment" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
    echo "                    PASS"  | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
    echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
  else
    echo "[Error]:            Fail to activate ${conda1} conda environment" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
    echo "                    HybSuite exits." | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
    echo ""
    exit 1
  fi
else
  echo "[HybSuite-INFO]:    You are now in conda environment ${conda1}, so HybSuite will skip activating ${conda1} conda environment."  | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
fi
if [ "${CONDA_DEFAULT_ENV}" != "${conda1}" ]; then
  echo "[HybSuite-INFO]:    You didn't activate conda environment ${conda1}, so HybSuite will help you activate ${conda1} environment."  | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
  eval "$(conda shell.bash hook)"
  conda activate "${conda1}"
  echo "[CMD]:              conda activate ${conda1}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
  if [ "$CONDA_DEFAULT_ENV" = "${conda1}" ]; then
    echo "[HybSuite-INFO]:    Successfully activate ${conda1} conda environment" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
    echo "                    PASS"  | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
    echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
  else
    echo "[Error]:            Fail to activate ${conda1} conda environment" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
    echo "                    HybSuite exits." | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
    echo ""
    exit 1
  fi
else
  echo "[HybSuite-INFO]:    You are now in conda environment ${conda1}, so HybSuite will skip activating ${conda1} conda environment."  | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
  eval "$(conda shell.bash hook)"
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
fi

echo "[HybSuite-INFO]:    Step1: Run SRAToolKit (prefetch and fasterq-dump)" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
if [ -e "${o}/00-logs_and_checklists/species_checklists/NCBI_SRR_list.txt" ]; then
  echo "[HybSuite-INFO]:    Downloading NGS raw data from NCBI via the command prefetch and fasterq-dump (SRAToolKit)..." | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
  while IFS= read -r line || [[ -n $line ]]; do
    srr=$(echo "${line}" | awk '{print $1}')
    spname=$(echo "${line}" | awk '{print $2}')
    #if the user choose the format of downloading as fastq.gz
    if [ "$download_format" = "fastq_gz" ]; then
      if ([ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq.gz" ] && [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq.gz" ]) \
      && [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq.gz" ] \
      && ([ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq" ] && [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq" ]) \
      && [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq" ]; then
        # prefetch
        echo "[HybSuite-INFO]:    Downloading $srr.sra ... " | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
        prefetch "$srr" -O ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/
        echo "[CMD]:              prefetch \"$srr\" -O ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/" \
        | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
        if [ -s ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}.sra ]; then
          echo "[HybSuite-INFO]:    Successfully download $srr.sra" \
          | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
        else 
          echo "[Warning]:          Fail to download $srr.sra" \
          | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
        fi
        
        # fasterq-dump
        fasterq-dump ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra -e ${nt_fasterq_dump} -p -O ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/
        echo "[CMD]:              fasterq-dump ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra -e ${nt_fasterq_dump} -p -O ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/" \
        | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
       
        # pigz for single-ended
        if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq" ]; then
          echo "[HybSuite-INFO]:    Successfully transform ${srr}.sra to ${srr}.fastq via fasterq-dump" \
        | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
          pigz -p ${nt_pigz} ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq
          echo "[CMD]:              pigz -p ${nt_pigz} ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
          if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq.gz" ]; then
            echo "[HybSuite-INFO]:    Successfully comprass ${srr}.fastq to ${srr}.fastq.gz via pigz, using ${nt_pigz} threads" \
          | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
          else
            echo "[Warning]:          Fail to comprass ${srr}.fastq to ${srr}.fastq.gz via pigz" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
          fi
        fi
        
        # pigz for pair-ended
        if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq" ] && [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq" ]; then
          echo "[HybSuite-INFO]:    Successfully transform ${srr}.sra to ${srr}_1.fastq and ${srr}_2.fastq via fasterq-dump" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
          pigz -p ${nt_pigz} ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq
          pigz -p ${nt_pigz} ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq
          echo "[CMD]:              pigz -p ${nt_pigz} ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq
                    pigz -p ${nt_pigz} ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
          if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq.gz" ] && [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq.gz" ]; then
            echo "[HybSuite-INFO]:    Successfully comprass ${srr}_1.fastq and ${srr}_2.fastq via pigz, using ${nt_pigz} threads" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
          else
            echo "[Warning]:          Fail to comprass ${srr}_1.fastq and ${srr}_2.fastq via pigz" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
          fi
        fi
        
        #remove the srr files
        if [ "$rm_sra" != "FALSE" ]; then
          rm -r ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}
          echo "[CMD]:              rm -r ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
          echo "[HybSuite-INFO]:    Remove ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}." | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"          
        fi
      else
        echo "[HybSuite-INFO]:    Skip downloading $srr since it exists." | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
      fi
      
      #rename the files
      if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq.gz" ] && [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq.gz" ]; then
        mv "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq.gz" "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq.gz"
        echo "[HybSuite-INFO]:    Successfully rename ${srr}_1.fastq.gz to ${spname}_1.fastq.gz in ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
        mv "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq.gz" "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq.gz"
        echo "[HybSuite-INFO]:    Successfully rename ${srr}_2.fastq.gz to ${spname}_2.fastq.gz in ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
        echo "[HybSuite-INFO]:    Successfully download paired-end raw data (fastq.gz) of the species ${spname} from NCBI." | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
        echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
      fi
      if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq.gz" ]; then
        mv "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq.gz" "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq.gz"
        echo "[HybSuite-INFO]:    Successfully rename ${srr}.fastq.gz to ${spname}.fastq.gz in ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
        echo "[HybSuite-INFO]:    Successfully download single-end raw data (fastq.gz) of the species ${spname} from NCBI." | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
        echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
      fi
    fi
    #if the user choose the format of downloading as fastq
    if [ "$download_format" = "fastq" ]; then
      if ([ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq.gz" ] && [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq.gz" ]) \
      && [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq.gz" ] \
      && ([ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq" ] && [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq" ]) \
      && [ ! -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq" ]; then
        # prefetch
        echo "[HybSuite-INFO]:    Downloading $srr.sra ... " | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
        prefetch "$srr" -O ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/
        echo "[CMD]:              prefetch \"$srr\" -O ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/" \
        | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
        if [ -s ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}.sra ]; then
          echo "[HybSuite-INFO]:    Successfully download $srr.sra" \
          | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
        else 
          echo "[Warning]:          Fail to download $srr.sra" \
          | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
        fi
        
        # fasterq-dump
        fasterq-dump ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra -e ${nt_fasterq_dump} -p -O ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/
        echo "[CMD]:              fasterq-dump ${d}/01-Downloaded_raw_data/01-Raw-reads_sra/${srr}/${srr}.sra -e ${nt_fasterq_dump} -p -O ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/" \
        | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
      else
        echo "[HybSuite-INFO]:    Skip downloading ${srr}(${spname}) since it exits."
      fi
      #rename the files
      if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq" ] && [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq" ]; then
        mv "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_1.fastq" "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq"
        echo "[HybSuite-INFO]:    Successfully rename ${srr}_1.fastq to ${spname}_1.fastq in ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
        mv "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}_2.fastq" "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq"
        echo "[HybSuite-INFO]:    Successfully rename ${srr}_2.fastq to ${spname}_2.fastq in ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
        echo "[HybSuite-INFO]:    Successfully download paired-end raw data (fastq) of the species ${spname} from NCBI." | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
        echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
      fi
      if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq" ]; then
        mv "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${srr}.fastq" "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq"
        echo "[HybSuite-INFO]:    Successfully rename ${srr}.fastq to ${spname}.fastq in ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
        echo "[HybSuite-INFO]:    Successfully download single-end raw data (fastq) of the species ${spname} from NCBI." | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
        echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
      fi
    fi
  done < ${i}/SRR_Spname.txt
fi

#2. Filter the raw data of NGS data via trimmomatic
#Trimmomatic for SRR_Spname.txt
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#2.1 Raw data filtering of NCBI public data (premise: the user provides SRR_Spname.txt and opts not to use the existing clean.paired.fq file)
echo "[HybSuite-INFO]:    Step2: Run Trimmomatic-0.39 to remove adapters of the raw data..." | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
cd ${d}
if [ -s "${i}/SRR_Spname.txt" ]; then
  while IFS= read -r line || [[ -n $line ]]; do
    spname=$(echo "${line}" | awk '{print $2}')
    #for pair-ended
    if ([ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq" ] && [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq" ]) \
    || ([ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.fastq.gz" ] && [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.fastq.gz" ]); then
      if [ -s "${d}/02-Downloaded_clean_data/${spname}_1_clean.paired.fq.gz" ] && [ -s "${d}/02-Downloaded_clean_data/${spname}_2_clean.paired.fq.gz" ]; then
        echo "[HybSuite-INFO]:    Trimmomatic: Skip ${spname} as it's already been trimmed." | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
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
          MINLEN:${trimmomatic_min_length}
          
          echo "[CMD]:         java -jar ${script_dir}/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads ${nt_trimmomatic} -phred33 ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_1.f* ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}_2.f* ./02-Downloaded_clean_data/${spname}_1_clean.paired.fq.gz ./02-Downloaded_clean_data/${spname}_1_clean.unpaired.fq.gz ./02-Downloaded_clean_data/${spname}_2_clean.paired.fq.gz ./02-Downloaded_clean_data/${spname}_2_clean.unpaired.fq.gz ILLUMINACLIP:${script_dir}/../dependencies/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} LEADING:${trimmomatic_leading_quality} TRAILING:${trimmomatic_trailing_quality} MINLEN:${trimmomatic_min_length}" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"      
  
          trfilename="${d}/02-Downloaded_clean_data/${spname}_2_clean.paired.fq.gz" # 替换为你的文件名  
          trfilesize=$(stat -c %s "$trfilename") # 获取文件大小（字节）
          if [ "$trfilesize" -lt 1024 ]; then
            rm ${d}/02-Downloaded_clean_data/${spname}_*_clean.paired.fq.gz
            echo "[Warning]:          Trimmomatic didn't produce any results about ${spname}." | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
          else
            echo "[HybSuite-INFO]:    Successfully trim adapters of the raw data for ${spname}, producing clean data ${spname}_1_clean.paired.fq.gz and ${spname}_2_clean.paired.fq.gz." | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
          fi
        fi
      fi
    fi
    #for single-ended
    if [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq" ] \
    || [ -s "${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.fastq.gz" ]; then
      if [ -s "${d}/02-Downloaded_clean_data/${spname}_clean.single.fq.gz" ]; then
        echo "[HybSuite-INFO]:    Trimmomatic: Skip ${spname} as it's already been trimmed." | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"  
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
          MINLEN:${trimmomatic_min_length}
          
          echo "[CMD]:              java -jar ${script_dir}/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar SE -threads ${nt_trimmomatic} -phred33 ${d}/01-Downloaded_raw_data/02-Raw-reads_fastq_gz/${spname}.f* ${d}/02-Downloaded_clean_data/${spname}_clean.single.fq.gz ILLUMINACLIP:${script_dir}/../dependencies/Trimmomatic-0.39/adapters/TruSeq3-SE.fa:2:30:10 SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} LEADING:${trimmomatic_leading_quality} TRAILING:${trimmomatic_trailing_quality} MINLEN:${trimmomatic_min_length}" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
          trfilename="${d}/02-Downloaded_clean_data/${spname}_clean.single.fq.gz" 
          trfilesize=$(stat -c %s "$trfilename") 
          if [ "$trfilesize" -lt 1024 ]; then
            rm ${d}/02-Downloaded_clean_data/${spname}_clean.single.fq.gz
            echo "[Warning]:          Trimmomatic didn't produce any results about ${spname}." | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
          else
            echo "[HybSuite-INFO]:    Successfully trim adapters of the raw data for ${spname}, producing clean data ${spname}_clean.paired.fq.gz." | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
          fi
        fi
      fi
    fi
  done < ${i}/SRR_Spname.txt
fi
#Trimmomatic for My_Spname.txt
#2.2 Filter the new self-test data (fastq format) (provided that the user provides My_Spname.txt and specifies the file path in the my_raw_data option)
if [ -s "${i}/My_Spname.txt" ] && [ "$my_raw_data" != "_____" ]; then
	while IFS= read -r spname || [[ -n $spname ]]; do
		#for pair-ended
    if ([ -s "${my_raw_data}/${spname}_1.fastq" ] && [ -s "${my_raw_data}/${spname}_2.fastq" ]) \
    || ([ -s "${my_raw_data}/${spname}_1.fq" ] && [ -s "${my_raw_data}/${spname}_2.fq" ]) \
    || ([ -s "${my_raw_data}/${spname}_1.fastq.gz" ] && [ -s "${my_raw_data}/${spname}_2.fastq.gz" ]) \
    || ([ -s "${my_raw_data}/${spname}_1.fq.gz" ] && [ -s "${my_raw_data}/${spname}_2.fq.gz" ]); then
      if [ -s "${d}/03-My_clean_data/${spname}_1_clean.paired.fq.gz" ] && [ -s "${d}/03-My_clean_data/${spname}_2_clean.paired.fq.gz" ]; then
        echo "[HybSuite-INFO]:    Trimmomatic: Skip ${spname} as it's already been trimmed."
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
          MINLEN:${trimmomatic_min_length}
          echo "[CMD]:              java -jar ${script_dir}/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads ${nt_trimmomatic} -phred33 ${my_raw_data}/${spname}_1.f* ${my_raw_data}/${spname}_2.f* ${d}/03-My_clean_data/${spname}_1_clean.paired.fq.gz ${d}/03-My_clean_data/${spname}_1_clean.unpaired.fq.gz ${d}/03-My_clean_data/${spname}_2_clean.paired.fq.gz ${d}/03-My_clean_data/${spname}_2_clean.unpaired.fq.gz ILLUMINACLIP:${script_dir}/../dependencies/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} LEADING:${trimmomatic_leading_quality} TRAILING:${trimmomatic_trailing_quality} MINLEN:${trimmomatic_min_length}" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt" 
          
          trfilename="${d}/03-My_clean_data/${spname}_1_clean.paired.fq.gz" 
          trfilesize=$(stat -c %s "$trfilename") 
          if [ "$trfilesize" -lt 1024 ]; then
            rm ${d}/03-My_clean_data/${spname}_*_clean.paired.fq.gz
            echo "[Warning]:          Trimmomatic didn't produce any results about ${spname}."
          else
            echo "[HybSuite-INFO]:    Successfully trim adapters of the raw data for ${spname}, producing clean data ${spname}_1_clean.paired.fq.gz and ${spname}_2_clean.paired.fq.gz." | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
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
        echo "[HybSuite-INFO]:    Trimmomatic: Skip ${spname} as it's already been trimmed."  
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
          MINLEN:${trimmomatic_min_length}
          echo "[CMD]:              java -jar ${script_dir}/../dependencies/Trimmomatic-0.39/trimmomatic-0.39.jar SE -threads ${nt_trimmomatic} -phred33 ${my_raw_data}/${spname}.f* ${d}/03-My_clean_data/${spname}_clean.single.fq.gz ILLUMINACLIP:${script_dir}/../dependencies/Trimmomatic-0.39/adapters/TruSeq3-SE.fa:2:30:10 SLIDINGWINDOW:${trimmomatic_sliding_window_s}:${trimmomatic_sliding_window_q} LEADING:${trimmomatic_leading_quality} TRAILING:${trimmomatic_trailing_quality} MINLEN:${trimmomatic_min_length}"
          
          trfilename="${d}/03-My_clean_data/${spname}_clean.single.fq.gz" 
          trfilesize=$(stat -c %s "$trfilename")
          if [ "$trfilesize" -lt 1024 ]; then
            rm ${d}/03-My_clean_data/${spname}_clean.single.fq.gz
            echo "[Warning]:          Trimmomatic didn't produce any results about ${spname}."
          else
            echo "[HybSuite-INFO]:    Successfully trim adapters of the raw data for ${spname}, producing clean data ${spname}_clean.paired.fq.gz." | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
          fi
        fi
      fi
    fi
  done < ${i}/My_Spname.txt
fi
echo "[HybSuite-INFO]:    Successfully finish running stage1: 'NGS database construction'. Moving on to the next stage..." | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
echo "                    The NGS database has been constructed in ${d}" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
if [ "${run_to_database}" = "true" ]; then
  echo "[HybSuite-INFO]:    You set '--run_to_database' to specify HybSuite to run only stage1." | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
  echo "                    Consequently, HybSuite will stop and exit right now." | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
  echo "                    HybSuite exits." | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage1_NGS_database_construction_${current_time}.txt"
  exit 1
fi

#===> Stage2 HybPiper pipeline <===#
#（1）Change working directory and conda environment
cd ${o}/01-HybPiper_results
if [ -s "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt" ]; then
  rm "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
fi
echo ""
echo "[HybSuite-INFO]:    <<<======= Stage2 HybPiper pipeline =======>>>" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
eval "$(conda shell.bash hook)"
conda activate "${conda2}"
echo "[CMD]:              conda activate ${conda2}" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
if [ "$CONDA_DEFAULT_ENV" = "${conda2}" ]; then
  echo "[HybSuite-INFO]:    Successfully activate ${conda2} conda environment" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
  echo "                    PASS"  | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
else
  echo "[Error]:            Fail to activate ${conda2} conda environment" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
  echo "                    HybSuite exits." | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
  echo ""
  exit 1
fi
#（2）hybpiper assemble
###01 Genes capture of public data using HybPiper (i.e. gene capture only for new species in the SRR_Spname.txt list) (provided that the user provides SRR_Spname.txt)
echo "[HybSuite-INFO]:    Step1: run 'hybpiper assemble'..." | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
if [ -s "${i}/SRR_Spname.txt" ]; then
  while IFS= read -r line || [[ -n $line ]]; do
    Sp_name=$(echo "${line}" | awk '{print $2}')
    echo "[HybSuite-INFO]:    For the sample '${Sp_name}': " | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
    if [ ! -s "${eas_dir}/${Sp_name}/genes_with_seqs.txt" ]; then
      if [ -e "${eas_dir}/${Sp_name}" ]; then
        rm ${eas_dir}/${Sp_name}/*
        echo "[HybSuite-INFO]:    'hybpiper assemble' hasn't been finished, so it will restart." | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
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
          --cpu ${nt_hybpiper}
          echo "[CMD]:              hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/02-Downloaded_clean_data/${Sp_name}_1_clean.paired.fq.gz ${d}/02-Downloaded_clean_data/${Sp_name}_2_clean.paired.fq.gz -o ${eas_dir} --prefix ${Sp_name} --diamond --cpu ${nt_hybpiper}" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt" 
        fi
        #use BLASTx (default) to map reads
        if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "blast" ]; then
          hybpiper assemble "-t_${hybpiper_tt}" ${t} \
          -r ${d}/02-Downloaded_clean_data/${Sp_name}_1_clean.paired.fq.gz ${d}/02-Downloaded_clean_data/${Sp_name}_2_clean.paired.fq.gz \
          -o ${eas_dir} \
          --prefix ${Sp_name} \
          --cpu ${nt_hybpiper}
          echo "[CMD]:              hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/02-Downloaded_clean_data/${Sp_name}_1_clean.paired.fq.gz ${d}/02-Downloaded_clean_data/${Sp_name}_2_clean.paired.fq.gz -o ${eas_dir} --prefix ${Sp_name} --cpu ${nt_hybpiper}" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt" 
        fi
        #02: for nucleotide reference sequence
        if [ "${hybpiper_tt}" = "dna" ]; then
          hybpiper assemble "-t_${hybpiper_tt}" ${t} \
          -r ${d}/02-Downloaded_clean_data/${Sp_name}_1_clean.paired.fq.gz ${d}/02-Downloaded_clean_data/${Sp_name}_2_clean.paired.fq.gz \
          -o ${eas_dir} \
          --prefix ${Sp_name} \
          --bwa \
          --cpu ${nt_hybpiper}
          echo "[CMD]:              hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/02-Downloaded_clean_data/${Sp_name}_1_clean.paired.fq.gz ${d}/02-Downloaded_clean_data/${Sp_name}_2_clean.paired.fq.gz -o ${eas_dir} --prefix ${Sp_name} --bwa --cpu ${nt_hybpiper}" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt" 
        fi
        if [ -s "${eas_dir}/${Sp_name}/genes_with_seqs.txt" ]; then
          gene_number=$(wc -l < "${eas_dir}/${Sp_name}/genes_with_seqs.txt")
          echo "[HybSuite-INFO]:    Successfully assemble ${gene_number} genes for ${Sp_name} via HybPiper." | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
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
          --cpu ${nt_hybpiper}
          echo "[CMD]:              hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/02-Downloaded_clean_data/${Sp_name}_clean.single.fq.gz -o ${eas_dir} --prefix ${Sp_name} --diamond --cpu ${nt_hybpiper}" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
        fi
        #01-2: use BLASTx (default) to map reads
        if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "blast" ]; then
          hybpiper assemble "-t_${hybpiper_tt}" ${t} \
          -r ${d}/02-Downloaded_clean_data/${Sp_name}_clean.single.fq.gz \
          -o ${eas_dir} \
          --prefix ${Sp_name} \
          --cpu ${nt_hybpiper}
          echo "[CMD]:              hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/02-Downloaded_clean_data/${Sp_name}_clean.single.fq.gz -o ${eas_dir} --prefix ${Sp_name} --cpu ${nt_hybpiper}" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
        fi
        #02: for nucleotide reference sequence
        if [ "${hybpiper_tt}" = "dna" ]; then
          hybpiper assemble "-t_${hybpiper_tt}" ${t} \
          -r ${d}/02-Downloaded_clean_data/${Sp_name}_clean.single.fq.gz \
          -o ${eas_dir} \
          --prefix ${Sp_name} \
          --bwa \
          --cpu ${nt_hybpiper}
          echo "[CMD]:              hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/02-Downloaded_clean_data/${Sp_name}_clean.single.fq.gz -o ${eas_dir} --prefix ${Sp_name} --bwa --cpu ${nt_hybpiper}" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
        fi
        if [ -s "${eas_dir}/${Sp_name}/genes_with_seqs.txt" ]; then
          gene_number=$(wc -l < "${eas_dir}/${Sp_name}/genes_with_seqs.txt")
          echo "[HybSuite-INFO]:    Successfully assemble ${gene_number} genes for ${Sp_name} via HybPiper." | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
        fi
      fi
    else
      echo "[HybSuite-INFO]:    Skip ${Sp_name}'s genes, because they have been assembled by HybPiper."
    fi
  done < ${i}/SRR_Spname.txt
fi

###02 Capture self-test data using HybPiper (that is, gene capture only for new species in the My_Spname.txt list) (provided that the user provides My_Spname.txt and specifies -my_raw_data)
if [ -s "${i}/My_Spname.txt" ]; then
  while IFS= read -r Sp_name || [[ -n ${Sp_name} ]]; do
    echo "[HybSuite-INFO]:    For the sample '${Sp_name}': " | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
    if [ ! -s "${eas_dir}/${Sp_name}/genes_with_seqs.txt" ]; then
      if [ -e "${eas_dir}/${Sp_name}" ]; then
        rm ${eas_dir}/${Sp_name}/*
        echo "[HybSuite-INFO]:    'hybpiper assemble' hasn't been finished, so it will restart." | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
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
          --cpu ${nt_hybpiper}
          echo "[CMD]:              hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/03-My_clean_data/${Sp_name}_1_clean.paired.fq.gz ${d}/03-My_clean_data/${Sp_name}_2_clean.paired.fq.gz -o ${eas_dir} --prefix ${Sp_name} --diamond --cpu ${nt_hybpiper}" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
        fi
        #use BLASTx (default) to map reads
        if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "blast" ]; then
          hybpiper assemble "-t_${hybpiper_tt}" ${t} \
          -r ${d}/03-My_clean_data/${Sp_name}_1_clean.paired.fq.gz ${d}/03-My_clean_data/${Sp_name}_2_clean.paired.fq.gz \
          -o ${eas_dir} \
          --prefix ${Sp_name} \
          --cpu ${nt_hybpiper}
          echo "[CMD]:              hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/03-My_clean_data/${Sp_name}_1_clean.paired.fq.gz ${d}/03-My_clean_data/${Sp_name}_2_clean.paired.fq.gz -o ${eas_dir} --prefix ${Sp_name} --cpu ${nt_hybpiper}" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
        fi
        #02: for nucleotide reference sequence
        if [ "${hybpiper_tt}" = "dna" ]; then
          hybpiper assemble "-t_${hybpiper_tt}" ${t} \
          -r ${d}/03-My_clean_data/${Sp_name}_1_clean.paired.fq.gz ${d}/03-My_clean_data/${Sp_name}_2_clean.paired.fq.gz \
          -o ${eas_dir} \
          --prefix ${Sp_name} \
          --bwa \
          --cpu ${nt_hybpiper}
          echo "[CMD]:              hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/03-My_clean_data/${Sp_name}_1_clean.paired.fq.gz ${d}/03-My_clean_data/${Sp_name}_2_clean.paired.fq.gz -o ${eas_dir} --prefix ${Sp_name} --bwa --cpu ${nt_hybpiper}" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
        fi
        if [ -s "${eas_dir}/${Sp_name}/genes_with_seqs.txt" ]; then
          gene_number=$(wc -l < "${eas_dir}/${Sp_name}/genes_with_seqs.txt")
          echo "[HybSuite-INFO]:    Successfully assemble ${gene_number} genes for ${Sp_name} via HybPiper." | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
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
          --cpu ${nt_hybpiper}
          echo "[CMD]:              hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/03-My_clean_data/${Sp_name}_clean.single.fq.gz -o ${eas_dir} --prefix ${Sp_name} --diamond --cpu ${nt_hybpiper}" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
        fi
        #01-2: use BLASTx (default) to map reads
        if [ "${hybpiper_tt}" = "aa" ] && [ "${hybpiper_m}" = "blast" ]; then
          hybpiper assemble "-t_${hybpiper_tt}" ${t} \
          -r ${d}/03-My_clean_data/${Sp_name}_clean.single.fq.gz \
          -o ${eas_dir} \
          --prefix ${Sp_name} \
          --cpu ${nt_hybpiper}
          echo "[CMD]:              hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/03-My_clean_data/${Sp_name}_clean.single.fq.gz -o ${eas_dir} --prefix ${Sp_name} --cpu ${nt_hybpiper}" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
        fi
        #02: for nucleotide reference sequence
        if [ "${hybpiper_tt}" = "dna" ]; then
          hybpiper assemble "-t_${hybpiper_tt}" ${t} \
          -r ${d}/03-My_clean_data/${Sp_name}_clean.single.fq.gz \
          -o ${eas_dir} \
          --prefix ${Sp_name} \
          --bwa \
          --cpu ${nt_hybpiper}
          echo "[CMD]:              hybpiper assemble -t_${hybpiper_tt} ${t} -r ${d}/03-My_clean_data/${Sp_name}_clean.single.fq.gz -o ${eas_dir} --prefix ${Sp_name} --bwa --cpu ${nt_hybpiper}" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
        fi
        if [ -s "${eas_dir}/${Sp_name}/genes_with_seqs.txt" ]; then
          gene_number=$(wc -l < "${eas_dir}/${Sp_name}/genes_with_seqs.txt")
          echo "[HybSuite-INFO]:    Successfully assemble ${gene_number} genes for ${Sp_name} via HybPiper." | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
        fi
      fi
    else
      echo "[HybSuite-INFO]:    Skip ${Sp_name}'s genes, because they have been assembled by HybPiper."
    fi
  done < ${i}/My_Spname.txt
fi
#(3) hybpiper stats to paralog retriever
if [ -s "${eas_dir}/HybPiper_namelist.txt" ]; then
  cp ${eas_dir}/HybPiper_namelist.txt ${eas_dir}/HybPiper_namelist_old.txt
fi
cp ${o}/00-logs_and_checklists/species_checklists/All_Spname_list.txt  ${eas_dir}/HybPiper_namelist.txt             
cd ${eas_dir}
hybpiper stats "-t_${hybpiper_tt}" ${t} ${hybpiper_rs} ${o}/00-logs_and_checklists/species_checklists/All_Spname_list.txt
echo "[CMD]:              hybpiper stats "-t_${hybpiper_tt}" ${t} ${hybpiper_rs} ${o}/00-logs_and_checklists/species_checklists/All_Spname_list.txt" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
hybpiper recovery_heatmap seq_lengths.tsv --heatmap_dpi ${hybpiper_heatmap_dpi}
echo "[CMD]:              hybpiper recovery_heatmap seq_lengths.tsv --heatmap_dpi ${hybpiper_heatmap_dpi}" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
mv seq_lengths.tsv ${o}/01-HybPiper_results/02-stats/
echo "[CMD]:              mv ${eas_dir}/seq_lengths.tsv ${o}/01-HybPiper_results/02-stats/" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
mv hybpiper_stats.tsv ${o}/01-HybPiper_results/02-stats/
echo "[CMD]:              mv ${eas_dir}/hybpiper_stats.tsv ${o}/01-HybPiper_results/02-stats/" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
mv recovery_heatmap.png ${o}/01-HybPiper_results/03-recovery_heatmap/
echo "[CMD]:              mv ${eas_dir}/recovery_heatmap.png ${o}/01-HybPiper_results/03-recovery_heatmap/" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"

# hybpiper retrieve_sequences
if [ "${hybpiper_tr}" = "dna" ]; then
  hybpiper retrieve_sequences "-t_${hybpiper_tt}" ${t} dna \
  --sample_names ${o}/00-logs_and_checklists/species_checklists/All_Spname_list.txt \
  --fasta_dir ${o}/01-HybPiper_results/04-retrieve_sequences
  echo "[CMD]:              hybpiper retrieve_sequences "-t_${hybpiper_tt}" ${t} dna --sample_names ${o}/00-logs_and_checklists/species_checklists/All_Spname_list.txt --fasta_dir ${o}/01-HybPiper_results/04-retrieve_sequences" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
fi

if [ "${hybpiper_tr}" = "aa" ]; then
  hybpiper retrieve_sequences "-t_${hybpiper_tt}" ${t} aa \
  --sample_names ${o}/00-logs_and_checklists/species_checklists/All_Spname_list.txt \
  --fasta_dir ${o}/01-HybPiper_results/04-retrieve_sequences
  echo "[CMD]:              hybpiper retrieve_sequences "-t_${hybpiper_tt}" ${t} aa --sample_names ${o}/00-logs_and_checklists/species_checklists/All_Spname_list.txt --fasta_dir ${o}/01-HybPiper_results/04-retrieve_sequences" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
fi

# hybpiper paralog_retriever
hybpiper paralog_retriever ${o}/00-logs_and_checklists/species_checklists/All_Spname_list.txt "-t_${hybpiper_tt}" ${t} \
--fasta_dir_all ${o}/01-HybPiper_results/05-paralogs_all_fasta \
--heatmap_dpi ${hybpiper_heatmap_dpi}
echo "[CMD]:              hybpiper paralog_retriever ${o}/00-logs_and_checklists/species_checklists/All_Spname_list.txt "-t_${hybpiper_tt}" ${t} --fasta_dir_all ${o}/01-HybPiper_results/05-paralogs_all_fasta --heatmap_dpi ${hybpiper_heatmap_dpi}" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
mv paralog_report.tsv ${o}/01-HybPiper_results/06-paralogs_reports
echo "[CMD]:              mv ${eas_dir}/paralog_report.tsv ${o}/01-HybPiper_results/06-paralogs_reports" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
mv paralog_heatmap.png ${o}/01-HybPiper_results/06-paralogs_reports
echo "[CMD]:              mv ${eas_dir}/paralog_heatmap.png ${o}/01-HybPiper_results/06-paralogs_reports" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
mv paralogs_above_threshold_report.txt ${o}/01-HybPiper_results/06-paralogs_reports
echo "[CMD]:              mv ${eas_dir}/paralogs_above_threshold_report.txt ${o}/01-HybPiper_results/06-paralogs_reports" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
echo "[HybSuite-INFO]:    Successfully finish the stage2: 'HybPiper pipeline'. Moving on to the next stage..." | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
echo "                    The resulting files have been saved in ${o}/01-HybPiper_results" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
if [ "${run_to_hybpiper}" = "true" ]; then
  echo "[HybSuite-INFO]:    You set '--run_to_hybpiper' to specify HybSuite to run only stage1 and stage2." | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
  echo "                    Consequently, HybSuite will stop and exit right now." | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
  echo "                    HybSuite exits." | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage2_HybPiper_pipeline_${current_time}.txt"
  exit 1
fi
#===> Stage3 Orthologs inference <===#
#0. Preparation
if [ -s "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt" ]; then
  rm "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
fi
echo ""
echo "[HybSuite-INFO]:    <<<======= Stage3 Orthologs inference =======>>>" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
# Change the conda environment
eval "$(conda shell.bash hook)"
conda activate ${conda1}
echo "[CMD]:              conda activate ${conda1}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
if [ "$CONDA_DEFAULT_ENV" = "${conda1}" ]; then
  echo "[HybSuite-INFO]:    Successfully activate ${conda1} conda environment" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  echo "                    PASS"  | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
else
  echo "[Error]:            Fail to activate ${conda1} conda environment" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  echo "                    HybSuite exits." | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  echo ""
exit 1
fi
#1. HRS
# Batch multiple sequence alignment using mafft (only gene sets with data are selected for running mafft alignment):
if [ "${HRS}" = "TRUE" ]; then
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  echo "[HybSuite-INFO]:    Run HRS (HybPiper retrieved sequences)..." | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  echo "[HybSuite-INFO]:    You choose HRS method, so HybSuite will directly align sequences which are retrived by HybPiper." | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  # (1) Filter genes
  ### 00 Create necessary directories and change working directories
  mkdir -p "${o}/02-Alignments/HRS/01_filtered_genes"
  if [ "$(ls -A "${o}/02-Alignments/HRS/01_filtered_genes")" ]; then
    rm ${o}/02-Alignments/HRS/01_filtered_genes/*
  fi
  cd ${o}/01-HybPiper_results/04-retrieve_sequences
  ### 01 Select the gene set that covers more than n * species
  for sample in *.FNA; do  
    # Count the number of lines containing ">" in each file 
    count_cover=$(grep -c '>' "$sample")
    count_sp=$(grep -c '.' "${eas_dir}/HybPiper_namelist.txt")
    count_sp_filter=$(echo "${count_sp} * ${spcover}" | bc)

    if (( $(echo "$count_cover >= $count_sp_filter" | bc -l) )); then
      cp ${sample} "${o}/02-Alignments/HRS/01_filtered_genes/" 
      sed -i 's/_R_//g' "${o}/02-Alignments/HRS/01_filtered_genes/${sample}"
    else
      echo "[HybSuite-INFO]:    ${sample} has been filterd because it can only cover less than ${spcover} of all species."
    fi  
  done
  
  # (2) MAFFT
  ### 00 Make necessary directories and change working directories
  if [ ! -e "${o}/02-Alignments/HRS/02_alignments_mafft" ]; then
    mkdir -p "${o}/02-Alignments/HRS/02_alignments_mafft"
  else
    if [ "$(ls -A "${o}/02-Alignments/HRS/02_alignments_mafft")" ]; then
      rm "${o}/02-Alignments/HRS/02_alignments_mafft/*"
    fi
  fi
  cd "${o}/02-Alignments/HRS/01_filtered_genes/"
  ### 01 Sort the contents of files A and B and save them to a temporary file
  sort ${eas_dir}/HybPiper_namelist_old.txt > sorted_fileA.txt
  sort ${eas_dir}/HybPiper_namelist.txt > sorted_fileB.txt
  ### 02 Compare the sorted files
  if diff -q sorted_fileA.txt sorted_fileB.txt >/dev/null && [ "$run_mafft" = "FALSE" ]; then
    echo "[HybSuite-INFO]:    HybSuite will not run mafft again because the sequences have been aligned."
  else
  ### 03 Align the genes datasets which contain at least one species' sequence
    first_iteration=true
    for sample in *.FNA; do
      file_path="${sample}"
      if [ -s "$file_path" ]; then
        echo "[HybSuite-INFO]:    Run MAFFT to align multiple sequences produced by HRS method..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
        if [ "$mafft" = "auto" ]; then
          mafft --quiet --auto \
          --thread "${nt_mafft}" \
          ./${sample} > ${o}/02-Alignments/HRS/02_alignments_mafft/${sample}
          echo "[CMD]:              mafft --quiet --auto --thread ${nt_mafft} ./${sample} > ${o}/02-Alignments/HRS/01_filtered_genes/${sample}" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
          sed -i 's/_R_//g' ${o}/02-Alignments/HRS/02_alignments_mafft/${sample}
        else
          mafft-linsi --quiet --adjustdirectionaccurately \
          --thread "${nt_mafft}" \
          --op 3 \
          --ep 0.123 \
          "./${sample}" > "${o}/02-Alignments/HRS/02_alignments_mafft/${sample}"
          echo "[CMD]:              mafft-linsi --quiet --adjustdirectionaccurately --thread ${nt_mafft} --op 3 --ep 0.123 ./${sample} > ${o}/02-Alignments/HRS/01_filtered_genes/${sample}" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
          sed -i 's/_R_//g' ${o}/02-Alignments/HRS/02_alignments_mafft/${sample}
        fi
      else
        if [ "$first_iteration" = true ]; then
          echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
          echo "[HybSuite-INFO]:    Attention:" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
          first_iteration=false
        fi
        echo "[HybSuite-INFO]:    The dataset does not contain genes ${sample} for any of the species." | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
      fi
    done
  fi

 ### 04 Remove "single*" and "multi*"
  cd ${o}/02-Alignments/HRS/02_alignments_mafft/
  for sample in *.FNA; do
    if [ -s "${sample}" ]; then
      sed -i 's/ single_hit//g;s/ multi_hit_stitched_contig_comprising_[0-9]\{1\}_hits//g' "${sample}"
    else
      echo "[ERROR]:            There is no sequence prepared to run MAFFT." | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
      exit 1
    fi
  done
fi

#2. RAPP
if [ "${RAPP}" = "TRUE" ]; then
  ### 01 Make necessary directories and change working directories
  chars="01_seqs_with_only_paralog_warnings/gene_titles_list 02_seqs_without_paralog_warnings/gene_titles_list 03_seqs_with_single_or_multi_hit/single_hit_titles 03_seqs_with_single_or_multi_hit/multi_hit_titles 04_filtered_genes 05_alignments_mafft 06_alignments_trimal"
  for dir in ${chars}; do  
    mkdir -p "${o}/02-Alignments/RAPP/${dir}" 
  done
  cd ${o}/01-HybPiper_results/05-paralogs_all_fasta

  ### 02 remove all putative paralogs (RAPP)
  for file in *.fasta; do
    new_file=$(echo "$file" | sed 's/_paralogs_all.fasta//g')
    grep '_length_' "${file}" | sed -e 's/>//g' > ${o}/02-Alignments/RAPP/01_seqs_with_only_paralog_warnings/gene_titles_list/gene_${new_file}_titles_seqs_with_only_paralog_warnings.txt
    grep -v '_length_' "${file}" | sed -e 's/>//g' > ${o}/02-Alignments/RAPP/02_seqs_without_paralog_warnings/gene_titles_list/gene_${new_file}_titles_seqs_without_paralog_warnings.txt
    grep 'multi_hit' "${file}" | sed -e 's/>//g' > ${o}/02-Alignments/RAPP/03_seqs_with_single_or_multi_hit/multi_hit_titles/gene_${new_file}_titles_multi_hit.txt
    grep 'single_hit' "${file}" | sed -e 's/>//g' > ${o}/02-Alignments/RAPP/03_seqs_with_single_or_multi_hit/single_hit_titles/gene_${new_file}_titles_single_hit.txt
    
    # seqs without paralog warnings
    if [ -s "${o}/02-Alignments/RAPP/01_seqs_with_only_paralog_warnings/gene_titles_list/gene_${new_file}_titles_seqs_with_only_paralog_warnings.txt" ]; then
      pxrms -s "${file}" -f ${o}/02-Alignments/RAPP/02_seqs_without_paralog_warnings/gene_titles_list/gene_${new_file}_titles_seqs_without_paralog_warnings.txt > "${o}/02-Alignments/RAPP/01_seqs_with_only_paralog_warnings/gene_${new_file}_seqs_with_only_paralog_warnings.fasta"
    
    # seqs with only paralog warnings
    elif [ -s "${o}/02-Alignments/RAPP/02_seqs_without_paralog_warnings/gene_titles_list/gene_${new_file}_titles_seqs_without_paralog_warnings.txt" ]; then
      pxrms -s "${file}" -f ${o}/02-Alignments/RAPP/01_seqs_with_only_paralog_warnings/gene_titles_list/gene_${new_file}_titles_seqs_with_only_paralog_warnings.txt > "${o}/02-Alignments/RAPP/02_seqs_without_paralog_warnings/gene_${new_file}_seqs_without_paralog_warnings.fasta"

    # single_hit
    elif [ -s "${o}/02-Alignments/RAPP/03_seqs_with_single_or_multi_hit/single_hit_titles/gene_${new_file}_titles_single_hit.txt" ]; then
      pxrms -s "${o}/02-Alignments/RAPP/01_seqs_with_only_paralog_warnings/gene_${new_file}_seqs_without_paralog_warnings.fasta" -f "${o}/02-Alignments/RAPP/03_seqs_with_single_or_multi_hit/multi_hit_titles/gene_${new_file}_titles_multi_hit.txt" \
    > "${o}/02-Alignments/RAPP/03_seqs_with_single_or_multi_hit/single_hit_gene_${new_file}_seqs.fasta"
    
    # multi_hit
    elif [  -s "${o}/02-Alignments/RAPP/03_seqs_with_single_or_multi_hit/multi_hit_titles/gene_${new_file}_titles_multi_hit.txt" ]; then
      pxrms -s "${o}/02-Alignments/RAPP/01_seqs_with_only_paralog_warnings/gene_${new_file}_seqs_without_paralog_warnings.fasta" -f "${o}/02-Alignments/RAPP/03_seqs_with_single_or_multi_hit/single_hit_titles/gene_${new_file}_titles_single_hit.txt" \ 
    > "${o}/02-Alignments/RAPP/03_seqs_with_single_or_multi_hit/multi_hit_gene_${new_file}_seqs.fasta"
    fi
  done
  
  ### 03 Filter genes according to the species coverage
  cd "${o}/02-Alignments/RAPP/02_seqs_without_paralog_warnings"
  for sample in *.fasta; do  
    # Count the number of lines containing ">" in each file  
    count_cover=$(grep -c '>' "$sample")
    count_sp=$(grep -c '.' "${eas_dir}/HybPiper_namelist.txt")
    count_sp_filter=$(echo "${count_sp} * ${spcover}" | bc)
    if (( $(echo "$count_cover >= $count_sp_filter" | bc -l) )); then
      cp ${sample} ../04_filtered_genes 
    else
      echo "[HybSuite-INFO]:    ${sample} has been filterd because it can only cover less than ${spcover} of all species."
    fi  
    sed -i 's/ single_hit//g;s/ multi_hit.*//g' "../04_filtered_genes/${sample}"
  done

  ### 04 Multiple alignments maffting
  ### 04-1 Sort the contents of files A and B and save them to a temporary file
  cd "${o}/02-Alignments/RAPP/04_filtered_genes"
  sort ${eas_dir}/HybPiper_namelist_old.txt > sorted_fileA.txt
  sort ${eas_dir}/HybPiper_namelist.txt > sorted_fileB.txt
  ### 04-2 Compare the sorted files
  if diff -q sorted_fileA.txt sorted_fileB.txt >/dev/null && [ "$run_mafft" = "FALSE" ]; then
    echo "[HybSuite-INFO]:    HybSuite will not run mafft again because the sequences have been aligned." | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  else
  ### 04-3 Align the genes datasets which contain at least one species' sequence
    first_iteration=true
    for sample in *.fasta; do
      file_path="${sample}"
      if [ -s "$file_path" ]; then
        echo "[HybSuite-INFO]:    HybSuite will run mafft to align multiple sequences produced by RAPP method."  | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
        if [ "$mafft" = "auto" ]; then
          mafft --quiet --auto \
          --thread "${nt_mafft}" \
          ./${sample} > ${o}/02-Alignments/RAPP/05_alignments_mafft/${sample}
          echo "[CMD]:              mafft --quiet --auto --thread ${nt_mafft} ./${sample} > ${o}/02-Alignments/RAPP/05_alignments_mafft/${sample}" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
          sed -i 's/_R_//g' ${o}/02-Alignments/RAPP/05_alignments_mafft/${sample}
        else
          mafft-linsi --quiet --adjustdirectionaccurately \
          --thread "${nt_mafft}" \
          --op 3 \
          --ep 0.123 \
          ./${sample} > ${o}/02-Alignments/RAPP/05_alignments_mafft/${sample}
          echo "[CMD]:              mafft-linsi --quiet --adjustdirectionaccurately --thread ${nt_mafft} --op 3 --ep 0.123 ./${sample} > ${o}/02-Alignments/RAPP/05_alignments_mafft/${sample}" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
          sed -i 's/_R_//g' ${o}/02-Alignments/RAPP/05_alignments_mafft/${sample}
        fi
      else
        if [ "$first_iteration" = true ]; then
          echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
          echo "[HybSuite-INFO]:    Attention:" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
          first_iteration=false
        fi
        echo "[HybSuite-INFO]:    The dataset does not contain genes ${sample} for any of the species." | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
      fi
    done
  fi
fi


#3. ParaGone
if [ "$MO" = "TRUE" ] || [ "$MI" = "TRUE" ] || [ "$RT" = "TRUE" ] || [ "${one_to_one}" = "TRUE" ]; then
  #Preparation: Logs
  conda activate "${conda3}"
  echo "[CMD]:              conda activate ${conda3}" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  if [ "$CONDA_DEFAULT_ENV" = "${conda3}" ]; then
    echo "[HybSuite-INFO]:    Successfully activate ${conda3} conda environment" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
    echo "                    PASS"  | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
    echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  else
    echo "[Error]:            Fail to activate ${conda3} conda environment" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
    echo "                    HybSuite exits." | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
    echo ""
    exit 1
  fi
  
  # (1) Run ParaGone pipeline
  mkdir -p ${o}/02-Alignments/ParaGone-results
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  echo "[HybSuite-INFO]:    run ParaGone (MO/MI/RT/1to1) ... " | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  if [ "${MO}" = "TRUE" ]; then
    echo "[HybSuite-INFO]:    You choose MO algorithm, so HybSuite will run MO algorithm via ParaGone." | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  fi
  if [ "${MI}" = "TRUE" ]; then
    echo "[HybSuite-INFO]:    You choose MI algorithm, so HybSuite will run MI algorithm via ParaGone." | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  fi
  if [ "${RT}" = "TRUE" ]; then
    echo "[HybSuite-INFO]:    You choose RT algorithm, so HybSuite will runn RT algorithm via ParaGone." | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  fi
  if [ "${one_to_one}" = "TRUE" ]; then
    echo "[HybSuite-INFO]:    You choose 1to1 algorithm, so HybSuite will extract 1to1 final alignments from the folder of MO alignments." | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  fi
  # Preparation: Outgroup processing
  cd ${o}/02-Alignments/ParaGone-results
  echo "[CMD]:              cd ${o}/02-Alignments/ParaGone-results" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  outgroup_args=""
  while IFS= read -r line; do
    outgroup_args="$outgroup_args --internal_outgroup $line"
  done < ${i}/Outgroup.txt
  find ${o}/01-HybPiper_results/05-paralogs_all_fasta/ -type f -empty -delete
  
  # ParaGone Step1
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  echo "[HybSuite-INFO]:    ParaGone step1: " | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  paragone check_and_align "${o}/01-HybPiper_results/05-paralogs_all_fasta"${outgroup_args} --pool ${paragone_pool} --threads ${nt_paragone} > /dev/null 2>&1
  echo "[CMD]:              paragone check_and_align "${o}/02-Alignments/ParaGone-results/Input-Filtered_paralogs_all_fasta"${outgroup_args} --pool ${paragone_pool} --threads ${nt_paragone}" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  
  # ParaGone Step2
  if [ "${paragone_tree}" = "iqtree" ]; then
    echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
    echo "[HybSuite-INFO]:    ParaGone step2: " | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
    paragone alignment_to_tree 04_alignments_trimmed_cleaned --pool ${paragone_pool} --threads ${nt_paragone} > /dev/null 2>&1
    echo "[CMD]:              paragone alignment_to_tree 04_alignments_trimmed_cleaned --pool ${paragone_pool} --threads ${nt_paragone}" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  elif [ "${paragone_tree}" = "fasttree" ]; then
    echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
    echo "[HybSuite-INFO]:    ParaGone step2: " | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
    paragone alignment_to_tree 04_alignments_trimmed_cleaned --use_fasttree --pool ${paragone_pool} --threads ${nt_paragone} > /dev/null 2>&1
    echo "[CMD]:              paragone alignment_to_tree 04_alignments_trimmed_cleaned --use_fasttree --pool ${paragone_pool} --threads ${nt_paragone}" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  fi
  
  # ParaGone Step3
  # --use_fasttree
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  echo "[HybSuite-INFO]:    ParaGone step3: " | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  paragone qc_trees_and_extract_fasta 04_alignments_trimmed_cleaned \
  --treeshrink_q_value ${paragone_treeshrink_q_value} \
  --cut_deep_paralogs_internal_branch_length_cutoff ${paragone_cutoff_value} > /dev/null 2>&1
  echo "[CMD]:              paragone qc_trees_and_extract_fasta 04_alignments_trimmed_cleaned --treeshrink_q_value ${paragone_treeshrink_q_value} --cut_deep_paralogs_internal_branch_length_cutoff ${paragone_cutoff_value}" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"

  # ParaGone Step4
  if [ "${paragone_tree}" = "iqtree" ]; then
    echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
    echo "[HybSuite-INFO]:    ParaGone step4: " | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
    paragone align_selected_and_tree 04_alignments_trimmed_cleaned --pool ${paragone_pool} --threads ${nt_paragone} > /dev/null 2>&1
    echo "[CMD]:              paragone align_selected_and_tree 04_alignments_trimmed_cleaned --pool ${paragone_pool} --threads ${nt_paragone}" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  elif [ "${paragone_tree}" = "fasttree" ]; then
    echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
    echo "[HybSuite-INFO]:    ParaGone step4: " | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
    paragone align_selected_and_tree 04_alignments_trimmed_cleaned --pool ${paragone_pool} --threads ${nt_paragone} > /dev/null 2>&1
    echo "[CMD]:              paragone align_selected_and_tree 04_alignments_trimmed_cleaned --use_fasttree --pool ${paragone_pool} --threads ${nt_paragone}" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  fi
  
  # ParaGone Step5
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  echo "[HybSuite-INFO]:    ParaGone step5: " | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  paragone prune_paralogs --mo --rt --mi > /dev/null 2>&1
  echo "[CMD]:              paragone prune_paralogs --mo --rt --mi" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  
  # ParaGone Step6
  if [ "${paragone_keep_files}" = "TRUE" ]; then
    echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
    echo "[HybSuite-INFO]:    ParaGone step6: " | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
    paragone final_alignments --mo --rt --mi --pool ${paragone_pool} --threads ${nt_paragone} --keep_intermediate_files > /dev/null 2>&1
    echo "[CMD]:              paragone final_alignments --mo --rt --mi --pool ${paragone_pool} --threads ${nt_paragone} --keep_intermediate_files" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  else
    echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
    echo "[HybSuite-INFO]:    ParaGone step6: " | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
    paragone final_alignments --mo --rt --mi --pool ${paragone_pool} --threads ${nt_paragone} > /dev/null 2>&1
    echo "[CMD]:              paragone final_alignments --mo --rt --mi --pool ${paragone_pool} --threads ${nt_paragone}" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  fi
  if [ "${one_to_one}" = "TRUE" ]; then
    cd ${o}/02-Alignments/ParaGone-results/23_MO_final_alignments
    mkdir -p ${o}/02-Alignments/ParaGone-results/HybSuite_1to1_final_alignments
    files=$(find . -maxdepth 1 -type f -name "*1to1*")
    for file in $files; do
      cp "$file" "../HybSuite_1to1_final_alignments"
      echo "[CMD]:              cp ${file} ../HybSuite_1to1_final_alignments" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
      echo "[HybSuite-INFO]:    Successfully extract 1to1 final alignments." | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
    done
  fi
  echo "[HybSuite-INFO]:    Successfully finish running ParaGone." | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
fi

# (2) Filter alignments
### MO
if [ "${MO}" = "TRUE" ]; then
  mkdir -p "${o}/02-Alignments/MO/01_filtered_alignments"
  if [ "$(ls -A "${o}/02-Alignments/MO/01_filtered_alignments")" ]; then
    rm ${o}/02-Alignments/MO/01_filtered_alignments/*
  fi
  cd ${o}/02-Alignments/ParaGone-results/23_MO_final_alignments
  ### 01 Select the gene set that covers more than n * species
  for sample in *.fasta; do  
    # Count the number of lines containing ">" in each file 
    count_cover=$(grep -c '>' "$sample")
    count_sp=$(grep -c '.' "${eas_dir}/HybPiper_namelist.txt")
    count_sp_filter=$(echo "${count_sp} * ${spcover}" | bc)
    if (( $(echo "$count_cover >= $count_sp_filter" | bc -l) )); then
      cp ${sample} "${o}/02-Alignments/MO/01_filtered_alignments/" 
      sed -i 's/_R_//g' "${o}/02-Alignments/MO/01_filtered_alignments/${sample}"
    else
      echo "[HybSuite-INFO]:    For ParaGone: ${sample} has been filterd because the species coverage is lower than ${spcover}."
    fi  
  done
fi

### MI
if [ "${MI}" = "TRUE" ]; then
  mkdir -p "${o}/02-Alignments/MI/01_filtered_alignments"
  if [ "$(ls -A "${o}/02-Alignments/MI/01_filtered_alignments")" ]; then
      rm ${o}/02-Alignments/MI/01_filtered_alignments/*
  fi
  cd ${o}/02-Alignments/ParaGone-results/24_MI_final_alignments
  ### 01 Select the gene set that covers more than n * species
  for sample in *.fasta; do  
    # Count the number of lines containing ">" in each file 
    count_cover=$(grep -c '>' "$sample")
    count_sp=$(grep -c '.' "${eas_dir}/HybPiper_namelist.txt")
    count_sp_filter=$(echo "${count_sp} * ${spcover}" | bc)
    if (( $(echo "$count_cover >= $count_sp_filter" | bc -l) )); then
      cp ${sample} "${o}/02-Alignments/MI/01_filtered_alignments/" 
      sed -i 's/_R_//g' "${o}/02-Alignments/MI/01_filtered_alignments/${sample}"
    else
      echo "[HybSuite-INFO]:    For ParaGone: ${sample} has been filterd because the species coverage is lower than ${spcover}."
    fi  
  done
fi

### RT
if [ "${RT}" = "TRUE" ]; then
  mkdir -p "${o}/02-Alignments/RT/01_filtered_alignments"
  if [ "$(ls -A "${o}/02-Alignments/RT/01_filtered_alignments")" ]; then
      rm ${o}/02-Alignments/RT/01_filtered_alignments/*
  fi
  cd ${o}/02-Alignments/ParaGone-results/25_RT_final_alignments
  ### 01 Select the gene set that covers more than n * species
  for sample in *.fasta; do  
    # Count the number of lines containing ">" in each file 
    count_cover=$(grep -c '>' "$sample")
    count_sp=$(grep -c '.' "${eas_dir}/HybPiper_namelist.txt")
    count_sp_filter=$(echo "${count_sp} * ${spcover}" | bc)
    if (( $(echo "$count_cover >= $count_sp_filter" | bc -l) )); then
      cp ${sample} "${o}/02-Alignments/RT/01_filtered_alignments/" 
      sed -i 's/_R_//g' "${o}/02-Alignments/RT/01_filtered_alignments/${sample}"
    else
      echo "[HybSuite-INFO]:    For ParaGone: ${sample} has been filterd because the species coverage is lower than ${spcover}."
    fi  
  done
fi

### 1to1
if [ "${one_to_one}" = "TRUE" ]; then
  mkdir -p "${o}/02-Alignments/1to1/01_filtered_alignments"
  if [ "$(ls -A "${o}/02-Alignments/1to1/01_filtered_alignments")" ]; then
      rm ${o}/02-Alignments/1to1/01_filtered_alignments/*
  fi
  cd ${o}/02-Alignments/ParaGone-results/HybSuite_1to1_final_alignments
  ### 01 Select the gene set that covers more than n * species
  for sample in *.fasta; do  
    # Count the number of lines containing ">" in each file 
    count_cover=$(grep -c '>' "$sample")
    count_sp=$(grep -c '.' "${eas_dir}/HybPiper_namelist.txt")
    count_sp_filter=$(echo "${count_sp} * ${spcover}" | bc)
    if (( $(echo "$count_cover >= $count_sp_filter" | bc -l) )); then
      cp ${sample} "${o}/02-Alignments/1to1/01_filtered_alignments/" 
      sed -i 's/_R_//g' "${o}/02-Alignments/1to1/01_filtered_alignments/${sample}"
    else
      echo "[HybSuite-INFO]:    For ParaGone: ${sample} has been filterd because the species coverage is lower than ${spcover}."
    fi  
  done
fi

#4. Conclusion
echo "[HybSuite-INFO]:    Successfully finish the stage3: 'Orthologs inference'. Moving on to the next stage..." | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
echo "                    The resulting files have been saved in ${o}/02-Alignments" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"

if [ "${run_to_alignments}" = "true" ]; then
  echo "[HybSuite-INFO]:    You set '--run_to_alignments' to specify HybSuite to run from stage1 to stage3." | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  echo "                    Consequently, HybSuite will stop and exit right now." | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  echo "                    HybSuite exits." | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  exit 1
fi

#===> Stage4 From alignments to trees <===#
# 1.TrimAl, pxcat, and AMAS/phyx
#Preparation
if [ -s "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt" ]; then
  rm "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
fi
echo ""
echo "[HybSuite-INFO]:     <<<======= Stage4 From alignments to trees =======>>>"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
eval "$(conda shell.bash hook)"
conda deactivate
conda activate ${conda1} 
echo "[CMD]:               conda activate ${conda1}" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
if [ "${CONDA_DEFAULT_ENV}" = "${conda1}" ]; then
  echo "[HybSuite-INFO]:    Successfully activate ${conda1} conda environment" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "                    PASS"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
else
  echo "[Error]:            Fail to activate ${conda1} conda environment" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "                    HybSuite exits." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo ""
fi

stage4_info() {
  echo "[HybSuite-INFO]:    $1" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
}
stage4_error() {
  echo "[ERROR]:            $1" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
}
stage4_cmd() {
  echo "[CMD]:              $1" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
}
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
  echo "[HybSuite-INFO]:     Trim HRS alignments and concatenate them into the supermatrix..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  if diff -q ${o}/02-Alignments/HRS/01_filtered_genes/sorted_fileA.txt ${o}/02-Alignments/HRS/01_filtered_genes/sorted_fileB.txt >/dev/null && ls ${o}/02-Alignments/HRS/Genes_trimal/*.FNA 1> /dev/null 2>&1 && [ "$run_trimal_again" = "FALSE" ]; then
    echo "[HybSuite-INFO]:    HybSuite will not run trimal again because the same sequences have been trimmed." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  elif ! find . -maxdepth 1 -name "*.FNA" -size +0c 1> /dev/null 2>&1; then
    echo "[Warning]:          Error: There are no sequences prepared to run trimal or some FNA files are empty." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    exit 1
  else
    echo "[HybSuite-INFO]:    Run TrimAl ..." | tee -a "${o}/00-logs_and_checklists/logs/Stage3_Orthologs_inference_${current_time}.txt"
  fi

  ### 02 run TrimAl in batch mode
  for sample in *.FNA; do 
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
        echo "[CMD]:              trimal -in "${sample}" -out ${o}/02-Alignments/HRS/03_alignments_trimal/${sample} -automated1" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"    
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of ${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "${sample}" -out ${o}/02-Alignments/HRS/03_alignments_trimal/${sample} -gt ${trimal_gt} > /dev/null 2>&1
        echo "[CMD]:              trimal -in "${sample}" -out ${o}/02-Alignments/HRS/03_alignments_trimal/${sample} -gt ${trimal_gt}" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of ${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "${sample}" -out ${o}/02-Alignments/HRS/03_alignments_trimal/${sample} -gappyout > /dev/null 2>&1
        echo "[CMD]:              trimal -in "${sample}" -out ${o}/02-Alignments/HRS/03_alignments_trimal/${sample} -gt ${trimal_gt}" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of ${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi 
    fi   
  done
  rm ${o}/02-Alignments/HRS/01_filtered_genes/sorted_fileA.txt
  rm ${o}/02-Alignments/HRS/01_filtered_genes/sorted_fileB.txt
 
 # (2) concatenate trimmed alignments
  pxcat \
  -s ${o}/02-Alignments/HRS/03_alignments_trimal/*.FNA \
  -p ${o}/03-Supermatrix/HRS/partition.txt \
  -o ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta
  echo "[CMD]:              pxcat -s ${o}/02-Alignments/HRS/03_alignments_trimal/*.FNA -p ${o}/03-Supermatrix/HRS/partition.txt -o ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  if [ -s "${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta" ]; then
    echo "[HybSuite-INFO]:    Successfully concatenate HRS alignments to the supermatrix." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  else
    echo "[Warning]:          Fail to concatenate HRS alignments to the supermatrix." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  fi
  
 #（3）Use phyx/AMAS to check sequences
  ###00-Set the directory
  mkdir -p "${o}/03-Supermatrix/HRS"
  cd ${o}/03-Supermatrix/HRS

  ###01-phyx
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "[HybSuite-INFO]:    Run phyx to check the supermatrix ${prefix}_HRS.fasta..." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  tp_1to1_phyx=$(pxlssq -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta -m)
  echo "[CMD]:              pxlssq -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta -m" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "[HybSuite-INFO]:    The missing percent of the supermatrix of ${prefix}_HRS.fasta is ${tp_1to1_phyx}" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  pxlssq -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta > "${o}/00-logs_and_checklists/logs/Situation_report_of_${prefix}_supermatrix.txt"
  echo "[CMD]:              pxlssq -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta > ${o}/00-logs_and_checklists/logs/Situation_report_of_${prefix}_supermatrix.txt" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"

  ###02-AMAS
  if [ "$run_AMAS" != "FALSE" ]; then
    mkdir -p ${o}/03-Supermatrix/HRS/AMAS
    python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
    summary -f fasta -d dna -i ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta \
    -o ./AMAS/AMAS_test.txt > /dev/null 2>&1
    echo "[CMD]:              python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta -o ./AMAS/AMAS_test.txt" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  fi
fi
#(2) RAPP
if [ "${RAPP}" = "TRUE" ]; then
echo "[HybSuite-INFO]:     Trim RAPP alignments and concatenate them into the supermatrix..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
# (1) TrimAl
  if [ "${run_trimal}" = "TRUE" ]; then
    cd "${o}/02-Alignments/RAPP/05_alignments_mafft/"
    for sample in *.f*; do 
    if [ "$replace_n" = "TRUE" ]; then
      sed -e '/^>/! s/n/-/g'  ${sample} > "Without_n_${sample}"
      if [ "${trimal_function}" = "automated1" ]; then
        trimal -in "Without_n_${sample}" -out ../06_alignments_trimal/${sample} -automated1 > /dev/null 2>&1
        echo "[CMD]:              trimal -in Without_n_${sample} -out ../06_alignments_trimal/${sample} -automated1" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of Without_n_${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "Without_n_${sample}" -out ../06_alignments_trimal/${sample} -gt ${trimal_gt} > /dev/null 2>&1
        echo "[CMD]:              trimal -in Without_n_${sample} -out ../06_alignments_trimal/${sample} -gt ${trimal_gt}" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of Without_n_${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "Without_n_${sample}" -out ../06_alignments_trimal/${sample} -gappyout > /dev/null 2>&1
        echo "[CMD]:              trimal -in Without_n_${sample} -out ../06_alignments_trimal/${sample} -gappyout" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of Without_n_${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi 
    else
      if [ "${trimal_function}" = "automated1" ]; then
        trimal -in "${sample}" -out ../06_alignments_trimal/${sample} -automated1 > /dev/null 2>&1
        echo "[CMD]:              trimal -in ${sample} -out ../06_alignments_trimal/${sample} -automated1" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of ${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "${sample}" -out ../06_alignments_trimal/${sample} -gt ${trimal_gt} > /dev/null 2>&1
        echo "[CMD]:              trimal -in ${sample} -out ../06_alignments_trimal/${sample} -gt ${trimal_gt}" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of ${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "${sample}" -out ../06_alignments_trimal/${sample} -gappyout > /dev/null 2>&1
        echo "[CMD]:              trimal -in ${sample} -out ../06_alignments_trimal/${sample} -gappyout" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of ${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi 
    fi   
    done
  fi
  
# (2) concatenate trimmed alignments
  pxcat \
  -s ${o}/02-Alignments/RAPP/06_alignments_trimal/*.f* \
  -p ${o}/03-Supermatrix/RAPP/partition.txt \
  -o ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta
  echo "[CMD]:              pxcat -s ${o}/02-Alignments/RAPP/06_alignments_trimal/*.f* -p ${o}/03-Supermatrix/RAPP/partition.txt -o ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  if [ -s "${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta" ]; then
    echo "[HybSuite-INFO]:    Successfully concatenate RAPP alignments to the supermatrix." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  else
    echo "[Warning]:          Fail to concatenate RAPP alignments to the supermatrix." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  fi
  
 #（3）Use phyx/AMAS to check sequences
  ###00-Set the directory
  cd ${o}/03-Supermatrix/RAPP

  ###01-phyx
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "[HybSuite-INFO]:    Run phyx to check the supermatrix ${prefix}_RAPP.fasta..." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  tp_1to1_phyx=$(pxlssq -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta -m)
  echo "[CMD]:              pxlssq -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta -m" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "[HybSuite-INFO]:    The missing percent of the supermatrix of ${prefix}_RAPP.fasta is ${tp_1to1_phyx}" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  pxlssq -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta > "${o}/00-logs_and_checklists/logs/Situation_report_of_${prefix}_supermatrix.txt"
  echo "[CMD]:              pxlssq -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta > ${o}/00-logs_and_checklists/logs/Situation_report_of_${prefix}_supermatrix.txt" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"

  ###02-AMAS
  if [ "$run_AMAS" != "FALSE" ]; then
    if [ ! -e "${o}/03-Supermatrix/RAPP/AMAS" ]; then
      mkdir ${o}/03-Supermatrix/RAPP/AMAS
    fi
    python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
    summary -f fasta -d dna -i ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta \
    -o ./AMAS/AMAS_test.txt > /dev/null 2>&1
    echo "[CMD]:              python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta -o ./AMAS/AMAS_test.txt" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  fi
fi

#(3) MO/MI/RT/1to1
# MO
if [ "${MO}" = "TRUE" ]; then
  echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "[HybSuite-INFO]:     Trim MO alignments and concatenate them into the supermatrix..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  mkdir -p "${o}/02-Alignments/MO/02_alignments_trimal"
# (1) TrimAl
  if [ "${run_trimal}" = "TRUE" ]; then
    cd "${o}/02-Alignments/MO/01_filtered_alignments"
    for sample in *.fasta; do 
    if [ "$replace_n" = "TRUE" ]; then
      sed -e '/^>/! s/n/-/g'  ${sample} > "Without_n_${sample}"
      if [ "${trimal_function}" = "automated1" ]; then
        trimal -in "Without_n_${sample}" -out ${o}/02-Alignments/MO/02_alignments_trimal/${sample} -automated1 > /dev/null 2>&1
        echo "[CMD]:              trimal -in Without_n_${sample} -out ${o}/02-Alignments/MO/02_alignments_trimal/${sample} -automated1" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of Without_n_${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "Without_n_${sample}" -out ${o}/02-Alignments/MO/02_alignments_trimal/${sample} -gt ${trimal_gt} > /dev/null 2>&1
        echo "[CMD]:              trimal -in Without_n_${sample} -out ${o}/02-Alignments/MO/02_alignments_trimal/${sample} -gt ${trimal_gt}" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of Without_n_${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "Without_n_${sample}" -out ${o}/02-Alignments/MO/02_alignments_trimal/${sample} -gappyout > /dev/null 2>&1
        echo "[CMD]:              trimal -in Without_n_${sample} -out ${o}/02-Alignments/MO/02_alignments_trimal/${sample} -gappyout" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of Without_n_${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi 
    else
      if [ "${trimal_function}" = "automated1" ]; then
        trimal -in "${sample}" -out ${o}/02-Alignments/MO/02_alignments_trimal/${sample} -automated1 > /dev/null 2>&1
        echo "[CMD]:              trimal -in ${sample} -out ${o}/02-Alignments/MO/02_alignments_trimal/${sample} -automated1" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of ${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "${sample}" -out ${o}/02-Alignments/MO/02_alignments_trimal/${sample} -gt ${trimal_gt} > /dev/null 2>&1
        echo "[CMD]:              trimal -in ${sample} -out ${o}/02-Alignments/MO/02_alignments_trimal/${sample} -gt ${trimal_gt}" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of ${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "${sample}" -out ${o}/02-Alignments/MO/02_alignments_trimal/${sample} -gappyout > /dev/null 2>&1
        echo "[CMD]:              trimal -in ${sample} -out ${o}/02-Alignments/MO/02_alignments_trimal/${sample} -gappyout" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of ${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi 
    fi   
    done
  fi
  
# (2) concatenate trimmed alignments
  pxcat \
  -s ${o}/02-Alignments/MO/02_alignments_trimal/*.f* \
  -p ${o}/03-Supermatrix/MO/partition.txt \
  -o ${o}/03-Supermatrix/MO/${prefix}_MO.fasta
  echo "[CMD]:              pxcat -s ${o}/02-Alignments/MO/02_alignments_trimal/*.f* -p ${o}/03-Supermatrix/MO/partition.txt -o ${o}/03-Supermatrix/MO/${prefix}_MO.fasta" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  if [ -s "${o}/03-Supermatrix/MO/${prefix}_MO.fasta" ]; then
    echo "[HybSuite-INFO]:    Successfully concatenate MO alignments to the supermatrix." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  else
    echo "[Warning]:          Fail to concatenate MO alignments to the supermatrix." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    echo "[HybSuite-INFO]:    HybSuite exits" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    exit 1
  fi
  
 #（3）Use phyx/AMAS to check sequences
  ###00-Set the directory
  cd ${o}/03-Supermatrix/MO

  ###01-phyx
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "[HybSuite-INFO]:    Run phyx to check the supermatrix ${prefix}_MO.fasta..." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  tp_1to1_phyx=$(pxlssq -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta -m)
  echo "[CMD]:              pxlssq -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta -m" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "[HybSuite-INFO]:    The missing percent of the supermatrix of ${prefix}_MO.fasta is ${tp_1to1_phyx}" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  pxlssq -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta > "${o}/00-logs_and_checklists/logs/Situation_report_of_${prefix}_supermatrix.txt"
  echo "[CMD]:              pxlssq -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta > ${o}/00-logs_and_checklists/logs/Situation_report_of_${prefix}_supermatrix.txt" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"

  ###02-AMAS
  if [ "$run_AMAS" != "FALSE" ]; then
    mkdir -p ${o}/03-Supermatrix/MO/AMAS
    python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
    summary -f fasta -d dna -i ${o}/03-Supermatrix/MO/${prefix}_MO.fasta \
    -o ./AMAS/AMAS_test.txt > /dev/null 2>&1
    echo "[CMD]:              python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${o}/03-Supermatrix/MO/${prefix}_MO.fasta -o ./AMAS/AMAS_test.txt" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  fi
fi

# MI
if [ "${MI}" = "TRUE" ]; then
  echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "[HybSuite-INFO]:     Trim MI alignments and concatenate them into the supermatrix..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  mkdir -p "${o}/02-Alignments/MI/02_alignments_trimal"
# (1) TrimAl
  if [ "${run_trimal}" = "TRUE" ]; then
    cd "${o}/02-Alignments/MI/01_filtered_alignments"
    for sample in *.fasta; do 
    if [ "$replace_n" = "TRUE" ]; then
      sed -e '/^>/! s/n/-/g'  ${sample} > "Without_n_${sample}"
      if [ "${trimal_function}" = "automated1" ]; then
        trimal -in "Without_n_${sample}" -out ${o}/02-Alignments/MI/02_alignments_trimal/${sample} -automated1 > /dev/null 2>&1
        echo "[CMD]:              trimal -in Without_n_${sample} -out ${o}/02-Alignments/MI/02_alignments_trimal/${sample} -automated1" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of Without_n_${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "Without_n_${sample}" -out ${o}/02-Alignments/MI/02_alignments_trimal/${sample} -gt ${trimal_gt} > /dev/null 2>&1
        echo "[CMD]:              trimal -in Without_n_${sample} -out ${o}/02-Alignments/MI/02_alignments_trimal/${sample} -gt ${trimal_gt}" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of Without_n_${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "Without_n_${sample}" -out ${o}/02-Alignments/MI/02_alignments_trimal/${sample} -gappyout > /dev/null 2>&1
        echo "[CMD]:              trimal -in Without_n_${sample} -out ${o}/02-Alignments/MI/02_alignments_trimal/${sample} -gappyout" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of Without_n_${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi 
    else
      if [ "${trimal_function}" = "automated1" ]; then
        trimal -in "${sample}" -out ${o}/02-Alignments/MI/02_alignments_trimal/${sample} -automated1 > /dev/null 2>&1
        echo "[CMD]:              trimal -in ${sample} -out ${o}/02-Alignments/MI/02_alignments_trimal/${sample} -automated1" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of ${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "${sample}" -out ${o}/02-Alignments/MI/02_alignments_trimal/${sample} -gt ${trimal_gt} > /dev/null 2>&1
        echo "[CMD]:              trimal -in ${sample} -out ${o}/02-Alignments/MI/02_alignments_trimal/${sample} -gt ${trimal_gt}" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of ${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "${sample}" -out ${o}/02-Alignments/MI/02_alignments_trimal/${sample} -gappyout > /dev/null 2>&1
        echo "[CMD]:              trimal -in ${sample} -out ${o}/02-Alignments/MI/02_alignments_trimal/${sample} -gappyout" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of ${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi 
    fi   
    done
  fi
  
# (2) concatenate trimmed alignments
  pxcat \
  -s ${o}/02-Alignments/MI/02_alignments_trimal/*.f* \
  -p ${o}/03-Supermatrix/MI/partition.txt \
  -o ${o}/03-Supermatrix/MI/${prefix}_MI.fasta
  echo "[CMD]:              pxcat -s ${o}/02-Alignments/MI/02_alignments_trimal/*.f* -p ${o}/03-Supermatrix/MI/partition.txt -o ${o}/03-Supermatrix/MI/${prefix}_MI.fasta" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  if [ -s "${o}/03-Supermatrix/MI/${prefix}_MI.fasta" ]; then
    echo "[HybSuite-INFO]:    Successfully concatenate MI alignments to the supermatrix." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  else
    echo "[Warning]:          Fail to concatenate MI alignments to the supermatrix." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    echo "[HybSuite-INFO]:    HybSuite exits" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    exit 1
  fi
  
 #（3）Use phyx/AMAS to check sequences
  ###00-Set the directory
  cd ${o}/03-Supermatrix/MI

  ###01-phyx
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "[HybSuite-INFO]:    Run phyx to check the supermatrix ${prefix}_MI.fasta..." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  tp_1to1_phyx=$(pxlssq -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta -m)
  echo "[CMD]:              pxlssq -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta -m" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "[HybSuite-INFO]:    The missing percent of the supermatrix of ${prefix}_MI.fasta is ${tp_1to1_phyx}" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  pxlssq -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta > "${o}/00-logs_and_checklists/logs/Situation_report_of_${prefix}_supermatrix.txt"
  echo "[CMD]:              pxlssq -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta > ${o}/00-logs_and_checklists/logs/Situation_report_of_${prefix}_supermatrix.txt" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"

  ###02-AMAS
  if [ "$run_AMAS" != "FALSE" ]; then
    mkdir -p ${o}/03-Supermatrix/MI/AMAS
    python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
    summary -f fasta -d dna -i ${o}/03-Supermatrix/MI/${prefix}_MI.fasta \
    -o ./AMAS/AMAS_test.txt > /dev/null 2>&1
    echo "[CMD]:              python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${o}/03-Supermatrix/MI/${prefix}_MI.fasta -o ./AMAS/AMAS_test.txt" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  fi
fi

### RT
if [ "${RT}" = "TRUE" ]; then
  echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "[HybSuite-INFO]:     Trim RT alignments and concatenate them into the supermatrix..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  mkdir -p "${o}/02-Alignments/RT/02_alignments_trimal"
# (1) TrimAl
  if [ "${run_trimal}" = "TRUE" ]; then
    cd "${o}/02-Alignments/RT/01_filtered_alignments"
    for sample in *.fasta; do 
    if [ "$replace_n" = "TRUE" ]; then
      sed -e '/^>/! s/n/-/g'  ${sample} > "Without_n_${sample}"
      if [ "${trimal_function}" = "automated1" ]; then
        trimal -in "Without_n_${sample}" -out ${o}/02-Alignments/RT/02_alignments_trimal/${sample} -automated1 > /dev/null 2>&1
        echo "[CMD]:              trimal -in Without_n_${sample} -out ${o}/02-Alignments/RT/02_alignments_trimal/${sample} -automated1" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of Without_n_${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "Without_n_${sample}" -out ${o}/02-Alignments/RT/02_alignments_trimal/${sample} -gt ${trimal_gt} > /dev/null 2>&1
        echo "[CMD]:              trimal -in Without_n_${sample} -out ${o}/02-Alignments/RT/02_alignments_trimal/${sample} -gt ${trimal_gt}" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of Without_n_${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "Without_n_${sample}" -out ${o}/02-Alignments/RT/02_alignments_trimal/${sample} -gappyout > /dev/null 2>&1
        echo "[CMD]:              trimal -in Without_n_${sample} -out ${o}/02-Alignments/RT/02_alignments_trimal/${sample} -gappyout" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of Without_n_${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi 
    else
      if [ "${trimal_function}" = "automated1" ]; then
        trimal -in "${sample}" -out ${o}/02-Alignments/RT/02_alignments_trimal/${sample} -automated1 > /dev/null 2>&1
        echo "[CMD]:              trimal -in ${sample} -out ${o}/02-Alignments/RT/02_alignments_trimal/${sample} -automated1" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of ${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "${sample}" -out ${o}/02-Alignments/RT/02_alignments_trimal/${sample} -gt ${trimal_gt} > /dev/null 2>&1
        echo "[CMD]:              trimal -in ${sample} -out ${o}/02-Alignments/RT/02_alignments_trimal/${sample} -gt ${trimal_gt}" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of ${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "${sample}" -out ${o}/02-Alignments/RT/02_alignments_trimal/${sample} -gappyout > /dev/null 2>&1
        echo "[CMD]:              trimal -in ${sample} -out ${o}/02-Alignments/RT/02_alignments_trimal/${sample} -gappyout" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of ${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi 
    fi   
    done
  fi
  
# (2) concatenate trimmed alignments
  pxcat \
  -s ${o}/02-Alignments/RT/02_alignments_trimal/*.f* \
  -p ${o}/03-Supermatrix/RT/partition.txt \
  -o ${o}/03-Supermatrix/RT/${prefix}_RT.fasta
  echo "[CMD]:              pxcat -s ${o}/02-Alignments/RT/02_alignments_trimal/*.f* -p ${o}/03-Supermatrix/RT/partition.txt -o ${o}/03-Supermatrix/RT/${prefix}_RT.fasta" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  if [ -s "${o}/03-Supermatrix/RT/${prefix}_RT.fasta" ]; then
    echo "[HybSuite-INFO]:    Successfully concatenate RT alignments to the supermatrix." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  else
    echo "[Warning]:          Fail to concatenate RT alignments to the supermatrix." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    echo "[HybSuite-INFO]:    HybSuite exits" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    exit 1
  fi
  
 #（3）Use phyx/AMAS to check sequences
  ###00-Set the directory
  cd ${o}/03-Supermatrix/RT

  ###01-phyx
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "[HybSuite-INFO]:    Run phyx to check the supermatrix ${prefix}_RT.fasta..." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  tp_1to1_phyx=$(pxlssq -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta -m)
  echo "[CMD]:              pxlssq -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta -m" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "[HybSuite-INFO]:    The missing percent of the supermatrix of ${prefix}_RT.fasta is ${tp_1to1_phyx}" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  pxlssq -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta > "${o}/00-logs_and_checklists/logs/Situation_report_of_${prefix}_supermatrix.txt"
  echo "[CMD]:              pxlssq -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta > ${o}/00-logs_and_checklists/logs/Situation_report_of_${prefix}_supermatrix.txt" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"

  ###02-AMAS
  if [ "$run_AMAS" != "FALSE" ]; then
    mkdir -p ${o}/03-Supermatrix/RT/AMAS
    python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
    summary -f fasta -d dna -i ${o}/03-Supermatrix/RT/${prefix}_RT.fasta \
    -o ./AMAS/AMAS_test.txt > /dev/null 2>&1
    echo "[CMD]:              python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${o}/03-Supermatrix/RT/${prefix}_RT.fasta -o ./AMAS/AMAS_test.txt" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  fi
fi

#1to1
if [ "${one_to_one}" = "TRUE" ]; then
  echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "[HybSuite-INFO]:     Trim 1to1 alignments and concatenate them into the supermatrix..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  mkdir -p "${o}/02-Alignments/1to1/02_alignments_trimal"
# (1) TrimAl
  if [ "${run_trimal}" = "TRUE" ]; then
    cd "${o}/02-Alignments/1to1/01_filtered_alignments/"
    for sample in *.fasta; do 
    if [ "$replace_n" = "TRUE" ]; then
      sed -e '/^>/! s/n/-/g'  ${sample} > "Without_n_${sample}"
      if [ "${trimal_function}" = "automated1" ]; then
        trimal -in "Without_n_${sample}" -out ${o}/02-Alignments/1to1/02_alignments_trimal/${sample} -automated1 > /dev/null 2>&1
        echo "[CMD]:              trimal -in Without_n_${sample} -out ${o}/02-Alignments/1to1/02_alignments_trimal/${sample} -automated1" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of Without_n_${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "Without_n_${sample}" -out ${o}/02-Alignments/1to1/02_alignments_trimal/${sample} -gt ${trimal_gt} > /dev/null 2>&1
        echo "[CMD]:              trimal -in Without_n_${sample} -out ${o}/02-Alignments/1to1/02_alignments_trimal/${sample} -gt ${trimal_gt}" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of Without_n_${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "Without_n_${sample}" -out ${o}/02-Alignments/1to1/02_alignments_trimal/${sample} -gappyout > /dev/null 2>&1
        echo "[CMD]:              trimal -in Without_n_${sample} -out ${o}/02-Alignments/1to1/02_alignments_trimal/${sample} -gappyout" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of Without_n_${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi 
    else
      if [ "${trimal_function}" = "automated1" ]; then
        trimal -in "${sample}" -out ${o}/02-Alignments/1to1/02_alignments_trimal/${sample} -automated1 > /dev/null 2>&1
        echo "[CMD]:              trimal -in ${sample} -out ${o}/02-Alignments/1to1/02_alignments_trimal/${sample} -automated1" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of ${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
      if [ "${trimal_function}" = "gt" ]; then
        trimal -in "${sample}" -out ${o}/02-Alignments/1to1/02_alignments_trimal/${sample} -gt ${trimal_gt} > /dev/null 2>&1
        echo "[CMD]:              trimal -in ${sample} -out ${o}/02-Alignments/1to1/02_alignments_trimal/${sample} -gt ${trimal_gt}" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of ${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        trimal -in "${sample}" -out ${o}/02-Alignments/1to1/02_alignments_trimal/${sample} -gappyout > /dev/null 2>&1
        echo "[CMD]:              trimal -in ${sample} -out ${o}/02-Alignments/1to1/02_alignments_trimal/${sample} -gappyout" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        echo "[HybSuite-INFO]:    Succeed in trimming the alignment of ${sample}."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi 
    fi   
    done
  fi
  
# (2) concatenate trimmed alignments
  pxcat \
  -s ${o}/02-Alignments/1to1/02_alignments_trimal/*.f* \
  -p ${o}/03-Supermatrix/1to1/partition.txt \
  -o ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta
  echo "[CMD]:              pxcat -s ${o}/02-Alignments/1to1/02_alignments_trimal/*.f* -p ${o}/03-Supermatrix/1to1/partition.txt -o ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  if [ -s "${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta" ]; then
    echo "[HybSuite-INFO]:    Successfully concatenate 1to1 alignments to the supermatrix." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  else
    echo "[Warning]:          Fail to concatenate 1to1 alignments to the supermatrix." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    echo "[HybSuite-INFO]:    HybSuite exits" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    exit 1
  fi
  
 #（3）Use phyx/AMAS to check sequences
  ###00-Set the directory
  cd ${o}/03-Supermatrix/1to1

  ###01-phyx
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "[HybSuite-INFO]:    Run phyx to check the supermatrix ${prefix}_1to1.fasta..." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  tp_1to1_phyx=$(pxlssq -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta -m)
  echo "[CMD]:              pxlssq -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta -m" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "[HybSuite-INFO]:    The missing percent of the supermatrix of ${prefix}_1to1.fasta is ${tp_1to1_phyx}" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  pxlssq -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta > "${o}/00-logs_and_checklists/logs/Situation_reports_of_${prefix}_supermatrix.txt"
  echo "[CMD]:              pxlssq -s ${o}/03-Supermatrix/1to1/${prefix}_MI.fasta > ${o}/00-logs_and_checklists/logs/Situation_report_of_${prefix}_supermatrix.txt" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"

  ###02-AMAS
  if [ "$run_AMAS" != "FALSE" ]; then
    mkdir -p ${o}/03-Supermatrix/1to1/AMAS
    python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
    summary -f fasta -d dna -i ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta \
    -o ./AMAS/AMAS_test.txt > /dev/null 2>&1
    echo "[CMD]:              python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py summary -f fasta -d dna -i ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta -o ./AMAS/AMAS_test.txt" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  fi
fi

#2. ModelTest-NG (Optional)
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
    echo "[CMD]:              modeltest-ng -d nt --force -p ${nt_modeltest_ng} -i ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta -o ${o}/04-ModelTest-NG/HRS/${prefix}_modeltest.txt -T raxml" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    echo "[HybSuite-INFO]:    Running ModelTest-NG for the HRS supermatrix ... " | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    ###02-According to the result, assign different variables to the suggested commands for each tree building software
    HRS_iqtree=$(grep -n 'iqtree' ${o}/04-ModelTest-NG/HRS/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*iqtree/iqtree/g')
    HRS_raxml_ng_mtest=$(grep -n 'raxml-ng' ${o}/04-ModelTest-NG/HRS/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxml-ng/raxml-ng/g')
    HRS_raxmlHPC_mtest=$(grep -n 'raxmlHPC' ${o}/04-ModelTest-NG/HRS/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxmlHPC/raxmlHPC/g; s/ -n .*//')
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
    echo "[CMD]:              modeltest-ng -d nt --force -p ${nt_modeltest_ng} -i ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta -o ${o}/04-ModelTest-NG/RAPP/${prefix}_modeltest.txt -T raxml" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    echo "[HybSuite-INFO]:    Running ModelTest-NG for the RAPP supermatrix ... " | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    ###02-According to the result, assign different variables to the suggested commands for each tree building software
    RAPP_iqtree=$(grep -n 'iqtree' ${o}/04-ModelTest-NG/RAPP/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*iqtree/iqtree/g')
    RAPP_raxml_ng_mtest=$(grep -n 'raxml-ng' ${o}/04-ModelTest-NG/RAPP/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxml-ng/raxml-ng/g')
    RAPP_raxmlHPC_mtest=$(grep -n 'raxmlHPC' ${o}/04-ModelTest-NG/RAPP/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxmlHPC/raxmlHPC/g; s/ -n .*//')
  fi
fi
#(3) MO
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
    echo "[CMD]:              modeltest-ng -d nt --force -p ${nt_modeltest_ng} -i ${o}/03-Supermatrix/MO/${prefix}_MO.fasta -o ${o}/04-ModelTest-NG/MO/${prefix}_modeltest.txt -T raxml" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    echo "[HybSuite-INFO]:    Running ModelTest-NG for the MO supermatrix ... " | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    ###02-According to the result, assign different variables to the suggested commands for each tree building software
    MO_iqtree=$(grep -n 'iqtree' ${o}/04-ModelTest-NG/MO/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*iqtree/iqtree/g')
    MO_raxml_ng_mtest=$(grep -n 'raxml-ng' ${o}/04-ModelTest-NG/MO/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxml-ng/raxml-ng/g')
    MO_raxmlHPC_mtest=$(grep -n 'raxmlHPC' ${o}/04-ModelTest-NG/MO/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxmlHPC/raxmlHPC/g; s/ -n .*//')
  fi
fi
#(4) MI
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
    echo "[CMD]:              modeltest-ng -d nt --force -p ${nt_modeltest_ng} -i ${o}/03-Supermatrix/MI/${prefix}_MI.fasta -o ${o}/04-ModelTest-NG/MI/${prefix}_modeltest.txt -T raxml" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    echo "[HybSuite-INFO]:    Running ModelTest-NG for the MI supermatrix ... " | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    ###02-According to the result, assign different variables to the suggested commands for each tree building software
    MI_iqtree=$(grep -n 'iqtree' ${o}/04-ModelTest-NG/MI/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*iqtree/iqtree/g')
    MI_raxml_ng_mtest=$(grep -n 'raxml-ng' ${o}/04-ModelTest-NG/MI/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxml-ng/raxml-ng/g')
    MI_raxmlHPC_mtest=$(grep -n 'raxmlHPC' ${o}/04-ModelTest-NG/MI/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxmlHPC/raxmlHPC/g; s/ -n .*//')
  fi
fi
#(5) RT
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
    echo "[CMD]:              modeltest-ng -d nt --force -p ${nt_modeltest_ng} -i ${o}/03-Supermatrix/RT/${prefix}_RT.fasta -o ${o}/04-ModelTest-NG/RT/${prefix}_modeltest.txt -T raxml" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    echo "[HybSuite-INFO]:    Running ModelTest-NG for the RT supermatrix ... " | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    ###02-According to the result, assign different variables to the suggested commands for each tree building software
    RT_iqtree=$(grep -n 'iqtree' ${o}/04-ModelTest-NG/RT/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*iqtree/iqtree/g')
    RT_raxml_ng_mtest=$(grep -n 'raxml-ng' ${o}/04-ModelTest-NG/RT/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxml-ng/raxml-ng/g')
    RT_raxmlHPC_mtest=$(grep -n 'raxmlHPC' ${o}/04-ModelTest-NG/RT/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxmlHPC/raxmlHPC/g; s/ -n .*//')
  fi
fi
#(6) 1to1
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
    echo "[CMD]:              modeltest-ng -d nt --force -p ${nt_modeltest_ng} -i ${o}/03-Supermatrix/RT/${prefix}_RT.fasta -o ${o}/04-ModelTest-NG/RT/${prefix}_modeltest.txt -T raxml" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    echo "[HybSuite-INFO]:    Running ModelTest-NG for the 1to1 supermatrix..." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    ###02-According to the result, assign different variables to the suggested commands for each tree building software
    1to1_iqtree=$(grep -n 'iqtree' ${o}/04-ModelTest-NG/1to1/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*iqtree/iqtree/g')
    1to1_raxml_ng_mtest=$(grep -n 'raxml-ng' ${o}/04-ModelTest-NG/1to1/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxml-ng/raxml-ng/g')
    1to1_raxmlHPC_mtest=$(grep -n 'raxmlHPC' ${o}/04-ModelTest-NG/1to1/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxmlHPC/raxmlHPC/g; s/ -n .*//')
  fi
fi
#3. Construct contenated trees (IQTREE, RAxML-NG, or RAxMLHPC)
#01-IQTREE #############################
#(1) HRS
if [ "${run_iqtree}" = "TRUE" ]; then
  if [ "${HRS}" = "TRUE" ]; then 
  ##01-1 Set the directory
    mkdir -p ${o}/05-Concatenated_trees/HRS/IQTREE
    cd ${o}/05-Concatenated_trees/HRS/IQTREE
    echo "[HybSuite-INFO]:    Running IQTREE for HRS alignments..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  ##01-2 run IQTREE
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${HRS_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_HRS \
          -p ${o}/03-Supermatrix/HRS/partition.txt
          echo "[CMD]:              ${HRS_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_HRS -p ${o}/03-Supermatrix/HRS/partition.txt"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          ${HRS_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_HRS -g "${iqtree_constraint_tree}" \
          -p ${o}/03-Supermatrix/HRS/partition.txt
          echo "[CMD]:              ${HRS_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_HRS -g ${iqtree_constraint_tree} -p ${o}/03-Supermatrix/HRS/partition.txt"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${HRS_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_HRS
          echo "[CMD]:              ${HRS_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_HRS"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          ${HRS_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_HRS -g "${iqtree_constraint_tree}"
          echo "[CMD]:              ${HRS_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_HRS -g ${iqtree_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      fi
    else
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/HRS/partition.txt -m MFP \
          -pre IQTREE_${prefix}_HRS
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/HRS/partition.txt -m MFP -pre IQTREE_${prefix}_HRS"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          iqtree -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/HRS/partition.txt -m MFP \
          -pre IQTREE_${prefix}_HRS -g "${iqtree_constraint_tree}"
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/HRS/partition.txt -m MFP -pre IQTREE_${prefix}_HRS -g ${iqtree_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta \
          -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_HRS
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_HRS"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          iqtree -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta \
          -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_HRS -g "${iqtree_constraint_tree}"
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_HRS -g ${iqtree_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      fi
    fi
  ##01-3 Check if IQ-TREE was successfully ran.
    if [ ! -s "IQTREE_${prefix}_HRS.treefile" ]; then
      echo "[ERROR]:            Error: fail to run IQ-TREE."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    HybSuite exits."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      exit 1
    else 
      echo "[HybSuite-INFO]:    Successfully finish running IQ-TREE."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  ##01-4 reroot the tree via phyx
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line; do
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
    echo "[HybSuite-INFO]:    Use phyx to reroot the tree (IQTREE)..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    echo "[CMD]:              $cmd > ./IQTREE_rr_${prefix}_HRS.tre ..." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    eval "$cmd > ./IQTREE_rr_${prefix}_HRS.tre"
    if [ ! -s "./IQTREE_rr_${prefix}_HRS.tre" ]; then
      echo "[WARNING]:          Fail to reroot the tree: "  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    ${o}/05-Concatenated_trees/HRS/IQTREE/IQTREE_${prefix}_HRS.treefile."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Please check your alignments and trees produced by IQTREE."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    else
      echo "[HybSuite-INFO]:    Successfully reroot the IQ-TREE tree."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Successfully finish all the IQ-TREE routine for HRS alignments."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Now moving on to the next step..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  fi
fi

#(2) RAPP
if [ "${run_iqtree}" = "TRUE" ]; then
  if [ "${RAPP}" = "TRUE" ]; then 
  ##01-1 Set the directory
    mkdir -p ${o}/05-Concatenated_trees/RAPP/IQTREE
    cd ${o}/05-Concatenated_trees/RAPP/IQTREE
    echo "[HybSuite-INFO]:    Running IQTREE for RAPP alignments..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  ##01-2 run IQTREE
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${RAPP_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_RAPP \
          -p ${o}/03-Supermatrix/RAPP/partition.txt
          echo "[CMD]:              ${RAPP_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_RAPP -p ${o}/03-Supermatrix/RAPP/partition.txt"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          ${RAPP_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_RAPP -g "${iqtree_constraint_tree}" \
          -p ${o}/03-Supermatrix/RAPP/partition.txt
          echo "[CMD]:              ${RAPP_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_RAPP -g ${iqtree_constraint_tree} -p ${o}/03-Supermatrix/RAPP/partition.txt"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${RAPP_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_RAPP
          echo "[CMD]:              ${RAPP_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_RAPP"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          ${RAPP_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_RAPP -g "${iqtree_constraint_tree}"
          echo "[CMD]:              ${RAPP_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_RAPP -g ${iqtree_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      fi
    else
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/RAPP/partition.txt -m MFP \
          -pre IQTREE_${prefix}_RAPP
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/RAPP/partition.txt -m MFP -pre IQTREE_${prefix}_RAPP"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          iqtree -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/RAPP/partition.txt -m MFP \
          -pre IQTREE_${prefix}_RAPP -g "${iqtree_constraint_tree}"
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/RAPP/partition.txt -m MFP -pre IQTREE_${prefix}_RAPP -g ${iqtree_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta \
          -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_RAPP
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_RAPP"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          iqtree -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta \
          -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_RAPP -g "${iqtree_constraint_tree}"
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_RAPP -g ${iqtree_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      fi
    fi
  ##01-3 Check if IQ-TREE was successfully ran.
    if [ ! -s "IQTREE_${prefix}_RAPP.treefile" ]; then
      echo "[ERROR]:            Error: fail to run IQ-TREE."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    HybSuite exits."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      exit 1
    else 
      echo "[HybSuite-INFO]:    Successfully finish running IQ-TREE."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  ##01-4 reroot the tree via phyx
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line; do
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
    echo "[HybSuite-INFO]:    Use phyx to reroot the tree (IQTREE)..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    echo "[CMD]:              $cmd > ./IQTREE_rr_${prefix}_RAPP.tre ..." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    eval "$cmd > ./IQTREE_rr_${prefix}_RAPP.tre"
    if [ ! -s "./IQTREE_rr_${prefix}_RAPP.tre" ]; then
      echo "[WARNING]:          Fail to reroot the tree: "  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    ${o}/05-Concatenated_trees/RAPP/IQTREE/IQTREE_${prefix}_RAPP.treefile."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Please check your alignments and trees produced by IQTREE."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    else
      echo "[HybSuite-INFO]:    Successfully reroot the IQ-TREE tree."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Successfully finish all the IQ-TREE routine for RAPP alignments."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Now moving on to the next step..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  fi
fi


#(3) MO
if [ "${run_iqtree}" = "TRUE" ]; then
  if [ "${MO}" = "TRUE" ]; then 
  ##01-1 Set the directory
    mkdir -p ${o}/05-Concatenated_trees/MO/IQTREE
    cd ${o}/05-Concatenated_trees/MO/IQTREE
    echo "[HybSuite-INFO]:    Running IQTREE for MO alignments..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  ##01-2 run IQTREE
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${MO_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_MO \
          -p ${o}/03-Supermatrix/MO/partition.txt
          echo "[CMD]:              ${MO_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_MO -p ${o}/03-Supermatrix/MO/partition.txt"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          ${MO_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_MO -g "${iqtree_constraint_tree}" \
          -p ${o}/03-Supermatrix/MO/partition.txt
          echo "[CMD]:              ${MO_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_MO -g ${iqtree_constraint_tree} -p ${o}/03-Supermatrix/MO/partition.txt"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${MO_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_MO
          echo "[CMD]:              ${MO_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_MO"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          ${MO_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_MO -g "${iqtree_constraint_tree}"
          echo "[CMD]:              ${MO_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_MO -g ${iqtree_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      fi
    else
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/MO/partition.txt -m MFP \
          -pre IQTREE_${prefix}_MO
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/MO/partition.txt -m MFP -pre IQTREE_${prefix}_MO"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          iqtree -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/MO/partition.txt -m MFP \
          -pre IQTREE_${prefix}_MO -g "${iqtree_constraint_tree}"
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/MO/partition.txt -m MFP -pre IQTREE_${prefix}_MO -g ${iqtree_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta \
          -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_MO
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_MO"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          iqtree -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta \
          -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_MO -g "${iqtree_constraint_tree}"
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_MO -g ${iqtree_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      fi
    fi
  ##01-3 Check if IQ-TREE was successfully ran.
    if [ ! -s "IQTREE_${prefix}_MO.treefile" ]; then
      echo "[ERROR]:            Error: fail to run IQ-TREE."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    HybSuite exits."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      exit 1
    else 
      echo "[HybSuite-INFO]:    Successfully finish running IQ-TREE."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  ##01-4 reroot the tree via phyx
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line; do
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
    echo "[HybSuite-INFO]:    Use phyx to reroot the tree (IQTREE)..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    echo "[CMD]:              $cmd > ./IQTREE_rr_${prefix}_MO.tre ..." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    eval "$cmd > ./IQTREE_rr_${prefix}_MO.tre"
    if [ ! -s "./IQTREE_rr_${prefix}_MO.tre" ]; then
      echo "[WARNING]:          Fail to reroot the tree: "  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    ${o}/05-Concatenated_trees/MO/IQTREE/IQTREE_${prefix}_MO.treefile."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Please check your alignments and trees produced by IQTREE."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    else
      echo "[HybSuite-INFO]:    Successfully reroot the IQ-TREE tree."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Successfully finish all the IQ-TREE routine for MO alignments."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Now moving on to the next step..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  fi
fi

#(4) MI
if [ "${run_iqtree}" = "TRUE" ]; then
  if [ "${MI}" = "TRUE" ]; then 
  ##01-1 Set the directory
    mkdir -p ${o}/05-Concatenated_trees/MI/IQTREE
    cd ${o}/05-Concatenated_trees/MI/IQTREE
    echo "[HybSuite-INFO]:    Running IQTREE for MI alignments..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  ##01-2 run IQTREE
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${MI_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_MI \
          -p ${o}/03-Supermatrix/MI/partition.txt
          echo "[CMD]:              ${MI_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_MI -p ${o}/03-Supermatrix/MI/partition.txt"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          ${MI_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_MI -g "${iqtree_constraint_tree}" \
          -p ${o}/03-Supermatrix/MI/partition.txt
          echo "[CMD]:              ${MI_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_MI -g ${iqtree_constraint_tree} -p ${o}/03-Supermatrix/MI/partition.txt"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${MI_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_MI
          echo "[CMD]:              ${MI_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_MI"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          ${MI_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_MI -g "${iqtree_constraint_tree}"
          echo "[CMD]:              ${MI_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_MI -g ${iqtree_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      fi
    else
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/MI/partition.txt -m MFP \
          -pre IQTREE_${prefix}_MI
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/MI/partition.txt -m MFP -pre IQTREE_${prefix}_MI"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          iqtree -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/MI/partition.txt -m MFP \
          -pre IQTREE_${prefix}_MI -g "${iqtree_constraint_tree}"
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/MI/partition.txt -m MFP -pre IQTREE_${prefix}_MI -g ${iqtree_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta \
          -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_MI
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_MI"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          iqtree -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta \
          -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_MI -g "${iqtree_constraint_tree}"
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_MI -g ${iqtree_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      fi
    fi
  ##01-3 Check if IQ-TREE was successfully ran.
    if [ ! -s "IQTREE_${prefix}_MI.treefile" ]; then
      echo "[ERROR]:            Error: fail to run IQ-TREE."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    HybSuite exits."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      exit 1
    else 
      echo "[HybSuite-INFO]:    Successfully finish running IQ-TREE."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  ##01-4 reroot the tree via phyx
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line; do
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
    echo "[HybSuite-INFO]:    Use phyx to reroot the tree (IQTREE)..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    echo "[CMD]:              $cmd > ./IQTREE_rr_${prefix}_MI.tre ..." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    eval "$cmd > ./IQTREE_rr_${prefix}_MI.tre"
    if [ ! -s "./IQTREE_rr_${prefix}_MI.tre" ]; then
      echo "[WARNING]:          Fail to reroot the tree: "  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    ${o}/05-Concatenated_trees/MI/IQTREE/IQTREE_${prefix}_MI.treefile."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Please check your alignments and trees produced by IQTREE."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    else
      echo "[HybSuite-INFO]:    Successfully reroot the IQ-TREE tree."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Successfully finish all the IQ-TREE routine for MI alignments."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Now moving on to the next step..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  fi
fi

#(5) RT
if [ "${run_iqtree}" = "TRUE" ]; then
  if [ "${RT}" = "TRUE" ]; then 
  ##01-1 Set the directory
    mkdir -p ${o}/05-Concatenated_trees/RT/IQTREE
    cd ${o}/05-Concatenated_trees/RT/IQTREE
    echo "[HybSuite-INFO]:    Running IQTREE for RT alignments..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  ##01-2 run IQTREE
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${RT_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_RT \
          -p ${o}/03-Supermatrix/RT/partition.txt
          echo "[CMD]:              ${RT_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_RT -p ${o}/03-Supermatrix/RT/partition.txt"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          ${RT_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_RT -g "${iqtree_constraint_tree}" \
          -p ${o}/03-Supermatrix/RT/partition.txt
          echo "[CMD]:              ${RT_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_RT -g ${iqtree_constraint_tree} -p ${o}/03-Supermatrix/RT/partition.txt"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${RT_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_RT
          echo "[CMD]:              ${RT_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_RT"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          ${RT_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_RT -g "${iqtree_constraint_tree}"
          echo "[CMD]:              ${RT_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_RT -g ${iqtree_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      fi
    else
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/RT/partition.txt -m MFP \
          -pre IQTREE_${prefix}_RT
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/RT/partition.txt -m MFP -pre IQTREE_${prefix}_RT"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          iqtree -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/RT/partition.txt -m MFP \
          -pre IQTREE_${prefix}_RT -g "${iqtree_constraint_tree}"
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/RT/partition.txt -m MFP -pre IQTREE_${prefix}_RT -g ${iqtree_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta \
          -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_RT
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_RT"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          iqtree -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta \
          -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_RT -g "${iqtree_constraint_tree}"
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_RT -g ${iqtree_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      fi
    fi
  ##01-3 Check if IQ-TREE was successfully ran.
    if [ ! -s "IQTREE_${prefix}_RT.treefile" ]; then
      echo "[ERROR]:            Error: fail to run IQ-TREE."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    HybSuite exits."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      exit 1
    else 
      echo "[HybSuite-INFO]:    Successfully finish running IQ-TREE."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  ##01-4 reroot the tree via phyx
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line; do
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
    echo "[HybSuite-INFO]:    Use phyx to reroot the tree (IQTREE)..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    echo "[CMD]:              $cmd > ./IQTREE_rr_${prefix}_RT.tre ..." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    eval "$cmd > ./IQTREE_rr_${prefix}_RT.tre"
    if [ ! -s "./IQTREE_rr_${prefix}_RT.tre" ]; then
      echo "[WARNING]:          Fail to reroot the tree: "  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    ${o}/05-Concatenated_trees/RT/IQTREE/IQTREE_${prefix}_RT.treefile."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Please check your alignments and trees produced by IQTREE."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    else
      echo "[HybSuite-INFO]:    Successfully reroot the IQ-TREE tree."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Successfully finish all the IQ-TREE routine for RT alignments."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Now moving on to the next step..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  fi
fi

#(6) 1to1
if [ "${run_iqtree}" = "TRUE" ]; then
  if [ "${1to1}" = "TRUE" ]; then 
  ##01-1 Set the directory
    mkdir -p ${o}/05-Concatenated_trees/1to1/IQTREE
    cd ${o}/05-Concatenated_trees/1to1/IQTREE
    echo "[HybSuite-INFO]:    Running IQTREE for 1to1 alignments..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  ##01-2 run IQTREE
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${1to1_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_1to1 \
          -p ${o}/03-Supermatrix/1to1/partition.txt
          echo "[CMD]:              ${1to1_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_1to1 -p ${o}/03-Supermatrix/1to1/partition.txt"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          ${1to1_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_1to1 -g "${iqtree_constraint_tree}" \
          -p ${o}/03-Supermatrix/1to1/partition.txt
          echo "[CMD]:              ${1to1_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_1to1 -g ${iqtree_constraint_tree} -p ${o}/03-Supermatrix/1to1/partition.txt"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          ${1to1_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_1to1
          echo "[CMD]:              ${1to1_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_1to1"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          ${1to1_iqtree} -B ${iqtree_bb} \
          -T ${nt_iqtree} -pre IQTREE_${prefix}_1to1 -g "${iqtree_constraint_tree}"
          echo "[CMD]:              ${1to1_iqtree} -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_1to1 -g ${iqtree_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      fi
    else
      if [ "${iqtree_partition}" = "TRUE" ]; then
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/1to1/partition.txt -m MFP \
          -pre IQTREE_${prefix}_1to1
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/1to1/partition.txt -m MFP -pre IQTREE_${prefix}_1to1"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          iqtree -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta \
          --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} \
          -p ${o}/03-Supermatrix/1to1/partition.txt -m MFP \
          -pre IQTREE_${prefix}_1to1 -g "${iqtree_constraint_tree}"
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta --seed 12345 -B ${iqtree_bb} --bnni -T ${nt_iqtree} -p ${o}/03-Supermatrix/1to1/partition.txt -m MFP -pre IQTREE_${prefix}_1to1 -g ${iqtree_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      else
        if [ "${iqtree_constraint_tree}" = "_____" ]; then
          iqtree -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta \
          -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_1to1
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_1to1"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        else
          iqtree -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta \
          -m MFP -B ${iqtree_bb} -T ${nt_iqtree} \
          -pre IQTREE_${prefix}_1to1 -g "${iqtree_constraint_tree}"
          echo "[CMD]:              iqtree -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta -m MFP -B ${iqtree_bb} -T ${nt_iqtree} -pre IQTREE_${prefix}_1to1 -g ${iqtree_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
        fi
      fi
    fi
  ##01-3 Check if IQ-TREE was successfully ran.
    if [ ! -s "IQTREE_${prefix}_1to1.treefile" ]; then
      echo "[ERROR]:            Error: fail to run IQ-TREE."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    HybSuite exits."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      exit 1
    else 
      echo "[HybSuite-INFO]:    Successfully finish running IQ-TREE."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  ##01-4 reroot the tree via phyx
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line; do
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
    echo "[HybSuite-INFO]:    Use phyx to reroot the tree (IQTREE)..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    echo "[CMD]:              $cmd > ./IQTREE_rr_${prefix}_1to1.tre ..." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    eval "$cmd > ./IQTREE_rr_${prefix}_1to1.tre"
    if [ ! -s "./IQTREE_rr_${prefix}_1to1.tre" ]; then
      echo "[WARNING]:          Fail to reroot the tree: "  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    ${o}/05-Concatenated_trees/1to1/IQTREE/IQTREE_${prefix}_1to1.treefile."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Please check your alignments and trees produced by IQTREE."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    else
      echo "[HybSuite-INFO]:    Successfully reroot the IQ-TREE tree."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Successfully finish all the IQ-TREE routine for 1to1 alignments."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Now moving on to the next step..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  fi
fi

#02-RAxML #######################
#(1) HRS
if [ "${run_raxml}" = "TRUE" ]; then
  if [ "${HRS}" = "TRUE" ]; then
##02-1 Set the directory
    cd ${o}/03-Supermatrix/HRS
    mkdir -p ${o}/05-Concatenated_trees/HRS/RAxML
    echo "[HybSuite-INFO]:    Running RAxML for HRS alignments..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
##02-2 Run RAxML
##02-2.1 If the user enables the Add Restriction tree feature (add the --tree-constraint < constraint tree path > parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      raxmlHPC="${HRS_raxmlHPC_mtest} -f a -# ${raxml_bb} -n '${prefix}_HRS.tre' -x ${raxml_x} -w ${o}/05-Concatenated_trees/HRS/RAxML"
      if [ "${raxml_constraint_tree}" != "_____" ]; then
        ${raxmlHPC} -g ${raxml_constraint_tree}
        echo "[CMD]:              ${raxmlHPC} -g ${raxml_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      else
        ${raxmlHPC}
        echo "[CMD]:              ${raxmlHPC}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
    else
      if [ "${raxml_constraint_tree}" = "_____" ]; then
        raxmlHPC-SSE3 -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta \
        -m ${raxml_m} -f a \
        -x ${raxml_x} \
        -# 1000 \
        -n "${prefix}_HRS.tre" -w ${o}/05-Concatenated_trees/HRS/RAxML
        echo "[CMD]:              raxmlHPC-SSE3 -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta -m ${raxml_m} -f a -x ${raxml_x} -# 1000 -n ${prefix}_HRS.tre -w ${o}/05-Concatenated_trees/HRS/RAxML"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      else
        raxmlHPC-SSE3 -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta \
        -m ${raxml_m} -f a \
        -x ${raxml_x} \
        -# 1000 \
        -n "${prefix}_HRS.tre" -w ${o}/05-Concatenated_trees/HRS/RAxML \
        -g ${raxml_constraint_tree}
        echo "[CMD]:              raxmlHPC-SSE3 -s ${o}/03-Supermatrix/HRS/${prefix}_HRS.fasta -m ${raxml_m} -f a -x ${raxml_x} -# 1000 -n ${prefix}_HRS.tre -w ${o}/05-Concatenated_trees/HRS/RAxML -g ${raxml_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
    fi
    if [ ! -s "${o}/05-Concatenated_trees/HRS/RAxML/RAxML_bestTree.${prefix}_HRS.tre" ]; then
      echo "[ERROR]:            Fail to run RAxML."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    HybSuite exits."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      exit 1
    else 
      echo "[HybSuite-INFO]:    Successfully finish running RAxML."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
##02-3 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/HRS/RAxML/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line; do
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
    echo "[HybSuite-INFO]:    Use phyx to reroot the tree (RAxML)..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    eval "$cmd > ./RAxML_rr_${prefix}_HRS.tre"
    echo "[CMD]:              $cmd > ./RAxML_rr_${prefix}_HRS.tre ..." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
# Check if the user ran phyx successfully
    if [ ! -s "./RAxML_rr_${prefix}_HRS.tre" ]; then
      echo "[WARNING]:          Fail to reroot the tree: "  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    ${o}/05-Concatenated_trees/HRS/RAxML/RAxML_bipartitions.${prefix}_HRS.tre."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Please check your alignments and trees produced by RAxML."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    else
      echo "[HybSuite-INFO]:    Successfully reroot the RAxML tree."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Successfully finish all the RAxML routine for HRS alignments..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  fi
fi

#(2) RAPP
if [ "${run_raxml}" = "TRUE" ]; then
  if [ "${RAPP}" = "TRUE" ]; then
##02-1 Set the directory
    cd ${o}/03-Supermatrix/RAPP
    mkdir -p ${o}/05-Concatenated_trees/RAPP/RAxML
    echo "[HybSuite-INFO]:    Running RAxML for RAPP alignments..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
##02-2 Run RAxML
##02-2.1 If the user enables the Add Restriction tree feature (add the --tree-constraint < constraint tree path > parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      raxmlHPC="${RAPP_raxmlHPC_mtest} -f a -# ${raxml_bb} -n '${prefix}_RAPP.tre' -x ${raxml_x} -w ${o}/05-Concatenated_trees/RAPP/RAxML"
      if [ "${raxml_constraint_tree}" != "_____" ]; then
        ${raxmlHPC} -g ${raxml_constraint_tree}
        echo "[CMD]:              ${raxmlHPC} -g ${raxml_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      else
        ${raxmlHPC}
        echo "[CMD]:              ${raxmlHPC}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
    else
      if [ "${raxml_constraint_tree}" = "_____" ]; then
        raxmlHPC-SSE3 -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta \
        -m ${raxml_m} -f a \
        -x ${raxml_x} \
        -# 1000 \
        -n "${prefix}_RAPP.tre" -w ${o}/05-Concatenated_trees/RAPP/RAxML
        echo "[CMD]:              raxmlHPC-SSE3 -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta -m ${raxml_m} -f a -x ${raxml_x} -# 1000 -n ${prefix}_RAPP.tre -w ${o}/05-Concatenated_trees/RAPP/RAxML"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      else
        raxmlHPC-SSE3 -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta \
        -m ${raxml_m} -f a \
        -x ${raxml_x} \
        -# 1000 \
        -n "${prefix}_RAPP.tre" -w ${o}/05-Concatenated_trees/RAPP/RAxML \
        -g ${raxml_constraint_tree}
        echo "[CMD]:              raxmlHPC-SSE3 -s ${o}/03-Supermatrix/RAPP/${prefix}_RAPP.fasta -m ${raxml_m} -f a -x ${raxml_x} -# 1000 -n ${prefix}_RAPP.tre -w ${o}/05-Concatenated_trees/RAPP/RAxML -g ${raxml_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
    fi
    if [ ! -s "${o}/05-Concatenated_trees/RAPP/RAxML/RAxML_bestTree.${prefix}_RAPP.tre" ]; then
      echo "[ERROR]:            Fail to run RAxML."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    HybSuite exits."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      exit 1
    else 
      echo "[HybSuite-INFO]:    Successfully finish running RAxML."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
##02-3 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/RAPP/RAxML/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line; do
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
    echo "[HybSuite-INFO]:    Use phyx to reroot the tree (RAxML)..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    eval "$cmd > ./RAxML_rr_${prefix}_RAPP.tre"
    echo "[CMD]:              $cmd > ./RAxML_rr_${prefix}_RAPP.tre ..." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
# Check if the user ran phyx successfully
    if [ ! -s "./RAxML_rr_${prefix}_RAPP.tre" ]; then
      echo "[WARNING]:          Fail to reroot the tree: "  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    ${o}/05-Concatenated_trees/RAPP/RAxML/RAxML_bipartitions.${prefix}_RAPP.tre."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Please check your alignments and trees produced by RAxML."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    else
      echo "[HybSuite-INFO]:    Successfully reroot the RAxML tree."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Successfully finish all the RAxML routine for RAPP alignments..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  fi
fi

#(3) MO
if [ "${run_raxml}" = "TRUE" ]; then
  if [ "${MO}" = "TRUE" ]; then
##02-1 Set the directory
    cd ${o}/03-Supermatrix/MO
    mkdir -p ${o}/05-Concatenated_trees/MO/RAxML
    echo "[HybSuite-INFO]:    Running RAxML for MO alignments..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
##02-2 Run RAxML
##02-2.1 If the user enables the Add Restriction tree feature (add the --tree-constraint < constraint tree path > parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      raxmlHPC="${MO_raxmlHPC_mtest} -f a -# ${raxml_bb} -n '${prefix}_MO.tre' -x ${raxml_x} -w ${o}/05-Concatenated_trees/MO/RAxML"
      if [ "${raxml_constraint_tree}" != "_____" ]; then
        ${raxmlHPC} -g ${raxml_constraint_tree}
        echo "[CMD]:              ${raxmlHPC} -g ${raxml_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      else
        ${raxmlHPC}
        echo "[CMD]:              ${raxmlHPC}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
    else
      if [ "${raxml_constraint_tree}" = "_____" ]; then
        raxmlHPC-SSE3 -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta \
        -m ${raxml_m} -f a \
        -x ${raxml_x} \
        -# 1000 \
        -n "${prefix}_MO.tre" -w ${o}/05-Concatenated_trees/MO/RAxML
        echo "[CMD]:              raxmlHPC-SSE3 -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta -m ${raxml_m} -f a -x ${raxml_x} -# 1000 -n ${prefix}_MO.tre -w ${o}/05-Concatenated_trees/MO/RAxML"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      else
        raxmlHPC-SSE3 -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta \
        -m ${raxml_m} -f a \
        -x ${raxml_x} \
        -# 1000 \
        -n "${prefix}_MO.tre" -w ${o}/05-Concatenated_trees/MO/RAxML \
        -g ${raxml_constraint_tree}
        echo "[CMD]:              raxmlHPC-SSE3 -s ${o}/03-Supermatrix/MO/${prefix}_MO.fasta -m ${raxml_m} -f a -x ${raxml_x} -# 1000 -n ${prefix}_MO.tre -w ${o}/05-Concatenated_trees/MO/RAxML -g ${raxml_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
    fi
    if [ ! -s "${o}/05-Concatenated_trees/MO/RAxML/RAxML_bestTree.${prefix}_MO.tre" ]; then
      echo "[ERROR]:            Fail to run RAxML."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    HybSuite exits."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      exit 1
    else 
      echo "[HybSuite-INFO]:    Successfully finish running RAxML."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
##02-3 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/MO/RAxML/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line; do
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
    echo "[HybSuite-INFO]:    Use phyx to reroot the tree (RAxML)..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    eval "$cmd > ./RAxML_rr_${prefix}_MO.tre"
    echo "[CMD]:              $cmd > ./RAxML_rr_${prefix}_MO.tre ..." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
# Check if the user ran phyx successfully
    if [ ! -s "./RAxML_rr_${prefix}_MO.tre" ]; then
      echo "[WARNING]:          Fail to reroot the tree: "  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    ${o}/05-Concatenated_trees/MO/RAxML/RAxML_bipartitions.${prefix}_MO.tre."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Please check your alignments and trees produced by RAxML."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    else
      echo "[HybSuite-INFO]:    Successfully reroot the RAxML tree."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Successfully finish all the RAxML routine for MO alignments..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  fi
fi
#(4) MI
if [ "${run_raxml}" = "TRUE" ]; then
  if [ "${MI}" = "TRUE" ]; then
##02-1 Set the directory
    cd ${o}/03-Supermatrix/MI
    mkdir -p ${o}/05-Concatenated_trees/MI/RAxML
    echo "[HybSuite-INFO]:    Running RAxML for MI alignments..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
##02-2 Run RAxML
##02-2.1 If the user enables the Add Restriction tree feature (add the --tree-constraint < constraint tree path > parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      raxmlHPC="${MI_raxmlHPC_mtest} -f a -# ${raxml_bb} -n '${prefix}_MI.tre' -x ${raxml_x} -w ${o}/05-Concatenated_trees/MI/RAxML"
      if [ "${raxml_constraint_tree}" != "_____" ]; then
        ${raxmlHPC} -g ${raxml_constraint_tree}
        echo "[CMD]:              ${raxmlHPC} -g ${raxml_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      else
        ${raxmlHPC}
        echo "[CMD]:              ${raxmlHPC}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
    else
      if [ "${raxml_constraint_tree}" = "_____" ]; then
        raxmlHPC-SSE3 -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta \
        -m ${raxml_m} -f a \
        -x ${raxml_x} \
        -# 1000 \
        -n "${prefix}_MI.tre" -w ${o}/05-Concatenated_trees/MI/RAxML
        echo "[CMD]:              raxmlHPC-SSE3 -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta -m ${raxml_m} -f a -x ${raxml_x} -# 1000 -n ${prefix}_MI.tre -w ${o}/05-Concatenated_trees/MI/RAxML"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      else
        raxmlHPC-SSE3 -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta \
        -m ${raxml_m} -f a \
        -x ${raxml_x} \
        -# 1000 \
        -n "${prefix}_MI.tre" -w ${o}/05-Concatenated_trees/MI/RAxML \
        -g ${raxml_constraint_tree}
        echo "[CMD]:              raxmlHPC-SSE3 -s ${o}/03-Supermatrix/MI/${prefix}_MI.fasta -m ${raxml_m} -f a -x ${raxml_x} -# 1000 -n ${prefix}_MI.tre -w ${o}/05-Concatenated_trees/MI/RAxML -g ${raxml_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
    fi
    if [ ! -s "${o}/05-Concatenated_trees/MI/RAxML/RAxML_bestTree.${prefix}_MI.tre" ]; then
      echo "[ERROR]:            Fail to run RAxML."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    HybSuite exits."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      exit 1
    else 
      echo "[HybSuite-INFO]:    Successfully finish running RAxML."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
##02-3 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/MI/RAxML/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line; do
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
    echo "[HybSuite-INFO]:    Use phyx to reroot the tree (RAxML)..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    eval "$cmd > ./RAxML_rr_${prefix}_MI.tre"
    echo "[CMD]:              $cmd > ./RAxML_rr_${prefix}_MI.tre ..." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
# Check if the user ran phyx successfully
    if [ ! -s "./RAxML_rr_${prefix}_MI.tre" ]; then
      echo "[WARNING]:          Fail to reroot the tree: "  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    ${o}/05-Concatenated_trees/MI/RAxML/RAxML_bipartitions.${prefix}_MI.tre."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Please check your alignments and trees produced by RAxML."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    else
      echo "[HybSuite-INFO]:    Successfully reroot the RAxML tree."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Successfully finish all the RAxML routine for MI alignments..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  fi
fi
#(5) RT
if [ "${run_raxml}" = "TRUE" ]; then
  if [ "${RT}" = "TRUE" ]; then
##02-1 Set the directory
    cd ${o}/03-Supermatrix/RT
    mkdir -p ${o}/05-Concatenated_trees/RT/RAxML
    echo "[HybSuite-INFO]:    Running RAxML for RT alignments..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
##02-2 Run RAxML
##02-2.1 If the user enables the Add Restriction tree feature (add the --tree-constraint < constraint tree path > parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      raxmlHPC="${RT_raxmlHPC_mtest} -f a -# ${raxml_bb} -n '${prefix}_RT.tre' -x ${raxml_x} -w ${o}/05-Concatenated_trees/RT/RAxML"
      if [ "${raxml_constraint_tree}" != "_____" ]; then
        ${raxmlHPC} -g ${raxml_constraint_tree}
        echo "[CMD]:              ${raxmlHPC} -g ${raxml_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      else
        ${raxmlHPC}
        echo "[CMD]:              ${raxmlHPC}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
    else
      if [ "${raxml_constraint_tree}" = "_____" ]; then
        raxmlHPC-SSE3 -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta \
        -m ${raxml_m} -f a \
        -x ${raxml_x} \
        -# 1000 \
        -n "${prefix}_RT.tre" -w ${o}/05-Concatenated_trees/RT/RAxML
        echo "[CMD]:              raxmlHPC-SSE3 -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta -m ${raxml_m} -f a -x ${raxml_x} -# 1000 -n ${prefix}_RT.tre -w ${o}/05-Concatenated_trees/RT/RAxML"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      else
        raxmlHPC-SSE3 -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta \
        -m ${raxml_m} -f a \
        -x ${raxml_x} \
        -# 1000 \
        -n "${prefix}_RT.tre" -w ${o}/05-Concatenated_trees/RT/RAxML \
        -g ${raxml_constraint_tree}
        echo "[CMD]:              raxmlHPC-SSE3 -s ${o}/03-Supermatrix/RT/${prefix}_RT.fasta -m ${raxml_m} -f a -x ${raxml_x} -# 1000 -n ${prefix}_RT.tre -w ${o}/05-Concatenated_trees/RT/RAxML -g ${raxml_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
    fi
    if [ ! -s "${o}/05-Concatenated_trees/RT/RAxML/RAxML_bestTree.${prefix}_RT.tre" ]; then
      echo "[ERROR]:            Fail to run RAxML."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    HybSuite exits."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      exit 1
    else 
      echo "[HybSuite-INFO]:    Successfully finish running RAxML."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
##02-3 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/RT/RAxML/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line; do
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
    echo "[HybSuite-INFO]:    Use phyx to reroot the tree (RAxML)..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    eval "$cmd > ./RAxML_rr_${prefix}_RT.tre"
    echo "[CMD]:              $cmd > ./RAxML_rr_${prefix}_RT.tre ..." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
# Check if the user ran phyx successfully
    if [ ! -s "./RAxML_rr_${prefix}_RT.tre" ]; then
      echo "[WARNING]:          Fail to reroot the tree: "  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    ${o}/05-Concatenated_trees/RT/RAxML/RAxML_bipartitions.${prefix}_RT.tre."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Please check your alignments and trees produced by RAxML."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    else
      echo "[HybSuite-INFO]:    Successfully reroot the RAxML tree."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Successfully finish all the RAxML routine for RT alignments..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  fi
fi
#(6) 1to1
if [ "${run_raxml}" = "TRUE" ]; then
  if [ "${one_to_one}" = "TRUE" ]; then
##02-1 Set the directory
    cd ${o}/03-Supermatrix/1to1
    mkdir -p ${o}/05-Concatenated_trees/1to1/RAxML
    echo "[HybSuite-INFO]:    Running RAxML for 1to1 alignments..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
##02-2 Run RAxML
##02-2.1 If the user enables the Add Restriction tree feature (add the --tree-constraint < constraint tree path > parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ]; then
      raxmlHPC="${1to1_raxmlHPC_mtest} -f a -# ${raxml_bb} -n '${prefix}_1to1.tre' -x ${raxml_x} -w ${o}/05-Concatenated_trees/1to1/RAxML"
      if [ "${raxml_constraint_tree}" != "_____" ]; then
        ${raxmlHPC} -g ${raxml_constraint_tree}
        echo "[CMD]:              ${raxmlHPC} -g ${raxml_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      else
        ${raxmlHPC}
        echo "[CMD]:              ${raxmlHPC}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
    else
      if [ "${raxml_constraint_tree}" = "_____" ]; then
        raxmlHPC-SSE3 -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta \
        -m ${raxml_m} -f a \
        -x ${raxml_x} \
        -# 1000 \
        -n "${prefix}_1to1.tre" -w ${o}/05-Concatenated_trees/1to1/RAxML
        echo "[CMD]:              raxmlHPC-SSE3 -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta -m ${raxml_m} -f a -x ${raxml_x} -# 1000 -n ${prefix}_1to1.tre -w ${o}/05-Concatenated_trees/1to1/RAxML"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      else
        raxmlHPC-SSE3 -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta \
        -m ${raxml_m} -f a \
        -x ${raxml_x} \
        -# 1000 \
        -n "${prefix}_1to1.tre" -w ${o}/05-Concatenated_trees/1to1/RAxML \
        -g ${raxml_constraint_tree}
        echo "[CMD]:              raxmlHPC-SSE3 -s ${o}/03-Supermatrix/1to1/${prefix}_1to1.fasta -m ${raxml_m} -f a -x ${raxml_x} -# 1000 -n ${prefix}_1to1.tre -w ${o}/05-Concatenated_trees/1to1/RAxML -g ${raxml_constraint_tree}"  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      fi
    fi
    if [ ! -s "${o}/05-Concatenated_trees/1to1/RAxML/RAxML_bestTree.${prefix}_1to1.tre" ]; then
      echo "[ERROR]:            Fail to run RAxML."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    HybSuite exits."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      exit 1
    else 
      echo "[HybSuite-INFO]:    Successfully finish running RAxML."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
##02-3 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/1to1/RAxML/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line; do
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
    echo "[HybSuite-INFO]:    Use phyx to reroot the tree (RAxML)..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    eval "$cmd > ./RAxML_rr_${prefix}_1to1.tre"
    echo "[CMD]:              $cmd > ./RAxML_rr_${prefix}_1to1.tre ..." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
# Check if the user ran phyx successfully
    if [ ! -s "./RAxML_rr_${prefix}_1to1.tre" ]; then
      echo "[WARNING]:          Fail to reroot the tree: "  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    ${o}/05-Concatenated_trees/1to1/RAxML/RAxML_bipartitions.${prefix}_1to1.tre."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Please check your alignments and trees produced by RAxML."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    else
      echo "[HybSuite-INFO]:    Successfully reroot the RAxML tree."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "[HybSuite-INFO]:    Successfully finish all the RAxML routine for 1to1 alignments..."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  fi
fi

#03-RAxML-NG ###########################################
#(1) HRS
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
        --prefix ${o}/05-Concatenated_trees/HRS/RAxML-NG/raxml_ng_test --threads 1
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
        --prefix ${o}/05-Concatenated_trees/HRS/RAxML-NG/raxml_ng_test --threads 1
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
        --prefix ${o}/05-Concatenated_trees/HRS/RAxML-NG/raxml_ng_test --threads 1
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
        --prefix ${o}/05-Concatenated_trees/HRS/RAxML-NG/raxml_ng_test --threads 1
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
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      exit 1
    else 
      stage4_info "Successfully finish running RAxML-NG."
      stage4_cmd "Moving on to the next step..."
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
##03 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/HRS/RAxML-NG/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line; do
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
      echo "[WARNING]:          Fail to reroot the tree: "  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    ${o}/05-Concatenated_trees/HRS/RAxML-NG/RAxML-NG_${prefix}_HRS.tre."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      stage4_info "Please check your alignments and trees produced by RAxML-NG."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    else
      stage4_info "Successfully reroot the RAxML-NG tree for HRS alignments."
      stage4_info "Successfully finish all the RAxML-NG routine for HRS alignments..."
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  fi
fi
#(2) RAPP
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
        --prefix ${o}/05-Concatenated_trees/RAPP/RAxML-NG/raxml_ng_test --threads 1
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
        --prefix ${o}/05-Concatenated_trees/RAPP/RAxML-NG/raxml_ng_test --threads 1
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
        --prefix ${o}/05-Concatenated_trees/RAPP/RAxML-NG/raxml_ng_test --threads 1
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
        --prefix ${o}/05-Concatenated_trees/RAPP/RAxML-NG/raxml_ng_test --threads 1
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
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      exit 1
    else 
      stage4_info "Successfully finish running RAxML-NG."
      stage4_cmd "Moving on to the next step..."
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
##03 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/RAPP/RAxML-NG/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line; do
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
      echo "[WARNING]:          Fail to reroot the tree: "  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    ${o}/05-Concatenated_trees/RAPP/RAxML-NG/RAxML-NG_${prefix}_RAPP.tre."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      stage4_info "Please check your alignments and trees produced by RAxML-NG."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    else
      stage4_info "Successfully reroot the RAxML-NG tree for RAPP alignments."
      stage4_info "Successfully finish all the RAxML-NG routine for RAPP alignments..."
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  fi
fi

#(3) MO
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
        --prefix ${o}/05-Concatenated_trees/MO/RAxML-NG/raxml_ng_test --threads 1
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
        --prefix ${o}/05-Concatenated_trees/MO/RAxML-NG/raxml_ng_test --threads 1
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
        --prefix ${o}/05-Concatenated_trees/MO/RAxML-NG/raxml_ng_test --threads 1
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
        --prefix ${o}/05-Concatenated_trees/MO/RAxML-NG/raxml_ng_test --threads 1
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
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      exit 1
    else 
      stage4_info "Successfully finish running RAxML-NG."
      stage4_cmd "Moving on to the next step..."
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
##03 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/MO/RAxML-NG/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line; do
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
      echo "[WARNING]:          Fail to reroot the tree: "  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    ${o}/05-Concatenated_trees/MO/RAxML-NG/RAxML-NG_${prefix}_MO.tre."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      stage4_info "Please check your alignments and trees produced by RAxML-NG."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    else
      stage4_info "Successfully reroot the RAxML-NG tree for MO alignments."
      stage4_info "Successfully finish all the RAxML-NG routine for MO alignments..."
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  fi
fi

#(4) MI
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
        --prefix ${o}/05-Concatenated_trees/MI/RAxML-NG/raxml_ng_test --threads 1
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
        --prefix ${o}/05-Concatenated_trees/MI/RAxML-NG/raxml_ng_test --threads 1
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
        --prefix ${o}/05-Concatenated_trees/MI/RAxML-NG/raxml_ng_test --threads 1
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
        --prefix ${o}/05-Concatenated_trees/MI/RAxML-NG/raxml_ng_test --threads 1
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
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      exit 1
    else 
      stage4_info "Successfully finish running RAxML-NG."
      stage4_cmd "Moving on to the next step..."
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
##03 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/MI/RAxML-NG/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line; do
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
      echo "[WARNING]:          Fail to reroot the tree: "  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    ${o}/05-Concatenated_trees/MI/RAxML-NG/RAxML-NG_${prefix}_MI.tre."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      stage4_info "Please check your alignments and trees produced by RAxML-NG."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    else
      stage4_info "Successfully reroot the RAxML-NG tree for MI alignments."
      stage4_info "Successfully finish all the RAxML-NG routine for MI alignments..."
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  fi
fi

#(5) RT
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
        --prefix ${o}/05-Concatenated_trees/RT/RAxML-NG/raxml_ng_test --threads 1
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
        --prefix ${o}/05-Concatenated_trees/RT/RAxML-NG/raxml_ng_test --threads 1
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
        --prefix ${o}/05-Concatenated_trees/RT/RAxML-NG/raxml_ng_test --threads 1
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
        --prefix ${o}/05-Concatenated_trees/RT/RAxML-NG/raxml_ng_test --threads 1
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
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      exit 1
    else 
      stage4_info "Successfully finish running RAxML-NG."
      stage4_cmd "Moving on to the next step..."
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
##03 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/RT/RAxML-NG/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line; do
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
      echo "[WARNING]:          Fail to reroot the tree: "  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    ${o}/05-Concatenated_trees/RT/RAxML-NG/RAxML-NG_${prefix}_RT.tre."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      stage4_info "It's OK because you use RT method, leading to the removal of outgroups."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    else
      stage4_info "Successfully reroot the RAxML-NG tree for RT alignments."
      stage4_info "Successfully finish all the RAxML-NG routine for RT alignments..."
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  fi
fi

#(6) 1to1
if [ "${run_raxml_ng}" != "FALSE" ] && [ "${run_raxml_ng}" != "False" ]; then
  if [ "${one_to_one}" = "TRUE" ]; then
##01 Set the directory
    mkdir -p ${o}/05-Concatenated_trees/1to1/RAxML-NG
##02 Run RAxML-NG
    stage4_info "Running RAxML-NG for 1to1 alignments..."  
##02.1 If the user sets the rng_force parameter to TRUE, the Ignore Thread warning feature is enabled (add the --force perf_threads parameter)
    if [ "${run_modeltest_ng}" = "TRUE" ] && [ ! -s "${rng_constraint_tree}" ]; then
      raxml_ng="${1to1_raxml_ng_mtest} --all --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/1to1/RAxML-NG/RAxML-NG_${prefix}_1to1 --bs-trees ${rng_bs_trees}"
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
        --prefix ${o}/05-Concatenated_trees/1to1/RAxML-NG/raxml_ng_test --threads 1
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
        --prefix ${o}/05-Concatenated_trees/1to1/RAxML-NG/raxml_ng_test --threads 1
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
      raxml_ng="${1to1_raxml_ng_mtest} --all --threads ${nt_raxml_ng} --prefix ${o}/05-Concatenated_trees/1to1/RAxML-NG/RAxML-NG_${prefix}_1to1 --bs-trees ${rng_bs_trees}"
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
        --prefix ${o}/05-Concatenated_trees/1to1/RAxML-NG/raxml_ng_test --threads 1
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
        --prefix ${o}/05-Concatenated_trees/1to1/RAxML-NG/raxml_ng_test --threads 1
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
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      exit 1
    else 
      stage4_info "Successfully finish running RAxML-NG."
      stage4_cmd "Moving on to the next step..."
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
##03 reroot the tree via phyx
    cd ${o}/05-Concatenated_trees/1to1/RAxML-NG/
# Initializes the row counter
    counter=1
# Dynamically create variables og1, og2, og3...
    while IFS= read -r line; do
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
      echo "[WARNING]:          Fail to reroot the tree: "  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "                    ${o}/05-Concatenated_trees/1to1/RAxML-NG/RAxML-NG_${prefix}_1to1.tre."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      stage4_info "Please check your alignments and trees produced by RAxML-NG."  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
      echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    else
      stage4_info "Successfully reroot the RAxML-NG tree for 1to1 alignments."
      stage4_info "Successfully finish all the RAxML-NG routine for 1to1 alignments..."
      echo ""  | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
    fi
  fi
fi
##Conclusion
if [ "${run_to_trees}" = "true" ]; then
  echo "[HybSuite-INFO]:    You set '--run_to_trees' to specify HybSuite to run from stage1 to stage4." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "                    Consequently, HybSuite will stop and exit right now." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "                    HybSuite exits." | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  echo "" | tee -a "${o}/00-logs_and_checklists/logs/Stage4_From_alignments_to_trees_${current_time}.txt"
  exit 1
fi

#04-PhyloBayes ###########################################