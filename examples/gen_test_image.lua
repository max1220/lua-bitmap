#!/usr/bin/env lua
--[[
This is a small example script that generates a simple
test image and saves it as Windows Bitmap.
]]
local Bitmap = require("bitmap")


-- print usage information
local function usage()
	print("gen_test_image.lua <bitmap file>")
	print("You use stdin as output by specifying - as first argument.")
end

-- check first argument is present
local output_arg = arg[1]
if not output_arg then
	usage()
	print("First argument needs to be an output file!")
	os.exit(1)
end


-- create new empty bitmap(initialized to black)
local width = 64
local height = 64
local bmp,err = Bitmap.empty_bitmap(width, height, false)
if not bmp then
	print("Bitmap error: ", tostring(err))
	os.exit(1)
end

-- create border around outside:
for x=1, width-2 do
	bmp:set_pixel(x,0,255,0,0,255)
	local grey = math.floor(255*((x-1)/(width-2)))
	bmp:set_pixel(x,height-1,grey,grey,grey,255)
end
for y=1, height-2 do
	bmp:set_pixel(0,y,0,255,0,255)
	bmp:set_pixel(width-1,y,0,0,255,255)
end

local _unpack = table.unpack or unpack

-- resolve a number to a list of active segments
local segments = {
	[0] = { true,  true,  true, false,  true,  true,  true},
	[1] = {false, false,  true, false, false,  true, false},
	[2] = { true, false,  true,  true,  true, false,  true},
	[3] = { true, false,  true,  true, false,  true,  true},
	[4] = {false,  true,  true,  true, false,  true, false},
	[5] = { true,  true, false,  true, false,  true,  true},
	[6] = { true,  true, false,  true,  true,  true,  true},
	[7] = { true, false,  true, false, false,  true, false},
	[8] = { true,  true,  true,  true,  true,  true,  true},
	[9] = { true,  true,  true,  true, false,  true, false},
	[" "] = {false, false, false, false, false, false, false},
	["-"] = {false, false, false, true, false, false, false},
	["_"] = {false, false, false, false, false, false,  true},
	["="] = {false, false, false,  true, false, false,  true},
	["H"] = {false,  true,  true,  true,  true,  true, false},
	["E"] = { true,  true, false,  true,  true, false,  true},
	["L"] = {false,  true, false, false,  true, false,  true},
	["O"] = { true,  true,  true, false,  true,  true,  true},
}
-- draw a 4x7px 7-segment number value v at offset_x,offset_y, in color r,g,b,a on bmp
local function seg7(target, offset_x, offset_y, v, r,g,b,a)
	local function vpx(x,y)
		target:set_pixel(offset_x+x,offset_y+y,r,g,b,a)
		target:set_pixel(offset_x+x+1,offset_y+y,r,g,b,a)
	end
	local function hpx(x,y)
		target:set_pixel(offset_x+x,offset_y+y,r,g,b,a)
		target:set_pixel(offset_x+x,offset_y+y+1,r,g,b,a)
	end
	local s1,s2,s3,s4,s5,s6,s7 = _unpack(segments[v] or segments[" "])
	if s1 then vpx(1,0) end
	if s2 then hpx(0,1) end
	if s3 then hpx(3,1) end
	if s4 then vpx(1,3) end
	if s5 then hpx(0,4) end
	if s6 then hpx(3,4) end
	if s7 then vpx(1,6) end
end
local function seg7_str(target, offset_x, offset_y, str, r,g,b,a)
	for i=1, #str do
		local n = str:sub(i,i)
		n = tonumber(n) or n
		if n then
			seg7(target, offset_x, offset_y, n, r,g,b,a)
			offset_x = offset_x + 5
		end
	end
end

seg7_str(bmp, 7,2,  "0123456789", 0xFF,0xFF,0xFF, 0xFF)
seg7_str(bmp, 19,10, "HELLO", 0xFF,0x00,0x00, 0xFF)
seg7_str(bmp, 7,18, os.date("%d_%m_%Y"), 0x00,0xFF,0x00, 0xFF)
seg7_str(bmp, 12,26, os.date("%H=%M=%S"), 0x00,0x00,0xFF, 0xFF)

local output_file = io.stdout
if output_arg ~= "-" then
	output_file = io.open(output_arg, "wb")
end
local bmp_data = bmp:tostring()
output_file:write(bmp_data)
