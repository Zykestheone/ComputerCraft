-- Call the function to get the list of current requests
    local colony = peripheral.wrap("back")
    local requests = colony.getRequests()
    local monitor = peripheral.wrap("left")

    -- Check if requests were retrieved successfully
    if requests then
        -- Iterate through each request in the table
        for i, request in ipairs(requests) do
            -- Extract desired properties from each request
            local id = request.id
            local name = request.name
            local desc = request.desc
            local state = request.state
            local count = request.count
            local minCount = request.minCount
            local target = request.target
            local items = request.items
            
            -- Print the extracted properties (or store them as needed)
            monitor.write("Request ID: " .. id)
            monitor.write("Name: " .. name)
            monitor.write("Description: " .. desc)
            monitor.write("State: " .. state)
            monitor.write("Count: " .. count)
            monitor.write("Min Count: " .. minCount)
            monitor.write("Target: " .. target)
            
            -- If you need to print or handle items, you can iterate through the items table
            if items then
                for j, item in ipairs(items) do
                    -- Extract item properties as needed
                    -- For example: item.id, item.name, etc.
                    monitor.write("Item " .. j .. ": " .. item.name)
                end
            end
            
            monitor.write("---------------------------") -- Separator between requests
        end
    else
        monitor.write("No requests found.")
    end
    