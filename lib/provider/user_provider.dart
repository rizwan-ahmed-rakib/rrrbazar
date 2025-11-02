import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? name;
  String? email;
  String? photoUrl;

  bool get isLoggedIn => name != null;

  /// ✅ ইউজার লগইন হলে সেট করো
  void setUser(String n, String e, String p) {
    name = n;
    email = e;
    photoUrl = p;
    notifyListeners();
    _saveToPrefs();
  }

  /// ✅ লগআউট করলে মুছে ফেলো
  Future<void> logout() async {
    name = null;
    email = null;
    photoUrl = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// ✅ SharedPreferences থেকে ইউজার রিস্টোর করো
  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString('userName');
    email = prefs.getString('userEmail');
    photoUrl = prefs.getString('userPhoto');
    notifyListeners();
  }

  /// ✅ SharedPreferences এ ইউজার সেভ করো
  /// ✅ SharedPreferences এ ইউজার সেভ করো
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name ?? '');
    await prefs.setString('userEmail', email ?? '');
    await prefs.setString('userPhoto', photoUrl ?? '');

    // সেভ করার পর প্রিন্ট করে দেখা
    String savedName = prefs.getString('userName') ?? 'No Name';
    String savedEmail = prefs.getString('userEmail') ?? 'No Email';
    String savedPhoto = prefs.getString('userPhoto') ?? 'No Photo';

    print('✅ Saved in local shared preferences after authentication ✅  ');
    print('Saved User Name: $savedName');
    print('Saved User Email: $savedEmail');
    print('Saved User Photo: $savedPhoto');
    print('----------------------------------------------------');
  }
}
