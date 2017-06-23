Class = {}
math.randomseed( os.time() )

local ball

Class.makeBall = function ( )
	num = math.random(1,4)

	if num==1 then
		ball = display.newImage("ball1.png")
	elseif num==2 then
		ball = display.newImage("ball2.png")
	elseif num==3 then
		ball = display.newImage("ball3.png")
	elseif num==4 then
		ball = display.newImage("ball4.png")
	end

	ball.x = math.random(0, 1080)
	ball.y = math.random(0, 1720)

	return ball
end

return Class