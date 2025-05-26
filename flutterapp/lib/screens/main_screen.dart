import 'package:flutter/material.dart';
import 'package:flutterapp/service/socket_service.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = '/main';
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final SocketService socketService = SocketService();

  @override
  void initState() {
    super.initState();
    socketService.updateUserList();
    socketService.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    socketService.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allUsers = socketService.allUsers;
    return Scaffold(
      appBar: AppBar(title: const Text('Users List')),
      body: ListView(
        children: allUsers.entries.map((entry) {
          final userId = entry.key;
          final userData = entry.value;
          return ListTile(
            title: Text(userData['name']),
            subtitle: Text('ID: $userId'),
          );
        }).toList(),
      ),
    );
  }
}
