
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Travis-CI Build
Status](https://travis-ci.org/hrbrmstr/cloc.svg?branch=master)](https://travis-ci.org/hrbrmstr/cloc)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/hrbrmstr/cloc?branch=master&svg=true)](https://ci.appveyor.com/project/hrbrmstr/cloc)
[![Coverage
Status](https://img.shields.io/codecov/c/github/hrbrmstr/cloc/master.svg)](https://codecov.io/github/hrbrmstr/cloc?branch=master)

# cloc

Count Lines of Code, Comments and Whitespace in Source Files and
Archives

## Description

Counts blank lines, comment lines, and physical lines of source code in
source files/trees/archives. An R wrapper to the Perl `cloc` utility
<https://github.com/AlDanial/cloc> by @AlDanial.

## What’s Inside The Tin

The following functions are implemented:

  - `cloc`: Count lines of code, comments and whitespace in source
    files/archives
  - `cloc_by_file`: Count lines of code, comments and whitespace in
    source files/archives by file
  - `cloc_cran`: Count lines of code (etc) from source packages on CRAN
  - `cloc_git`: Count lines of code, comments and whitespace in a git
    tree
  - `cloc_remove_comments`: Strip comments and white space from a single
    source file
  - `cloc_recognized_languages`: Return a data frame of ‘cloc’
    recognized languages and associated extensions
  - `cloc_call`: Call ‘cloc.pl’ directly with granular control over
    options
  - `clock_pkg_md` : Run `cloc_pkg()` on active package and format it as
    a markdown table for knitting into reports
  - `cloc_help`: See the command-line help
  - `cloc_version`: Retrieve the version of the embedded perl script
  - `cloc_os`: Ask the embedded perl script to detect the OS type

## Usage

``` r
devtools::install_github("hrbrmstr/cloc")
```

``` r
library(cloc)
library(tibble)

# current verison
packageVersion("cloc")
#> [1] '0.3.0'
```

Basic usage

``` r
# by dir
cloc(system.file("extdata", package="cloc"))
#> # A tibble: 2 x 10
#>   source  language file_count file_count_pct   loc loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
#>   <chr>   <chr>         <int>          <dbl> <int>   <dbl>       <int>          <dbl>         <int>            <dbl>
#> 1 extdata C++               1            0.5   142   0.507          41          0.631            63            0.470
#> 2 extdata R                 1            0.5   138   0.493          24          0.369            71            0.530

# by file
cloc(system.file("extdata", "qrencoder.cpp", package="cloc"))
#> # A tibble: 1 x 10
#>   source      language file_count file_count_pct   loc loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
#>   <chr>       <chr>         <int>          <dbl> <int>   <dbl>       <int>          <dbl>         <int>            <dbl>
#> 1 qrencoder.… C++               1              1   142       1          41              1            63                1

# from a url
cloc("https://rud.is/dl/cloc-1.74.tar.gz")
#> # A tibble: 93 x 10
#>    source    language  file_count file_count_pct   loc loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
#>    <chr>     <chr>          <int>          <dbl> <int>   <dbl>       <int>          <dbl>         <int>            <dbl>
#>  1 cloc-1.7… Perl               5        0.0180  19712  0.598         1353       0.420             2430          0.443  
#>  2 cloc-1.7… YAML             141        0.507    2887  0.0876           1       0.000311           141          0.0257 
#>  3 cloc-1.7… Markdown           1        0.00360  2195  0.0666         226       0.0702              26          0.00474
#>  4 cloc-1.7… ANTLR Gr…          2        0.00719  1012  0.0307         200       0.0621              59          0.0108 
#>  5 cloc-1.7… R                  3        0.0108    698  0.0212          95       0.0295             312          0.0569 
#>  6 cloc-1.7… C/C++ He…          1        0.00360   617  0.0187         191       0.0593             780          0.142  
#>  7 cloc-1.7… C++                4        0.0144    570  0.0173         132       0.0410             173          0.0315 
#>  8 cloc-1.7… Forth              2        0.00719   529  0.0160          17       0.00528             84          0.0153 
#>  9 cloc-1.7… TypeScri…          3        0.0108    410  0.0124          52       0.0162              39          0.00711
#> 10 cloc-1.7… Logtalk            1        0.00360   368  0.0112          59       0.0183              57          0.0104 
#> # … with 83 more rows
```

Custom CRAN package counter:

``` r
cloc_cran(c("archdata", "hrbrthemes", "iptools", "dplyr"))
#> # A tibble: 19 x 11
#>    source language file_count file_count_pct   loc loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
#>    <chr>  <chr>         <dbl>          <dbl> <dbl>   <dbl>       <dbl>          <dbl>         <dbl>            <dbl>
#>  1 archd… <NA>              0        0           0 0.                0       0                    0         0       
#>  2 hrbrt… R                21        0.7      1094 6.63e-1         215       0.560              584         0.832   
#>  3 hrbrt… HTML              2        0.0667    366 2.22e-1          48       0.125                2         0.00285 
#>  4 hrbrt… CSS               1        0.0333    113 6.85e-2          27       0.0703               0         0       
#>  5 hrbrt… Rmd               3        0.1        35 2.12e-2          78       0.203              116         0.165   
#>  6 hrbrt… Markdown          1        0.0333     33 2.00e-2          16       0.0417               0         0       
#>  7 hrbrt… YAML              2        0.0667      8 4.85e-3           0       0                    0         0       
#>  8 iptoo… C++               4        0.138     846 4.21e-1         167       0.400              375         0.286   
#>  9 iptoo… HTML              2        0.0690    633 3.15e-1          54       0.129                2         0.00153 
#> 10 iptoo… R                20        0.690     444 2.21e-1         133       0.319              638         0.487   
#> 11 iptoo… Rmd               2        0.0690     48 2.39e-2          33       0.0791              72         0.0550  
#> 12 iptoo… C/C++ H…          1        0.0345     37 1.84e-2          30       0.0719             223         0.170   
#> 13 dplyr… R               171        0.552   14999 4.76e-1        3127       0.425             4957         0.685   
#> 14 dplyr… C/C++ H…        101        0.326    6661 2.11e-1        1754       0.238              483         0.0668  
#> 15 dplyr… C++              23        0.0742   4706 1.49e-1         954       0.130              437         0.0604  
#> 16 dplyr… HTML              5        0.0161   3206 1.02e-1         140       0.0190               5         0.000691
#> 17 dplyr… Markdown          2        0.00645  1479 4.69e-2         708       0.0962               0         0       
#> 18 dplyr… Rmd               7        0.0226    462 1.46e-2         667       0.0907            1350         0.187   
#> 19 dplyr… C                 1        0.00323    30 9.51e-4           7       0.000951             0         0       
#> # … with 1 more variable: pkg <chr>
```

git tree

``` r
cloc_git("~/packages/cloc")
##   source language file_count file_count_pct   loc      loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
## 1   cloc     Perl          1      0.1111111 10059 0.9867569158         787    0.910879630          1292     0.9570370370
## 2   cloc Markdown          2      0.2222222    60 0.0058858152          31    0.035879630             0     0.0000000000
## 3   cloc        R          4      0.4444444    52 0.0051010398          22    0.025462963            25     0.0185185185
## 4   cloc      Rmd          1      0.1111111    13 0.0012752600          21    0.024305556            32     0.0237037037
## 5   cloc     YAML          1      0.1111111    10 0.0009809692           3    0.003472222             1     0.0007407407
```

git tree (with specific commit)

``` r
cloc_git("~/packages/cloc", "3643cd09d4b951b1b35d32dffe35985dfe7756c4")
##   source language file_count file_count_pct   loc      loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
## 1   cloc     Perl          1      0.1111111 10059 0.9867569158         787    0.910879630          1292     0.9570370370
## 2   cloc Markdown          2      0.2222222    60 0.0058858152          31    0.035879630             0     0.0000000000
## 3   cloc        R          4      0.4444444    52 0.0051010398          22    0.025462963            25     0.0185185185
## 4   cloc      Rmd          1      0.1111111    13 0.0012752600          21    0.024305556            32     0.0237037037
## 5   cloc     YAML          1      0.1111111    10 0.0009809692           3    0.003472222             1     0.0007407407
```

remote git tree

``` r
cloc_git("git://github.com/maelle/convertagd.git")
#> # A tibble: 4 x 10
#>   source      language file_count file_count_pct   loc loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
#>   <chr>       <chr>         <int>          <dbl> <int>   <dbl>       <int>          <dbl>         <int>            <dbl>
#> 1 convertagd… R                 7         0.583    249  0.659           70          0.56             68           0.667 
#> 2 convertagd… Markdown          2         0.167     77  0.204           23          0.184             0           0     
#> 3 convertagd… YAML              2         0.167     42  0.111           16          0.128             4           0.0392
#> 4 convertagd… Rmd               1         0.0833    10  0.0265          16          0.128            30           0.294
```

Detailed results by file

``` r
# whole dir
str(cloc_by_file(system.file("extdata", package="cloc")))
#> Classes 'tbl_df', 'tbl' and 'data.frame':    2 obs. of  6 variables:
#>  $ source       : chr  "extdata" "extdata"
#>  $ filename     : chr  "/Library/Frameworks/R.framework/Versions/3.5/Resources/library/cloc/extdata/qrencoder.cpp" "/Library/Frameworks/R.framework/Versions/3.5/Resources/library/cloc/extdata/dbi.r"
#>  $ language     : chr  "C++" "R"
#>  $ loc          : int  142 138
#>  $ blank_lines  : int  41 24
#>  $ comment_lines: int  63 71

# single file
str(cloc_by_file(system.file("extdata", "qrencoder.cpp", package="cloc")))
#> Classes 'tbl_df', 'tbl' and 'data.frame':    1 obs. of  6 variables:
#>  $ source       : chr "qrencoder.cpp"
#>  $ filename     : chr "/Library/Frameworks/R.framework/Versions/3.5/Resources/library/cloc/extdata/qrencoder.cpp"
#>  $ language     : chr "C++"
#>  $ loc          : int 142
#>  $ blank_lines  : int 41
#>  $ comment_lines: int 63
```

Recognized languages

``` r
cloc_recognized_languages()
#> # A tibble: 242 x 2
#>    lang           extensions            
#>    <chr>          <chr>                 
#>  1 ABAP           abap                  
#>  2 ActionScript   as                    
#>  3 Ada            ada, adb, ads, pad    
#>  4 ADSO/IDSM      adso                  
#>  5 Agda           agda, lagda           
#>  6 AMPLE          ample, dofile, startup
#>  7 Ant            build.xml, build.xml  
#>  8 ANTLR Grammar  g, g4                 
#>  9 Apex Trigger   trigger               
#> 10 Arduino Sketch ino, pde              
#> # … with 232 more rows
```

Strip comments and whitespace from individual source files

``` r
cat(
  cloc_remove_comments("https://raw.githubusercontent.com/maelle/convertagd/master/README.Rmd")
)
#> library("knitr")
#> library("devtools")
#> install_github("masalmon/convertagd")
#> library("convertagd")
#> file <- system.file("extdata", "dummyCHAI.agd", package = "convertagd")
#> testRes <- read_agd(file, tz = "GMT")
#> kable(testRes[["settings"]])
#> kable(head(testRes[["raw.data"]]))
#> path_to_directory <- system.file("extdata", package = "convertagd")
#> batch_read_agd(path_to_directory, tz="GMT")
```

## cloc Metrics

| Lang | \# Files |  (%) | LoC |  (%) | Blank lines |  (%) | \# Lines |  (%) |
| :--- | -------: | ---: | --: | ---: | ----------: | ---: | -------: | ---: |
| R    |       16 | 0.94 | 484 | 0.95 |         183 | 0.83 |      289 | 0.77 |
| Rmd  |        1 | 0.06 |  24 | 0.05 |          38 | 0.17 |       85 | 0.23 |

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.
