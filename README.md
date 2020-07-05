
# modelsummary <img src="https://user-images.githubusercontent.com/987057/82849698-05ba5700-9ec7-11ea-93a0-67dcd9151848.png" align="right" alt="" width="120" />

<!-- badges: start -->

[![Travis-CI Build
Status](https://travis-ci.org/vincentarelbundock/modelsummary.svg?branch=master)](https://travis-ci.org/vincentarelbundock/modelsummary)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/vincentarelbundock/modelsummary?branch=master&svg=true)](https://ci.appveyor.com/project/vincentarelbundock/modelsummary)
[![R build status](https://github.com/vincentarelbundock/modelsummary/workflows/R-CMD-check/badge.svg)](https://github.com/vincentarelbundock/modelsummary/actions)
[![Codecov test coverage](https://codecov.io/gh/vincentarelbundock/modelsummary/branch/master/graph/badge.svg)](https://codecov.io/gh/vincentarelbundock/modelsummary?branch=master)
<!-- badges: end -->

`modelsummary` creates tables and plots to summarize statistical models and data in `R`. 

The tables produced by `modelsummary` are beautiful and highly customizable. They can be echoed to the `R` console or displayed in the `RStudio` Viewer. They can be saved to a wide variety of formats, including HTML, PDF, Text/Markdown, LaTeX, MS Word, RTF, JPG, and PNG. Tables can easily be embedded in dynamic documents with `Rmarkdown`, `knitr`, or `Sweave`. `modelsummary` supports dozens of model types out-of-the-box. 

`modelsummary` includes three families of functions:

1. `modelsummary`: Display results from several statistical models side-by-side. 
2. `modelplot`: Plot model coefficients and confidence intervals.
3. `datasummary`: A flexible tool to create crosstabs and data summaries.
    - `datasummary_balance`: Balance tables with subgroup statistics and difference in means (aka "Table 1").
    - `datasummary_correlation`: Correlation tables.
    - `datasummary_skim`: Quick overview of a dataset.
    
Click on the links at the top of this page to see how these functions are used: https://vincentarelbundock.github.io/modelsummary

These tables and plots were created using `modelsummary`, without any manual editing at all:

| | |
|:-------------------------:|:-------------------------:|
|<img width="2406" src="https://user-images.githubusercontent.com/987057/82853752-90558300-9ed4-11ea-88af-12cf20cb367f.png">|<img width="2406" src="https://user-images.githubusercontent.com/987057/86512021-50839480-bdcc-11ea-893c-8c1e7a277895.png">
|<img width="2406" src="https://user-images.githubusercontent.com/987057/82855711-0a3c3b00-9eda-11ea-8a81-1eebfbb7cb73.png">|<img width="2406" src="https://user-images.githubusercontent.com/987057/85772292-b1cfa780-b6ea-11ea-8ae1-b95c6ddbf0a9.png">|
|<img width="2406" src="https://user-images.githubusercontent.com/987057/86502482-9eb77a00-bd71-11ea-80da-dc935c1fbd90.jpeg">|<img width="2406" src="https://user-images.githubusercontent.com/987057/86511490-cb967c00-bdc7-11ea-9d9b-0ef188840faf.png">


# Contents

  - [Why should I use `modelsummary`?](#why-should-i-use-modelsummary)
  - [Installation](#installation)
  - [Getting started](#getting-started)
  - [Saving and viewing: output formats](#saving-and-viewing-output-formats)
  - [modelsummary](https://vincentarelbundock.github.io/modelsummary/articles/modelsummary.html)
  - [modelplot](https://vincentarelbundock.github.io/modelsummary/articles/modelplot.html)
  - [datasummary](https://vincentarelbundock.github.io/modelsummary/articles/datasummary.html)
  - [Dynamic documents with `Rmarkdown` and `knitr`](https://vincentarelbundock.github.io/modelsummary/articles/rmarkdown.html)
  - [Adding and customizing models](https://vincentarelbundock.github.io/modelsummary/articles/newmodels.html)
  - [Multiple imputation](https://vincentarelbundock.github.io/modelsummary/articles/multiple_imputation.html)
  - [Raw data](https://vincentarelbundock.github.io/modelsummary/articles/extract.html)

# Why should I use `modelsummary`?

Here are a few benefits of `modelsummary` over some [alternative packages](#alternative-packages):

#### Easy

`modelsummary` is very easy to use. This simple call often suffices:

``` r
library(modelsummary)

mod <- lm(y ~ x, dat)
msummary(mod)
```

The command above will automatically display a summary table in the `Rstudio` Viewer or in a web browser. All you need is one word to change the output format. For example, a text-only version of the table can be printed to the Console by typing:

``` r
msummary(mod, "markdown")
```

Tables in Microsoft Word and LaTeX formats can be saved to file by typing:

``` r
msummary(mod, "table.docx")
msummary(mod, "table.tex")
```

#### Flexible

*Information*: The package offers many intuitive and powerful utilities to [customize the information](https://vincentarelbundock.github.io/modelsummary/articles/content.html) reported in a summary table. You can rename, reorder, subset or omit parameter estimates; choose the set of goodness-of-fit statistics to include; display various “robust” standard errors or confidence intervals; add titles, footnotes, or source notes; insert stars or custom characters to indicate levels of statistical significance; or add rows with supplemental information about your models.

*Appearance*: Thanks to the [`gt`](https://gt.rstudio.com), [`kableExtra`](https://haozhu233.github.io/kableExtra/), [`huxtable`](https://hughjonesd.github.io/huxtable/), and [`flextable`](https://davidgohel.github.io/flextable/) packages, the appearance of `modelsummary` tables is endlessly customizable. The [appearance customization page](https://vincentarelbundock.github.io/modelsummary/articles/appearance.html) shows tables with colored cells, weird text, spanning column labels, row groups, titles, source notes, footnotes, significance stars, and more.  This only scratches the surface of possibilities.

*Supported models*: Thanks to the [`broom` package](https://broom.tidymodels.org/), `modelsummary` supports dozens of statistical models out-of-the-box. Installing other packages can extend the capabilities further (e.g., [`broom.mixed`](https://CRAN.R-project.org/package=broom.mixed)). It is also very easy to [add or customize your own models.](https://vincentarelbundock.github.io/modelsummary/articles/newmodels.html)

*Output formats*: `modelsummary` tables can be saved to HTML, LaTeX, Text/Markdown, Microsoft Word, Powerpoint, RTF, JPG, or PNG formats.  They can also be inserted seamlessly in Rmarkdown documents to produce [automated documents and reports in PDF, HTML, RTF, or Microsoft Word formats.](https://vincentarelbundock.github.io/modelsummary/articles/rmarkdown.html)

#### Dangerous

`modelsummary` is dangerous\! It allows users to do stupid stuff like [replacing their intercepts by squirrels.](https://vincentarelbundock.github.io/modelsummary/articles/appearance.html#images)

<center>
<img src="https://user-images.githubusercontent.com/987057/82818916-7a60a780-9e6d-11ea-96ed-04fa92874a23.png" width="40%">
</center>

#### Reliable

`modelsummary` is *reliably* dangerous\! The package is developed using a [suite of unit tests](https://github.com/vincentarelbundock/modelsummary/tree/master/tests/testthat), so it (probably) won’t break.

#### Community

`modelsummary` does not try to do everything. Instead, it leverages the incredible work of the `R` community. By building on top of the `broom` package, `modelsummary` already supports dozens of model types out-of-the-box. `modelsummary` also supports four of the most popular table-building and customization packages: `gt`, `kableExtra`, `huxtable`, and `flextable`. packages. By using those packages, `modelsummary` allows users to produce beautiful, endlessly customizable tables in a wide variety of formats, including HTML, PDF, LaTeX, Markdown, and MS Word.

One benefit of this community-focused approach is that when external packages improve, `modelsummary` improves as well. Another benefit is that leveraging external packages allows `modelsummary` to have a massively simplified codebase (relative to other similar packages). This should improve long term code maintainability, and allow contributors to participate through GitHub.

# Installation

You can install `modelsummary` from CRAN:

``` r
install.packages('modelsummary')
```

If you want the very latest version, install it from Github:

``` r
library(remotes)
remotes::install_github('vincentarelbundock/modelsummary')
```

# Getting started

We begin by loading the `modelsummary` package and by downloading data
from the [RDatasets](https://vincentarelbundock.github.io/Rdatasets/)
repository:

``` r
library(modelsummary)

url <- 'https://vincentarelbundock.github.io/Rdatasets/csv/HistData/Guerry.csv'
dat <- read.csv(url) 
```

We estimate a linear model and call the `msummary` function to display
the results:

``` r
mod <- lm(Donations ~ Crime_prop, data = dat)
msummary(mod)
```

<center>

<img src="https://user-images.githubusercontent.com/987057/82819815-08895d80-9e6f-11ea-8f78-93a62df204b3.png" width="15%">

</center>

To summarize multiple models side-by-side, we store them in a list. If
the items in that list are named, the names will be used as column
labels:

``` r
models <- list()
models[['OLS 1']] <- lm(Donations ~ Literacy + Clergy, data = dat)
models[['Poisson 1']] <- glm(Donations ~ Literacy + Commerce, family = poisson, data = dat)
models[['OLS 2']] <- lm(Crime_pers ~ Literacy + Clergy, data = dat)
models[['Poisson 2']] <- glm(Crime_pers ~ Literacy + Commerce, family = poisson, data = dat)
models[['OLS 3']] <- lm(Crime_prop ~ Literacy + Clergy, data = dat)

msummary(models)
```

In `Rstudio`, the image below will be displayed automatically in the
“Viewer” window. When running `R` from a terminal or from the basic
`R` interface, this table should appear in your browser.

<center>

<img src="https://user-images.githubusercontent.com/987057/82816112-8eee7100-9e68-11ea-8bc7-30c0f2626539.png" width="40%">

</center>

The same table can be printed in text-only format to the `R` Console:

``` r
msummary(models, 'markdown')


|            |OLS 1      |Poisson 1   |OLS 2      |Poisson 2   |OLS 3      |
|:-----------|:----------|:-----------|:----------|:-----------|:----------|
|(Intercept) |7948.667   |8.241       |16259.384  |9.876       |11243.544  |
|            |(2078.276) |(0.006)     |(2611.140) |(0.003)     |(1011.240) |
|Clergy      |15.257     |            |77.148     |            |-16.376    |
|            |(25.735)   |            |(32.334)   |            |(12.522)   |
|Literacy    |-39.121    |0.003       |3.680      |-0.000      |-68.507    |
|            |(37.052)   |(0.000)     |(46.552)   |(0.000)     |(18.029)   |
|Commerce    |           |0.011       |           |0.001       |           |
|            |           |(0.000)     |           |(0.000)     |           |
|Num.Obs.    |86         |86          |86         |86          |86         |
|R2          |0.020      |            |0.065      |            |0.152      |
|Adj.R2      |-0.003     |            |0.043      |            |0.132      |
|AIC         |1740.8     |274160.8    |1780.0     |257564.4    |1616.9     |
|BIC         |1750.6     |274168.2    |1789.9     |257571.7    |1626.7     |
|Log.Lik.    |-866.392   |-137077.401 |-886.021   |-128779.186 |-804.441   |
```

# Saving and viewing: output formats

There are four ways to display and save `modelsummary` tables.

1. Display in the R Console, the RStudio Viewer, or a web browser.
2. Save a table to file.
3. Insert a [table in `Rmarkdown` or `knitr` documents](https://vincentarelbundock.github.io/modelsummary/articles/rmarkdown.html),
4. Convert the table to human-readable html, latex, or markdown code.

To display, simply choose the output format. For example,

```{r}
msummary(models, output = 'latex')
msummary(models, output = 'markdown')
msummary(models, output = 'gt')
msummary(models, output = 'kableExtra')
msummary(models, output = 'flextable')
```

To save a table, choose the file path with the extension you want. For example,

```{r}
msummary(models, output = 'table.tex')
msummary(models, output = 'table.docx')
msummary(models, output = 'table.html')
msummary(models, output = 'table.md')
```

To customize a table with the `gt`, `kableExtra`, `flextable`, or `huxtable` packages, choose the output format. Then, you can use functions from those packages to modify the resulting objects:

```{r}
library(kableExtra)

tab <- msummary(models, output = 'kableExtra')
tab %>% row_spec(3, bold = TRUE, color = 'green')
```

`modelsummary` uses sensible defaults to choose an appopriate table-making package for each output format (`gt`, `kableExtra`, `flextable`, or `huxtable`). This table summarizes how to modify `modelsummary`'s `output` argument to display and save tables: 

<center><img src="https://user-images.githubusercontent.com/987057/83556122-5a6c5c00-a4dd-11ea-905d-b04f633c9844.png" width="50%"></center>

In the above table, checkmarks identify the default table-making package used for each output format. Dots identify supported alternatives. To use those alternatives, we set global options such as:

```r
options(modelsummary_html = 'kableExtra')
options(modelsummary_latex = 'gt')
options(modelsummary_word = 'huxtable')
options(modelsummary_png = 'gt')
```

# Alternative packages

There are several excellent alternatives to draw model summary tables in `R`:

  - [texreg](https://cran.r-project.org/package=texreg)
  - [stargazer](https://cran.r-project.org/package=stargazer)
  - [apsrtable](https://cran.r-project.org/package=apsrtable)
