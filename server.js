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

    socket.emit('message', `Welcome ${name}!`);

    if (clients.length === 1) {
        socket.emit('message', 'Waiting for another client to connect...');
    }

    if (clients.length === 2) {
        clients[0].socket.emit('message', `${clients[1].name} has connected. You can start chatting!`);
        clients[1].socket.emit('message', `You are connected to ${clients[0].name}. Start chatting!`);
    }
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
