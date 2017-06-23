--블럭을 다 부셨을 경우에 다시 시작
--블럭 부실 때마다 점수 계산하기
display.setStatusBar( display.HiddenStatusBar )

local physics = require "physics"

_W, _H = display.contentWidth, display.contentHeight

score = 0
scoreT = display.newText( "now Score : "..score, _W*0.775, _H*0.055 )
scoreT.size = 15
replayC = 0
replayT = display.newText( "you replay "..replayC.." times", _W*0.25, _H*0.055 )
replayT.size = 15

createBall = function()
	ball = display.newCircle( _W*0.5, _H - 70, 10 )
	physics.addBody(ball, "dynamic", { friction = 0, bounce = 1, radius=10} )

	ball.collision = function(self, event)
		if event.phase == "ended" then
			if event.other.name == "bricks" then
				event.other:removeSelf( )
				count = count - 1
				score = score + 10
				scoreT.text = "now Score : "..score
				if count == 0 then
					self:removeSelf()
					createBall()
					createBricks()
					paddle.x = _W/2
					touchToStart()
				end
			end
			if event.other.name == "down" then
				self:removeSelf()
				replay()
			end
		end
	end

	ball:addEventListener( "collision", ball )
	Runtime:addEventListener( "tap", touchToStart )
end

createWalls = function()
	wallL = display.newRect( 0, 0, 10, _H )
	wallL.anchorX, wallL.anchorY = 0, 0
	physics.addBody(wallL, "static", { friction = 0, bounce = 1 })

	wallR = display.newRect( _W-10, 0, 10, _H )
	wallR.anchorX, wallR.anchorY = 0, 0
	physics.addBody(wallR, "static", { friction = 0, bounce = 1 })

	wallU = display.newRect( 0, 0, _W, 10 )
	wallU.anchorX, wallU.anchorY = 0, 0
	physics.addBody(wallU, "static", { friction = 0, bounce = 1 })

	wallD = display.newRect( 0, _H-10, _W, 10 )
	wallD.anchorX, wallD.anchorY = 0, 0
	wallD.name = "down"
	physics.addBody(wallD, "static", { friction = 0, bounce = 1 })

	wallL.alpha = 0
	wallR.alpha = 0
	wallU.alpha = 0
	wallD.alpha = 0
end

createBouncePaddle = function()
	--패드 움직이는 함수
	moveBouncePaddle = function(event)
		if event.x >= _W -10 - paddle.contentWidth / 2 then
			paddle.x = _W - 10 - paddle.contentWidth / 2
		elseif event.x <= 10 + paddle.contentWidth / 2 then
			paddle.x = 10 +paddle.contentWidth / 2
		else
			paddle.x = event.x
		end
	end
	paddle = display.newRoundedRect( _W*0.5, _H-50, 100, 10, 5 )
	physics.addBody(paddle, "static", { friction = 0, bounce = 1 })
	paddle:addEventListener( "touch", moveBouncePaddle )
end

createBricks = function()
	for i =1, 5, 1 do
		for j = 1, 6, 1 do
			bricks = display.newRect( 37+40*(j-1), 70+25*(i-1), 40, 25)
			bricks.anchorX, bricks.anchorY = 0, 0
			bricks:setFillColor( math.random(50,255)/255, math.random(50,255)/255, math.random(50,255)/255, 1 )
			bricks.name = "bricks"
			physics.addBody( bricks, "static", { friction = 0, bounce = 1 } )
		end
	end
	count = 30
end

touchToStart = function()
	ball:setLinearVelocity(75, 150)
	Runtime:removeEventListener( "tap", touchToStart )
end

replay = function()
	onButton = function(event)
		yesT:removeEventListener( "touch", onButton )
		noT:removeEventListener( "touch", onButton )
		alertT:removeSelf()
		yesT:removeSelf()
		noT:removeSelf()
		if event.target.name == "yes" then
			paddle.x = _W/2
			replayC = replayC + 1
			replayT.text = "you replay "..replayC.." times"	
			createBall()
		else
			os.exit()
		end
	end
	alertT = display.newText("Replay?", _W*0.5, _H*0.5 )
	yesT = display.newText("Yes", _W*0.3, _H*0.65 )
	noT = display.newText("No", _W*0.7, _H*0.65 )
	alertT.size, yesT.size, noT.size = 30, 20, 20
	yesT.name, noT.name = "yes", "no"

	yesT:addEventListener( "touch", onButton )
	noT:addEventListener( "touch", onButton )
end

--모든 함수 실행/관리
main = function()
	physics.start() 
	physics.setGravity(0,0)
	createWalls()
	createBouncePaddle()
	createBall()
	createBricks()
end

main()