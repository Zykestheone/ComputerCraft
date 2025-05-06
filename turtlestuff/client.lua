rednet.open("back")

print("Press any key to trigger action...")

while true do
    local event, key = os.pullEvent("key")
    rednet.broadcast("runCommand")
    print("Command sent.")
    sleep(0.5)
end
