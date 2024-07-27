local colony = peripheral.wrap("right")
local mebridge = peripheral.wrap("left")

function request()
    requests = colony.getRequests()

    for i, request in ipairs(requests) do
        if request.items then
            for i, item in ipairs(request.items) do
                print("Item Name: " .. item.name)
                print("Item Count: " .. item.count)
            end
        end
    end
end

request()