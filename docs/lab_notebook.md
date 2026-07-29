# Lab Notebook

This notebook records major milestones, observations, and decisions made throughout the project. It is intended as a concise record of *why* each step was taken rather than a log of every command that was run.

---

## 2026-07-28 — Project Setup & Raw Read Quality Control

### Goal

Set up the project structure, download the dataset, convert SRA files to FASTQ, and perform an initial quality assessment of the raw sequencing reads.

### Work Completed

* Created the project directory structure.
* Downloaded the GSE52778 dataset and organized the sample metadata.
* Converted all SRA files to compressed paired-end FASTQ format.
* Wrote a Bash script (`run_fastqc_raw.sh`) to automate FastQC across all samples.
* Generated FastQC reports for all 16 FASTQ files (8 paired-end samples).

### Key Observations

* Dataset contains 8 biological samples (4 untreated, 4 dexamethasone-treated).
* Reads are paired-end with a read length of 63 bp.
* The first sample inspected showed consistently high base quality (median > Q30 across the read).
* Quality decline toward the end of the reads was minimal and consistent with typical Illumina sequencing.

### Decisions

* Automated FastQC instead of running each sample manually to improve reproducibility.
* Kept generated QC reports out of version control since they can be regenerated at any time.
* Delayed any trimming decisions until all samples can be reviewed together with MultiQC.

### Next Step

Run MultiQC to compare quality metrics across all samples and determine whether read trimming is necessary before alignment.
