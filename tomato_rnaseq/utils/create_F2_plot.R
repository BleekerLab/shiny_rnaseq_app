import_process_and_create_f2_plot_data <- function(dataset = "datasets/dataset03_F2_ElitexPI127826.csv", 
                                                    my_selected_gene = "Solyc10g075090"){
  # Goal = pass the plot ready for Shiny
  new_genotype_levels = c("Elite_2017",
                          "Elite_2020",
                          "F1",     
                          "PI127826_2020",
                          "PI127826_2017",
                          "F2-28",
                          "F2-73",
                          "F2-127",
                          "F2-151",
                          "F2-411",
                          "F2-445")
  genotype2phenotype <- read.csv("info/dataset03_F2_samples2condition.csv", 
                                 stringsAsFactors = FALSE)
  
  df <- read.csv(dataset, stringsAsFactors = FALSE, check.names = FALSE)
  
  df_filtered <- dplyr::filter(.data = df, grepl(pattern = my_selected_gene, x = gene)) %>% 
    inner_join(., y = genotype2phenotype, by = "genotype") %>% 
    mutate(genotype = factor(genotype, levels = new_genotype_levels))
  
  
  p <- ggplot(df_filtered, aes(x = genotype, y = counts, col = trichome_class)) + 
    geom_point(size = 3) + 
    scale_fill_brewer(type = "qual", palette = 3) +
    coord_flip() +
    labs(x = "Genotypes (From the Elite x PI127826 cross)", y = "Normalised counts (AU)")
  
  return(p)
}
