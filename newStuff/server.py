import asyncio
import websockets
import json

connected_clients = set()

async def handle_command(websocket, message):
    try:
        data = json.loads(message)
    except json.JSONDecodeError:
        await websocket.send(json.dumps({"error": "Invalid JSON"}))
        return
    
    command = data.get("command")

    if command =="runCommand":
        print("Running a simulated command...")
        await websocket.send(json.dumps({
            "respone": "Command executed successfully"
        }))

    elif command == "getGPS":
        await websocket.send(json.dumps({
            "x": 123,
            "y": 64,
            "z": -456
        }))

    else:
        await websocket.send(json.dumps({
            "error": f"Unknodwn Command: {command}"
        }))

async def handler(websocket, path):
    connected_clients.add(websocket)
    print("Client connected")

    try:
        async for message in websocket:
            print(f"Received: {message}")
            await handle_command(websocket, message)
    except websockets.exceptions.ConnectionClosed:
        print("Client disconnected")
    finally:
        connected_clients.remove(websocket)

# Start the WebSocket server
start_server = websockets.serve(handler, "0.0.0.0", 8765)
print("WebSocket server listening on ws://localhost:8765")

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()