const express = require('express');
const http = require('http');
const socket = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = socket(server);

let clients = [];

function isRoomFull(socket) {
    if (clients.length >= 2) {
        socket.emit('message', 'Room full. Try again later.');
        socket.disconnect();
        return true;
    };
    return false;
}

function registerUser(socket, name) {
    socket.name = name;
    clients.push({ socket, name });
    console.log(`${name} connected.`);

    console.log(`Welcome ${name}!`);

    clients.forEach(client => {
        client.socket.emit('clients', clients.length);
        console.log(clients.length)
    });
}

function isNotRegistered(socket) {
    if (!socket.name) {
        socket.emit('message', 'Please register before chatting.');
        return true;
    }
    return false;
}

function chat(socket, msg) {
    if (isNotRegistered(socket)) return;

    clients.forEach(client => {
        if (client.socket !== socket) {
            client.socket.emit('message', `${socket.name}: ${msg}`);
        }
    });
}

function handleDisconnect(socket) {
    const index = clients.findIndex(c => c.socket === socket);
    if (index !== -1) {
        const disconnectedClient = clients.splice(index, 1)[0];
        console.log(`${disconnectedClient.name} disconnected.`);

        clients.forEach(client => {
            client.socket.emit('message', `${disconnectedClient.name} has disconnected.`);
        });
    }
}

io.on('connection', socket => {
    if (isRoomFull(socket)) return;

    socket.on('register', (name) => {
        registerUser(socket, name);
    });

    socket.on('chat', msg => {
        chat(socket, msg);
    });

    socket.on('disconnect', () => {
        handleDisconnect(socket);
    });
});

server.listen(3000, () => {
    console.log('Server running at http://localhost:3000');
});
