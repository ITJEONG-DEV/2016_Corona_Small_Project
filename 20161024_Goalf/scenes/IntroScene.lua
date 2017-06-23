--##############################  Main Code Begin  ##############################--
local composer = require( "composer" )

local scene = composer.newScene()

-- "scene:create()"
function scene:create( event )
	local sceneGroup = self.view
	

	-- 여기서부터 시작
	local stick
	local map
	local wall
	local ball
	local turn = true
	local angle = math.random(1,5)
	local gage1 = nil
	local checker = nil
	local _H = display.contentHeight
	local _W = display.contentWidth

	local function CC(hex)
		local r = tonumber( hex:sub(1,2), 16) / 255
		local g = tonumber( hex:sub(3,4), 16) / 255
		local b = tonumber( hex:sub(5,6), 16) / 255
		local a = 255/255
		if #hex == 8 then a = tonumber( hex:sub(7,8), 16) / 255 end
		return r,g,b,a
	end

	wall = display.newRect(0, _H*0.8, _W, _H*0.2)
	wall.anchorX, wall.anchorY = 0,0
	wall:setFillColor( CC("8BA520") )

	stick = display.newImage("putter.png")
	stick:scale(0.1,0.1)
	stick.x, stick.y = 200, wall.y - stick.contentHeight
	stick.anchorx, stick.anchorY = stick.contentWidth*0.5, 0

	local checkerMove = function ( )
		if checker.rotation >= 270 then angle = -2 end
		if checker.rotation <= 0 then angle = 2 end
		print("checkerMove is running")
		checker.rotatino = checker.rotation + angle
	end

	local checkerOn  = function ( )
		--Enterframe 이벤트로 checker가 움직임
		--다시 터치하면 각도에 따른 힘을 계산해서 공이 나가야 함
		--공이 나오는 모션 추가
		--힘 추가 물리 추가
		--그림 완성 요청
		Runtime:removeEventListener( "enterFrame", checkerMove )
		print("checkerOn is running")
	end

	local gage = function ( )
		--power탭
		--정가운데를 기준으로 좌우로 이동하는 게이지
		gage1 = display.newImage( "gage.png" )
		checker = dipslay.newImage("checker.png")

		gage1.x, gage1.y = _W*0.17, _H*0.9
		checker.x, checker.y = _W*0.17, _H*0.9
		gage1:scale(0.5,0.5)
		checker:scale(0.5,0.5)
		Runtime:addEventListener( "enterFrmae", checkerMove )
		Runtime:addEventListener( "tap", checkerOn )
	end

	local rotate = function ( )
		if stick.rotation >= 30 then angle = -2
		elseif stick.rotation <= -30 then angle = 2 end
		stick.rotation = stick.rotatino + angle
	end

	local stop = function ( )
		Runtime:removeEventListener( "enterFrame", rotate )
		gage()
	end

	Runtime:addEventListener( "enterFrmae", rotate )
	Runtime:addEventListener( "tap", stop1 )

	local img = display.newImage("Icon.png")
	transition.to(img, {time=1000, x=150, y=150})

	--power는 게이지 만들기
end

-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )

-- -------------------------------------------------------------------------------

return scene
--##############################  Main Code End  ##############################--