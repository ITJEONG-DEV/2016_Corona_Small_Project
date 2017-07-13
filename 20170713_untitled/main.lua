math.randomseed( os.time( ) )
-- -----------------------------------------------------------------------------------
-- require modules
-- -----------------------------------------------------------------------------------
local json = require "json"
local chatt = require "chatt"
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
local press, makeSprite, move
local bg, char
local goX, goY = 0, 0
local isFlip = false
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
	if e.phase == "down" then
		if keyName == "up" then goY = -2
		elseif keyName == "down" then goY = 2
		elseif keyName == "left" then
			goX = -2
			if not isFlip then
				char:scale(-1, 1)
				isFlip = false
			end
		elseif keyName == "right" then
			goX = 2
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
	end
	print("X : "..goX.."\tY : "..goY)
end

function move()
	print(char.x, char.y)
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
		width = 128,
		height = 128,
		numFrames = 4,
		sheetContentWidth = 512, 
		sheetContentHeight = 128,
	}
	charSet = 
	{
		{ name = "normal", frames = { 1 }, loopCount = 0 },
		{ name = "walk", frames = { 1, 2, 3, 4 }, loopCount = 0, time = 300 },
	}
	charSheet = graphics.newImageSheet( "char_image.png", charData )

	char = display.newSprite( charSheet, charSet )
	Runtime:addEventListener( "enterFrame", move )

	char.x, char.y = _W*0.5, _H*0.5

	char:setSequence( "walk" )
	char:play()
end

Runtime:addEventListener( "key", press )
makeSprite()