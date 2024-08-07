-- Pocket Computer with colony intergrator installed, Uses back on pocket
local colony = peripheral.wrap("back")

-- Clears Terminal and sets Cursor to start
local function TermClear()
    term.clear()
    term.setCursorPos(1, 1)
end

-- Gets Requests and prints them out 1 by 1 for each Citizen
local function Requests()
    local requests = colony.getRequests()

    if requests and #requests > 0 then
        for i, request in ipairs(requests) do
            local itemName = request.name
            local requesterName = request.target

            print("Request: " .. itemName .. " requested by " .. requesterName)
            print("")
        end
    else
        return
    end
end

-- Main Function, Prints Generic Info about Colony
local function UpdateDisplay()
    TermClear()
    print(colony.getColonyName() .. " Stats")
    term.write("--------------------------------------------------------------------------------")
    print("")
    print("Construction Sites: " .. colony.amountOfConstructionSites())
    print("Citizens: " .. colony.amountOfCitizens() .. "/" .. colony.maxOfCitizens())
    print("Overall happiness: " .. math.floor(colony.getHappiness()))
    print("Amount of graves: " .. colony.amountOfGraves())
    print("")
-- Runs the Request Function
    Requests()
end

-- Initiates Display
UpdateDisplay()

-- Loops every 20 seconds or if a key is pressed.
while true do
        local timerId = os.startTimer(20)
        local eventData = {os.pullEvent()}
        local event = eventData[1]
    
        if event == "timer" then
            UpdateDisplay()
        elseif event == "key" then
            UpdateDisplay()
            os.cancelTimer()
            timerId = os.startTimer(20)
        end 
end

