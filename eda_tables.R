# ==========================================================
# ONE VERTICAL MASTER TABLE (show in R only, no saving)
# Dataset: StudentsPerformance.csv (Kaggle)
# ==========================================================

# --- (Optional) set your working directory ---
# setwd("E:/SEM 1 MCD Chandigarh University/Program_files/R_lab/mini project")

# --- Packages ---
need <- c("readr","dplyr","tidyr","janitor","tibble")
to_install <- need[!(need %in% installed.packages()[,"Package"])]
if(length(to_install)) install.packages(to_install, dependencies = TRUE)

library(readr); library(dplyr); library(tidyr); library(janitor); library(tibble)

# --- Load & clean ---
df_raw <- read_csv("StudentsPerformance.csv", show_col_types = FALSE)
df <- df_raw |>
  clean_names() |>
  rename(
    race_ethnicity     = race_ethnicity,
    parental_education = parental_level_of_education,
    test_prep          = test_preparation_course,
    math               = math_score,
    reading            = reading_score,
    writing            = writing_score
  )

num_cols <- c("math","reading","writing")
cat_cols <- c("gender","race_ethnicity","parental_education","lunch","test_prep")

# --------- A) OVERVIEW ----------
missing_by_col <- df |>
  summarise(across(everything(), ~sum(is.na(.)))) |>
  pivot_longer(everything(), names_to = "column", values_to = "missing_count") |>
  filter(missing_count > 0)

overview <- tibble(
  metric = c("Rows","Columns","Numeric variables","Categorical variables",
             "Total Missing (all columns)","Columns with Missing (>0)"),
  value  = c(nrow(df), ncol(df), length(num_cols), length(cat_cols),
             sum(is.na(df)), nrow(missing_by_col))
)

overview_long <- overview |>
  mutate(section = "Overview",
         key = metric,
         subkey = NA_character_,
         metric = "value",
         value = as.character(value)) |>
  select(section, key, subkey, metric, value)

# --------- B) SCORE DESCRIPTIVES ----------
desc_long <- bind_rows(lapply(num_cols, function(col){
  tibble(
    variable = col,
    n       = sum(!is.na(df[[col]])),
    mean    = mean(df[[col]], na.rm = TRUE),
    sd      = sd(df[[col]], na.rm = TRUE),
    min     = min(df[[col]], na.rm = TRUE),
    q1      = quantile(df[[col]], 0.25, na.rm = TRUE),
    median  = median(df[[col]], na.rm = TRUE),
    q3      = quantile(df[[col]], 0.75, na.rm = TRUE),
    max     = max(df[[col]], na.rm = TRUE)
  )
})) |>
  pivot_longer(cols = -variable, names_to = "metric", values_to = "value") |>
  mutate(section = "Descriptives",
         key = variable,
         subkey = NA_character_,
         value = as.character(round(as.numeric(value), 2))) |>
  select(section, key, subkey, metric, value)

# --------- C) CORRELATIONS ----------
cor_mat <- round(cor(df[, num_cols], use = "pairwise.complete.obs"), 3)
cor_long <- as.data.frame(as.table(cor_mat)) |>
  rename(var1 = Var1, var2 = Var2, r = Freq) |>
  mutate(section = "Correlations",
         key = var1,
         subkey = var2,
         metric = "r",
         value = as.character(r)) |>
  select(section, key, subkey, metric, value)

# --------- D) KEY GROUP MEANS ----------
by_gender <- df |>
  group_by(gender) |>
  summarise(across(all_of(num_cols), ~mean(.x, na.rm = TRUE)), .groups = "drop") |>
  mutate(group = "gender", level = gender) |>
  select(group, level, all_of(num_cols))

by_testprep <- df |>
  group_by(test_prep) |>
  summarise(across(all_of(num_cols), ~mean(.x, na.rm = TRUE)), .groups = "drop") |>
  mutate(group = "test_prep", level = test_prep) |>
  select(group, level, all_of(num_cols))

by_parent <- df |>
  group_by(parental_education) |>
  summarise(across(all_of(num_cols), ~mean(.x, na.rm = TRUE)), .groups = "drop") |>
  mutate(group = "parental_education", level = parental_education) |>
  select(group, level, all_of(num_cols))

group_means_long <- bind_rows(by_gender, by_testprep, by_parent) |>
  pivot_longer(cols = all_of(num_cols), names_to = "subject", values_to = "mean") |>
  mutate(section = "GroupMeans",
         key = paste(group, level, sep = ": "),
         subkey = subject,
         metric = "mean",
         value = as.character(round(mean, 2))) |>
  select(section, key, subkey, metric, value)

# --------- E) ONE VERTICAL MASTER TABLE ----------
one_big_table <- bind_rows(
  overview_long,
  desc_long,
  cor_long,
  group_means_long
) |>
  arrange(factor(section, levels = c("Overview","Descriptives","Correlations","GroupMeans")),
          key, subkey, metric)

# ---- Show in Console (pretty print top rows) ----
print(one_big_table, n = 50)

# ---- Open spreadsheet-style viewer in RStudio ----
if (interactive()) {
  View(one_big_table, title = "ALL EDA IN ONE TABLE")
}

# ---- (Optional) pretty table in console if knitr is installed ----
if (requireNamespace("knitr", quietly = TRUE)) {
  cat("\n--- Pretty preview (knitr::kable) ---\n")
  print(knitr::kable(head(one_big_table, 30), align = "l"))
}

# ---- (Optional) save to file: uncomment if you want later ----
# if(!dir.exists("tables")) dir.create("tables")
# readr::write_csv(one_big_table, "tables/one_big_table.csv")
