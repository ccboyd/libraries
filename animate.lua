local animate = {}

local runs = game:GetService"RunService"

function easeinoutcubic (a)
	if a < 0.5 then
		return 4 * a * a * a
	else
		return 1 - (-2 * a + 2) ^ 2 / 2
	end
end

function animate.lerpjoint (joint, c0, c1, t)
	local currentt = 0

	local start0 = joint.C0
	local start1 = joint.C1
	
	task.spawn(function()
		while currentt <= t do
			currentt = currentt + runs.Heartbeat:Wait()
			
			joint.C0 = start0:Lerp(c0, easeinoutcubic(currentt/t))
			joint.C1 = start1:Lerp(c1, easeinoutcubic(currentt/t))
		end
	end)
end

function animate.lerppart (part, cframe, t)
	local currentt = 0

	local start = part.CFrame

	task.spawn(function()
		while currentt <= t do
			currentt = currentt + runs.Heartbeat:Wait()

			part.CFrame = start:Lerp(cframe, currentt/t)
		end
	end)
end

function animate.getjoints (character)
	local joints = {}

	for _, joint in pairs(character:GetDescendants()) do
		if joint:IsA"Motor6D" then
			joints[joint.Name] = joint
		end
	end

	return joints
end

return animate
