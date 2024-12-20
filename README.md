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

**Released on 10.20.2024 by [the Sun Lab](https://github.com/SunLab-MiaoPu)**  
**Developed by**: Yuxuan Liu  
**Contributed by**: [Miao Sun](https://github.com/Cactusolo), Xueqin Wang, Liguo Zhang, Tao Xiong, Yiying Wang, Xiaotong Niu, Xinru Zhang, Xiaowen Ma, Mengmeng Wang, Yu Meng  

If you have any questions/issues/suggestions, please leave a message [here](https://github.com/Yuxuanliu-HZAU/HybSuite/issues).  

**Latest version**: 1.1.0

---

## What is HybSuite

HybSuite is a bash wrapper, and designed for **reconstructing phylogenetic trees using NGS (Next-Generation Sequencing) raw data by only one single run**. According to the user's preference, final tree can be **concatenated trees** constructed by [IQ-TREE](https://github.com/iqtree/iqtree2), [RAxML](https://github.com/stamatak/standard-RAxML), or [RAxML-NG](https://github.com/amkozlov/raxml-ng), or can be the **coalescent-based species tree** summarized by [ASTER](https://github.com/chaoszhang/ASTER/tree/master), including [ASTRAL-III](https://github.com/smirarab/ASTRAL) or [wASTRAL](https://github.com/chaoszhang/ASTER/blob/master/tutorial/wastral.md). Please keep in mind that, all results (downloaded data, orthologous groups, alignments, trees) can be produced by one single run!

Hence, HybSuite can incredibly streamline the process of phylogenomics analysis, making it more accessible to researchers from diverse research background.

## Pipeline introduction

* The HybSuite pipeline starts with **NGS(Next-generation sequencing) raw data** (e.g. RNA-seq, Targeted enrichment or WGS (Whole genome sequencing)), which can be downloaded automatically if the user provides the corresponding accession numbers (usually prefixed with SRR- or ERR-).     
* After which, [Trimmomatic-0.39](https://github.com/usadellab/Trimmomatic) will be invoked to remove the adapters and produce clean data. Then, the data assembly and targeted bait capture will be executed via [HybPiper](https://github.com/mossmatters/HybPiper).     
* HybSuite will then run one or more of the following methods to infer orthology groups:     
  (more details about methods can be found [here](https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Methods))
  - **HRS pipeline** (**H**ybPiper **R**etrieved **S**equences)             
  > **Note:** Directly use sequence retrieved by running `hybpiper retrieve_sequences` via [HybPiper](https://github.com/mossmatters/HybPiper) for downstream analysis.
  - **RAPP pipeline** (**R**emove **A**ll **P**utative **P**aralogs)
  > **Note:** This pipeline has two alternative ways:    
  > (1) Remove all loci where more than one putative paralog is detected in any species; this will remove all sequences for that locus across all species.    
  > (2) Remove all sequences from any sample where more than one putative paralog is detected.    
  > Before this step, putative paralogs have been produced by running 'hybpiper paralog_retriever' via [HybPiper](https://github.com/mossmatters/HybPiper)
  - **LS algorithm** (**L**argest **S**ubtree)
  > **Note:** HybSuite implements LS algorithum via [PhyloPyPruner](https://pypi.org/project/phylopypruner/), following the approach of [(Kocot et al 2013)](https://journals.sagepub.com/doi/10.4137/EBO.S12813)
  - **MI algorithm** (**M**aximum **I**nclusion)
  - **MO algorithm** (**M**onophyletic **O**utgroups)
  - **RT algorithm** (**R**ooted **T**ree)
  - **1to1 algorithm** (**1:1** orthologs)
  > **Note:** HybSuite implements MI, MO, RT, 1to1 algorithums alternatively via [ParaGone](https://github.com/chrisjackson-pellicle/ParaGone) or [PhyloPyPruner](https://pypi.org/project/phylopypruner/), following the approach of [(Yang and Smith 2014)](https://bitbucket.org/yangya/workspace/projects/PROJ)
  
     
  
* Nextly, Hybsuite will filter loci and species with a series of criterias, and trim alignments via [TrimAl](https://github.com/inab/trimal) to get final filtered and trimmed alignments, which are used to infer phylogenetic trees.    
* Finally, HybSuite will help the user to construct phylogenetic trees by concatenated method or coalscent-based method according to the user's choices.
* All essential arguments for the software options used in the pipeline can be specified directly when running HybSuite.

![](https://github.com/Yuxuanliu-HZAU/HybSuite/blob/main/images/HybSuite_pipeline.png)

---

# Set up

## How to install HybSuite

HybSite is a shell script, so it is only available for Linux/Unix/WSL users, installing HybSuite is easy, you can directly clone the [github repository](https://github.com/Yuxuanliu-HZAU/HybSuite.git):
```
git clone https://github.com/Yuxuanliu-HZAU/HybSuite.git
```
More details can be found in our wiki page:    
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Installation

## Dependencies
HybSuite is highly relying on dependencies in the conda environment. If you want to run all of the HybSuite pipeline, the following dependencies should be installed in two different conda environments (here temporarily name them as `conda1` and `conda2`, or by your choice).

#### (1) Dependencies for `conda1` environment

* [HybPiper](https://github.com/mossmatters/HybPiper)
* [Phyx](https://github.com/FePhyFoFum/phyx)
* [Newick_Utilities](https://github.com/tjunier/newick_utils)
* [MAFFT](https://github.com/GSLBiotech/mafft)  
* [TrimAl](https://github.com/inab/trimal)
* [ModelTest-NG](https://github.com/ddarriba/modeltest)
* [IQ-TREE](http://trimal.cgenomics.org/)
* [RAxML](https://github.com/stamatak/standard-RAxML)  
* [RAxML-NG](https://github.com/amkozlov/raxml-ng)
* [R](https://www.r-project.org/about.html)≥3.2.0, along with the R packages:
    * [ape](https://cran.r-project.org/web/packages/ape/index.html)
    * [phytools](https://cran.r-project.org/web/packages/phytools/index.html)
* [Python](https://www.python.org/downloads/)≥3.9, along with the Python libraries:
    * [ete3](http://etetoolkit.org/)
    * [PyQt5](https://pypi.org/project/PyQt5/)

#### (2) Dependencies for `conda2` environment
 
* [ParaGone](https://github.com/chrisjackson-pellicle/ParaGone)   
 _In most cases, the discrepancies between ParaGone and other packages are hard to resolve, <br>
 so if you want to do orthology inference by MI/MO/RT/1to1 algorithms (Yang and Smith, 2014), you need to install ParaGone in `conda2` environment._  
 
## How to install the above dependencies?
For full dependencies installation instructions, including details on how to install all dependencies by running `./bin/Install_all_dependencies.sh`, please see our wiki page:    
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Installation

---

# How to run HybSuite
## HybSuite Pipeline Input

### 1.The input folder
Containing necessary input `.txt` files.  
The absolute directory (_path_) of the input folder (`<input directory>`) needs to be specified by the parameter `-i`.

### 2.The textfiles in the input folder

- **Species names list (Including ingroup and outgroup)**:  
    The user will optionally provide at least one of the two types of species name lists in the `<input directory>` specified by `-i`, setting the filenames as follows:
    
  - **Type1: `SRR_Spname.txt`** (optional): The list of SRR number and their corresponding species name.  
      Format: first column is SRR number, second column is the species name (tab-separated).
    
  - **Type2: `My_Spname.txt`** (optional): The name list of species sequenced by yourself and haven't been cleaned before (including ingroups and outgroups).  [names in raw sequence data file?]
      If provided, specify the local directory of the raw data in fastq/fastq.gz format with the option `-my_raw_data`.

- **Outgroup names list**:   
    The outgroup species names in this analysis.  
    **File**: `Outgroup.txt` (Not limited).

### 3.Existed raw reads

### 4.Targeted file

## HybSuite Usage Instruction

Full instructions on running the HybSuite pipeline, including a tutorial using a small test dataset, are available on our wiki:
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Tutorial

## HybSuite Pipeline Output

Full details about results and output directories and files are available on our wiki:    
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Results-and-output-files

# Citation
