# LuaRocks installation

This library is packaged and build using Luarocks, which makes building
and installing easy.

Currently this library is not published on a luarocks server,
so you need to clone this repository and build it yourself:

```
git clone https://github.com/max1220/lua-getch
cd lua-getch
# install locally, usually to ~/.luarocks
luarocks make --local
```

This will install the module locally, typically in ~/.luarocks.



## Adding to LuaRocks modules to package.path

When installing locally you need to tell Lua where to look for modules
installed using Luarocks, e.g.:

```
luarocks path >> ~/.bashrc
```

This will allow you to `require()` and locally installed LuaRocks package.





# Manual installation

As this library is just a single file, you can easily copy the entire
implementation to where it is most useful to you, e.g.:

`cp lua/lua-bitmap/init.lua <your project directory>/lua-bitmap.lua`
