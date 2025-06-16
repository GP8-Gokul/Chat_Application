const express = require('express');
const http = require('http');
const socket = require('socket.io');

const group = require('./group_messages/group_messages');
const connection = require('./connection/connection');
const privateMessage = require('./private_messages/user_message');
const auth = require('./authentication/authentication');

const app = express();
const server = http.createServer(app);
const io = socket(server);

app.use(express.json());

app.post('/signup', auth.signup);
app.post('/login', auth.login);
app.post('/verify-otp', auth.verifyOtp);

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

    socket.on('create_group', ({ name, creatorID }) => {
        group.createGroup(io, socket, name, creatorID);
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
