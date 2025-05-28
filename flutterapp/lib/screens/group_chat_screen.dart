import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutterapp/widgets/confirm_button.dart';
import 'package:flutterapp/service/socket_service.dart';

class GroupChatScreen extends StatefulWidget {
  static const String routeName = '/groupChat';
  const GroupChatScreen({Key? key}) : super(key: key);

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  late final String groupId;
  late final String groupName;
  late final List messages;

  final SocketService socketService = SocketService();
  final TextEditingController _messageController = TextEditingController();

  late VoidCallback socketListener;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final rawArgs = ModalRoute.of(context)!.settings.arguments;

    if (rawArgs is Map) {
      final args = Map<String, dynamic>.from(rawArgs);
      groupId = args['groupId'];
      groupName = args['groupName'];
      messages = args['groupMessages'] ?? [];
    } else {
      throw Exception('Invalid arguments passed to GroupChatScreen');
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

  void sendMessage(String message) {
    if (message.isNotEmpty) {
      log('Sending message: $message to group: $groupId');
      socketService.sendGroupMessage(groupId, message);
    }
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          groupName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msgMap = messages[index] as Map<String, dynamic>;
                final senderId = msgMap['senderId'] as String;
                final messageText = msgMap['message'] as String;

                final bool isMe = senderId == 'me';

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    margin: EdgeInsets.only(
                      top: 4,
                      bottom: 4,
                      left: isMe ? 40 : 8,
                      right: isMe ? 8 : 40,
                    ),
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ConfirmButton(
                    onPressed: () {
                      sendMessage(_messageController.text);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
