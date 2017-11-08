local physics = require "physics"

local _W, _H = display.contentWidth, display.contentHeight

local function CC(hex)
	local r = tonumber( hex:sub(1,2), 16 ) / 255
	local g = tonumber( hex:sub(3,4), 16 ) / 255
	local b = tonumber( hex:sub(5,6), 16 ) / 255
	local a = 255 / 255

	if #hex == 8 then a = tonumber( hex:sub(7,8), 16 ) / 255 end

	return r, g, b, a
end

local start, createWalls
local wall = {}
local object = {}
local joint

function start()
  physics.start()
  --physics.setDrawMode( "hybrid" )
  createWalls()
  createObject()
  makePivot("pivot")
end

function createWalls()
  wall["left"] = display.newRect( -1, 0, 1, _H )
  wall["left"].anchorX, wall["left"].anchorY = 0, 0
  physics.addBody( wall["left"], "static", { } )

  wall["right"] = display.newRect( _W, 0, 1, _H )
  wall["right"].anchorX, wall["right"].anchorY = 0, 0
  physics.addBody( wall["right"], "static", { } )

  wall["top"] = display.newRect( 0, -1, _W, 1 )
  wall["top"].anchorX, wall["top"].anchorY = 0, 0
  physics.addBody( wall["top"], "static", { } )

  wall["bottom"] = display.newRect( 0, _H, _W, 1 )
  wall["bottom"].anchorX, wall["bottom"].anchorY = 0, 0
  physics.addBody( wall["bottom"], "static", { } )
end

function createObject()
  object["a"] = display.newRect( _W*0.5, _H*0.5, 150, 150 )
  object["a"]:setFillColor( CC("ff6600") )

  object["b"] = display.newRect( _W*0.6, _H*0.6, 150, 150 )
  object["b"].rotation = 45
  object["b"]:setFillColor( CC("66ff00") )
end

function makePivot(jointType)
  physics.addBody( object["a"], "static", { } )
  physics.addBody( object["b"], "dynamic", { } )

  if jointType == "pivot" then
    joint = physics.newJoint( "pivot", object["a"], object["b"], object["a"].x, object["a"].y )
  end
end



start()
