import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutterapp/screens/chat_screen.dart';
import 'package:flutterapp/screens/register_screen.dart';
import 'dart:developer';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  late Socket socket;

  void connect(BuildContext context) {
    socket = io('http://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    log('no issues before connect');
    socket.connect();
    log('no issues after connect');
    socket.onConnect((_) {
      //Connected successfully
      log('Connected to server');
    });
    socket.on('clients', (client) {
      if (client > 1 && socket.connected) {
        Navigator.pushNamed(context, ChatScreen.routeName);
        log('2 clients');
      } else {
        //Show waiting message
        log('Only you here');
      }
    });
  }

  void disconnect(BuildContext context) {
    socket.disconnect();
    socket.dispose();
    Navigator.pushNamed(context, RegisterScreen.routeName);
  }

  void sendMessageToServer(String message) {
    socket.emit('chat', message);
  }

  void receiveMessageFromServer() {
    socket.on('message', (data) {
      //Display data
      log('Data from server');
    });
  }
}
