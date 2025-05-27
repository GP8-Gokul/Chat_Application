const userList = [];

function addUser(socket, name) {
    socket.name = name;
    const user = { socket, name, socketId: socket.id };
    userList.push(user);
}

function removeUser(socket) {
    const index = userList.findIndex(u => u.socket.id === socket.id);
    if (index !== -1) {
        return userList.splice(index, 1)[0];
    }
    return null;
}

function getUserList() {
    return userList;
}

function findUserBySocketId(socketId) {
    return userList.find(u => u.socketId === socketId);
}

module.exports = {
    addUser,
    removeUser,
    getUserList,
    findUserBySocketId
};
