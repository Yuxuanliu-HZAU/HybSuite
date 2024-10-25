# HybSuite
```
      >>>>  Only one run
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
            /_/         NGS raw data ATGCTACTGATCCAACCT......  >>>>  Trees
```

**Released on 10.20.2024 by the Sun Lab**  
**Developed by**: Yuxuan Liu  
**Contributors**: Miao Sun, Xueqin Wang, Liguo Zhang, Tao Xiong, Yiying Wang, Xiaotong Niu, Xinru Zhang, Xiaowen Ma, Mengmeng Wang, Yu Meng
If you have any questions/problems/suggestions, please visit: [GitHub Repository](https://github.com/Yuxuanliu-HZAU/HybSuite.git)  
**Latest version**: 1.1.0

### Purpose

HybSuite was designed for constructing phylogenetic trees from NGS (Next-Generation Sequencing) raw data by only one run. According to the user's aquirement, final trees can be contenated trees constructed by different softwares ([IQ-TREE](https://github.com/iqtree/iqtree2), [RAxML](https://github.com/stamatak/standard-RAxML), or [RAxML-NG](https://github.com/amkozlov/raxml-ng), or can be coalescent-based trees constructed by [wASTRAL](https://github.com/chaoszhang/ASTER/blob/master/tutorial/wastral.md) or ASTRAL- . 

### Pipline introduction

The HybSuite pipeline starts with NGS (Next-Generation Sequencing) raw data (for example: RNA-seq, Targeted enrichment or WGS(Whole genome sequencing)), which can be downloaded automatically if the user provides the corresponding SRR or ERR numbers, or can be provided by the user if it exists. After which, Trimmomatic-0.39 will be used to remove the adapters and produce clean data. Then, the targeted bait capture will be executed via HybPiper. And then HybSuite will alternatively run 5 orthologs inference pipelines or directly retrieve sequences by HybPiper. Later 


## 1.Before running HybSuite, you have to prepare:

### (1) Necessary folders and text files:

- **INPUT FOLDER**: Prepare the input folder containing necessary `.txt` files.  
  The absolute directory of the input folder (`<input directory>`) needs to be specified by the parameter `-i`.

- **TEXTFILES**:

  - **Species names list (Including ingroup and outgroup)**:  
    According to your needs, you must provide at least one of the following two types of species names lists in the `<input directory>` specified by the parameter `-i`.  
    Set the filenames as follows:
    
    - **Type1: `SRR_Spname.txt`** (Optional): The list of SRR numbers and their corresponding species names.  
      Format: first column is SRR number, second column is the species name (tab-separated).
    
    - **Type2: `My_Spname.txt`** (Optional): The name list of new species sequenced by yourself and haven't been cleaned before (including ingroups and outgroups).  
      If provided, specify the directory of your new raw data in the format of fastq/fastq.gz with the option `-my_raw_data`.

  - **Outgroup names list**:   
    Only include outgroup names.  
    **File**: `Outgroup.txt` (No number limitation).

## 2.HybSuite Usage Instructions:

Choose one of the following usage modes:

- **Usage 1**: Run until constructing the NGS database (Stage1).  
  **Command**:  
  ```bash
  bash "/absolute/path/to/HybSuite.sh" --run_to_database [Options] ...
  ```
  
- **Usage 2**: Run until finishing the HybPiper pipeline (Stages 1-2)
  **Command:**
  ```bash
  bash "/absolute/path/to/HybSuite.sh" --run_to_hybpiper [Options] ...
  ```

- **Usage 3**: Run until producing alignments (Stages 1-3)
  **Command**:
  ```bash
  bash "/absolute/path/to/HybSuite.sh" --run_to_alignments [Options] ...
  ```
- **Usage 4**: Run until constructing trees (Stages 1-4)
  **Command:**
  ```bash
  bash "/absolute/path/to/HybSuite.sh" --run_to_trees [Options] ...
  ```

- **Usage 5: Run all stages (Stages 1-5)**
  **Command**:
  ```bash
  bash "/absolute/path/to/HybSuite.sh" --run_all [Options] ...
  ```
  
# General Options
- **-h, --help**  
  Display this help message.
- **-v, --version**  
  Display the version number.
- **-i DIR**  
  Set the `<input directory>` which must encompass one of two name lists. (Absolute Path)
- **-o DIR**  
  Set the `<output directory>` (All results produced by HybSuite will be output to this directory, Absolute Path)  
  *(Default: `<input directory>/05-HybSuite-Results`)*
  *(Default: `<output directory>/HybSuite_results`)*
- **-d DIR**  
  Set the `<database directory>` which is used to store downloaded data and existing data.  
  *(Default: `<output directory>/NGS_database`)*
- **-t DIR**  
  Set the absolute path of your target file for HybPiper.
- **-prefix STRING**  
  The prefix of related output files. *(Default: HybSuite)*
- **-conda1 STRING**  
  The Conda environment for R, Python, IQTREE, RAxML, RAxML-NG, ModelTest-NG, MAFFT, trimAl, phyx, and pigz (for fastq.gz).
- **-conda2 STRING**  
  The Conda environment for HybPiper.
- **-conda3 STRING**  
  The Conda environment for ParaGone.

# Options for Threads Used for Running Individual Softwares
- **-nt NUM**  
  Number of cores/threads used for running Trimmomatic and MAFFT. *(Default: 10)*
- **-nt_fasterq_dump NUM**  
  Number of cores/threads used for running fasterq-dump. *(Default: 10)*
- **-nt_pigz NUM**  
  Number of cores/threads used for running pigz to turn fastq into fastq.gz. *(Default: 10)*
- **-nt_trimmomatic NUM**  
  Number of cores/threads used for running Trimmomatic-0.39. *(Default: 10)*
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

# Options for Downloading NGS Data (Stage 1)
- **-download_format fastq/fastq_gz**  
  The format of your downloaded NGS data.
  - "fastq" for the format of fastq (files end with fastq).
  - "fastq_gz" for the format of fastq.gz (files end with fastq.gz).
- **-rm_sra TRUE/FALSE**  
  Choose whether to remove NGS data in SRA format. *(Default: FALSE)*  
  - "TRUE": Download SRA files and then remove them.  
  - "FALSE": Download SRA files and then keep them.
- **-my_raw_data DIR**  
  The directory of your own NGS raw data (Absolute Path), required file suffixes:
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
  (Prerequisite: It is not your first time to run HybSuite in the same directory specified by `-i`.)
- **-rm_discarded_samples TRUE/FALSE**  
  Choose whether to remove the folders of results generated by `HybPiper assemble` belonging to abandoned species. *(Default: FALSE)*  
  (Prerequisite: It is not your first time to run HybSuite in the same directory specified by `-i`.)

# Options for Running Trimmomatic (Stage 1)
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

# Options for Running HybPiper (Stage 2)
- **-hybpiper_m blast/diamonds**  
- **-hybpiper_tt dna/aa**  
  The type of your target file. *(Default: dna)*
- **-hybpiper_tr dna/aa**  
  The type of your retrieved sequences. *(Default: dna)*
- **-hybpiper_rs gene/supercontig**  
  The type of sequences you want to recover statistics for by using `HybPiper stats`. *(Default: gene)*

# Options for Running ParaGone (Stage 3)
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
