local manager = peripheral.find("inventoryManager")

local items = manager.getItems()

for i,item in ipairs(items) do
    local name = item.name
    if name == "minecraft:cobblestone" then
        manager.removeItemFromPlayer("right", {name="minecraft:cobblestone"})
    end
end

