# nolint start

#' Count lines of code, comments and whitespace in a package
#'
#' Think of this as [cloc()] with saner defaults for packages. Skips common
#' IDE tempdirs, `.git`, `inst`, `man`.
#'
#' @md
#' @param source file, directory or archive to read from (can be a valid URL)
#' @param extract_with passed into `cloc` command line. This option is only
#'        needed if cloc is unable to figure out how to extract the contents of
#'        the input file(s) by itself.
#' @return data frame (tibble)
#' @export
#' @examples
#' # by dir
#' cloc(system.file("extdata", package="cloc"))
#'
#' # by file
#' cloc(system.file("extdata", "qrencoder.cpp", package="cloc"))
#'
#' # requires a network connection therefore is set for you to run it manually
#' \dontrun{
#' # from a url
#' cloc("https://rud.is/dl/cloc-1.74.tar.gz")
#' }
cloc_pkg <- function(source = ".", extract_with = NULL) {

  perl <- find_perl()

  tis_url <- is_url(source)

  if (tis_url) { # download the source if a URL was specified
    tdir <- tempdir()
    utils::download.file(source, file.path(tdir, basename(source)), method = "curl", quiet = TRUE)
    source <- file.path(tdir, basename(source))
    on.exit(unlink(source), add = TRUE)
  }

  source <- path.expand(source)

  stopifnot(file.exists(source))

  # make the command line

  c(
    system.file("bin/cloc.pl", package = "cloc"),
    "--exclude-ext=yml,md,Rproj",
    "--exclude-dir=.Rproj,.Rproj.user,.git,inst,man,docs,tools",
    "--quiet",
    "--csv",
    source
  ) -> args

  # tack on the "--extract-with" value (if specified)
  if (!is.null(extract_with)) {
    cmd <- c(args, sprintf('--extract-with="%s"', extract_with))
  }

  processx::run(
    command = perl,
    args = args
  ) -> res

  dat <- res$stdout

  # sprintf(
  #   "%s %s --exclude-ext=yml,md,Rproj --exclude-dir=.Rproj,.Rproj.user,.git,inst,man,docs,tools --quiet --csv %s",
  #   perl,
  #   shQuote(system.file("bin/cloc.pl", package = "cloc")),
  #   source
  # ) -> cmd

  # run the perl script
  # dat <- system(cmd, intern = TRUE)

  # nothing to count
  if (nzchar(dat) == 0) {
    return(
      data.frame(
        source = basename(source),
        language = NA_character_,
        file_count = 0,
        file_count_pct = 0,
        loc = 0,
        loc_pct = 0,
        blank_lines = 0,
        blank_line_pct = 0,
        comment_lines = 0,
        comment_line_pct = 0,
        stringsAsFactors = FALSE
      )
    )
  }

  dat <- unlist(strsplit(dat, "\r?\n"))

  # read in the output from the perl script
  fil <- read.table(
    text = paste(utils::tail(dat, -2), sep = "", collapse = "\n"),
    col.names = c("file_count", "language", "blank_lines", "comment_lines", "loc"),
    sep = ",", comment.char = "", stringsAsFactors = FALSE
  )

  # calculate percentages
  fil$source <- basename(source)
  fil$file_count_pct <- fil$file_count / sum(fil$file_count)
  fil$blank_line_pct <- fil$blank_lines / sum(fil$blank_lines)
  fil$comment_line_pct <- fil$comment_lines / sum(fil$comment_lines)
  fil$loc_pct <- fil$loc / sum(fil$loc)

  # reorganize columns
  fil <- fil[, c(
    "source", "language",
    "file_count", "file_count_pct",
    "loc", "loc_pct",
    "blank_lines", "blank_line_pct",
    "comment_lines", "comment_line_pct"
  )]

  class(fil) <- c("tbl_df", "tbl", "data.frame")

  fil

}

# nolint end