# Oxford-Nanopore-Direct-RNA-Sequencing
Computational analysis of Oxford Nanopore RNA004 direct RNA sequencing data using Dorado, NanoPlot, minimap2, and Squigualiser.

## Project Overview

This project presents an end-to-end computational workflow for analyzing human Oxford Nanopore direct RNA sequencing (DRS) data generated using RNA004 chemistry. The analysis includes basecalling of raw nanopore electrical signals, sequencing quality assessment, transcriptome alignment, and signal-to-reference visualization.

The analysis was performed on the Indiana University Quartz high-performance computing cluster.

## Tools and Technologies

- **Dorado 0.5.3:** Basecalling with the RNA004 Super Accuracy model (`rna004_130bps_sup@v3.0.1`)
- **NanoPlot 1.48.0:** Sequencing quality assessment
- **minimap2 2.31:** Long-read transcriptome alignment
- **samtools 1.24:** BAM processing and alignment statistics
- **Squigualiser 0.7.0:** Raw electrical signal visualization using basecaller move tables
- **Blue-Crab:** POD5 to BLOW5 conversion
- **Linux, Bash, Slurm, and NVIDIA H100 GPU:** Computational environment

## Key Results

| Metric | Result |
|---|---|
| Total basecalled reads | 10,074 |
| Sequencing yield | 10.75 Mb |
| Mean read length | 1,066.7 nt |
| Read length N50 | 1,482 nt |
| Mean read quality | Q12.2 |
| Reads exceeding Q10 | 92.6% |
| Primary-read mapping rate | 94.01% |
| Squigualiser HTML plots generated | 110 |

## Signal-to-Reference Visualization

Squigualiser Option 2 was used to visualize electrical current signals associated with human mitochondrial transcript **ENST00000387347.2 (MT-RNR2)**, focusing on positions **1360–1400**.

The visualizations show how raw nanopore current signals are associated with basecalled nucleotides and their corresponding reference positions. Exact signal-to-base calibration was not independently validated, so the plots are not interpreted as evidence of specific RNA modifications.

## Reproducibility

The repository includes analysis scripts, software versions, reference information, quality-assessment results, and a representative signal visualization. The full sequencing dataset is not redistributed.

## Data Availability

Original sequencing dataset: https://zenodo.org/records/15853348

Human reference transcriptome: GENCODE release 46

## Research Applications

Long-read direct RNA sequencing can support transcript isoform characterization, alternative splicing analysis, and the investigation of RNA features relevant to precision medicine.

## Acknowledgment

This project was completed as a bioinformatics course assignment using the Indiana University Quartz HPC environment. Generative AI tools assisted with documentation, formatting, and troubleshooting; the reported outputs were generated through the computational workflow.
