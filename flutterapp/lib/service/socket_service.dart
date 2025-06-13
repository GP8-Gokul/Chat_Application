import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'dart:developer';

class SocketService extends ChangeNotifier {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  late Socket socket;
  late String name;
  Map<String, dynamic> allUsers = {};
  Map<String, dynamic> allGroups = {};

  void connect(String name) {
    socket = io('http://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      log('Connected to server');
      listenForPrivateMessages();
      listenForGroupMessages();
    });
    socket.emit('register', name);
    this.name = name;
    log('User registered with name: $name');
  }

  void sendMessage(userId, message) {
    allUsers[userId]['messages'].add({
      'senderId': 'me',
      'message': message,
    });
    log('Sending message: $message to user: $userId added to all users list');
    socket.emit('private_message', {
      'toId': userId,
      'message': message,
    });
    log('Message sent: $message to user: $userId');
    notifyListeners();
  }

  void updateUserList() {
    socket.on('user_list', (updatedList) {
      log('Received user list: $updatedList');

      bool hasChanges = false;

      for (var user in updatedList) {
        final userId = user['id'];
        final userName = user['name'];

        if (!allUsers.containsKey(userId)) {
          allUsers[userId] = {
            'name': userName,
            'messages': [],
          };
          hasChanges = true;
        }
      }

      List currentUserIds = allUsers.keys.toList();
      for (final id in currentUserIds) {
        if (updatedList.every((user) => user['id'] != id)) {
          allUsers.remove(id);
          hasChanges = true;
        }
      }

      if (hasChanges) {
        notifyListeners();
      }

      log('Updated allUsers: $allUsers');
    });
  }

  void listenForPrivateMessages() {
    socket.on('private_message', (data) {
      final senderId = data['from'] as String;
      final message = data['message'] as String;

      allUsers[senderId]['messages'].add({
        'senderId': senderId,
        'message': message,
      });

      notifyListeners();
    });
  }

  void createGroup(String groupName) {
    log('Creating group: $groupName');
    socket.emit('create_group', {
      'name': groupName,
      'creatorID': socket.id,
    });
    log('Group creation request sent for: $groupName');
  }

  void joinGroup(String groupId) {
    log('Joining group: $groupId');
    if (!allGroups.containsKey(groupId)) {
      socket.emit('join_group', {'groupId': groupId});
      log('Join group request sent for: $groupId');
    } else {
      log('Already a member of group: $groupId So entering group');
    }
  }

  void loadGroups() {
    socket.on('group_list', (updatedGroups) {
      log('Received group list: $updatedGroups');

      bool hasChanges = false;

      for (var group in updatedGroups) {
        final groupId = group['id'];
        final groupName = group['name'];

        if (!allGroups.containsKey(groupId)) {
          allGroups[groupId] = {
            'name': groupName,
            'members': [],
            'messages': [],
          };
          hasChanges = true;
        }
        log(allGroups.toString());

        if (hasChanges) {
          notifyListeners();
        }
      }
    });
  }

  void listenForGroupMessages() {
    socket.on('group_message', (data) {
      final groupId = data['fromGroup'] as String;
      final senderId = data['fromUser'] as String;
      final message = data['message'] as String;

      if (allGroups.containsKey(groupId) && senderId != socket.id) {
        log('senderId: $senderId, socket.id: ${socket.id}');
        allGroups[groupId]['messages'].add({
          'senderId': senderId,
          'message': message,
        });
        notifyListeners();
        log('Received group message: $message in group: $groupId');
      } else {
        log('Group $groupId not found in allGroups');
      }
    });
  }

  void sendGroupMessage(String groupId, String message) {
    log('Sending group message: $message to group: $groupId');
    socket.emit('group_message', {
      'groupId': groupId,
      'message': message,
    });
    if (allGroups.containsKey(groupId)) {
      allGroups[groupId]['messages'].add({
        'senderId': 'me',
        'message': message,
      });
      notifyListeners();
      log('Message sent: $message to group: $groupId');
    } else {
      log('Group $groupId not found in allGroups');
    }
  }

  Future<int?> signup(String username, String email, String password) async {
    log('Signing up with username: $username, email: $email');
    final completer = Completer<int?>();

    socket.emitWithAck('signup', {
      'username': username,
      'email': email,
      'password': password,
    }, ack: (data) {
      if (data is Map && data.containsKey('status')) {
        completer.complete(data['status'] as int?);
      } else if (data is int) {
        completer.complete(data);
      } else {
        completer.complete(null);
      }
    });

    return completer.future;
  }

  Future<int?> login(String username, String password) async {
    log('Logging in with username: $username');
    final completer = Completer<int?>();

    socket.emitWithAck('login', {
      'username': username,
      'password': password,
    }, ack: (data) {
      if (data is Map && data.containsKey('status')) {
        completer.complete(data['status'] as int?);
      } else if (data is int) {
        completer.complete(data);
      } else {
        completer.complete(null);
      }
    });

    return completer.future;
  }
}
