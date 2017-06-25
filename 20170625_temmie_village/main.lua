-- -----------------------------------------------------------------------------------
-- default set
-- -----------------------------------------------------------------------------------

-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )

display.statusBarHeight = 0

-- Reserve channel 1 for background music
audio.reserveChannels( 1 )
-- Reduce the overall volume of the channel
audio.setVolume( 0.05, { channel=1 } )

-- Seed the random number generator
math.randomseed( os.time() )

local _W, _H = display.contentWidth, display.contentHeight

local CC = function (hex)
	local r = tonumber( hex:sub(1,2), 16 ) / 255
	local g = tonumber( hex:sub(3,4), 16 ) / 255
	local b = tonumber( hex:sub(5,6), 16 ) / 255
	local a = 255 / 255

	if #hex == 8 then a = tonumber( hex:sub(7,8), 16 ) / 255 end

	return r, g, b, a
end

-- -----------------------------------------------------------------------------------
-- code here
-- -----------------------------------------------------------------------------------
local start, initTemmie, randomTemmie, moveTemmie, onTemmie, onTemmie2
local bg, temmieSheet, temmieData, temmie, reverseTemmie

start = function()
	bg = display.newRect( 0, 0, _W, _H )
	bg:setFillColor( CC("ffffff") )
	bg.anchorX, bg.anchorY = 0, 0

	initTemmie()
end

initTemmie = function()
	temmieSheet = graphics.newImageSheet( "temmie.png", { width = 200, height = 200, numFrames = 6, sheetContentWidth = 1200, sheetContentHeight = 200 })
	temmieData =
	{
		{ name = "default", frames = { 3, 4 }, time = 800 },
		{ name = "bud", frames = { 1, 2 }, time = 350 },
		{ name = "walk", frames = { 5, 3, 6, 4 }, time = 1000 }
	}

	temmie = display.newSprite( temmieSheet, temmieData )

	reverseTemmie = 1

	temmie.x, temmie.y = _W/2, _H/2
	temmie:play()
	temmie:addEventListener( "touch", onTemmie )

	randomTemmie()	

	--timer.performWithDelay( delay, listener [, iterations] )

end

randomTemmie = function()
	local time, x, y
	local count = 0
	local pers = 30
	local moveTemmie, stopTemmie

	moveTemmie = function( e )
		timerID = e.source
		-- print("++x : "..x.." reverse : "..reverseTemmie.." ".. count*30 .." /"..time)
		temmie.x, temmie.y = temmie.x + x, temmie.y + y

		count = count + 1

		if temmie.x < 100 or temmie.x + 100 > _W or temmie.y < 100 or temmie.y + 0 > _H then
			count = time / pers
		end


		-- if ended > setSequence "default"
		if count >= time / pers then
			stopTemmie( )
		end
	end

	stopTemmie = function( )
		timer.cancel( timerID )
		temmie:setSequence( "default" )
		temmie:play()
		randomTemmie()
	end

	-- random time and x, y
	time = math.random( 10, 30 ) * 100
	x = math.random( 0, 1 ) * math.pow( -1, math.random( 0, 1 ) )
	y = math.random( 0, 1 ) * math.pow( -1, math.random( 0, 1 ) )

	--reverse axis X
	if x > 0  then reverseTemmie = -1
	elseif x < 0 then reverseTemmie = 1
	end
	temmie:scale( reverseTemmie, 1 )

	-- isStay?
	if x ~= 0 or y ~= 0 then
		temmie:setSequence( "walk" )
		temmie:play()
	end

	timer.performWithDelay( pers, moveTemmie, time/pers )
end

onTemmie = function( e )
	if e.phase == "began" then
		if timerID then timer.cancel(timerID) end
	elseif e.phase == "moved" then
		if temmie.sequence ~= "bud" then
			temmie:setSequence( "bud" )
			temmie:play()
		end
		temmie.x = e.x
		temmie.y = e.y
		if temmie.x < 100 then temmie.x = 100
		elseif temmie.x + 100 > _W then temmie.x = _W - 100
		end

		if temmie.y < 100 then temmie.y = 100
		elseif temmie.y + 100 > _H then temmie.y = _H - 100
		end
	elseif e.phase == "ended" then
		temmie:setSequence( "default" )
		temmie:play()
		onTemmie2()
		randomTemmie()
	end
end

onTemmie2 = function()
	local a = math.random( 1, 4 )
	if a == 1 then media.playSound( "audioEffect/bob.mp3" )
	elseif a == 2 then media.playSound( "audioEffect/imbob.mp3" )
	elseif a == 3 then media.playSound( "audioEffect/temmie.mp3" )
	elseif a == 4 then media.playSound( "audioEffect/temmie2.mp3" )
	end
end


start()