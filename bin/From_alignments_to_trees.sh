# Function to display the help message
###set the run name:
current_time=$(date +"%Y-%m-%d %H:%M:%S")
function display_help {
  echo ""
  echo "Super-Auto-HybPiper v. 1.1.0 released on 7.6.2024 by The Sun Lab.
Developed by: Yuxuan Liu.
Contributors: Miao Sun, Yiying Wang, Xueqin Wang, Liguo Zhang, Tao Xiong , Xiaotong Niu, Xinru Zhang, Xiaowen Ma, Tianxiang Li.
If you have any questions/problems/suggestions，please visit: https://github.com/Yuxuanliu-HZAU/Super-Auto-HybPiper.git\e[0m
Latest version: https://github.com/Yuxuanliu-HZAU/Super-Auto-HybPiper.git"
sed -n '6,$p' ../config/FATCT-help.txt
}

# Function to display the version number
function display_version {
    echo -e "\e[41mVersion: 1.0.0\e[0m"
}

# 切换到脚本所在路径
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$script_dir" || { echo "Error: Failed to change directory."; exit 1; }
while IFS= read -r line || [[ -n $line ]]; do
  var=$(echo "${line}" | awk '{print $1}')
  default=$(echo "${line}" | awk '{print $2}')
  eval "${var}=''"
  eval "Default_${var}='${default}'"
  eval "found_${var}=false"
done < ../config/FATT_vars_list.txt

# Set conditional statements so that options "-h" and "-v" are in play
if [[ "$1" = "-h" || "$1" = "--help" ]]; then
    display_help
    exit 1
fi
if [[ "$1" = "-v" || "$1" = "--version" ]]; then
    display_version
    exit 1
fi

#打印欢迎使用语
python ${script_dir}/../config/SAH-Print_welcome_chars.py
echo -e "\n[INFO]:    FATT (From_alignments_to_trees.sh) was called with these arguments:\n"
while [[ $# -gt 0 ]]; do
    case "$1" in
        -*)
            option="${1/-/}"
			echo "               $option: $2"
            while read -r line; do
                var=$(echo "${line}" | awk '{print $1}')
                if [ "$option" = "$var" ]; then
					eval "${var}=\"$2\""
                    eval "found_${var}=true"
					echo "$option" >> ./Option-list.txt
                    shift 2
                fi
            done < ../config/FATCT_vars_list.txt
            ;;
        *)
            shift
            ;;
    esac
done
cut -f 1 ../config/FATCT_vars_list.txt > ./Option-all-list.txt
sort ./Option-all-list.txt ./Option-list.txt|uniq -u > ./Option-default-list.txt

while read -r line; do
    default_var="Default_${line}"
    default_value="${!default_var}"  # 使用间接引用获取默认值
    eval "${line}=\"$default_value\""  # 设置变量值
    echo "               Using default value for ${line}: ${default_value}"  # 输出默认值
done < ./Option-default-list.txt
rm ./Option*

