source("helpers.R")

requiet("gt")
requiet("magrittr")
using("tinysnapshot")

models <- list()
models[["OLS 1"]] <- lm(hp ~ mpg + wt, mtcars)
models[["Poisson 1"]] <- glm(hp ~ mpg + drat, mtcars, family = poisson())
models[["OLS 2"]] <- lm(vs ~ hp + wt, mtcars)
models[["Logit 1"]] <- glm(vs ~ hp + drat, mtcars, family = binomial())
models[["Logit 2"]] <- glm(am ~ hp + disp, mtcars, family = binomial())

# gof_omit='.*' used to produce an error
mod <- lm(mpg ~ wt, mtcars)
tab <- modelsummary(mod, output = "gt", gof_omit = ".*")
expect_inherits(tab, "gt_tbl")

# complex html table
cm <- c(
  "hp" = "Horsepower",
  "mpg" = "Miles/Gallon",
  "wt" = "Weight",
  "drat" = "Rear axle ratio",
  "disp" = "Displacement",
  "(Intercept)" = "Constant"
)

# not sure why gt produces a warning here
raw <-
  modelsummary(
    models,
    output = "gt",
    coef_map = cm,
    stars = TRUE,
    gof_omit = "Statistics|^p$|Deviance|Resid|Sigma|Log.Lik|^DF$",
    notes = c(
      "First custom note to contain text.",
      "Second custom note with different content."
    )
  ) %>%
  gt::tab_spanner(label = "Horsepower", columns = c(`OLS 1`, `Poisson 1`)) %>%
  gt::tab_spanner(label = "V-Shape", columns = c(`OLS 2`, `Logit 1`)) %>%
  gt::tab_spanner(label = "Transmission", columns = `Logit 2`) %>%
  gt::tab_header(
    title = "Summarizing 5 statistical models using the `modelsummary` package for `R`.",
    subtitle = "Models estimated using the mtcars dataset."
  )
suppressWarnings(expect_snapshot_print(print_html(raw), "gt-complex.html"))

# title
raw <- modelsummary(
  models,
  output = "gt",
  title = "This is a title for my table."
)
suppressWarnings(expect_snapshot_print(print_html(raw), "gt-title.html"))

# background color
raw <- modelsummary(models, output = "gt", title = "colors") %>%
  tab_style(
    style = cell_text(weight = "bold"),
    locations = cells_body(columns = c(`OLS 1`))
  ) %>%
  tab_style(
    style = cell_text(style = "italic"),
    locations = cells_body(columns = c(`Poisson 1`), rows = 2:6)
  ) %>%
  tab_style(
    style = cell_fill(color = "lightcyan"),
    locations = cells_body(columns = c(`OLS 1`))
  ) %>%
  tab_style(
    style = cell_fill(color = "#F9E3D6"),
    locations = cells_body(columns = c(`Logit 2`), rows = 2:6)
  )
suppressWarnings(expect_snapshot_print(
  print_html(raw),
  "gt-background_color.html"
))
