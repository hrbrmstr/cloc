setNames <- function(object = nm, nm)  {
  names(object) <- nm
  object
}

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

is_rmd_file <- function(path) { grepl("\\.Rmd$", path, ignore.case = TRUE) }
