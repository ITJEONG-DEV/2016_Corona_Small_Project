local M = {}

math.randomseed( os.time() )

function M.setMon(maxSum)
	local hp = math.random(0, 100)
	local atk = math.random(0, 100)
	local weight = math.random(0, 100)
	local mp = math.random(0, 100)
	return {
		max = math.floor(hp*maxSum/(hp+atk)),
		atk =  maxSum - math.floor(hp*maxSum/(hp+atk)) + math.floor((weight-50)*0.5),
		weight = weight,
		mp = mp
	}
end

return M