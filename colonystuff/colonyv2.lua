local colony = peripheral.wrap("back")

function termclear()
    term.clear()
    term.setCursorPos(1, 1)
end

function requests()
    local requests = colony.getRequests()

    if requests and #requests > 0 then
        for i, request in ipairs(requests) do
            local itemName = request.name
            local requesterName = request.target

            print("Request: " .. itemName .. " requested by " .. requesterName)
        end
    else
        return
    end
end

function citizens()
    local citizens = colony.getCitizens()

    if citizens and #citizens > 0 then
        for i, citizen in ipairs(citizens) do
            local citizenName = citizen.name
            local citizenSaturation = citizen.saturation
            local citizenBetterFood = citizen.betterFood
            if citizenSaturation <= 6 and citizenBetterFood == true then
                print(citizenName .. " needs better food")
            elseif citizenSaturation <= 6 then
                    print(citizenName .. " needs food")
            end
        end
    else
        return
    end
end

function research()
    local research = colony.getResearch()

    if research and #research > 0 then
        for i, x in ipairs(research) do
        
        end
    end
end

function updateDisplay()
    termclear()
    print(colony.getColonyName() .. " Stats")
    term.write("--------------------------------------------------------------------------------")
    print("")
    print("Construction Sites: " .. colony.amountOfConstructionSites())
    print("Citizens: " .. colony.amountOfCitizens() .. "/" .. colony.maxOfCitizens())
    print("Overall happiness: " .. math.floor(colony.getHappiness()))
    print("Amount of graves: " .. colony.amountOfGraves())
    print("")
    requests()
    citizens()
end

updateDisplay()

while true do
        local timerId = os.startTimer(20)
        local eventData = {os.pullEvent()}
        local event = eventData[1]
    
        if event == "timer" then
            updateDisplay()
        elseif event == "key" then
            updateDisplay()
            timerId = os.startTimer(20)
        end 
end

