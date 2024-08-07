--CLIENT DIG--

local SLOT_COUNT = 16

local CLIENT_PORT = 0
local SERVER_PORT = 420

local modem = peripheral.wrap("right")
modem.open(CLIENT_PORT)

local function split (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
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

    return (coords)
end


local function checkFuel()
    turtle.select(1)
    
    if(turtle.getFuelLevel() < 50) then
        print("Attempting Refuel...")
        for slot = 1, SLOT_COUNT, 1 do
            turtle.select(slot)
            if(turtle.refuel()) then
                return true
            end
        end

        return false
    else
        return true
    end
end


local function getOrientation()
    local loc1 = vector.new(gps.locate(2, false))
    if not turtle.forward() then
        for j=1,6 do
            if not turtle.forward() then
                turtle.dig()
            else 
                break 
            end
        end
    end
    local loc2 = vector.new(gps.locate(2, false))
    local heading = loc2 - loc1
    turtle.down()
    turtle.down()
    return ((heading.x + math.abs(heading.x) * 2) + (heading.z + math.abs(heading.z) * 3))
    end


local function turnToFaceHeading(heading, destinationHeading)
    if(heading > destinationHeading) then
        for t = 1, math.abs(destinationHeading - heading), 1 do 
            turtle.turnLeft()
        end
    elseif(heading < destinationHeading) then
        for t = 1, math.abs(destinationHeading - heading), 1 do 
            turtle.turnRight()
        end
    end
end

local function setHeadingZ(zDiff, heading)
    local destinationHeading = heading
    if(zDiff < 0) then
        destinationHeading = 2
    elseif(zDiff > 0) then
        destinationHeading = 4
    end
    turnToFaceHeading(heading, destinationHeading)

    return destinationHeading
end

local function setHeadingX(xDiff, heading)
    local destinationHeading = heading
    if(xDiff < 0) then
        destinationHeading = 1
    elseif(xDiff > 0) then
        destinationHeading = 3
    end

    turnToFaceHeading(heading, destinationHeading)
    return destinationHeading
end

local function digAndMove(n)
    for x = 1, n, 1 do
        while(turtle.detect()) do
            turtle.dig()
        end
        turtle.forward()
        checkFuel()
    end
end

local function digAndMoveDown(n)
    for y = 1, n, 1 do
        print(y)
        while(turtle.detectDown()) do
            turtle.digDown()
        end
        turtle.down()
        checkFuel()
    end
end

local function digAndMoveUp(n)
    for y = 1, n, 1 do
        while(turtle.detectUp()) do
            turtle.digUp()
        end
        turtle.up()
        checkFuel()
    end
end


local function moveTo(coords, heading)
    local currX, currY, currZ = gps.locate()
    local xDiff, yDiff, zDiff = coords.x - currX, coords.y - currY, coords.z - currZ
    print(string.format("Distances from start: %d %d %d", xDiff, yDiff, zDiff))

    --    -x = 1
    --    -z = 2
    --    +x = 3
    --    +z = 4
    

    -- Move to X start
    heading = setHeadingX(xDiff, heading)
    digAndMove(math.abs(xDiff))

    -- Move to Z start
    heading = setHeadingZ(zDiff, heading)
    digAndMove(math.abs(zDiff))

    -- Move to Y start
    if(yDiff < 0) then    
        digAndMoveDown(math.abs(yDiff))
    elseif(yDiff > 0) then
        digAndMoveUp(math.abs(yDiff))
    end


    return heading
end


local function calculateFuel(travels, digSize, fuelType)
    local currX, currY, currZ = gps.locate()
    local xDiff, yDiff, zDiff = travels.x - currX, travels.y - currY, travels.z - currZ

    local volume = digSize.x + digSize.y + digSize.z
    local travelDistance = (math.abs(xDiff) + math.abs(yDiff) + math.abs(zDiff)) * 2
    
    local totalFuel = volume + travelDistance
    print(string.format( "total steps: %d", totalFuel))

    if(fuelType == "minecraft:coal") then
        totalFuel = totalFuel / 80
    elseif(fuelType == "minecraft:coal_block") then
        totalFuel = totalFuel / 800
		elseif(fuelType == "minecraft:charcoal") then
        totalFuel = totalFuel / 80
    else
        print("INVALID FUEL SOURCE")
        do return end
    end

    return math.floor(totalFuel) + 5
end



modem.transmit(SERVER_PORT, CLIENT_PORT, "CLIENT_DEPLOYED")
Event, Side, SenderChannel, ReplyChannel, Msg, Distance = os.pullEvent("modem_message")
local data = parseParams(Msg)

-- Pick up coal and refuel
local fuelNeeded = calculateFuel(data[1], data[2], "minecraft:coal")
turtle.suckDown(fuelNeeded)
checkFuel()

print(string.format( "Extracting %d fuel...", fuelNeeded))

-- Grab Ender Chest
turtle.turnRight(1)
turtle.suck(1)
turtle.turnLeft(1)

local startCoords = data[1]
local finalHeading = moveTo(startCoords, getOrientation())

local NORTH_HEADING = 2
--Turn to face North
turnToFaceHeading(finalHeading, NORTH_HEADING)
finalHeading = NORTH_HEADING
--Now in Starting Position--

--------------------------------START MINING CODE-----------------------------------------





------------------------------------------------------------------------------------------

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
    for slot = 1, SLOT_COUNT, 1 do
        local item = turtle.getItemDetail(slot)
        if(item ~= nil) then
            for filterIndex = 1, #DROPPED_ITEMS, 1 do
                if(item["name"] == DROPPED_ITEMS[filterIndex]) then
                    print("Dropping - " .. item["name"])
                    turtle.select(slot)
                    turtle.dropDown()
                end
            end
        end
    end
end


local function getEnderIndex()
    for slot = 1, SLOT_COUNT, 1 do
        local item = turtle.getItemDetail(slot)
        if(item ~= nil) then
            if(item["name"] == "enderstorage:ender_chest") then
                return slot
            end
        end
    end
    return nil
end

local function manageInventory()
    dropItems()
    local index = getEnderIndex()
    if(index ~= nil) then
        turtle.select(index)
        turtle.digUp()      
        turtle.placeUp()  
    end
    -- Chest is now deployed
    for slot = 1, SLOT_COUNT, 1 do
        local item = turtle.getItemDetail(slot)
        if(item ~= nil) then
            if(item["name"] ~= "minecraft:coal_block" and item["name"] ~= "minecraft:coal" and item["name"] ~= "minecraft:charcoal") then
                turtle.select(slot)
                turtle.dropUp()
            end
        end
    end
    -- Items are now stored

    turtle.digUp()
end


local function detectAndDig()
    while(turtle.detect()) do
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
    if(tier % 2 == 1) then
        if(heading == 2 or heading == 3) then
            rightTurn()
        elseif(heading == 1 or heading == 4) then
            leftTurn()
        end
    else
        if(heading == 2 or heading == 3) then
            leftTurn()
        elseif(heading == 1 or heading == 4) then
            rightTurn()
        end
    end
    
    return FlipDirection(heading)
end



local function startQuary(width, height, depth, heading)

    for tier = 1, height, 1 do
        for col = 1, width, 1 do
            for row = 1, depth - 1, 1 do
                if(not checkFuel()) then
                    print("Turtle is out of fuel, Powering Down...")
                    return
                end
                forward()
            end
            if(col ~= width) then
                heading = turnAround(tier, heading)
            end
            manageInventory()
        end
        if(tier ~= height) then
            heading = dropTier(heading)
        end
    end

    return heading
end


local quary = data[2]
local finishedHeading = startQuary(quary.x, quary.y, quary.z, finalHeading)



--------------------------------START RETURN TRIP CODE------------------------------------





------------------------------------------------------------------------------------------


local function returnTo(coords, heading)
    local currX, currY, currZ = gps.locate()
    local xDiff, yDiff, zDiff = coords.x - currX, coords.y - currY, coords.z - currZ
    print(string.format("Distances from end: %d %d %d", xDiff, yDiff, zDiff))
    
    -- Move to Y start
    if(yDiff < 0) then    
        digAndMoveDown(math.abs(yDiff))
    elseif(yDiff > 0) then
        digAndMoveUp(math.abs(yDiff))
    end

    -- Move to X start
    heading = setHeadingX(xDiff, heading)
    digAndMove(math.abs(xDiff))

    -- Move to Z start
    heading = setHeadingZ(zDiff, heading)
    digAndMove(math.abs(zDiff))
    
    

    return heading
end

local endCoords = data[3]
returnTo(endCoords ,finishedHeading)

local timoutWait = 90
for i = 1, timoutWait, 1 do
    os.sleep(1)
    print(string.format( "Waiting for brothers %d/%d", i, timoutWait))
end

modem.transmit(SERVER_PORT, CLIENT_PORT, "cum")