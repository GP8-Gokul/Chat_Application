import 'package:flutter/material.dart';
import 'package:flutterapp/screens/auth_screen.dart';
import 'package:flutterapp/screens/chat_screen.dart';
import 'package:flutterapp/screens/group_chat_screen.dart';
import 'package:flutterapp/screens/group_main_screen.dart';
import 'package:flutterapp/screens/login_screen.dart';
import 'package:flutterapp/screens/main_screen.dart';
import 'package:flutterapp/screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        MainScreen.routeName: (context) => const MainScreen(),
        ChatScreen.routeName: (context) => const ChatScreen(),
        GroupMainScreen.routeName: (context) => const GroupMainScreen(),
        GroupChatScreen.routeName: (context) => const GroupChatScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        AuthScreen.routeName: (context) => const AuthScreen(),
      },
      initialRoute: AuthScreen.routeName,
    );
  }
}
