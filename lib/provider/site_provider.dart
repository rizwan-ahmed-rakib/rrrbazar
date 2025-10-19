// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import 'base_url.dart' show backendUrl;
//
//
// class SiteProvider extends ChangeNotifier {
//
//   Map<String, dynamic>? siteData;
//   bool isLoading = false;
//   bool hasError = false;
//
//   /// ✅ একবার data ফেচ করে রাখবে, আবার পেজ পরিবর্তন করলে আবার লোড করবে না
//   Future<void> fetchSiteData() async {
//     if (siteData != null) return; // আগেই থাকলে পুনরায় ফেচ করবে না
//
//     isLoading = true;
//     hasError = false;
//     notifyListeners();
//
//     String apiUrl = "$backendUrl/api/v1/site";
//
//     try {
//       final response = await http.get(Uri.parse(apiUrl),
//           headers: {
//             // "Accept": "application/json",
//             // নিচেরটা ঐচ্ছিক, যদি backend Origin চায়
//             "Origin": "com.example.rrrbazar.com", // বা তোমার প্যাকেজ নাম
//             // "Origin": "http://localhost:3000", // বা তোমার প্যাকেজ নাম
//           },
//           );
//
//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         siteData = jsonResponse["data"];
//         print("✅ সাইট ডেটা পাওয়া গেছে: $siteData");
//       } else {
//         hasError = true;
//         print("❌ সার্ভার ত্রুটি: ${response.statusCode}");
//       }
//     } catch (e) {
//       hasError = true;
//       print("⚠️ ডেটা আনতে সমস্যা হয়েছে: $e");
//     }
//
//     isLoading = false;
//     notifyListeners();
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/site_model.dart';
import 'base_url.dart' show backendUrl;

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
          "Origin": "com.example.rrrbazar.com",
          // "Origin": "http://localhost:3000", // বা তোমার প্যাকেজ নাম

        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        siteData = SiteModel.fromJson(jsonResponse["data"]);
        print("✅ সাইট ডেটা পাওয়া গেছে: ${siteData}");
        print(jsonEncode(jsonResponse["data"]));
      } else {
        hasError = true;
        print("❌ সার্ভার ত্রুটি: ${response.statusCode}");
      }
    } catch (e) {
      hasError = true;
      print("⚠️ ডেটা আনতে সমস্যা হয়েছে: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
