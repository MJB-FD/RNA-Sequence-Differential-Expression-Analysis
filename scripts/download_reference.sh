#!/bin/bash

mkdir -p reference/hisat2_index/hg38
mkdir -p reference/annotation

wget -c \
https://genome-idx.s3.amazonaws.com/hisat/hg38_genome.tar.gz \
-P reference/hisat2_index/hg38

tar -xzf reference/hisat2_index/hg38/hg38_genome.tar.gz \
-C reference/hisat2_index/hg38

wget -c \
https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_50/gencode.v50.annotation.gtf.gz \
-P reference/annotation
