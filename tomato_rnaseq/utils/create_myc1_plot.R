create_myc1_plot <- function(dataset          = "datasets/dataset04_MYC1.csv", 
                             info             = "info/dataset04_MYC1_samples2conditions.csv",
                             my_selected_gene = "Solyc10g075090"){
  # Import counts
  df <- data.table::fread(file = dataset, 
                          data.table = FALSE,
                          stringsAsFactors = F)
  
  # Import sample to genotype and tissue correspondence
  genotype2conditions <- read.csv(info, 
                                stringsAsFactors = F) 
  
  genotype_order <- c("WT", "KO", "KD", "OE")
  tissue_order <- c("leaf", "stem_trichomes")
  
  # Keep gene of interest
  df_filtered <- dplyr::filter(.data = df, grepl(pattern = my_selected_gene, x = gene)) %>% 
  inner_join(., y = genotype2conditions, by = "sample") %>% 
  mutate(genotype = factor(genotype, levels = genotype_order)) %>% 
  mutate(tissue = factor(tissue, levels = tissue_order)) 
  
  plot_title <- glue("{my_selected_gene} gene expression in MYC1-related genotypes")
  p <- ggplot(df_filtered, aes(x = genotype, y = counts, fill = genotype)) + 
    geom_boxplot() + 
    scale_fill_brewer(type = "qual", palette = 3) +
    labs(x = "Genotype", y = "Normalised counts (AU)") +
    ggtitle(plot_title) +
    facet_wrap(~ tissue)

  # convert to interactive plotly figure
  p <- ggplotly(p)
  return(p)
}