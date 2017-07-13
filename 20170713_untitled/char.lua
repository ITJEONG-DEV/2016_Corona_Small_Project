local M = {}

function M.makeSprite()
	M.charData = 
	{
		width = 128,
		height = 128,
		numFrames = 4,
		sheetContentWidth = 512, 
		sheetContentHeight = 128,
	}
	M.charSet = 
	{
		{ name = "normal", frames = { 1 }, loopCount = 0 },
		{ name = "walk", frames = { 1, 2, 3, 4 }, loopCount = 0 },
	}
	M.charSheet = graphics.newImageSheet( "char_image.png", M.charData )

	M.char = display.newSprite( M.charSheet, M.charSet )

	print(M.char)

	return M.char
end

return M