# modules
this repository is a collection and list of libraries and modules i've either written or decided to collect. libraries will primarily be made for luau.

# function
luau libraries can be fetched with roblox's http library and the loadstring method.

```lua
function getlib (link)
	local http = game:GetService"HttpService"
	local lib = loadstring(http:GetAsync(link))()

	return lib
end
```

# script
script made for importing listed modules directly into the global table `_G`

```lua
function getlib (link)
	local http = game:GetService"HttpService"
	local lib = loadstring(http:GetAsync(link))()

	return lib
end

function removepadding (str)
	local pat = " *(.*)"
	return str:match(pat):reverse():match(pat):reverse()
end

function getargs (str)
	--// fetching args
	local comma = string.split(str, ",")

	--// removing spacesg
	for i, arg in pairs(comma) do
		local pat = " *(.*)" --[[
			using " *" gets any amount of spaces in a string,
			however putting this at the start and end of a string
			can sometimes have trouble removing the end spaces.
			so it's better to just reverse and use the pattern twice.
		]]

		comma[i] = removepadding(arg)
	end

	--// returning args
	return comma
end

local modules = {
	npc = "https://raw.githubusercontent.com/redpawed/libraries/main/npc.lua",
	fione = "https://raw.githubusercontent.com/redpawed/libraries/main/fione.lua",
	yueliang = "https://raw.githubusercontent.com/redpawed/libraries/main/yueliang.lua",
	loadstring = "https://raw.githubusercontent.com/redpawed/libraries/main/loadstring.lua",
}

local player = owner

--// keep keys lowercase or else they won't work.
local importkey = "import "
local exportkey = "export "

player.Chatted:Connect(function(message)
	local s,e = pcall(function()
		if message:sub(1, #importkey):lower() == importkey then
			local read = message:sub(#importkey, #message):lower()

			for _, keyp in getargs(read) do
				if modules[keyp] then
					print("imported " .. keyp)
					_G[keyp] = getlib(modules[keyp])
				else
					warn("no such module as " .. keyp)
				end
			end
		elseif message:sub(1, #exportkey):lower() == exportkey then
			local read = message:sub(#importkey, #message):lower()

			for _, keyp in getargs(read) do
				if _G[keyp] then
					print("exported " .. keyp)
					_G[keyp] = nil
				else
					warn("no such module as " .. keyp)
				end
			end
		end
	end)
end)
```
