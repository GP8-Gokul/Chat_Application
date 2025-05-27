const users = require('../data/users');

function registerUser(io, socket, name) {
    users.addUser(socket, name);
    console.log(`${name} connected.`);
    sendUserListToAll(io);
}

function sendUserListToAll(io) {
    const updatedList = users.getUserList().map(user => ({
        name: user.name,
        id: user.socketId
    }));

    io.emit('user_list', updatedList);
}

function handleDisconnect(io, socket) {
    const removedUser = users.removeUser(socket);
    if (removedUser) {
        console.log(`${removedUser.name} disconnected.`);
        sendUserListToAll(io);
    }
}

module.exports = {
    registerUser,
    handleDisconnect
};
