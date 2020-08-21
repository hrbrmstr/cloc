# cloc 0.3.5

- upgraded bundled clocl.pl to 1.86
- switched from `system()` to `processx::run()` package-wide to address #10

# cloc 0.3.0

- upgraded bundled cloc.pl to 1.80

# cloc 0.2.0

- included a custom `cloc.pl` script (`cloc` pending PR <https://github.com/AlDanial/cloc/pull/294>)
  that adds support for R Markdown (Rmd) files. Only the lines of code between
  the triple-backticks code blocks are included. THe resultant "language" type is
  `Rmd` as the code blocks could be anything. The results will only be fully accurate for
  R/Python-ish syntax languages (i.e. the ones supporting the basic `cloc` rules for 
  those languages) but they should be accurate enough for rough estimates for
  other languages used in Rmd code blocks.
- URLs as sources work in more functions now
- cloc_git() can now clone repo when using git:// URLs
- removed dplyr dependency
- created an RStudio addin to enable reducing the active Rmd document to just code (in a new document)

# cloc 0.1.0

- added support for many cloc.pl features
- overhaul to resurrect the package
- upgraded to latest (1.74) cloc perl utility (@maelle)

# cloc 0.0.0.9000

- initial version
