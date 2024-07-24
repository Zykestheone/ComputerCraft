ws = http.websocket("ws://localhost:5656")
local x,y,z = gps.locate()
local fuel = turtle.getFuelLevel()

ws.send("XYZ: "..x.." / "..y.." / "..z)
ws.send("Fuel: "..fuel)