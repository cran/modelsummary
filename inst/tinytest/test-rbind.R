source("helpers.R")
requiet("fixest")
requiet("tinysnapshot")
using("tinysnapshot")
fixest::setFixest_nthreads(1)

panels <- list(
  "Panel A: MPG" = list(
    "A" = lm(mpg ~ hp, data = mtcars),
    "B" = lm(mpg ~ hp + factor(gear), data = mtcars)
  ),
  "Panel B: Displacement" = list(
    "A" = lm(disp ~ hp, data = mtcars),
    "C" = lm(disp ~ hp + factor(gear), data = mtcars)
  )
)

# (non-)matching models
panels <- list(
  "Panel A: MPG" = list(
    lm(mpg ~ hp, data = mtcars),
    lm(mpg ~ hp + factor(gear), data = mtcars)
  ),
  "Panel B: Displacement" = list(
    lm(disp ~ hp, data = mtcars),
    lm(disp ~ hp + factor(gear), data = mtcars)
  )
)
tab1 <- modelsummary(
  panels,
  gof_map = "nobs",
  output = "dataframe",
  shape = "rbind"
)
expect_equivalent(colnames(tab1), c(" ", "(1)", "(2)"))

panels <- list(
  "Panel A: MPG" = list(
    "A" = lm(mpg ~ hp, data = mtcars),
    "B" = lm(mpg ~ hp + factor(gear), data = mtcars)
  ),
  "Panel B: Displacement" = list(
    "A" = lm(disp ~ hp, data = mtcars),
    "C" = lm(disp ~ hp + factor(gear), data = mtcars)
  )
)
tab2 <- modelsummary(
  panels,
  gof_map = "nobs",
  output = "dataframe",
  shape = "rbind"
)
expect_equivalent(colnames(tab2), c(" ", "A", "B", "C"))

# stars note
p <- suppressWarnings(modelsummary(
  panels,
  output = "markdown",
  stars = TRUE,
  shape = "rbind"
))
expect_true(any(grepl("p < 0.1", p, fixed = TRUE)))

# output formats: no validity
p <- modelsummary(panels, output = "gt", shape = "rbind")
expect_inherits(p, "gt_tbl")
p <- modelsummary(panels, output = "latex", shape = "rbind")
expect_inherits(p, "tinytable")
p <- modelsummary(panels, output = "tinytable", shape = "rbind")
expect_inherits(p, "tinytable")

# Issue #593: rbind vs rcollapse
panels <- list(
  list(
    lm(mpg ~ hp, data = mtcars),
    lm(mpg ~ hp + am, data = mtcars)
  ),
  list(
    lm(qsec ~ hp, data = mtcars),
    lm(qsec ~ hp + am, data = mtcars)
  )
)
tab1 <- modelsummary(
  panels,
  shape = "rbind",
  gof_map = "nobs",
  output = "dataframe"
)
tab2 <- modelsummary(
  panels,
  shape = "rcollapse",
  gof_map = "nobs",
  output = "dataframe"
)
expect_true(nrow(tab1) == nrow(tab2) + 1)

# Issue #593: models with different FEs do not get collapsed
panels <- list(
  list(
    feols(mpg ~ cyl | gear, data = mtcars, cluster = ~hp),
    feols(
      mpg ~ cyl | gear + am,
      data = subset(mtcars, mpg > 20),
      cluster = ~hp
    )
  ),
  list(
    feols(disp ~ cyl | gear, data = mtcars, cluster = ~hp),
    feols(disp ~ cyl | gear + carb, data = mtcars, cluster = ~hp)
  )
)
tab <- modelsummary(panels, shape = "rcollapse", output = "dataframe")
expect_equivalent(sum(tab[[1]] == "FE: gear"), 2)

# Issue #593: models with identical FEs get collapsed
panels <- list(
  list(
    feols(mpg ~ cyl | gear, data = mtcars, cluster = ~hp),
    feols(
      mpg ~ cyl | gear + carb,
      data = subset(mtcars, mpg > 20),
      cluster = ~hp
    )
  ),
  list(
    feols(disp ~ cyl | gear, data = mtcars, cluster = ~hp),
    feols(disp ~ cyl | gear + carb, data = mtcars, cluster = ~hp)
  )
)
tab <- modelsummary(panels, shape = "rcollapse", output = "dataframe")
expect_equivalent(sum(tab[[1]] == "FE: gear"), 1)


# Issue #620
models <- list(
  mpg = lm(mpg ~ cyl + disp, mtcars),
  hp = lm(hp ~ cyl + disp, mtcars)
)
tab <- modelsummary(
  models,
  output = "data.frame",
  statistic = NULL,
  estimate = "{estimate}{stars} [{conf.low}, {conf.high}] ",
  shape = "rcollapse",
  gof_map = c("nobs", "r.squared")
)
expect_equivalent(nrow(tab), 9)

# Issue #626: shape="rbind" does not respect with add_rows
rows <- tibble::tribble(
  ~term,
  ~OLS,
  ~Logit,
  "Info",
  "???",
  "XYZ"
)
attr(rows, "position") <- c(6)
gm <- c("r.squared", "nobs", "rmse")
panels <- list(
  "Panel A" = list(
    lm(mpg ~ 1, data = mtcars),
    lm(mpg ~ qsec, data = mtcars)
  ),
  "Panel B" = list(
    lm(hp ~ 1, data = mtcars),
    lm(hp ~ qsec, data = mtcars)
  )
)

expect_snapshot_print(
  modelsummary(
    panels,
    fmt = 2, # tolerance
    output = "markdown",
    shape = "rbind",
    gof_map = gm,
    add_rows = rows
  ),
  "rbind-add_rows_rbind"
)


# Issue #725: Headers are not printed if shape = "rbind" is used
gm <- c("r.squared", "nobs", "rmse")
panels <- list(
  "Panel A" = list(
    lm(mpg ~ 1, data = mtcars),
    lm(mpg ~ qsec, data = mtcars)
  ),
  "Panel B" = list(
    lm(hp ~ 1, data = mtcars),
    lm(hp ~ qsec, data = mtcars)
  )
)
tab <- modelsummary(
  panels,
  output = "markdown",
  shape = "rbind",
  gof_map = gm
)
expect_snapshot_print(tab, "rbind-issue725_tinytable_hgroup")


# Issue #849: remove panel rows
requiet("marginaleffects")
mod <- lm(mpg ~ factor(cyl) * disp, mtcars)
fins <- list(
  hypotheses(mod, "`factor(cyl)6`+`factor(cyl)6:disp`=0"),
  hypotheses(mod, "`factor(cyl)8`+`factor(cyl)8:disp`=0")
)
tab <- modelsummary(
  fins,
  stars = TRUE,
  gof_omit = ".*",
  shape = "rbind",
  output = "markdown"
)
expect_snapshot_print(tab, "rbind-issue849_without_panel_names")

mod <- lm(mpg ~ factor(cyl) * disp, mtcars)
fins <- list(
  a = hypotheses(mod, "`factor(cyl)6`+`factor(cyl)6:disp`=0"),
  b = hypotheses(mod, "`factor(cyl)8`+`factor(cyl)8:disp`=0")
)
tab <- modelsummary(
  fins,
  stars = TRUE,
  gof_omit = ".*",
  shape = "rbind",
  output = "markdown"
)
expect_snapshot_print(tab, "rbind-issue849_with_panel_names")


rm(list = ls())
