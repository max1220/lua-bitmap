#!/usr/bin/env lua
local Bitmap = require("lua-bitmap")

-- this is a small example script that renders a Windows Bitmap as very primitive ANSI art,
-- using the 256-color(technically 240-color) or 23-bit colors terminal escape sequences.


-- convert a rgb[0-255] value to an ANSI 256-color set background color escape sequence
local function rgb_to_ansi_256(r,g,b)
	if (math.floor(r/11) == math.floor(g/11)) and (math.floor(r/11) == math.floor(b/11)) then
		local grey_level = r/11
		if grey_level < 0.5 then
			-- output black
			return ("\027[48;5;%dm"):format(0)
		elseif grey_level > 23.5 then
			-- output white
			return ("\027[48;5;%dm"):format(15)
		else
			-- output 24-level grey code
			--io.stderr:write("grey level: "..math.floor(grey_level).."\n")
			return ("\027[48;5;%dm"):format(232 + math.floor(grey_level))
		end
	else
		-- output 216-color code(6*6*6)
		r = (r/255)*5
		g = (g/255)*5
		b = (b/255)*5
		local i = (36*math.floor(r)) + (6*math.floor(g)) + math.floor(b)
		return ("\027[48;5;%dm"):format(16 + i)
	end
end

-- convert a rgb[0-255] value to an ANSI 24-bit color set background escape sequence
local function rgb_to_ansi_24bit(r,g,b)
	return ("\027[48;2;%d;%d;%dm"):format(r,g,b)
end

-- print usage information
local function usage()
	print("bmp2ansi.lua <bitmap file> [--24bit]")
	print("You use stdin as input by specifying - as first argument.")
	print()
end

-- check first argument is present
local input_arg = arg[1]
if not input_arg then
	usage()
	print("First argument needs to be an input Windows Bitmap file!")
	os.exit(1)
end

local use_24bit = false
if arg[2] == "--24bit" then
	use_24bit = true
elseif arg[2] or (#arg > 2) then
	usage()
	os.exit(1)
end

-- read a bitmap from file
local bmp,err
if input_arg == "-" then
	bmp,err = Bitmap.from_string(io.read("*a"))
else
	bmp,err = Bitmap.from_file(input_arg)
end
if not bmp then
	print("Bitmap error: "..tostring(err))
	os.exit(1)
end

-- output some info about this bitmap to stdout
local bmp_info = "Bitmap info: width=%d, height=%d, bpp=%d, pixel_offset=%d, topdown=%s\n"
bmp_info = bmp_info:format(bmp.width, bmp.height, bmp.bpp, bmp.pixel_offset, bmp.topdown and "yes" or "no")
io.stderr:write(bmp_info)

for y=0, bmp.height-1 do
	for x=0, bmp.width-1 do
		local r,g,b,a = bmp:get_pixel(x,y)
		if a == 0 then
			io.write("\027[0m")
		elseif r and use_24bit then
			io.write(rgb_to_ansi_24bit(r,g,b))
		elseif r then
			io.write(rgb_to_ansi_256(r,g,b))
		end
		io.write(" ")
	end
	io.write("\027[0m\n")
end
io.flush()
