-- goTo.lua
-- Script to move the turtle to specified x, y, z coordinates

-- Ensure the script is running on a turtle
if not turtle then
  print("Error: This can only be used by a turtle!")
  return
end

-- Function to move the turtle to the specified coordinates
function goTo(targetX, targetY, targetZ)
  -- Get current location using GPS
  local x, y, z = gps.locate()

  if not x then
    print("GPS signal not found!")
    return
  end

  -- Move on the Z-axis (north/south)
  if z < targetZ then
      turtle.setFacing("south")
      while z < targetZ do
          turtle.forceForward()
          x, y, z = turtle.location()
      end
  elseif z > targetZ then
      turtle.setFacing("north")
      while z > targetZ do
          turtle.forceForward()
          x, y, z = turtle.location()
      end
  end
  
  -- Move on the X-axis (east/west)
  if x < targetX then
      turtle.setFacing("east")
      while x < targetX do
          turtle.forceForward()
          x, y, z = turtle.location()
      end
  elseif x > targetX then
      turtle.setFacing("west")
      while x > targetX do
          turtle.forceForward()
          x, y, z = turtle.location()
      end
  end
  
  -- Move on the Y-axis (up/down)
  if y < targetY then
      while y < targetY do
          turtle.forceUp()
          x, y, z = turtle.location()
      end
  elseif y > targetY then
      while y > targetY do
          turtle.forceDown()
          x, y, z = turtle.location()
      end
  end

  print("Arrived at destination: ("..targetX..", "..targetY..", "..targetZ..")")
end

-- Parse command-line arguments
local args = {...}
if #args < 3 then
  print("Usage: goTo <x> <y> <z>")
  return
end

-- Convert arguments to numbers
local targetX = tonumber(args[1])
local targetY = tonumber(args[2])
local targetZ = tonumber(args[3])

if not targetX or not targetY or not targetZ then
  print("Error: Coordinates must be numbers")
  return
end

-- Call the goTo function with the provided coordinates
goTo(targetX, targetY, targetZ)
