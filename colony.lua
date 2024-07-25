local colony = peripheral.wrap("back")
function termclear()
    term.clear()
    term.setCursorPos(1,1)
end

while true do
    termclear()
    print(colony.getColonyName().." Stats")
    print("--------------------------")
    print("")
    print("Building Sites: ".. colony.amountOfConstructionSites())
    print("Citizens: ".. colony.amountOfCitizens().."/"..colony.maxOfCitizens())
    print("Overall happiness: ".. math.floor(colony.getHappiness()))
    print("Amount of graves: ".. colony.amountOfGraves())
    os.sleep(60)
end
