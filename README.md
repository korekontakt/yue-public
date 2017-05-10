# yue-public
Extract historical prices in Lua from the web automatically

The origina of the extraction of historical prices were in PHP. In 2016, I started learning Lua and I rewrote my code in Lua.

The master branch is in AWS CodeCommit but the code is untidy and messy. I'm refactoring code and push it to GitHub.

The code depends on these Lua packages:
```shell
luarocks install date
luarocks install classic
luarocks install web_sanitize
luarocks install lua-curl
luarocks install dkjson
luarocks install luasql-mysql
