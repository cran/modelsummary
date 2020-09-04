# modelsummary 0.6.1

* bug fixes

# modelsummary 0.6.0

* default HTML output factory is now kableExtra
* interaction ":" gsubbed by "\u00d7"
* dependencies: removed 1 depends, 3 imports, and 3 suggests
* word_document knitr works out-of-the-box
* bug fixes

# modelsummary 0.5.1

* glance_custom.fixest ships with modelsummary

# modelsummary 0.5.0

* datasummary
* datasummary_skim
* datasummary_balance
* datasummary_correlation
* modelplot
* allow duplicate model names
* bug: can't use coef_map with multiple statistics (thanks @sbw78)
* bug: wrong number of stars w/ statistic='p.value' (thanks @torfason)
* output='data.frame'. `extract` is no longer documented.

# modelsummary 0.4.1

* add_rows now accepts a data.frame with "position" and "section" columns
* add_rows_location is deprecated
* bug in sanity_output prevented overwriting files

# modelsummary 0.4.0

* huxtable support
* flextable support
* estimate argument
* fixest tidiers
* website and vignette improvements
* gof_map additions
* glance_custom
* tidy_custom

# modelsummary 0.3.0

* Out-of-the-box Rmarkdown compilation to HTML, PDF, RTF
* kableExtra output format for LaTeX and Markdown
* Support for `threeparttable`, colors, and many other LaTeX options
* Deprecated arguments: filename, subtitle
* Deprecated functions: clean_latex, knit_latex
* `pkgdown` website and doc improvements
* `mitools` tidiers
* New tests

# modelsummary 0.2.1

* Convenience function to render markdown in row/column labels
* bug: breakage when all GOF were omitted
* Clean up manual with @keywords internal
* bug: tidyr import

# modelsummary 0.2.0

* gt is now available on CRAN
* new latex_env argument for knit_latex and clean_latex
* bug when all gof omitted
* bug in statistic_override with functions
* bug caused by upstream changes in tab_style
* bug caused by upstream changes in filename='rtf'
* Allow multiple rows of uncertainty estimates per coefficient
* Preserve add_rows order
* Display uncertainty estimates next to the coefficient with statistic_vertical = FALSE
* Better clean_latex function
* Can display R2 and confidence intervals for mice-imputed lm-models
* Internal functions have @keywords internal to avoid inclusion in docs
* Statistic override accepts pre-formated character vectors

# modelsummary 0.1.0

* Initial release (gt still needs to be installed from github)
