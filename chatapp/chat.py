import socketio
import threading

sio = socketio.Client()

def userInput():
    while True:
        try:
            msg = input()
        except EOFError:
            print("Exiting chat.")
            sio.disconnect()
            break
        if msg.lower() == 'exit':
            print("Disconnecting")
            sio.disconnect()
            break
        sio.emit('chat', msg)

@sio.event
def connect():
    print("Connected to server.")
    name = input("Enter your name to register: ")
    sio.emit('register', name)

@sio.event
def message(data):
    print(data)

@sio.event
def disconnect():
    print("Disconnected from server.")

if __name__ == '__main__':
    try:
        sio.connect('http://localhost:3000')
        threading.Thread(target=userInput).start()
        sio.wait()
    except KeyboardInterrupt:
        print("\nDisconnected")
        sio.disconnect()