import 'package:shared_preferences/shared_preferences.dart';

final String backendUrl = "https://api.cobratopups.com";
// final String backendUrl = "https://cae13c4bcbb8.ngrok-free.app";



Future<void> saveTokenToLocalStorage(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);
}


