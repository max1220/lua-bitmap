#!/usr/bin/env lua
--[[
This file tests the functions used internally to read/write
integer values from the bitmap.
]]

local Bitmap = require("lua-bitmap")

-- create a new bitmap structure, but don't create header
-- (create uninitialized bmp structure)
local bmp,err = Bitmap._new_bitmap()
if not bmp then
	print("Bitmap error: ", tostring(err))
	os.exit(1)
end

-- pre-initialize data to 0
local data_len_k = tonumber(arg[1]) or 1000
bmp.data = {}
for i=1, data_len_k*1000 do
	bmp.data[i-1] = "\000"
end

-- perform a simple write-then-read test
local function test_func(read_func, write_func, addr, value)
	write_func(bmp, addr, value)
	local read_value = read_func(bmp, addr)
	if read_value ~= value then
		print("FAILED")
		print()
		os.exit(1)
	end
end

-- provide the test values for different bytes per integer values
local function test_func_list(sign, read_func, write_func, bytes)
	-- repeat test in every location in the first 1k of memory
	for addr=0, 996 do
		test_func(read_func, write_func, addr, 0)
		test_func(read_func, write_func, addr, sign*1)
		test_func(read_func, write_func, addr, sign*2)

		test_func(read_func, write_func, addr, sign*253)
		test_func(read_func, write_func, addr, sign*254)
		test_func(read_func, write_func, addr, sign*255)

		if bytes > 1 then
			test_func(read_func, write_func, addr, sign*256)
			test_func(read_func, write_func, addr, sign*257)
			test_func(read_func, write_func, addr, sign*258)

			test_func(read_func, write_func, addr, sign*65533)
			test_func(read_func, write_func, addr, sign*65534)
			test_func(read_func, write_func, addr, sign*65535)
		end

		if bytes>2 then
			test_func(read_func, write_func, addr, sign*65536)
			test_func(read_func, write_func, addr, sign*65537)
			test_func(read_func, write_func, addr, sign*65538)

			test_func(read_func, write_func, addr, sign*2147483645)
			test_func(read_func, write_func, addr, sign*2147483646)
			test_func(read_func, write_func, addr, sign*2147483647)
		end
	end
end


-- run the tests for the supported data types word, dword, long
print("running int tests, data size="..data_len_k.."K")

test_func_list(1, bmp.read_long, bmp.write_long, 4)
test_func_list(-1, bmp.read_long, bmp.write_long, 4)

test_func_list(1, bmp.read_dword, bmp.write_dword, 4)

test_func_list(1, bmp.read_word, bmp.write_word, 2)


-- provide wrapper for byte_write(write accepts numeric value, test provides strings)
local function byte_write(self, addr, val)
	self:write(addr, string.char(val), 1)
end
test_func_list(1, bmp.read, byte_write, 1)

-- if we made it here, we didn't error! (this is good)
print("all ok")
