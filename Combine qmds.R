files <- c(
  "Chapter 4.qmd",
  "Chapter 5 Complex Anovas.qmd",
  "Between Groups.qmd",
  "Between Groups Part II.qmd"
)

text <- unlist(lapply(files, readLines))
writeLines(text, "Chapter 4 ANOVAs.qmd")