-- CLIENT DIG --

local SLOT_COUNT = 16

local CLIENT_PORT = 0
local SERVER_PORT = 420

local modem = peripheral.wrap("right")
modem.open(CLIENT_PORT)

local function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

local function parseParams(data)
    local coords = {}
    local params = split(data, " ")

    coords[1] = vector.new(params[1], params[2], params[3])
    coords[2] = vector.new(params[4], params[5], params[6])
    coords[3] = vector.new(params[7], params[8], params[9])
    coords[4] = tonumber(params[10]) -- Fuel needed

    return coords
end

local function checkFuel(fuelNeeded)
    if turtle.getFuelLevel() < fuelNeeded then
        print("Refueling...")

        for slot = 1, SLOT_COUNT do
            turtle.select(slot)
            local itemDetail = turtle.getItemDetail(slot)
            if itemDetail and turtle.refuel() then
                if turtle.getFuelLevel() >= fuelNeeded then
                    return true
                end
            end
        end

        print("Not enough fuel. Fuel level:", turtle.getFuelLevel(), "Needed:", fuelNeeded)
        return false
    else
        return true
    end
end

local function gatherFuel(fuelNeeded)
    local fuelGathered = 0
    local stackSize = 64 -- Adjust if using a different fuel type with a different stack size

    while fuelGathered < fuelNeeded do
        local amountToSuck = math.min(stackSize, fuelNeeded - fuelGathered)
        local success = turtle.suckDown(amountToSuck)
        if not success then
            print("Failed to gather sufficient fuel.")
            return false
        end
        fuelGathered = fuelGathered + amountToSuck
        os.sleep(1) -- Sleep for a bit to avoid potential issues with rapid successive calls
    end
    return true
end

local function getOrientation()
    local loc1 = vector.new(gps.locate(2, false))
    if not turtle.forward() then
        for j = 1, 6 do
            if not turtle.forward() then
                turtle.dig()
            else 
                break
            end
        end
    end
    local loc2 = vector.new(gps.locate(2, false))
    local heading = loc2 - loc1
    turtle.back()  -- Correct the movement
    turtle.down()
    turtle.down()
    return ((heading.x + math.abs(heading.x) * 2) + (heading.z + math.abs(heading.z) * 3))
end

local function turnToFaceHeading(heading, destinationHeading)
    if heading == nil or destinationHeading == nil then
        print("Error: heading or destinationHeading is nil in turnToFaceHeading")
        return
    end

    if heading > destinationHeading then
        for t = 1, math.abs(destinationHeading - heading) do 
            turtle.turnLeft()
        end
    elseif heading < destinationHeading then
        for t = 1, math.abs(destinationHeading - heading) do 
            turtle.turnRight()
        end
    end
end

local function setHeadingZ(zDiff, heading)
    if heading == nil then
        print("Error: heading is nil in setHeadingZ")
        return nil
    end

    local destinationHeading = heading
    if zDiff < 0 then
        destinationHeading = 2
    elseif zDiff > 0 then
        destinationHeading = 4
    end
    turnToFaceHeading(heading, destinationHeading)

    return destinationHeading
end

local function setHeadingX(xDiff, heading)
    if heading == nil then
        print("Error: heading is nil in setHeadingX")
        return nil
    end

    local destinationHeading = heading
    if xDiff < 0 then
        destinationHeading = 1
    elseif xDiff > 0 then
        destinationHeading = 3
    end

    turnToFaceHeading(heading, destinationHeading)
    return destinationHeading
end

local function digAndMove(n, fuelNeeded)
    for x = 1, n do
        while turtle.detect() do
            turtle.dig()
        end
        turtle.forward()
        if not checkFuel(fuelNeeded) then
            print("Out of fuel, stopping operation.")
            return false
        end
    end
    return true
end

local function digAndMoveDown(n, fuelNeeded)
    for y = 1, n do
        print(y)
        while turtle.detectDown() do
            turtle.digDown()
        end
        turtle.down()
        if not checkFuel(fuelNeeded) then
            print("Out of fuel, stopping operation.")
            return false
        end
    end
    return true
end

local function digAndMoveUp(n, fuelNeeded)
    for y = 1, n do
        while turtle.detectUp() do
            turtle.digUp()
        end
        turtle.up()
        if not checkFuel(fuelNeeded) then
            print("Out of fuel, stopping operation.")
            return false
        end
    end
    return true
end

local function moveTo(coords, heading, fuelNeeded)
    local currX, currY, currZ = gps.locate()
    local xDiff, yDiff, zDiff = coords.x - currX, coords.y - currY, coords.z - currZ
    print(string.format("Distances from start: %d %d %d", xDiff, yDiff, zDiff))

    -- Move to X start
    heading = setHeadingX(xDiff, heading)
    if not digAndMove(math.abs(xDiff), fuelNeeded) then return nil end

    -- Move to Z start
    heading = setHeadingZ(zDiff, heading)
    if not digAndMove(math.abs(zDiff), fuelNeeded) then return nil end

    -- Move to Y start
    if yDiff < 0 then    
        if not digAndMoveDown(math.abs(yDiff), fuelNeeded) then return nil end
    elseif yDiff > 0 then
        if not digAndMoveUp(math.abs(yDiff), fuelNeeded) then return nil end
    end

    return heading
end

-- Main script starts here
modem.transmit(SERVER_PORT, CLIENT_PORT, "CLIENT_DEPLOYED")
Event, Side, SenderChannel, ReplyChannel, Msg, Distance = os.pullEvent("modem_message")
local data = parseParams(Msg)

-- Pick up coal and refuel
local fuelNeeded = data[4]  -- Use the provided fuel needed value
print(string.format("Extracting %d fuel...", fuelNeeded))
if not gatherFuel(fuelNeeded) then
    print("Failed to gather sufficient fuel.")
    return
