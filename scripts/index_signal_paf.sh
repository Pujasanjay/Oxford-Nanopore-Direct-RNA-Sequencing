#!/bin/bash
#SBATCH --job-name=RNA004_IndexPAF
#SBATCH --account=c02374
#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --output=/N/slate/puthora/nanopore_midterm/logs/paf_index_%j.out
#SBATCH --error=/N/slate/puthora/nanopore_midterm/logs/paf_index_%j.err
set -euo pipefail
# Reconstructed from documented analysis. RNA-oriented PAF had reverse coordinates.
# tabix generated "Coordinate <= 0" warnings in the original analysis.
# Successful region plotting does not establish generic correctness of this indexing method.
BASE=/N/slate/puthora/nanopore_midterm
cd "$BASE"
awk 'BEGIN {OFS="\t"} {low=($8<$9 ? $8 : $9); print $6, low, $0}' \
  signal_data/rna004_reference_signal.paf \
  | sort -k1,1 -k2,2n | cut -f3- \
  > signal_data/rna004_reference_signal.sorted.paf
bgzip -c signal_data/rna004_reference_signal.sorted.paf \
  > signal_data/rna004_reference_signal.sorted.paf.gz
tabix -f -s 6 -b 9 -e 8 signal_data/rna004_reference_signal.sorted.paf.gz
