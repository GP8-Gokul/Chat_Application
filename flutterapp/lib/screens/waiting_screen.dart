import 'package:flutter/material.dart';
import 'package:flutterapp/screens/chat_screen.dart';
import 'package:flutterapp/service/socket.dart';
import '../widgets/background_container.dart';

class WaitingScreen extends StatefulWidget {
  static const String routeName = '/waiting';
  final SocketService socketService;

  const WaitingScreen({super.key, required this.socketService});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  String statusMessage = "Please wait...";

  @override
  void initState() {
    super.initState();
    widget.socketService.onClientCount((count) {
      if (count == '2') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(socketService: widget.socketService),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    end();
    super.dispose();
  }

  void checkServer() {
    widget.socketService.onClientCount((count) {
      if (count == '2') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(socketService: widget.socketService),
          ),
        );
      }
    });
  }

  void end() {
    widget.socketService.disconnect(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                statusMessage,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