# 01 Judge if SAH should run trimal sccording to the settings by users
  if diff -q ${o}/01-Hybpiper-results/04-retrieve_sequences/sorted_fileA.txt ${o}/01-Hybpiper-results/04-retrieve_sequences/sorted_fileB.txt >/dev/null && ls ${o}/02-Alignments/HybPiper-retrieved_sequences/Genes_trimal/*.FNA 1> /dev/null 2>&1 && [ "$run_trimal_again" = "FALSE" ]; then
    echo "[SAH-INFO]:    SAH will not run trimal again because the same sequences have been trimmed."
  elif ! find . -maxdepth 1 -name "*.FNA" -size +0c 1> /dev/null 2>&1; then
    echo "[SAH-INFO]:    Error: There are no sequences prepared to run trimal or some FNA files are empty."
    exit 1
  else
    echo "\n[SAH-INFO]:    Runing trimal ...\n"
  fi

if [ ! -e "${o}/00-logs/" ]; then
	mkdir ${o}/00-logs/
fi
if [ ! -e "${o}/01-Genes_trimal/" ]; then
	mkdir ${o}/01-Genes_trimal
fi

if [ ! -e "${o}/02-Genes_trimal_filtered/" ]; then
	mkdir ${o}/02-Genes_trimal_filtered/
fi

if [ ! -e "${o}/03-Supermatrix/" ]; then
	mkdir ${o}/03-Supermatrix/
fi

if [ ! -e "${o}/04-Modeltest-ng/" ]; then
	mkdir ${o}/04-Modeltest-ng/
fi
if [ ! -e "${o}/05-Tree-files/" ]; then
	mkdir ${o}/05-Tree-files/
fi

cd ${i}

  ###01 run trimal in batch mode
files=$(find . -maxdepth 1 -type f)
    all_fasta=true
for file in $files; do
	if [[ "${file##*.}" != "fasta" ]]; then
		all_fasta=false
		break
	fi
done
if [ ${all_fasta} = "true" ]; then
  for sample in *.fasta; do
      if [ "${trimal_function}" = "automated1" ]; then
        echo "[CMD]:     trimal -in "${sample}" -out ${o}/01-Genes_trimal/${sample} -automated1"
        trimal -in "${sample}" -out ${o}/01-Genes_trimal/${sample} -automated1
        echo "[INFO]:    Succeed in trimming ${sample}."
      fi
      if [ "${trimal_function}" = "gt" ]; then
        echo "[CMD]:     trimal -in "${sample}" -out ${o}/01-Genes_trimal/${sample} -gt ${trimal_gt}"
        trimal -in "${sample}" -out ${o}/01-Genes_trimal/${sample} -gt ${trimal_gt}
        echo "[INFO]:    Succeed in trimming ${sample}."
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        echo "[CMD]:     trimal -in "${sample}" -out ${o}/01-Genes_trimal/${sample} -gappyout"
        trimal -in "${sample}" -out ${o}/01-Genes_trimal/${sample} -gappyout
        echo "[INFO]:    Succeed in trimming ${sample}."
      fi
  done
fi

for file in $files; do
	if [[ "${file##*.}" != "fasta" ]]; then
		all_fasta=false
		break
	fi
done
if [ ${all_fasta} = "true" ]; then
  for sample in *.fasta; do
      if [ "${trimal_function}" = "automated1" ]; then
        echo "[CMD]:     trimal -in "${sample}" -out ${o}/01-Genes_trimal/${sample} -automated1"
        trimal -in "${sample}" -out ${o}/01-Genes_trimal/${sample} -automated1
        echo "[INFO]:    Succeed in trimming ${sample}."
      fi
      if [ "${trimal_function}" = "gt" ]; then
        echo "[CMD]:     trimal -in "${sample}" -out ${o}/01-Genes_trimal/${sample} -gt ${trimal_gt}"
        trimal -in "${sample}" -out ${o}/01-Genes_trimal/${sample} -gt ${trimal_gt}
        echo "[INFO]:    Succeed in trimming ${sample}."
      fi  
      if [ "${trimal_function}" = "gappyout" ]; then
        echo "[CMD]:     trimal -in "${sample}" -out ${o}/01-Genes_trimal/${sample} -gappyout"
        trimal -in "${sample}" -out ${o}/01-Genes_trimal/${sample} -gappyout
        echo "[INFO]:    Succeed in trimming ${sample}."
      fi
  done
fi

cp ${o}/01-Genes_trimal/* ${o}/02-Genes_trimal_filtered/

###03 串联得到supermatrix
cd ${o}/02-Genes_trimal_filtered/
files=$(find . -maxdepth 1 -type f)
has_fasta=false
has_fna=false
if [ -s "phyx.logfile" ]; then
  rm phyx.logfile
fi
for file in $files; do
    # Check if it ends with .fasta
    if [[ $(basename "$file") == *.fasta ]]; then
        has_fasta=true
    fi
    # Check if it ends with .FNA
    if [[ $(basename "$file") == *.fna ]]; then
        has_fna=true
    fi
    # If both files are found, end the loop
    if [[ "$has_fasta" == "true" && "$has_fna" == "true" ]]; then
		echo "[WARNING]:          All of the files in ${i} should be only ended with one type, 'fasta' or 'FNA'."
		echo ""
		echo "                    HybTools Exit."
		echo ""
		exit 1
    fi
done
echo "has_fasta: ${has_fasta}"
echo "has_fna: ${has_fna}"
if [[ "$has_fasta" == "true" && "$has_fna" == "false" ]]; then
  pxcat \
  -s ${o}/02-Genes_trimal_filtered/*.fasta \
  -p ${o}/03-Supermatrix/partition.txt \
  -o ${o}/03-Supermatrix/${prefix}_Supermatrix.fasta
fi

if [[ "$has_fasta" == "false" && "$has_fna" == "true" ]]; then
  pxcat \
  -s ${o}/02-Genes_trimal_filtered/*.FNA \
  -p ${o}/03-Supermatrix/partition.txt \
  -o ${o}/03-Supermatrix/${prefix}_Supermatrix.fasta
fi

###04modeltest-ng
# HybPiper_retrieved_sequences
cd ${o}/03-Supermatrix/

if [ -s "${o}/04-Modeltest-ng/${prefix}_modeltest.txt.ckp" ]; then
  rm "${o}/04-Modeltest-ng/${prefix}_modeltest.txt.*"
fi

  ###01-Use modeltest-ng
modeltest-ng -d nt \
--force \
-p ${nt_modeltest_ng} \
-i ${o}/03-Supermatrix/${prefix}_Supermatrix.fasta \
-o ${o}/04-Modeltest-ng/${prefix}_modeltest.txt \
-T raxml

  ###02-根据结果，赋值不同的变量给各个建树软件的建议命令
main_iqtree=$(grep -n 'iqtree' ${o}/04-Modeltest-ng/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*iqtree/iqtree/g')
main_raxml_ng_mtest=$(grep -n 'raxml-ng' ${o}/04-Modeltest-ng/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxml-ng/raxml-ng/g')
main_raxmlHPC_mtest=$(grep -n 'raxmlHPC' ${o}/04-Modeltest-ng/${prefix}_modeltest.txt.log | head -n 3 | tail -n 1 | sed -e 's/^.*raxmlHPC/raxmlHPC/g; s/ -n .*//')

