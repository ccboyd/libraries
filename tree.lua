local TreeGrowth = {};

local rand = math.random;

function GrowBranch (root, minimumAmount, maximumAmount, copy_, t:{thickness:height}, leaves_)
	local amount = rand(minimumAmount, maximumAmount);
	local quarter = amount / 4;
	
	local woodMaterial = Enum.Material.Wood;
	local woodBrickColor = BrickColor.new("Brown");
	
	local leafMaterial = Enum.Material.Grass;
	local leafBrickColor = BrickColor.new("Forest green");
	local leafTransparency = 0.15;
	
	local thickness, thicknessDecrease = nil, 0.2
	local height, heightIncrease = t[2], 0
	
	if copy_ then
		thickness = root.Size.X;
	else
		thickness = t[1];
	end
	
	local minimumAngle, maximumAngle = -45, 45
	
	local previous;
	local base;
	local tip;
	
	for index = 1, amount do
		if not previous then
			-- Quick variable
			tip = false;
			
			-- Creating base branch
			local baseBranch = Instance.new("Part", root);
			baseBranch.Name = "BaseBranch";
			baseBranch.Anchored = true;
			baseBranch.Material = woodMaterial;
			baseBranch.BrickColor = woodBrickColor;
			
			-- Important Positioning:
			baseBranch.Size = Vector3.new(thickness, 0, thickness);
			baseBranch.Position = root.Position + root.CFrame.UpVector * root.Size.Y / 2;
			baseBranch.Orientation = root.Orientation;
			baseBranch.Size += Vector3.new(0, height, 0);
			baseBranch.Position += baseBranch.CFrame.UpVector * height / 2;
			
			previous = baseBranch;
			base = baseBranch;
		else
			-- Just tweaking values, leave it there
			thickness -= thicknessDecrease;
			height += heightIncrease;
			
			if thickness < 0.05 then
				print("Thickness: ".. thickness.. " too low, loop broken.");
				tip = true;
				break;
			end
			
			-- Creating more branches
			local branch = Instance.new("Part", previous);
			-- Naming it appropriately
			if index > quarter and index < (quarter * 3) then
				branch.Name = "MiddleBranch";
			elseif index > (quarter * 3) then
				branch.Name = "UpperBranch";
			elseif index < quarter then
				branch.Name = "LowerBranch";
			elseif index == amount then
				branch.Name = "Tip";
			end
			if tip then
				branch.Name = "Tip";
			end
			
			branch.Anchored = true;
			branch.Material = woodMaterial;
			branch.BrickColor = woodBrickColor;
			
			-- Important Positioning:
			branch.Size = Vector3.new(thickness, 0, thickness);
			branch.Position = previous.Position + previous.CFrame.UpVector * previous.Size.Y / 2;
			branch.Orientation += Vector3.new(rand(minimumAngle, maximumAngle), rand(minimumAngle, maximumAngle), rand(minimumAngle, maximumAngle));
			branch.Size += Vector3.new(0, height, 0);
			branch.Position += branch.CFrame.UpVector * height / 2;
			
			-- Creating leaves
			if leaves_ then
				if branch.Name == "UpperBranch" or branch.Name == "Tip" then
					local leaf = Instance.new("Part", branch);
					leaf.Name = "Leaf";
					leaf.Anchored = true;
					leaf.CanCollide = false;
					leaf.Transparency = leafTransparency;
					leaf.Material = Enum.Material.Grass;
					leaf.BrickColor = BrickColor.new("Earth green");
					leaf.Size = Vector3.new(thickness * 18, height, thickness * 18);
					leaf.CFrame = branch.CFrame;
					leaf.Position += leaf.CFrame.UpVector * height;
				end
			end
			
			previous = branch;
		end
	end
	
	return base;
end

function TreeGrowth.GrowSmall (t, leaves_)
	for _, root in pairs(t) do
		local sprout = GrowBranch(root, 6, 8, false, {3, 7}, leaves_);

		for _, branch in pairs(sprout:GetDescendants()) do
			if branch.Name == "MiddleBranch" then
				GrowBranch(branch, rand(2, 4), rand(4, 6), true, {3, 9}, leaves_);
			end
		end
	end
end

function TreeGrowth.GrowMedium (t, leaves_)
	for _, root in pairs(t) do
		local sprout = GrowBranch(root, 10, 14, false, {6, 9}, leaves_);

		for _, branch in pairs(sprout:GetDescendants()) do
			if branch.Name == "MiddleBranch" then
				GrowBranch(branch, rand(4, 6), rand(8, 8), true, {5, 13}, leaves_);
			end
		end
	end
end

function TreeGrowth.GrowBig (t, leaves_)
	for _, root in pairs(t) do
		local sprout = GrowBranch(root, 10, 18, false, {9, 17}, leaves_);

		for _, branch in pairs(sprout:GetDescendants()) do
			if branch.Name == "MiddleBranch" then
				GrowBranch(branch, rand(4, 6), rand(9, 11), true, {5, 13}, leaves_);
			end
		end
	end
end

function TreeGrowth.GrowGigantic (t, leaves_)
	for _, root in pairs(t) do
		local sprout = GrowBranch(root, 20, 25, false, {13, 15}, leaves_);
		
		for _, branch in pairs(sprout:GetDescendants()) do
			if branch.Name == "MiddleBranch" then
				GrowBranch(branch, rand(8, 10), rand(13, 16), true, {11, 19}, leaves_)
			end
		end
	end
end

return TreeGrowth;