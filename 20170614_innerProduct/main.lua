local _W, _H = display.contentWidth, display.contentHeight

local widget = require "widget"

local create, showT, moveM, product, rotateLB, rotateRB, onButtonL, onButtonR
local player, playerT, playerV, monster, monsterT, showTP, showTM, showFB, showLR, showR, showV

create = function( )
	playerV = display.newLine( _W/2, _H/2, _W/2, _H/2 - 500 )
	playerV.strokeWidth = 4
	playerV.anchorX, playerV.anchorY = playerV.contentWidth/2, playerV.contentHeight

	player = display.newCircle( _W/2, _H/2, 50 )
	player:setFillColor( 0, 1, 1 )
	player:addEventListener( "touch", moveE )

	playerT = display.newText( "P", player.x, player.y )
	playerT:setTextColor( 0, 0, 0 )

	monster = display.newCircle( _W*0.2, _H*0.3, 35 )
	monster:setFillColor( 1, 1, 0 )
	monster:addEventListener( "touch", moveE )

	monsterT = display.newText( "M", monster.x, monster.y )
	monsterT:setTextColor( 0, 0, 0 )

	rotateLB = widget.newButton(
		{
			left = _W*0.2,
			top = _H*0.9,
			label = "Go left",
			labelColor = { default = { 1, 1, 1 }, over = { 0.5, 0.5, 0.5 } },
			fontSize = 40,
			onEvent = onButtonL
		}
	)
	rotateRB = widget.newButton(
		{
			left = _W*0.55,
			top = _H*0.9,
			label = "Go right",
			fontSize = 40,
			labelColor = { default = { 1, 1, 1 }, over = { 0.5, 0.5, 0.5 } },
			onEvent = onButtonR	
		}
	)

	showTP = display.newText( "Player x : "..player.x.."\nPlayer y : "..player.y, _W*0.05, _H*0.8 )
	showTM = display.newText( "Monster x : "..monster.x.."\nMonster y : "..monster.y, _W*0.57, _H*0.8 )
	showFB = display.newText( "", _W*0.25, _H*0.65 )
	showLR = display.newText( "", _W*0.65, _H*0.65 )
	showTP.anchorX, showTM.anchorX = 0, 0
	showFB.anchorX, showFB.anchorY = 0, 0
	showLR.anchorX, showLR.anchorY = 0, 0
	showR = display.newText( "", _W*0.5, _H*0.75 )

	Runtime:addEventListener( "enterFrame", showT )
end

showT = function( )
	showTP.text = "Player x : "..player.x.."\nPlayer y : "..player.y
	showTM.text = "Monster x : "..monster.x.."\nMonster y : "..monster.y
end

onButtonR = function( e )
	if e.phase == "ended" then
		product()
	elseif e.phase == "began" or e.phase == "moved" then
		playerV.rotation = ( playerV.rotation + 1 ) %360
		showR.text = "rotation : "..playerV.rotation
		product()
	end
end

onButtonL = function( e )
	if e.phase == "ended" then
		product()
	elseif e.phase == "began" or e.phase == "moved" then
		playerV.rotation = ( playerV.rotation - 1 ) %360
		showR.text = "rotation : "..playerV.rotation
		product()
	end
end

moveE = function( e )
	if e.x <= e.target.contentWidth/2 then e.target.x = e.target.contentWidth/2
	elseif e.x >= _W - e.target.contentWidth/2 then e.target.x = _W - e.target.contentWidth/2
	else e.target.x = e.x
	end

	if e.y <= e.target.contentHeight/2 then e.target.y = e.target.contentHeight/2
	elseif e.y >= _H - e.target.contentHeight/2 then e.target.y = _H - e.target.contentHeight/2
	else e.target.y = e.y
	end

	playerT.x, playerT.y = player.x, player.y
	monsterT.x, monsterT.y = monster.x, monster.y
	playerV.x, playerV.y = player.x, player.y

	product()
end

product = function( )
	local A, F, R = {}, {}, {}

	A.x = ( monster.x + monster.anchorX ) - ( player.x + player.anchorX )
	A.y = ( monster.y + monster.anchorY ) - ( player.y + player.anchorY )
	A.z = 0

	F.x = 0
	F.y = ( player.y + player.anchorY )
	F.z = 0

	R.x = F.y * math.sin(playerV.rotation)
	R.y = F.y * ( math.cos(playerV.rotation) )
	R.z = 0

	local cos =  ( R.x * A.x + R.y * A.y ) /  ( math.sqrt( A.x * A.x + A.y * A.y ) * F.y )
	local sin = ( A.x * R.y - A.y * R.x ) / ( math.sqrt( A.x * A.x + A.y * A.y ) * F.y )

	print("rotate : "..playerV.rotation.." R.x : "..R.x.." R.y : "..R.y.." sin : "..sin)


	--print("COS : " ..cos)

	if cos > 0 then showFB.text = "BACK"
	else showFB.text = "FRONT"
	end
	if sin > 0 then showLR.text = "RIGHT"
	else showLR.text = "LEFT"
	end
end

create()

product()
