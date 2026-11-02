#!/bin/bash
#SBATCH --job-name=RNA004_FASTQ
#SBATCH --account=c02374
#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --output=/N/slate/puthora/nanopore_midterm/logs/fastq_%j.out
#SBATCH --error=/N/slate/puthora/nanopore_midterm/logs/fastq_%j.err
set -euo pipefail
# Reconstructed equivalent: original BAM-to-FASTQ extraction command not retained.
BASE=/N/slate/puthora/nanopore_midterm
"$BASE/minimap2_env/bin/samtools" fastq \
  "$BASE/basecalling/rna004_sup.bam" \
  > "$BASE/basecalling/rna004_sup.fastq"
ls -lh "$BASE/basecalling/rna004_sup.fastq"
