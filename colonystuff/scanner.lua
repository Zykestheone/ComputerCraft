local geo = peripheral.find("geoScanner")
if not geo then
    error("no geo found")
end

print("Enter Location")
local input = read()

local xStr, yStr, zStr = input:match("^(%-?%d+)%s+(%->%d+)%s+)%-?%d+)$")

if not xStr or not yStr or not zStr then
    error("Invalid Input! Format must be : x y z")
end

local x = tonumber(xStr)
local y = tonumber(yStr)
local z = tonumber(zStr)

local scannerPos = vector.new(x, y, z)
print("Scanner position set to:", scannerPos.x, scannerPos.y, scannerPos.z)

local wanted = {"ore"}

local function isWanted(name)
    for _, word in ipairs(wanted) do
        if string.find(name, word) then
            return true
        end
    end
    return false
end

local function scan()
    local results = geo.scan(16)
    if results == "nil" then
        error(results)
    end

    for i, result in ipairs(results) do
        if isWanted(result.name) then
            local relative = vector.new(result.x, result.y, result.z)
            local absolute = scannerPos + relative
            print(string.format("Found %s at X=%d, Y=%d, Z=%d", result.name, absolute.x, absolute.y, absolute.z))
        end
    end
end

scan()
