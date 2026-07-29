# Project Information

## Objective

Build a reproducible RNA-seq differential expression analysis pipeline from raw sequencing reads to biological interpretation while demonstrating practical bioinformatics skills and reproducible research practices.

---

## Dataset

* **Source:** NCBI GEO (GSE52778)
* **Organism:** *Homo sapiens*
* **Sequencing:** Bulk RNA-seq
* **Library Layout:** Paired-end
* **Read Length:** 63 bp

| Condition     | Samples                                        |
| ------------- | ---------------------------------------------- |
| Untreated     | SRR1039508, SRR1039512, SRR1039516, SRR1039520 |
| Dexamethasone | SRR1039509, SRR1039513, SRR1039517, SRR1039521 |

**Total samples:** 8

---

## Biological Question

How does dexamethasone treatment affect gene expression compared with untreated controls?

---

## Planned Workflow

1. Download sequencing data
2. Convert SRA → FASTQ
3. FastQC
4. MultiQC
5. Read trimming (if required)
6. HISAT2 alignment
7. featureCounts quantification
8. DESeq2 differential expression
9. Functional enrichment and visualization

---

## Software

* Linux (WSL)
* Bash
* SRA Toolkit
* FastQC
* MultiQC
* HISAT2
* SAMtools
* featureCounts
* R / DESeq2
* Git & GitHub

---

## Current Status

**Completed**

* Repository initialized
* Dataset downloaded
* SRA files converted to compressed FASTQ
* FastQC completed

**Next**

* Aggregate QC with MultiQC
* Assess overall sequencing quality
* Determine whether trimming is required

