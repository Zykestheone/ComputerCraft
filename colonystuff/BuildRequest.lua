local me = peripheral.find("meBridge")
local colony = peripheral.find("colonyIntegrator")

function termclear()
    term.clear()
    term.setCursorPos(1,1)
end

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
    print("Please Enter Job ID:")
    local inputID = tonumber(read())

    for i, jobid in ipairs(jobids) do
        if jobid.id == inputID then
            print("Getting Resources")
            termclear()
            getResources(inputID)
            return
        end
    end
    print("Invalid ID")
end

function getResources(jobID)
    local resources = colony.getWorkOrderResources(jobID)
    
    if resources then
        print("Resources needed for Job ID " .. jobID .. ":")
        for i, resource in ipairs(resources) do
            print("Item: " .. resource.item)
            print("Display Name: " .. resource.displayName)
            print("Status: " .. resource.status)
            print("Needed: " .. resource.needed)
            print("Available: " .. tostring(resource.available))
            print("Delivering: " .. tostring(resource.delivering))
            print("--------------------")
        end
    else
        print("No resources found for Job ID " .. jobID .. " or the Job ID does not exist.")
    end
end

local jobids = workOrders()
checkJobID(jobids)