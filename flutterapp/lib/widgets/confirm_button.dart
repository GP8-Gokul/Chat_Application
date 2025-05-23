import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ConfirmButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      width: 58,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4,
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF4A148C),
        ),
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
