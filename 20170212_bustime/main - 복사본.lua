viewBusButton = widget.newButton(
{
    left = 100,
    top = 1000,
    id = "busButton",
    defaultFile = "button2_off.png",
    overFile = "button2_on.png",
    onEvent = turnBusView
})


local displaying

displaying = function( )
    local date = os.date( "*t" )

    local goTime, turnStarting, turnBus, createImage, checkWeek, chooseData


    local bg, nowTime, listView
    local list, listT, shape, text = {}, {}, {}, {}
    local busNum, starting, columnData

    goTime = function( e )
        local d, h, m = day, date.hour, date.min
        date = os.date( "*t" )
        nowTime.text = "지금 시간 : "..date.hour.."시 "..date.min.."분 "..date.sec.."초"

        if h == 23 and date.hour == 0 then
            checkWeek()
        end
    end

    turnStarting = function( e )
        local t = text[2].text
        text[2].text = e.target.text

        if text[2].text == "배곧" then
            starting = "B"
        elseif text[2].text == "안산역" then
            starting = "A"
        elseif text[2].text == "오이도역" then
            starting = "O"
        end

        if t ~= e.target.text then chooseData() end

        t = nil
    end 

    turnBus = function( e )
        local t = text[3].text
        text[3].text = e.target.text

        if text[3].text == "버스" then
            busNum = 1
        elseif text[3].text == "99-3" then
            busNum = 3
        elseif text[2].text == "99-2" then
            busNum = 2
        end

        if t ~= e.target.text then chooseData() end

        t = nil
    end

    createImage = function( )
        bg = display.newImage("bg.png", _W/2, _H/2)

        nowTime = display.newText( "지금 시간 : "..date.hour.."시 "..date.min.."분 "..date.sec.."초", _W/2, 100+5, native.newFont( "BMYEONSUNG.ttf" ) )
        nowTime.size = 70
        nowTime:setFillColor( )
        timer.performWithDelay( 500, goTime, -1 )

        shape[1] = display.newLine( 0, 200, 720, 200 )
        shape[1].strokeWidth = 6
        shape[1]:setStrokeColor( )

        text[1] = display.newText( "에서 출발하는", _W/2, 300 , native.newFont( "BMYEONSUNG.ttf" ) )
        text[1].size = 50
        text[1]:setFillColor( )

        shape[2] = display.newImage( "box_s.png", 150, 295 )
        shape[3] = display.newImage( "box_s.png", 580, 295 )

        text[2] = display.newText( "배곧", 150, 300, native.newFont( "BMYEONSUNG.ttf" ) )
        text[2].size = 50
        text[2]:setFillColor( )

        text[3] = display.newText( "버스", 580, 300, native.newFont( "BMYEONSUNG.ttf" ) )
        text[3].size = 50
        text[3]:setFillColor( )

        text[4] = display.newText( "배곧", 80, 350, native.newFont( "BMYEONSUNG.ttf") )
        text[4].size = 25
        text[4]:setFillColor( )
        text[4]:addEventListener( "tap", turnStarting )

        text[5] = display.newText( "오이도역", 145, 350, native.newFont( "BMYEONSUNG.ttf") )
        text[5].size = 25
        text[5]:setFillColor( )
        text[5]:addEventListener( "tap", turnStarting )

        text[6] = display.newText( "안산역", 220, 350, native.newFont( "BMYEONSUNG.ttf") )
        text[6].size = 25
        text[6]:setFillColor( )
        text[6]:addEventListener( "tap", turnStarting )

        text[7] = display.newText( "버스", 520, 350, native.newFont( "BMYEONSUNG.ttf") )
        text[7].size = 25
        text[7]:setFillColor( )
        text[7]:addEventListener( "tap", turnBus )

        text[8] = display.newText( "99-2", 575, 350, native.newFont( "BMYEONSUNG.ttf") )
        text[8].size = 25
        text[8]:setFillColor( )
        text[8]:addEventListener( "tap", turnBus )

        text[9] = display.newText( "99-3", 640, 350, native.newFont( "BMYEONSUNG.ttf") )
        text[9].size = 25
        text[9]:setFillColor( )
        text[9]:addEventListener( "tap", turnBus )

        columnData =
        {
            {
                align = "left",
                width = display.contentWidth,
                startIndex = 1,
                labels = listT
            },
            {
                align = "left",
                width = 1,
                startIndex = 1,
                labels = { 1, 2, 3, 4, 5 }
            },
        }

        listView = widget.newPickerWheel({
            top = 400,
    --      width = _W,
    --      fontSize = 30,
            columns = columnData,
        })

        text[10] = display.newText( "1.'지금 시간'은 실제 버스 시간 차이가 날 수 있습니다.\n2. 교통 상황에 따라 버스 운행 시간이 달라질 수 있습니다.\n3. 이 버스 시간표는 2017년 2월 12일까지의 정보를 반영한 시간표입니다.\n4. 개발자의 편의를 위해 만들어진 앱입니다.\n※ 시간표가 변경된 경우, derbana1027@gmail.com으로 연락주세요.", _W*0.5, 1190, native.newFont("BMYEONSUNG.ttf") )
        text[10].size = 25

        text[10]:setFillColor( )
    end

    checkWeek = function( )
        if date.wday == 1 or date.wday == 6 then
            day = "E"
        else
            day = "w"
        end
    end

    chooseData = function ( )
        for key, value in pairs(data) do
            -- check week
            if value[1] == day or value[1] == "A" then
                --starting
                if value[2] == starting then 
                    --busNum
                    if busNum == 1 or ( ( busNum == 2 and value[3] == 2 ) or ( busNum == 3 and value[3] == 3 ) ) then
                        table.insert( list, #list + 1 , { value[3], value[4], value[5] } )
                        table.insert( listT, #list + 1, value[3].."시 "..value[4].."분\t\t"..value[5].."번" )
                    end
                end
            end
        end

        for key, value in pairs(list) do
            if ( date.hour == value[1] and date.min < value[2] ) or ( date.hour < value[1] ) then
                break
            else
                count = count + 1
            end
        end
    end

    checkWeek()
    chooseData()
    createImage()
end

displaying()