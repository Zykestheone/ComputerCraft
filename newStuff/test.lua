local colony = peripheral.find("colonyIntegrator")

local citizens = colony.getCitizens()

for i, citizen in ipairs(citizens) do
    if citizen then
        local food = citizen.saturation
        local location = citizen.location
        if food <= 8 then
           print(citizen.name,":",math.floor(food),":", location.x, location.y, location.z)
        end
    end
end