# HybSuite: An integrated pipeline for hybrid capture phylogenomics from reads to trees

<img src="https://github.com/Yuxuanliu-HZAU/HybSuite/blob/master/images/HybSuite_logo.png" width="300" height="auto">

**Released on 10.3.2025 by [Sun's Lab](https://github.com/SunLab-MiaoPu)**  
**Developed by:** [Yuxuan Liu](https://github.com/Yuxuanliu-HZAU)  
**Contributors:**: [Miao Sun](https://github.com/Cactusolo), Wycliffe Omondi Omollo, Xueqin Wang, Liguo Zhang, Zijia Lu, Tao Xiong, Yiying Wang, Xiaotong Niu, Xinru Zhang, Xiaowen Ma, Mengmeng Wang, Yu Meng  

If you have any questions/issues/suggestions, please leave a message [here](https://github.com/Yuxuanliu-HZAU/HybSuite/issues).  

**Latest version**: 1.1.5

---

# Introduction

## 🧬 Overview

**HybSuite** is a comprehensive, transparent, and flexible pipeline for Hyb-Seq phylogenomics analysis from NGS raw reads (can be Hyb-Seq, Transcriptome, Whole Genome Sequencing) to phylogenetic trees.       
*The full pipeline is composed of totally 4 stages:*    
- **Stage 1: NGS dataset construction**    
  - (1) Download public raw reads from NCBI (via [SRA Toolkit](https://github.com/ncbi/sra-tools) );
  - (2) Integrate user-provided raw reads;
  - (3) Raw reads trimming (via [Trimmomatic](https://github.com/usadellab/Trimmomatic));  
- **Stage 2: Data assembly & paralog detection**    
  - (1) Target loci assembly and putative paralogs retrieval (via [HybPiper](https://github.com/mossmatters/HybPiper))
  - (2) Integrate pre-assembled sequences (if provided);
  - (3) Filter putative paralogs;
  - (4) Plot original and filtered paralogs heatmap;
- **Stage 3: Paralog handling & alignment processing**    
  - handle paralogs using multiple paralog handling methods:
    seven methods are available: HRS, RLWP, LS, MI, MO, RT, 1to1; 
  - Generate filtered alignments for downstream analysis.
  - Optionally execute seven paralogs-handling methods (HRS, RLWP, LS, MO, MI, RT, 1to1; see our [wiki page](https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Tutorial)):
    - **HRS**:
    (1) retrieve seqeunces via command 'hybpiper retrieve_sequences' in HybPiper;
    (2) integrate pre-assembled sequences (if provided);
    (3) filter sequences by length to remove potential mis-assembled seqeunces;
    (4) mutiple sequences aligning (via [MAFFT]()) and trimming ([trimAl]() or [HMMCleaner]());
    (5) filter trimmed alignments to generate final alignments.
    - **RLWP**: 
    (1) retrieve seqeunces via 'hybpiper retrieve_sequences' via HybPiper;
    (2) integrate pre-assembled sequences (if provided);
    (3) filter sequences by length to remove potential mis-assembled seqeunces;
    (4) remove loci with putative paralogs masked in more than <threshold> samples;
    (5) mutiple sequences aligning and trimming;
    (6) filter trimmed alignments to generate final alignments.
    - **PhyloPypruner pipeline (LS, MI, MO, RT, 1to1)**:
    (1) mutiple sequences aligning and trimming for all putative paralogs;
    (2) gene trees inference of all putative paralogs;
    (3) obtain orthogroup alignments using tree-based orthology inference algorithms via PhyloPypruner;
    (4) realigning and trimming the orthogroup alignments;
    (5) filtering trimmed orthogroup alignments to generate final alignments.
    - **ParaGone pipeline (MI, MO, RT, 1to1)**:
    (1) use the directory cantaining all putative paralogs generated in stage 2 as input;
    (2) obtain orthogroup alignments using tree-based orthology inference algorithms via ParaGone;
    (3) filter trimmed orthogroup alignments to generate final alignments.
  
- **Stage 4: Species tree inference**
  **Purpose:** Reconstruct phylogenetic species trees using multiple approaches:
  - **Species tree inference with multiple methodologies:**    
    **concatenation-based analysis:**    
    - [IQ-TREE](https://github.com/iqtree/iqtree2)
    - [RAxML](https://github.com/stamatak/standard-RAxML)
    - [RAxML-NG](https://github.com/amkozlov/raxml-ng);
    **coalescent analysis:**    
    - [ASTRAL-IV](https://github.com/chaoszhang/ASTER/blob/master/tutorial/astral4.md)
    - [wASTRAL](https://github.com/chaoszhang/ASTER/blob/master/tutorial/wastral.md);
    **coalescent analysis allowing multi-copy genes:**    
    - [ASTRAL-pro3](https://github.com/chaoszhang/ASTER/blob/master/tutorial/astral-pro3.md).

![](https://github.com/Yuxuanliu-HZAU/HybSuite/blob/master/images/HybSuite-workflow.png)

## ✨ Key Features

🔄 **Transparent**: Full workflow visibility with real-time progress logging at each step    
📝 **Reproducible**: Automatically archives exact software commands & parameters for every run      
🧩 **Modular**: Execute individual stages or complete pipeline in one command    
⚡ **Flexible**: 7 paralog handling methods & 5+ species tree inference options    
🚀 **Scalable**: Built-in parallelization for large-scale phylogenomic datasets    

---

# 🚀 Quick Start

## Quick installation
```
conda create -n hybsuite
conda activate hybsuite
conda install yuxuanliu::hybsuite
```

More details of installing HybSuite can be found in:    
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Installation

## Basic Syntax
```
hybsuite <subcommand> [options] ...
```

### Available subcommands for running the pipeline

- `full_pipeline` - Complete end-to-end analysis (Stages 1-4)
- `stage1` - NGS dataset construction and quality control
- `stage2` - Data assembly and paralog detection
- `stage3` - Paralog handling and alignment processing
- `stage4` - Species tree inference and analysis

### Available subcommands for running HybSuite extension tools

- `filter_seqs_by_length` | `fsl` - Filter sequences by length (run filter_seqs_by_length.py).
- `filter_seqs_by_coverage` | `fsc` - Filter sequences by sample and locus coverage (run filter_seqs_by_sample_and_locus_coverage.py).
- `plot_paralog_heatmap` | `pph` -  Plot paralog heatmap (run plot_paralog_heatmap.py).
- `rlwp` - Remove loci with putative paralogs masked in more than <threshold> samples (run RLWP.py).
- `fasta_formatter` | `ff` - Format fasta files (run Fasta_formatter.py).
- `rename_assembled_data` | `rad` - Rename HybPiper assembled data directory (run rename_assembled_data.py).
- `modified_phypartspiecharts` | `mpp` - Visualize gene-species tree conflict (run modified_phypartspiecharts.py).

### Getting the help menu
- **General help**
```
hybsuite -h
```

- **Subcommand help**
```
hybsuite stage1 -h
hybsuite full_pipeline -h
```

- **Version information**
```
hybsuite -v
```

---

# Other instructions
> [!TIP]
> Every aspect of HybSuite can be found on our wiki, just feel free to visit:    
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/

- **Usage tutorial**    
Full instructions on running the HybSuite pipeline, including pipeline input preparation and parameter configuration, are available on our wiki:
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Tutorial

- **Pipeline parameters**   
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Pipeline-parameters

- **Pipeline output**    
Full details about the results, output directories and files are available on our wiki:    
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Results-and-output-files

- **Extension tools usage**
Full instructions on the usage of HybSuite extension tools are available on our wiki:
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Extension-tools

- **Tips for running HybSuite**
Full instructions on the tips for running HybSuite pipeline are available on our wiki:
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Tips-for-running-HybSuite

- **Example dataset running codes**
You can find the codes for running our example dataset:
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Example-dataset

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
