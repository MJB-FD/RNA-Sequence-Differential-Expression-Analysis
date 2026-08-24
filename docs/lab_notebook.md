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


"============================================================================================================"

## 2026-07-29 — Aggregate Quality Control (MultiQC)

### Goal

Summarize FastQC results across all samples to evaluate sequencing quality at the experiment level.

### Work Completed

- Installed MultiQC.
- Generated a combined QC report from all FastQC outputs.
- Verified that all FastQC reports were successfully detected.

### Key Observations

- MultiQC provides an experiment-wide view of sequencing quality that is difficult to obtain from individual FastQC reports.
- The report makes it easier to identify outlier samples and determine whether preprocessing is required.

### Decisions

- Review aggregate QC metrics before deciding whether to perform read trimming.

### Next Step

Interpret the MultiQC report and determine whether trimming should be included in the workflow.

"================================================================================================================="


## 2026-07-30 — Aggregate Quality Control (MultiQC)

### Goal

Review quality metrics across all samples to identify outliers and determine whether any preprocessing is needed before alignment.

### Work Completed

- Installed the latest version of MultiQC.
- Combined all 16 FastQC reports into a single QC report.
- Reviewed sequencing depth, GC content, duplication levels, and overall sample consistency.

### Key Observations

- All 16 FASTQ files were successfully detected by MultiQC.
- Sequencing depth ranged from approximately 16.8 to 34.3 million reads.
- GC content was highly consistent across all samples (48–50%).
- Read counts matched between paired-end files (R1 and R2).
- No obvious outlier samples were identified from the General Statistics table.
- Sequence duplication levels were consistent across samples and are not unexpected for bulk RNA-seq.

### Issues Encountered

**Problem:** The Ubuntu `apt` version of MultiQC generated a report with missing JavaScript assets, preventing the report from displaying correctly.

**Cause:** The packaged version was outdated and contained missing web assets.

**Solution:** Removed the `apt` version, installed the latest release with `pipx`, deleted the old output directory, and regenerated the report.

### Decisions

- Retained all samples for downstream analysis.
- Aggregate QC showed consistently high read quality across all samples.
- Adapter contamination was minimal and restricted to the final bases of a small proportion of reads.
- Read trimming was not performed because the QC metrics did not indicate that it would provide a meaningful benefit prior to alignment.
### Next Step

Review adapter content and determine whether read trimming is justified before alignment.

"================================================================================================================="
## HISAT2

### Purpose

Align RNA-seq reads to the human reference genome.

### Input

- Paired-end FASTQ files
- HISAT2 genome index

### Output

- Sorted BAM file (via samtools)
- Alignment summary statistics

### Why it is needed

Differential expression analysis requires knowing where each sequencing read originated in the genome before reads can be assigned to genes.
