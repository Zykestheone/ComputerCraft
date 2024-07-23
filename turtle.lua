local success, data = turtle.inspect()

if success then
    print("Block name: ", data.name)
    print("Block metadata: ", data.metadata)
    print("Block state: ", data.state)
else
    print("No Block Detected")
end