end

if not checkFuel(fuelNeeded) then
    print("Failed to refuel.")
    return
end

-- Grab Ender Chest
turtle.turnRight()
turtle.suck(1)
turtle.turnLeft()

local startCoords = data[1]
local heading = getOrientation()
if heading == nil then
    print("Failed to get orientation.")
    return
end

local finalHeading = moveTo(startCoords, heading, fuelNeeded)
if finalHeading == nil then
    print("Failed to move to start coordinates.")
    return
end

local NORTH_HEADING = 2
-- Turn to face North
turnToFaceHeading(finalHeading, NORTH_HEADING)
finalHeading = NORTH_HEADING
-- Now in Starting Position--

--------------------------------START MINING CODE-----------------------------------------

DROPPED_ITEMS = {
    "minecraft:stone",
    "minecraft:dirt",
    "minecraft:basalt",
    "minecraft:granite",
    "minecraft:cobblestone",
    "minecraft:sand",
    "minecraft:gravel",
    "minecraft:redstone",
    "minecraft:flint",
    "railcraft:ore_metal",
    "extrautils2:ingredients",
    "minecraft:dye",
    "thaumcraft:nugget",
    "thaumcraft:crystal_essence",
    "thermalfoundation:material",
    "projectred-core:resource_item",
    "thaumcraft:ore_cinnabar",
    "deepresonance:resonating_ore",
    "forestry:apatite",
    "biomesoplenty:loamy_dirt",
    "chisel:marble",
    "chisel:limestone",
}

local function dropItems()
    print("Purging Inventory...")
    for slot = 1, SLOT_COUNT do
        local item = turtle.getItemDetail(slot)
        if item then
            for filterIndex = 1, #DROPPED_ITEMS do
                if item.name == DROPPED_ITEMS[filterIndex] then
                    print("Dropping - " .. item.name)
                    turtle.select(slot)
                    turtle.dropDown()
                end
            end
        end
    end
end

local function getEnderIndex()
    for slot = 1, SLOT_COUNT do
        local item = turtle.getItemDetail(slot)
        if item and item.name == "enderstorage:ender_chest" then
            return slot
        end
    end
    return nil
end

local function manageInventory()
    dropItems()
    local index = getEnderIndex()
    if index then
        turtle.select(index)
        turtle.digUp()      
        turtle.placeUp()  
    end
    -- Chest is now deployed
    for slot = 1, SLOT_COUNT do
        local item = turtle.getItemDetail(slot)
        if item and item.name ~= "minecraft:coal_block" and item.name ~= "minecraft:coal" and item.name ~= "minecraft:charcoal" then
            turtle.select(slot)
            turtle.dropUp()
        end
    end
    -- Items are now stored
    turtle.digUp()
end

local function detectAndDig()
    while turtle.detect() do
        turtle.dig()
    end
end

local function forward()
    detectAndDig()
    turtle.forward()
end

local function leftTurn()
    turtle.turnLeft()
    detectAndDig()
    turtle.forward()
    turtle.turnLeft()
end

local function rightTurn()
    turtle.turnRight()
    detectAndDig()
    turtle.forward()
    turtle.turnRight()
end

local function dropTier(heading)
    turtle.turnRight()
    turtle.turnRight()
    turtle.digDown()
    turtle.down()
    return FlipDirection(heading)
end

function FlipDirection(heading)
    return ((heading + 1) % 4) + 1
end

local function turnAround(tier, heading)
    if tier % 2 == 1 then
        if heading == 2 or heading == 3 then
            rightTurn()
        elseif heading == 1 or heading == 4 then
            leftTurn()
        end
    else
        if heading == 2 or heading == 3 then
            leftTurn()
        elseif heading == 1 or heading == 4 then
            rightTurn()
        end
    end
    
    return FlipDirection(heading)
end

local function startQuarry(width, height, depth, heading, fuelNeeded)
    for tier = 1, height do
        for col = 1, width do
            for row = 1, depth - 1 do
                if not checkFuel(fuelNeeded) then
                    print("Turtle is out of fuel, Powering Down...")
                    return
                end
                forward()
            end
            if col ~= width then
                heading = turnAround(tier, heading)
            end
            manageInventory()
        end
        if tier ~= height then
            heading = dropTier(heading)
        end
    end
    return heading
end

local quarry = data[2]
local finishedHeading = startQuarry(quarry.x, quarry.y, quarry.z, finalHeading, fuelNeeded)

--------------------------------START RETURN TRIP CODE------------------------------------

local function returnTo(coords, heading, fuelNeeded)
    local currX, currY, currZ = gps.locate()
    local xDiff, yDiff, zDiff = coords.x - currX, coords.y - currY, coords.z - currZ
    print(string.format("Distances from end: %d %d %d", xDiff, yDiff, zDiff))
    
    -- Move to Y start
    if yDiff < 0 then    
        digAndMoveDown(math.abs(yDiff), fuelNeeded)
    elseif yDiff > 0 then
        digAndMoveUp(math.abs(yDiff), fuelNeeded)
    end

    -- Move to X start
    heading = setHeadingX(xDiff, heading)
    digAndMove(math.abs(xDiff), fuelNeeded)

    -- Move to Z start
    heading = setHeadingZ(zDiff, heading)
    digAndMove(math.abs(zDiff), fuelNeeded)
    
    return heading
end

local endCoords = data[3]
returnTo(endCoords, finishedHeading, fuelNeeded)

local timeoutWait = 90
for i = 1, timeoutWait do
    os.sleep(1)
    print(string.format("Waiting for brothers %d/%d", i, timeoutWait))
end

modem.transmit(SERVER_PORT, CLIENT_PORT, "cum")
