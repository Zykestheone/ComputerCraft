local colony = peripheral.wrap("back")
local function stats ()
    if colony then
        local citizens = colony.getCitizens()
        local awakeCount = 0
        print("Citizens: ".. colony.amountOfCitizens().."/"..colony.maxOfCitizens())
        print("Building Sites: ".. colony.amountOfConstructionSites())
        local underAttack = colony.isUnderAttack() and "Yes" or "No"
        print("Is under attack? ".. underAttack)
        print("Overall Happiness: ".. math.floor(colony.getHappiness()))
        print("Amount of Graves: ".. colony.amountOfGraves())
        for i, citizen in ipairs(citizens) do
            local work = citizen.work
            local jobType = work and work.type or ""
            if jobType ~= "guardtower" and jobType ~= "barrackstower" then
                if not citizen.isAsleep then
                    awakeCount = awakeCount + 1
                end
            end
        end
        print("Awake Citizens: ".. awakeCount)
    end
end

while true do
    term.clear()
    term.setCursorPos(1,1)
    stats()
    os.sleep(20)
end
