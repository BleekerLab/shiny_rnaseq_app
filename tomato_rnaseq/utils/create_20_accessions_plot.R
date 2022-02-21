create_20_accessions_plot <- function(dataset = "datasets/dataset01_20_accessions.csv", 
                                                          my_selected_gene = "Solyc10g075090"){
  # Goal = pass the plot ready for Shiny
  # Step 01: import counts
  df <- read.csv(dataset, 
                 stringsAsFactors = F) %>% 
    pivot_longer(- gene, names_to = "sample", values_to = "counts") %>% 
    separate(sample, into = c("genotype", "replicate"))
  
  # Step 02: import sample to genotype and species correspondence 
  genotype2species <- read.csv("info/dataset01_20_accessions_samples2species.csv", 
                               stringsAsFactors = F) %>% 
    arrange(species)
  species_order <- genotype2species %>% pull(species) %>% unique()
  genotype_order <- genotype2species %>% pull(genotype) %>% unique()
  
  # Step 03: filter complete dataframe to keep only gene of interest
  df_filtered <- dplyr::filter(.data = df, grepl(pattern = my_selected_gene, x = gene)) %>% 
    inner_join(., y = genotype2species, by = "genotype") %>% 
    mutate(species = factor(species, levels = species_order)) %>% 
    mutate(genotype = factor(genotype, levels = genotype_order)) 
  
  # Step 04: Create the plot and make it interactive 
  plot_title <- glue("{my_selected_gene} gene expression in stem trichomes (20 accessions)")
  
  p <- ggplot(df_filtered, aes(x = genotype, y = counts, fill = species)) + 
    geom_boxplot() + 
    geom_point() +
    scale_fill_brewer(type = "qual", palette = 3) +
    labs(x = "Genotype", y = "Normalised counts (AU)") +
    ggtitle(plot_title) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  p <- ggplotly(p)
  
  return(p)
}


