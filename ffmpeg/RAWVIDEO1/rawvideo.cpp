// ffmpeg -i _SOURCE_ -f rawvideo -pix_fmt rgb32 - | ./rawvideo | ffmpeg -f rawvideo -pix_fmt rgb32 -i - rtmp://broadcast.to.server/
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
int main () {
  // allocate variables and buffer
  uint8_t *pixels = (uint8_t*)malloc (147456);
  uint8_t *pix;
  int q;
  while (1) {
    // read frame
    if (fread (pixels, 1,147456, stdin) <= 0) {break;}
    // process image
    pix = pixels;
    for (q = 0; q <49152; q ++) {
        *pix++ = *pix * 2; // multiple red to 2
        *pix++ = *pix + 120; // shift green channel
        *pix++ = *pix + q / 10; // lines in blue channel
    }
    // write frame back
    fwrite (pixels, 1,147456, stdout);
    }
    return EXIT_SUCCESS;
}
