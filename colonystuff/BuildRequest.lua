local me = peripheral.find("meBridge")
local colony = peripheral.find("colonyIntegrator")

function workOrders()
    local jobids = colony.getWorkOrders()
    
    for i, jobid in ipairs(jobids) do
        local id = jobid.id
        local type = jobid.workOrderType
        print("Job ID is " .. id)
        print("Job Type is " .. type)
    end
end

workOrders()