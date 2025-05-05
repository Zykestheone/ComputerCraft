local manager = peripheral.find("inventoryManager")
local items = manager.getItems()
local validTags = {
    ["minecraft:item/c:gems"] = true,
    ["minecraft:item/c:raw_materials"] = true,
    ["minecraft:item/c:dusts"] = true,
    ["minecraft:item/minecraft:coals"] = true
}

for i,item in ipairs(items) do
    for _, tag in ipairs(item.tags) do
        if validTags[tag] then
            local removed = manager.removeItemFromPlayer("right", {name = item.name, fromSlot = item.slot, count = item.count})
            print("Removed " .. removed .. " of " .. item.name)
            break
        end
    end
end
