local colony = peripheral.find("colonyIntegrator")

local workOrders = colony.getWorkOrders()

for i, workOrder in ipairs(workOrders) do
    local builder = workOrder.builder
    print(workOrder.id)
    print(workOrder.priority)
    print(workOrder.workOrderType)
    print("isClaimed? :", workOrder.isClaimed)
    if builder then
        print("Builder Pos", builder.x, builder.y, builder.z)    
    end
    print(workOrder.buildingName)
    print(workOrder.type)
    print(workOrder.targetLevel)
end