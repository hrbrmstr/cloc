is_url <- function (path) { grepl("^(git|http|ftp)s?://", path) }

find_perl <- function() {
  perl <- Sys.which("perl")

  if (perl == "") {
    stop(
      "Cannot find 'perl'. cloc requires perl to be installed and on the PATH.",
      call. = FALSE
    )
  }

  return(perl)

}