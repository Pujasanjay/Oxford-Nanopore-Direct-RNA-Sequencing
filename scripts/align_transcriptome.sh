#!/bin/bash
#SBATCH --job-name=RNA004_Align
#SBATCH --account=c02374
#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=24G
#SBATCH --time=02:00:00
#SBATCH --output=/N/slate/puthora/nanopore_midterm/logs/align_%j.out
#SBATCH --error=/N/slate/puthora/nanopore_midterm/logs/align_%j.err
set -euo pipefail
# Based on the supplied original alignment batch script.
BASE=/N/slate/puthora/nanopore_midterm
MINIMAP2="$BASE/minimap2_env/bin/minimap2"
SAMTOOLS="$BASE/minimap2_env/bin/samtools"
REF="$BASE/reference/gencode.v46.transcripts.simple.fa"
READS="$BASE/basecalling/rna004_sup.fastq"
OUT="$BASE/alignment/rna004_transcriptome.sorted.bam"
mkdir -p "$BASE/alignment" "$BASE/logs"
"$MINIMAP2" -ax map-ont -t 8 "$REF" "$READS" \
  2> "$BASE/logs/minimap2_alignment.log" \
  | "$SAMTOOLS" sort -@ 4 -o "$OUT" -
"$SAMTOOLS" index "$OUT"
"$SAMTOOLS" flagstat "$OUT" > "$BASE/alignment/alignment_flagstat.txt"
cat "$BASE/alignment/alignment_flagstat.txt"
