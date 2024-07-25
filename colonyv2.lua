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
        print("No requests found.")
    end
end

function updateDisplay()
    termclear()
    print(colony.getColonyName() .. " Stats")
    print("--------------------------")
    print("")
    print("Construction Sites: " .. colony.amountOfConstructionSites())
    print("Citizens: " .. colony.amountOfCitizens() .. "/" .. colony.maxOfCitizens())
    print("Overall happiness: " .. math.floor(colony.getHappiness()))
    print("Amount of graves: " .. colony.amountOfGraves())
    print("")

    -- Call the requests function to print request information
    requests()
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

    if event == "timer" and eventData[2] == timerId then
        -- Timer event occurred, update the display
        updateDisplay()
    elseif event == "key" then
        -- Key event occurred, update the display
        updateDisplay()
        
        -- Reset the timer after key press
        timerId = os.startTimer(60)
    end
end
