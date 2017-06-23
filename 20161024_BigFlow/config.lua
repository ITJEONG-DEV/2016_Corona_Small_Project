--
-- For more information on config.lua see the Corona SDK Project Configuration Guide at:
-- https://docs.coronalabs.com/guide/basics/configSettings
--
local designSize = "fhd"

if not display then return end

local w, h = display.pixelWidth, display.pixelHeight

local normalW, normalH = ( w / h >= 0.6 ) and 640 or 640, 960
if designSize == "hd" then normalW, normalH = ( w / h >= 0.6 ) and 426.66 or 360, 640 end

local scale = math.max( normalW / w, normalH / h )
w, h = w * scale, h * scale

application =
{
	content =
	{
		width = w,
		height = h, 
		scale = "letterBox",
		fps = 30,
		audioPlayFrequency = 44100,
	},
}
