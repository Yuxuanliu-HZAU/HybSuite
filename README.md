<div align="center">

# HybSuite: An integrated pipeline for hybrid capture phylogenomics from reads to trees

</div>

```
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
            /_/            NGS Raw Data ATGCTACTGATCCAACCT   ......  >>>>  Trees
```

**Released on 10.3.2025 by [Sun's Lab](https://github.com/SunLab-MiaoPu)**  
**Developed by:** [Yuxuan Liu](https://github.com/Yuxuanliu-HZAU)  
**Contributors:**: [Miao Sun](https://github.com/Cactusolo), Wycliffe Omondi Omollolo, Xueqin Wang, Liguo Zhang, Zijia Lu, Tao Xiong, Yiying Wang, Xiaotong Niu, Xinru Zhang, Xiaowen Ma, Mengmeng Wang, Yu Meng  

If you have any questions/issues/suggestions, please leave a message [here](https://github.com/Yuxuanliu-HZAU/HybSuite/issues).  

**Latest version**: 1.1.2

---

## What is HybSuite

HybSuite is a bash wrapper, and designed for **reconstructing phylogenetic trees using NGS (Next-Generation Sequencing) raw data (mainly Hyb-Seq data) in a single run**. Depending on the user's preference, final tree can either be a **concatenated trees** constructed by [IQ-TREE](https://github.com/iqtree/iqtree2), [RAxML](https://github.com/stamatak/standard-RAxML), or [RAxML-NG](https://github.com/amkozlov/raxml-ng), or a **coalescent-based species tree** summarized by [ASTER](https://github.com/chaoszhang/ASTER/tree/master), including [ASTRAL-III](https://github.com/smirarab/ASTRAL) or [wASTRAL](https://github.com/chaoszhang/ASTER/blob/master/tutorial/wastral.md). Please keep in mind that, all results (downloaded data, orthologous groups, alignments, trees) can be produced in a single run!

Hence, HybSuite can significantly streamline the process of Hyb-Seq phylogenomics analysis, making it more accessible to researchers from diverse research backgrounds.    

![](https://github.com/Yuxuanliu-HZAU/HybSuite/blob/master/images/HybSuite-workflow.png)

## Pipeline introduction

* The HybSuite pipeline starts with **NGS(Next-generation sequencing) raw data** (mainly Hyb-Seq, but other types such as RNA-seq and WGS (Whole genome sequencing) are also supported). All public raw data in NCBI can be automatically downloaded if the user provides the corresponding accession numbers (usually prefixed with SRR- or ERR-).     
* After which, [Trimmomatic-0.39](https://github.com/usadellab/Trimmomatic) is invoked to remove the adapters and produce clean data. The data assembly and targeted bait capture are then executed via [HybPiper](https://github.com/mossmatters/HybPiper).     
* HybSuite will then run one or more of the following methods to infer orthology groups:     
  (more details about methods can be found [here](https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Methods))    
  - **HRS pipeline** (**H**ybPiper **R**etrieved **S**equences)             
  > **Note:** Directly use sequence retrieved by running `hybpiper retrieve_sequences` via [HybPiper](https://github.com/mossmatters/HybPiper) for downstream analysis.    
  - **RLWP pipeline** (**R**emove **L**oci **W**ith **P**aralogues)    
  > **Note:** This pipeline removes loci exceeding a user-defined threshold of samples with paralog occurrences.    
  > Putative paralogs are produced by running `hybpiper paralog_retriever` via [HybPiper](https://github.com/mossmatters/HybPiper) before this pipeline.    
  - **LS algorithm** (**L**argest **S**ubtree)    
  > **Note:** HybSuite implements LS algorithum via [PhyloPyPruner](https://pypi.org/project/phylopypruner/), following the approach of [(Kocot et al 2013)](https://journals.sagepub.com/doi/10.4137/EBO.S12813).    
  - **MI algorithm** (**M**aximum **I**nclusion)    
  - **MO algorithm** (**M**onophyletic **O**utgroups)    
  - **RT algorithm** (**R**ooted **T**ree)    
  - **1to1 algorithm** (**1:1** orthologs)    
  > **Note:** HybSuite implements MI, MO, RT, 1to1 algorithums alternatively via [PhyloPyPruner](https://pypi.org/project/phylopypruner/) or [ParaGone](https://github.com/chrisjackson-pellicle/ParaGone), following the approach of [(Yang and Smith 2014)](https://bitbucket.org/yangya/workspace/projects/PROJ) (Default: PhyloPyPruner).   
  
     
  
* Next, Hybsuite filters loci and species based on a series of criterias, and trims alignments via [TrimAl](https://github.com/inab/trimal) to obtain the final filtered and trimmed alignments, which are used to construct phylogenetic trees.    
* Finally, HybSuite will assist the user in constructing phylogenetic trees using either concatenation-based or coalscent-based method according to the user's preferences.
* All essential arguments for the software options used in the pipeline can be specified directly when running HybSuite.

![](https://github.com/Yuxuanliu-HZAU/HybSuite/blob/main/images/HybSuite_pipeline.png)

---

# Installing and running HybSuite

## HybSuite installation
Full instruction of installing HybSuite:    
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Installation

## HybSuite input and usage instruction

Full instructions on running the HybSuite pipeline, including pipeline input preparation and parameter configuration, are available on our wiki:
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Tutorial

## HybSuite pipeline output

Full details about the results, output directories and files are available on our wiki:    
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Results-and-output-files

> [!TIP]
> Every aspect of HybSuite can be found on our wiki, just feel free to visit:    
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/

---

# Changelog

**1.1.2** *August, 2025*

Integrated [ASTRAL-IV](https://github.com/chaoszhang/ASTER/blob/master/tutorial/astral4.md) into the pipeline stage 5.           

**Usage Update:**    
- Run [ASTRAL-IV](https://github.com/chaoszhang/ASTER/blob/master/tutorial/astral4.md) with parameter: `-tree 5`
- Run [wASTRAL](https://github.com/chaoszhang/ASTER/blob/master/tutorial/wastral.md) with parameter: `-tree 6`    

**New dependency:**     
- [ASTER(conda version)](https://github.com/chaoszhang/ASTER)

**1.1.1** *August, 2025*

Fixed some common bugs.

# Citation

Our manuscript is still in preparation, it will be posted here once a preprint of the article is available.