#05 Use phyx/AMAS to check sequences.
###00-Set the directory
cd ${o}/03-Supermatrix/
if [ ! -e "phyx_reports_about_supermatrix" ]; then
mkdir phyx_reports_about_supermatrix
fi

###01-phyx
tp_1to1_phyx=$(pxlssq -s ${o}/03-Supermatrix/${prefix}_Supermatrix.fasta -m)
  echo "[SAH-INFO]:    The missing percent of the supermatrix of ${prefix}_Supermatrix.fasta is ${tp_1to1_phyx}" >> phyx_reports_about_supermatrix/Missing_percent.txt
  pxlssq -s ${o}/03-Supermatrix/${prefix}_Supermatrix.fasta > phyx_reports_about_supermatrix/Situation_of_${prefix}_supermatrix.txt

###02-AMAS
if [ "${run_AMAS}" != "FALSE" ]; then
  if [ ! -e "./AMAS" ]; then
  mkdir ./AMAS
  fi
  python3 ${script_dir}/../dependencies/AMAS-master/amas/AMAS.py \
  summary -f fasta -d dna -i ${o}/03-Supermatrix/${prefix}_Supermatrix.fasta \
  -o ./AMAS/AMAS_test.txt
fi

#6. Construct phylogenetic trees via three different softwares (IQTREE, RAxML-NG, and RAxMLHPC)
##01-IQTREE ######################################################################
if [ "${run_iqtree}" != "FALSE" ]; then 
##01-1 Set the directory
  if [ ! -e "${o}/05-Tree-files/IQTREE" ]; then
  mkdir -p ${o}/05-Tree-files/IQTREE
  cd ${o}/05-Tree-files/IQTREE
  fi
