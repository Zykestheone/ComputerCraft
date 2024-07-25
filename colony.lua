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

while true do
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

    os.sleep(60)
end
