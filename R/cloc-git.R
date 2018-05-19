#' Count lines of code, comments and whitespace in a git tree
#'
#' @md
#' @param repo path to git repo; if `repo` is a URL like `git://`, it will be fetched into
#'        a temporary directory
#' @param commit "`.`" for the current source tree or the commit identifier for a specific commit
#' @param branch,credentials,progressed passed on to [git2r::clone()].
#' @return data frame (tibble)
#' @export
#' @examples \dontrun{
#' cloc_git("~/packages/cloc", "3643cd09d4b951b1b35d32dffe35985dfe7756c4")
#'
#' # from remote git
#' cloc_git("git://github.com/hrbrmstr/cloc.git")
#' }
cloc_git <- function(repo, commit=".", branch = NULL, credentials = NULL, progress = FALSE) {

  perl <- find_perl()

  tis_url <- is_url(repo)

  if (tis_url) { # clone the repo if a URL was specified

    tdir <- tempdir()

    git2r::clone(
      url = repo,
      local_path = file.path(tdir, basename(repo)),
      branch = branch,
      credentials = credentials,
      progress = progress
    ) -> repo_obj

    repo <- file.path(tdir, basename(repo))

    on.exit(unlink(repo), add = TRUE)

  }

  repo <- path.expand(repo)

  stopifnot(file.exists(repo))

  # make the command line

  curr_dir <- getwd()

  setwd(repo)
  on.exit(setwd(curr_dir), add=TRUE)

  x <- processx::run(
    command = perl,
    args = c(
      system.file("bin/cloc.pl", package = "cloc"),
      "--quiet",
      "--git",
      "--csv",
      commit
    )
  )

  # run the perl script
  dat <- strsplit(x$stdout, "[\r\n]+")[[1]]

  # nothing to count
  if (length(dat) == 0) {
    return(
      data.frame(
        source = basename(repo),
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

  # read in the output from the perl script
  fil <- read.table(
    text = paste(utils::tail(dat, -2), sep = "", collapse = "\n"),
    col.names = c("file_count", "language", "blank_lines", "comment_lines", "loc"),
    sep = ",", comment.char = "", stringsAsFactors = FALSE
  )

  # calculate percentages
  fil$source <- basename(repo)
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
