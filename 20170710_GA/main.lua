local setMon = require "setMonster"

local compare

-- stage count
local count = 0

local maxSum = 50

-- default user set
local user = 
{
	hp = 25,
	atk = 25,
	max = 25,
	weight = 50
}

local monData = {}


function onStart( e )
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

	for i = 1, 2, 1 do
		flag = nil

		user.hp = user.max
		monData[num].hp = monData[num].max

		-- user first
		for turn = 1, 10, 1 do
			-- print( num.."번 째 몬스터와 "..i.."번 째 전투 중 "..turn.."스테이지. 몬스터 : "..monData[num].hp .." 유저 : "..user.hp)
			monData[num].hp = monData[num].hp - math.floor( user.atk * 0.2 )
			-- print("몬스터에게 "..math.floor( user.atk * 0.2).."만큼의 데이지를 입혔습니다. 남은 몬스터의 체력 "..monData[num].hp)

			user.hp = user.hp - math.floor( monData[num].atk * 0.2 )
			-- print("몬스터가 "..math.floor( monData[num].atk * 0.2).."만큼의 데이지를 입혔습니다. 남은 체력 "..user.hp)

			if monData[num].hp <= 0 then
				monData[num].score = getScore(1)
				flag = true
				break
			elseif user.hp <= 0 then
				monData[num].score = getScore(2)
				flag = true
				break
			end
		end

		if not flag then
			if monData[num].hp < user.hp then
				monData[num].score = getScore(3)
			elseif monData[num].hp > user.hp then
				monData[num].score = getScore(4)
			end
		end

	end
	print(num.."번째 몬스터의 점수 : "..monData[num].score)
end

function compare(a, b)
	return a.score > b.score
end

onStart()