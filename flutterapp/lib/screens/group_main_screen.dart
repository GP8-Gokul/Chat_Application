import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/group_chat_screen.dart';
import 'package:flutterapp/service/socket_service.dart';
import '../widgets/group_popup.dart';

class GroupMainScreen extends StatefulWidget {
  static const String routeName = '/groupMain';
  const GroupMainScreen({super.key});

  @override
  State<GroupMainScreen> createState() => _GroupMainScreenState();
}

class _GroupMainScreenState extends State<GroupMainScreen> {
  final SocketService socketService = SocketService();

  late VoidCallback groupSocketListener;

  @override
  void initState() {
    super.initState();
    socketService.loadGroups();
    groupSocketListener = () => setState(() {});
    socketService.addListener(groupSocketListener);
  }

  void createGroup() async {
    log("Create Group button pressed");
    String groupName = await showDialog(
      context: context,
      builder: (context) => const GroupPopup(),
    );
    log("Group name received: $groupName");
    socketService.createGroup(groupName);
  }

  void joinOrEnterGroup(String groupId, Map<String, dynamic>? groupData) {
    socketService.joinGroup(groupId);
    Navigator.pushNamed(
      context,
      GroupChatScreen.routeName,
      arguments: {
        'groupId': groupId,
        'groupName': groupData?['name'] ?? 'Unknown Group',
        'groupMessages': groupData?['messages'] ?? [],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Group Main Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 75,
              width: MediaQuery.of(context).size.width - 40,
              child: ElevatedButton(
                onPressed: createGroup,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              itemCount: socketService.allGroups.length,
              itemBuilder: (context, index) {
                final groupId = socketService.allGroups.keys.elementAt(index);
                final groupData = socketService.allGroups[groupId];
                return ListTile(
                  title: Text(groupData?['name'] ?? 'Unknown Group'),
                  subtitle:
                      Text('Members: ${groupData?['members'].length ?? 0}'),
                  onTap: () {
                    joinOrEnterGroup(groupId, groupData);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
