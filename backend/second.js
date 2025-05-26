const express = require('express');
const http = require('http');
const socket = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = socket(server);

let userList = [];

function registerUser(socket, name) {
    socket.name = name;
    userList.push({ socket: socket, name: name, socketId: socket.id });
    console.log(`${name} connected.`);

    sendUserListToAll();
}

function sendUserListToAll() {
    const updatedList = userList.map(user => ({
        name: user.name,
        id: user.socketId
    }));

    io.emit('user_list', updatedList);
}

function handleDisconnect(socket) {
    const index = userList.findIndex(c => c.socket === socket);
    if (index !== -1) {
        const disconnectedClient = userList.splice(index, 1)[0];
        console.log(`${disconnectedClient.name} disconnected.`);
        sendUserListToAll();
    }
}

function privateMessage(fromSocket, toId, message) {
    const toClient = userList.find(user => user.socket.id === toId);
    if (toClient) {
        toClient.socket.emit('private_message', {
            from: fromSocket.name,
            message: message
        });
    }
}

io.on('connection', socket => {
    socket.on('register', name => {
        registerUser(socket, name);
    });

    socket.on('private_message', ({ toId, message }) => {
        privateMessage(socket, toId, message);
    });

    socket.on('disconnect', () => {
        handleDisconnect(socket);
    });
});

server.listen(3000, () => {
    console.log('Server running at http://localhost:3000');
});
