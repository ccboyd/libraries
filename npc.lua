local npclib = {}

local players = game:GetService"Players"
local http = game:GetService"HttpService"

local animation = "https://raw.githubusercontent.com/redpawed/Public-Links/main/NPC-Animation"
local animationcode

pcall(function()
	animationcode = http:GetAsync(animation)
end)

function npclib.getrandom (parent, rigtype, conditions)
	local description
	local character
	local name
	local id

	local errors = {}

	local suc, er = pcall(function()
		if not conditions then
			id = math.random(10000000, 1000000000)
		else
			id = math.random(conditions[1], conditions[2])
		end

		description = players:GetHumanoidDescriptionFromUserId(id)
		character = players:CreateHumanoidModelFromDescription(description, rigtype)
		name = players:GetNameFromUserIdAsync(id)
	end)

	if suc then
		character.Name = name
		character:PivotTo(CFrame.new(0, 30, 0))

		character:WaitForChild"Humanoid"
		character:WaitForChild"HumanoidRootPart"

		character.Humanoid.DisplayName = name
		character.Parent = parent

		if animationcode then
			NS(animationcode, character)
		end

		return character, id, #errors
	else table.insert(errors, er)
		return npclib.getrandom(parent, rigtype, conditions), id, #errors
	end
end

function npclib.fetch (info, rigtype, parent)
	local description
	local character
	local name

	pcall(function()
		name = players:GetNameFromUserIdAsync(info)
	end)

	if name then
		description = players:GetHumanoidDescriptionFromUserId(info)
	else
		local id = players:GetUserIdFromNameAsync(info)
		name = players:GetNameFromUserIdAsync(id)
		description = players:GetHumanoidDescriptionFromUserId(id)
	end

	character = players:CreateHumanoidModelFromDescription(description, rigtype)

	character.Name = name

	character:WaitForChild"Humanoid"
	character:WaitForChild"HumanoidRootPart"

	character:PivotTo(CFrame.new(0, 30, 0))
	character.Humanoid.DisplayName = name
	character.Parent = parent

	if animationcode then
		NS(animationcode, character)
	end

	return character
end

function npclib.islooking (npc, target)
	local looking = false
	
	local look = npc.Head.CFrame.LookVector
	local difference = (target.Head.Position - npc.Head.Position).Unit
	
	local dot = look:Dot(difference)
	
	if dot > 0.5 then
		looking = true
	end
	
	return looking
end

function npclib.setnetworkowner (npc, player)
	for _, basepart in pairs(npc:GetDescendants()) do
		if basepart:IsA"BasePart" and not basepart.Anchored then
			basepart:SetNetworkOwner(player)
		end
	end
end

return npclib
