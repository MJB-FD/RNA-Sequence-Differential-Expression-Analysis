# Lab Notebook

## Dataset Setup

Used GSE52778, an RNA-seq dataset of human airway smooth muscle cells.

For this analysis I selected 8 samples:
- 4 untreated
- 4 dexamethasone-treated
- 4 different cell lines, with one untreated and one treated sample from each

Saved the SRA metadata in:

`data/metadata/sra/SraRunTable.csv`

### Metadata issue

Initially tried using `cut` to inspect specific CSV columns. The output was incorrect because some CSV fields contained commas inside quoted values, which caused the columns to shift.

Used a CSV-aware parser instead to inspect the metadata correctly.

Important metadata identified:
- Run accession
- Cell line
- Cell type
- Treatment
- Library layout
- Library source
- Organism

Created:

`data/metadata/sample_metadata.csv`

This contains the sample, cell line, and treatment information needed by DESeq2.


## SRA → FASTQ

Downloaded the selected SRA runs and converted them to paired-end FASTQ.

Used `fasterq-dump` followed by `pigz` compression because storing all uncompressed FASTQs at once required too much disk space.

Final input consisted of 16 compressed FASTQ files:

- 8 samples
- R1 and R2 for each sample


## Raw Read QC

Ran FastQC on all FASTQ files.

Checked:
- Per-base sequence quality
- GC content
- Sequence duplication
- Adapter content
- Overrepresented sequences

Then combined the individual FastQC reports with MultiQC.

The reads were generally high quality and no major issue required trimming before alignment.


## Reference

Used:
- hg38 HISAT2 index
- GENCODE v50 annotation

Created `scripts/download_reference.sh` so the reference files can be downloaded again instead of storing the large files in Git.


## Alignment

Aligned paired-end reads to hg38 using HISAT2.

Piped HISAT2 output directly through SAMtools to create sorted BAM files instead of saving intermediate SAM files. This was done to reduce disk usage.

Generated for each sample:
- Sorted BAM
- BAM index
- HISAT2 alignment summary
- `samtools flagstat` summary

Overall alignment rates were approximately 96–98%.

Created:

`results/alignment/alignment_rates.tsv`


## Gene Counting

Used featureCounts with the GENCODE v50 GTF to assign aligned fragments to genes.

Output:

`results/counts/gene_counts.txt`

Most reads were assigned successfully. The main unassigned categories were multimapping reads, ambiguous reads, and reads with no annotated feature.

The count matrix contained 78,733 annotated features before filtering.


## Differential Expression Setup

Used R and DESeq2.

Imported:
- `gene_counts.txt`
- `sample_metadata.csv`

Removed the featureCounts annotation columns and kept the 8 sample count columns.

Cleaned the BAM filenames so the count-matrix column names matched the sample IDs in the metadata.

Used:

`design = ~ cell_line + condition`

Reason: each cell line has an untreated and dexamethasone sample. Including `cell_line` accounts for baseline differences between the cell lines while testing the treatment effect.

Filtered genes with fewer than 10 total counts.

Genes remaining:

23,391


## DESeq2

Ran DESeq2 normalization and differential-expression testing.

Comparison:

`dexamethasone vs untreated`

Positive log2 fold change = higher expression with dexamethasone.

Negative log2 fold change = lower expression with dexamethasone.

Results at `padj < 0.05`:
- 3,879 significant genes
- 2,167 upregulated
- 1,712 downregulated

Applied a stronger cutoff:

`padj < 0.05 AND |log2FoldChange| >= 1`

Results:
- 1,049 genes
- 540 upregulated
- 509 downregulated

Mapped Ensembl IDs to gene symbols using `AnnotationDbi` and `org.Hs.eg.db`.


## PCA

Applied DESeq2 variance-stabilizing transformation before PCA.

PC1 explained 50.3% of the variation.

PC2 explained 23.0%.

Untreated samples were on the negative side of PC1 and dexamethasone samples were on the positive side.

Interpretation: treatment is associated with the largest source of expression variation. Cell-line differences appear to contribute to PC2.

Saved:

`results/differential_expression/pca_plot.png`


## Differential Expression Plots

Generated:
- MA plot
- Volcano plot
- Top 30 gene heatmap

The heatmap clearly separated untreated and dexamethasone-treated samples based on the strongest DE genes.

Saved:
- `ma_plot.png`
- `volcano_plot.png`
- `top30_heatmap.png`


## GO Enrichment

Originally tried using `clusterProfiler`.

### Installation problems

Several dependencies failed to compile.

Problems included:
- `systemfonts` missing `fontconfig/fontconfig.h`
- `fs` missing `uv.h`
- `fgsea` / Boost C++ compatibility problems

Installed the missing Ubuntu development libraries, but `clusterProfiler` continued to have dependency issues.

Rather than spending more time fixing unrelated package dependencies, switched to `gprofiler2`.

Used the 1,049 significant genes as the query.

Used the genes tested by DESeq2 as the custom background rather than the entire human genome.

Ran GO Biological Process enrichment.

Strong enriched categories included:
- Signaling
- Cell communication
- Response to stimulus
- Signal transduction
- Cell differentiation

Saved:

`results/differential_expression/go_enrichment_results.csv`


## Disk Space / Git Issues

FASTQs, BAMs, and the HISAT2 index used roughly 46 GB.

Once gene counting and the downstream analysis were complete, deleted the large reproducible intermediate files.

Kept:

`results/counts/gene_counts.txt`

This is enough to rerun the DESeq2 analysis without repeating alignment and counting.

The count matrix is ~129 MB and exceeded GitHub's 100 MB file limit.

Removed it from Git tracking and added it to `.gitignore`.

Large raw data, BAMs, and reference files are also excluded from Git. Scripts and metadata are kept so those files can be regenerated.
