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
}
