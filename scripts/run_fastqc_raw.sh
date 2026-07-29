#!/usr/bin/env bash

INPUT_DIR="data/raw/fastq"
OUTPUT_DIR="results/qc/fastqc_raw"

start_time=$(date +%s)

for fastq_file in "$INPUT_DIR"/*.fastq.gz
do
	echo "Running FastQC on $fastq_file"

	fastqc "$fastq_file" -o "$OUTPUT_DIR"
done

end_time=$(date +%s)

elapsed=$((end_time - start_time))

echo
echo "=================================="
echo "FastQC completed!"
echo "Total runtime: ${elapsed} seconds"
echo "=================================="
