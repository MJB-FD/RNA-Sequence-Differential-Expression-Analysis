#!/bin/bash
set -e

echo "1. Downloading SRA files..."
bash scripts/download_sra.sh

echo "2. Converting SRA to FASTQ..."
bash scripts/sra_to_fastq.sh

echo "3. Running FastQC..."
bash scripts/run_fastqc_raw.sh

echo "4. Downloading reference files..."
bash scripts/download_reference.sh

echo "5. Running HISAT2 alignment..."
bash scripts/run-hisat2.sh

echo "6. Summarizing alignment rates..."
bash scripts/summarize_alignment_rates.sh

echo "7. Running featureCounts..."
bash scripts/run_featurecounts.sh

echo "8. Running DESeq2 analysis..."
Rscript scripts/r/deseq2_analysis.R

echo "Pipeline complete."
