--you should make mask!!

local physics = require "physics"

--상태바 안보이도록 하기
display.setStatusBar( display.HiddenStatusBar )

--기기의 시간에 따라 난수 생성함.
math.randomseed( os.time() )

--widget 불러오기.
local widget = require "widget"

--개발을 편리하게 만들어 줄 변수 선언
local _W, _H = display.contentWidth, display.contentHeight

--큰 흐름을 책임질 큰 함수들
local loading, lobby, readygame, ingame, result

--어느 화면에서나 사용하는 함수들
local BGM, nowMusic, PLAY_UI1, SET_NUM

--어느 화면에서나 필요한 수치.
local CHRISTAL, COIN, HEART = 125, 135500, 10

--UI 효과음은 어디에서나 사용됩니다.
--UI 효과음 미리 로딩해 두기(지연 없는 재생을 위하여.)
local UI_1 = audio.loadSound( "bgm/ui_1.mp3" )

--배경 음악을 깔아봅시다.
BGM = function( )
	media.playSound( nowMusic, BGM ) --음악 재생이 끝나면 BGM함수 다시 호출함.
end --음악 무한 반복됨.

--UI 음악을 틀어주는 함수.
PLAY_UI1 = function( )
	audio.play( UI_1 )
end

--쿠키런에서 사용하는 방식 > 숫자를 하나 하나 뜯어서 표시하기.
SET_NUM = function( num, color, x1, y1, arr )
	-- num : 125, 133500
	-- color : "W" / "B"
	-- x1, y1 : 위치
	-- arr : 이미지를 담을 테이블
	local arr1 = {}
	local i = 1
	while true do
		arr1[i] = num%10
		num = ( num - num%10 ) / 10

		if num == 0 then
			break
		end

		i = i + 1
	end

	-- 초기값, 조건, 증감값
	for j = i, 1, -1 do
		arr[i+1-j] = display.newImage( "UI/number/"..color..arr1[j]..".png", x1, y1 )

		if j ~= i then
			arr[i+1-j].x = arr[i-j].x + arr[i-j].contentWidth
		end
	end
end


-->Convert Color
--hex코드를 코로나에서 사용하는 RGB값(0~1)으로 반환해주는 함수
local function CC(hex)
	local r = tonumber( hex:sub(1, 2), 16 ) / 255
	local g = tonumber( hex:sub(3, 4), 16 ) / 255
	local b = tonumber( hex:sub(5, 6), 16 ) / 255
	local a = 255/255
	if #hex == 8 then a = tonumber( hex:sub(7, 8), 16 ) / 255 end
	return r,g,b,a
end

--loading 함수 선언 시작
loading = function( )
	--loading 화면에서 사용하게 될 변수들.
	local bg, alertBox, alertText, loadingComplete
	local i = 1

	-- 정보 로딩/게임 시작 등의 문구를 바꿔줄 함수 > 타이머로 연결함.
	loadingComplete = function( e )
		if i == 1 then
			alertText.text = "정보 로딩 완료!"
		elseif i == 2 then
			alertText.text = "게임이 곧 시작합니다."
		else
			--화면 이동 전에는 꼭 이미지를 다 제거해 주어야 함 > 메로리를 위하여!
			bg:removeSelf()
			alertBox:removeSelf( )
			alertText:removeSelf( )

			--이미지 모두 제거 후 화면 이동
			lobby()
		end
		--타이머 호출 시마다 i값 증가함
		i = i + 1
	end

	--기본 이미지 셋팅
	bg = display.newImage("UI/loading/loading.png")
	bg.anchorX, bg.anchorY = 0, 0

	alertBox = display.newRoundedRect( _W*0.5, _H*0.95, _W*0.25, _H*0.07, 20 )
	alertBox:setFillColor( CC("1b1b1b") )
	alertBox.alpha = 0.8

	alertText = display.newText( "정보 로딩 중. . .", _W*0.5, _H*0.95, native.newFont( "nanumSquareL.ttf"), 27 )
	
	--함수 호출
	-- 1초 > 1000
	timer.performWithDelay( 2500, loadingComplete , 3 )
