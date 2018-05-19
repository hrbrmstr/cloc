#' @keywords internal
cloc_pkg_addin <- function() {

  ctx <- rstudioapi::getActiveDocumentContext()

  if (!is.null(ctx)) {

    pkg_root <- rprojroot::find_package_root_file(path = ".")

    res <- cloc::cloc_pkg(pkg_root)
    res <- res[,-1] # we know what pkg we're in

    DT::datatable(
      data = res,
      options = list(pageLength = 20),
      colnames = c(
        "Lang",
        "# Files", "(%)",
        "LoC", "(%)",
        "Blank lines", "(%)",
        "# Lines", "(%)"
      ),
      caption = sprintf("Code Metrics For %s", basename(pkg_root)),
      style = "default"
    ) -> cloc_dt

    cloc_dt <- DT::formatPercentage(cloc_dt, 'file_count_pct', 2)
    cloc_dt <- DT::formatPercentage(cloc_dt, 'loc_pct', 2)
    cloc_dt <- DT::formatPercentage(cloc_dt, 'blank_line_pct', 2)
    cloc_dt <- DT::formatPercentage(cloc_dt, 'comment_line_pct', 2)

    htmltools::html_print(cloc_dt)

    print(res)

  }

}

