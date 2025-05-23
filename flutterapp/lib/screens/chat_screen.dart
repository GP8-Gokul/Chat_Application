import 'package:flutter/material.dart';
import 'package:flutterapp/widgets/confirm_button.dart';
import 'package:flutterapp/widgets/input_field.dart';
import 'package:flutterapp/service/socket.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];

  void sendMessage() {
    if (_messageController.text.isNotEmpty) {
      SocketService().sendMessageToServer(_messageController.text);
      setState(() {
        _messages.add(_messageController.text);
        _messageController.clear();
      });
    }
  }

  void receiveMessage() {
    SocketService().socket.on('message', (data) {
      if (data != null) {
        setState(() {
          _messages.add(data);
        });
      }
    });
  }

  void end() {
    SocketService().disconnect(context);
  }

  void initState() {
    super.initState();
    receiveMessage(); // Start listening
  }

  bool isOwnMessage(String message) {
    return _messages
        .contains(message); // Improve this with proper message struct
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(height: 60, color: Colors.transparent),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: isOwnMessage(_messages[index])
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      _messages[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: InputField(
                      controller: _messageController, errorText: null),
                ),
                const SizedBox(width: 10),
                ConfirmButton(onPressed: sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
