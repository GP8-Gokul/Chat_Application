import 'package:flutter/material.dart';

class NameInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final String? hintText;

  const NameInputField(
      {super.key, required this.controller, this.errorText, this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        prefixIcon: const Icon(Icons.person, color: Color(0xFF4A148C)),
        errorText: errorText,
      ),
    );
  }
}
