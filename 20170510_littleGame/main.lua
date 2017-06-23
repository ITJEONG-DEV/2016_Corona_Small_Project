
display.setStatusBar( display.HiddnStatusBar )

display.topStatusBarContentHeight = 0
display.statusBarHeight = 0

system.activate( "multiTouch" )

----------------------------------------------------------------------

local physics = require "physics"

physics.start()

----------------------------------------------------------------------

local _W, _H = display.contentWidth, display.contentHeight

local CC = function (hex)
	local r = tonumber( hex:sub(1,2), 16 ) / 255
	local g = tonumber( hex:sub(3,4), 16 ) / 255
	local b = tonumber( hex:sub(5,6), 16 ) / 255
	local a = 255 / 255

	if #hex == 8 then a = tonumber( hex:sub(7,8), 16 ) / 255 end

	return r, g, b, a
end

----------------------------------------------------------------------
--[[
local block = {}
local ball, i
local onTouchBall

block[1] = display.newRect( 0, -10, _W, 10 )
block[2] = display.newRect( -10, 0, 10, _H )
block[3] = display.newRect( _W, 0, 10, _H )
block[4] = display.newRect( 0, _H, _W, 10 )

for i = 1, 4, 1 do
	block[i].anchorX, block[i].anchorY = 0, 0
	physics.addBody( block[i], "static", { bounce = 0.6, friction = 24.0, density = 24.0 } )
end

ball = display.newCircle( _W/2, _H/2, 25 )
ball.anchorX, ball.anchorY = 0, 0
ball:setFillColor( CC("FFCC00") )
physics.addBody( ball, "dynamic", { bounce = 0.66, frictoin = 1.0, density = 1.0 } )
physics.setGravity( 0, 0 )

onTouchBall = function( )
end

]]--
physics.setDrawMode( "hybrid" )
local j1 = display.newRect( _W/2, _H/2, 100, 40 )
local j2 = display.newRect( _W/3, _H/3, 40, 100 )
local j3 = display.newRect( 10, 70, _W-10, 10 )
j1.anchorX, j1.anchorY = 0, 0
j2.anchorX, j2.anchorY = 0, 0
j3.anchorX, j3.anchorY = 0, 0
j1:setFillColor( CC("ff6600") )
j2:setFillColor( CC("66ff00") )
j3:setFillColor( CC("0066ff") )
physics.addBody( j1, "dynamic", {} )
physics.addBody( j2, "dynamic", {} )
physics.addBody( j3, "static", {} )
--physics.setGravity( 0, 0 )

local pivotJoint = physics.newJoint( "pivot", j1, j2, 500, 50 )