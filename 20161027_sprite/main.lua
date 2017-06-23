local _W = display.contentWidth
local _H = display.contentHeight
local cookieData =
{
   width = 100, 
   height = 100,
   numFrames = 7,
   sheetContentWidth = 700,
   sheetContentHeight = 100
}
local sheetData =
{
   {name = "run", frames = {1, 2, 3, 4, 5, 6}, time = 500, loopCount = 0}, 
   {name = "jump", frames = { 7 }, time = 500, loopCount = 0 }
}

local sheet = graphics.newImageSheet("cookie.png", cookieData )

local cookieAnimation = display.newSprite( sheet, sheetData)
cookieAnimation.x = _W / 2 - 75
cookieAnimation.y = _H /3 * 2 - 40
cookieAnimation:play()

local b = function ( e )
	cookieAnimation:setSequence( "run" )
	--cookieAnimation:play()
end

local c = function ( e )
	transition.to( cookieAnimation, { time = 300, y = cookieAnimation.y + 50, transition = easing.inQuad, onComplete = b })
end

local a = function ( e )
	cookieAnimation:setSequence("jump")
	--cookieAnimation:play()
	transition.to( cookieAnimation, { time = 300, y = cookieAnimation.y - 50, transition = easing.outQuad, onComplete = c } )
end

Runtime:addEventListener( "touch", a )