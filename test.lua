local ws,err = http.websocket("ws://localhost:5656")
if ws then
    while true do
        local data = ws.receive()
        if data ~= "getfuel" then
            local cmd = assert(loadstring(data))
            cmd()
        end
        elseif data == "getfuel" then
            local flevel =turtle.getFuelLevel()
            ws.send(flevel)
        end
    end
elseif err then
    print(err)
end