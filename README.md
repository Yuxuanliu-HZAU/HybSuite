# HybSuite: An integrated pipeline for hybrid capture phylogenomics from reads to trees

<img src="https://github.com/Yuxuanliu-HZAU/HybSuite/blob/master/images/HybSuite_logo.png" width="300" height="auto">

**Released on 10.3.2025 by [Sun's Lab](https://github.com/SunLab-MiaoPu)**  
**Developed by:** [Yuxuan Liu](https://github.com/Yuxuanliu-HZAU)  
**Contributors:**: [Miao Sun](https://github.com/Cactusolo), Zijia Lu, Wycliffe Omondi Omollo, Tao Xiong, Mengmeng Wang, Xueqin Wang, Liguo Zhang, Yiying Wang

If you have any questions/issues/suggestions, please leave a message [here](https://github.com/Yuxuanliu-HZAU/HybSuite/issues).  

**Latest version**: 1.1.5

---

# Introduction

## 🧬 Overview

**HybSuite** performs end-to-end hybrid capture (Hyb-Seq) phylogenomic analysis from raw reads (Hyb-Seq preferred; compatible with RNA-seq, WGS, and genome skimming data) to phylogenetic trees.       
<br>
**The full pipeline is composed of totally 4 stages:**   
- **Stage 1: NGS dataset construction**    
  - (1) Download public raw reads from NCBI (via [SRA Toolkit](https://github.com/ncbi/sra-tools) );
  - (2) Integrate user-provided raw reads (if provided);
  - (3) Raw reads trimming (via [Trimmomatic](https://github.com/usadellab/Trimmomatic));  
- **Stage 2: Data assembly & paralog detection**    
  - (1) Target loci assembly and putative paralogs retrieval (via [HybPiper](https://github.com/mossmatters/HybPiper))
  - (2) Integrate pre-assembled sequences (if provided);
  - (3) Filter putative paralogs;
  - (4) Plot original and filtered paralogs heatmap;
- **Stage 3: Paralog handling & alignment processing**    
  - Optionally execute seven paralogs-handling methods (HRS, RLWP, LS, MO, MI, RT, 1to1; see our [wiki page](https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Tutorial)) and generate filtered alignments for downstream analysis:    
    - **HRS**:    
    (1) Retrieve seqeunces via command `hybpiper retrieve_sequences` in [HybPiper](https://github.com/mossmatters/HybPiper);     
    (2) Integrate pre-assembled sequences (if provided);    
    (3) Filter sequences by length to remove potential mis-assembled seqeunces;    
    (4) Mutiple sequences aligning (via [MAFFT](https://github.com/GSLBiotech/mafft)) and trimming (via [trimAl](https://github.com/inab/trimal) or [HMMCleaner](https://metacpan.org/dist/Bio-MUST-Apps-HmmCleaner/view/bin/HmmCleaner.pl));    
    (5) Filter trimmed alignments to generate final alignments.    
    - **RLWP**:     
    (1) Retrieve seqeunces via 'hybpiper retrieve_sequences' via HybPiper;    
    (2) Integrate pre-assembled sequences (if provided);    
    (3) Filter sequences by length to remove potential mis-assembled seqeunces;   
    (4) Remove loci with putative paralogs masked in more than <threshold> samples;   
    (5) Mutiple sequences aligning (via [MAFFT](https://github.com/GSLBiotech/mafft)) and trimming (via [trimAl](https://github.com/inab/trimal) or [HMMCleaner](https://metacpan.org/dist/Bio-MUST-Apps-HmmCleaner/view/bin/HmmCleaner.pl));    
    (6) Filter trimmed alignments to generate final alignments.    
    - **[PhyloPypruner](https://github.com/fethalen/phylopypruner) pipeline ([LS](https://sourceforge.net/projects/phylotreepruner/), [MI, MO, RT, 1to1](https://bitbucket.org/yangya/phylogenomic_dataset_construction/src/master/))**:    
    (1) Mutiple sequences aligning (via [MAFFT](https://github.com/GSLBiotech/mafft)) and trimming (via [trimAl](https://github.com/inab/trimal) or [HMMCleaner](https://metacpan.org/dist/Bio-MUST-Apps-HmmCleaner/view/bin/HmmCleaner.pl)) for all putative paralogs;    
    (2) Gene trees inference of all putative paralogs;    
    (3) Obtain orthogroup alignments using tree-based orthology inference algorithms (via [PhyloPypruner](https://github.com/fethalen/phylopypruner));    
    (4) Realign (via [MAFFT](https://github.com/GSLBiotech/mafft)) and trim (via [trimAl](https://github.com/inab/trimal) or [HMMCleaner](https://metacpan.org/dist/Bio-MUST-Apps-HmmCleaner/view/bin/HmmCleaner.pl)) the orthogroup alignments;    
    (5) Filter trimmed orthogroup alignments to generate final alignments.    
    - **[ParaGone](https://github.com/chrisjackson-pellicle/ParaGone) pipeline ([MI, MO, RT, 1to1](https://bitbucket.org/yangya/phylogenomic_dataset_construction/src/master/))**:    
    (1) Use the directory cantaining all putative paralogs generated in stage 2 as input;    
    (2) Obtain orthogroup alignments using tree-based orthology inference algorithms via [ParaGone](https://github.com/chrisjackson-pellicle/ParaGone);    
    (3) Filter trimmed orthogroup alignments to generate final alignments.    
  
- **Stage 4: Species tree inference**
  - Multiple species tree inference methods available:        
    - **Concatenation-based approach:** [IQ-TREE](https://github.com/iqtree/iqtree2), [RAxML](https://github.com/stamatak/standard-RAxML), or [RAxML-NG](https://github.com/amkozlov/raxml-ng);    
    - **Coalescent-based approach:** [ASTRAL-IV](https://github.com/chaoszhang/ASTER/blob/master/tutorial/astral4.md) or [wASTRAL](https://github.com/chaoszhang/ASTER/blob/master/tutorial/wastral.md);    
    - **Multi-copy genes aware coalescent-based approach**: [ASTRAL-pro3](https://github.com/chaoszhang/ASTER/blob/master/tutorial/astral-pro3.md).    

## ✨ Key Features

🔄 **Transparent**: Full workflow visibility with real-time progress logging at each step    
📝 **Reproducible**: Automatically archives exact software commands & parameters for every run      
🧩 **Modular**: Execute individual stages or complete pipeline in one command    
⚡ **Flexible**: 7 paralog handling methods & 5+ species tree inference options    
🚀 **Scalable**: Built-in parallelization for large-scale phylogenomic datasets    

![](https://github.com/Yuxuanliu-HZAU/HybSuite/blob/master/images/HybSuite-workflow.png)

---

# Quick Start

## 🚀 Quick installation
```
conda create -n hybsuite
conda activate hybsuite
conda install yuxuanliu::hybsuite
```

More details of installing HybSuite can be found in:    
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Installation

## 📚 Basic syntax
```
hybsuite <subcommand> [options] ...
```

### ⚙️ Available subcommands for running the pipeline

- `full_pipeline` - Complete end-to-end analysis (Stages 1-4)
- `stage1` - Run Stage 1: NGS dataset construction    
- `stage2` - Run stage 2: Data assembly and paralog detection
- `stage3` - Run Stage 3: Paralog handling and alignment processing
- `stage4` - Run Stage 4: Species tree inference

### 🧰 Available subcommands for running HybSuite extension tools

- `filter_seqs_by_length` | `fsl` - Filter sequences by length (run filter_seqs_by_length.py).
- `filter_seqs_by_coverage` | `fsc` - Filter sequences by sample and locus coverage (run filter_seqs_by_sample_and_locus_coverage.py).
- `plot_paralog_heatmap` | `pph` -  Plot paralog heatmap (run plot_paralog_heatmap.py).
- `rlwp` - Remove loci with putative paralogs masked in more than <threshold> samples (run RLWP.py).
- `fasta_formatter` | `ff` - Format fasta files (run Fasta_formatter.py).
- `rename_assembled_data` | `rad` - Rename HybPiper assembled data directory (run rename_assembled_data.py).
- `modified_phypartspiecharts` | `mpp` - Visualize gene-species tree conflict (run modified_phypartspiecharts.py).

## 🆘 Obtaining the help menu

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

- **📖 Usage tutorial**    
Full instructions on running HybSuite pipeline, including input preparation and parameter configuration:  
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Tutorial

- **🎛️ Pipeline parameters**   
Complete parameter documentation:  
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Pipeline-parameters

- **📂 Pipeline output**    
Detailed results structure with output directories/files:  
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Results-and-output-files

- **🧰 Extension tools**  
Comprehensive guide for HybSuite extension tools:  
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Extension-tools

- **💡 Running tips**  
Best practices and optimization suggestions:  
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Tips-for-running-HybSuite

- **🔍 Example dataset**  
Ready-to-run demonstration codes:  
https://github.com/Yuxuanliu-HZAU/HybSuite/wiki/Example-dataset

---

# Changelog

**1.1.5** *September, 2025* - **MAJOR UPDATE !**

- **Pipeline restructuring**    
  - **Stage consolidation**: Combined previous stages 3 and 4, simplifying the pipeline from 5 to 4 stages.
  - **Stagewise execution**: Added flexible stage-by-stage execution capability.

- **Enhanced functionality**    
  **Gene tree inference**:    
  - Added support for [IQ-TREE](https://github.com/iqtree/iqtree2) and [FASTTree](http://www.microbesonline.org/fasttree/).
  - Deprecated RAxML.
  
  **Alignment trimming**:    
  - New alternative: Integrated [HMMCleaner](https://metacpan.org/dist/Bio-MUST-Apps-HmmCleaner/view/bin/HmmCleaner.pl)
  - Maintained trimAl as the default setting.

  **Species tree inference**:    
  - Added [ASTRAL-pro3](https://github.com/chaoszhang/ASTER/blob/master/tutorial/astral-pro3.md) for multi-copy gene aware coalescent analysis.

**1.1.3-1.1.4** *August, 2025*

Fixed some bugs in stages control. These versions have been abondoned.

**1.1.2** *August, 2025*

Integrated [ASTRAL-IV](https://github.com/chaoszhang/ASTER/blob/master/tutorial/astral4.md) into the pipeline stage 4.           

**Usage Update:**    
- Run [ASTRAL-IV](https://github.com/chaoszhang/ASTER/blob/master/tutorial/astral4.md) with parameter: `-tree 4`    

**New dependency:**     
- [ASTER(conda version)](https://github.com/chaoszhang/ASTER)

**1.1.1** *August, 2025*

Fixed some common bugs.

# Citation

Our manuscript is still in preparation, it will be posted here once a preprint of the article is available.
