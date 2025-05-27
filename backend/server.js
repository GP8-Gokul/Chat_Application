const express = require('express');
const http = require('http');
const socket = require('socket.io');

const group = require('./group_messages/group_messages');
const connection = require('./connection/connection');
const privateMessage = require('./private_messages/user_message');

const app = express();
const server = http.createServer(app);
const io = socket(server);

io.on('connection', socket => {
    socket.on('register', name => {
        connection.registerUser(io, socket, name);
    });

    socket.on('disconnect', () => {
        connection.handleDisconnect(io, socket);
    });

    socket.on('private_message', ({ toId, message }) => {
        privateMessage.privateMessage(socket, toId, message);
    });

    socket.on('create_group', ({ name, creator }) => {
        group.createGroup(io, socket, name, creator);
    });

    socket.on('join_group', ({ groupId }) => {
        group.joinGroup(socket, groupId);
    });

    socket.on('group_message', ({ groupId, message }) => {
        group.groupMessage(io, socket, groupId, message);
    });

});

server.listen(3000, () => {
    console.log('Server running at http://localhost:3000');
});
