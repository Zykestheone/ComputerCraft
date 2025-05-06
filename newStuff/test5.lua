local colony = peripheral.wrap("left")
if colony then
    local workOrders = colony.getWorkOrders()
    for i, workOrder in ipairs(workOrders) do
        local workOrderID = workOrder.id
        local workOrderType = workOrder.workOrderType
        if workOrder.isClaimed then
            print(workOrder.buildingName)
            print(workOrderID)
            print(workOrderType)

            local workOrderResources = colony.getWorkOrderResources(workOrderID)
            for i, workOrderResource in ipairs(workOrderResources) do
                print(workOrderResource.displayName.. workOrderResource.status.."/"..workOrderResource.needed)            end
        end
    end
end