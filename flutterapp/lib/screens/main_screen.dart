import 'package:flutter/material.dart';
import 'package:flutterapp/screens/chat_screen.dart';
import 'package:flutterapp/service/socket_service.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = '/main';
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final SocketService socketService = SocketService();

  late VoidCallback socketListener;

  @override
  void initState() {
    super.initState();
    socketService.updateUserList();
    socketListener = () => setState(() {});
    socketService.addListener(socketListener);
  }

  @override
  void dispose() {
    socketService.removeListener(socketListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allUsers = socketService.allUsers;
    final myId = socketService.socket.id;

    return Scaffold(
      appBar: AppBar(title: const Text('Users List')),
      body: ListView(
        children:
            allUsers.entries.where((entry) => entry.key != myId).map((entry) {
          final userId = entry.key;
          final userData = entry.value;
          return ListTile(
            title: Text(userData['name']),
            subtitle: Text('ID: $userId'),
            onTap: () {
              Navigator.pushNamed(
                context,
                ChatScreen.routeName,
                arguments: {
                  'userId': userId,
                  'userName': userData['name'],
                },
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
