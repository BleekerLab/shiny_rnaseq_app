create_tissue_plot <- function(dataset = "datasets/dataset02_tissues.csv", 
                                                          my_selected_gene = "Solyc10g075090"){
  # Goal = pass the plot ready for Shiny
  df <- read.csv(dataset, stringsAsFactors = FALSE, check.names = FALSE) %>% 
    pivot_longer(- gene, names_to = "sample", values_to = "counts") %>% 
    separate(sample, into = c("genotype", "tissue","replicate"), sep = "_") %>% 
    mutate(tissue = gsub(pattern = "baldStem", replacement = "bald_stem", x = tissue)) %>% 
    mutate(genotype = factor(genotype, levels = c("Moneymaker", "PI127826", "LA0716")))
    
  
  df_filtered <- dplyr::filter(.data = df, grepl(pattern = my_selected_gene, x = gene)) 
  
  p <- ggplot(df_filtered, aes(x = genotype, y = counts, fill = genotype)) + 
    geom_boxplot() + 
    geom_point() +
    scale_fill_brewer(type = "qual", palette = 3) +
    facet_wrap(~ tissue) +
    labs(x = "Genotypes", y = "Normalised counts (AU)") +
    ggtitle("Gene expression in different tissues")
  return(p)
}
