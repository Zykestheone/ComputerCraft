--PHONE SERVER--

local SERVER_PORT = 420
local CLIENT_PORT = 0
local SLOT_COUNT = 16

local segmentation = 5
if (#arg == 1) then
    local temp_segmentation = tonumber(arg[1])
    if temp_segmentation then
        segmentation = temp_segmentation
    else
        print("Invalid Argument, must be a number")
        do return end
    end
elseif (#arg == 0) then
    print(string.format("No segmentation size selected, defaulting to %d", segmentation))
else
    print('Too many args given...')
    do return end
end

local modem = peripheral.wrap("right")
modem.open(SERVER_PORT)

local target = vector.new()
local size = vector.new()
local finish = vector.new()

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

    return coords
end

local function getItemIndex(itemName)
    for slot = 1, SLOT_COUNT do
        local item = turtle.getItemDetail(slot)
        if item and item.name == itemName then
            return slot
        end
    end
    return nil
end

local function checkFuel()
    turtle.select(1)
    if turtle.getFuelLevel() < 50 then
        print("Attempting Refuel...")
        for slot = 1, SLOT_COUNT do
            turtle.select(slot)
            if turtle.refuel(1) then
                return true
            end
        end
        return false
    else
        return true
    end
end

local function deployFuelChest()
    if not checkFuel() then
        print("SERVER NEEDS FUEL...")
        os.exit(1)
    end
end

local function calculateFuel(travelDistance, segmentSize, fuelType)
    -- Calculate the total number of movements within the segment
    local horizontalMovesPerLayer = (segmentSize.x * segmentSize.z) * 2
    local verticalMoves = segmentSize.y * 2
    local totalMoves = travelDistance + (horizontalMovesPerLayer * segmentSize.y) + verticalMoves

    -- Print debugging information
    print(string.format("Travel distance: %d", travelDistance))
    print(string.format("Horizontal moves per layer: %d", horizontalMovesPerLayer))
    print(string.format("Vertical moves: %d", verticalMoves))
    print(string.format("Total moves: %d", totalMoves))

    -- Calculate fuel based on the fuel type
    local totalFuel = totalMoves
    if fuelType == "minecraft:coal" then
        totalFuel = totalFuel / 80
    elseif fuelType == "minecraft:coal_block" then
        totalFuel = totalFuel / 800
    elseif fuelType == "minecraft:charcoal" then
        totalFuel = totalFuel / 80
    else
        print("INVALID FUEL SOURCE")
        return nil
    end

    return math.ceil(totalFuel) + 5
end

local function deploy(startCoords, quarySize, endCoords, options, travelDistance)
    -- Calculate fuel needed for the segment
    local fuelNeeded = calculateFuel(travelDistance, quarySize, "minecraft:coal")
    if fuelNeeded == nil then
        print("Failed to calculate fuel needed.")
        os.exit(1)
    end

    -- Place turtle from inventory
    turtle.select(getItemIndex("computercraft:turtle_advanced"))
    while turtle.detect() do
        os.sleep(0.3)
    end

    -- Place and turn on turtle
    turtle.place()
    os.sleep(1)
    peripheral.call("front", "turnOn")

    -- Wait for client to send ping
    Event, Side, SenderChannel, ReplyChannel, Msg, Distance = os.pullEvent("modem_message")
    if Msg ~= "CLIENT_DEPLOYED" then
        print("No client deploy message, exitting...")
        os.exit()
    end

    if options.withStorage then
        -- Set up ender chest
        if not checkFuel() then
            print("SERVER NEEDS FUEL...")
            os.exit(1)
        end
    end

    deployFuelChest()
    local storageBit = options.withStorage and 1 or 0

    -- Client is deployed
    modem.transmit(CLIENT_PORT,
        SERVER_PORT,
        string.format("%d %d %d %d %d %d %d %d %d %d %d", 
        startCoords.x, startCoords.y, startCoords.z,
        quarySize.x, quarySize.y, quarySize.z,
        endCoords.x, endCoords.y, endCoords.z,
        storageBit, fuelNeeded
    ))
end

-- Return array of arbitrary size for each bot placement
local function getPositioningTable(x, z, segmentationSize)
    local xRemainder = x % segmentationSize
    local zRemainder = z % segmentationSize

    local xMain = x - xRemainder
    local zMain = z - zRemainder

    xRemainder = (xRemainder == 0 and segmentationSize or xRemainder)
    zRemainder = (zRemainder == 0 and segmentationSize or zRemainder)

    local positions = {}

    for zi = 0, z - 1 , segmentationSize do
        for xi = 0, x - 1, segmentationSize do
            local dims = {xi, zi, segmentationSize, segmentationSize}
            if xi >= x - segmentationSize and xi <= x - 1 then
                dims = {xi, zi, xRemainder, segmentationSize}
            end
            if zi >= z - segmentationSize and zi <= z - 1 then
                dims = {xi, zi, segmentationSize, zRemainder}
            end
            table.insert(positions, dims)
        end
    end

    return table.pack(positions, xRemainder, zRemainder)
end

while true do
    -- Wait for phone
    print("Waiting for target signal...")
    Event, Side, SenderChannel, ReplyChannel, Msg, Distance = os.pullEvent("modem_message")

    -- Parse out coordinates and options
    local args = split(Msg, " ")
    local withStorage = args[#args]
    withStorage = withStorage == "1" and true or false
    local data = parseParams(Msg)
    local options = {}
    options["withStorage"] = true

    target = data[1]
    size = data[2]

    finish = vector.new(gps.locate())
    finish.y = finish.y + 1
    print(string.format( "RECEIVED QUARY REQUEST AT: %d %d %d", target.x, target.y, target.z))

    Tab, XDf, ZDf = table.unpack(getPositioningTable(size.x, size.z, segmentation))

    print(string.format("Deploying %d bots...", #Tab))
    for i = 1, #Tab do
        XOffset, ZOffset, Width, Height = table.unpack(Tab[i])
        local offsetTarget = vector.new(target.x + XOffset, target.y, target.z + ZOffset)
        local scaledSize = vector.new(Width, size.y, Height)
        local travelDistance = math.abs(finish.x - offsetTarget.x) + math.abs(finish.y - offsetTarget.y) + math.abs(finish.z - offsetTarget.z)

        deploy(offsetTarget, scaledSize, finish, options, travelDistance)
        os.sleep(1)
        print(string.format("Deploying to; %d %d %d %d %d", target.x + XOffset, target.y, target.z + ZOffset, scaledSize.x, scaledSize.z))
    end

    -- All bots deployed, wait for last bot finished signal
    Event, Side, SenderChannel, ReplyChannel, Msg, Distance = os.pullEvent("modem_message")
    turtle.digUp()
    turtle.turnRight()
    turtle.forward(1)
    turtle.turnLeft()
    turtle.select(getItemIndex("enderstorage:ender_chest"))
    Endercount = (turtle.getItemCount())
    if Endercount > 0 then
        print(string.format("Depositing %d Ender Chests.", Endercount))
        turtle.drop(Endercount)
    end
    
    turtle.turnLeft()
    turtle.forward(1)
    turtle.turnRight()
end
