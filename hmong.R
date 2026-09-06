library(dplyr)
library(tidyr)
library(gt)

brokering_df<-readRDS("brokering_df")

set.seed(123)

# Select 10 cases per group with non-missing AAFCS scores
toy_brokering <- brokering_df %>%
  filter(
    !is.na(brok_three),
    !is.na(aafcs)
  ) %>%
  group_by(brok_three) %>%
  slice_sample(n = 10) %>%
  ungroup()

# Verify sample sizes
table(toy_brokering$brok_three)

# Create wide table for ANOVA demonstration
demo_table <- toy_brokering %>%
  select(brok_three, aafcs) %>%
  group_by(brok_three) %>%
  mutate(row = row_number()) %>%
  pivot_wider(
    id_cols = row,
    names_from = brok_three,
    values_from = aafcs
  ) %>%
  arrange(row) %>%
  select(Low, Medium, High)

# Add means row
demo_table <- bind_rows(
  demo_table,
  data.frame(
    Low = mean(demo_table$Low),
    Medium = mean(demo_table$Medium),
    High = mean(demo_table$High)
  )
)

# Add row labels
demo_table <- demo_table %>%
  mutate(Case = c(as.character(1:10), "Mean")) %>%
  select(Case, Low, Medium, High)

# Pretty table
demo_table %>%
  gt(rowname_col = "Case") %>%
  fmt_number(
    columns = c(Low, Medium, High),
    decimals = 2
  ) %>%
  tab_header(
    title = "AAFCS Scores by Brokering Group"
  ) %>%
  cols_label(
    Low = "Low",
    Medium = "Medium",
    High = "High"
  )
