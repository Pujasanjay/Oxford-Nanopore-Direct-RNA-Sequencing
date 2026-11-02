#!/bin/bash
#SBATCH --job-name=RNA004_Realign
#SBATCH --account=c02374
#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --output=/N/slate/puthora/nanopore_midterm/logs/realign_%j.out
#SBATCH --error=/N/slate/puthora/nanopore_midterm/logs/realign_%j.err
set -euo pipefail
# Reconstructed from the documented successful realign command.
BASE=/N/slate/puthora/nanopore_midterm
"$BASE/squigualiser_env/bin/squigualiser" realign \
  -p "$BASE/signal_data/rna004_read_signal_filtered.paf" \
  -b "$BASE/alignment/rna004_transcriptome.sorted.bam" \
  -c --rna --skip \
  -o "$BASE/signal_data/rna004_reference_signal.paf"
