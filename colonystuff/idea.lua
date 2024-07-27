local colony = peripheral.wrap("right")
local mebridge = peripheral.wrap("left")

function request()
    requests = colony.getRequests()

    for i, request in ipairs(requests) do
        if request.items then
            for i, item in ipairs(request.items) do
                print("Item Name: " .. item.name)
                print("Item Count: " .. item.count)
                checkME(item)
            end
        end
    end
end

function checkME(item)
    local itemDetails = mebridge.getItem({name = item.name})
    if itemDetails then
        print("Item Available")
    else
        print("Item not Avaiable")
    end
end

request()