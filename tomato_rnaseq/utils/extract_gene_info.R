extract_gene_info_from_solgenomics <- function(my_selected_gene = "Solyc10g075090"){
  # Goal = create a table with gene information
  # List info for the selected gene

  gene_description_ITAG4 <- read.delim(file = "info/ITAG4.0_descriptions.txt", 
                                       stringsAsFactors = F) %>% 
    dplyr::filter(., grepl(pattern = my_selected_gene, x = gene)) %>% 
    mutate(source = "ITAG4.0")
  
  gene_description_ITAG25 <- read.delim(file = "info/ITAG2.4_descriptions.tsv", 
                                       stringsAsFactors = F) %>% 
    dplyr::filter(., grepl(pattern = my_selected_gene, x = gene)) 
  
  gene_descriptions <- bind_rows(gene_description_ITAG25, gene_description_ITAG4)
  
  return(gene_descriptions)
}
