local Colony = peripheral.find("colonyIntegrator")
if not Colony then
    return("No Colony Found")
end

local Citizens = Colony.getCitizens()
for i,citizen in ipairs(Citizens) do
    local awakeCount = 0
    local location = citizen.location
    local bedPos = citizen.bedPos
    local work = citizen.work
    local jobType = work and work.type or ""
    if jobType ~= "guardtower" and jobType ~= "barrackstower" then
        if location.x == bedPos.x then
            if location.y == bedPos.y then
                if location.z == bedPos.z then
                    awakeCount = awakeCount + 1
                end
            end
        end
    end

    print(awakeCount)
end
