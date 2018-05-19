#' @keywords internal
strip_rmd <- function() {

  ctx <- rstudioapi::getActiveDocumentContext()

  if (!is.null(ctx)) {

    if (is_rmd_file(ctx$path)) {

      x <- basename(ctx$path)
      x <- tools::file_path_sans_ext(x)

      tf1 <- tempfile(pattern = x, fileext = ".Rmd")
      on.exit(unlink(tf1), add = TRUE)

      tf2 <- tempfile(pattern = x, fileext = ".R")

      cat(ctx$contents, file = tf1, sep = "\n")

      nc <- cloc_remove_comments(tf1)

      cat(nc, file = tf2)

      navigateToFile(tf2, line = -1L, column = -1L)

      message(
        sprintf(
          "Temporary file generated is in [%s]", tf2
        )
      )

    } else {
      stop("Can only style .R and .Rmd files.", call. = FALSE)
    }

  }

}
