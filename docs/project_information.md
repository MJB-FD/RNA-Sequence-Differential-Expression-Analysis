# RNA-seq Differential Expression Project

## Organism

Homo sapiens

## Experiment

Bulk RNA sequencing

## Sequencing Platform

Illumina

## Experimental Design

Control vs Treatment

3 biological replicates per condition

## Goal

Identify genes that are differentially expressed between treatment and control samples.

## Workflow

FASTQ

↓

FastQC

↓

fastp

↓

HISAT2

↓

samtools

↓

featureCounts

↓

DESeq2

↓

Biological interpretation
