local function fileExistsAndEqual(filePath1, filePath2)
    if not fs.exists(filePath1) or not fs.exists(filePath2) then
        return false
    end
    
    local file1 = fs.open(filePath1, "r")
    local file2 = fs.open(filePath2, "r")
    
    if not file1 or not file2 then
        if file1 then file1.close() end
        if file2 then file2.close() end
        return false
    end
    
    local content1 = file1.readAll()
    local content2 = file2.readAll()
    
    file1.close()
    file2.close()
    
    return content1 == content2
end

-- Paths for the files on the disk and the turtle
local diskClientDig = "disk/clientdig"
local turtleClientDig = "/clientdig"
local turtleStartup = "/startup"

-- Copy files if they don't exist or are different
if not fs.exists(turtleStartup) or not fileExistsAndEqual(diskClientDig, turtleStartup) then
    fs.copy(diskClientDig, turtleStartup)
end

if not fs.exists(turtleClientDig) or not fileExistsAndEqual(diskClientDig, turtleClientDig) then
    fs.copy(diskClientDig, turtleClientDig)
end

-- Run the clientdig script
shell.run("clientdig")
