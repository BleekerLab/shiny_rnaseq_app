import_process__and_create_20_accessions_plot <- function(dataset = "datasets/20accessions.csv", my_selected_gene = "Solyc10g075090"){
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
  genotype2phenotype <- read.csv("datasets/dataset01_20_accessions.csv", 
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


df <- read.delim("tomato_rnaseq/datasets/20accessions.tsv", check.names = F, stringsAsFactors = F)
df$sample2 = df$sample
df <- df %>% separate(col = "sample2", into = c("genotype", "replicate")) 