end
--loading 함수 선언 끝


--lobby 함수 선언 시작
lobby = function( )
	--변수 선언
	local showHeart
	local bg, lv, heartBox, rank, christalB, coinB, heartB, helpB, heartT, onStartB
	--SET_NUM 함수 호출 결과를 담을 테이블
	local christalNumI= {}
	local coinNumI = {}
	local heartI = {}

	showHeart = function( )
		--HEART의 수를 기준으로 계산됨
		local max = 0

		--하트의 개수가 5보다 넘을 경우, 추가 보유 생명 수 표시
		if HEART > 5 then
			max = 5
			heartT = display.newText( "추가 보유 생명 : "..(HEART-5).."개", _W*0.77, _H*0.14, native.newFont( "nanumSquareB.ttf"), 20 )
		
		--아니면 하트 칸만 채움
		else
			max = HEART
		end

		--for문을 사용하여, 하트를 표시해줌 ( 동일한 간격을 가지고 있기 때문 )
		for i = 1, max, 1 do
			heartI[i] = display.newImage( "UI/lobby/heart.png",
				_W*0.665 + 49*(i-1), _H*0.072 )
		end
	end

	onStartB = function( )
		PLAY_UI1()
		bg:removeSelf( )
		lv:removeSelf()
		rank:removeSelf()
		christalB:removeSelf()
		coinB:removeSelf()
		heartB:removeSelf()
		helpB:removeSelf()
		startB:removeSelf()
		cookie:removeSelf()
		--heart 이미지 제거
		for key,value in pairs(heartI) do
			if value ~= nil then value:removeSelf() end
		end
		--추가 보유 생명 : 이 표시되어 있다면, 삭제
		if heartT ~= nil then heartT:removeSelf() end
		for key, value in pairs(christalNumI) do
			if value ~= nil then value:removeSelf() end
		end
		for key, value in pairs(coinNumI) do
			if value ~= nli then value:removeSelf() end
		end
		readygame()
	end

	--기본 이미지 셋팅
	bg = display.newImage( "UI/lobby/bg.png" )
	bg.anchorX, bg.anchorY = 0, 0

	lv = display.newImage( "UI/lobby/lv.png", _W*0.1, _H*0.075 )
	rank = display.newImage( "UI/lobby/rank.png", _W*0.3, _H*0.575 )
	
	--기본 버튼 셋팅
	--[[
	button = widget.newButton({ --버튼을 만들겠다고 선언함
		left = _W*0.21, --버튼의 왼쪽 모서리 위치
		top = _H*0.03, --버튼의 윗쪽 모서리 위치
		defaultFile = "UI/lobby/christal_off.png", --보통 상태의 버튼 이미지/그라디언트 컬러
		overFile = "UI/lobby/christal_on.png", --클린된 상태의 버튼 이미지/그라이던트 컬러
		onTouch = hi, -- 버튼을 터치했을 때 호출하는 함수(phase상태가 began/moved/ended때 각각 실행됨)
		onRelease = ok, --버튼을 눌렀다가 뗐을 때 호출하는 함수(phase상태가 ended일때만 실행됨)
	})
	]]--

	christalB = widget.newButton({
		left = _W*0.21,
		top = _H*0.03,
		defaultFile = "UI/lobby/christal_off.png",
		overFile = "UI/lobby/christal_on.png",
		onRelease = ok,
	})
	coinB = widget.newButton({
		left = _W*0.38,
		top = _H*0.03,
		defaultFile = "UI/lobby/coin_off.png",
		overFile = "UI/lobby/coin_on.png",
		onRelease = PLAY_UI1,
	})
	heartB = widget.newButton({
		left = _W*0.63,
		top = _H*0.025,
		defaultFile = "UI/lobby/heartBox_off.png",
		overFile = "UI/lobby/heartBox_on.png",
		onRelease = PLAY_UI1,
	})
	helpB = widget.newButton({
		left = _W*0.9325,
		top = _H*0.03,
		defaultFile = "UI/lobby/help_off.png",
		overFile = "UI/lobby/help_on.png",
		onRelease = PLAY_UI1,
	})
	startB = widget.newButton({
		left = _W*0.62,
		top = _H*0.835,
		defaultFile = "UI/lobby/start_on.png",
		overFile = "UI/lobby/start_off.png",
		onRelease = onStartB,
	})

	--로비에서 보여 줄 쿠키 이미지
	cookie = display.newImage("UI/lobby/braveCookie.png", _W*0.77, _H*0.45 )
	
	--object:scale(xScale, yScale)
	cookie:scale(1.2, 1.2)

	--nowMusic에 로비 음악 링크 걸어줌
	nowMusic = "bgm/bgm_lobby.mp3"
	--음악 재생 시작
	BGM( )
	--음악 볼륨 조정 ( 0 ~ 1 사이 )
	media.setSoundVolume( 0.05 )


	--SET_NUM 호출
	SET_NUM( CHRISTAL, "W", _W*0.27, _H*0.065, christalNumI )
	SET_NUM( COIN, "W", _W*0.43, _H*0.065, coinNumI )
	
	--showHeart() 호출
	showHeart()
