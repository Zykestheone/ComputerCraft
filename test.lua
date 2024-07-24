local ws = http.websocket("ws://localhost:5656")

local data = ws.receive()

local cmd = textutils.unserialise(data)
print(cmd)

