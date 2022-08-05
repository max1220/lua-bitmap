# lua-bitmap

This single-file Lua-only library implements basic read/write support
for a subset of the `Windows Bitmap`/`device-independent bitmap`
file format, version 3.0.

Compatible with Lua5.1, LuaJIT, Lua5.2, Lua5.3, Lua5.4.



## Supported file format

`Windows Bitmap`/`device-independent bitmap`, version 3.0,

 * 24bpp/32bpp bitmaps only(no 1/2/4/8/16bpp)
 * no bitfields
 * no compression

See [doc/FILE_FORMAT.md](doc/FILE_FORMAT.md)


## Library usage

Library usage is documented in `doc/USAGE.md`.

Example:

```
local Bitmap = require("lua-bitmap") -- load module
local bmp = Bitmap.empty_bitmap(width, height, alpha)
--local bmp = Bitmap.from_string(data)
--local bmp = Bitmap.from_file(path)
--local bmp = Bitmap._new_bitmap()
r,g,b,a = bmp:get_pixel(x,y) -- get color value at x,y
bmp:set_pixel(x,y,r,g,b,a) -- set pixel at x,y to r,g,b,a[0-255]
```

See [doc/USAGE.md](doc/USAGE.md)



## Installation

The LuaRocks module is not published on a rocks server yet.

See [doc/INSTALLATION.md](doc/INSTALLATION.md)



## Examples

There are currently two runnable examples, `bmp2ansi.lua` coverts a
bitmap to primitive ASCII art, and `gen_test_image.lua` generates a
simple bitmap with a test pattern.

bmp2ansi.lua: [doc/examples/bmp2ansi.lua](doc/examples/bmp2ansi.lua)
gen_test_image.lua: [doc/examples/gen_test_image.lua](doc/examples/gen_test_image.lua)

See [doc/EXAMPLES.md](doc/EXAMPLES.md)
