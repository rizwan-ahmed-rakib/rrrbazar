import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/topup_product_model.dart';
import 'base_url.dart' show backendUrl;

// class Topup_Products_Provider with ChangeNotifier {
//   List<Topup_Product_Model> _products = [];
//   bool _isLoading = false;
//
//   List<Topup_Product_Model> get products => _products;
//   bool get isLoading => _isLoading;
//
//   Future<void> fetchTopupProducts() async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       final response = await http.get(Uri.parse("$backendUrl/api/v1/topupproduct"));
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final List<dynamic> results = data['data'];
//
//         _products = results.map((item) => Topup_Product_Model.fromJson(item)).toList();
//       }
//     } catch (e) {
//       print("Error fetching topup products: $e");
//     }
//
//     _isLoading = false;
//     notifyListeners();
//   }
// }




// topup_products_provider.dart
// class Topup_Products_Provider with ChangeNotifier {
//   List<Data> _products = [];
//   bool _isLoading = false;
//
//   List<Data> get products => _products;
//   bool get isLoading => _isLoading;
//
//   Future<void> fetchTopupProducts() async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       final response = await http.get(Uri.parse("$backendUrl/api/v1/topupproduct"));
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final topupProduct = Topup_Product_Model.fromJson(data);
//         _products = topupProduct.data ?? [];
//       }
//     } catch (e) {
//       print("Error fetching topup products: $e");
//     }
//
//     _isLoading = false;
//     notifyListeners();
//   }
// }



class Topup_Products_Provider with ChangeNotifier {
  List<Data> _products = [];
  bool _isLoading = false;

  List<Data> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchTopupProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      print("🟡 Fetching products from: $backendUrl/api/v1/topupproduct");

      final response = await http.get(Uri.parse("$backendUrl/api/v1/topupproduct"),
        // headers: {
        //   "Accept": "application/json",
        //   // নিচেরটা ঐচ্ছিক, যদি backend Origin চায়
        //   "Origin": "com.example.rrrbazar.com", // বা তোমার প্যাকেজ নাম
        // },
      );

      print("🟡 Response status for products: ${response.statusCode}");
      print("🟡 Response body products: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final topupProduct = Topup_Product_Model.fromJson(data);
        _products = topupProduct.data ?? [];

        print("🟡 Loaded products ${_products.length} products");
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
