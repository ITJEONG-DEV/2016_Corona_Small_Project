-- 1280*720 -> 40*22.5
local function arrayFloor()
	local floor = { }
	local sizeX, sizeY = 64, 64
	for i = 1, 40*32/sizeX, 1 do
		floor[i] = {}
		for j = 1, math.floor(23*32/sizeY), 1 do
			floor[i][j] = 0
			floor[i][j] = display.newImage("1_1.png")
			floor[i][j].x = sizeX*(j-1)-12
			floor[i][j].y = sizeY*(i-1)
		end
	end
end

arrayFloor()