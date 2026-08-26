#!/bin/bash
set -e

RUNS=(
SRR1039508
SRR1039509
SRR1039512
SRR1039513
SRR1039516
SRR1039517
SRR1039520
SRR1039521
)

mkdir -p data/raw/sra

for run in "${RUNS[@]}"
do
    echo "Downloading $run..."
    prefetch "$run" --output-directory data/raw/sra
done

echo "SRA download complete."
