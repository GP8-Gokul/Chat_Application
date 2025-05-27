const group = require('../data/groups');

function sendGroupListToAll(io) {
    const updatedGroupList = group.getGroupList().map(group => ({
        id: group.id,
        name: group.name,
    }));

    io.emit('group_list', updatedGroupList);
}

function joinGroup(socket, groupId) {
    const group = group.findGroupById(groupId);
    if (group) {
        socket.join(groupId);
        group.members.push(socket.name);
        console.log(`${socket.name} joined group: ${group.name}`);
    }
}

function createGroup(io, socket, name, creator) {
    const groupId = Date.now().toString();
    const group = {
        id: groupId,
        name,
        creator,
        members: [creator]
    };
    group.addGroup(group);
    socket.join(groupId);
    console.log(`Group created: ${name} by ${creator}`);
    sendGroupListToAll(io);
}

function groupMessage(io, socket, groupId, message) {
    const group = group.findGroupById(groupId);
    if (group) {
        io.to(groupId).emit('group_message', {
            from: socket.name,
            message,
        });
        console.log(`Group message from ${socket.name} to group ${groupId}: ${message}`);
    }
}

module.exports = {
    createGroup,
    joinGroup,
    groupMessage,
};
