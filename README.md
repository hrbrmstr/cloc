
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
#> [1] '0.2.0'
```

Basic usage

``` r
# by dir
cloc(system.file("extdata", package="cloc"))
#> # A tibble: 3 x 10
#>   source  language file_count file_count_pct   loc loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
#>   <chr>   <chr>         <int>          <dbl> <int>   <dbl>       <int>          <dbl>         <int>            <dbl>
#> 1 extdata C++               1          0.333   142  0.493           41         0.621             63           0.457 
#> 2 extdata R                 1          0.333   138  0.479           24         0.364             71           0.514 
#> 3 extdata Java              1          0.333     8  0.0278           1         0.0152             4           0.0290

# by file
cloc(system.file("extdata", "App.java", package="cloc"))
#> # A tibble: 1 x 10
#>   source   language file_count file_count_pct   loc loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
#>   <chr>    <chr>         <int>          <dbl> <int>   <dbl>       <int>          <dbl>         <int>            <dbl>
#> 1 App.java Java              1             1.     8      1.           1             1.             4               1.

# from a url
cloc("https://rud.is/dl/cloc-1.74.tar.gz")
#> # A tibble: 93 x 10
#>    source   language  file_count file_count_pct   loc loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
#>    <chr>    <chr>          <int>          <dbl> <int>   <dbl>       <int>          <dbl>         <int>            <dbl>
#>  1 cloc-1.… Perl               5        0.0180  19712  0.598         1353       0.420             2430          0.443  
#>  2 cloc-1.… YAML             141        0.507    2887  0.0876           1       0.000311           141          0.0257 
#>  3 cloc-1.… Markdown           1        0.00360  2195  0.0666         226       0.0702              26          0.00474
#>  4 cloc-1.… ANTLR Gr…          2        0.00719  1012  0.0307         200       0.0621              59          0.0108 
#>  5 cloc-1.… R                  3        0.0108    698  0.0212          95       0.0295             312          0.0569 
#>  6 cloc-1.… C/C++ He…          1        0.00360   617  0.0187         191       0.0593             780          0.142  
#>  7 cloc-1.… C++                4        0.0144    570  0.0173         132       0.0410             173          0.0315 
#>  8 cloc-1.… Forth              2        0.00719   529  0.0160          17       0.00528             84          0.0153 
#>  9 cloc-1.… TypeScri…          3        0.0108    410  0.0124          52       0.0162              39          0.00711
#> 10 cloc-1.… Logtalk            1        0.00360   368  0.0112          59       0.0183              57          0.0104 
#> # ... with 83 more rows
```

Custom CRAN package counter:

``` r
cloc_cran(c("archdata", "hrbrthemes", "iptools", "dplyr"))
#> # A tibble: 20 x 11
#>    source   language file_count file_count_pct    loc loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
#>    <chr>    <chr>         <dbl>          <dbl>  <dbl>   <dbl>       <dbl>          <dbl>         <dbl>            <dbl>
#>  1 archdat… <NA>             0.        0.          0. 0.               0.       0.                  0.          0.     
#>  2 hrbrthe… R               20.        0.690     927. 0.627          183.       0.523             549.          0.823  
#>  3 hrbrthe… HTML             2.        0.0690    366. 0.248           48.       0.137               2.          0.00300
#>  4 hrbrthe… CSS              1.        0.0345    113. 0.0765          27.       0.0771              0.          0.     
#>  5 hrbrthe… Rmd              3.        0.103      35. 0.0237          78.       0.223             116.          0.174  
#>  6 hrbrthe… Markdown         1.        0.0345     29. 0.0196          14.       0.0400              0.          0.     
#>  7 hrbrthe… YAML             2.        0.0690      8. 0.00541          0.       0.                  0.          0.     
#>  8 iptools… JavaScr…         2.        0.0741   7952. 0.864          699.       0.693             356.          0.250  
#>  9 iptools… C++              3.        0.111     600. 0.0652         109.       0.108             260.          0.182  
#> 10 iptools… R               17.        0.630     341. 0.0371          92.       0.0912            531.          0.372  
#> 11 iptools… HTML             2.        0.0741    220. 0.0239          51.       0.0505              2.          0.00140
#> 12 iptools… Rmd              2.        0.0741     48. 0.00522         33.       0.0327             72.          0.0505 
#> 13 iptools… C/C++ H…         1.        0.0370     41. 0.00446         25.       0.0248            205.          0.144  
#> 14 dplyr_0… R              148.        0.454   13216. 0.442         2671.       0.380            3876.          0.673  
#> 15 dplyr_0… C/C++ H…       125.        0.383    6687. 0.223         1836.       0.261             267.          0.0464 
#> 16 dplyr_0… C++             33.        0.101    4724. 0.158          915.       0.130             336.          0.0583 
#> 17 dplyr_0… HTML            11.        0.0337   3602. 0.120          367.       0.0522             11.          0.00191
#> 18 dplyr_0… Markdown         2.        0.00613  1251. 0.0418         619.       0.0880              0.          0.     
#> 19 dplyr_0… Rmd              6.        0.0184    421. 0.0141         622.       0.0884           1270.          0.220  
#> 20 dplyr_0… C                1.        0.00307    30. 0.00100          7.       0.000995            0.          0.     
#> # ... with 1 more variable: pkg <chr>
```

git tree

``` r
cloc_git("~/packages/cloc")
#> # A tibble: 8 x 10
#>   source language file_count file_count_pct   loc  loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
#>   <chr>  <chr>         <int>          <dbl> <int>    <dbl>       <int>          <dbl>         <int>            <dbl>
#> 1 cloc   Perl              1         0.0323 10578 0.908            838       0.708             1339          0.728  
#> 2 cloc   R                17         0.548    618 0.0530           205       0.173              360          0.196  
#> 3 cloc   Markdown          3         0.0968   245 0.0210            47       0.0397               0          0.     
#> 4 cloc   C++               1         0.0323   142 0.0122            41       0.0346              63          0.0342 
#> 5 cloc   YAML              3         0.0968    35 0.00300           14       0.0118               3          0.00163
#> 6 cloc   Rmd               1         0.0323    24 0.00206           38       0.0321              71          0.0386 
#> 7 cloc   Java              1         0.0323     8 0.000686           1       0.000845             4          0.00217
#> 8 cloc   JSON              4         0.129      4 0.000343           0       0.                   0          0.
```

git tree (with specific commit)

``` r
cloc_git("~/packages/cloc", "3643cd09d4b951b1b35d32dffe35985dfe7756c4")
#> # A tibble: 5 x 10
#>   source language file_count file_count_pct   loc  loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
#>   <chr>  <chr>         <int>          <dbl> <int>    <dbl>       <int>          <dbl>         <int>            <dbl>
#> 1 cloc   Perl              1          0.111 10059 0.987            787        0.911            1292         0.957   
#> 2 cloc   Markdown          2          0.222    60 0.00589           31        0.0359              0         0.      
#> 3 cloc   R                 4          0.444    52 0.00510           22        0.0255             25         0.0185  
#> 4 cloc   Rmd               1          0.111    13 0.00128           21        0.0243             32         0.0237  
#> 5 cloc   YAML              1          0.111    10 0.000981           3        0.00347             1         0.000741
```

remote git tree

``` r
cloc_git("git://github.com/maelle/convertagd.git")
#> # A tibble: 4 x 10
#>   source     language file_count file_count_pct   loc loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
#>   <chr>      <chr>         <int>          <dbl> <int>   <dbl>       <int>          <dbl>         <int>            <dbl>
#> 1 convertag… R                 7         0.583    249  0.659           70          0.560            68           0.667 
#> 2 convertag… Markdown          2         0.167     77  0.204           23          0.184             0           0.    
#> 3 convertag… YAML              2         0.167     42  0.111           16          0.128             4           0.0392
#> 4 convertag… Rmd               1         0.0833    10  0.0265          16          0.128            30           0.294
```

Detailed results by file

``` r
# whole dir
str(cloc_by_file(system.file("extdata", package="cloc")))
#> Classes 'tbl_df', 'tbl' and 'data.frame':    3 obs. of  6 variables:
#>  $ source       : chr  "extdata" "extdata" "extdata"
#>  $ filename     : chr  "/Library/Frameworks/R.framework/Versions/3.5/Resources/library/cloc/extdata/qrencoder.cpp" "/Library/Frameworks/R.framework/Versions/3.5/Resources/library/cloc/extdata/dbi.r" "/Library/Frameworks/R.framework/Versions/3.5/Resources/library/cloc/extdata/App.java"
#>  $ language     : chr  "C++" "R" "Java"
#>  $ loc          : int  142 138 8
#>  $ blank_lines  : int  41 24 1
#>  $ comment_lines: int  63 71 4

# single file
str(cloc_by_file(system.file("extdata", "App.java", package="cloc")))
#> Classes 'tbl_df', 'tbl' and 'data.frame':    1 obs. of  6 variables:
#>  $ source       : chr "App.java"
#>  $ filename     : chr "/Library/Frameworks/R.framework/Versions/3.5/Resources/library/cloc/extdata/App.java"
#>  $ language     : chr "Java"
#>  $ loc          : int 8
#>  $ blank_lines  : int 1
#>  $ comment_lines: int 4
```

Recognized languages

``` r
cloc_recognized_languages()
#> # A tibble: 238 x 2
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
#> # ... with 228 more rows
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

| Lang | \# Files |  (%) | LoC |  (%) | Blank lines |  (%) | \# Lines | (%) |
| :--- | -------: | ---: | --: | ---: | ----------: | ---: | -------: | --: |
| R    |       16 | 0.94 | 480 | 0.95 |         181 | 0.83 |      289 | 0.8 |
| Rmd  |        1 | 0.06 |  24 | 0.05 |          38 | 0.17 |       71 | 0.2 |

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.
