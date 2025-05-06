local keyMap = {
    [keys.w] = "forward",
    [keys.a] = "left",
    [keys.d] = "right",
    [keys.s] = "back",
    [keys.q] = "down",
    [keys.e] = "up"
}

rednet.open("back")  -- or correct side

print("Sending movement commands to Turtle")

while true do
    local event, key = os.pullEvent("key")
    local command = keyMap[key]
    if command then
        rednet.send(command)
        print("Sent:", command)
    end
end
