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
local bg
bg = display.newRect( 0,0,_W,_H )
bg.anchorX, bg.anchorY = 0, 0
bg:setFillColor( CC("666666") )


chatt.showChat(
{ 
	"5  한국디지털미디어고등학교",
	"4  안녕   나는   테미야!  그리고   여기는   내   친구  .  .  .   테미!!!",
	"3  한국디지털미디어고등학교",
	"2  안녕   나는   테미야!  그리고   여기는   내   친구  .  .  .   테미!!!",
	"1  한국디지털미디어고등학교",
	"0  안녕   나는   테미야!  그리고   여기는   내   친구  .  .  .   테미!!!",
})

function press(e)
	local keyName = e.keyName
	if e.phase == "down" then
		if keyName == "up" then
		elseif keyName == "down" then
		elseif keyName == "left" then
		elseif keyName == "right" then
		end
	end
end