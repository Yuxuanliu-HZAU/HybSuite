# HybSuite
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

**Released on 3.10.2025 by [the Sun Lab](https://github.com/SunLab-MiaoPu)**  
**Developed by**: [Yuxuan Liu](https://github.com/Yuxuanliu-HZAU)  
**Contributed by**: [Miao Sun](https://github.com/Cactusolo), Xueqin Wang, Liguo Zhang, Tao Xiong, Yiying Wang, Xiaotong Niu, Xinru Zhang, Xiaowen Ma, Mengmeng Wang, Yu Meng  

If you have any questions/issues/suggestions, please leave a message [here](https://github.com/Yuxuanliu-HZAU/HybSuite/issues).  

**Latest version**: 1.1.0

---

## What is HybSuite

HybSuite is a bash wrapper, and designed for **reconstructing phylogenetic trees using NGS (Next-Generation Sequencing) raw data (mainly Hyb-Seq data) by only one single run**. According to the user's preference, final tree can be **concatenated trees** constructed by [IQ-TREE](https://github.com/iqtree/iqtree2), [RAxML](https://github.com/stamatak/standard-RAxML), or [RAxML-NG](https://github.com/amkozlov/raxml-ng), or can be the **coalescent-based species tree** summarized by [ASTER](https://github.com/chaoszhang/ASTER/tree/master), including [ASTRAL-III](https://github.com/smirarab/ASTRAL) or [wASTRAL](https://github.com/chaoszhang/ASTER/blob/master/tutorial/wastral.md). Please keep in mind that, all results (downloaded data, orthologous groups, alignments, trees) can be produced by one single run!

Hence, HybSuite can incredibly streamline the process of Hyb-Seq phylogenomics analysis, making it more accessible to researchers from diverse research backgrounds.    

## Pipeline introduction

* The HybSuite pipeline starts with **NGS(Next-generation sequencing) raw data** (mainly Hyb-Seq, other types are also allowed, e.g. RNA-seq, WGS (Whole genome sequencing)). All public raw data in NCBI can be downloaded automatically if the user provides the corresponding accession numbers (usually prefixed with SRR- or ERR-).     
* After which, [Trimmomatic-0.39](https://github.com/usadellab/Trimmomatic) will be invoked to remove the adapters and produce clean data. Then, the data assembly and targeted bait capture will be executed via [HybPiper](https://github.com/mossmatters/HybPiper).     
* HybSuite will then run one or more of the following methods to infer orthology groups:     
  (more details about methods can be found [here](https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Methods))    
  - **HRS pipeline** (**H**ybPiper **R**etrieved **S**equences)             
  > **Note:** Directly use sequence retrieved by running `hybpiper retrieve_sequences` via [HybPiper](https://github.com/mossmatters/HybPiper) for downstream analysis.    
  - **RLWP pipeline** (**R**emove **L**oci **W**ith **P**aralogues)    
  > **Note:** This pipeline rempves Loci exceeding a user-defined threshold of samples with paralog occurrences.    
  > Before this step, putative paralogs have been produced by running 'hybpiper paralog_retriever' via [HybPiper](https://github.com/mossmatters/HybPiper).    
  - **LS algorithm** (**L**argest **S**ubtree)    
  > **Note:** HybSuite implements LS algorithum via [PhyloPyPruner](https://pypi.org/project/phylopypruner/), following the approach of [(Kocot et al 2013)](https://journals.sagepub.com/doi/10.4137/EBO.S12813).    
  - **MI algorithm** (**M**aximum **I**nclusion)    
  - **MO algorithm** (**M**onophyletic **O**utgroups)    
  - **RT algorithm** (**R**ooted **T**ree)    
  - **1to1 algorithm** (**1:1** orthologs)    
  > **Note:** HybSuite implements MI, MO, RT, 1to1 algorithums alternatively via [PhyloPyPruner](https://pypi.org/project/phylopypruner/) or [ParaGone](https://github.com/chrisjackson-pellicle/ParaGone), following the approach of [(Yang and Smith 2014)](https://bitbucket.org/yangya/workspace/projects/PROJ) (Default: PhyloPyPruner).   
  
     
  
* Nextly, Hybsuite will filter loci and species with a series of criterias, and trim alignments via [TrimAl](https://github.com/inab/trimal) to get final filtered and trimmed alignments, which are used to construct phylogenetic trees.    
* Finally, HybSuite will help the user to construct phylogenetic trees by concatenated method or coalscent-based method according to the user's choices.
* All essential arguments for the software options used in the pipeline can be specified directly when running HybSuite.

![](https://github.com/Yuxuanliu-HZAU/HybSuite/blob/main/images/HybSuite_pipeline.png)

---

# Set up

## How to install HybSuite

HybSite is a shell script, combined with some python and R scripts. So it is only available for Linux/Unix/WSL users, installing HybSuite is easy, you can directly clone the [github repository](https://github.com/Yuxuanliu-HZAU/HybSuite.git):
```
git clone https://github.com/Yuxuanliu-HZAU/HybSuite.git
```
More details can be found in our wiki page:    
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Installation

---

# How to run HybSuite

## HybSuite Input and Usage Instruction

Full instructions on running the HybSuite pipeline, including pipeline input preparation and parameters configuration, are available on our wiki:
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Tutorial

## HybSuite Pipeline Output

Full details about results and output directories and files are available on our wiki:    
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Results-and-output-files

# Citation
