import asyncio
import serial
import websockets

SERIAL_PORT = '/dev/cu.usbserial-120'
BAUDRATE = 9600
PORT = 6789

async def serial_to_websocket(websocket):
    print("Client connected")
    ser = None
    try:
        ser = serial.Serial(SERIAL_PORT, BAUDRATE, timeout=1)
        print(f"Serial port opened: {SERIAL_PORT}")
        while True:
            if ser.in_waiting > 0:
                line = ser.readline().decode('utf-8').strip()
                await websocket.send(line)
            await asyncio.sleep(0.1)
    except Exception as e:
        print(f"Error: {e}")
    finally:
        if ser:
            ser.close()

async def main():
    async with websockets.serve(serial_to_websocket, "0.0.0.0", PORT):
        print(f"WebSocket server running on port {PORT}")
        await asyncio.Future()

if __name__ == "__main__":
    asyncio.run(main())
