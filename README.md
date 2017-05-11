# yue-public
Extract historical prices in Lua from the web automatically

The original code of the historical price extraction was in PHP. In 2016, I started learning Lua and I rewrote the code in Lua. As I'm a developer of Java, ColdFusion, C# and Python, the style looks different from the traditional way of Lua.

The master branch is in AWS CodeCommit but the code is untidy and messy. I'm refactoring code. I'll push the to GitHub gradually.

The code depends on these Lua packages:
```shell
luarocks install classic
luarocks install date
luarocks install dkjson
luarocks install lua-curl
luarocks install luaunit # if you want to run unit testing
luarocks install luasql-mysql
luarocks install web_sanitize