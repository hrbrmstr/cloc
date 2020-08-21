
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Signed
by](https://img.shields.io/badge/Keybase-Verified-brightgreen.svg)](https://keybase.io/hrbrmstr)
![Signed commit
%](https://img.shields.io/badge/Signed_Commits-74%25-lightgrey.svg)
[![Linux build
Status](https://travis-ci.org/hrbrmstr/cloc.svg?branch=master)](https://travis-ci.org/hrbrmstr/cloc)
[![Windows build
status](https://ci.appveyor.com/api/projects/status/github/hrbrmstr/cloc?svg=true)](https://ci.appveyor.com/project/hrbrmstr/cloc)
[![Coverage
Status](https://codecov.io/gh/hrbrmstr/cloc/branch/master/graph/badge.svg)](https://codecov.io/gh/hrbrmstr/cloc)
![Minimal R
Version](https://img.shields.io/badge/R%3E%3D-3.6.0-blue.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

cloc
====

Count Lines of Code, Comments and Whitespace in Source Files and
Archives

Description
-----------

Counts blank lines, comment lines, and physical lines of source code in
source files/trees/archives. An R wrapper to the ‘Perl’ command-line
utility
<a href="https://github.com/AlDanial/cloc" class="uri">https://github.com/AlDanial/cloc</a>.

What’s Inside The Tin
---------------------

The following functions are implemented:

-   `cloc_by_file`: Count lines of code, comments and whitespace in
    source files/archives by file
-   `cloc_call`: Call cloc.pl directly with granular control over
    options
-   `cloc_cran`: Count lines of code (etc) from source packages on CRAN
-   `cloc_git`: Count lines of code, comments and whitespace in a git
    tree
-   `cloc_pkg_md`: Run cloc\_pkg() on active package and format it as a
    markdown table for knitting into reports
-   `cloc_pkg`: Count lines of code, comments and whitespace in a
    package
-   `cloc_recognized_languages`: Return a data frame of cloc recognized
    languages and associated extensions
-   `cloc_remove_comments`: Strip comments and white space from a single
    source file

Installation
------------

    install.packages("cloc", repos = c("https://cinc.rud.is", "https://cloud.r-project.org/"))
    # or
    remotes::install_git("https://git.rud.is/hrbrmstr/cloc.git")
    # or
    remotes::install_git("https://git.sr.ht/~hrbrmstr/cloc")
    # or
    remotes::install_gitlab("hrbrmstr/cloc")
    # or
    remotes::install_bitbucket("hrbrmstr/cloc")
    # or
    remotes::install_github("hrbrmstr/cloc")

NOTE: To use the ‘remotes’ install options you will need to have the
[{remotes} package](https://github.com/r-lib/remotes) installed.

Usage
-----

    library(cloc)
    library(tibble) # for printing

    # current version
    packageVersion("cloc")
    ## [1] '0.3.5'

Basic usage

    # by dir
    cloc(system.file("extdata", package="cloc"))
    ## # A tibble: 3 x 10
    ##   source  language file_count file_count_pct   loc loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
    ##   <chr>   <chr>         <int>          <dbl> <int>   <dbl>       <int>          <dbl>         <int>            <dbl>
    ## 1 extdata C++               1           0.25   142   0.254          41          0.315            63            0.235
    ## 2 extdata R                 1           0.25   138   0.246          24          0.185            71            0.265
    ## 3 extdata SUM               2           0.5    280   0.5            65          0.5             134            0.5

    # by file
    cloc(system.file("extdata", "qrencoder.cpp", package="cloc"))
    ## # A tibble: 2 x 10
    ##   source      language file_count file_count_pct   loc loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
    ##   <chr>       <chr>         <int>          <dbl> <int>   <dbl>       <int>          <dbl>         <int>            <dbl>
    ## 1 qrencoder.… C++               1            0.5   142     0.5          41            0.5            63              0.5
    ## 2 qrencoder.… SUM               1            0.5   142     0.5          41            0.5            63              0.5

    # from a url
    cloc("https://rud.is/dl/cloc-1.74.tar.gz")
    ## # A tibble: 93 x 10
    ##    source    language  file_count file_count_pct   loc loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
    ##    <chr>     <chr>          <int>          <dbl> <int>   <dbl>       <int>          <dbl>         <int>            <dbl>
    ##  1 cloc-1.7… Perl               5        0.00903 19712 0.299          1353       0.211             2430          0.222  
    ##  2 cloc-1.7… YAML             141        0.255    2887 0.0438            1       0.000156           141          0.0129 
    ##  3 cloc-1.7… Markdown           1        0.00181  2195 0.0333          226       0.0352              26          0.00237
    ##  4 cloc-1.7… ANTLR Gr…          2        0.00361  1012 0.0154          200       0.0312              59          0.00538
    ##  5 cloc-1.7… R                  3        0.00542   698 0.0106           95       0.0148             312          0.0285 
    ##  6 cloc-1.7… C/C++ He…          1        0.00181   617 0.00937         191       0.0298             780          0.0712 
    ##  7 cloc-1.7… C++                4        0.00722   570 0.00865         132       0.0206             173          0.0158 
    ##  8 cloc-1.7… Forth              2        0.00361   529 0.00803          17       0.00265             84          0.00766
    ##  9 cloc-1.7… TypeScri…          3        0.00542   410 0.00622          52       0.00810             39          0.00356
    ## 10 cloc-1.7… Logtalk            1        0.00181   368 0.00559          59       0.00919             57          0.00520
    ## # … with 83 more rows

Custom CRAN package counter:

    cloc_cran(c("archdata", "hrbrthemes", "iptools", "dplyr"))
    ## # A tibble: 23 x 11
    ##    source language file_count file_count_pct   loc loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
    ##    <chr>  <chr>         <dbl>          <dbl> <dbl>   <dbl>       <dbl>          <dbl>         <dbl>            <dbl>
    ##  1 archd… <NA>              0         0          0 0                 0         0                  0          0      
    ##  2 hrbrt… R                23         0.338   1615 0.345           308         0.314            827          0.437  
    ##  3 hrbrt… HTML              2         0.0294   378 0.0807           53         0.0541             3          0.00159
    ##  4 hrbrt… SVG               2         0.0294   150 0.0320            0         0                  0          0      
    ##  5 hrbrt… CSS               1         0.0147   113 0.0241           27         0.0276             0          0      
    ##  6 hrbrt… Markdown          1         0.0147    44 0.00939          24         0.0245             0          0      
    ##  7 hrbrt… Rmd               3         0.0441    35 0.00747          78         0.0796           116          0.0613 
    ##  8 hrbrt… YAML              2         0.0294     8 0.00171           0         0                  0          0      
    ##  9 hrbrt… SUM              34         0.5     2343 0.5             490         0.5              946          0.5    
    ## 10 iptoo… C++               4         0.0690   846 0.211           167         0.200            375          0.143  
    ## # … with 13 more rows, and 1 more variable: pkg <chr>

git tree

    cloc_git("~/packages/cloc")
    ##   source language file_count file_count_pct   loc      loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
    ## 1   cloc     Perl          1      0.1111111 10059 0.9867569158         787    0.910879630          1292     0.9570370370
    ## 2   cloc Markdown          2      0.2222222    60 0.0058858152          31    0.035879630             0     0.0000000000
    ## 3   cloc        R          4      0.4444444    52 0.0051010398          22    0.025462963            25     0.0185185185
    ## 4   cloc      Rmd          1      0.1111111    13 0.0012752600          21    0.024305556            32     0.0237037037
    ## 5   cloc     YAML          1      0.1111111    10 0.0009809692           3    0.003472222             1     0.0007407407

git tree (with specific commit)

    cloc_git("~/packages/cloc", "3643cd09d4b951b1b35d32dffe35985dfe7756c4")
    ##   source language file_count file_count_pct   loc      loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
    ## 1   cloc     Perl          1      0.1111111 10059 0.9867569158         787    0.910879630          1292     0.9570370370
    ## 2   cloc Markdown          2      0.2222222    60 0.0058858152          31    0.035879630             0     0.0000000000
    ## 3   cloc        R          4      0.4444444    52 0.0051010398          22    0.025462963            25     0.0185185185
    ## 4   cloc      Rmd          1      0.1111111    13 0.0012752600          21    0.024305556            32     0.0237037037
    ## 5   cloc     YAML          1      0.1111111    10 0.0009809692           3    0.003472222             1     0.0007407407

remote git tree

    cloc_git("git://github.com/maelle/convertagd.git")
    ## # A tibble: 5 x 10
    ##   source      language file_count file_count_pct   loc loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
    ##   <chr>       <chr>         <int>          <dbl> <int>   <dbl>       <int>          <dbl>         <int>            <dbl>
    ## 1 convertagd… R                 7         0.292    249  0.329           70          0.28             68           0.333 
    ## 2 convertagd… Markdown          2         0.0833    77  0.102           23          0.092             0           0     
    ## 3 convertagd… YAML              2         0.0833    42  0.0556          16          0.064             4           0.0196
    ## 4 convertagd… Rmd               1         0.0417    10  0.0132          16          0.064            30           0.147 
    ## 5 convertagd… SUM              12         0.5      378  0.5            125          0.5             102           0.5

Detailed results by file

    # whole dir
    str(cloc_by_file(system.file("extdata", package="cloc")))
    ## tibble [3 × 6] (S3: tbl_df/tbl/data.frame)
    ##  $ source       : chr [1:3] "extdata" "extdata" "extdata"
    ##  $ filename     : chr [1:3] "/Library/Frameworks/R.framework/Versions/4.0/Resources/library/cloc/extdata/qrencoder.cpp" "/Library/Frameworks/R.framework/Versions/4.0/Resources/library/cloc/extdata/dbi.r" ""
    ##  $ language     : chr [1:3] "C++" "R" "SUM"
    ##  $ loc          : int [1:3] 142 138 280
    ##  $ blank_lines  : int [1:3] 41 24 65
    ##  $ comment_lines: int [1:3] 63 71 134

    # single file
    str(cloc_by_file(system.file("extdata", "qrencoder.cpp", package="cloc")))
    ## tibble [2 × 6] (S3: tbl_df/tbl/data.frame)
    ##  $ source       : chr [1:2] "qrencoder.cpp" "qrencoder.cpp"
    ##  $ filename     : chr [1:2] "/Library/Frameworks/R.framework/Versions/4.0/Resources/library/cloc/extdata/qrencoder.cpp" ""
    ##  $ language     : chr [1:2] "C++" "SUM"
    ##  $ loc          : int [1:2] 142 142
    ##  $ blank_lines  : int [1:2] 41 41
    ##  $ comment_lines: int [1:2] 63 63

Recognized languages

    cloc_recognized_languages()
    ## # A tibble: 262 x 2
    ##    lang          extensions            
    ##    <chr>         <chr>                 
    ##  1 ABAP          abap                  
    ##  2 ActionScript  as                    
    ##  3 Ada           ada, adb, ads, pad    
    ##  4 ADSO/IDSM     adso                  
    ##  5 Agda          agda, lagda           
    ##  6 AMPLE         ample, dofile, startup
    ##  7 Ant           build.xml, build.xml  
    ##  8 ANTLR Grammar g, g4                 
    ##  9 Apex Class    cls                   
    ## 10 Apex Trigger  trigger               
    ## # … with 252 more rows

Strip comments and whitespace from individual source files

    cat(
      cloc_remove_comments("https://raw.githubusercontent.com/maelle/convertagd/master/README.Rmd")
    )
    ## library("knitr")
    ## library("devtools")
    ## install_github("masalmon/convertagd")
    ## library("convertagd")
    ## file <- system.file("extdata", "dummyCHAI.agd", package = "convertagd")
    ## testRes <- read_agd(file, tz = "GMT")
    ## kable(testRes[["settings"]])
    ## kable(head(testRes[["raw.data"]]))
    ## path_to_directory <- system.file("extdata", package = "convertagd")
    ## batch_read_agd(path_to_directory, tz="GMT")

cloc Metrics
------------

| Lang | \# Files |  (%) | LoC |  (%) | Blank lines |  (%) | \# Lines |  (%) |
|:-----|---------:|-----:|----:|-----:|------------:|-----:|---------:|-----:|
| R    |       16 | 0.47 | 514 | 0.48 |         198 | 0.43 |      334 | 0.42 |
| Rmd  |        1 | 0.03 |  22 | 0.02 |          34 | 0.07 |       68 | 0.08 |
| SUM  |       17 | 0.50 | 536 | 0.50 |         232 | 0.50 |      402 | 0.50 |

clock Package Metrics for cloc

Code of Conduct
---------------

Please note that this project is released with a Contributor Code of
Conduct. By participating in this project you agree to abide by its
terms.
