local M = {}

math.randomseed( os.time() )

function M.setMon(maxSum)
	local hp = math.floor( math.random() * maxSum )
	return { max = hp, atk = maxSum-hp }
end

return M