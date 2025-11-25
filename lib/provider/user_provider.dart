import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_flavor.dart';

class UserProvider extends ChangeNotifier {
  String? name;
  String? email;
  String? photoUrl;

  bool get isLoggedIn => name != null;

  String _getUserNameKey() => 'userName_${AppConfig.instance.flavor.name}';
  String _getUserEmailKey() => 'userEmail_${AppConfig.instance.flavor.name}';
  String _getUserPhotoKey() => 'userPhoto_${AppConfig.instance.flavor.name}';

  void setUser(String n, String e, String p) {
    name = n;
    email = e;
    photoUrl = p;
    notifyListeners();
    _saveToPrefs();
  }

  void clearUser() {
    name = null;
    email = null;
    photoUrl = null;
    notifyListeners();
  }

  Future<void> logout() async {
    clearUser();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_getUserNameKey());
    await prefs.remove(_getUserEmailKey());
    await prefs.remove(_getUserPhotoKey());
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString(_getUserNameKey());
    email = prefs.getString(_getUserEmailKey());
    photoUrl = prefs.getString(_getUserPhotoKey());
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_getUserNameKey(), name ?? '');
    await prefs.setString(_getUserEmailKey(), email ?? '');
    await prefs.setString(_getUserPhotoKey(), photoUrl ?? '');

    String savedName = prefs.getString(_getUserNameKey()) ?? 'No Name';
    String savedEmail = prefs.getString(_getUserEmailKey()) ?? 'No Email';
    String savedPhoto = prefs.getString(_getUserPhotoKey()) ?? 'No Photo';

    print('✅ Saved in local shared preferences after authentication ✅  ');
    print('Saved User Name: $savedName');
    print('Saved User Email: $savedEmail');
    print('Saved User Photo: $savedPhoto');
    print('----------------------------------------------------');
  }
}
