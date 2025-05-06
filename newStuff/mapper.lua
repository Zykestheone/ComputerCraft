peripheral.find("modem", rednet.open)

print("Listening for block maps...")

while true do
    local senderID, message, protocol = rednet.receive()
    if protocol == "blockmap" then
        local receivedMap = textutils.unserialize(message)
        print("Received block map from ID:", senderID)
        
        -- Do something with it:
        for pos, name in pairs(receivedMap) do
            print(pos .. ": " .. name)
        end
    end
end
