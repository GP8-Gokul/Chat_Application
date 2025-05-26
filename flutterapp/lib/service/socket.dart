import 'package:socket_io_client/socket_io_client.dart';
import 'dart:developer';

Map<String, dynamic> allMessages = {
  'userName': '',
  'userId': '',
  'messages': [],
};

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  late Socket socket;

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
}
