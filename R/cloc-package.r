#' Count Lines of Code, Comments and Whitespace in Source Files and Archives
#'
#' Counts blank lines, comment lines, and physical lines of source code in source
#' files/trees/archives. An R wrapper to the Perl `cloc` utility
#' <https://github.com/AlDanial/cloc> by @@AlDanial.
#'
#' @md
#' @section How it works:
#' `cloc`'s method of operation resembles [`SLOCCount`](https://www.dwheeler.com/sloccount/)'s:
#' First, create a list of files to consider. Next, attempt to determine whether or not
#' found files contain recognized computer language source code. Finally, for files
#' identified as source files, invoke language-specific routines to count the number of
#' source lines.
#'
#' A more detailed description:
#'
#' 1.  If the input file is an archive (such as a `.tar.gz` or `.zip` file),
#'     create a temporary directory and expand the archive there using a
#'     system call to an appropriate underlying utility (`tar`, `bzip2`, `unzip`,
#'     etc) then add this temporary directory as one of the inputs. (This
#'     works more reliably on Unix than on Windows.)
#' 2.  Use perl's `File::Find` to recursively descend the input directories and make
#'     a list of candidate file names. Ignore binary and zero-sized files.
#' 3.  Make sure the files in the candidate list have unique contents
#'     (first by comparing file sizes, then, for similarly sized files,
#'     compare MD5 hashes of the file contents with perl's `Digest::MD5`). For each
#'     set of identical files, remove all but the first copy, as determined
#'     by a lexical sort, of identical files from the set. The removed
#'     files are not included in the report.
#' 4.  Scan the candidate file list for file extensions which cloc
#'     associates with programming languages. Files which match are classified as
#'     containing source
#'     code for that language. Each file without an extensions is opened
#'     and its first line read to see if it is a Unix shell script
#'     (anything that begins with `#!`). If it is shell script, the file is
#'     classified by that scripting language (if the language is
#'     recognized). If the file does not have a recognized extension or is
#'     not a recognzied scripting language, the file is ignored.
#' 5.  All remaining files in the candidate list should now be source files
#'     for known programming languages. For each of these files:
#'
#'     1.  Read the entire file into memory.
#'     2.  Count the number of lines (= L _original_).
#'     3.  Remove blank lines, then count again (= L _non-blank_).
#'     4.  Loop over the comment filters defined for this language. (For
#'         example, C++ as two filters: (1) remove lines that start with
#'         optional whitespace followed by `//` and (2) remove text between
#'         `/*` and `*/`) Apply each filter to the code to remove comments.
#'         Count the left over lines (= L _code_).
#'     5.  Save the counts for this language:
#'         * blank lines = L _original_ - L _non-blank_
#'         * comment lines = L _non-blank_ - L _code_
#'         * code lines = L _code_
#' @name cloc-package
#' @docType package
#' @author Bob Rudis (bob@@rud.is)
#' @importFrom git2r clone
#' @importFrom utils read.table contrib.url download.file download.packages tail
#' @importFrom dplyr bind_rows progress_estimated data_frame
#' @importFrom processx run
NULL
