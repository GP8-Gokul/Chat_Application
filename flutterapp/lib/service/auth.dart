import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutterapp/service/socket_service.dart';
import 'dart:developer';

class AuthService {
  final String baseUrl = "http://10.0.2.2:3000";

  Future<String> signup(String username, String email, String password) async {
    final url = Uri.parse("$baseUrl/signup");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"username": username, "email": email, "password": password}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      final socketService = SocketService();
      socketService.connect(email);
      return "Registered Successfully!";
    } else {
      return data["message"] ?? "Signup failed";
    }
  }

  Future<String> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");
    log("Logging in  email: $email");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    log("Response status: ${response.statusCode}");
    final data = jsonDecode(response.body);
    log(data["message"] ?? "No message in response");
    if (response.statusCode == 200) {
      return "Login Successful! Username: ${data["username"]}";
    } else {
      return data["message"] ?? "Login failed";
    }
  }
}
