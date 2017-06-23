local Class = {}

local _W = display.contentWidth
local _H = display.contentHeight
local backG = nil
local title = nil
local toStart1 = nil
local toStart2 = nil
local Trans = true

Class.newBack = function ()
	backG = display.newRect(0,0,_W,_H)
	backG:setFillColor(0.25,0.25,0.25)
	backG.anchorX, backG.anchorY = 0, 0
	title = display.newText( "Hole In 1",_W/2,_H/2-120 )
	title.size = 40
	toStart1 = display.newText( "Touch To Start", _W/2, _H/2 )
	toStart1.size = 15
end

return Class