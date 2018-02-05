
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
  - `cloc_by_file`: Count lines of code, comments and whitespace in
    source files/archives by file
  - `cloc_cran`: Count lines of code (etc) from source packages on CRAN
  - `cloc_git`: Count lines of code, comments and whitespace in a git
    tree
  - `cloc_remove_comments`: Strip comments and white space from a single
    source file
  - `cloc_reognized_languages`: Return a data frame of ‘cloc’ recognized
    languages and associated extensions

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

git tree (with specific commit)

``` r
cloc_git("~/packages/cloc", "3643cd09d4b951b1b35d32dffe35985dfe7756c4")
#> # A tibble: 4 x 10
#>   source language file_count file_count_pct   loc      loc_pct blank_lines blank_line_pct comment_lines
#>    <chr>    <chr>      <int>          <dbl> <int>        <dbl>       <int>          <dbl>         <int>
#> 1   cloc     Perl          1          0.125 10059 0.9880168942         787    0.933570581          1292
#> 2   cloc Markdown          2          0.250    60 0.0058933307          31    0.036773428             0
#> 3   cloc        R          4          0.500    52 0.0051075533          22    0.026097272            25
#> 4   cloc     YAML          1          0.125    10 0.0009822218           3    0.003558719             1
#> # ... with 1 more variables: comment_line_pct <dbl>
```

Detailed results by file

``` r
# whole dir
str(cloc_by_file(system.file("extdata", package="cloc")))
#> Classes 'tbl_df', 'tbl' and 'data.frame':    3 obs. of  6 variables:
#>  $ source       : chr  "extdata" "extdata" "extdata"
#>  $ filename     : chr  "/Library/Frameworks/R.framework/Versions/3.4/Resources/library/cloc/extdata/qrencoder.cpp" "/Library/Frameworks/R.framework/Versions/3.4/Resources/library/cloc/extdata/dbi.r" "/Library/Frameworks/R.framework/Versions/3.4/Resources/library/cloc/extdata/App.java"
#>  $ language     : chr  "C++" "R" "Java"
#>  $ loc          : int  142 138 8
#>  $ blank_lines  : int  41 24 1
#>  $ comment_lines: int  63 71 4

# single file
str(cloc_by_file(system.file("extdata", "App.java", package="cloc")))
#> Classes 'tbl_df', 'tbl' and 'data.frame':    1 obs. of  6 variables:
#>  $ source       : chr "App.java"
#>  $ filename     : chr "/Library/Frameworks/R.framework/Versions/3.4/Resources/library/cloc/extdata/App.java"
#>  $ language     : chr "Java"
#>  $ loc          : int 8
#>  $ blank_lines  : int 1
#>  $ comment_lines: int 4
```

Recognized languages

``` r
cloc_reognized_languages()
#> # A tibble: 217 x 2
#>              lang             extensions
#>             <chr>                  <chr>
#>  1           ABAP                   abap
#>  2   ActionScript                     as
#>  3            Ada     ada, adb, ads, pad
#>  4      ADSO/IDSM                   adso
#>  5          AMPLE ample, dofile, startup
#>  6            Ant   build.xml, build.xml
#>  7  ANTLR Grammar                  g, g4
#>  8   Apex Trigger                trigger
#>  9 Arduino Sketch               ino, pde
#> 10            ASP               asa, asp
#> # ... with 207 more rows
```

Strip comments and whitespace from individual source files

