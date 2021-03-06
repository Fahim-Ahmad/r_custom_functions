# Custom function for comparing two data frames
library(dplyr)
library(tidyr)
library(stringr)

compare_df <- function(df1, df2, unique_id_df1, unique_id_df2) {
  
  if ("KEY" %in% colnames(df1) & unique_id_df1 != "KEY") {
    df1 <- df1 %>% 
      rename(key = KEY)
  }
  
  df1 <- df1 %>% 
    select(KEY = all_of(unique_id_df1), everything()) %>% 
    mutate(across(-KEY, function(x)
      x = as.character(x)
    )) %>% 
    pivot_longer(-KEY, values_to = "value_1") %>% 
    mutate(value_1 = str_squish(value_1))
  
  if ("KEY" %in% colnames(df2) & unique_id_df2 != "KEY") {
    df2 <- df2 %>% 
      rename(key = KEY)
  }
  
  df2 <- df2 %>% 
    select(KEY = all_of(unique_id_df2), everything()) %>% 
    mutate(across(-KEY, function(x)
      x = as.character(x)
    )) %>% 
    pivot_longer(-KEY, values_to = "value_2") %>% 
    mutate(value_2 = str_squish(value_2))
  
  df_both <- full_join(df1, df2, by = c("KEY", "name"))
  
  diff <- df_both %>% 
    filter((value_1 != value_2) | (is.na(value_1) & !is.na(value_2)) | (!is.na(value_1) & is.na(value_2))) %>%
    rename(column_name = name, value_in_df1 = value_1, value_in_df2 = value_2) %>% 
    mutate(column_name = ifelse(column_name == "key", "KEY", column_name))
  
  if(nrow(diff) == 0) {
    paste0("No difference in df1 and df2")
  } else {
    return(diff) 
  }
}
