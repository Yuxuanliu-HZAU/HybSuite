#!/usr/bin/bash
#本bash文件需要输入的文件名如下：
#$1：Astral总文件夹路径
#$2：存放各个基因序列的文件路径：/data/yuxuan/Projects/Spiraea/Hyb-Seq/04-HybPiper_results/retrieve_data/After_mafft/After_trimal
#$3：对Astral中基因所覆盖的物种数的最低要求
#$4：使用raxmlHPC建立单基因树时，所用到的线程数
#$5：去旁系同源类型：HybPiper_main
#$6：类群名字：Spiraea
#$7：外类群名字1
#$8：外类群名字2
#$9：外类群名字3
#$10:外类群名字4
#$11:外类群名字5
#$12:run_Astral_gt_again
#$13:run_Astral_gtr_again

#01:set the directionary
cd $1
if [ ! -e "./01-gene_tre" ]; then
mkdir ./01-gene_tre
fi
if [ ! -e "./02-gene_tre_reroot" ]; then
mkdir ./02-gene_tre_reroot
fi
if [ ! -e "./03-gene_combine_tree" ]; then
mkdir ./03-gene_combine_tree
fi
if [ ! -e "./04-Astral_final_results" ]; then
mkdir ./04-Astral_final_results
fi
if [ ! -e "./05-phypartspiechart" ]; then
mkdir ./05-phypartspiechart
fi
# 02:Construct the single-gene trees via raxmlHPC (**gene_tree.sh**)
> ./gene_list.txt
cd $2
for Gene in *.F*A; do
# 计算每个文件中包含">"的行数  
  count=$(grep -c '>' "${Gene}")  
#选择物种覆盖数大于等于最低要求的基因名，输入到gene_list.txt 
  if [ "$count" -ge "$3" ]; then   
    echo "$Gene" >> $1/gene_list.txt
  fi
done

# 切换回Astral总路径并替换掉gene_list.txt中的基因名之后的后缀：FNA/FAA
cd $1
sed -i 's/\.FNA//g;s/\.FAA//g' gene_list.txt

#03：Construct the gene trees via RAxMLHPC
while IFS= read -r Genename || [[ -n $Genename ]]; do
	if [ ! -e "./01-gene_tre/$Genename" ]; then
  mkdir ./01-gene_tre/$Genename
  fi
  if [ -s "$1/01-gene_tre/${Genename}/RAxML_bestTree.${Genename}.ML" ] && [ "${12}" = "FALSE" ]; then
  	echo -e "  Because $1/01-gene_tre/${Genename}.FNA already exists, SAH will skip the step of using raxmlHPC to construct single-gene trees."
  else
    if [ -e "$1/01-gene_tre/${Genename}/RAxML_bestTree.${Genename}.ML" ]; then
    >$1/01-gene_tre/${Genename}/RAxML_info.${Genename}.ML
    fi
    raxmlHPC -f a \
  	-T $4 \
  	-s $2/${Genename}.F*A \
  	-k -x "$RANDOM" \
  	-m GTRGAMMA \
  	-p "$RANDOM" \
  	-n "${Genename}.ML" \
  	-w $1/01-gene_tre/${Genename} \
  	-N 100
  fi
done < ./gene_list.txt
echo -e "\n Step I: Concatenate all gene trees ...\n"

#04：使用基于mad包的R脚本对所有已建好的树进行置根
# 获取脚本所在路径
SAH_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "${13}"
while IFS= read -r Genename || [[ -n $Genename ]]; do
	if [ -s "$1/02-gene_tre_reroot/${Genename}.rt.tre" ] && [ "${13}" = "FALSE" ]; then
    echo -e "  Because $1/02-gene_tre_reroot/${Genename}.rt.tre already exists, SAH will skip the step of using phyx or mad to construct single-gene trees."
  else
    Rscript ${SAH_script_dir}/SAH-Astral/Reroot_genetree_phyx_mad.R ${Genename} $1 $7 $8 $9 ${10} ${11}
  fi
done < ./gene_list.txt 

#Chapter04：合并所有树文件并使用Astral
cat ./02-gene_tre_reroot/*.rt.tre >>./03-gene_combine_tree/$6_$5_genetrees.tre
cd ./03-gene_combine_tree
echo -e "\n Step II: Collaps all the nodes that BS support <10% within all gene trees ...\n"

nw_ed $6_$5_genetrees.tre 'i & b<=0.1' o > $6_$5.tre

# the main input is just a file that contains all the input gene trees in Newick format. The input gene trees are treated as unrooted, whether or not they have a root. 
# Note that the output of ASTRAL should also be treated as an unrooted tree.

echo -e	"\n Step III: running astral for species tree ...\n"
cd ../04-Astral_final_results/
#/data/yuxuan/software/ASTRAL-master/ASTRAL-master/Astral/astral.5.7.8.jar
java -jar ${SAH_script_dir}/SAH-Astral/ASTRAL-master/Astral/astral.5.7.8.jar \
-i ../03-gene_combine_tree/$6_$5.tre \
-o ./$6_$5_Astral.tre 2> $6_$5_Astral.log

echo -e "\n****************\nDone!!!\n****************\n"
SAH_dir=$(echo "$1" | sed 's\/09-Astral/01-HybPiper-main\\g')
if [ -s "$1/04-Astral_final_results/RAxML_info.$6_$5_Astral_bl.tre" ]; then
>$1/04-Astral_final_results/RAxML_info.$6_$5_Astral_bl.tre
fi
raxmlHPC -f e -t ./$6_$5_Astral.tre -m GTRGAMMA \
-s ${SAH_dir}/06-Supermatrix/01-HybPiper-main/$6_$5.fasta \
-T $4 \
-n $6_$5_Astral_bl.tre \
-w $1/04-Astral_final_results \
-N 100
# reroot and ladderize
nw_reroot ./RAxML_result.$6_$5_Astral_bl.tre |nw_order -c n - >Final_Astral_$6_$5.tre

#phypartsPiechart
cd $1/05-phypartspiechart
java -jar ${SAH_script_dir}/SAH-phyparts/target/phyparts-0.0.1-SNAPSHOT-jar-with-dependencies.jar \
-a 1 -v -d $1/02-gene_tre_reroot \
-m $1/04-Astral_final_results/Final_Astral_$6_$5.tre \
-o ./phyparts &> /dev/null
#-d 基因树所在的文件夹
#-m Astral生成的物种树
#-o prepend output files with this

phyparts_number=$(find $1/02-gene_tre_reroot -type f -name "*.rt.tre" | wc -l)
python3 ${SAH_script_dir}/SAH-phyparts/phypartspiechart.py \
$1/04-Astral_final_results/Final_Astral_$6_$5.tre \
phyparts ${phyparts_number} \
--svg_name PhypartsPiecharts.svg \
--to_csv
