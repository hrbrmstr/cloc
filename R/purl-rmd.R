
#' @keywords internal
purl_rmd_addin <- function() {

  ctx <- rstudioapi::getActiveDocumentContext()

  if (!is.null(ctx)) {

    if (is_rmd_file(ctx$path)) {

      x <- basename(ctx$path)
      x <- tools::file_path_sans_ext(x)

      tf1 <- tempfile(pattern = x, fileext = ".Rmd")
      on.exit(unlink(tf1), add = TRUE)

      tf2 <- tempfile(pattern = x, fileext = ".R")

      cat(ctx$contents, file = tf1, sep = "\n")

      knitr::purl(tf1, output = tf2, quiet = TRUE)

      navigateToFile(tf2, line = -1L, column = -1L)

      message(
        sprintf(
          "Temporary file generated is in [%s]", tf2
        )
      )

    } else {
      stop("Can only perform operations on Rmd files.", call. = FALSE)
    }

  }

}
