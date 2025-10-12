import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/topup_product_model.dart';
import 'base_url.dart' show backendUrl;

class Topup_Products_Provider with ChangeNotifier {
  List<Topup_Product_Model> _products = [];
  bool _isLoading = false;

  List<Topup_Product_Model> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchTopupProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse("$backendUrl/api/v1/topupproduct"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['data'];

        _products = results.map((item) => Topup_Product_Model.fromJson(item)).toList();
      }
    } catch (e) {
      print("Error fetching topup products: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
