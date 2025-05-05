local manager = peripheral.find("inventoryManager")
local items = manager.getItems()

local wantedTags = {
    ["minecraft:item/c:gems"] = true,
    ["minecraft:item/c:raw_materials"] = true,
    ["minecraft:item/c:dusts"] = true,
    ["minecraft:item/minecraft:coals"] = true
}
local unwantedTags = {
    ["minecraft:item/c:cobblestones"] = true,
    ["minecraft:item/c:dirt"] = true,
    ["minecraft:item/c:gravels"] = true
}
local unwantedItems = {
    ["minecraft:granite"] = true,
    ["minecraft:andesite"] = true,
    ["minecraft:diorite"] = true,
    ["minecraft:tuff"] = true,
    ["minecraft:flint"] = true
}

for _, item in ipairs(items) do
    local isWanted = false
    local isUnwanted = unwantedItems[item.name] or false

    for _, tag in ipairs(item.tags) do
        if unwantedTags[tag] then
            isUnwanted = true
        end
        if wantedTags[tag] then
            isWanted = true
        end
    end

    if isWanted and not isUnwanted then
        local removed = manager.removeItemFromPlayer("right", {
            name = item.name, fromSlot = item.slot, count = item.count
        })
        print("Removed wanted: " .. removed .. " of " .. item.name)
    elseif isUnwanted then
        local removed = manager.removeItemFromPlayer("up", {
            name = item.name, fromSlot = item.slot, count = item.count
        })
        print("Removed unwanted: " .. removed .. " of " .. item.name)
    end
end
