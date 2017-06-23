local Class = { }

local score
local level
local count

--set/get score
Class.getScore = function ( )
	return score
end

Class.setScore = function ( v )
	score = score + v
end

--set Count
Class.getCount = function ( )
	return count
end
Class.setCount = function ( )
	count = count + 1
end

--basic
Class.basic = function ( )
	life = 3
	score = 0
	count = 0
end

return Class
