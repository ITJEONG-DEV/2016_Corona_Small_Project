local commonSettings = require "commonSettings"
local ballSet = require "ballSet"

local _W = display.contentWidth
local _H = display.contentHeight

local bg = display.newImage("realBack.png")
bg.anchorX, bg.anchorY = 0,0

local ball = ballSet.makeBall()-