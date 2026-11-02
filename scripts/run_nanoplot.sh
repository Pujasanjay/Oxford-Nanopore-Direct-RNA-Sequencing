#!/bin/bash
#SBATCH --job-name=RNA004_NanoPlot
#SBATCH --account=c02374
#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --output=/N/slate/puthora/nanopore_midterm/logs/nanoplot_%j.out
#SBATCH --error=/N/slate/puthora/nanopore_midterm/logs/nanoplot_%j.err
set -euo pipefail
# Based on supplied original NanoPlot batch script.
BASE=/N/slate/puthora/nanopore_midterm
source "$BASE/nanoplot_env/bin/activate"
mkdir -p "$BASE/nanoplot"
NanoPlot \
  --ubam "$BASE/basecalling/rna004_sup.bam" \
  --outdir "$BASE/nanoplot" \
  --prefix RNA004_ \
  --threads 4 --plots hex dot
ls -lh "$BASE/nanoplot"
