rednet.open("back")

print("Rednet Server Listening...")

while true do
    local senderID, message = rednet.receive()
    if message == "runCommand" then
        print("Received command from ID:", senderID)
        if fs.exists("inventory.lua") then
            local success = shell.run("inventory.lua")
            if success then
                print("Program ran successfully")
            else
                print("program failed to run")
            end
        else
            print("Program 'inventory' not found")
        end
    end
end