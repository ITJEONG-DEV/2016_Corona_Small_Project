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

local a, b, showText, id, createChatUI, flag
local num = 0

function createChatUI()
	a = display.newRect( _W*0.5, _H*0.86, _W*0.95, _H*0.2 )

	b = display.newRect( _W*0.5, _H*0.86, _W*0.95 -10, _H*0.2 -10 )
	b:setFillColor( CC("000000") )

	showText = display.newText( "", _W*0.06, _H*0.8, font[1], 25 )
	showText.anchorX, showText.anchorY = 0, 0
end

function M.showChat(textArray)
	local press, showDialog, goNext, first
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
				timer.cancel(id)
				showText.text = text
				flag = true
			end
		end
	end
	function showDialog(e)
		id = e.source

		if string.len(showText.text) == string.len(text) then
			timer.cancel(id)
			flag = true
		end

		showText.text = showText.text .. text:sub( string.len(showText.text)+1, string.len(showText.text)+3 )
		-- showText.text = showText.text..M.text:sub( string.len(showText.text)+1, string.len(showText.text)+3)
	end
	function goNext()
		showText.text = ""
		num = num + 1
		text = textArray[num]
		if num <= table.maxn( textArray ) then
			timer.performWithDelay( 100, showDialog, -1 )
		else
			timer.cancel(id)
			Runtime:removeEventListener( "key", press )
			a:removeSelf( )
			b:removeSelf( )
			showText:removeSelf( )
			flag = nil
		end
	end

	function first()
		createChatUI()
		Runtime:addEventListener( "key", press )

		goNext()
	end

	first()
end

return M