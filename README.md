# r_custom_functions
I use this repository for recording the functions i write in R for my daily tasks

## 1. compare_df() function

It takes four arguments:

  - df1 and df2 - name of dataframes to compare
  - unique_id_df1 - unique identifier in df1
  - unique_id_df2 - unique identifier in df2

```{r}
dt1 <- dt2 <- mtcars
dt1$id <- dt2$id <- rownames(mtcars)
dt2$am[dt1$am == 1] <- 2

compare_df(df1 = dt1, df2 = dt2,
           unique_id_df1 = "id",
           unique_id_df2 = "id"
           )
```
