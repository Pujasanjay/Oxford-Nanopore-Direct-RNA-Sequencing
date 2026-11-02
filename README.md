# Oxford Nanopore Direct RNA Sequencing Analysis (RNA004)
End-to-end bioinformatics analysis of human Oxford Nanopore direct RNA sequencing (DRS) data using Dorado, NanoPlot, minimap2, and Squigualiser.
Project Overview
This project analyzes human RNA sequenced with Oxford Nanopore RNA004 chemistry, starting from raw nanopore electrical signals in a POD5 file and proceeding through GPU-accelerated basecalling, quality control, transcriptome alignment, and raw signal-to-reference visualization. The analysis was carried out on the Indiana University Quartz high-performance computing (HPC) cluster as part of MS Bioinformatics coursework.

Workflow: POD5 raw signal → Dorado basecalling with move tables → NanoPlot quality assessment → minimap2 transcriptome alignment → Squigualiser Option 2 signal-to-reference visualization.
Tools and Technologies
Tool / resource	Version or configuration	Purpose
Dorado	0.5.3	Basecalling
Dorado model	rna004_130bps_sup@v3.0.1	RNA004 Super Accuracy model
NanoPlot	1.48.0	Read quality assessment
minimap2	2.31-r1302	Long-read transcriptome alignment
samtools	1.24	BAM processing and mapping statistics
Squigualiser	0.7.0	Signal-to-reference plotting using basecaller move tables
Blue-Crab	Version not recorded	POD5-to-BLOW5 conversion
GENCODE	Human release 46	Reference transcriptome
Computing	Linux, Bash, Slurm, NVIDIA H100 GPU	HPC analysis environment


Key Results
Metric	Result
Basecalled reads	10,074
Total sequencing yield	10,745,746 bases (10.75 Mb)
Mean read length	1,066.7 nt
Median read length	793 nt
Read length N50	1,482 nt
Mean / median read quality	Q12.2 / Q14.1
Reads above Q10	9,325 (92.6%)
Reads above Q15	2,724 (27.0%)
Reads above Q20	36 (0.4%)
Primary reads mapped to transcriptome	9,471 / 10,074 (94.01%)
Signal-to-reference PAF records	9,324
Squigualiser HTML plots generated at target region	110


The 94.01% mapping rate refers to distinct primary reads. The separate 98.19% overall mapped-alignment-record percentage includes secondary and supplementary alignment records and should not be interpreted as the percentage of distinct reads mapped.
Target Signal Visualization
The required region is ENST00000387347.2 (MT-RNR2), positions 1360–1400. Squigualiser displays this as 1400–1360 in the direct-RNA orientation (3′ → 5′). The example read is 0e014703-7f84-4b04-9757-7fdc1ae0cf1f.
- The blue trace represents the nanopore ionic-current measurements.
- The colored blocks represent reference-base positions and their approximate associated signal spans.
- The basecaller move table connects electrical signal to basecalled sequence, and the transcriptome alignment connects the sequence to reference coordinates.
- 110 interactive HTML plots were generated for alignments overlapping the target region; one representative file is sufficient to illustrate the result here.
Important limitation: The signal-reform offset -m 0 was not independently calibrated for this RNA004 model; the plotting profile also applies base_shift: -5. The plots illustrate signal/reference correspondence, but do not establish precisely validated nucleotide-level signal positioning or RNA modifications.
Data Sources
- Raw dataset: Zenodo record 15853348, file rna004_hsapiens_r10k.pod5 (approximately 349 MB).
- Reference: GENCODE human release 46 transcriptome.
- Prepared reference: reference/gencode.v46.transcripts.simple.fa, with the FASTA identifier truncated at the first | to preserve transcript accessions such as ENST00000387347.2.
Raw POD5/BLOW5 signals, large FASTQ/BAM files, and the complete transcriptome reference are not redistributed in this repository. Obtain them from their original sources and regenerate intermediate files using the workflow below.
Reproducible Analysis Workflow
The following commands document the workflow run on Quartz. They were executed in a prepared Linux/HPC environment with the named tools installed. The tool-specific *_env/ paths are local virtual environments from that run; on another machine, replace them with your installed executable paths. GPU basecalling requires appropriate CUDA hardware. Examples identified as equivalent are supplied where the exact original command was not retained.

# Project setup
  
 Use an existing working directory (for example, a scratch directory on your HPC system).
BASE="$PWD"
mkdir -p "$BASE"/{data,models,basecalling,nanoplot,reference,alignment,signal_data,logs}
mkdir -p "$BASE/signal_plots/all_target_reads"
The original Quartz project directory was /N/slate/puthora/nanopore_midterm; that absolute path is specific to the original compute environment.
1. Download raw POD5 data
wget -c 'https://zenodo.org/records/15853348/files/rna004_hsapiens_r10k.pod5?download=1' \
  -O "$BASE/data/rna004_hsapiens_r10k.pod5"
