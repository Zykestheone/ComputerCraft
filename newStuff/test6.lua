local Colony = peripheral.find("colonyIntegrator")
if not Colony then
    return("No Colony Found")
end

local Citizens = Colony.getCitizens()
for i,citizen in ipairs(Citizens) do
    AwakeCount = 0
    local location = citizen.location
    local bedPos = citizen.bedPos
    local work = citizen.work
    local jobType = work and work.type or ""
    if jobType ~= "guardtower" and jobType ~= "barrackstower" then
        if location.x == bedPos.x then
            if location.y == bedPos.y then
                if location.z == bedPos.z then
                    AwakeCount = AwakeCount + 1
                end
            end
        end
    end

    print(AwakeCount)
end