end
--lobby 함수 선언 끝

--readygame 함수 선언 시작
readygame = function()
	media.stopSound( )
	local bg, text, gogame
	-- 용감한 쿠키의 대사는 5개이다.
	local charT = { "달리기 하면 나지!", "마녀는 보이지 않는군...\n            이때다!", "                안돼!\n난 여기에서 빠져나가야겠어!", "이대로 먹힐 수는 없어!", "쿠키라고 무시하지 마!" }

	--readygame에서 gogame으로 이동시켜줄 함수
	gogame = function( )
		bg:removeSelf()
		text:removeSelf()
		ingame()
	end
	--gogame 함수 끝
	
	--기본 이미지 셋팅
	bg = display.newImage( "UI/readyGame/ready1b.png" )
	bg.anchorX, bg.anchorY = 0, 0

	--실제 디스플레이 크키에 맞추어 이미지 확장
	local scaleX, scaleY = _W/bg.contentWidth, _H/bg.contentHeight
	bg:scale(scaleX,scaleY)

	text = display.newText( charT[math.random(1,5)], _W*0.755, _H*0.27, native.newFont( "nanumSquareB.ttf"), 32)
	text.align = "center"
	text:setFillColor( CC("1b1b1b") )
	media.playSound( "bgm/g_start.mp3", gogame )
	media.setSoundVolume( 0.35 )
end
--readygame 함수 선언 끝


