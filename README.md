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

**HybSuite** is a comprehensive, transparent, and flexible pipeline for Hyb-Seq phylogenomics analysis. It seamlessly processes NGS raw reads through to phylogenetic trees, including data assembly (via [HybPiper](https://github.com/mossmatters/HybPiper)), sequences and alignments filtering, paralog handling (seven methods are available: HRS, RLWP, LS, MI, MO, RT, 1to1; see our [wiki page](https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Tutorial)), and species tree inference with multiple methodologies (concatenation-based analysis: [IQ-TREE](https://github.com/iqtree/iqtree2), [RAxML](https://github.com/stamatak/standard-RAxML), or [RAxML-NG](https://github.com/amkozlov/raxml-ng); coalescent analysis: [ASTRAL-IV](https://github.com/chaoszhang/ASTER/blob/master/tutorial/astral4.md) or [wASTRAL](https://github.com/chaoszhang/ASTER/blob/master/tutorial/wastral.md); coalescent analysis allowing multi-copy genes: [ASTRAL-pro3](https://github.com/chaoszhang/ASTER/blob/master/tutorial/astral-pro3.md).

*The full pipeline has totally 4 stages:*    
- **Stage 1: NGS dataset construction**    
  **Purpose:** Download public data, and read trimming    
- **Stage 2: Data assembly & paralog detection**    
  **Purpose:** Assemble target loci, identify and filtering putative paralogs.    
- **Stage 3: Paralog handling & alignment processing**
  **Purpose:** Process paralogs using multiple orthology inference methods and generating filtered alignments for downstream analysis.
- **Stage 4: Species tree inference**
  **Purpose:** Reconstruct phylogenetic species trees using multiple approaches (concatenated or coalescent analysis).

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
