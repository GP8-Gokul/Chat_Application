import 'package:flutter/material.dart';
import 'package:flutterapp/screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        RegisterScreen.routeName: (context) => const RegisterScreen(),
      },
      initialRoute: RegisterScreen.routeName,
    );
  }
}