##01-2 run IQTREE
    #${main_iqtree} \
    #-B ${iqtree_bb} \
    #-nt ${nt_iqtree} \
    #-pre IQTREE-${prefix}_retrieved_sequences
  iqtree -s ${o}/03-Supermatrix/${prefix}_Supermatrix.fasta \
  -m MFP \
  -bb ${iqtree_bb} \
  -nt ${nt_iqtree} \
  -pre IQTREE_${prefix}_retrieved_sequences
  echo "[CMD]:     iqtree -s ${o}/03-Supermatrix/HybPiper-retrieved_sequences/${prefix}_retrieved_sequences.fasta \
           -m MFP \
           -bb ${iqtree_bb} \
           -nt ${nt_iqtree} \
           -pre IQTREE_${prefix}_retrieved_sequences"
  if [ $? -ne 0 ]; then
    echo "[WARNING]:    Error: IQ-TREE command failed."
    exit 1
  fi
fi

##02-RAxML ########################################################################
if [ "${run_raxmlHPC}" != "FALSE" ] && [ "${run_raxmlHPC}" != "False" ]; then
##02-1 Set the directory
  cd ${o}/03-Supermatrix/
  if [ ! -e "${o}/05-Tree-files/RAxML" ]; then
    mkdir ${o}/05-Tree-files/RAxML
  fi
##02-2 Run RAxML
  raxmlHPC="${main_raxmlHPC_mtest} \
           -f a \
           -# ${raxmlHPC_bb} \
           -T ${nt_raxmlHPC} \
           -n ${prefix}_retrieved_sequences.tre \
           -p ${raxmlHPC_p} \
           -w ${o}/05-Tree-files/RAxML"
##02-2.1 If the user enables the Add Restriction tree feature (add the --tree-constraint < constraint tree path > parameter)
  if [ "${raxmlHPC_constraint_tree}" != "_____" ]; then
    echo "[CMD]:     ${raxmlHPC}  \
           -g ${raxmlHPC_constraint_tree}"
    ${raxmlHPC} \
    -g ${raxmlHPC_constraint_tree}

  else
    echo "[CMD]:     ${raxmlHPC}"
    ${raxmlHPC}
  fi
fi
###03-RAxML-NG ###########################################################################
if [ "${run_raxml_ng}" != "FALSE" ] && [ "${run_raxml_ng}" != "False" ]; then
  cd ${o}/03-Supermatrix/
##03-1 Set the directory
  if [ ! -e "${o}/05-Tree-files/RAxML-NG" ]; then
    mkdir ${o}/05-Tree-files/RAxML-NG
  fi
##03-2 Run RAxML-NG
  raxml_ng="${main_raxml_ng_mtest} \
           --all \
           --threads ${nt_raxmlng} \
           --prefix ${o}/05-Tree-files/RAxML-NG/RAxML-NG_${prefix}_retrieved_sequences \
           --bs-trees ${rng_bs_trees}"
##03-2.1 如果用户将rng_force参数设置为TRUE，则启用“忽视线程警告”功能（添加--force perf_threads参数）
  if [ "${rng_force}" = "TRUE" ]; then
    ${raxml_ng} --force perf_threads
	echo "[CMD]:     ${raxml_ng} --force perf_threads"
  else
    ${raxml_ng}
	echo "[CMD]:     ${raxml_ng}"
  fi
##03-2.2 如果用户启用“增加限制树”功能（添加--tree-constraint <限制树路径>参数）
  if [ "${rng_constraint_tree}" != "_____" ]; then
    if [ "${rng_force}" = "TRUE" ]; then
      echo "[CMD]:     ${raxml_ng} \
           --tree-constraint ${rng_constraint_tree} \
           --force perf_threads"
      ${raxml_ng} \
      --tree-constraint ${rng_constraint_tree} \
      --force perf_threads
    else
	  echo "[CMD]:     ${raxml_ng} \
           --tree-constraint ${rng_constraint_tree}"
      ${raxml_ng} \
      --tree-constraint ${rng_constraint_tree}
    fi
  fi
fi