--ingame 함수 선언 시작
ingame = function( )
	--음악이 나오고 있다면 음악 종료 시키기
	media.stopSound( )
	--게임 시작시 나오는 음악으로 링크 변경
	nowMusic = "bgm/bgm_main.mp3"
	--음악 틀기
	BGM( )
	--볼륨 조정
	media.setSoundVolume( 0.1 )
	physics.start()
	physics.setGravity( 0, 20 )
	--display.setDrawMode( "hybrid" )
	
	--변수 선언
	local moved, makeObs, onJumpB, onSlideB
	local bonustime, hpIcon, hpOff, hpOn, hpMask, hpEnd, hpMove, cookieMove, jumpB, slideB, coinI, jellyI, stopB
	local bg = {}
	local speed = 5
	local mapCount = 10
	local score
	-- 0 : 공백
	-- 1 : 바닥만
	-- 2 : 올리브 압정
	-- 3 : 압정
	-- 4 : 뾰족이 3개
	-- 5 : 뾰족이 2개
	-- 6 : 소시지 포크
	local mapInfo = 
	{
		1,1,1,1,1, 1,1,1,1,1, 1,1,1,1,1, 1,1,1,1,1,
		6,6,6,6,6, 6,6,6,6,6, 6,6,6,6,6, 1,1,1,1,1,
		0,1,1,1,1, 0,0,1,1,1, 2,1,1,1,1, 3,1,1,1,1,
		4,1,1,1,1, 5,1,1,1,1, 6,1,1,1,1, 1,1,1,1,1
	}
	local nowFloor = {}
	local mapN, spaceN = 0, 0

	local cookieData, cookieSet, cookieSheet, cookie, physicsData
	local isJump = false
	local collisionC = 0

	--배경화면과 맵의 이동을 담당해줄 함수
	--moved 함수 시작
	moved = function( )
		cookie.rotation = 0
		cookie.x = _W*0.4
		--스피드가 증가합니다.
		if speed < 15 then speed = speed + 0.005
		else speed = 15 end

		--배경 이미지가 움직입니다.
		bg[1].x = bg[1].x - speed
		bg[2].x = bg[2].x - speed


		--바닥을 움직여 봅시다!
		for i = 1, 13, 1 do
			nowFloor[i].x = nowFloor[i].x - speed
		end
		--hpOn.x = hpOn.x - speed
		--hpOn.maskX = hpOn.maskX + speed

		-- 배경의 추가 조건
		if bg[1].x <= bg[1].contentWidth * -1 then
			bg[1].x = bg[2].x + bg[1].contentWidth
		end
		if bg[2].x <= bg[2].contentWidth * -1 then
			bg[2].x = bg[1].x + _W
		end

		-- 바닥의 추가 조건!
		for i = 1, 13, 1 do
			if nowFloor[i].x <= nowFloor[i].contentWidth * -1 then
				while true do
					if mapN == 60 then mapN = 1
					else mapN = mapN + 1 end

					if mapInfo[mapN] == 0 then
						spaceN = spaceN + 1
					else
						if i ~= 1 then
							nowFloor[i].x = nowFloor[i-1].x + nowFloor[i].contentWidth*( 1+spaceN )
							if mapInfo[mapN] > 1 then makeObs(mapInfo[mapN], i) end
						else
							nowFloor[i].x = nowFloor[13].x + nowFloor[i].contentWidth*( 1+spaceN )
						end

						spaceN = 0
						break
					end

				end
			end
		end

		
		  -- 대형 HP 젤리가 언제쯤 나오는지 알려주는 파라미터
		cookieMove.x = cookieMove.x + speed/mapCount
		if cookieMove.x >= 300 then
			cookieMove.x = _W*0.0785
			if mapCount < 20 then
				mapCount = mapCount * 4
			else
				mapCount = 20
			end
		end
		--print("speed is "..speed.."   cookieMove speed is "..speed/mapCount)
	end
	--moved함수 끝

	--장애물을 만들어주는 함수!
	makeObs = function( obsN, i )
		local obsMove
		local obs
		local physicsData
		local bool = false

		obsMove = function()
			obs.x = obs.x - speed

			if obs.x < obs.contentWidth * -1 then
				Runtime:removeEventListener( "enterFrame", obsMove )
				obs:removeSelf()
			end
		end
		
		obs = display.newImage( "UI/inGame/obstacle/"..obsN..".png", nowFloor[i].x + nowFloor[i].contentWidth/2, _H-nowFloor[i].contentHeight*1.5 )
		obs.name = "obstacle"

		if obsN == 2 then
			obs:scale(1.2, 1.2)
			physicsData = (require "UI.inGame.obstacle.2").physicsData(1.2)
			physics.addBody( obs, "static", physicsData:get("2") )
		elseif obsN == 3 then
			obs:scale(1.2, 1.2)
			physicsData = (require "UI.inGame.obstacle.3").physicsData(1.2)
			physics.addBody( obs, "static", physicsData:get("3") )
		elseif obsN == 4 then
			obs:scale(1.2, 1.2)
			physicsData = (require "UI.inGame.obstacle.4").physicsData(1.2)
			physics.addBody( obs, "static", physicsData:get("4") )
		elseif obsN == 5 then
			obs:scale(1.2, 1.2)
			physicsData = (require "UI.inGame.obstacle.5").physicsData(1.2)
			physics.addBody( obs, "static", physicsData:get("5") )
		elseif obsN == 6 then
			obs:scale(0.8, 0.8)
			physicsData = (require "UI.inGame.obstacle.6").physicsData(0.8)
			physics.addBody( obs,  "static", physicsData:get("6") )
			obs.y = _H*0.4
		end

		Runtime:addEventListener( "enterFrame", obsMove )
	end

	onJumpB = function( e )
		if e.phase == "began" then
			if not isJump then
				isJump = true
				PLAY_UI1()

				physicsData = (require "UI.jump").physicsData(1.0)
				physics.removeBody( cookie )
				physics.addBody( cookie, "dynamic", physicsData:get("jump") )
				cookie:setSequence( "jump" )
				cookie:play()

				--cookie:setLinearVelocity( 0 , -750 )
				transition.to( cookie, { time = 300, y = cookie.y - 150, transtion = easing.outQuad  } )
				transition.to( cookie, { time = 300, y = cookie.y, delay = 300, transition = easing.inQuad })
			end
		end
	end

	onSlideB = function( e )
		if cookie.sequence ~= "jump" then
			if e.phase == "began" then
				PLAY_UI1()
				cookie:setSequence( "slide" )
				cookie:play()

				physicsData = (require "UI.slide").physicsData(1.0)
				physics.removeBody( cookie )
				physics.addBody( cookie, "dynamic", physicsData:get("slide") )
				--cookie
			elseif e.phase == "ended" then
				physicsData = (require "UI.run").physicsData(1.0)
				physics.removeBody( cookie )
				physics.addBody( cookie, "dynamic", physicsData:get("run") )
				cookie:setSequence( "run" )
				cookie:play()
			end
		end
	end

	--기본 이미지 셋팅
	bg[1] = display.newImage( "UI/inGame/back1.png", 0, 0 )
	bg[1].anchorX, bg[1].anchorY = 0, 0

	bg[2] = display.newImage( "UI/inGame/back1.png", _W, 0 )
	bg[2].anchorX, bg[2].anchorY = 0, 0

	bonustime = display.newImage( "UI/inGame/bonustime.png", _W*0.153, _H*0.04 )
	hpOff = display.newImage( "UI/inGame/gage_off.png", _W*0.05, _H*0.135 )
	hpOn = display.newImage( "UI/inGame/gage_on.png", _W*0.05, _H*0.135 + 5 )
	hpEnd = display.newImage( "UI/inGame/hp_end_1.png", hpOn.contentWidth + _W*0.05*0.62, _H*0.135 + 5 )
	hpIcon = display.newImage( "UI/inGame/hpIcon.png", _W*0.04, _H*0.135 )
	hpMove = display.newImage( "UI/inGame/hpMove.png", _W*0.155, _H*0.188 )
	cookieMove = display.newImage( "UI/inGame/cookieMove.png", _W*0.077 , _H*0.19 )
	coinI = display.newImage( "UI/inGame/coin.png", _W*0.487, _H*0.043 )
	jellyI = display.newImage( "UI/inGame/jelly.png", _W*0.785, _H*0.043 )
	stopB = display.newImage( "UI/inGame/stopbutton.png", _W*0.968, _H*0.05 )

	--바닥을 생성해 봅시다.
	for i = 1, 13, 1 do
		if mapInfo[i] >= 1 then
			nowFloor[i] = display.newImage( "UI/inGame/obstacle/1.png", 112*(i-1+spaceN), _H )
			nowFloor[i].anchorX, nowFloor[i].anchorY = 0, nowFloor[i].contentHeight
			nowFloor[i].name = "floor"
			physics.addBody( nowFloor[i], "static", { bounce = 0, friction = 0 } )
			spaceN = 0
		else
			spaceN = spaceN + 1
		end
	end

	jumpB = widget.newButton(
	{
		left = _W*0.0005,
		top = _H*0.75,
		defaultFile = "UI/inGame/jump_off.png",
		overFile = "UI/inGame/jump_on.png",
		onEvent = onJumpB,
	})

	slideB = widget.newButton(
	{
		left = _W*0.808,
		top = _H*0.75,
		defaultFile = "UI/inGame/slide_off.png",
		overFile = "UI/inGame/slide_on.png",
		onEvent = onSlideB,
	})

	--쿠키를 만들어 봅시다!!!
	cookieData =
	{
		width = 180,
		height = 140,
		numFrames = 22,
		sheetContentWidth = 1440,
		sheetContentHeight = 420,
	}
	cookieSet = 
	{
		{ name = "run", frames = { 1,2,3,4,5,6 }, time = 500, loopCount = 0 },
		{ name = "jump", frames = { 7, 8 }, time = 350, loopCount = 0 },
		{ name = "slide", frames = { 9, 10 }, time = 350, loopCount = 0 },
		{ name = "runHit", frames = { 11, 12, 13 }, time = 350, loopCount = 1 },
		{ name = "slideHit", frames = { 14, 15 }, time = 350, loopCount = 1 },
		{ name = "jumpHit", frames = { 16 }, time = 350, loopCount = 1 },
		{ name = "dead", frames = { 17, 18, 19, 20, 21, 22 }, time = 1500, loopCount = 1 },
	}
	cookieSheet = graphics.newImageSheet( "UI/cookie_normal.png", cookieData )
	cookie = display.newSprite( cookieSheet, cookieSet )
	cookie.x, cookie.y = _W*0.4, _H - nowFloor[1].contentHeight - cookie.contentHeight/2
	cookie.name = "cookie"
	cookie:play()

	physicsData = (require "UI.run").physicsData(1.0)
	physics.addBody( cookie, "dynamic", physicsData:get("run") )


	cookie.collision = function( self, event )
		local changeRun

		changeRun = function( )
			physics.removeBody( cookie )
			physicsData = (require "UI.run").physicsData(1.0)
			physics.addBody( cookie, "dynamic", physicsData:get("run") )
			cookie:setSequence( "run" )
			cookie:play()
		end

		if event.phase == "began" then
			if event.other.name == "floor" and isJump then
				if collisionC == 2 then
					if cookie.squence == "slide" then
						isJump = false
						collisionC = 0
					else
						isJump = false
						timer.performWithDelay( 1, changeRun, 1 )
						collisionC = 0
					end
				else
					collisionC = collisionC + 1
				end
			end

			if event.other.name == "obstacle" then
				transition.cancel( )
				print("collision with obstacle")
			end
		end
	end

	cookie:addEventListener( "collision", cookie )



	hpOff.anchorX, hpOn.anchorX = 0, 0
	--graphics.newMask 연구해 오기
	hpOn.anchorX = 0
--	hpMask = graphics.newMask( "UI/inGame/gage_mask.png" )
--	hpOn:setMask( hpMask )

	Runtime:addEventListener( "enterFrame", moved )
end
--ingame 함수 선언 끝


--result 함수 선언 시작
result = function( getScore, getCoin, getTime )
	--변수 선언
	local bg, okB, showB

	--기본 이미지 셋팅
	bg = display.newImage( "UI/result/result_pop.png", _W*0.5, _H*0.5 )

	okB = widget.newButton(
	{
		left = _W*0.24,
		top = _H*0.82,
		defaultFile = "UI/result/ok_off.png",
		overFile = "UI/result/ok_on.png",
		onEvent = PLAY_UI1,
	})

	showB = widget.newButton(
	{
		left = _W*0.513,
		top = _H*0.82,
		defaultFile = "UI/result/show_off.png",
		overFile = "UI/result/show_on.png",
		onEvent = PLAY_UI1,
	})
end
--result 함수 선언 끝


--함수 호출 시작
--loading()
--lobby()
--readygame()
ingame()
--result()