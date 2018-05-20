#' Run [cloc_pkg()] on active package and format it as a markdown table for knitting into reports
#'
#' @md
#' @note Target application is output to Rmd files
#' @export
cloc_pkg_md <- function() {

  pkg_root <- rprojroot::find_package_root_file(path = ".")

  as.data.frame(
    read.dcf(file.path(pkg_root, "DESCRIPTION")),
    stringsAsFactors=FALSE
  )$Package[1] -> pkg_name

  knitr::kable(
    setNames(
      cloc::cloc_pkg()[,-1],
      c(
        "Lang",
        "# Files", "(%)",
        "LoC", "(%)",
        "Blank lines", "(%)",
        "# Lines", "(%)"
      )
    ),
    format = "markdown",
    digits = 2,
    caption = sprintf("clock Package Metrics for %s", pkg_name)
  )

}
