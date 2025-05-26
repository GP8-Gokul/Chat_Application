import 'package:flutter/material.dart';
import 'package:flutterapp/widgets/confirm_button.dart';
import 'package:flutterapp/widgets/input_field.dart';
import 'package:flutterapp/service/socket.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat';
  final SocketService socketService;
  const ChatScreen({super.key, required this.socketService});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];
  late bool isOwnMessage = false;

  @override
  void initState() {
    super.initState();
    receiveMessage();
  }

  @override
  void dispose() {
    end();
    super.dispose();
  }

  void receiveMessage() {
    widget.socketService.receiveMessageFromServer((onMessageReceived) {
      _messages.add(onMessageReceived);
      isOwnMessage = false;
    });
  }

  void sendMessage() {
    if (_messageController.text.isEmpty) return;
    widget.socketService.sendMessageToServer(_messageController.toString());
    isOwnMessage = true;
  }

  void end() {
    widget.socketService.disconnect(context);
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
                  alignment: isOwnMessage
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