``` r
cat(
  cloc_remove_comments(system.file("extdata", "qrencoder.cpp", package="cloc"))
)
#> #include <Rcpp.h>
#> #include "qrencode.h"
#> #include <stdio.h>
#> #include <unistd.h>
#> #include <string>
#> #include <fstream>
#> #include <streambuf>
#> using namespace Rcpp;
#> #define INCHES_PER_METER (100.0/2.54)
#> static int rle = 1;
#> static unsigned int fg_color[4] = {0, 0, 0, 255};
#> static unsigned int bg_color[4] = {255, 255, 255, 255};
#> NumericMatrix qrencode_raw(std::string to_encode,
#>                            int version=0,
#>                            int level=0,
#>                            int hint=2,
#>                            int caseinsensitive=1) {
#>   QRcode *qrcode ;
#>   unsigned char *row;
#>   int x, y;
#>   qrcode = QRcode_encodeString(to_encode.c_str(),
#>                                version,
#>                                (QRecLevel)level,
#>                                (QRencodeMode)hint, caseinsensitive);
#>   NumericMatrix qr(qrcode->width, qrcode->width);
#>   for(y=0; y <qrcode->width; y++) {
#>     row = qrcode->data+(y*qrcode->width);
#>     for(x = 0; x < qrcode->width; x++) {
#>       qr(x, y) = row[x]&0x1;
#>     }
#>   }
#>   return(qr);
#> }
#> static FILE *openFile(const char *outfile) {
#>   FILE *fp;
#>   if(outfile == NULL || (outfile[0] == '-' && outfile[1] == '\0')) {
#>     fp = stdout;
#>   } else {
#>     fp = fopen(outfile, "wb");
#>     if (fp == NULL) return(NULL);
#>   }
#>   return fp;
#> }
#> static void writeSVG_writeRect(FILE *fp, int x, int y, int width, char* col, float opacity) {
#>   if(fg_color[3] != 255) {
#>     fprintf(fp, "\t\t\t<rect x=\"%d\" y=\"%d\" width=\"%d\" height=\"1\" "\
#>               "fill=\"#%s\" fill-opacity=\"%f\" />\n",
#>               x, y, width, col, opacity );
#>   } else {
#>     fprintf(fp, "\t\t\t<rect x=\"%d\" y=\"%d\" width=\"%d\" height=\"1\" "\
#>               "fill=\"#%s\" />\n",
#>               x, y, width, col );
#>   }
#> }
#> CharacterVector writeSVG(QRcode *qrcode, int margin, int size, int dpi) {
#>   FILE *fp;
#>   unsigned char *row, *p;
#>   int x, y, x0, pen;
#>   int symwidth, realwidth;
#>   float scale;
#>   char fg[7], bg[7];
#>   float fg_opacity;
#>   float bg_opacity;
#>   char fname[L_tmpnam];
#>   memset(fname, 0, L_tmpnam);
#>   strncpy(fname,"qrencoder-XXXXXX", 16);
#>   fp = openFile(mktemp(fname));
#>   if (fp == NULL) return(R_NilValue);
#>   scale = dpi * INCHES_PER_METER / 100.0;
#>   symwidth = qrcode->width + margin * 2;
#>   realwidth = symwidth * size;
#>   snprintf(fg, 7, "%02x%02x%02x", fg_color[0], fg_color[1],  fg_color[2]);
#>   snprintf(bg, 7, "%02x%02x%02x", bg_color[0], bg_color[1],  bg_color[2]);
#>   fg_opacity = (float)fg_color[3] / 255;
#>   bg_opacity = (float)bg_color[3] / 255;
#>   fputs( "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n", fp );
#>   fprintf( fp, "<!-- Created with qrencode %s (http:
#>            QRcode_APIVersionString() );
#>   fprintf( fp, "<svg width=\"%0.2fcm\" height=\"%0.2fcm\" viewBox=\"0 0 %d %d\""\
#>              " preserveAspectRatio=\"none\" version=\"1.1\""                    \
#>              " xmlns=\"http:
#>              realwidth / scale, realwidth / scale, symwidth, symwidth
#>   );
#>   fputs( "\t<g id=\"QRcode\">\n", fp );
#>   if(bg_color[3] != 255) {
#>     fprintf(fp, "\t\t<rect x=\"0\" y=\"0\" width=\"%d\" height=\"%d\" fill=\"#%s\" fill-opacity=\"%f\" />\n", symwidth, symwidth, bg, bg_opacity);
#>   } else {
#>     fprintf(fp, "\t\t<rect x=\"0\" y=\"0\" width=\"%d\" height=\"%d\" fill=\"#%s\" />\n", symwidth, symwidth, bg);
#>   }
#>   fputs( "\t\t<g id=\"Pattern\">\n", fp);
#>   p = qrcode->data;
#>   for(y=0; y<qrcode->width; y++) {
#>     row = (p+(y*qrcode->width));
#>     if( !rle ) {
#>       for(x=0; x<qrcode->width; x++) {
#>         if(*(row+x)&0x1) {
#>           writeSVG_writeRect(fp, margin + x,
#>                              margin + y, 1,
#>                              fg, fg_opacity);
#>         }
#>       }
#>     } else {
#>       pen = 0;
#>       x0  = 0;
#>       for(x=0; x<qrcode->width; x++) {
#>         if( !pen ) {
#>           pen = *(row+x)&0x1;
#>           x0 = x;
#>         } else {
#>           if(!(*(row+x)&0x1)) {
#>             writeSVG_writeRect(fp, x0 + margin, y + margin, x-x0, fg, fg_opacity);
#>             pen = 0;
#>           }
#>         }
#>       }
#>       if( pen ) {
#>         writeSVG_writeRect(fp, x0 + margin, y + margin, qrcode->width - x0, fg, fg_opacity);
#>       }
#>     }
#>   }
#>   fputs( "\t\t</g>\n", fp );
#>   fputs( "\t</g>\n", fp );
#>   fputs( "</svg>\n", fp );
#>   fclose( fp );
#>   std::ifstream t(fname);
#>   std::string str((std::istreambuf_iterator<char>(t)),
#>                   std::istreambuf_iterator<char>());
#>   t.close();
#>   unlink(fname);
#>   return(Rcpp::wrap(str));
#> }
#> CharacterVector qrencode_svg(
#>     std::string to_encode,
#>     int version=0, int level=0, int hint=2,
#>     int caseinsensitive=1, int margin = 0, int size = 3, int dpi = 72) {
#>   QRcode *qrcode ;
#>   qrcode = QRcode_encodeString(to_encode.c_str(),
#>                                version,
#>                                (QRecLevel)level,
#>                                (QRencodeMode)hint, caseinsensitive);
#>   return(writeSVG(qrcode, margin, size, dpi));
#> }
```

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.
