#!/bin/bash
#SBATCH --job-name=DownloadPOD5
#SBATCH --account=c02374
#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --time=00:30:00
#SBATCH --output=/N/slate/puthora/nanopore_midterm/logs/download_%j.out
#SBATCH --error=/N/slate/puthora/nanopore_midterm/logs/download_%j.err
set -euo pipefail
# Corrected plain URL; reconstructed from supplied original script.
BASE=/N/slate/puthora/nanopore_midterm
mkdir -p "$BASE/data"
wget -c 'https://zenodo.org/records/15853348/files/rna004_hsapiens_r10k.pod5?download=1' \
  -O "$BASE/data/rna004_hsapiens_r10k.pod5"
ls -lh "$BASE/data/rna004_hsapiens_r10k.pod5"
md5sum "$BASE/data/rna004_hsapiens_r10k.pod5"
