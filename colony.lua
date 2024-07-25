local colony = peripheral.wrap("back")
while true do
    term.clear()
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
