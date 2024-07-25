local colony = peripheral.wrap("back")
function termclear()
    term.clear()
    term.setCursorPos(1,1)
end

while true do
    termclear()
    print(colony.getColonyName().." Stats")
    print("---------------------------")
    print("Building Sites: ".. colony.amountOfConstructionSites())
    print("Citizens: ".. colony.amountOfCitizens())
    local underAttack = "No"
    if colony.isUnderAttack() then
        underAttack = "Yes"
    end
    print("Is under attack? ".. underAttack)
    print("Overall happiness: ".. math.floor(colony.getHappiness()))
    print("Amount of graves: ".. colony.amountOfGraves())
    os.sleep(60)
end
