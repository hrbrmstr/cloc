
<!-- README.md is generated from README.Rmd. Please edit that file -->

![Project Status: Concept - Minimal or no implementation has been done
yet.](http://www.repostatus.org/badges/0.1.0/concept.svg)

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
  - `cloc_cran`: Count lines of code (etc) from source packages on CRAN

## Usage

``` r
devtools::install_github("hrbrmstr/cloc")
```

``` r
library(cloc)

# current verison
packageVersion("cloc")
#> [1] '0.1.0'
```

Basic usage

``` r
# by dir
cloc(system.file("extdata", package="cloc"))
#> # A tibble: 3 x 10
#>    source language file_count file_count_pct   loc    loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
#>     <chr>    <chr>      <int>          <dbl> <int>      <dbl>       <int>          <dbl>         <int>            <dbl>
#> 1 extdata      C++          1      0.3333333   142 0.49305556          41     0.62121212            63       0.45652174
#> 2 extdata        R          1      0.3333333   138 0.47916667          24     0.36363636            71       0.51449275
#> 3 extdata     Java          1      0.3333333     8 0.02777778           1     0.01515152             4       0.02898551

# by file
cloc(system.file("extdata", "App.java", package="cloc"))
#> # A tibble: 1 x 10
#>     source language file_count file_count_pct   loc loc_pct blank_lines blank_line_pct comment_lines comment_line_pct
#>      <chr>    <chr>      <int>          <dbl> <int>   <dbl>       <int>          <dbl>         <int>            <dbl>
#> 1 App.java     Java          1              1     8       1           1              1             4                1

# from a url
cloc("https://rud.is/dl/cloc-1.74.tar.gz")
#> # A tibble: 93 x 10
#>              source      language file_count file_count_pct   loc    loc_pct blank_lines blank_line_pct comment_lines
#>               <chr>         <chr>      <int>          <dbl> <int>      <dbl>       <int>          <dbl>         <int>
#>  1 cloc-1.74.tar.gz          Perl          5    0.017985612 19712 0.59784059        1353   0.4203168686          2430
#>  2 cloc-1.74.tar.gz          YAML        141    0.507194245  2887 0.08755914           1   0.0003106555           141
#>  3 cloc-1.74.tar.gz      Markdown          1    0.003597122  2195 0.06657164         226   0.0702081392            26
#>  4 cloc-1.74.tar.gz ANTLR Grammar          2    0.007194245  1012 0.03069271         200   0.0621310966            59
#>  5 cloc-1.74.tar.gz             R          3    0.010791367   698 0.02116948          95   0.0295122709           312
#>  6 cloc-1.74.tar.gz  C/C++ Header          1    0.003597122   617 0.01871285         191   0.0593351973           780
#>  7 cloc-1.74.tar.gz           C++          4    0.014388489   570 0.01728740         132   0.0410065238           173
#>  8 cloc-1.74.tar.gz         Forth          2    0.007194245   529 0.01604392          17   0.0052811432            84
#>  9 cloc-1.74.tar.gz    TypeScript          3    0.010791367   410 0.01243479          52   0.0161540851            39
#> 10 cloc-1.74.tar.gz       Logtalk          1    0.003597122   368 0.01116099          59   0.0183286735            57
#> # ... with 83 more rows, and 1 more variables: comment_line_pct <dbl>
```

Custom CRAN package counter:

``` r
cloc_cran(c("archdata", "hrbrthemes", "iptools", "dplyr"))
#>                     source     language file_count file_count_pct   loc     loc_pct blank_lines blank_line_pct
#> 1      archdata_1.1.tar.gz         <NA>          0    0.000000000     0 0.000000000           0    0.000000000
#> 2  hrbrthemes_0.1.0.tar.gz            R          9    0.750000000   360 0.592105263          80    0.544217687
#> 3  hrbrthemes_0.1.0.tar.gz     Markdown          2    0.166666667   140 0.230263158          39    0.265306122
#> 4  hrbrthemes_0.1.0.tar.gz         HTML          1    0.083333333   108 0.177631579          28    0.190476190
#> 5     iptools_0.4.0.tar.gz   JavaScript          2    0.080000000  7952 0.868691282         699    0.716188525
#> 6     iptools_0.4.0.tar.gz          C++          3    0.120000000   600 0.065545117         109    0.111680328
#> 7     iptools_0.4.0.tar.gz            R         17    0.680000000   341 0.037251475          92    0.094262295
#> 8     iptools_0.4.0.tar.gz         HTML          2    0.080000000   220 0.024033210          51    0.052254098
#> 9     iptools_0.4.0.tar.gz C/C++ Header          1    0.040000000    41 0.004478916          25    0.025614754
#> 10      dplyr_0.7.4.tar.gz            R        147    0.462264151 12303 0.436245656        2655    0.427398583
#> 11      dplyr_0.7.4.tar.gz C/C++ Header        125    0.393081761  6816 0.241684987        1826    0.293947199
#> 12      dplyr_0.7.4.tar.gz          C++         32    0.100628931  4335 0.153712503         795    0.127978107
#> 13      dplyr_0.7.4.tar.gz         HTML         11    0.034591195  3564 0.126374016         367    0.059079202
#> 14      dplyr_0.7.4.tar.gz     Markdown          2    0.006289308  1154 0.040919084         562    0.090470058
#> 15      dplyr_0.7.4.tar.gz            C          1    0.003144654    30 0.001063754           7    0.001126851
#>    comment_lines comment_line_pct        pkg
#> 1              0      0.000000000   archdata
#> 2            239      0.995833333 hrbrthemes
#> 3              0      0.000000000 hrbrthemes
#> 4              1      0.004166667 hrbrthemes
#> 5            356      0.262924668    iptools
#> 6            260      0.192023634    iptools
#> 7            531      0.392171344    iptools
#> 8              2      0.001477105    iptools
#> 9            205      0.151403250    iptools
#> 10          3836      0.873406193      dplyr
#> 11           251      0.057149362      dplyr
#> 12           294      0.066939891      dplyr
#> 13            11      0.002504554      dplyr
#> 14             0      0.000000000      dplyr
#> 15             0      0.000000000      dplyr
```

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.
