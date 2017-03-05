lua-bitmap
==========

Read 24bpp uncompressed Bitmaps from pure Lua.


Install
-------

Copy to somewhere in Lua's search path:

`lua -e "print(package.path:gsub(';', '\n'))"`



Usage
-----

Coordinates are 0-indexed.

command | description
--- | ---
bmp = bitmap.from_file(path)       | Read content from file and return as bmp instance.
bmp = bitmap.from_string(data)     | Read content from and return as bmp instance.
r,g,b = bmp:get_pixel(x,y,r,g,b)   | Get pixel at x,y. r,g,b are 0-255
bmp:set_pixel(x,y,r,g,b)           | Set pixel at x,y to r,g,b(0-255)
bmp:write_to_file(path)            | Dump bitmap to file
bmp:to_string()                    | Get bitmap as string
tbl = bmp:get_rect(x,y,w,h)        | Get a rectangle of pixels. r,g,b = unpack(tbl[y][x])
