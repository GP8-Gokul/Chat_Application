import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'dart:developer';

class SocketService extends ChangeNotifier {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  late Socket socket;
  Map<String, dynamic> allUsers = {};

  void connect() {
    socket = io('http://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      log('Connected to server');
    });
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
}
