import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';
import 'base_url.dart';

class UserTransactionProvider extends ChangeNotifier {
  List<UserTransaction> transactions = [];
  bool isLoading = false;
  bool hasError = false;

  Future<void> fetchTransactions() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        print("⚠️ টোকেন পাওয়া যায়নি");
        hasError = true;
        isLoading = false;
        notifyListeners();
        return;
      }

      final url = Uri.parse("$backendUrl/api/v1/usertransaction");
      print("📡 Transaction API: $url");

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

        transactions = dataList
            .map((item) => UserTransaction.fromJson(item))
            .toList();

        print("✅ Transaction লোড সফল! ${transactions.length} টি ডাটা পাওয়া গেছে");
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

  /// Optional: রিফ্রেশের জন্য
  Future<void> refreshTransactions() async {
    transactions = [];
    await fetchTransactions();
  }
}
