#' Count lines of code, comments and whitespace in source files/archives
#'
#' @param source thing to extract from
#' @param extract_with thing
#' @return \code{tbl_df}
#' @export
cloc <- function(source, extract_with=NULL) {

  is_url <- isUrl(source)

  if (is_url) {
    dir <- tempdir()
    download.file(source, file.path(dir, basename(source)), method="curl")
    source <- file.path(dir, basename(source))
  }

  stopifnot(file.exists(source))

  cmd <- sprintf("perl %s --quiet --csv %s",
                 system.file("bin/cloc.pl", package="cloc"),
                 source)

  if (!is.null(extract_with)) cmd <- sprintf('%s --extract-with="%s"', cmd, extract_with)

  dat <- system(cmd, intern=TRUE)

  fil <- read.table(text=paste(tail(dat, -2), sep="", collapse="\n"),
                    col.names=c("file_count", "language", "blank_lines",
                                "comment_lines", "loc"),
                    sep=",", stringsAsFactors=FALSE)

  if (is_url) unlink(source)

  # calculate percentages

  fil$source <- basename(source)
  fil$file_count_pct <- fil$file_count / sum(fil$file_count)
  fil$blank_line_pct <- fil$blank_lines / sum(fil$blank_lines)
  fil$comment_line_pct <- fil$comment_lines / sum(fil$comment_lines)
  fil$loc_pct <- fil$loc / sum(fil$loc)

  tbl_df(fil[, c("source", "language",
                 "file_count", "file_count_pct",
                 "loc", "loc_pct",
                 "blank_lines", "blank_line_pct",
                 "comment_lines", "comment_line_pct")])

}

#' Count lines of code (etc) from source packages on CRAN
#'
#' @param pkgs names of pkgs
#' @param repos repos
#' @param contriburl
#' @return \code{tbl_df}
#' @export
cloc_cran <- function(pkgs,
                      repos = getOption("repos"),
                      contriburl = contrib.url(repos, "source")) {

  destdir <- tempfile()
  dir.create(destdir)

  res_p <- as.data.frame(download.packages(pkgs, destdir, repos=repos,
                                         contriburl=contriburl, type="source"),
                       stringsAsFactors=FALSE)

  res <- bind_rows(pblapply(res_p$V2, function(x) {
    ret <- cloc(x)
    ret$pkg <- res_p[res_p$V2==x,]$V1
    ret
  }))

  unlink(destdir, recursive=TRUE)

  res

}
