# Examples

There are currently two runnable examples in the `doc/examples` directory:



## bmp2ansi.lua

This example program uses the Bitmap library to read a BMP image
from disk or stdin, then render it using very primitive ANSI art.

Best use this on a terminal that supports 256-color ANSI escape sequences
(most do, even when they only support 8/16 colors, like the Linux console).

It optionally supports 24-bit ANSI color codes(most graphical terminal
emulators work)

### Usage

```
bmp2ansi.lua <input bitmap file> [--24bit]
```

### Example

```
./doc/examples/bmp2ansi.lua doc/examples/images/test_02.bmp --24bit
```



## gen_test_image.lua

This script generates a test image, and saves it as a Bitmap file or to stdout.

### Usage

```
gen_test_image.lua <output bitmap file> [--24bit]
```

### Example

```
./doc/examples/gen_test_image.lua - --24bit | ./examples/bmp2ansi.lua - --24bit
```

