#!/bin/bash
#SBATCH --job-name=RNA004_Plot
#SBATCH --account=c02374
#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --output=/N/slate/puthora/nanopore_midterm/logs/plot_%j.out
#SBATCH --error=/N/slate/puthora/nanopore_midterm/logs/plot_%j.err
set -euo pipefail
# Reconstructed from successful final plot command; NO --plot_limit used.
BASE=/N/slate/puthora/nanopore_midterm
mkdir -p "$BASE/signal_plots/all_target_reads"
"$BASE/squigualiser_env/bin/squigualiser" plot \
  -f "$BASE/reference/gencode.v46.transcripts.simple.fa" \
  -s "$BASE/signal_data/rna004_hsapiens_r10k.blow5" \
  -a "$BASE/signal_data/rna004_reference_signal.sorted.paf.gz" \
  --region ENST00000387347.2:1360-1400 \
  --rna --sig_ref \
  --profile kmer_model_rna004_130bps_9mer \
  --loose_bound --auto \
  -o "$BASE/signal_plots/all_target_reads"
find "$BASE/signal_plots/all_target_reads" -maxdepth 1 -type f -name '*.html' | wc -l
# Previous run produced 110 HTML files; this count depends on input files and versions.
