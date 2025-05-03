local colony = peripheral.wrap("left")
if colony then
    local workOrders = colony.getWorkOrders()
    for i, workOrder in ipairs(workOrders) do
        local workOrderID = workOrder.id
        local workOrderType = workOrder.workOrderType

        print(workOrderID)
        print(workOrderType)
    end
end
