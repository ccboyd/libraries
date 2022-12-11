local cloneables = {}

function findclassintable (classname)
	for _, v in pairs(cloneables) do
		if v:IsA (classname) then
			return v
		end
	end
end

function create (classname, parent)
	local existing = findclassintable(classname)
	local new
	
	if existing then
		new = script.Clone(existing)
	else
		local instance = Instance.new (classname)
		table.insert(cloneables, instance)
		
		new = script.Clone(instance)
	end
	
	new.Parent = parent
	
	return new
end

return create
