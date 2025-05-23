import 'package:flutter/material.dart';
import 'package:flutterapp/screens/main_screen.dart';
import 'package:flutterapp/widgets/background_Container.dart';
import 'package:flutterapp/widgets/navigation_button.dart';
import 'package:flutterapp/widgets/name_input_field.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _errorText;

  void navigateToMainScreen() {
    if (_nameController.text.isEmpty) {
      setState(() {
        _errorText = "Name cannot be empty!";
      });
      return;
    }
    Navigator.pushNamed(context, MainScreen.routeName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enter your name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                NameInputField(
                  controller: _nameController,
                  errorText: _errorText,
                  hintText: 'Enter your name',
                ),
                const SizedBox(height: 20),
                NavigationButton(onPressed: navigateToMainScreen),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
