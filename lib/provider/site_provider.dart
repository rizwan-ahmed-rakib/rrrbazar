import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/site_model.dart';
import 'base_url.dart';

class SiteProvider extends ChangeNotifier {
  SiteModel? siteData;
  bool isLoading = false;
  bool hasError = false;

  /// ✅ একবারই ফেচ করবে
  Future<void> fetchSiteData() async {
    if (siteData != null) return;

    isLoading = true;
    hasError = false;
    notifyListeners();

    String apiUrl = "$backendUrl/api/v1/site";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          // "Origin": "com.example.rrrbazar.com",
          // "Origin": "https://rrrbazar.com",
          // "Origin": "https://cobratopups.com",
          // "Origin": "https://bdgamebazar.com", // বা তোমার প্যাকেজ নাম
          // "Origin": backendUrl,
          // "Origin": "http://localhost:3000", // বা তোমার প্যাকেজ নাম

          //////////////////dynamic origin form base_url.dart //////////////////////////

          "Origin": ClientOrigin,

        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        siteData = SiteModel.fromJson(jsonResponse["data"]);
        print("✅ সাইট ডেটা পাওয়া গেছে: ${siteData}");
        print(jsonEncode(jsonResponse["data"]));
      } else {
        hasError = true;
        print("❌ site data সার্ভার ত্রুটি: ${response.statusCode}");
      }
    } catch (e) {
      hasError = true;
      print("⚠️ ডেটা আনতে সমস্যা হয়েছে: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshSiteData() async {
    siteData = null;     // আগের ডেটা মুছে দিচ্ছি
    hasError = false;    // পুরাতন error reset
    notifyListeners();   // UI কে জানাচ্ছি

    await fetchSiteData();  // আবার নতুন ডেটা আনছি
  }


}
