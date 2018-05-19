#' Call `cloc.pl` directly with granular control over options
#'
#' It is nigh impossible to predict all use-cases for the `cloc.pl` acript and
#' create associated R functions for them. To that end, this function provides direct
#' access to the script and enables direct passing of command-line parameters
#' via [processx::run()].
#'
#' @section Caveat utilitor:
#' As indicated, this is an lower-level function providing granular control over
#' the options for `cloc.pl`. You are invoking an operating system command-line
#' and need to read the `cloc.pl` help very carefully as --- unlike the higher-level
#' functions -- there are no "guide railss" provided to do helpful things such as e
#' nsure you do not clobber files in a given directory.
#'
#' [processx::run()] supports "callback functions" to make it easier to deal with
#' stdout and stderr and you may need to make use of those depending on the how
#' you are calling the underlying script.
#'
#' @md
#' @param args, character vector, arguments to the command. They will be escaped
#'        via [base::shQuote()].
#' @param echo echo Whether to print the standard output and error to the screen.
#'        Note that the order of the standard output and error lines are not necessarily
#'        correct, as standard output is typically buffered.
#' @param ... other options/parameters passed on to [processx::run()]
#' @return the structure returned by [processx::run()] (a list with four elements).
#' @export
#' @examples
#' # Get help on the parameters `cloc.pl` supports
#' cloc_call("--help", echo_cmd=TRUE, echo=TRUE)
#'
#' # or use the helper version of the above
#' cloc_help()
#'
#' # show the OS type
#' cloc_call("--show-os")
#'
#' # shortcut equivalent
#' cloc_os()
#'
#' # retrieve the OS type
#' trimws(cloc_call("--show-os")$stdout)
#'
#' # shortcut of the above with no echo and only returning trimmed stdout
#' cloc_os()
#'
#' # get version of cloc.pl script provided with the package
#' cloc_version()
cloc_call <- function(args = character(), echo = TRUE, ...) {

  perl <- find_perl()

  args <-  c(system.file("bin/cloc.pl", package = "cloc"), args)

  ret <- processx::run(command = perl, args = args, echo = echo, ...)

  invisible(ret)

}

#' @rdname cloc_call
#' @export
cloc_help <- function(echo = FALSE) {
  cat(cloc_call("--help", echo = echo)$stdout)
  invisible()
}

#' @rdname cloc_call
#' @export
cloc_version <- function(echo = FALSE) {
  trimws(cloc_call("--version", echo = echo)$stdout)
}

#' @rdname cloc_call
#' @export
cloc_os <- function(echo = FALSE) {
  trimws(cloc_call("--show-os", echo = echo)$stdout)
}
