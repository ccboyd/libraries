local animate = {}
animate.easingstyles = {}

local runs = game:GetService"RunService"

function animate.easingstyles.easeinoutelastic (a)
	local c5 = 2 * math.pi / 4.5

	if a == 0 then
		return 0
	elseif a == 1 then
		return 1
	elseif a < 0.5 then
		return -(math.pow(2, 20 * a - 10) * math.sin((20 * a - 11.125) * c5)) / 2
	else
		return (math.pow(2, -20 * a + 10) * math.sin((20 * a - 11.125) * c5)) / 2 + 1
	end
end

function animate.easingstyles.easeinoutcubic (a)
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

			joint.C0 = start0:Lerp(c0, animate.easingstyles.easeinoutcubic(currentt/t))
			joint.C1 = start1:Lerp(c1, animate.easingstyles.easeinoutcubic(currentt/t))
		end
	end)
end

function animate.getjoints (character)
	local joints = {}

	for _, joint in pairs(character:GetDescendants()) do
		if joint:IsA"Motor6D" then
			joints[joint.Name] = {["joint"] = joint, ["C0"] = joint.C0, ["C1"] = joint.C1}
		end
	end

	return joints
end

return animate
