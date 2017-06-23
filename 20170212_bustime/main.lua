display.setStatusBar( display.HiddenStatusBar )

local widget = require( "widget" )
 
local _W, _H = display.contentWidth, display.contentHeight

local CC = function (hex)
    local r = tonumber( hex:sub(1, 2), 16 ) / 255
    local g = tonumber( hex:sub(3, 4), 16 ) / 255
    local b = tonumber( hex:sub(5, 6), 16 ) / 255
    local a = 255/255
    if #hex == 8 then a = tonumber( hex:sub(7, 8), 16 ) / 255 end
    return r,g,b,a
end

local infoB2W =
{
    { 05, 40 }, { 06, 00 }, { 06, 30 }, { 06, 50 }, { 07, 10 }, { 07, 25 },
    { 07, 40 }, { 07, 55 }, { 08, 20 }, { 08, 45 }, { 09, 05 }, { 09, 20 },
    { 09, 40 }, { 10, 00 }, { 10, 20 }, { 10, 40 }, { 11, 00 }, { 11, 20 },
    { 11, 40 }, { 12, 00 }, { 12, 20 }, { 12, 45 }, { 13, 10 }, { 13, 35 },
    { 13, 55 }, { 14, 15 }, { 14, 35 }, { 15, 00 }, { 15, 20 }, { 15, 45 },
    { 16, 10 }, { 16, 35 }, { 17, 00 }, { 17, 25 }, { 17, 50 }, { 18, 15 },
    { 18, 35 }, { 18, 55 }, { 19, 15 }, { 19, 35 }, { 19, 55 }, { 20, 10 },
    { 20, 30 }, { 21, 00 }, { 21, 30 }, { 21, 50 }, { 22, 15 }, { 22, 45 },
}

local infoB2E =
{
    { 05, 50 }, { 06, 30 }, { 07, 10 }, { 07, 50 }, { 08, 20 }, { 08, 45 },
    { 09, 15 }, { 09, 40 }, { 10, 00 }, { 10, 20 }, { 10, 50 }, { 11, 20 },
    { 11, 50 }, { 12, 20 }, { 12, 50 }, { 13, 10 }, { 13, 40 }, { 14, 10 },
    { 14, 40 }, { 15, 00 }, { 15, 20 }, { 15, 50 }, { 16, 10 }, { 16, 40 },
    { 17, 10 }, { 17, 30 }, { 18, 00 }, { 18, 20 }, { 18, 55 }, { 19, 25 },
    { 20, 00 }, { 20, 30 }, { 21, 00 }, { 21, 30 }, { 22, 00 }, { 22, 30 },
}

local infoB3A =
{
    { 06, 10 }, { 06, 40 }, { 07, 15 }, { 07, 45 }, { 08, 15 }, { 08, 50 },
    { 09, 30 }, { 10, 10 }, { 10, 45 }, { 11, 25 }, { 12, 30 }, { 13, 05 },
    { 13, 40 }, { 14, 20 }, { 14, 55 }, { 15, 30 }, { 16, 00 }, { 16, 45 },
    { 17, 20 }, { 18, 25 }, { 19, 00 }, { 19, 40 }, { 20, 20 }, { 21, 00 },
    { 21, 40 }, { 22, 10 }, { 22, 40 },
}

local infoA2W =
{
    { 06, 20 }, { 06, 40 }, { 07, 10 }, { 07, 35 }, { 07, 55 }, { 08, 15 },
    { 08, 30 }, { 08, 55 }, { 09, 05 }, { 09, 30 }, { 09, 45 }, { 10, 00 },
    { 10, 20 }, { 10, 40 }, { 11, 00 }, { 11, 20 }, { 11, 40 }, { 12, 00 },
    { 12, 20 }, { 12, 40 }, { 13, 00 }, { 13, 25 }, { 13, 50 }, { 14, 15 },
    { 14, 35 }, { 14, 55 }, { 15, 15 }, { 15, 40 }, { 16, 00 }, { 16, 25 },
    { 16, 50 }, { 17, 15 }, { 17, 40 }, { 18, 05 }, { 18, 30 }, { 18, 55 },
    { 19, 15 }, { 19, 35 }, { 19, 55 }, { 20, 15 }, { 20, 35 }, { 20, 50 },
    { 21, 05 }, { 21, 35 }, { 22, 05 }, { 22, 30 }, { 22, 55 }, { 23, 20 }
}

