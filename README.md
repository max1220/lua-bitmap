# lua-bitmap

This single-file Lua-only library implements basic read/write support for the
`Windows Bitmap`/`device-independent bitmap` file format(version 3.0).

Compatible with Lua5.1, LuaJIT, Lua5.2, Lua5.3, Lua5.4.



## Supported Bitmaps

 * 24bpp/32bpp bitmaps only(no 1/2/4/8/16bpp)
 * no bitfields
 * no compression

You can easily export images using GIMP.

Select `r8 g8 b8` under `Advanced Options` when exporting as `.bmp`.

Under `Compatibility Options` select `Do not write color space information`(It's simply ignored when present).

DO NOT check `Run-length Encoded`, as this library doesn't support it.

You can also convert images using ImageMagic:
```
convert "source_image.png" -type truecolor "target_image.bmp"
```


## Install

Copy the `bitmap.lua` file to somewhere in the Lua `package` search path.

To print your package search path, you can use;
```
lua -e "print((package.path:gsub(';', '\n')))"
```


## Examples
You can use the examples without installing the library because by default `.` is included in Lua's `package.path`.

There are currently 3 runnable examples:



### bmp2ansi.lua

This example program uses the Bitmap library to read an image
from disk or stdin, then render it using very primitive ANSI art.

Best use this on a terminal that supports 256-color ANSI escape sequences
(most do, even when they only support 8/16 colors, like the Linux console).

```
./examples/bmp2ansi.lua <input bitmap file> [--24bit]
```
E.g.
```
./examples/bmp2ansi.lua images/test_02.bmp --24bit
```



### gen_test_image.lua

This script generates a test image, and saves it as a Bitmap file or to stdout.

```
./examples/gen_test_image.lua <output bitmap file> [--24bit]
```
```
./examples/gen_test_image.lua - | ./examples/bmp2ansi.lua - --24bit
```


### test_ints.lua

This is a simple test of the functions for reading data from
the bitmap header, specifically decoding the integer formats found in
bitmaps(8bit, 16-bit- 32bit unsigned integers, 32-bit twos-complement signed integers).

It might be useful if you're replacing the `bmp:write()` and `bmp:read()`
functions.
It also serves as a simple benchmark of these functions by calling them repeatedly.

(For most users this is of little use)

```
./examples/test_ints.lua <data size in K>
```
E.g.
```
time ./examples/test_ints.lua 1000
```



## Library Usage

After installing the library, you can load this library using:
```
Bitmap = require("bitmap")
```

The returned table(`Bitmap` in the example above) contains three functions:
```
bmp = Bitmap.empty_bitmap(width, height, alpha)
bmp = Bitmap.from_string(data)
bmp = Bitmap.from_file(path)
bmp = Bitmap._new_bitmap()
```

Each of these functions returns a table representing a single Bitmap image.



### bmp, err = Bitmap.empty_bitmap(width, height, alpha)

This function creates a new bitmap of the specified dimensions.
If alpha is truethy the bits per pixel value is set to 32, otherwise
the default of 24 will be used.

Keep in mind that Bitmap Version 3.0 does not officially support an alpha-channel.

The initial background is black, or transparent if alpha is present (r=0, g=0, b=0, a=0).



### bmp, err = Bitmap.from_string(string)

Load a bitmap from a string. The string must include the entire bitmap, as it
would be read from disk(including headers).

When passing this to C, keep in mind that this string almost always includes `\000`s
(lua handles strings with embedded zeros just fine).



### bmp, err = Bitmap.from_file(path)

This function loads a bitmap from a filepath.
This basically does: `return Bitmap.from_string(io.open(path, "r"):read("*a"))`,
but with better error handling.



### bmp = Bitmap._new_bitmap()

This just returns a table with the bitmap functions, *without* initializing it by
reading headers, or generating headers for new empty bitmaps.

After creating a pre-filled `bmp.data` table, you need to at least provide the `bmp.pixel_offset` value(Usually 54) before calling the `bmp:write_header(width, height, bpp)` function to write a valid bitmap header and populate the internal state.



### bmp functions

The table returned by the 4 functions
`Bitmap.empty_bitmap, Bitmap.from_string, Bitmap.from_file, Bitmap._new_bitmap`
(here called `bmp`) supports the following functions
for working with bitmap image data:

The `a` alpha-value argument to functions is always optional and defaults to 255.
If the bitmap does not support the alpha channel, `nil` is returned as `a` for the alpha-value.

function | description
--- | ---
r,g,b,a = bmp:get_pixel(x,y) | get color value at x,y
bmp:set_pixel(x,y,r,g,b,a)   | set pixel at x,y to r,g,b,a[0-255]
bmp:tostring()               | get bitmap as string

#### Internal functions

Besides these graphics related functions, the returned `bmp` table also contains
some functions used for parsing and creating header data.

Bitmaps use two's complement little endian integers for header data.
These are functions for reading such values in Lua:

`offset` is zero-based.

function | description
--- | ---
bmp:read_header()                    | read the headers, and update internal state from the internal data.
bmp:write_header(width, height, bpp) | write the header using the specified information, the re-read header using `bmp:read_header()`
val = bmp:read(offset)               | read uint8
val = bmp:read_word(offset)          | read uint16
val = bmp:read_dword(offset)         | read uint32
val = bmp:read_long(offset)          | read int32
bmp:write(offset, data)              | write uint8 * (#data can be >1)
bmp:write_word(offset, val)          | write uint16
bmp:write_dword(offset, val)         | write uint32
bmp:write_long(offset, val)          | write int16

The library expects the `bmp.data` field to
be a table, where indexing with an offset(0-based) results in a single character(`assert(#bmp.data[index]==1)`).

The write functions will refuse to create a new index in the data table, so you need to pre-initialize `bmp.data` before use, e.g.:

```
bmp.data = {}
for i=1, len do
	bmp.data[i-1] = "\000"
end
```
