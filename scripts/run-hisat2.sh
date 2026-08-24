#!/bin/bash

set -e
set -o pipefail

INDEX="reference/hisat2_index/hg38/hg38/genome"
FASTQ_DIR="data/raw/fastq"
OUT_DIR="results/alignment"

SAMPLES=(
SRR1039509
SRR1039512
SRR1039513
SRR1039516
SRR1039517
SRR1039520
SRR1039521
)

TOTAL_START=$(date +%s)

for SAMPLE in "${SAMPLES[@]}"
do
    SAMPLE_START=$(date +%s)

    echo "===================================="
    echo "Processing $SAMPLE"
    echo "Started: $(date)"
    echo "===================================="

    hisat2 \
        -x "$INDEX" \
        -1 "$FASTQ_DIR/${SAMPLE}_1.fastq.gz" \
        -2 "$FASTQ_DIR/${SAMPLE}_2.fastq.gz" \
        -p 2 \
        2> "$OUT_DIR/${SAMPLE}.hisat2_summary.txt" \
    | samtools sort \
        -@ 1 \
        -m 256M \
        -o "$OUT_DIR/${SAMPLE}.sorted.bam"

    samtools quickcheck -v "$OUT_DIR/${SAMPLE}.sorted.bam"

    samtools index "$OUT_DIR/${SAMPLE}.sorted.bam"

    samtools flagstat "$OUT_DIR/${SAMPLE}.sorted.bam" \
        > "$OUT_DIR/${SAMPLE}.flagstat.txt"

    SAMPLE_END=$(date +%s)
    ELAPSED=$((SAMPLE_END - SAMPLE_START))

    echo "$SAMPLE complete"
    echo "Runtime: $((ELAPSED / 60)) min $((ELAPSED % 60)) sec"
    echo
done

TOTAL_END=$(date +%s)
TOTAL=$((TOTAL_END - TOTAL_START))

echo "===================================="
echo "All remaining samples completed"
echo "Total runtime: $((TOTAL / 3600)) hr $(((TOTAL % 3600) / 60)) min $((TOTAL % 60)) sec"
echo "Finished: $(date)"
echo "===================================="
