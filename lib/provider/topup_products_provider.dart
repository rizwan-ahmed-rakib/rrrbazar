import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/topup_product_model.dart';
import 'base_url.dart';

class Topup_Products_Provider with ChangeNotifier {
  List<Data> _products = [];
  bool _isLoading = false;
  bool hasFetched = false; // ✅ নতুন flag


  List<Data> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchTopupProducts() async {

    if (hasFetched) return; // ✅ একবার ফেচ হলে আর করবে না

    _isLoading = true;
    notifyListeners();

    try {
      print("🟡 Fetching products from: $backendUrl/api/v1/topupproduct");

      final response = await http.get(Uri.parse("$backendUrl/api/v1/topupproduct"),
        headers: {
          "Accept": "application/json",
          // নিচেরটা ঐচ্ছিক, যদি backend Origin চায়
          // "Origin": "com.example.rrrbazar.com", // বা তোমার প্যাকেজ নাম
          // "Origin": backendUrl, // বা তোমার প্যাকেজ নাম
          // "Origin": "https://cobratopups.com", // বা তোমার প্যাকেজ নাম
          "Origin": "https://zsshopbd.com", // বা তোমার প্যাকেজ নাম
          // "Origin": "https://bdgamebazar.com", // বা তোমার প্যাকেজ নাম
        },
      );

      print("🟡 Response status for products: ${response.statusCode}");
      print("🟡 Response body products: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final topupProduct = Topup_Product_Model.fromJson(data);
        _products = topupProduct.data ?? [];

        print("🟡 Loaded products ${_products.length} products");
        hasFetched = true; // ✅ একবার লোড হয়ে গেলে true করে দিচ্ছি

      } else {
        print("🔴 Failed to load products. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("🔴 Error fetching products: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
