-- require modules
local setMon = require "setMonster"
local widget = require "widget"

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
local compare, compete, competeB, exportB, textCount, bg

-- stage count
local count = 0

local maxSum = 50

-- default user set
local user = 
{
	hp = 25,
	atk = 25,
	max = 25,
	mp = 25,
	weight = 50
}

local monData = {}

function onStart( e )
	if e.phase == "began" then
		-- setMonData
		for i = 1, 20, 1 do
			monData[i] = setMon.setMon(maxSum)
			-- print(i.."번 째 몬스터.".." hp : "..monData[i].max.." atk : "..monData[i].atk)
			compete(i)
		end


		table.sort( monData, compare )

		for i, v in pairs( monData ) do
			print( i, v.score )
		end

		count = count + 1

		textCount.text = "generatoin : "..count
	end
end

function compete( num )
	local turn = 0
	local flag

	getScore = function ( n )
		if n == 1 then return 20 + 10 - math.abs( turn - 5 ) + 10 - user.hp
		elseif n == 2 then return 10 + 10 - math.abs( turn - 5 ) + 10 - user.hp
		elseif n == 3 then return -20 + 10 - math.abs( turn - 5 ) + 10 - user.hp
		elseif n == 4 then return -15 + 10 - math.abs( turn - 5 ) + 10 - user.hp
		end
	end

	flag = nil

	monData[num].score = 0
	user.hp = user.max
	monData[num].hp = monData[num].max

	-- user first
	for turn = 1, 10, 1 do
		-- print( num.."번 째 몬스터와 1 번 째 전투 중 "..turn.."스테이지. 몬스터 : "..monData[num].hp .." 유저 : "..user.hp)

		monData[num].hp = monData[num].hp - math.floor( user.atk * 0.2 )
		-- print("몬스터에게 "..math.floor( user.atk * 0.2).."만큼의 데이지를 입혔습니다. 남은 몬스터의 체력 "..monData[num].hp)

		user.hp = user.hp - math.floor( monData[num].atk * 0.2 )
		-- print("몬스터가 "..math.floor( monData[num].atk * 0.2).."만큼의 데이지를 입혔습니다. 남은 체력 "..user.hp)

		if monData[num].hp <= 0 then
			monData[num].score = monData[num].score + getScore(1)
			flag = true
			break
		elseif user.hp <= 0 then
			monData[num].score = monData[num].score + getScore(2)
			flag = true
			break
		end
	end

	if not flag then
		if monData[num].hp < user.hp then
			monData[num].score = monData[num].score + getScore(3)
		elseif monData[num].hp > user.hp then
			monData[num].score = monData[num].score + getScore(4)
		end
	end

	print(num.."번째 몬스터의 1 번 째 점수 : "..monData[num].score)

	-- ------------------------------------------------------------

	user.hp = user.max
	monData[num].hp = monData[num].max

		-- mon first
	for turn = 1, 10, 1 do
		-- print( num.."번 째 몬스터와 2 번 째 전투 중 "..turn.."스테이지. 몬스터 : "..monData[num].hp .." 유저 : "..user.hp)

		user.hp = user.hp - math.floor( monData[num].atk * 0.2 )
		-- print("몬스터가 "..math.floor( monData[num].atk * 0.2).."만큼의 데이지를 입혔습니다. 남은 체력 "..user.hp)

		monData[num].hp = monData[num].hp - math.floor( user.atk * 0.2 )
		-- print("몬스터에게 "..math.floor( user.atk * 0.2).."만큼의 데이지를 입혔습니다. 남은 몬스터의 체력 "..monData[num].hp)

		if monData[num].hp <= 0 then
			monData[num].score = monData[num].score +  getScore(1)
			flag = true
			break
		elseif user.hp <= 0 then
			monData[num].score = monData[num].score + getScore(2)
			flag = true
			break
		end
	end

	if not flag then
		if monData[num].hp < user.hp then
			monData[num].score = monData[num].score + getScore(3)
		elseif monData[num].hp > user.hp then
			monData[num].score = monData[num].score + getScore(4)
		end
	end

	print(num.."번째 몬스터의 2 번 째 점수 : "..monData[num].score/2)
end

function compare(a, b)
	return a.score > b.score
end

function saveD(e)
	if e.phase == "began" then
	end
end

-- bg = display.newRect( 0, 0, _W, _H )
-- bg:setFillColor( CC("ff6600") )
-- bg.anchorX, bg.anchorY = 0, 0

competeB = widget.newButton(
    {
        label = "경쟁하기",
        onEvent = onStart,
        fontSize = 15,
        emboss = true,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        top = _H*0.85,
        left = 10,
        width = 100,
        height = 30,
        cornerRadius = 2,
        labelColor = { default={ CC("666666") }, over={ CC("666666")} },
        fillColor = { default={ CC("ffffff") }, over={ CC("888888")} },
    }
)

exportB = widget.newButton(
    {
        label = "내보내기",
        onEvent = saveD,
        fontSize = 15,
        emboss = true,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        top = _H*0.85,
        left = 120,
        width = 100,
        height = 30,
        cornerRadius = 2,
        labelColor = { default={ CC("666666") }, over={ CC("666666")} },
        fillColor = { default={ CC("ffffff") }, over={ CC("888888")} },
    }
)

textCount = display.newText( "generation : "..count, _W*0.125, _H*0.775 )

-- -----------------------------------------------------------------------------------
-- event function listeners
-- -----------------------------------------------------------------------------------
