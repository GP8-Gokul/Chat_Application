import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterapp/service/socket_service.dart';
import 'package:flutterapp/widgets/input_field.dart';
import 'package:flutterapp/widgets/confirm_button.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _errorMessage;
  final SocketService socketService = SocketService();

  void toggleScreen() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void login() async {
    final result = await socketService.login(
      _emailController.text,
      _passwordController.text,
    );
    if (result == 200) {
      socketService.connect(_emailController.text);
      sleep(const Duration(seconds: 3));
      Navigator.pushReplacementNamed(context, '/chat');
    } else if (result == 401) {
      setState(() {
        _errorMessage = "Invalid email or password";
        _passwordController.clear();
      });
    } else if (result == 500) {
      setState(() {
        _errorMessage = "Login failed. Please try again.";
      });
    }
  }

  void signUp() async {
    final String validationMessage = validatePassword(
        _passwordController.text, _confirmPasswordController.text);
    if (validationMessage.isNotEmpty) {
      setState(() {
        _errorMessage = validationMessage;
        _passwordController.clear();
        _confirmPasswordController.clear();
      });
      return;
    } else {
      final result = await socketService.signup(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      );
      if (result == 201) {
        Navigator.pushReplacementNamed(context, '/auth');
      } else if (result == 400) {
        setState(() {
          _errorMessage = "Email already exists, try logging in";
        });
      } else if (result == 500) {
        setState(() {
          _errorMessage = "Signup failed. Please try again.";
        });
      }
    }
  }

  String validatePassword(String password, String confirmPassword) {
    if (password.length < 6) {
      return "Password must be at least 6 characters long";
    }
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$').hasMatch(password)) {
      return "Password must contain both letters and numbers";
    }
    if (password != confirmPassword) {
      return "Passwords do not match";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
            child: isLogin ? _buildLoginScreen() : _buildSignUpScreen(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginScreen() {
    return Center(
      key: const ValueKey(1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputField(controller: _emailController, hintText: "Email"),
            const SizedBox(height: 16),
            InputField(
                controller: _passwordController,
                hintText: "Password",
                obscureText: true),
            const SizedBox(height: 24),
            ConfirmButton(onPressed: login),
            const SizedBox(height: 10),
            TextButton(
                onPressed: toggleScreen,
                child: const Text("Don't have an account? Sign up"))
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpScreen() {
    return Center(
      key: const ValueKey(2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputField(controller: _usernameController, hintText: "Username"),
            const SizedBox(height: 16),
            InputField(controller: _emailController, hintText: "Email"),
            const SizedBox(height: 16),
            InputField(
                controller: _passwordController,
                hintText: "Password",
                obscureText: true),
            const SizedBox(height: 16),
            InputField(
                controller: _confirmPasswordController,
                hintText: "Confirm Password",
                obscureText: true),
            const SizedBox(height: 8),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 24),
            ConfirmButton(onPressed: signUp),
            const SizedBox(height: 10),
            TextButton(
                onPressed: toggleScreen,
                child: const Text("Already have an account? Login"))
          ],
        ),
      ),
    );
  }
}
