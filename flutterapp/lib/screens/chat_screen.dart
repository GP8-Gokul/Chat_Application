import 'package:flutter/material.dart';
import 'package:flutterapp/service/socket_service.dart';
import 'dart:developer';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final String userId;
  late final String userName;

  final SocketService socketService = SocketService();
  final TextEditingController _messageController = TextEditingController();

  late VoidCallback socketListener;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final rawArgs = ModalRoute.of(context)!.settings.arguments;

    if (rawArgs is Map) {
      final args = Map<String, dynamic>.from(rawArgs);
      userId = args['userId'];
      userName = args['userName'];
    } else {
      throw Exception('Invalid arguments passed to ChatScreen');
    }
  }

  @override
  void initState() {
    super.initState();
    socketListener = () => setState(() {});
    socketService.addListener(socketListener);
  }

  @override
  void dispose() {
    socketService.removeListener(socketListener);
    _messageController.dispose();
    super.dispose();
  }

  void sendMessage() {
    final messageText = _messageController.text.trim();
    log('Sending message: $messageText to user: $userId');
    if (messageText.isNotEmpty) {
      socketService.sendMessage(userId, messageText);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages =
        socketService.allUsers[userId]['messages'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(userName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msgMap = messages[index] as Map<String, dynamic>;
                final senderId = msgMap['senderId'] as String;
                final messageText = msgMap['message'] as String;

                final bool isMe = senderId != userId;

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blueAccent : Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: Radius.circular(isMe ? 12 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 12),
                      ),
                    ),
                    child: Text(
                      messageText.toString(),
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      sendMessage();
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
