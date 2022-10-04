# libraries
this repository is a collection and list of libraries i've either written or decided to collect. libraries will primarily be made for luau.

# function
luau libraries can be fetched with roblox's http library and the loadstring method.

```lua
function getlib (link)
	local http = game:GetService"HttpService"
	local lib = loadstring(http:GetAsync(link))()

	return lib
end
```
