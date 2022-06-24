import_process_and_create_gland_plot <- function(dataset = "datasets/dataset05_isolated_glands_active_lazy_BC1F3.csv", 
                                                    my_selected_gene = "Solyc10g075090"){
  # Goal = pass the plot ready for Shiny
  new_genotype_levels = c("Moneymaker",
                          "Elite",
                          "BC1F3-P447-05",
                          "BC1F3-P427-24",
                          "F2-P28",
                          "PI127826")
  
  df <- data.table::fread(file = dataset, 
                          data.table = FALSE,
                          stringsAsFactors = F, check.names = FALSE)
  
  df_filtered <- dplyr::filter(.data = df, grepl(pattern = my_selected_gene, x = gene)) %>% 
    mutate(genotype = factor(genotype, levels = new_genotype_levels))
  
  plot_title <- glue("{my_selected_gene} gene expression in 'active' and 'lazy' type 6 trichome glands")
  p <- ggplot(df_filtered, aes(x = genotype, y = scaled_counts, fill = terpene_productivity)) + 
    geom_boxplot() +
    geom_point() +
    coord_flip() +
    labs(x = "Genotypes", y = "Normalised counts (AU)") +
    ggtitle(plot_title) 
  p <- ggplotly(p)
  
  return(p)
}
