----------------------------------------
-- 이 주석은 삭제하지 마세요.
-- 35% 할인해 드립니다. 코로나 계정 유료 구매시 연락주세요. (Corona SDK, Enterprise, Cards)
-- @Author 아폴로케이션 원강민 대표
-- @Website http://WonHaDa.com, http://Apollocation.com, http://CoronaLabs.kr
-- @E-mail englekk@naver.com, englekk@apollocation.com
-- 'John 3:16, Psalm 23'
-- MIT License :: WonHada Library에 한정되며, 라이선스와 저작권 관련 명시만 지켜주면 되는 라이선스
----------------------------------------

---------------------------------
-- 기본 세팅
-- __statusBarHeight__ : 상단 StatusBar의 높이
-- __appContentWidth__ : App의 너비
-- __appContentHeight__ : App의 높이
-- 앵커포인트는 좌상단 
---------------------------------

-- 안드로이드 풀 스크린 모드 여부
local isAndroidFullScreen = true

-- 이 함수가 시작점입니다. 나머지는 신경쓰지 마세요. (-:
local function startApp()
	require("CommonSettings")
	
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

--=======================================================--
local function on_SystemEvent(e)
	local _type = e.type
	if _type == "applicationStart" then -- 앱이 시작될 때
		
		local isResized = false -- 리사이즈 함수 실행 여부
		
		local function onResized(e1)
			Runtime:removeEventListener("resize", onResized)
			isResized = true

			startApp()
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
--=======================================================--