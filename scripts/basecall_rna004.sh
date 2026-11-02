#!/bin/bash
#SBATCH --job-name=RNA004_Dorado
#SBATCH --account=c02374
#SBATCH --partition=h100-single
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:h100:1
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --output=/N/slate/puthora/nanopore_midterm/logs/basecall_%j.out
#SBATCH --error=/N/slate/puthora/nanopore_midterm/logs/basecall_%j.err
set -euo pipefail
# Based on the supplied original Dorado batch script.
module load dorado/0.5.3
BASE=/N/slate/puthora/nanopore_midterm
MODEL="$BASE/models/rna004_130bps_sup@v3.0.1"
INPUT="$BASE/data/rna004_hsapiens_r10k.pod5"
OUTPUT="$BASE/basecalling/rna004_sup.bam"
mkdir -p "$BASE/basecalling"
nvidia-smi
dorado basecaller "$MODEL" "$INPUT" \
  --device cuda:0 --emit-moves --min-qscore 0 > "$OUTPUT"
echo "Basecalling completed: $OUTPUT"
ls -lh "$OUTPUT"
