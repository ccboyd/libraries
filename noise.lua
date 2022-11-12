--[[ Perlin Noise Info:
Magnitude: The distance between mounds and hills.
Frequency: How often the peaks appear.
Amplitude: Height of mounds and hills.
]]

local PRNG = Random.new()
local Terrain = workspace.Terrain

local module = {}

module.GetValue = function (X, Z, Magnitude, Frequency, Amplitude, Seed)
	Z = Z or 0 --[[ Z and Seed aren't necessary,
	however you can't perform arithmetic on nil, so I default Z to 0.
	]]

	return math.noise(
		X / Magnitude * Frequency,
		Z / Magnitude * Frequency,
		Seed
	) * Amplitude
end

module.TerrainGrid = function (
	ScaleX, ScaleZ, 
	GridOrigin, GridPieceScale, 
	Material, 
	NoiseData : {"Magnitude, Frequency, Amplitude, Seed"}
)
	local Magnitude, Frequency, Amplitude, Seed = 
		NoiseData[1], NoiseData[2], NoiseData[3], NoiseData[4]

	for X = 1, ScaleX do
		-- Loop through the rows ...

		for Z = 1, ScaleZ do
			-- and create the columns.

			local Height = module.GetValue(X, Z, 
				Magnitude, Frequency, Amplitude, Seed
			)

			local Position = GridOrigin + Vector3.new(
				X * GridPieceScale.X,
				Height,
				Z * GridPieceScale.Z
			)

			Terrain:FillBlock(
				CFrame.new(Position),
				GridPieceScale,
				Material
			)
		end
	end
end

module.PartGrid = function (
	ScaleX, ScaleZ,
	GridOrigin, GridPieceScale,
	NoiseData : {"Magnitude, Frequency, Amplitude, Seed"},
	PartFunction
)
	PartFunction = PartFunction or function () end

	local Magnitude, Frequency, Amplitude, Seed = 
		NoiseData[1], NoiseData[2], NoiseData[3], NoiseData[4]

	for X = 1, ScaleX do
		-- Loop through the rows ...

		for Z = 1, ScaleZ do
			-- and create the columns.

			local Height = module.GetValue(X, Z, 
				Magnitude, Frequency, Amplitude, Seed
			)

			local Position = GridOrigin + Vector3.new(
				X * GridPieceScale.X,
				Height,
				Z * GridPieceScale.Z
			)

			local Part = Instance.new"Part"
			Part.Anchored = true
			Part.Size = GridPieceScale
			Part.Position = Position
			PartFunction(Part)
		end
	end
end

return module
