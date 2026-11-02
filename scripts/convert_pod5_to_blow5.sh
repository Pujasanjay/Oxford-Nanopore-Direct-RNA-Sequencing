#!/bin/bash
#SBATCH --job-name=RNA004_BLOW5
#SBATCH --account=c02374
#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --output=/N/slate/puthora/nanopore_midterm/logs/blow5_%j.out
#SBATCH --error=/N/slate/puthora/nanopore_midterm/logs/blow5_%j.err
set -euo pipefail
# REVISED reproduction command from the successful analysis.
# The original saved script called blue-crab directly and had an environment incompatibility.
BASE=/N/slate/puthora/nanopore_midterm
INPUT="$BASE/data/rna004_hsapiens_r10k.pod5"
OUTPUT="$BASE/signal_data/rna004_hsapiens_r10k.blow5"
PYTHON="$BASE/bluecrab_test_env/bin/python"
BLUECRAB="$BASE/bluecrab_env/bin/blue-crab"
mkdir -p "$BASE/signal_data"
"$PYTHON" "$BLUECRAB" p2s "$INPUT" -o "$OUTPUT" -t 4
ls -lh "$OUTPUT"
