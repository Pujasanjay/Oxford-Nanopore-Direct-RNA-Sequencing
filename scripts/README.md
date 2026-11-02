# RNA004 workflow scripts for GitHub

These scripts were **reconstructed for publication** from the original six Bash/Slurm scripts pasted from the IU Quartz project and the analysis commands recorded in the README. They have **not been rerun as a complete pipeline** in this environment. Do not describe them as verbatim copies of executed batch jobs.

## Script execution order

Run `mkdir -p /N/slate/puthora/nanopore_midterm/logs` before submitting scripts (Slurm opens log files before each script begins). Use `sbatch scripts/<script>.sh` **one step at a time after verifying the preceding step succeeded**, or set up Slurm dependencies; submitting all jobs simultaneously can fail due to missing outputs.

1. `download_pod5.sh`
2. `basecall_rna004.sh` (requires RNA004 SUP model directory and H100 GPU)
3. `prepare_fastq.sh` (equivalent extraction command, original not retained)
4. `run_nanoplot.sh` (can run after basecalling)
5. `download_transcriptome.sh` (includes equivalent FASTA-header simplification)
6. `align_transcriptome.sh`
7. `convert_pod5_to_blow5.sh` (working-interpreter workaround; must have `bluecrab_test_env`)
8. `squigualiser_reform.sh`
9. `squigualiser_realign.sh`
10. `index_signal_paf.sh` (reproduces warning-prone index step)
11. `squigualiser_plot.sh`

## Differences from original saved scripts

- Download scripts have corrected **plain HTTPS URLs** rather than the Markdown link text shown in pasted output; check exact source files before assuming the paste reflected the bytes on Quartz.
- `convert_pod5_to_blow5.sh` uses the documented successful compatible interpreter instead of the original failed direct Blue-Crab invocation. It should not be presented as an untouched original script.
- `download_transcriptome.sh` also performs documented FASTA header simplification; the original saved script only downloaded/decompressed the FASTA.
- FASTQ extraction and Squigualiser scripts are reconstructed from the documented commands, not saved originals.
- Slurm resource requests and absolute paths target one IU Quartz allocation and require adjustment elsewhere.

## Scientific limitations

The Squigualiser reform offset `-m 0` has not been independently calibrated for this RNA004 model. Tabix raised `Coordinate <= 0` warnings on the signal PAF. The original analysis generated 110 HTML visualizations, but the exact signal-to-base calibration is not independently validated; do not infer RNA modifications.

## Verification

Run `bash -n scripts/*.sh` only on **individual files** with a loop (shown below), since `bash -n scripts/*.sh` does not validate all of them:

```bash
for f in scripts/*.sh; do bash -n "$f" || exit 1; done
```

Syntax validation is not execution validation; the software environments, data, and inputs must exist for the pipeline to run.
