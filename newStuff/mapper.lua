peripheral.find("modem", rednet.open)

print("Listening for turtle map/position...")

while true do
    local senderID, message, protocol = rednet.receive()
    if protocol == "blockmap" then
        local data = textutils.unserialize(message)

        if type(data) == "table" and data.position and data.blocks then
            local pos = data.position
            local blocks = data.blocks

            print(string.format("Turtle at (%d, %d, %d) sent a block map", pos.x, pos.y, pos.z))
            
            -- Loop through received blocks
            for key, blockName in pairs(blocks) do
                print(key .. ": " .. blockName)
            end
        else
            print("Malformed blockmap message from", senderID)
        end
    end
end
