import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/order_model.dart';
import 'base_url.dart';
import 'shared_local_storage.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> orders = [];
  bool isLoading = false;
  bool hasError = false;

  void printLong(Object data) {
    final text = data.toString();
    const chunk = 800;
    for (int i = 0; i < text.length; i += chunk) {
      print(text.substring(i, i + chunk > text.length ? text.length : i + chunk));
    }
  }


  Future<void> fetchOrders() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      final token = await getTokenFromLocalStorage();

      if (token == null) {
        print("⚠️ টোকেন পাওয়া যায়নি");
        hasError = true;
        isLoading = false;
        notifyListeners();
        return;
      }

      final url = Uri.parse("$backendUrl/api/v1/myorder");
      print("📡 Order API: $url");

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> dataList = jsonResponse["data"]["data"];

        orders = dataList.map((item) => OrderModel.fromJson(item)).toList();
        print("✅ Order লোড সফল! ${orders.length} টি ডাটা পাওয়া গেছে");
        // 🔥 Raw response print (Full)
        print("📌 Full JSON Response:");
        // printLong(jsonResponse);
        printLong(dataList.first);
        print("📌 📌 Full JSON Response end:");


        // 🔥 Only dataList print (Full)

        // print("📌 DataList:");
        // printLong(dataList);

      } else {
        hasError = true;
        print("❌ সার্ভার ত্রুটি: ${response.statusCode}");
      }
    } catch (e) {
      hasError = true;
      print("🚫 ফেচ ব্যর্থ: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshOrders() async {
    orders = [];
    await fetchOrders();
  }
}
