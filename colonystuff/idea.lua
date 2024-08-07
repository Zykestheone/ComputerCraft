local colony = peripheral.wrap("right")
local mebridge = peripheral.wrap("left")

local function Request()
    local requests = colony.getRequests()

    for i, request in ipairs(requests) do
        if request.items then
            for i, item in ipairs(request.items) do
                print("Item Name: " .. item.name)
                print("Item Count: " .. item.count)
                CheckME(item)
            end
        end
    end
end

function CheckME(item)
    local itemDetails, err = mebridge.getItem({name = item.name})
    if itemDetails and itemDetails.amount and itemDetails.amount >= item.count then
        print("Item is Avaiable")
        ExportItem(item)
    else
        print("Item not Available")
    end
end

function ExportItem(item)
    local direction = "back"
    local exportedCount, err = mebridge.exportItem({name = item.name, count = item.count}, direction)
    if exportedCount and exportedCount > 0 then
        print("Exported Item")
    else
        print("Failled to export item " .. (err or "Unknown Error"))
    end
end

Request()