import 'package:shared_preferences/shared_preferences.dart';
import '../app_flavor.dart';

String _getAuthTokenKey() {
  final flavor = AppConfig.instance.flavor.name;
  return 'auth_token_$flavor';
}

Future<void> saveTokenToLocalStorage(String token) async {
  final prefs = await SharedPreferences.getInstance();
  // 👇 Debug print
  print("👇Saving token using key: ${_getAuthTokenKey()}");
  await prefs.setString(_getAuthTokenKey(), token);
}

Future<String?> getTokenFromLocalStorage() async {
  final prefs = await SharedPreferences.getInstance();

  // 👇 Debug print
  print("👇👇Getting token using key: ${_getAuthTokenKey()}");

  return prefs.getString(_getAuthTokenKey());
}

Future<void> removeTokenFromLocalStorage() async {
  final prefs = await SharedPreferences.getInstance();
  // 👇 Debug print
  print("👇👇👇Removing token using key: ${_getAuthTokenKey()}");

  await prefs.remove(_getAuthTokenKey());
}
