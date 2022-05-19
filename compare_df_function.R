# Custom function for comparing two data frames
compare_df <- function(df1, df2, unique_id_df1, unique_id_df2) {
  df1 <- df1 %>% 
    select(KEY = unique_id_df1, everything()) %>% 
    mutate(across(-KEY, function(x)
      x = as.character(x)
    )) %>% 
    pivot_longer(-KEY, values_to = "value_1") %>% 
    mutate(value_1 = str_squish(value_1))
  
  df2 <- df2 %>% 
    select(KEY = unique_id_df2, everything()) %>% 
    mutate(across(-KEY, function(x)
      x = as.character(x)
    )) %>% 
    pivot_longer(-KEY, values_to = "value_2") %>% 
    mutate(value_2 = str_squish(value_2))
  
  df_both <- full_join(df1, df2, by = c("KEY", "name"))
  
  diff <- df_both %>% 
    filter((value_1 != value_2) | (is.na(value_1) & !is.na(value_2)) | (!is.na(value_1) & is.na(value_2))) %>%
    # filter(value_1 != value_2) %>% 
    rename(values_in_df1 = value_1, values_in_df2 = value_2)
  
  if(nrow(diff) == 0) {
    paste0("No difference in df1 and df2")
  } else {
    return(diff) 
  }
}