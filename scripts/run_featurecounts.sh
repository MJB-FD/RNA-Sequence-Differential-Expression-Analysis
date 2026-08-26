#!/bin/bash
set -e

mkdir -p results/counts

featureCounts \
  -T 2 \
  -p \
  --countReadPairs \
  -t exon \
  -g gene_id \
  -a reference/annotation/gencode.v50.annotation.gtf \
  -o results/counts/gene_counts.txt \
  results/alignment/*.sorted.bam

echo "featureCounts complete."
