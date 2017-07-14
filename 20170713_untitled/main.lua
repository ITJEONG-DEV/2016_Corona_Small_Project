math.randomseed( os.time( ) )
-- -----------------------------------------------------------------------------------
-- require modules
-- -----------------------------------------------------------------------------------
local json = require "json"
local chatt = require "chatt"
local physics = require "physics"
-- -----------------------------------------------------------------------------------
-- basic setttttting!
-- -----------------------------------------------------------------------------------
local _W, _H = display.contentWidth, display.contentHeight

local CC = function (hex)
	local r = tonumber( hex:sub(1,2), 16 ) / 255
	local g = tonumber( hex:sub(3,4), 16 ) / 255
	local b = tonumber( hex:sub(5,6), 16 ) / 255
	local a = 255 / 255

	if #hex == 8 then a = tonumber( hex:sub(7,8), 16 ) / 255 end

	return r, g, b, a
end

local NanumGothicCoding = native.newFont( "NanumSquareB.ttf" )
-- local userPath = 'C:/Users/derba/Desktop/2017_Corona_Small_Project/20170710_GA/user.txt'
-- -----------------------------------------------------------------------------------
-- basic setttttting!
-- -----------------------------------------------------------------------------------
local press, makeSprite, move, charSprite, makeBox
local bg, char, box
local goX, goY = 0, 0
local speed = 2.5
local isFlip = false
local isAttacked = false
local isDamaged = false
local isDied = false
bg = display.newRect( 0,0,_W,_H )
bg.anchorX, bg.anchorY = 0, 0
bg:setFillColor( CC("666666") )

--[[
chatt.showChat(
{ 
	"5  한국디지털미디어고등학교",
	"4  안녕   나는   테미야!  그리고   여기는   내   친구  .  .  .   테미!!!",
	"3  한국디지털미디어고등학교",
	"2  안녕   나는   테미야!  그리고   여기는   내   친구  .  .  .   테미!!!",
	"1  한국디지털미디어고등학교",
	"0  안녕   나는   테미야!  그리고   여기는   내   친구  .  .  .   테미!!!",
})
]]--

function press(e)
	local keyName = e.keyName
	print(keyName)
	if e.phase == "down" then
		char:setSequence( "walk" )
		char:play()
		if keyName == "z" then
			isAttacked = true
			print("leftCtrl")
			char:setSequence( "attack" )
			char:play()
		elseif keyName == "leftControl" then
			isDamaged = true
			char:setSequence( "damage" )
			char:play()
		elseif keyName == "x" then
			isDamaged = true
			char:setSequence( "dead" )
			char:play()
		elseif keyName == "up" then goY = -1 * speed
		elseif keyName == "down" then goY = speed
		elseif keyName == "left" then
			goX = -1 * speed
			if not isFlip then
				char:scale(-1, 1)
				isFlip = true
			end
		elseif keyName == "right" then
			goX = speed
			if isFlip then
				char:scale(-1, 1)
				isFlip = false
			end
		end
	elseif e.phase == "up" then
		if keyName == "up" then goY = 0
		elseif keyName == "down" then goY = 0
		elseif keyName == "left" then goX = 0
		elseif keyName == "right" then goX = 0
		end

		if goX == 0 and goY == 0 and not ( isAttacked or isDamaged or isDied ) then
			char:setSequence( "normal" )
			char:play()
		end
	end
	-- print("X : "..goX.."\tY : "..goY)
end

function charSprite(e)
	print(e.target.sequence)
	if e.phase == "ended" then
		if e.target.sequence == "attack" then
			print("sequence : "..e.target.sequence.."\t")
			isAttacked = false
			e.target:setSequence("normal")
		end
	end
end

function move()
	-- print(char.x, char.y)
	char.x, char.y = char.x + goX, char.y + goY
	if char.x + char.contentWidth/2 > _W then
		char.x = _W - char.contentWidth/2
	elseif char.x - char.contentWidth/2 < 0 then
		char.x = char.contentWidth/2
	end

	if char.y + char.contentHeight/2 > _H then
		char.y = _H - char.contentHeight/2
	elseif char.y - char.contentHeight/2 < 0 then
		char.y = char.contentHeight/2
	end
end

function makeSprite()
	charData = 
	{
		width = 100,
		height = 100,
		numFrames = 36,
		sheetContentWidth = 600, 
		sheetContentHeight = 600,
	}
	charSet = 
	{
		{ name = "normal", frames = { 1, 2, 3, 4, 5, 6 }, loopCount = 0, time = 1000 },
		{ name = "walk", frames = { 7, 8, 9, 10, 11, 12 }, loopCount = 0, time = 500 },
		{ name = "attack", frames = { 13, 14, 15, 16, 17, 19, 20, 21, 22, 23 }, loopCount = 1, time = 1000 },
		{ name = "damage", frames = { 18 }, loopCount = 1, time = 500 },
		{ name = "dead", frames = { 25, 26, 27, 28, 29, 31, 32, 33, 34, 35 }, loopCount = 1, time = 1000 }
	}
	charSheet = graphics.newImageSheet( "witchCat.png", charData )

	char = display.newSprite( charSheet, charSet )
	char:addEventListener( "sprite", charSprite )
	Runtime:addEventListener( "enterFrame", move )

	char.x, char.y = _W*0.5, _H*0.5

	char:setSequence( "normal" )
	char:scale(-1, 1)
	char:play()
end

function makeBox()
	box = display.newImage("unlock.png", _W*0.2, _H*0.5)
	boxPhysicsData = (require "box").physicsData(1.0)
	box:scale(0.5,0.5)

	physics.addBody( box, "static", boxPhysicsData:get("box") )
end
display.setDrawMode( "hybrid" )
physics.start( )
physics.setGravity( 0, 0 )
Runtime:addEventListener( "key", press )
makeSprite()
makeBox()

