--기본 설정 변수들
math.randomseed( os.time() )
display.setStatusBar( display.HiddenStatusBar )
local physics = require "physics"
local _W, _H = display.contentWidth, display.contentHeight

--화면 이동과 관련된 변수들
local startMenu --시작화면
local readyGame
local inGame --게임화면

--기타 변수들
local nowMusic

--Convert RGB > NUM
local CC = function( hex )
	local r = tonumber( hex:sub( 1, 2 ), 16 ) / 255
	local g = tonumber( hex:sub( 3, 4 ), 16 ) / 255
	local b = tonumber( hex:sub( 5, 6 ), 16 ) / 255
	local a = 255 / 255
	if #hex == 8 then a = tonumber( ehx:sub( 7, 8 ), 16 ) end
	return r, g, b, a
end

--BGM
BGM = function ( )
	if nowMusic == "bgm/bgm_main.mp3" then
		nowMusic = "bgm/bgm_main2.mp3"
	elseif nowMusic == "bgm/bgm_main2.mp3" then
		nowMusic = "bgm/bgm_main3.mp3"
	elseif nowMusic == "bgm/bgm_main3.mp3" then
		nowMusic = "bgm/bgm_main.mp3"
	end
	media.playSound( nowMusic, BGM )
end

--시작 화면 설정
startMenu = function( )
	local bg = nil
	local text = nil
	local count  = nil
	local num = -20
	local opa  = nil
	local opaSource  = nil
	local goReady  = nil

	-- 로딩중 카운트!
	count = function( event )
		-- 0보다 크면 숫자 커지기! 아니면 가만히 있기!
		if num >= 0 then
			text.text = "로딩 중 ("..num.."%)"
		end
		-- 100%가 되면 종료합니다
		if num == 100 then
			timer.cancel( event.source )
			text.text = "터치해서 시작"
			Runtime:addEventListener( "touch", goReady )
			timer.performWithDelay( 1200, opa, -1 )
		end
		num = num + 1
	end

	--'터시하면 시작'을 반짝거리게!
	opa = function( event )
		opaSource = event.source
		if text.alpha == 1 then
			--투명하게
			transition.to( text, { alpha = 0, time = 1000 } )
		elseif text.alpha == 0 then
			--진하게
			transition.to( text, { alpha = 1, time = 1000 } )
		end
	end

	-- 터치하면 넘어간다!
	goReady = function( event )
		-- 실행한 적이 있으면 멈추자.
		if opaSource ~= nil then
			timer.cancel( opaSource )
		end
		--표시된 배경/글자 지우기
		bg:removeSelf()
		text:removeSelf()
		--터치 이벤트 제거
		Runtime:removeEventListener( "touch", goRead )
		-- 안쓰는 숫자 제거
		num = nil
		--inGame()으로 넘어가기
		inGame()
	end

	--display.newImage( [parent,], filename [,baseDir] [,x,y] [,isFullResolution] )
	bg = display.newImage("bg.png",0,0)
	--bg의 중심 변경
	bg.anchorX, bg.anchorY = 0, 0

	--display.newText( [parentGroup,], text, x, y [, width, height], font [, fontSize] )
	text = display.newText("로딩 중 ( 0%)",_W/2, _H * 0.9, native.newFont("nanumSquareB.ttf"))

	nowMusic = "bgm/bgm_lobby.mp3"
	media.playSound( nowMusic, BGM )

	timer.performWithDelay( 5, count, -1 )

end

readyGame = function( )
	local bg = nil
	local text = nil
	local cookieText =
	{
		"달리기 하면 나지!",
		"마녀는 보이지 않는군… 이때다!",
		"                  안돼!\n 난 여기에서 빠져나가야겠어!",
		"이대로 먹힐 수는 없어!",
		"쿠키라고 무시하지 마!"

	}
	local num = math.random(1,5)
	local goGame = nil

	goGame = function( event )
		text:removeSelf()
		bg:removeSelf()
		cookieText = nil
		num = nil
		inGame()
	end

	media.stopSound( )

	bg = display.newImage("ready1b.png", 0, 0)
	bg.anchorX, bg.anchorY = 0, 0
	local scaleFactorX, scaleFactorY = _W/bg.contentWidth, _H/bg.contentHeight
	bg:scale(scaleFactorX,scaleFactorY)

	text = display.newText(cookieText[num], _W*0.75, _H*0.27, native.newFont("nanumSquareB.ttf"), "center")
	text:setFillColor( CC("000000") )

	media.playSound("bgm/g_start.mp3", goGame )
	

end

