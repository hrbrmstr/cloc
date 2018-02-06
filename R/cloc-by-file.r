#' Count lines of code, comments and whitespace in source files/archives by file
#'
#' @md
#' @param source file, directory or archive to read from (can be a valid URL)
#' @param extract_with passed into `cloc` command line. This option is only
#'        needed if cloc is unable to figure out how to extract the contents of
#'        the input file(s) by itself.
#' @return tibble
#' @note Unlike it's `cloc()` counterpart, no percentages are reported by this function
#' @export
#' @examples
#' # whole dir
#' str(cloc_by_file(system.file("extdata", package="cloc")))
#'
#' # single file
#' str(cloc_by_file(system.file("extdata", "App.java", package="cloc")))
cloc_by_file <- function(source, extract_with=NULL) {

  perl <- Sys.which("perl")

  if (perl == "") {
    stop(
      "Cannot find 'perl'. cloc requires perl to be installed and on the PATH.",
       call. = FALSE
      )
  }

  is_url <- R.utils::isUrl(source)

  if (is_url) { # download the source if a URL was specified
    dir <- tempdir()
    utils::download.file(source, file.path(dir, basename(source)), method = "curl", quiet = TRUE)
    source <- file.path(dir, basename(source))
    on.exit(unlink(source), add = TRUE)
  }

  source <- path.expand(source)

  stopifnot(file.exists(source))

  # make the command line

  sprintf(
    "%s %s --quiet --by-file --csv %s",
    perl,
    system.file("bin/cloc.pl", package = "cloc"),
    source
  ) -> cmd

  # tack on the "--extract-with" value (if specified)
  if (!is.null(extract_with)) cmd <- sprintf('%s --extract-with="%s"', cmd, extract_with)

  # run the perl script
  dat <- system(cmd, intern = TRUE)

  # nothing to count
  if (length(dat) == 0) {
    return(
      data.frame(
        source = basename(source),
        language = NA_character_,
        filename = NA_character_,
        loc = 0,
        blank_lines = 0,
        comment_lines = 0,
        stringsAsFactors = FALSE
      )
    )
  }

  # read in the output from the perl script
  fil <- read.table(
    text = paste(utils::tail(dat, -2), sep = "", collapse = "\n"),
    col.names = c("language", "filename", "blank_lines", "comment_lines", "loc"),
    sep = ",", comment.char = "", stringsAsFactors = FALSE
  )

  fil$source <- basename(source)

  # reorganize columns
  fil <- fil[, c("source", "filename", "language", "loc", "blank_lines", "comment_lines")]

  class(fil) <- c("tbl_df", "tbl", "data.frame")

  fil

}
