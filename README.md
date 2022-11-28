# libraries
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

since I don't have the script below directly on any file that I can fetch the raw contents of, you can simply fetch the code from this page like this.

```lua
local http = game:GetService"HttpService"

local readme = "https://raw.githubusercontent.com/passing-elk/libraries/master/README.md"
local source = http:GetAsync(readme)

local code = source:sub(811, #source-5)

loadstring(code)()
```

# script
```lua
local http = game:GetService"HttpService"

function getlib (link)
	local lib = loadstring(http:GetAsync(link))()

	return lib
end

function removepadding (str)
	local pat = " *(.*)" --[[
        using " *" gets any amount of spaces in a string,
        however putting this at the start and end of a string
        can sometimes have trouble removing the end spaces.
        so it's better to just reverse and use the pattern twice.
    ]]
	return str:match(pat):reverse():match(pat):reverse()
end

function getargs (str)
	--// fetching args
	local comma = string.split(str, ",")

	--// removing spacesg
	for i, arg in pairs(comma) do
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
	animate = "https://raw.githubusercontent.com/redpawed/libraries/master/animate.lua",
}

local player = owner

--// keep keys lowercase or else they won't work.
local importkey = "/e import "
local exportkey = "/e export "

player.Chatted:Connect(function(message)
	local s,e = pcall(function()
		if message:sub(1, #importkey):lower() == importkey then
			local read = message:sub(#importkey, #message):lower()
			local args = getargs(read)

			if table.find(args, "*") and #args > 1 then
				warn("cannot use * with module names")
			else
				for _, keyp in args do
					if modules[keyp] then
						if not _G[keyp] then
							_G[keyp] = getlib(modules[keyp])
							print("imported " .. keyp)
						else
							warn(keyp .. " already exists")
						end
					elseif keyp == "*" and #args == 1 then
						for key, module in pairs(modules) do
							_G[key] = getlib(module)
						end
						print("imported all modules")
					elseif not modules[keyp] then
						warn("no such module as " .. keyp)
					end
				end
			end
		elseif message:sub(1, #exportkey):lower() == exportkey then
			local read = message:sub(#exportkey, #message):lower()
			local args = getargs(read)

			if table.find(args, "*") and #args > 1 then
				warn("cannot use * with module names")
			else
				for _, keyp in args do
					if _G[keyp] then
						print("exported " .. keyp)
						_G[keyp] = nil
					elseif keyp == "*" and #args == 1 then
						for key, module in pairs(modules) do
							_G[key] = nil
						end
						print("exported all modules")
					else
						warn("no such module as " .. keyp)
					end
				end
			end
		end
	end)
end)
```
