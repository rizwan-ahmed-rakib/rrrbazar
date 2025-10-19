import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/topup_banner_model.dart'; // তোমার model path অনুযায়ী adjust করো
import 'base_url.dart' show backendUrl;





class TopupBannerProvider with ChangeNotifier {
  List<Data> _banners = [];
  bool _isLoading = false;

  List<Data> get banners => _banners;
  bool get isLoading => _isLoading;

  Future<void> fetchBanners() async {
    _isLoading = true;
    notifyListeners();

    try {
      print("🔵 Fetching banners from: $backendUrl/api/v1/banner");

      // final response = await http.get(Uri.parse("$backendUrl/api/v1/banner"));

      final response = await http.get(
        Uri.parse("$backendUrl/api/v1/banner"),
        // headers: {
        //   "Accept": "application/json",
        //   // নিচেরটা ঐচ্ছিক, যদি backend Origin চায়
        //   "Origin": "com.example.rrrbazar.com", // বা তোমার প্যাকেজ নাম
        // },
      );


      print("🔵 Response status banner: ${response.statusCode}");
      print("🔵 Response body banner: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final topupBanner = topup_banner_model.fromJson(data);
        _banners = topupBanner.data ?? [];

        print("🔵 Loaded banners ${_banners.length} banners");
      } else {
        print("🔴 Failed to load banners. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("🔴 Error fetching banners: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
