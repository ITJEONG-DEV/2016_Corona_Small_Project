local basicSettings = require "basicSettings"
local _W = display.contentWidth
local _H = display.contentHeight
local backG = nil
local title = nil
local toStart1 = nil
local score
local score_t
local seat
local stick
local ball
local map
local touch = true
local a = 0.5

local turn = function ( )
	if touch then touch = false
	end
end

local step1 = function( event )
	Runtime:addEventListener( "tap", turn )
	while touch do
		if stick.rotation >= 30 then a = 0.5
		elseif stick.rotation <= -30 then a = -0.5
		end
		stick.rotation = stick.rotation + a
	end
end

local inGame = function( )
	Runtime:removeEventListener( "tap", inGame )
	backG:setFillColor(0.7,1,1,1)
	title.text = "score : "
	title.size = 20
	title.x = 20 + title.contentWidth/2
	title.y = 45
	toStart1.text = ""
	basicSettings.basic()
	score = basicSettings.getScore()
	score_t = display.newText(score, 30+title.contentWidth,45)
	score_t.size = 20
	seat = display.newRect(0,_H*0.65,_W,_H*0.65)
	seat.anchorX, seat.anchorY = 0, 0
	seat:setFillColor( 0.5,0.5,1,1 )
	stick = display.newImage("putter.png",75,200)
	stick:scale(0.01,0.01)
	stick.anchorX, stick.anchorY = display.contentWidth/2, 0
	stick.alpha = 1
	Runtime:addEventListener( "enterFrame", step1 )

end

local newBack = function ()
	backG = display.newRect(0,0,_W,_H)
	backG:setFillColor(0.25,0.25,0.25)
	backG.anchorX, backG.anchorY = 0, 0
	title = display.newText( "Hole In 1",_W/2,_H/2-120 )
	title.size = 40
	-- Touch To Start 이미지 2개(alpha = 1과 alpha= 0.2가 disoolve 효과를 주도록)
	toStart1 = display.newText( "Touch To Start", _W/2, _H/2 )
	toStart1.size = 15
	Runtime:addEventListener( "tap", inGame )
end

newBack()