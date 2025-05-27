const user = require('../data/users');

function privateMessage(fromSocket, toId, message) {
    const toClient = user.findUserBySocketId(toId);
    if (toClient) {
        toClient.socket.emit('private_message', {
            from: fromSocket.id,
            message: message
        });
    }
    console.log(`Private message from ${fromSocket.name} to ${toId}: ${message}`);
}

module.exports = {
    privateMessage
};