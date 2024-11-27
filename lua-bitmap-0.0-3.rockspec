package = "lua-bitmap"
version = "0.0-3"
source = {
	url = "git://github.com/max1220/lua-bitmap",
	tag = "0.0-3"
}
description = {
	summary = "Basic read/write support for `Windows Bitmap`/`device-independent bitmap` file format(version 3.0)",
	detailed = [[
		This single-file Lua-only library implements basic read/write support for the
		`Windows Bitmap`/`device-independent bitmap` file format(version 3.0).

		Compatible with Lua5.1, LuaJIT, Lua5.2, Lua5.3, Lua5.4.
	]],
	homepage = "http://github.com/max1220/lua-bitmap",
	license = "MIT"
}
dependencies = {
	"lua >= 5.1"
}
build = {
	type = "builtin",
	modules = {},
	test = {
		type = "command",

		-- Let's hope that the lua version is the one we install for...
		-- TODO: Is there a better way of doing this?
		script = "lua -l 'lua-bitmap.test_ints' -e 'print(\"ok\")'",
	}
}
