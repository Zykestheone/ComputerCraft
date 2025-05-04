local Colony = peripheral.find("colonyIntegrator")
if not Colony then
    return("No Colony Found")
end

local Citizens = Colony.getCitizens()
for i,citizen in ipairs(Citizens) do
    local location = citizen.location
    local bedPos = citizen.bedPos

    if location.x == bedPos.x then
        if location.y == bedPos.y then
            if location.z == bedPos.y then
                print("Citizen in bed")
            end
        end
    end
end
