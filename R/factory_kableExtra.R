#' Internal function to build table with `kableExtra`
#'
#' @inheritParams factory_gt
#' @noRd
#' @return kableExtra object
factory_kableExtra <- function(
  tab,
  align = NULL,
  hrule = NULL,
  hgroup = NULL,
  hindent = FALSE,
  notes = NULL,
  title = NULL,
  escape = TRUE,
  output_format = "kableExtra",
  output_file = NULL,
  ...
) {
  insight::check_if_installed("kableExtra")

  span_list <- get_span_kableExtra(tab)

  # escape
  if (
    isTRUE(escape) && isTRUE(output_format %in% c("latex", "html", "typst"))
  ) {
    # escape ourselves rather than use the kableExtra escaping
    escape <- FALSE

    tmp <- escape_everything(
      tab = tab,
      output_format = output_format,
      span_list = span_list,
      title = title,
      notes = notes
    )
    tab <- tmp$tab
    title <- tmp$title
    notes <- tmp$notes
    span_list <- tmp$span_list
  }

  # new variable "kable_format" because "kableExtra" and "html" both produce
  # html, but we need to distinguish the two.
  if (output_format %in% c("latex", "latex_tabular")) {
    kable_format <- "latex"
  } else if (identical(output_format, "markdown")) {
    kable_format <- "markdown"
  } else {
    kable_format <- "html"
  }

  ## don't print row.names
  row.names(tab) <- NULL

  # kbl arguments
  valid <- c(
    "x",
    "align",
    "caption",
    "format",
    "booktabs",
    "linesep",
    "format.args",
    "escape",
    "table.attr",
    "longtable",
    "valign",
    "position",
    "centering",
    "vline",
    "toprule",
    "bottomrule",
    "midrule",
    "caption.short",
    "table.envir",
    "col.names"
  )

  arguments <- c(
    list(...),
    "caption" = title,
    "format" = kable_format,
    "booktabs" = TRUE,
    "escape" = escape,
    "linesep" = "",
    "row.names" = NULL
  )

  extra_siunitx <- "
    \\newcolumntype{d}{S[
      table-align-text-before=false,
      table-align-text-after=false,
      input-symbols={-,\\*+()}
    ]}
  "

  if (
    output_format %in%
      c("latex", "latex_tabular") &&
      settings_equal("format_numeric_latex", "siunitx")
  ) {
    invisible(knitr::knit_meta_add(list(
      rmarkdown::latex_dependency("booktabs")
    )))
    invisible(knitr::knit_meta_add(list(
      rmarkdown::latex_dependency("siunitx", extra_lines = extra_siunitx)
    )))
  }

  ## align
  if (!is.null(align)) {
    for (i in seq_along(align)) {
      if (align[i] == "d") {
        if (output_format %in% c("latex", "latex_tabular")) {
          ## protect strings from siunitx
          tab[[i]] <- ifelse(
            !grepl("[0-9]", tab[[i]]),
            sprintf("{%s}", tab[[i]]),
            tab[[i]]
          )
        } else {
          tab[[i]] <- ifelse(
            grepl("[0-9]", tab[[i]]),
            sprintf("$%s$", tab[[i]]),
            tab[[i]]
          )
        }
      }
    }
    if (any(grepl("d", align))) {
      ## protect column labels
      colnames(tab)[align == "d"] <- sprintf(
        "{%s}",
        colnames(tab)[align == "d"]
      )
    }
    arguments[["align"]] <- align
  }

  # Issue #669: <0.001 gets printed as a tag in HTML
  if (output_format %in% c("kableExtra", "html")) {
    for (i in seq_along(tab)) {
      idx <- grepl("<[^>]*$", tab[[i]]) | grepl("^[^<]*>", tab[[i]])
      # Brackets are not matching, perform substitution
      tab[[i]][idx] <- gsub("<", "&lt;", tab[[i]][idx])
      tab[[i]][idx] <- gsub(">", "&gt;", tab[[i]][idx])
    }
  }

  # kableExtra sometimes converts (1), (2) to list items, which breaks formatting
  # insert think white non-breaking space
  if (output_format %in% c("html", "kableExtra")) {
    regex <- paste0(
      paste(1:12, collapse = "|"),
      "|",
      paste(utils::as.roman(1:12), collapse = "|")
    )
    regex <- paste0("^\\(", regex, "\\)$")
    idx <- grepl(regex, colnames(tab))
    colnames(tab)[idx] <- paste0("&nbsp;", colnames(tab)[idx])
  }

  # issue #761: only matters for shape
  colnames(tab) <- gsub(".*\\|\\|\\|\\|", "", colnames(tab))

  # create tables with combined arguments
  arguments <- arguments[base::intersect(names(arguments), valid)]
  arguments <- c(list(tab), arguments)
  out <- do.call(kableExtra::kbl, arguments)

  ## footnote arguments
  valid <- c(
    "footnote_as_chunk",
    "escape",
    "threeparttable",
    "fixed_small_size",
    "symbol_manual",
    "title_format"
  )
  arguments <- list(...)
  arguments <- arguments[base::intersect(names(arguments), valid)]

  ## kableExtra::footnote bug when adding multiple notes with threeparttable in LaTeX
  ## combine notes
  if (
    identical(output_format, "latex") &&
      !is.null(notes) &&
      length(notes) > 1 &&
      "threeparttable" %in% names(arguments) &&
      isTRUE(arguments[["threeparttable"]])
  ) {
    notes <- paste(notes, collapse = " ")
  }

  ## user-supplied notes at the bottom of table
  if (!is.null(notes)) {
    ## kableExtra::footnote does not support markdown
    ## kableExtra::add_footnote does not support longtable
    if (output_format %in% c("kableExtra", "html", "latex")) {
      if (
        isTRUE(kable_format == "latex") &&
          any(grepl(" < ", notes)) &&
          !isTRUE(escape)
      ) {
        notes <- gsub(" < ", " $<$ ", notes)
        arguments[["escape"]] <- FALSE
      }
      ## threeparttable only works with 1 note. But it creates a weird bug
      ## when using coef_map and stars in Rmarkdown PDF output
      arguments[["general"]] <- notes
      arguments[["general_title"]] <- ""
      arguments[["kable_input"]] <- out

      # Issue #855: When output="kableExtra", we do not know the ultimate output format,
      # so we must rely on kableExtra's escaping for notes.
      if (identical(output_format, "kableExtra")) {
        arguments[["escape"]] <- escape
      }

      if (isTRUE(any(nchar(arguments$general) > 0))) {
        out <- do.call(kableExtra::footnote, arguments)
      }
    } else if (identical(output_format, "markdown")) {
      for (n in notes) {
        out <- kableExtra::add_footnote(
          out,
          label = n,
          notation = "none",
          escape = FALSE
        )
      }
    }
  }

  # theme
  theme_ms <- getOption(
    "modelsummary_theme_kableExtra",
    default = theme_ms_kableExtra
  )
  out <- theme_ms(
    out,
    output_format = output_format,
    hrule = hrule,
    hgroup = hgroup,
    hindent = hindent,
    ...
  )

  # span: apply (not supported in markdown)
  if (
    !is.null(span_list) && output_format %in% c("kableExtra", "latex", "html")
  ) {
    for (i in 1:length(span_list)) {
      sp <- span_list[[i]]
      names(span_list[[i]]) <- gsub("&nbsp;", " ", names(span_list[[i]]))
      out <- kableExtra::add_header_above(out, span_list[[i]], escape = escape)
    }
  }

  # html & latex get a new class to use print.modelsummary_string
  if (output_format %in% c("latex", "latex_tabular", "html")) {
    class(out) <- c("modelsummary_string", class(out))
  }

  # output
  if (is.null(output_file)) {
    return(out)
  } else {
    if (identical(output_format, "markdown")) {
      writeLines(paste(out, collapse = "\n"), con = output_file)
    } else {
      kableExtra::save_kable(out, file = output_file)
    }
  }
}
