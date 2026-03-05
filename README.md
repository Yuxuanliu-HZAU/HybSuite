# HybSuite: An integrated pipeline for hybrid capture phylogenomics from reads to trees

[![install with conda](https://img.shields.io/badge/install%20with-conda-brightgreen.svg?style=flat)](https://anaconda.org/channels/YuxuanLiu/packages/hybsuite/overview)

<img src="https://github.com/Yuxuanliu-HZAU/HybSuite/blob/master/images/HybSuite_logo.png" width="300" height="auto">

**Released on 10.3.2025 by [Sun's Lab](https://github.com/SunLab-MiaoPu)**  
**Developed by:** [Yuxuan Liu](https://github.com/Yuxuanliu-HZAU)  
**Contributors:**: [Miao Sun](https://github.com/Cactusolo), Zijia Lu, Wycliffe Omondi Omollo, Tao Xiong, Mengmeng Wang, Xueqin Wang, Liguo Zhang, Yiying Wang
**Manual:** [https://yuxuanliu-hzau.github.io/HybSuite.docs/](https://yuxuanliu-hzau.github.io/HybSuite.docs/)

If you have any questions/issues/suggestions, please leave a message [here](https://github.com/Yuxuanliu-HZAU/HybSuite/issues).  

**Latest version**: 1.1.7

---

## ⚠️ Attention

Our wiki page has not been updated since March 1, 2026.  
The existing tutorial remains available but only applies to **HybSuite v1.1.6** or earlier version.

Alternatively, We have created a dedicated documentation site for HybSuite.  
Please visit the new manual here, where you can find everything for using HybSuite:

👉 https://yuxuanliu-hzau.github.io/HybSuite.docs/

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
- `plot_recovery_heatmap` | `prh` -  Plot recovery heatmap (run plot_recovery_heatmap_v2.py).
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
hybsuite filter_seqs_by_length -h
```

- **Version information**
```
hybsuite -v
```

---

# Citation

Our manuscript has been accepted by Applications in Plant Sciences and will be online soon:

Liu, Y.-X.*, Lu, Z.-J., Omollo, W. O., Wang, M.-M., Zhang, L.-G., Xiong, T., Wang, X.-Q., Wang, Y.-Y., & Sun, M. (corresponding author). HybSuite: An integrated pipeline for hybrid capture phylogenomics from reads to trees. *Applications in Plant Sciences*. (Accepted)
