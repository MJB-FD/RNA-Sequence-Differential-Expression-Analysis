##################################################
# RNA-seq differential expression analysis
# Dataset: GSE52778
##################################################

# 1. Load packages

library(DESeq2)
library(AnnotationDbi)
library(org.Hs.eg.db)
library(ggplot2)
library(pheatmap)


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


# 16. Save tables

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


# 17. Variance-stabilizing transformation

vsd <- vst(
  dds,
  blind = FALSE
)


# 18. Save PCA plot

png(
  "results/differential_expression/pca_plot.png",
  width = 1200,
  height = 900,
  res = 150
)

plotPCA(
  vsd,
  intgroup = c("condition", "cell_line")
)

dev.off()


# 19. Save MA plot

png(
  "results/differential_expression/ma_plot.png",
  width = 1200,
  height = 900,
  res = 150
)

plotMA(
  results_dex,
  alpha = 0.05,
  ylim = c(-6, 6)
)

dev.off()


# 20. Prepare volcano plot data

results_df$significance <- "Not significant"

results_df$significance[
  !is.na(results_df$padj) &
  results_df$padj < 0.05 &
  results_df$log2FoldChange >= 1
] <- "Upregulated"

results_df$significance[
  !is.na(results_df$padj) &
  results_df$padj < 0.05 &
  results_df$log2FoldChange <= -1
] <- "Downregulated"


# 21. Save volcano plot

volcano_plot <- ggplot(
  results_df,
  aes(
    x = log2FoldChange,
    y = -log10(padj),
    color = significance
  )
) +
  geom_point(
    alpha = 0.6,
    size = 1.5
  ) +
  geom_vline(
    xintercept = c(-1, 1),
    linetype = "dashed"
  ) +
  geom_hline(
    yintercept = -log10(0.05),
    linetype = "dashed"
  ) +
  labs(
    title = "Dexamethasone vs Untreated",
    x = "Log2 Fold Change",
    y = "-Log10 Adjusted P-value"
  ) +
  theme_minimal()

ggsave(
  "results/differential_expression/volcano_plot.png",
  plot = volcano_plot,
  width = 8,
  height = 6,
  dpi = 150
)


# 22. Prepare top 30 genes for heatmap

top_results <- results_df[
  !is.na(results_df$padj),
]

top_results <- top_results[
  order(top_results$padj),
]

top_results <- top_results[1:30, ]

top_genes <- rownames(top_results)

heatmap_matrix <- assay(vsd)[top_genes, ]


# 23. Prepare heatmap labels

gene_labels <- ifelse(
  is.na(top_results$gene_symbol),
  top_results$ensembl_id,
  top_results$gene_symbol
)

annotation_col <- data.frame(
  condition = metadata$condition,
  cell_line = metadata$cell_line
)

rownames(annotation_col) <- rownames(metadata)


# 24. Save heatmap

pheatmap(
  heatmap_matrix,
  scale = "row",
  annotation_col = annotation_col,
  labels_row = gene_labels,
  filename = "results/differential_expression/top30_heatmap.png",
  width = 8,
  height = 10
)
