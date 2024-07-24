rednet.open("back")
local forward = "turtle.forward()"
local back = "turtle.back()"
local left = "turtle.turnLeft()"
local right = "turtle.turnRight()"

while true do
    io.write("")
    action = io.read()
    if action == "forward"
        then rednet.broadcast(forward)
    end
end