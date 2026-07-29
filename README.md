# RNA-Seq Differential Expression Analysis Pipeline

This repository documents my implementation of an end-to-end RNA-seq differential expression analysis pipeline using publicly available human sequencing data. The goal of the project is to understand each stage of an RNA-seq workflow by building it from the ground up rather than relying on pre-built pipelines.

The analysis begins with raw sequencing data downloaded from the Sequence Read Archive (SRA) and will progress through quality control, read alignment, gene quantification, differential expression analysis, and biological interpretation.

---

## Dataset

* **Source:** NCBI Gene Expression Omnibus (GSE52778)
* **Organism:** *Homo sapiens*
* **Experiment:** Bulk RNA-seq
* **Library layout:** Paired-end
* **Samples:** 8 (4 untreated, 4 dexamethasone-treated)

---

## Project Goals

* Learn the purpose of each step in an RNA-seq analysis pipeline.
* Gain hands-on experience with commonly used bioinformatics software.
* Write reusable Bash scripts to automate repetitive tasks.
* Produce a well-documented project that demonstrates practical bioinformatics skills.

---

## Workflow

* Download sequencing data
* Convert SRA files to FASTQ
* Assess read quality with FastQC
* Summarize quality reports with MultiQC
* Trim reads if quality assessment indicates it is necessary
* Align reads to the reference genome
* Generate gene-level read counts
* Perform differential expression analysis
* Interpret biologically significant results

---

## Repository Structure
```
data/        Raw data and metadata
docs/        Project documentation
logs/        Command logs
reference/   Reference genome and annotations
results/     Analysis outputs
scripts/     Bash automation scripts
```

---

## Progress

* [x] Project setup
* [x] Dataset downloaded
* [x] SRA → FASTQ conversion
* [x] FastQC completed
* [ ] MultiQC
* [ ] Read trimming (if required)
* [ ] Alignment
* [ ] Gene quantification
* [ ] Differential expression analysis
* [ ] Functional interpretation

---

## Tools

Linux • Bash • Git • SRA Toolkit • FastQC • MultiQC • HISAT2 • SAMtools • featureCounts • R • DESeq2

---

This repository is updated as the project progresses. Each stage is documented, committed independently, and built with an emphasis on understanding the analysis rather than simply producing the final result.
