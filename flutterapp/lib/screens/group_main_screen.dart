import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutterapp/service/socket_service.dart';

class GroupMainScreen extends StatefulWidget {
  static const String routeName = '/groupMain';
  const GroupMainScreen({Key? key}) : super(key: key);

  @override
  _GroupMainScreenState createState() => _GroupMainScreenState();
}

class _GroupMainScreenState extends State<GroupMainScreen> {
  final SocketService socketService = SocketService();

  void createGroup() {
    log("Create Group button pressed");
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
                  padding: EdgeInsets.all(20),
                ),
                child: Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