inGame = function( )
	--sound effect
	local jump = audio.loadSound("bgm/ch01jump.mp3")
	local slide audio.loadSound("bgm/ch01slide.mp3") 
	local alphabet = audio.loadSound("bgm/g_alphabet.mp3")
	local bigJelly = audio.loadSound("bgm/g_BigBearJelly.mp3")
	local bigCoin = audio.loadSound("bgm/g_BigCoinJelly.mp3")
	local coin = audio.loadSound("bgm/g_coin.mp3")
	local gold = audio.loadSound("bgm/g_gold.mp3")
	local jelly = audio.loadSound("bgm/g_jelly.mp3")
	local ob1 = audio.loadSound("bgm/g_obs1.mp3")
	local coinItem = audio.loadSound("bgm/i_coin.mp3")


	--변수들
	local bg1 = nil
	local bg2 = nil
	local enterFrames = nil
	local speed = 3
	-- 0 : null
	-- 1 : floor
	-- 2 : olive
	-- 3 : 압정
	-- 4 : gasi3
	-- 5 : long gasi2
	-- 6 : sausage fork
	local mapNumber =
	{
		1,1,1,1,1,1,1,1,1,1, 1,1,1,2,1,1,3,1,1,1,
		0,0,1,1,5,1,1,1,1,1, 1,1,0,0,1,1,1,6,1,1,
		1,1,0,0,1,1,1,0,0,1, 1,1,2,1,1,2,1,1,2,1,
		1,1,0,0,1,2,1,1,2,1, 1,1,1,1,1,1,1,1,1,1,
		1,1,1,2,1,1,3,1,1,1, 0,0,1,1,5,1,1,1,1,1,
		1,1,1,0,0,1,1,6,1,1, 1,1,0,0,1,1,1,0,0,1,
		1,1,2,1,1,2,1,1,2,1, 1,1,1,0,0,2,1,1,2,1,
		1,1,1,1,1,1,1,1,1,1, 1,1,1,2,1,1,3,1,1,1,
		0,0,1,1,5,1,1,1,1,1, 1,1,1,0,0,1,1,6,1,1,
		1,1,0,0,1,1,1,0,0,1, 1,1,2,1,1,2,1,1,2,1,
	}
	local floor = {}
	local speed = 5
	local nowNum = 1
	local zeroNum = 0
	local movedMap
	local makeObs
	local moveObs

	movedMap = function( event )
		bg1.x = bg1.x - 0.2
		bg2.x = bg2.x - 0.2

		for i = 1, 13, 1 do
			floor[i].x = floor[i].x - speed
		end

		if speed <= 15 then speed = speed + 0.03 end

		if bg1.x <= bg1.contentWidth * -1 then
			bg1.x = bg2.x + bg2.contentWidth
		end
		if bg2.x <= bg2.contentWidth * -1 then
			bg2.x = bg1.x + bg1.contentWidth
		end


		for i = 1, 13, 1 do
			if floor[i].x <= floor[i].contentWidth * -1 then

				if nowNum < 200 then
					nowNum = nowNum + 1
				else
					nowNum = 1
				end

				if mapNumber[nowNum] >= 1 then
					if i == 1 then
						floor[i].x = floor[13].x + floor[13].contentWidth*(1+zeroNum)
					else
						floor[i].x = floor[i-1].x + floor[i-1].contentWidth*(1+zeroNum)
					end
					zeroNum = 0
					if mapNumber[nowNum] ~= 1 then makeObs(mapNumber[nowNum], i) end
				else
					zeroNum = zeroNum + 1
				end
			end
		end
	end


--	makeObs = function(num, i)
--
--		local obs
--		local moveObs
--
--		moveObs = function( event )
--			obs.x = obs.x - speed
--			if obs.x <= obs.contentWidth * -1 then
--				obs:removeEventListener( "enterFrame", moveObs )
--				obs:removeSelf()
--			end
--		end
--
--
--		if num == 2 then
--			obs = display.newImage("obstacle/2.png", floor[i].x, floor[i].y - floor[i].contentHeight)
--			obs.anchorX, obs.anchorY = 0, obs.contentHeight
--			obs.name = "obs"
--			obs:addEventListener( "enterFrame", moveObs )
--		elseif num == 3 then
--		elseif num == 4 then
--		elseif num == 5 then
--		elseif num == 6 then
--		end
--	end


	display.setDrawMode( "hybrid" )
	physics.start()

	bg1 = display.newImage("back1.png", 0, 0 )
	bg1.anchorX, bg1.anchorY = 0, 0

	bg2 = display.newImage("back1.png", bg1.contentWidth, 0 )
	bg2.anchorX, bg2.anchorY = 0, 0

	for i = 1, 13, 1 do
		if mapNumber[i] >= 1 then
			floor[i] = display.newImage("obstacle/1.png")
			floor[i].x, floor[i].y = 111*(i-1), _H
			floor[i].anchorX, floor[i].anchorY = 0, floor[i].contentHeight
			floor[i].name = "floor"
			nowNum = nowNum + 1
			physics.addBody( floor[i], "static", { bounce = 0 } )
		end
	end



	nowMusic = "bgm/bgm_main.mp3"
	media.playSound( nowMusic, BGM )

	Runtime:addEventListener( "enterFrame", movedMap )
end

--startMenu()
--readyGame()
inGame()