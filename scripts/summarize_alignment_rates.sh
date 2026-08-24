#!/bin/bash

SUMMARY_DIR="results/alignment"

printf "Sample\tAlignment_Rate\n"

for FILE in "$SUMMARY_DIR"/*.hisat2_summary.txt
do
	SAMPLE=$(basename "$FILE" .hisat2_summary.txt)
	RATE=$(grep "overall alignment rate" "$FILE" | awk '{print $1}')

	printf "%s\t%s\n" "$SAMPLE" "$RATE"
done