local infoA2E =
{
    { 06, 25 }, { 07, 05 }, { 07, 45 }, { 08, 25 }, { 09, 00 }, { 09, 25 },
    { 09, 55 }, { 10, 20 }, { 10, 40 }, { 11, 00 }, { 11, 30 }, { 12, 00 },
    { 12, 30 }, { 13, 00 }, { 13, 30 }, { 13, 50 }, { 14, 20 }, { 14, 50 },
    { 15, 20 }, { 15, 40 }, { 16, 00 }, { 16, 30 }, { 16, 50 }, { 17, 20 },
    { 17, 50 }, { 18, 10 }, { 18, 40 }, { 19, 00 }, { 19, 35 }, { 20, 05 },
    { 20, 40 }, { 21, 10 }, { 21, 40 }, { 22, 10 }, { 22, 45 }, { 23, 20 },
}

local infoOA3 =
{
    { 06, 25 }, { 06, 55 }, { 07, 30 }, { 08, 00 }, { 08, 30 }, { 09, 05 },
    { 09, 45 }, { 10, 25 }, { 11, 00 }, { 11, 40 }, { 12, 45 }, { 13, 20 },
    { 13, 55 }, { 14, 35 }, { 15, 10 }, { 15, 45 }, { 16, 15 }, { 17, 00 },
    { 17, 35 }, { 18, 40 }, { 19, 15 }, { 19, 55 }, { 20, 35 }, { 21, 15 },
    { 21, 55 }, { 22, 25 }, { 22, 50 },
}

local displaying

