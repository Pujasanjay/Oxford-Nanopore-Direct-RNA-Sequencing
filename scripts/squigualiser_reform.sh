#!/bin/bash
#SBATCH --job-name=RNA004_Reform
#SBATCH --account=c02374
#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --output=/N/slate/puthora/nanopore_midterm/logs/reform_%j.out
#SBATCH --error=/N/slate/puthora/nanopore_midterm/logs/reform_%j.err
set -euo pipefail
# Reconstructed from recorded successful Squigualiser Option 2 commands.
BASE=/N/slate/puthora/nanopore_midterm
SAMTOOLS="$BASE/minimap2_env/bin/samtools"
SQUIG="$BASE/squigualiser_env/bin/squigualiser"
mkdir -p "$BASE/signal_data"
"$SAMTOOLS" view -h "$BASE/basecalling/rna004_sup.bam" \
  | awk '/^@/ || ($10 != "*" && length($10) >= 9)' \
  | "$SAMTOOLS" view -b -o "$BASE/signal_data/rna004_sup_filtered.bam" -
"$SQUIG" reform \
  -b "$BASE/signal_data/rna004_sup_filtered.bam" \
  -c --rna -k 9 -m 0 \
  -o "$BASE/signal_data/rna004_read_signal_filtered.paf"
# NOTE: -m 0 was used but not independently calibrated for this RNA004 model.
