import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutterapp/screens/chat_screen.dart';
import 'package:flutterapp/screens/register_screen.dart';

class SocketService {
  late Socket socket;

  void connect(BuildContext context) {
    socket = io('http://localhost:5000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect((_) {
      //Connected successfully
    });
    socket.on('clients', (client) {
      if (client > 1 && socket.connected) {
        Navigator.pushNamed(context, ChatScreen.routeName);
      } else {
        //Show waiting message
      }
    });
  }

  void disconnect(BuildContext context) {
    socket.disconnect();
    socket.dispose();
    Navigator.pushNamed(context, RegisterScreen.routeName);
  }

  void sendMessageToServer(String message) {
    socket.emit('message', message);
  }

  void receiveMessageFromServer() {
    socket.on('message', (data) {
      //Display data
    });
  }
}
