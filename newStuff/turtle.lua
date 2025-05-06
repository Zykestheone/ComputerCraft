-- Starting Position
local position = vector.new(0,0,0)
local facing = 0 --North(Relative)
local blockMap = {}

local function setBlock(pos, name)
    local key = string.format("%d,%d,%d", pos.x, pos.y, pos.z)
    blockMap[key] = name
end


local function inspectAll()
    local frontPos = position + getFacing()
    local hasFront, frontData = turtle.inspect()
    if hasFront then
        setBlock(frontPos, frontData.name)
    end

    local upPos = position + vector.new(0, 1, 0)
    local hasUp, upData = turtle.inspectUp()
    if hasUp then
        setBlock(upPos, upData.name)
    end

    local downPos = position + vector.new(0, -1, 0)
    local hasDown, downData = turtle.inspectDown()
    if hasDown then
        setBlock(downPos, downData.name)
    end
end

function turnLeft()
    turtle.turnLeft()
    facing = (facing -1) % 4
    inspectAll()
end

function turnRight()
    turtle.turnRight()
    facing = (facing + 1) % 4
    inspectAll()
end

function getFacing()
    local dirs = {
        [0] = vector.new(0, 0, -1),
        [1] = vector.new(1, 0, 0),
        [2] = vector.new(0, 0, 1),
        [3] = vector.new(-1, 0, 0)
    }
    return dirs[facing]
end

function forward()
    inspectAll()
    if turtle.forward() then
        position = position + getFacing()
        return true
    end
    return false
end

function back()
    inspectAll()
    if turtle.back() then
        position = position - getFacing()
        return true
    end
    return false
end

function up()
    inspectAll()
    if turtle.up() then
        position = position + vector.new(0, 1, 0)
        return true
    end
    return false
end

function down()
    inspectAll()
    if turtle.down() then
        position = position + vector.new(0, -1, 0)
        return true
    end
    return false
end

function sendBlockMap(targetID)
    local data = textutils.serialize(blockMap)
    rednet.send(targetID, data, "blockmap")
    print("Block map sent to ID:", targetID)
end


peripheral.find("modem", rednet.open)

print("Waiting for Command")

while true do
    local senderID, message = rednet.receive()
    print("Received:", message)

    if message == "forward" then forward()
    elseif message == "back" then back()
    elseif message == "left" then turnLeft()
    elseif message == "right" then turnRight()
    elseif message == "up" then up()
    elseif message == "down" then down()
    end

    sendBlockMap(0)
end