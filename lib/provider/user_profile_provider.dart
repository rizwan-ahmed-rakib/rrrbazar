import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile_model.dart';
import 'base_url.dart';

class UserProfileProvider extends ChangeNotifier {
  userProfileData? profileData;
  bool isLoading = false;
  bool hasError = false;

  /// ✅ একবারই ফেচ করবে, যদি profileData আগে না থাকে
  Future<void> fetchUserProfile() async {
    if (profileData != null) return;

    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        hasError = true;
        isLoading = false;
        print("⚠️ টোকেন পাওয়া যায়নি। ইউজার হয়তো লগইন করেনি।");
        notifyListeners();
        return;
      }

      final url = Uri.parse("$backendUrl/api/v1/user/profile");
      print("📡 ইউজার প্রোফাইল ফেচ করা হচ্ছে: $url");

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        profileData = userProfileData.fromJson(jsonResponse);
        print("✅ প্রোফাইল লোড সফল!");
        print("✅ প্রোফাইল লোড সফল! ${jsonResponse}");
      } else {
        hasError = true;
        print("❌ সার্ভার ত্রুটি: ${response.statusCode}");
      }
    } catch (e) {
      hasError = true;
      print("🚫 প্রোফাইল ফেচ ব্যর্থ: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  /// 🔄 প্রোফাইল রিফ্রেশ করতে চাইলে
  Future<void> refreshProfile() async {
    profileData = null;
    await fetchUserProfile();
  }
}
