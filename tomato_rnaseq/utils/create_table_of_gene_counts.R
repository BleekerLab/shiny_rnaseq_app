create_table_of_gene_counts <- function(my_selected_gene = "Solyc10g075090"){
  # Import all gene counts
  df1 <- data.table::fread(file = "datasets/dataset01_20_accessions.csv", 
                          data.table = FALSE,
                          stringsAsFactors = F) %>% 
    pivot_longer(- gene, values_to = "scaled_counts", names_to = "sample") %>% 
    dplyr::filter(.data = ., grepl(pattern = my_selected_gene, x = gene)) %>% 
    mutate(dataset = "20 accessions: ENA PRJEB44371") 
  
  df2 <- data.table::fread(file = "datasets/dataset02_tissues.csv", 
                           data.table = FALSE,
                           stringsAsFactors = F) %>% 
    pivot_longer(- gene, values_to = "scaled_counts", names_to = "sample") %>% 
    dplyr::filter(.data = ., grepl(pattern = my_selected_gene, x = gene)) %>% 
    mutate(dataset = "tissues: https://doi.org/10.5281/zenodo.4326969")
    
  df3 <- data.table::fread(file = "datasets/dataset05_isolated_glands_active_lazy_BC1F3.csv", 
                    data.table = FALSE,
                    stringsAsFactors = F) %>% 
    dplyr::filter(.data = ., grepl(pattern = my_selected_gene, x = gene)) %>%
    mutate(dataset = "Active lazy type6 trichomes: ENA PRJEBXXXX") %>% 
    mutate(sample_id = paste(sample_id, genotype,sep = "_")) %>% 
    dplyr::select(gene, sample_id, scaled_counts, dataset) %>% 
    dplyr::rename("sample" = "sample_id")
  
  df4 <- data.table::fread(file = "datasets/dataset04_MYC1_with_conditions.csv",
                           data.table = FALSE,
                           stringsAsFactors = F) %>% 
    dplyr::filter(.data = ., grepl(pattern = my_selected_gene, x = gene)) %>% 
    mutate(dataset = "MYC1-related dataset: ENA PRJEB49287") %>% 
    dplyr::rename("scaled_counts" = "counts") %>% 
    select(- tissue, - genotype)
  
  # Combine all data in one dataframe
  combined_df <- bind_rows(df1, df2, df3, df4)

  return(combined_df)
}