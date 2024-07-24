local ws = http.websocket("ws://localhost:5656")
while true do
    local data = ws.receive()
    assert(loadstring(data)) ()
end