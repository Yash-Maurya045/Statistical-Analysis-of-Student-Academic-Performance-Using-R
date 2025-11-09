# ==========================================================
# STATISTICAL ANALYSIS OF STUDENT ACADEMIC PERFORMANCE
# Section 5: EDA (13 Plots, clean & attractive)
# Dataset: StudentsPerformance.csv (Kaggle)
# ==========================================================

# 0) Working directory (EDIT THIS)
setwd("your/file/path")

# 1) Packages
need <- c("readr","dplyr","janitor","ggplot2","corrplot","stringr","forcats")
to_install <- need[!(need %in% installed.packages()[,"Package"])]
if(length(to_install)) install.packages(to_install, dependencies = TRUE)

library(readr); library(dplyr); library(janitor); library(ggplot2)
library(corrplot); library(stringr); library(forcats)

# 2) Read + clean
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
  ) |>
  mutate(
    gender = factor(gender),
    test_prep = factor(test_prep, levels = c("none","completed")),
    parental_education = fct_relevel(
      as.factor(parental_education),
      "high school","some high school","some college",
      "associate's degree","bachelor's degree","master's degree"
    )
  )

num_cols <- c("math","reading","writing")

# 3) Output folder
plots_dir <- "plots"
if(!dir.exists(plots_dir)) dir.create(plots_dir)

# A tiny helper for a consistent look
nice_theme <- theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )

# ----------------------------------------------------------
# PLOTS (TOTAL = 13)
# ----------------------------------------------------------

# (1–3) Histograms (3)
for (v in num_cols) {
  p <- ggplot(df, aes(x = .data[[v]])) +
    geom_histogram(bins = 20, fill = "#6BAED6", color = "white") +
    labs(title = paste("Histogram of", str_to_title(v), "Score"),
         x = paste(str_to_title(v), "Score"), y = "Frequency") +
    nice_theme
  ggsave(file.path(plots_dir, paste0("hist_", v, ".png")), p, width = 6.5, height = 4.3, dpi = 300)
}

# (4) Overall boxplot (1)
df_long <- tidyr::pivot_longer(df, cols = all_of(num_cols), names_to = "subject", values_to = "score")
p_box_all <- ggplot(df_long, aes(x = subject, y = score, fill = subject)) +
  geom_boxplot(alpha = 0.85, color = "gray30") +
  scale_fill_brewer(palette = "Set2") +
  labs(title = "Boxplots of Scores", x = "Subject", y = "Score") +
  theme_minimal(base_size = 12) +
  theme(legend.position = "none", plot.title = element_text(face = "bold"))
ggsave(file.path(plots_dir, "boxplot_scores.png"), p_box_all, width = 6.5, height = 4.3, dpi = 300)

# (5–7) Boxplots by gender (3)
for (v in num_cols) {
  p <- ggplot(df, aes(x = gender, y = .data[[v]], fill = gender)) +
    geom_boxplot(alpha = 0.8, color = "gray30") +
    scale_fill_brewer(palette = "Pastel1") +
    labs(title = paste(str_to_title(v), "Score by Gender (Boxplot)"),
         x = "Gender", y = "Score") +
    nice_theme + theme(legend.position = "none")
  ggsave(file.path(plots_dir, paste0("box_", v, "_by_gender.png")),
         p, width = 6.5, height = 4.3, dpi = 300)
}

# (8–10) Density plots by gender (3)
for (v in num_cols) {
  p <- ggplot(df, aes(x = .data[[v]], color = gender, fill = gender)) +
    geom_density(alpha = 0.35) +
    scale_fill_brewer(palette = "Set1") +
    scale_color_brewer(palette = "Set1") +
    labs(title = paste(str_to_title(v), "Score Distribution by Gender (Density)"),
         x = paste(str_to_title(v), "Score"), y = "Density") +
    nice_theme
  ggsave(file.path(plots_dir, paste0("density_", v, "_by_gender.png")),
         p, width = 6.5, height = 4.3, dpi = 300)
}

# (11–12) Scatter plots with regression line (2)  <-- kept 2 to make total = 13
p_wr <- ggplot(df, aes(x = reading, y = writing)) +
  geom_point(alpha = 0.55, color = "#3182BD") +
  geom_smooth(method = "lm", se = FALSE, color = "#FD8D3C") +
  labs(title = "Writing vs Reading (with Linear Fit)",
       x = "Reading Score", y = "Writing Score") +
  nice_theme
ggsave(file.path(plots_dir, "scatter_writing_vs_reading.png"), p_wr, width = 6.5, height = 4.3, dpi = 300)

p_rm <- ggplot(df, aes(x = math, y = reading)) +
  geom_point(alpha = 0.55, color = "#31A354") +
  geom_smooth(method = "lm", se = FALSE, color = "#E6550D") +
  labs(title = "Reading vs Math (with Linear Fit)",
       x = "Math Score", y = "Reading Score") +
  nice_theme
ggsave(file.path(plots_dir, "scatter_reading_vs_math.png"), p_rm, width = 6.5, height = 4.3, dpi = 300)

# (13) Correlation heatmap (1)
cor_mat <- cor(df[, num_cols], use = "pairwise.complete.obs")
png(file.path(plots_dir, "corr_heatmap_scores.png"), width = 1200, height = 900, res = 200)
corrplot(cor_mat, method = "color", type = "upper", addCoef.col = "black",
         tl.col = "black", tl.srt = 45, number.cex = 0.8, col = colorRampPalette(c("#EFF3FF","#6BAED6","#08519C"))(200))
dev.off()

cat("\nAll 13 improved EDA plots saved in:", normalizePath(plots_dir), "\n")
