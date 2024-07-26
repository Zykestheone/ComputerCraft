local colony = peripheral.wrap("back")

function termclear()
    term.clear()
    term.setCursorPos(1, 1)
end

function requests()
    -- Fetch the list of current requests
    local requests = colony.getRequests()

    -- Check if requests were retrieved successfully
    if requests and #requests > 0 then
        -- Iterate through each request in the table
        for i, request in ipairs(requests) do
            -- Extract the name of the item requested and the target (person who needs it)
            local itemName = request.name
            local requesterName = request.target

            -- Print the short answer
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
            if citizenSaturation <= 6 then
                print(citizenName .. "needs food")
            elseif citizenSaturation <= 6 and citizenBetterFood == true then
                print(citizenName .. "needs better food")
            end
        end
    else
        return
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

    -- Call the requests function to print request information
    requests()
    citizens()
end

-- Initial display update
updateDisplay()

-- Main loop
while true do
    -- Start a timer for 60 seconds
    local timerId = os.startTimer(60)

    -- Wait for events and handle them
    local eventData = {os.pullEvent()}
    local event = eventData[1]

    if event == "timer" then
        -- Timer event occurred, update the display
        updateDisplay()
    elseif event == "key" then
        -- Key event occurred, update the display
        updateDisplay()
        
        -- Reset the timer after key press
        timerId = os.startTimer(60)
    end
end
