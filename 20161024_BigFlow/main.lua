display.setStatusBar( display.HiddenStatusBar )
_statusBarHeight = 0
math.randomseed(os.time())
_W = display.contentWidth
_H = display.contentHeight
_aW = display.actualContentWidth
_aH = display.actualContentHeight
_isSimulator = system.getInfo("environment") == "simulator"
_scaleFactor = 0.5
_setScaleFactor = function ( obj, ratio )
	ratio = ratio or __scaleFactor
	obj.width, obj.heigt = math.round(obj.width * ratio), math.round( obj.height * ratio )
end
local function CC(hex)
	local r = tonumber( hex:sub(1,2), 16) / 255
	local g = tonumber( hex:sub(3,4), 16) / 255
	local b = tonumber( hex:sub(5,6), 16) / 255
	local a = 255/255
	if #hex == 8 then a = tonumber( hex:sub(7,edswxa
end

local physics = require "physics"
physics.setDrawMode( "hybrid" )

local start
local inGame
local score
--shop1 : map
local shop1
--shop2 : ball
local shop2
--shop3 : stick
local shop3

local checkerMove
local checkerTouch
local checkerPass
local gage
local stickMove
local stickStop


local floor_n
local ball_n
local stick_n
local floor
local ball
local stick
local sc = display.contentWidth / 1080
local bg = display.newRect(0,0,_W,_H)
local angle = 2
local checker
local gage1
local ballSeat
--floor에 physicsEditor 추가해야 함
local scaleFactor = 1.0
bg:setFillColor( CC("37B2D3") )
bg.anchorX, bg.anchorY = 0, 0

start = function ( )
	--Default : 1,1,1
	--Else : 저번에 플레이 했던 수치로
	floor_n = 1
	ball_n = 2
	stick_n = 1
	inGame()
end
inGame = function ( )
	--Before Start//Settings

	physics.start()
	--Select floor
	local we1 = display.newRect(0, _H*0.85, _W*0.785, _H*0.15)
	local we2 = display.newRect(_W*0.875, _H*0.85, _W*0.125, _H*0.15)
	local we3 = display.newRect(_W*0.785, _H*0.96, _W*0.09, _H*0.04) --collision
	we1.anchorX, we1.anchorY = 0, 0
	we2.anchorX, we2.anchorY = 0, 0
	we3.anchorX, we3.anchorY = 0, 0
	physics.addBody(we1, "static", { })
	physics.addBody(we2, "static", { })
	physics.addBody(we3, "static", { })
	local f = floor_n
	if f == 1 then floor = display.newImage("floor/floor_1.png")
	else
	end
	floor:toFront( )
	floor.anchorX, floor.anchorY = 0, 0
	floor.x, floor.y = 0, 0
	floor:scale(0.6,0.6)
	--Illustrator로 편집하기!!!!

	--Select stick
	local s = stick_n
	if s == 1 then stick = display.newImage("stick/putter.png")
	else
	end
	stick:scale(0.15,0.15)
	stick.x, stick.y = _W*0.1, stick.contentHeight * 1.25
	local physicsData = (require "stick.putter").physicsData(0.15)
	physics.addBody(stick, "static", physicsData:get("putter"))
	--Play Start

	checkerMove = function ( )
		if checker.rotation >= 270 then angle = -2 end
		if checker.rotation <= 0 then angle = 2 end
		---print("checkerMove is running")
		checker.rotation = checker.rotation + angle
	end
	checkerPass = function ( )
		--ball open!
		--Select ball
		local b = ball_n
		if b == 1 then
		elseif b == 2 then ball = display.newImage("ball/baseball.png")
		elseif b == 3 then ball = display.newImage("ball/ballingball.png")
		else
		end
		ball.x, ball.y = _W*0.17, _H*0.96
		ball:scale(0.8,0.8)
		ballSeat = display.newImage("ballS.png")
		ballSeat.x, ballSeat.y = _W*0.17, _H*1.0
		physics.addBody(ballSeat, "static", {})
		physics.addBody(ball, "dynamic", { radius = 29 })	
		transition.to( ballSeat, { delay = 400, y = _H*0.82, onComplete = gage() } )
		transition.to( ball, { delay = 400, y = _H*0.78})
	end
	checkerTouch = function ( )
		transition.to( )
		Runtime:removeEventListener( "enterFrame", checkerMove )
		print("checkerTouch is running")
	end
	gage = function ( )
		gage1 = display.newImage("gage.png")
		checker = display.newImage("checker.png")

		gage1.x, gage1.y = _W*0.1, _H*0.9
		checker.x, checker.y = _W*0.1, _H*0.9
		gage1:scale(0.3,0.3)
		checker:scale(0.3,0.3)
		angle = 2
		Runtime:addEventListener( "enterFrame", checkerMove )
		Runtime:addEventListener( "tap", checkerTouch )
	end

	stickMove = function ( )
		if stick.rotation >= 30 then angle = -2
		elseif stick.rotation <= 0 then angle = 2 end
		stick.rotation = stick.rotation + angle
	end
	stickStop = function ( )
		Runtime:removeEventListener( "enterFrame", stickMove )
		Runtime:removeEventListener( "tap", stickStop )
		checkerPass()
	end

	Runtime:addEventListener( "enterFrame", stickMove )
	Runtime:addEventListener( "tap", stickStop )



end
score = function ( )
end
shop1 = function ( )
end
shop2 = function ( )
end
shop3 = function ( )
end

local function on_SystemEvent(e)
	local _type = e.type
	if _type == "applicationStart" then -- 앱이 시작될 때
		
		local isResized = false -- 리사이즈 함수 실행 여부
		
		local function onResized(e1)
			Runtime:removeEventListener("resize", onResized)
			isResized = true

			---여기서부터 함수 시작!!
			start()
		end
		
		--======== 안드로이드 풀 스크린 적용(수정 불필요) Begin ========--
		if system.getInfo("environment") == "simulator" or string.lower(system.getInfo("platformName")) ~= "android" or isAndroidFullScreen == false then
			onResized(nil)
		else -- 안드로이드이면서 풀 스크린 모드일 경우
			Runtime:addEventListener("resize", onResized)
			native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
			
			-- 소프트키 바가 없는 경우
			local function on_Timer(e2)
				if not isResized then onResized(nil) end
			end
			timer.performWithDelay(200, on_Timer, 1)
		end
		--======== 안드로이드 풀 스크린 적용(수정 불필요) End ========--
		
	elseif _type == "applicationExit" then -- 앱이 완전히 종료될 때
	elseif _type == "applicationSuspend" then -- 전화를 받거나 홈 버튼 등을 눌러서 앱을 빠져나갈 때
	elseif _type == "applicationResume" then -- Suspend 후 다시 돌아왔을 때
		if system.getInfo("environment") == "simulator" or string.lower(system.getInfo("platformName")) ~= "android" or isAndroidFullScreen == false then
		else -- 안드로이드이면서 풀 스크린 모드일 경우
			native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
		end
	end
end
Runtime:addEventListener("system", on_SystemEvent)

--print(display.contentWidth)
--print(display.contentHeight)
--print(display.actualContentWidth)
--print(display.actualContentHeight)