displaying = function( )
    local date = os.date( "*t" )

    local day, starting, tran = "W", "B", "1"

    local runningTime, renewWeek, renewInfo, popUp, turnBusView, turnSubView

    local bg, nowTime, columnData, listView, viewBusButton, viewSubButton
    local shape, text, list = {}, {}, {}

    runningTime = function( e )
        local d, h, m = day, date.hour, date.min
        date = os.date( "*t" )
        nowTime.text = "지금 시간 : "..date.hour.."시 "..date.min.."분 "..date.sec.."초"

        if h == 23 and date.hour == 0 then
        end
    end

    renewWeek = function( )
        if date.wday == 0 or date.wday == 6 then
            day = "E"
        else
            day = "W"
        end
    end

    renewInfo = function( )
        local swap

        swap = function( i, j )
            local sample2 = {}
            sample2 = sample[i]
            sample[i] = sample[j]
            sample[j] = sample2
            sample2 = nil
        end

        local sample = {}
        print(day..starting..tran)

        local i = 1

        if tran == 1 and tran == 2 then
            if day == "W" then
                if starting == "B" then
                    for i = i, #infoB3A, 1 do
                        table.insert( sample, #infoB3A + 1, { infoB3A[1], infoB3A[2], 3 } )
                        print( sample[#infoB3A + 1][1]..sample[#info00B3A + 1][2] )
                    end
                elseif starting == "A" then
                    for i = i, #infoB3A, 1 do
                        table.insert( sample, #infoB3A + 1, { infoB3A[1], infoB3A[2], 3 } )
                        print( sample[#infoB3A + 1][1]..sample[#infoB3A + 1][2] )
                    end
                end
            elseif day == "E" then
                if starting == "B" then
                    for i = i, #infoB2E, 1 do
                        table.insert( sample, #infoB2E + 1, { infoB2E[1], infoB2E[2], 2 } )
                    end
                elseif starting == "A" then
                    for i = i, #infoA2E, 1 do
                        table.insert( sample, #sample + 1, { infoA2E[1], infoA2E[2], 2 } )
                        print( sample[#sample][1]..sample[#sample][2] )
                    end
                end
            end
        end
        if ( day == "W" and starting == "B" ) and ( tran == 1 or tran == 3 ) then
            for i =1, #infoB3A, 1 do
                table.insert( sample, #infoB3A + 1, { infoB3A[1], infoB3A[2], 3 } )
                print( sample[#infoB3A + 1][1]..sample[#infoB3A + 1][2] )
            end
        end

        if ( day == "W" and starting == "A" ) and ( tran == 1 or tran == 2 ) then
            

        end

        if ( day == "E" and starting == "A" ) and ( tran == 1 or tran == 2 ) then
            
        end

        if starting == "O" and ( tran == 1 or tran == 3 ) then
            for i = 1, #infoOA3, 1 do
                table.insert( sample, #sample + 1, { infoOA3[1], infoOA3[2], 3 } )
                print( sample[#sample][1]..sample[#sample][2] )
            end
        end

        local sample2 = {}
        for i = 1, #sample, 1 do
            for j = i, #sample, 1 do
                print(sample[i][1])
                print(sample[j][1])
                if sample[i][1] > sample[j][1] then
                    swap(i,j)
                elseif sample[i][1] == samplee[j][1] then
                    if sample[i][2] > sample[j][2] then
                        swap(i,j)
                    elseif sample[i][2] == sample[j][2] then
                        if sample[i][3] == 3 then
                            swap(i,j)                            
                        end
                    end
                end
            end
        end

        local t
        for i = 1, #sample, 1 do
            sample2[i] = sample[i][1]..":"..sample[i][2].."\t".."99-"..sample[i][3]
        end

        sample = nil
        swap = nil
        return sample2
    end

    popUp = function( )
        local turnText, applyOn
        local overView
        local text2 = {}

        turnText = function( e )
            if ( e.target.text == "배곧" or e.target.text == "안산역" ) or e.target.text == "오이도역" then 
                text[2].text = e.target.text
            elseif ( e.target.text == "버스" or e.target.text == "99-2" ) or e.target.text == "99-3" then
                text[3].text = e.target.text
            end
        end

        applyOn = function( e )
            if text[2].text == "배곧" then starting = "B"
            elseif text[2].text == "안산역" then starting = "A"
            elseif text[2].text == "오이도역" then starting = "O"
            end

            if text[3].text == "버스" then tran = 1
            elseif text[3].text == "99-2" then tran = 2
            elseif text[3].text == "99-3" then tran = 3
            end

            text2[3]:removeEventListener( "tap", turnText )
            text2[4]:removeEventListener( "tap", turnText )
            text2[5]:removeEventListener( "tap", turnText )
            text2[6]:removeEventListener( "tap", turnText )
            text2[7]:removeEventListener( "tap", turnText )
            text2[8]:removeEventListener( "tap", turnText )
            turnText = nil
            applyOn = nil

            shape[2].onEvent = popUp
            shape[3].onEvent = popUp

            for i = 1, 9, 1 do
                text2[i]:removeSelf()
                text2[i] = nil
            end

            overView:removeSelf()
            overView = nil
        end

        shape[2].onEvent = nil
        shape[3].onEvent = nil

        overView = display.newImage( "overView.png", 362, 578 )

        text2[1] = display.newText( "<출발지 선택>", 362, 430, native.newFont("BMYEONSUNG.ttf") )
        text2[1].size = 35
        text2[1]:setFillColor( )

        text2[2] = display.newText( "<교통수단 선택>", 362, 550, native.newFont("BMYEONSUNG.ttf") )
        text2[2].size = 35
        text2[2]:setFillColor( )

        text2[3] = display.newText( "배곧", 185, 485, native.newFont("BMYEONSUNG.ttf") )
        text2[3].size = 35
        text2[3]:setFillColor( )
        text2[3]:addEventListener( "tap", turnText )

        text2[4] = display.newText( "안산역", 350, 485, native.newFont("BMYEONSUNG.ttf") )
        text2[4].size = 35
        text2[4]:setFillColor( )
        text2[4]:addEventListener( "tap", turnText )

        text2[5] = display.newText( "오이도역", 525, 485, native.newFont("BMYEONSUNG.ttf") )
        text2[5].size = 35
        text2[5]:setFillColor( )
        text2[5]:addEventListener( "tap", turnText )

        text2[6] = display.newText( "버스", 185, 605, native.newFont("BMYEONSUNG.ttf") )
        text2[6].size = 35
        text2[6]:setFillColor( )
        text2[6]:addEventListener( "tap", turnText )

        text2[7] = display.newText( "99-2", 350, 605, native.newFont("BMYEONSUNG.ttf") )
        text2[7].size = 35
        text2[7]:setFillColor( )
        text2[7]:addEventListener( "tap", turnText )

        text2[8] = display.newText( "99-3", 525, 605, native.newFont("BMYEONSUNG.ttf") )
        text2[8].size = 35
        text2[8]:setFillColor( )
        text2[8]:addEventListener( "tap", turnText )

        text2[9] = widget.newButton(
        {
            left = 260,
            top = 665,
            id = "apply",
            defaultFile = "applyB_off.png",
            overFile = "applyB_on.png",
            onEvent = applyOn
        })
    end

    --renewWeek()
    list = renewInfo()

    bg = display.newImage( "bg.png", _W/2, _H/2 )

    nowTime = display.newText( "지금 시간 : "..date.hour.."시 "..date.min.."분 "..date.sec.."초", _W/2, 100+5, native.newFont( "BMYEONSUNG.ttf") )
    nowTime.size = 70
    nowTime:setFillColor( )
    timer.performWithDelay( 500, runningTime, -1 )

    shape[1] = display.newLine( 0, 200, 720, 200 )
    shape[1].strokeWidth = 6
    shape[1]:setStrokeColor( )

    text[1] = display.newText( "에서 출발하는", _W/2, 300, native.newFont( "BMYEONSUNG.ttf") )
    text[1].size = 50
    text[1]:setFillColor( )

    shape[2] = widget.newButton(
    {
        left = 72.5,
        top = 260,
        id = "busButton",
        defaultFile = "box_s.png",
        overFile = "box_soff.png",
        onEvent = popUp
    })

    shape[3] = widget.newButton(
    {
        left = 505,
        top = 260,
        id = "busButton",
        defaultFile = "box_s.png",
        overFile = "box_soff.png",
        onEvent = popUp
    })

    text[2] = display.newText( "배곧", 150, 300, native.newFont( "BMYEONSUNG.ttf") )
    text[2].size = 50
    text[2]:setFillColor( )

    text[3] = display.newText( "버스", 580, 300, native.newFont( "BMYEONSUNG.ttf" ) )
    text[3].size = 50
    text[3]:setFillColor( )

    text[4] = display.newText( "1.'지금 시간'은 실제 버스 시간 차이가 날 수 있습니다.\n2. 교통 상황에 따라 버스 운행 시간이 달라질 수 있습니다.\n3. 이 버스 시간표는 2017년 2월 12일까지의 정보를 반영한 시간표입니다.\n4. 개발자의 편의를 위해 만들어진 앱입니다.\n※ 시간표가 변경된 경우, derbana1027@gmail.com으로 연락주세요.", _W*0.5, 1190, native.newFont("BMYEONSUNG.ttf") )
    text[4].size = 25
    text[4]:setFillColor( )

    --[[
    columnData =
    {
        {
            align = "center",
            width = display.contentWidth,
            startIndex = 2,
            labels = list

        },
    }
     
    -- Create the widget
    listView = widget.newPickerWheel(
    {
        x = display.contentCenterX,
        top = 400,
        fontSize = 50,
        style = "resizable",
        rowHeight= 100,
        font = native.newFont( "BMYEONSUNG.ttf"),
        hideBackground = true,
        columns = columnData
    })
]]--

    viewBusButton = widget.newButton(
    {
        left = 35,
        top = 950,
        id = "busButton",
        defaultFile = "button2_off.png",
        overFile = "button2_on.png",
        onEvent = turnBusView
    })
    viewSubButton = widget.newButton(
    {
        left = 375,
        top = 950,
        id = "subButton",
        defaultFile = "button1_off.png",
        overFile = "button1_on.png",
        onEvent = turnSubView
    })



end

displaying()

-- Set up the picker wheel columns
