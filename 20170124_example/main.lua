display.setStatusBar( display.HiddenStatusBar )

-- box2d를 사용하기 위해 불러옴
local physics = require "physics"

local _W, _H = display.contentWidth, display.contentHeight

-- 중심점 고정
display.setDefault( "anchorX", 0 )
display.setDefault( "anchorY", 0 )

--box2d 시작
physics.start()

local createWall, onAccelerate
local ball, miro, physicsData

--물리법칙이 적용되는 물체가 어떤 건지 알려주는 친구
display.setDrawMode( "hybrid" )

--createWall 시작
createWall = function( )
	local wall
	wall = display.newRect( 0, -5, _W, 10 )
	physics.addBody( wall, "static", { } )
	wall = display.newRect( -5, 0, 10, _H )
	physics.addBody( wall, "static", { } )
	wall = display.newRect( _W-5, 5, 10, _H-5 )
	physics.addBody( wall, "static", { } )
	wall = display.newRect( 5, _H-5, _W-10, 10 )
	physics.addBody( wall, "static", { } )
end
--createWall 끝

--onAccelerate 시작
onAccelerate = function( event )
	physics.setGravity( event.xRaw, event.yRaw )
	print( event.xRaw, event.yRaw )
end
--onAccelerate 끝

physics.setGravity( 0, 0 )

physicsData = (require "miro01").physicsData(1.0)
miro = display.newImage("miro01.png")
physics.addBody( miro, "static", physicsData:get("miro01"))


createWall()
-- 공을 만들어서, 물리를 적용함
ball = display.newCircle( 100, 100, 20 )
physics.addBody( ball, "dynamic" )

Runtime:addEventListener( "accelerometer", onAccelerate )