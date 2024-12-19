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

## What is HybSuite

HybSuite is a bash wrapper, and designed for reconstructing phylogenetic trees using NGS (Next-Generation Sequencing) raw data by only one single run. According to the user's preference, final tree can be concatenated trees constructed by [IQ-TREE](https://github.com/iqtree/iqtree2), [RAxML](https://github.com/stamatak/standard-RAxML), or [RAxML-NG](https://github.com/amkozlov/raxml-ng), or can be the coalescent-based species tree summarized by [ASTER](https://github.com/chaoszhang/ASTER/tree/master), including [ASTRAL-III](https://github.com/smirarab/ASTRAL) or [wASTRAL](https://github.com/chaoszhang/ASTER/blob/master/tutorial/wastral.md). Please keep in mind that, all results (downloaded data, orthologous groups, alignments, trees) can be produced by one single run!

Hence, HybSuite can incredibly streamline the process of phylogenomics analysis, making it more accessible to researchers from diverse research background.

## Pipeline introduction

The HybSuite pipeline starts with NGS raw data (e.g. RNA-seq, Targeted enrichment or WGS (Whole genome sequencing)), which can be downloaded automatically if the user provides the corresponding accession numbers (usually prefixed with SRR- or ERR-). After which, [Trimmomatic-0.39](https://github.com/usadellab/Trimmomatic) will be invoked to remove the adapters and produce clean data. Then, the targeted bait capture will be executed via [HybPiper](https://github.com/mossmatters/HybPiper). And then HybSuite will either alternatively run 5 orthologs inference algorithum (including LS, MI, MO, RT, 1to1) , or RAPP pipeline (remove all putative paralogs from the results produced by HybPiper), or directly retrieve sequences by user's choice. 

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
* [Python](https://www.python.org/downloads/), along with the Python libraries:
    * [ete3](http://etetoolkit.org/)
    * [PyQt5](https://pypi.org/project/PyQt5/)

#### (2) Dependencies for `conda2` environment
 
* [ParaGone](https://github.com/chrisjackson-pellicle/ParaGone).   
 _In most cases, the discrepancies between ParaGone and other packages are hard to resolve, <br>
 so if you want to do orthology inference by MI/MO/RT/1to1 algorithms (Yang and Smith, 2014), you need to install ParaGone in `conda2` environment._  
 
## How to install the above dependencies?
For full dependencies installation instructions, including details on how to install all dependencies by running `./bin/Install_all_dependencies.sh`, please see our wiki page:    
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Installation

# HybSuite Pipeline Input

## 1.Input folders and files:

- **INPUT FOLDER**: Containing necessary input `.txt` files.  
  The absolute directory (_path_) of the input folder (`<input directory>`) needs to be specified by the parameter `-i`.

- **TEXTFILES**:

- **Species names list (Including ingroup and outgroup)**:  
    The user will optionally provide at least one of the two types of species name lists in the `<input directory>` specified by `-i`, setting the filenames as follows:
    
  - **Type1: `SRR_Spname.txt`** (optional): The list of SRR number and their corresponding species name.  
      Format: first column is SRR number, second column is the species name (tab-separated).
    
  - **Type2: `My_Spname.txt`** (optional): The name list of species sequenced by yourself and haven't been cleaned before (including ingroups and outgroups).  [names in raw sequence data file?]
      If provided, specify the local directory of the raw data in fastq/fastq.gz format with the option `-my_raw_data`.[not clear]

- **Outgroup names list**:   
    The outgroup species names in this analysis.  
    **File**: `Outgroup.txt` (Not limited).

# HybSuite Usage Instruction

Full instructions on running the HybSuite pipeline, including a tutorial using a small test dataset, are available on our wiki:
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Tutorial

Because the ASTER module in HybSuite currently has no GUI, users need to run it through the command-line. Starting at the HybSuite directory in a terminal/PowerShell, and then run HybSuite under either of **five** modes outlined below:

- **Usage[Mode] 1**: Run until constructing the NGS database (Stage1).   
  ```bash
  bash ./bin/HybSuite.sh --run_to_database [Options] ...
  ```
  
- **Usage 2**: Run until finishing the HybPiper pipeline (Stages 1-2)
  ```bash
  bash ./bin/HybSuite.sh --run_to_hybpiper [Options] ...
  ```

- **Usage 3**: Run until producing alignments (Stages 1-3)
  **Command**:
  ```bash
  bash ./bin/HybSuite.sh --run_to_alignments [Options] ...
  ```
- **Usage 4**: Run until constructing trees (Stages 1-4)
  ```bash
  bash ./bin/HybSuite.sh --run_to_trees [Options] ...
  ```

- **Usage 5: Run all stages (Stages 1-5)**
  ```bash
  bash ./bin/HybSuite.sh --run_all [Options] ...
  ```

# HybSuite Pipeline Output



# General Options
- **-h, --help**  
  Display this help message.
- **-v, --version**  
  Display the version number.
- **-i DIR**  
  Set the `<input directory>` which must encompass one of two species name lists. (Absolute Path)
- **-o DIR**  
  Set the `<output directory>` (All results produced by HybSuite will be output to this directory, Absolute Path)  
  *(Default: `<input directory>/05-HybSuite-Results`)*
  *(Default: `<output directory>/HybSuite_results`)*
- **-d DIR**  
  Set the `<database directory>` which is used to store raw data downloaded and prepared by the user.  
  *(Default: `<output directory>/NGS_database`)*
- **-t DIR**  
  Set the absolute path of the user's target file for HybPiper assemblage.
- **-prefix STRING**  
  The prefix of related output files. *(Default: HybSuite)*
- **-conda1 STRING**  
  The conda environment for R, Python, IQTREE, RAxML, RAxML-NG, ModelTest-NG, MAFFT, trimAl, phyx, and pigz (for fastq.gz).
- **-conda2 STRING**  
  The conda environment for HybPiper.
- **-conda3 STRING**  
  The conda environment for ParaGone.

# Setting for Threads
- **-nt NUM**  
  Number of cores/threads used for running Trimmomatic and MAFFT. *(Default: 10)*
- **-nt_fasterq_dump NUM**  
  Number of cores/threads used for running fasterq-dump. *(Default: 10)*
- **-nt_pigz NUM**  
  Number of cores/threads used for running pigz to turn fastq into fastq.gz. *(Default: 10)*
- **-nt_trimmomatic NUM**  
  Number of cores/threads used for running Trimmomatic. *(Default: 10)*
- **-nt_hybpiper NUM**  
  Number of cores/threads used for running HybPiper. *(Default: 10)*
- **-nt_paragone NUM**  
  Number of cores/threads used for running ParaGone. *(Default: 10)*
- **-nt_mafft NUM**  
  Number of cores/threads used for running MAFFT. *(Default: 10)*
- **-nt_modeltest_ng NUM**  
  Number of cores/threads used for running ModelTest-NG. *(Default: 10)*
- **-nt_iqtree NUM**  
  Number of cores/threads used for running IQ-TREE. *(Default: 10)*
- **-nt_raxmlng NUM**  
  Number of cores/threads used for running RAxML-NG. *(Default: 10)*

# Settings for Downloading NGS Data (Stage 1) [there is already "Stage 1" above]
- **-download_format fastq/fastq_gz**  
  The format of NGS data downloaded by the user.
  - "fastq" files end with fastq.
  - "fastq_gz" files end with fastq.gz.
- **-rm_sra TRUE/FALSE**  
  Choose whether to remove NGS data in SRA format. *(Default: FALSE)*  
  - "TRUE": Download SRA files and then remove them.  [what is the point?]
  - "FALSE": Download SRA files and then keep them.
- **-my_raw_data DIR**  
  The directory of the user's NGS raw data (Absolute Path), and file suffix is required:
  - Two-pair-end:  
    `*_1.fastq` & `*_2.fastq`  
    `*_1.fq` & `*_2.fq`  
    `*_1.fastq.gz` & `*_2.fastq.gz`  
    `*_1.fq.gz` & `*_2.fq.gz`
  - Single-end:  
    `*.fq`  
    `*.fastq`  
    `*.fq.gz`  
    `*.fastq.gz`
- **-run_HybPiperstats_again TRUE/FALSE**  
  Choose whether to run `HybPiper stats` again. *(Default: FALSE)*  
  (Prerequisite: It is not your first time to run HybSuite in the same directory specified by `-i`.) # not clear
- **-rm_discarded_samples TRUE/FALSE**  
  Choose whether to remove the folders of results generated by `HybPiper assemble` belonging to abandoned species. *(Default: FALSE)*  
  (Prerequisite: It is not your first time to run HybSuite in the same directory specified by `-i`.)# refine

# Settings for Trimmomatic (Stage 1)
- **-trimmomatic_leading_quality NUM**  
  Cut bases off the start of a read, if below this threshold quality. *(Default: 3)*
- **-trimmomatic_trailing_quality NUM**  
  Cut bases off the end of a read, if below this threshold quality. *(Default: 3)*
- **-trimmomatic_min_length NUM**  
  Drop a read if it is below this specified length. *(Default: 36)*
- **-trimmomatic_sliding_window_s NUM**  
  Size of the sliding window used by Trimmomatic; specifies the number of bases to average across. *(Default: 4)*
- **-trimmomatic_sliding_window_q NUM**  
  The average quality required within the sliding window. *(Default: 20)*

# Settings for HybPiper (Stage 2)
- **-hybpiper_m blast/diamonds**  
- **-hybpiper_tt dna/aa**  
  The type of the target file. *(Default: dna)*
- **-hybpiper_tr dna/aa**  
  The type of the retrieved sequences. *(Default: dna)*
- **-hybpiper_rs gene/supercontig**  
  The type of sequences you want to recover statistics for by using `HybPiper stats`. *(Default: gene)*

# Settings for ParaGone (Stage 3)
- **-paragone_pool NUM**  
  Number of alignments to run concurrently. *(Default: 1)*
- **-paragone_tree iqtree/fasttree**  
  Use FastTree or IQ-TREE to construct gene trees from alignments. *(Default: fasttree)*
- **-paragone_treeshrink_q_value**  
  q value for TreeShrink; the quantile(s) to set threshold. *(Default: 0.05)*
- **-paragone_cutoff_value**  
  Internal branch length cutoff for cutting tree. *(Default: 0.3)*

# Options for Running MAFFT (Stage 3)
- **-mafft STRING**  
  Choose the parameter for running MAFFT. *(Default: _____)*  
  - "Default": run `mafft-linsi --adjustdirectionaccurately ...`
  - "auto": run `mafft --auto ...`
- **-run_mafft_again TRUE/FALSE**  
  Choose whether to run MAFFT again. *(Default: FALSE)*
- **-replace_n TRUE/FALSE**  
  Choose whether to replace the character `n` with `-` in your alignments. *(Default: FALSE)*

# Options for Running AMAS (Stage 4)
- **-run_AMAS TRUE/FALSE**  
  Choose whether to run IQTREE to construct phylogenetic trees. *(Default: TRUE)*

# Options for Running IQ-TREE (Stage 4)
- **-run_iqtree TRUE/FALSE**  
  Choose whether to run IQTREE to construct phylogenetic trees. *(Default: TRUE)*  
- **-iqtree_bb NUM**  
  Number of bootstrap replicates for running IQTREE. *(Default: 1000)*

# Options for Running RAxML-NG (Stage 4)
- **-run_raxml_ng TRUE/FALSE**  
  Choose whether to run RAxML-NG to construct phylogenetic trees. *(Default: TRUE)*  
- **-rng_bs_trees NUM**  
  Number of bootstrap replicates for running RAxML-NG. *(Default: 1000)*  
- **-rng_force TRUE/FALSE**  
  Choose whether to ignore thread warnings when running RAxML-NG. *(Default: FALSE)*
- **-rng_constraint_tree DIR**  
  The directory of your constraint tree for running RAxML-NG.

# Options for Running ASTRAL-III (Stage 4)
- **-run_Astral TRUE/FALSE**  
  Choose whether to run ASTRAL-III and Phyparts.
- **-run_Astral_gt_again TRUE/FALSE**  
  Choose whether to skip the step of using `raxmlHPC` to construct single-gene trees before running ASTRAL-III.
- **-run_Astral_gtr_again TRUE/FALSE**  
  Choose whether to use phyx or mad to reroot single-gene trees.
- **-Astral_nt NUM**  
  Number of cores/threads used for running IQTREE. *(Default: 10)*
