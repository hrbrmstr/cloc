#' Strip comments and white space from a single source file
#'
#' Pass in a path to a source file and retrieve a version of the source file
#' without comments (or white space).
#'
#' @md
#' @param source_file path to source file
#' @export
#' @examples
#' cloc_remove_comments(system.file("extdata", "qrencoder.cpp", package="cloc"))
cloc_remove_comments <- function(source_file) {

  perl <- Sys.which("perl")

  if (perl == "") {
    stop(
      "Cannot find 'perl'. cloc requires perl to be installed and on the PATH.",
       call. = FALSE
      )
  }

  tis_url <- is_url(source_file)

  if (tis_url) { # download the source_file if a URL was specified
    dir <- tempdir()
    utils::download.file(source_file, file.path(dir, basename(source_file)), method = "curl", quiet = TRUE)
    source_file <- file.path(dir, basename(source_file))
    on.exit(unlink(source_file), add = TRUE)
  }

  source_file <- path.expand(source_file)

  stopifnot(file.exists(source_file))

  # make the command line

  sprintf(
    "%s %s --strip-comments=nc %s",
    perl,
    system.file("bin/cloc.pl", package = "cloc"),
    source_file
  ) -> cmd

  td <- tempdir()
  curr_dir <- getwd()
  on.exit(setwd(curr_dir))

  setwd(td)

  dat <- system(cmd, intern = TRUE)

  lines <- paste0(readLines(sprintf("%s.nc", basename(source_file))), collapse="\n")

  unlink(sprintf("%s.nc", basename(source_file))) # clean up

  return(lines)

}
