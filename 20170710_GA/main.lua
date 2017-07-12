display.setStatusBar( display.HiddenStatusBar )
-- -----------------------------------------------------------------------------------
-- require modules
-- -----------------------------------------------------------------------------------
local setMon = require "setMonster"
local widget = require "widget"
local json = require "json"
-- -----------------------------------------------------------------------------------
-- basic setttttting!
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

local NanumGothicCoding = native.newFont( "NanumGothicCoding.ttf" )
local userPath = 'C:/Users/derba/Desktop/2017_Corona_Small_Project/20170710_GA/user.txt'
-- -----------------------------------------------------------------------------------
-- basic setttttting!
-- -----------------------------------------------------------------------------------

--default user set
local user =
{
	["hp"] = 10,
	["atk"] = 10,
	["max"] = 10,
	["mp"] = 10,
	["weight"] = 50,
	["lv"] = 1,
	["generation"] = 0,
	["maxSum"] = 20
}

local monData = {}

local renewData, onCompete, compete, saveMonsterData, saveUserData, loadUserData, createUI
local competeB, importB, showGeneration, showUserStatus

function renewData()
	showGeneration.text = "generation : "..user.generation
	showUserStatus.text = "<user status>\n\n user lv : "..user.lv.."\n user hp : "..user.max.."\n user atk : "..user.atk.."\n user mp : "..user.mp.."\n user weight : "..user.weight
end

function onCompete( e )
	local function compare(a, b)
		return a.score > b.score
	end

	if e.phase == "began" then

		--setMonData & compete
		for i = 1, 20, 1 do
			monData[i] = setMon.setMon(user.maxSum)
			-- print(i.."번 째 몬스터.".." hp : "..monData[i].max.." atk : "..monData[i].atk)
			compete(i)
		end

		--sort
		table.sort( monData, compare )

		-- for i, v in pairs(monData) do
		--	print( i, v.score )
		-- end

		user.generation = user.generation + 1

		saveUserData()
		loadUserData({["phase"]="began"})
		--saveMonsterData()
		renewData()
	end
end

function compete( num )
	local getScore, inCompete, scoring
	local turn, isUserFirst

	function getScore( isUserWin, isKO, t, hp )
		t = -2 *(t-5)*(t-5)+20
		if isUserWin == nil then return 10+t
		elseif isUserWin then
			if isKO then return 50+t+hp
			else return 30+t+hp
			end
		else
			if isKO then return -30+t
			else return -10+t
			end
		end
	end

	function inCompete( first, second, isUserFirst )
		local isUserWin, isKO = nil, false

		-- full hp
		first.hp, second.hp = first.max, second.max

		-- user first
		for turn = 1, 10, 1 do
			-- print( num.."번 째 몬스터와 1 번 째 전투 중 "..turn.."스테이지. 몬스터 : "..monData[num].hp .." 유저 : "..user.hp)

			second.hp = second.hp - math.floor( first.atk * 0.2 )
			-- print("몬스터에게 "..math.floor( user.atk * 0.2).."만큼의 데이지를 입혔습니다. 남은 몬스터의 체력 "..monData[num].hp)

			first.hp = first.hp - math.floor( second.atk * 0.2 )
			-- print("몬스터가 "..math.floor( monData[num].atk * 0.2).."만큼의 데이지를 입혔습니다. 남은 체력 "..user.hp)

			if second.hp <= 0 or first.hp <= 0 then
				isKO = true

				if isUserFirst and second.hp <= 0 then
					isUserWin = true
				else
					isUserWin = false
				end
				return getScore( isUserWin, isKO, turn, user.hp )
			end
		end

		if first.hp > second.hp then
			if isUserFirst then
				isUserWin = true
			else
				isUserWin = false
			end
		elseif first.hp < second.hp then
			if isUserFirst then
				isUserWin = false
			else
				isUserWin = true
			end
		end

		return getScore( isUserWin, isKO, turn, user.hp )
	end

	monData[num].score = 0
	monData[num].score =  math.floor( ( inCompete( user, monData[num], true ) + inCompete( user, monData[num], false ) ) / 2 )
end

function saveMonsterData()
end

function saveUserData()
	local encoded = json.encode( user )

	local file, errorString = io.open( userPath, "w" )

	if not file then
		print("not file")
	else
		file:write()
		file:write( encoded )

		print("save succeed")

		io.close(file)
	end

	file = nil
end

function loadUserData(e)
	if e.phase == "began" then
		local file, errorString = io.open( userPath, "r" )

		if not file then
			print( "File error : ".. errorString )
		else
			local decoded, pos, msg = json.decodeFile( userPath )

			if not decoded then
				print( "decode filaed at ".. tostring(pos)..": "..tostring(msg))
			else
				user = decoded
				print(decoded)
			end

			io.close(file)
		end

		file = nil

		renewData()
	end
end

function createUI()
	competeB = widget.newButton(
	{
		label = "경쟁하기",
		onEvent = onCompete,
		fontSize = 15,
		font = NanumGothicCoding,
		emboss = true,
		shape = "roundedRect",
		cornerRadius = 4,
		top = _H*0.85,
		left = _W*0.6,
		width = 100,
		height = 30,
	    labelColor = { default={ CC("666666") }, over={ CC("666666")} },
	    fillColor = { default={ CC("ffffff") }, over={ CC("888888")} },
	})

	importB = widget.newButton(
	{
	    label = "불러오기",
	    onEvent = loadUserData,
	    fontSize = 15,
	    font = NanumGothicCoding,
	    emboss = true,
	    shape = "roundedRect",
	    cornerRadius = 4,
	    top = _H*0.85,
	    left = _W*0.6 + 110,
	    width = 100,
	    height = 30,
	    labelColor = { default={ CC("666666") }, over={ CC("666666")} },
	    fillColor = { default={ CC("ffffff") }, over={ CC("888888")} },
	})

	showGeneration = display.newText( "hioa", _W*0.1, 20, NanumGothicCoding )
	showUserStatus = display.newText( "hioa22", _W*0.12, _H*0.3, NanumGothicCoding )
end

function start()
	createUI()
	loadUserData({["phase"]="began"})
end

start()