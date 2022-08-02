# Supported Bitmap File Format

The library supports the following subset of the
"Bitmap"(`Windows Bitmap`/`device-independent bitmap`, version 3.0)
file format:

 * 24bpp/32bpp bitmaps only(no 1/2/4/8/16bpp)
 * no bitfields
 * no compression

(This library does *not* support every feature of the bitmap file format.
But it can detect that it doesn't support a file by it's header)



## Exporting using Gimp

You can easily export images using GIMP.

Select `r8 g8 b8` under `Advanced Options` when exporting as `.bmp`.

Under `Compatibility Options` select `Do not write color space information`(It's simply ignored when present).

DO NOT check `Run-length Encoded`, as this library doesn't support it.



## Exporting using ImageMagic

You can also convert images using ImageMagic:
```
convert "source_image.png" -type truecolor "target_image.bmp"
```
