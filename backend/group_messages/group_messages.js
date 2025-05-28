const group = require('../data/groups');

function sendGroupListToAll(io) {
    const updatedGroupList = group.getGroupList().map(group => ({
        id: group.id,
        name: group.name,
    }));

    io.emit('group_list', updatedGroupList);
}

function joinGroup(socket, groupId) {
    const groupFound = group.findGroupById(groupId);
    if (groupFound) {
        socket.join(groupId);
        group.members.push(socket.id);
        console.log(`${socket.name} joined group: ${group.name}`);
    }
}

function createGroup(io, socket, name, creatorID) {
    console.log(`Creating group: ${name} by ${creatorID}`);
    const groupId = Date.now().toString();
    const newGroup = {
        id: groupId,
        name,
        creatorID,
        members: [creatorID]
    };
    group.addGroup(newGroup);
    socket.join(groupId);
    console.log(`Group created: ${name} by ${creatorID}`);
    sendGroupListToAll(io);
}

function groupMessage(io, socket, groupId, message) {
    const foundGroup = group.findGroupById(groupId);
    if (foundGroup) {
        io.emit('group_message', {
            fromGroup: groupId,
            fromUser: socket.id,
            message: message,
        });
        console.log(`Group message from ${socket.name} to group ${groupId}: ${message}`);
    }
}

module.exports = {
    createGroup,
    joinGroup,
    groupMessage,
};
