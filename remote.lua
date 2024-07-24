rednet.open("back")
local forward = "turtle.forward()"
local back = "turtle.back()"
local left = "turtle.turnLeft()"
local right = "turtle.turnRight()"

while true do
    io.write("")
    action = io.read()
    if action == "w"
        then rednet.broadcast(forward)
    end
    if action == "s"
        then rednet.broadcast(back)
    end
    if action == "a"
        then rednet.broadcast(left)
    end
    if action == "d"
        then rednet.broadcast(right)
    end
end