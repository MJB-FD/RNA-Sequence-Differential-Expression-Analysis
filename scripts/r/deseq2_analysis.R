##################################################
# RNA-seq differential expression analysis
# Dataset: GSE52778
##################################################

# 1. Load packages

library(DESeq2)
library(AnnotationDbi)
library(org.Hs.eg.db)


# 2. File paths

counts_file <- "results/counts/gene_counts.txt"
metadata_file <- "data/metadata/sample_metadata.csv"


# 3. Import featureCounts output

counts_raw <- read.delim(
  counts_file,
  comment.char = "#",
  check.names = FALSE
)


# 4. Prepare count matrix

count_matrix <- counts_raw[, 7:14]

rownames(count_matrix) <- counts_raw$Geneid

colnames(count_matrix) <- sub(
  ".*/(SRR[0-9]+)\\.sorted\\.bam",
  "\\1",
  colnames(count_matrix)
)


# 5. Import sample metadata

metadata <- read.csv(
  metadata_file,
  row.names = 1
)

metadata$cell_line <- factor(metadata$cell_line)

metadata$condition <- factor(
  metadata$condition,
  levels = c("untreated", "dexamethasone")
)


# 6. Verify sample order

stopifnot(
  identical(
    colnames(count_matrix),
    rownames(metadata)
  )
)


# 7. Create DESeq2 dataset

dds <- DESeqDataSetFromMatrix(
  countData = count_matrix,
  colData = metadata,
  design = ~ cell_line + condition
)


# 8. Filter low-count genes

keep <- rowSums(counts(dds)) >= 10

dds <- dds[keep, ]


# 9. Run DESeq2

dds <- DESeq(dds)


# 10. Extract dexamethasone vs untreated results

results_dex <- results(
  dds,
  name = "condition_dexamethasone_vs_untreated",
  alpha = 0.05
)

results_dex <- results_dex[
  order(results_dex$padj),
]


# 11. Convert results to data frame

results_df <- as.data.frame(results_dex)

results_df$Geneid <- rownames(results_df)


# 12. Clean Ensembl IDs

results_df$ensembl_id <- sub(
  "\\..*$",
  "",
  results_df$Geneid
)


# 13. Add gene symbols

results_df$gene_symbol <- mapIds(
  org.Hs.eg.db,
  keys = results_df$ensembl_id,
  keytype = "ENSEMBL",
  column = "SYMBOL",
  multiVals = "first"
)


# 14. Reorder columns

results_df <- results_df[
  ,
  c(
    "Geneid",
    "ensembl_id",
    "gene_symbol",
    "baseMean",
    "log2FoldChange",
    "lfcSE",
    "stat",
    "pvalue",
    "padj"
  )
]


# 15. Select significant genes

significant <- subset(
  results_df,
  !is.na(padj) &
  padj < 0.05 &
  abs(log2FoldChange) >= 1
)


# 16. Save results

write.csv(
  results_df,
  "results/differential_expression/deseq2_results_annotated.csv",
  row.names = FALSE
)

write.csv(
  significant,
  "results/differential_expression/significant_genes.csv",
  row.names = FALSE
)
