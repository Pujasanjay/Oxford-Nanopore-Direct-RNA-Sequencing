#!/bin/bash
#SBATCH --job-name=RNA004_Reference
#SBATCH --account=c02374
#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --output=/N/slate/puthora/nanopore_midterm/logs/reference_%j.out
#SBATCH --error=/N/slate/puthora/nanopore_midterm/logs/reference_%j.err
set -euo pipefail
# Corrected plain URL and added documented header simplification.
BASE=/N/slate/puthora/nanopore_midterm
mkdir -p "$BASE/reference"
cd "$BASE/reference"
wget -c 'https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_46/gencode.v46.transcripts.fa.gz' \
  -O gencode.v46.transcripts.fa.gz
if [[ ! -s gencode.v46.transcripts.fa ]]; then
  gunzip -k gencode.v46.transcripts.fa.gz
fi
# Reproduced equivalent; exact original header-editing command not preserved.
awk '/^>/ {sub(/\|.*/, "", $0)} {print}' \
  gencode.v46.transcripts.fa > gencode.v46.transcripts.simple.fa
ls -lh gencode.v46.transcripts.simple.fa
