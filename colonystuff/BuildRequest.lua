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

    return jobids
end

function checkJobID(jobids)
    print("Please Enter Job ID: ")
    local inputID = tonumber(read())
    print(inputID)
end


local jobids = workOrders()
checkJobID(jobids)