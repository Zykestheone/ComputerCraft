local colony = peripheral.wrap("back")
local function stats ()
    if colony then
        print("Citizens :".. colony.amountOfCitizens().."/"..colony.maxOfCitizens())
        print("Building Sites :".. colony.amountOfConstructionSites())
        local underAttack = "No"
        if colony.isUnderAttack() then
            underAttack = "Yes"
        end
        print("Is under attack? ".. underAttack)
        print("Overall Happiness: ".. math.floor(colony.getHappiness()))
        print("Amount of Graves: "..colony.amountOfGraves())
    end
end
while true do
    stats()
    os.startTimer(30)
    term.setCursorPos(0,10)
end