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
    if action == "back"
        then rednet.broadcast(back)
    end
    if action == "left"
        then rednet.broadcast(left)
    end
    if action == "right"
        then rednet.broadcast(right)
    end
end