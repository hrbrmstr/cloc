#' Count lines of code (etc) from source packages on CRAN
#'
#' @md
#' @param pkgs names of packages
#' @param repos character vector, the base URL(s) of the repositories to use,
#'        i.e., the URL of the CRAN master such as "`https://cran.r-project.org`"
#'        or its Statlib mirror, "`http://lib.stat.cmu.edu/R/CRAN`".
#' @param contrib_url URL(s) of the contrib sections of the repositories. Use
#'        this argument only if your repository mirror is incomplete, e.g.,
#'        because you burned only the ‘contrib’ section on a CD. Overrides
#'        argument repos.
#' @param .progress show a progress bar? Default: `TRUE` if running interactively.
#' @return tibble
#' @export
#' @examples
#' # requires a network connection therefore is set for you to run it manually
#' \dontrun{
#' cloc_cran(c("archdata", "hrbrthemes", "iptools", "dplyr"))
#' }
cloc_cran <- function(pkgs,
                      repos = getOption("repos"),
                      contrib_url = utils::contrib.url(repos, "source"),
                      .progress = interactive()) {

  destdir <- tempfile()
  dir.create(destdir)
  on.exit(unlink(destdir, recursive = TRUE), add = TRUE)

  # retrieve the package archive
  as.data.frame(
    utils::download.packages(
      pkgs, destdir, repos = repos, contriburl = contrib_url, type = "source"
    ),
    stringsAsFactors = FALSE
  ) -> res_p

  #
  if (.progress) pb <- dplyr::progress_estimated(length(res_p$V2))
  dplyr::bind_rows(
    lapply(res_p$V2, function(x) {
      if (.progress) pb$tick()$print()
      ret <- cloc(x)
      if (nrow(ret) > 0) ret$pkg <- res_p[res_p$V2 == x, ]$V1
      ret
    })
  ) -> res

  res

}
