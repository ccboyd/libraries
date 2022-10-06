local easingstyles = {}

function easingstyles.easeinoutelastic (a)
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

function easingstyles.easeinoutcubic (a)
	if a < 0.5 then
		return 4 * a * a * a
	else
		return 1 - (-2 * a + 2) ^ 2 / 2
	end
end

return easingstyles
