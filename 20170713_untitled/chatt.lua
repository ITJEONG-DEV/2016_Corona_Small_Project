local M = { }

local _W, _H = display.contentWidth, display.contentHeight

local font = 
{
	native.newFont( "NanumSquareB.ttf" )
}

local CC = function (hex)
	local r = tonumber( hex:sub(1,2), 16 ) / 255
	local g = tonumber( hex:sub(3,4), 16 ) / 255
	local b = tonumber( hex:sub(5,6), 16 ) / 255
	local a = 255 / 255

	if #hex == 8 then a = tonumber( hex:sub(7,8), 16 ) / 255 end

	return r, g, b, a
end

local a, b, c, showText, id, id2, createChatUI, flag
local num = 0

function createChatUI()
	a = display.newRect( _W*0.5, _H*0.86, _W*0.95, _H*0.2 )

	b = display.newRect( _W*0.5, _H*0.86, _W*0.95 -10, _H*0.2 -10 )
	b:setFillColor( CC("000000") )

	c = display.newPolygon( _W*0.93, _H*0.81, { 0, 0, 16, 0, 8, 12 } )
	-- c.alpha = 0
 	
	showText = display.newText( "", _W*0.06, _H*0.8, font[1], 25 )
	showText.anchorX, showText.anchorY = 0, 0
end

function twinkle(e)
	id2 = e.source
	local params = e.source.params
	--print(params.isAlpha)

	if params.isAlpha then
		c.alpha = 1
		params.isAlpha = false
	else
		c.alpha = 0
		params.isAlpha = true
	end
end

function M.showChat(textArray)
	local press, showDialog, goNext, first, setTimer, tm
	function press(e)
		local keyName = e.keyName

		if e.phase == "down" then
			-- z : 넘기기
			-- x : 빨리 재생하기
			if keyName == "z" then
				if flag then
					flag = false
					goNext()
				end
			elseif keyName == "x" then
				if not flag then
					if num ~= table.maxn(textArray) then
						print("flag1")
						setTimer()
					end
				end
				if showText.text ~= text then
					timer.cancel(id)
					showText.text = text
					flag = true
				end
			end
		end
	end
	function showDialog(e)
		id = e.source

		if string.len(showText.text) == string.len(text) then
			if num ~= table.maxn(textArray) then
				print("flag2")
				setTimer()
			end	
			timer.cancel(id)
			flag = true
		end

		showText.text = showText.text .. text:sub( string.len(showText.text)+1, string.len(showText.text)+3 )
		-- showText.text = showText.text..M.text:sub( string.len(showText.text)+1, string.len(showText.text)+3)
	end
	function goNext()
		c.alpha = 0
		if id2 then timer.cancel(id2) end	
		showText.text = ""
		num = num + 1
		text = textArray[num]
		if num <= table.maxn( textArray ) then
			timer.performWithDelay( 100, showDialog, -1 )
		else
			timer.cancel(id)
			if id2 then timer.cancel(id2) end
			Runtime:removeEventListener( "key", press )
			a:removeSelf( )
			b:removeSelf( )
			c:removeSelf( )
			showText:removeSelf( )
			flag = nil
		end
	end
	function setTimer()
		print("2 num : "..num.." textArray : "..table.maxn(textArray))
		tm = timer.performWithDelay( 600, twinkle, -1 )
		tm.params = { isAlpha = true }
	end
	function first()
		createChatUI()
		Runtime:addEventListener( "key", press )

		goNext()
	end

	first()
end

return M