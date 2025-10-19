import 'package:shared_preferences/shared_preferences.dart';

final String backendUrl = "https://efd5f3fc2602.ngrok-free.app";



Future<void> saveTokenToLocalStorage(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);
}


