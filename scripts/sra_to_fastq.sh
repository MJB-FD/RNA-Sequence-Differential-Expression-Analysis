#!/bin/bash

set -e

SAMPLE=$1

echo "===================================="
echo "Converting $SAMPLE"
echo "===================================="

fasterq-dump \
    --threads 8 \
    --outdir data/raw/fastq \
    data/raw/sra/$SAMPLE

echo
echo "Compressing FASTQ files..."

pigz "data/raw/fastq/${SAMPLE}_1.fastq" &
pigz "data/raw/fastq/${SAMPLE}_2.fastq" &
wait

echo
echo "Testing compressed FASTQ files..."

pigz -t "data/raw/fastq/${SAMPLE}_1.fastq.gz"
pigz -t "data/raw/fastq/${SAMPLE}_2.fastq.gz"

echo "Compression verified."

echo
echo "Removing original SRA archive..."

rm -r "data/raw/sra/${SAMPLE}"

echo
echo "Finished $SAMPLE"

echo
echo "Finished $SAMPLE"
