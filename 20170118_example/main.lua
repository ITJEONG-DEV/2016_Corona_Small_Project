display.setStatusBar( display.HiddenStatusBar )

math.randomseed( os.time() )

local physics = require "physics"
local widget = require "widget"

local _W,_H = display.contentWidth, display.contentHeight

local outline = {}

local main, createLine, createButton, createBlock, setPhysics

local alpha, beta = 45, 250

local oldBlock = {}
local blockC = 1
local block
local buttonL, buttonR, buttonS

local CC = function(hex)
	local r = tonumber( hex:sub(1, 2), 16 ) / 255
	local g = tonumber( hex:sub(3, 4), 16 ) / 255
	local b = tonumber( hex:sub(5, 6), 16 ) / 255
	local a = 255/255
	if #hex == 8 then a = tonumber( hex:sub(7, 8), 16 ) / 255 end
	return r,g,b,a
end

createLine = function( )
	--세로선
	for i = 1, 10, 1 do
		outline = display.newLine( alpha + 70 * (i-1), _H - 70 * 14 - beta , alpha + 70 * (i-1), _H - beta )
		outline:setStrokeColor( CC("ffffff") )
		outline.strokeWidth = 2
		outline.alpha = 0.5
	end -- 45 ~ 675 : 70
	--가로선
	for i = 15, 1, -1 do
		outline = display.newLine( alpha, _H - 70 * (i - 1) - beta , 70 * 9 + alpha, _H - 70*(i-1) - beta )
		outline:setStrokeColor( CC("ffffff") )
		outline.strokeWidth = 2
		outline.alpha = 0.5
	end -- 250 ~ 1230 : 70
end

createButton = function( )
	local moveL, moveR, S

	moveL = function( )
		if block.x > alpha then
			block.x = block.x - 70
		end
	end
	moveR = function( )
		if block.x < _W - alpha - block.contentWidth then
			block.x = block.x + 70
		end
	end
	S = function( )
		block.rotation = block.rotation + 90
	end
	buttonL = widget.newButton({
		left = alpha,
		top = _H*0.85,
		defaultFile = "buttonL_off.png",
		overFile = "buttonL_on.png",
		onEvent = moveL,
	})
	buttonS = widget.newButton({
		left = _W/2 - 80,
		top = _H*0.85,
		defaultFile = "buttonS_off.png",
		overFile = "buttonS_on.png",
		onEvent = S,
	})
	buttonR = widget.newButton({
		left = _W - 210,
		top = _H*0.85,
		defaultFile = "buttonR_off.png",
		overFile = "buttonR_on.png",
		onEvent = moveR,
	})
end

createBlock = function( )
	local downBlock, collisionWithBlock
	local source

	downBlock = function( e )
		source = e.source
		if block.y >= 820 then
			timer.cancel(source)
			block.y = 820
			oldBlock[blockC] = block
			oldBlock[blockC].name = "block"
			blockC = blockC + 1
			createBlock()
		end
		block.y = block.y + 70
		print(block.y)
	end

	-- alpha / beta + 10
	local a = math.random(1,5)
	block = display.newImage( "shape"..a..".png", alpha + 70*3, _H - 14*70 - beta )
	physics.addBody( block, "dynamic" )

	if a == 1 then block.x = block.x + 70
	elseif a == 2 then block.x = block.x + 105
	elseif a == 3 then block.x = block.x + 70
	elseif a == 4 then block.x = block.x + 105
	else block.x = block.x + 140
		end

	block.collisionWithBlock = function( self, event )
		if event.other.name == "block" then
			timer.cancel(source)
		end
	end

	block:addEventListener( "collision", block )
	timer.performWithDelay( 750, downBlock, -1 )
end

setPhysics = function( )
	physics.start()
	physics.setGravity( 0, 0 )
end

main = function( )
	createLine( )
	setPhysics( )
	createBlock( )
	createButton( )
end


main()