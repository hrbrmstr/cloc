# nolint start

#' Strip comments and white space from a single source file
#'
#' Pass in a path to a source file and retrieve a version of the source file
#' without comments (or white space).
#'
#' @md
#' @param source_file path to source file
#' @export
#' @return character vector containing only code blocks
#' @examples
#' cloc_remove_comments(system.file("extdata", "qrencoder.cpp", package="cloc"))
cloc_remove_comments <- function(source_file) {

  perl <- find_perl()

  tis_url <- is_url(source_file)

  if (tis_url) { # download the source_file if a URL was specified
    tdir <- tempdir()
    utils::download.file(source_file, file.path(tdir, basename(source_file)), method = "curl", quiet = TRUE)
    source_file <- file.path(tdir, basename(source_file))
    on.exit(unlink(source_file), add = TRUE)
  }

  source_file <- path.expand(source_file)

  stopifnot(file.exists(source_file))

  # make the command line
  # sprintf(
  #   "%s %s --strip-comments=nc %s",
  #   perl,
  #   shQuote(system.file("bin/cloc.pl", package = "cloc")),
  #   source_file
  # ) -> cmd

  td <- tempdir()
  curr_dir <- getwd()
  on.exit(setwd(curr_dir))

  setwd(td)

  c(
    system.file("bin/cloc.pl", package = "cloc"),
    "--strip-comments=nc",
    source_file
  ) -> args

  processx::run(
    command = perl,
    args = args
  ) -> res

  dat <- res$stdout

  # dat <- system(cmd, intern = TRUE)

  paste0(
    readLines(
      sprintf("%s.nc", basename(source_file)),
      warn = FALSE
    ),
    collapse = "\n"
  ) -> lines

  unlink(sprintf("%s.nc", basename(source_file))) # clean up

  return(lines)

}

# nolint end