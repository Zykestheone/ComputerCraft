local Colony = peripheral.find("colonyIntegrator")
if not Colony then
    return "no colony"
end

local requests = Colony.getRequests()
if not requests then
    return "no requests"
end

for _, request in ipairs(requests) do
    print("-----------------")
    print("Request ID: " .. request.id)
    print("Name: " .. request.name)
    print("Count: " .. request.count)

    for _, item in ipairs(request.items) do
        print("  Item Name: " .. item.name)
        print("  Display Name: " .. item.displayName)
        print("  Count: " .. item.count)
    end
end