md5sum "$BASE/data/rna004_hsapiens_r10k.pod5"
The original download was run via scripts/download_pod5.sh under Slurm. The original MD5 value was not preserved, so no checksum is asserted here.
2. Basecall using Dorado and retain move tables
The RNA004-specific SUP model rna004_130bps_sup@v3.0.1 was available locally under models/ in the original run. Download the matching model using Dorado's model distribution before running this step.
module load dorado/0.5.3

dorado basecaller \
  "$BASE/models/rna004_130bps_sup@v3.0.1" \
  "$BASE/data/rna004_hsapiens_r10k.pod5" \
  --device cuda:0 --emit-moves --min-qscore 0 \
  > "$BASE/basecalling/rna004_sup.bam"
--emit-moves retains the move-table information used by Squigualiser Option 2. --min-qscore 0 retains low-quality reads for QC rather than excluding them at basecalling.

A FASTQ was also produced from the unaligned BAM. The exact extraction command used originally was not retained; this equivalent command can regenerate it:
samtools fastq "$BASE/basecalling/rna004_sup.bam" \
  > "$BASE/basecalling/rna004_sup.fastq"
3. Assess read quality with NanoPlot
NanoPlot \
  --ubam "$BASE/basecalling/rna004_sup.bam" \
  --outdir "$BASE/nanoplot" --prefix RNA004_ \
  --threads 4 --plots hex dot
Key outputs: nanoplot/RNA004_NanoPlot-report.html and nanoplot/RNA004_NanoStats.txt. The output contained 10,074 reads totaling 10,745,746 bases, with N50 = 1,482 nt. Read quality was variable: 92.6% above Q10, but 27.0% above Q15.
4. Obtain and prepare GENCODE v46 reference
wget -c \
  'https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_46/gencode.v46.transcripts.fa.gz' \
  -O "$BASE/reference/gencode.v46.transcripts.fa.gz"

gunzip -k "$BASE/reference/gencode.v46.transcripts.fa.gz"
The exact original header-simplification command was not retained. This equivalent command strips the pipe-delimited annotation text while preserving transcript sequences:
awk '/^>/ {sub(/\|.*/, "", $0)} {print}' \
  "$BASE/reference/gencode.v46.transcripts.fa" \
  > "$BASE/reference/gencode.v46.transcripts.simple.fa"
5. Align reads to the transcriptome using minimap2
minimap2 -ax map-ont -t 8 \
  "$BASE/reference/gencode.v46.transcripts.simple.fa" \
  "$BASE/basecalling/rna004_sup.fastq" \
  2> "$BASE/logs/minimap2_alignment.log" \
  | samtools sort -@ 4 \
      -o "$BASE/alignment/rna004_transcriptome.sorted.bam" -

samtools index "$BASE/alignment/rna004_transcriptome.sorted.bam"
samtools flagstat "$BASE/alignment/rna004_transcriptome.sorted.bam" \
  > "$BASE/alignment/alignment_flagstat.txt"
The map-ont preset handles Nanopore long reads. A mature-transcript reference avoids the need for genomic splice-aware alignment in this particular analysis. The results included 9,471 mapped primary reads out of 10,074 (94.01%). Secondary and supplementary alignment records were not counted as additional reads.
6. Convert POD5 raw signal to BLOW5
Blue-Crab was used to produce a BLOW5 file for Squigualiser. A dependency mismatch affected the initially prepared environment; the successful command used the interpreter from bluecrab_test_env and the Blue-Crab entry point from bluecrab_env:
bluecrab_test_env/bin/python bluecrab_env/bin/blue-crab p2s \
  "$BASE/data/rna004_hsapiens_r10k.pod5" \
  -o "$BASE/signal_data/rna004_hsapiens_r10k.blow5" -t 4
The resulting BLOW5 was approximately 353 MB. The working environment had pyarrow 19.0.1 and pod5 0.3.49. If reproducing elsewhere, install a compatible Blue-Crab environment and substitute the correct executable or interpreter paths.
7. Squigualiser Option 2: reform moves into signal-to-read PAF
Six basecalled reads contained fewer than nine nucleotides and were excluded from the reform input (10,068 remaining):
samtools view -h "$BASE/basecalling/rna004_sup.bam" \
  | awk '/^@/ || length($10)>=9' \
  | samtools view -b -o "$BASE/signal_data/rna004_sup_filtered.bam" -

squigualiser reform \
  -b "$BASE/signal_data/rna004_sup_filtered.bam" \
  -c --rna -k 9 -m 0 \
  -o "$BASE/signal_data/rna004_read_signal_filtered.paf"
Observed: 9,858 reformed records; 210 split reads skipped. The -m 0 offset was used in the original successful run but was not independently calibrated for the RNA004 model.
8. Realign raw signal to reference transcripts
squigualiser realign \
  -p "$BASE/signal_data/rna004_read_signal_filtered.paf" \
  -b "$BASE/alignment/rna004_transcriptome.sorted.bam" \
  -c --rna --skip \
  -o "$BASE/signal_data/rna004_reference_signal.paf"
