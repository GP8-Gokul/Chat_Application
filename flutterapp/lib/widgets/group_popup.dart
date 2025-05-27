import 'package:flutter/material.dart';
import 'confirm_button.dart';

class GroupPopup extends StatefulWidget {
  const GroupPopup({super.key});

  @override
  State<GroupPopup> createState() => _GroupPopupState();
}

class _GroupPopupState extends State<GroupPopup> {
  final TextEditingController _groupNameController = TextEditingController();

  void confirmGroup() {
    if (_groupNameController.text.isNotEmpty) {
      Navigator.of(context).pop(_groupNameController.text); // Pass data back
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Enter Group Name"),
      content: TextField(
        controller: _groupNameController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Group Name",
        ),
      ),
      actions: [
        ConfirmButton(onPressed: confirmGroup),
      ],
    );
  }
}
