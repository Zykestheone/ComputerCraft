local ws = http.websocket("ws://localhost:5656")

local data = ws.receive()

local cmd = textutils.serialise(data)
print(cmd)

