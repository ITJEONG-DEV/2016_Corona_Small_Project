
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
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

-- -----------------------------------------------------------------------------------
-- basic settttting!
-- -----------------------------------------------------------------------------------

local physics = require "physics"

physics.start()

local goMenu = function()
	composer.removeScene( "menu" )
	composer.gotoScene( "menu", { time = 800, effect = "crossFade" } )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	-- create & group & addEventListener
	backGroup = display.newGroup( )
	sceneGroup:insert( backGroup )

	mainGroup = display.newGroup( )
	sceneGroup:insert( mainGroup )

	uiGroup = display.newGroup( )
	sceneGroup:insert( uiGroup )

	local ground = display.newRect( backGroup, 0, _H*0.8, _W, _H*0.2 )
	ground.anchorX, ground.anchorY = 0, 0
	ground:setFillColor( CC("22ff22") )

	physics.addBody( ground, "static", { } )

	local ball = display.newCircle( mainGroup, _W*0.5, _H*0.5, 20 )
	physics.addBody( ball, "dynamic", { bounce = 0.5 } )

	local rb = display.newRoundedRect( uiGroup, _W*0.2, _H*0.05, _W*0.2, _H*0.05, 10 )
	rb:addEventListener( "touch", goMenu )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

		-- music?

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

		-- stop audio

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

	-- audio.dipose( musicTrack )

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