The original analysis produced 9,324 signal-to-reference PAF records. Of 177 alignments for the target transcript, 110 overlapped positions 1360–1400 after accounting for RNA-oriented coordinates.
9. Sort, compress, and index signal-to-reference PAF
awk 'BEGIN {OFS="\t"} {
  low=($8<$9 ? $8 : $9)
  print $6, low, $0
}' "$BASE/signal_data/rna004_reference_signal.paf" \
  | sort -k1,1 -k2,2n | cut -f3- \
  > "$BASE/signal_data/rna004_reference_signal.sorted.paf"

bgzip -c "$BASE/signal_data/rna004_reference_signal.sorted.paf" \
  > "$BASE/signal_data/rna004_reference_signal.sorted.paf.gz"

tabix -f -s 6 -b 9 -e 8 \
  "$BASE/signal_data/rna004_reference_signal.sorted.paf.gz"
Indexing caveat: The original Tabix run emitted Coordinate <= 0 detected warnings. Although the targeted plots were generated, the indexing approach above is documented as the procedure used—not as a generally validated PAF indexing recipe. Coordinate conventions and the applicable Squigualiser documentation should be checked before independently reproducing regional queries.
10. Plot the target transcript's raw electrical signal
squigualiser plot \
  -f "$BASE/reference/gencode.v46.transcripts.simple.fa" \
  -s "$BASE/signal_data/rna004_hsapiens_r10k.blow5" \
  -a "$BASE/signal_data/rna004_reference_signal.sorted.paf.gz" \
  --region ENST00000387347.2:1360-1400 \
  --rna --sig_ref \
  --profile kmer_model_rna004_130bps_9mer \
  --loose_bound --auto \
  -o "$BASE/signal_plots/all_target_reads"
The complete run had no plot limit. Squigualiser reported Number of plots: 110, independently matching the number of generated HTML files. An earlier exploratory run produced 10 plots, but that was not the final run.

To confirm the final output count:
find "$BASE/signal_plots/all_target_reads" -type f -name '*.html' | wc -l

Expected from original run: 110
Representative plot: 0e014703-7f84-4b04-9757-7fdc1ae0cf1f_.html, showing the requested region in reverse RNA orientation.
Interpreting the Results
The data contained a broad distribution of RNA read lengths. Although most reads were above Q10, only a minority exceeded Q15, illustrating variable basecalling confidence. Transcriptome alignment mapped 94.01% of primary reads to GENCODE v46, demonstrating substantial reference compatibility but not proving that every read had a unique transcript assignment or represented a complete transcript.

Squigualiser makes it possible to examine approximate relationships between nanopore current levels, basecalls, and transcript coordinates. Current variation alone cannot establish RNA modifications; the selected signal-to-base offset was not independently validated.
Precision Medicine Relevance
Long-read RNA sequencing can reveal the combination of alternative exons, retained introns, and transcript ends present in the same RNA molecule. This may distinguish disease-associated transcript isoforms that are difficult to reconstruct unambiguously from conventional short RNA-seq fragments. In oncology, such isoforms could inform biomarker discovery, pathway interpretation, and potentially treatment monitoring. This example is a methodological demonstration, not a clinical validation study.
Repository Contents
Suggested organization (include only the folders/files you actually upload):
Oxford-Nanopore-Direct-RNA-Sequencing/
├── README.md
├── scripts/                  # Original Bash / Slurm scripts, if provided
├── results/
│   ├── RNA004_NanoPlot-report.html
│   └── 0e014703-7f84-4b04-9757-7fdc1ae0cf1f_.html
├── figures/                  # Optional PNG screenshots of selected results
└── report/
    └── Report_MTA.docx
The original course report contains a screenshot of the representative Squigualiser figure. Interactive HTML reports may require a browser and access to their referenced JavaScript libraries.
Reproducibility Notes and Limitations
1. The repository documents the original HPC tool versions, model, reference, parameters, and observed results.
2. Some commands shown above are explicitly marked as reproducible equivalents because the exact original command was not preserved.
3. Virtual environment paths and the local Dorado model directory must be configured for another system; Slurm requests and dependency installation are environment-specific.
4. Blue-Crab conversion required a Python-environment workaround. The Squigualiser -m 0 move offset was not independently calibrated.
5. Tabix reported coordinate warnings. Exact signal-to-base locations and RNA modification status were not validated.
6. Raw and intermediate sequencing files are excluded because they are large and are available or regenerable from public sources.
References
- Original RNA004 test data — Zenodo
- Dorado
- NanoPlot
- minimap2
- Squigualiser — Option 2 basecaller move table
- GENCODE v46
Acknowledgment
Completed as an MS Bioinformatics course project using the Indiana University Quartz HPC environment. Generative AI tools assisted with documentation, formatting, and troubleshooting. The sequencing analyses and reported numerical outputs were generated during the computational workflow; method limitations are disclosed above.
