--commonSettings.lua
Class = { }

local life
local score
local round
local count

Class.getLife = function ( )
	return life
end
Class.upLife = function ( )
	life = life + 1
end

Class.getScore = function ( )
	return score
end
Class.upScore = function ( )
	score = score + 100
end

Class.upRound = function ( )
	round = round + 1
	count = round * 5
end

Class.getRound = function ( )
	return round
end

Class.getCount = function ( )
	return count
end

Class.commonSet = function ( )
	life = 3
	score = 0
	round = 1
	count = 5
end

return Class