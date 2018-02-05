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

  dat <- system(cmd, intern = TRUE)

  lines <- paste0(readLines(sprintf("%s.nc", basename(source_file))), collapse="\n")

  return(lines)

}
