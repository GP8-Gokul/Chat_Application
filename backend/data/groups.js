let groupList = [];

function getGroupList() {
    return groupList;
}

function findGroupById(groupId) {
    return groupList.find(g => g.id === groupId);
}

function addGroup(group) {
    groupList.push(group);
}


module.exports = {
    getGroupList,
    findGroupById,
    addGroup,
};
