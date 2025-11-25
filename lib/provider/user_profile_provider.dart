import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile_model.dart';
import 'base_url.dart';
import 'shared_local_storage.dart';
import '../app_flavor.dart';


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
      final token = await getTokenFromLocalStorage();

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
        try {
          final prefs = await SharedPreferences.getInstance();

          // 🔥 CORRECTION: jsonResponse থেকে সঠিকভাবে data access করুন
          if (jsonResponse['data'] != null && jsonResponse['data']['username'] != null) {
            await prefs.setString('userName_${AppConfig.instance.flavor.name}', jsonResponse['data']['username']);
            print("✅ SharedPreferences-এ userName সেভ করা হয়েছে: ${jsonResponse['data']['username']}");
          }

          if (jsonResponse['data'] != null && jsonResponse['data']['avatar'] != null) {
            await prefs.setString('userPhoto_${AppConfig.instance.flavor.name}', jsonResponse['data']['avatar']);
            print("✅ SharedPreferences-এ userPhoto সেভ করা হয়েছে: ${jsonResponse['data']['avatar']}");
          }

          // 🔥 Alternative: profileData object ব্যবহার করে (better approach)
          if (profileData?.data?.username != null) {
            await prefs.setString('userName_${AppConfig.instance.flavor.name}', profileData!.data!.username!);
            print("✅ SharedPreferences-এ userName সেভ করা হয়েছে: ${profileData!.data!.username!}");
          }

          if (profileData?.data?.avatar != null) {
            await prefs.setString('userPhoto_${AppConfig.instance.flavor.name}', profileData!.data!.avatar!);
            print("✅ SharedPreferences-এ userPhoto সেভ করা হয়েছে: ${profileData!.data!.avatar!}");
          }

          print("🎉 SharedPreferences-এ সব ডেটা সফলভাবে সেভ করা হয়েছে!");

        } catch (e) {
          print("❌ SharedPreferences-এ সেভ করতে সমস্যা: $e");
        }
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
