#include <Rcpp.h>
#include "qrencode.h"
#include <stdio.h>
#include <unistd.h>
#include <string>
#include <fstream>
#include <streambuf>
using namespace Rcpp;
#define INCHES_PER_METER (100.0/2.54)
static int rle = 1;
static unsigned int fg_color[4] = {0, 0, 0, 255};
static unsigned int bg_color[4] = {255, 255, 255, 255};
NumericMatrix qrencode_raw(std::string to_encode,
                           int version=0,
                           int level=0,
                           int hint=2,
                           int caseinsensitive=1) {
  QRcode *qrcode ;
  unsigned char *row;
  int x, y;
  qrcode = QRcode_encodeString(to_encode.c_str(),
                               version,
                               (QRecLevel)level,
                               (QRencodeMode)hint, caseinsensitive);
  NumericMatrix qr(qrcode->width, qrcode->width);
  for(y=0; y <qrcode->width; y++) {
    row = qrcode->data+(y*qrcode->width);
    for(x = 0; x < qrcode->width; x++) {
      qr(x, y) = row[x]&0x1;
    }
  }
  return(qr);
}
static FILE *openFile(const char *outfile) {
  FILE *fp;
  if(outfile == NULL || (outfile[0] == '-' && outfile[1] == '\0')) {
    fp = stdout;
  } else {
    fp = fopen(outfile, "wb");
    if (fp == NULL) return(NULL);
  }
  return fp;
}
static void writeSVG_writeRect(FILE *fp, int x, int y, int width, char* col, float opacity) {
  if(fg_color[3] != 255) {
    fprintf(fp, "\t\t\t<rect x=\"%d\" y=\"%d\" width=\"%d\" height=\"1\" "\
              "fill=\"#%s\" fill-opacity=\"%f\" />\n",
              x, y, width, col, opacity );
  } else {
    fprintf(fp, "\t\t\t<rect x=\"%d\" y=\"%d\" width=\"%d\" height=\"1\" "\
              "fill=\"#%s\" />\n",
              x, y, width, col );
  }
}
CharacterVector writeSVG(QRcode *qrcode, int margin, int size, int dpi) {
  FILE *fp;
  unsigned char *row, *p;
  int x, y, x0, pen;
  int symwidth, realwidth;
  float scale;
  char fg[7], bg[7];
  float fg_opacity;
  float bg_opacity;
  char fname[L_tmpnam];
  memset(fname, 0, L_tmpnam);
  strncpy(fname,"qrencoder-XXXXXX", 16);
  fp = openFile(mktemp(fname));
  if (fp == NULL) return(R_NilValue);
  scale = dpi * INCHES_PER_METER / 100.0;
  symwidth = qrcode->width + margin * 2;
  realwidth = symwidth * size;
  snprintf(fg, 7, "%02x%02x%02x", fg_color[0], fg_color[1],  fg_color[2]);
  snprintf(bg, 7, "%02x%02x%02x", bg_color[0], bg_color[1],  bg_color[2]);
  fg_opacity = (float)fg_color[3] / 255;
  bg_opacity = (float)bg_color[3] / 255;
  fputs( "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n", fp );
  fprintf( fp, "<!-- Created with qrencode %s (http:
           QRcode_APIVersionString() );
  fprintf( fp, "<svg width=\"%0.2fcm\" height=\"%0.2fcm\" viewBox=\"0 0 %d %d\""\
             " preserveAspectRatio=\"none\" version=\"1.1\""                    \
             " xmlns=\"http:
             realwidth / scale, realwidth / scale, symwidth, symwidth
  );
  fputs( "\t<g id=\"QRcode\">\n", fp );
  if(bg_color[3] != 255) {
    fprintf(fp, "\t\t<rect x=\"0\" y=\"0\" width=\"%d\" height=\"%d\" fill=\"#%s\" fill-opacity=\"%f\" />\n", symwidth, symwidth, bg, bg_opacity);
  } else {
    fprintf(fp, "\t\t<rect x=\"0\" y=\"0\" width=\"%d\" height=\"%d\" fill=\"#%s\" />\n", symwidth, symwidth, bg);
  }
  fputs( "\t\t<g id=\"Pattern\">\n", fp);
  p = qrcode->data;
  for(y=0; y<qrcode->width; y++) {
    row = (p+(y*qrcode->width));
    if( !rle ) {
      for(x=0; x<qrcode->width; x++) {
        if(*(row+x)&0x1) {
          writeSVG_writeRect(fp,	margin + x,
                             margin + y, 1,
                             fg, fg_opacity);
        }
      }
    } else {
      pen = 0;
      x0  = 0;
      for(x=0; x<qrcode->width; x++) {
        if( !pen ) {
          pen = *(row+x)&0x1;
          x0 = x;
        } else {
          if(!(*(row+x)&0x1)) {
            writeSVG_writeRect(fp, x0 + margin, y + margin, x-x0, fg, fg_opacity);
            pen = 0;
          }
        }
      }
      if( pen ) {
        writeSVG_writeRect(fp, x0 + margin, y + margin, qrcode->width - x0, fg, fg_opacity);
      }
    }
  }
  fputs( "\t\t</g>\n", fp );
  fputs( "\t</g>\n", fp );
  fputs( "</svg>\n", fp );
  fclose( fp );
  std::ifstream t(fname);
  std::string str((std::istreambuf_iterator<char>(t)),
                  std::istreambuf_iterator<char>());
  t.close();
  unlink(fname);
  return(Rcpp::wrap(str));
}
CharacterVector qrencode_svg(
    std::string to_encode,
    int version=0, int level=0, int hint=2,
    int caseinsensitive=1, int margin = 0, int size = 3, int dpi = 72) {
  QRcode *qrcode ;
  qrcode = QRcode_encodeString(to_encode.c_str(),
                               version,
                               (QRecLevel)level,
                               (QRencodeMode)hint, caseinsensitive);
  return(writeSVG(qrcode, margin, size, dpi));
}
