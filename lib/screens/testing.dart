// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../provider/user_profile_provider.dart';
//
// Future<void> _confirmOrder() async {
//   final prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString('auth_token');
//
//   final profileProvider = Provider.of<UserProfileProvider>(
//     context,
//     listen: false,
//   );
//   final profile = profileProvider.profileData?.data;
//   final double walletBalance = _convertToDouble(profile?.wallet);
//   final ingamepassword = "IDCODE";
//   final securitycode = "IDCODE";
//   int payment_method = selectedPayment == "RRR Bazar Wallet" ? 1 : 2;
//   String playerId = playerIdController.text;
//
//   if (playerIdController.text.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("❌ Player ID দিন!")));
//     return;
//   }
//
//   if (selectedPackIndex == null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("❌ Recharge Pack Select করুন!")),
//     );
//     return;
//   }
//
//   print("✅✅✅ Confirm order function is clicked ✅✅");
//
//   showDialog(
//     context: context,
//     useRootNavigator: true,
//     builder: (context) {
//       bool isSubmitting = false; // 🔹 Local state for dialog
//
//       return StatefulBuilder(
//         builder: (context, setDialogState) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             title: const Text(
//               "Confirm Order",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             content: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Your current wallet is ৳${walletBalance.toStringAsFixed(0)}",
//                     style: const TextStyle(fontSize: 15, color: Colors.black87),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     "You need ৳${selectedPackagePrice} to purchase this product.",
//                     style: const TextStyle(fontSize: 15, color: Colors.black87),
//                   ),
//                 ],
//               ),
//             ),
//             actionsPadding: const EdgeInsets.symmetric(
//               horizontal: 15,
//               vertical: 10,
//             ),
//             actionsAlignment: MainAxisAlignment.start,
//             actions: [
//               ElevatedButton(
//                 onPressed: isSubmitting
//                     ? null
//                     : () async {
//                   print("🔄 Starting order submission...");
//
//                   setDialogState(() => isSubmitting = true);
//
//                   // ✅ ব্যালেন্স চেক শুধু Wallet-এর জন্য
//                   if (selectedPayment == "RRR Bazar Wallet" &&
//                       walletBalance < (selectedPackagePrice ?? 0)) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                           "❌ পর্যাপ্ত ব্যালেন্স নেই! আপনার ওয়ালেটে ৳${walletBalance.toStringAsFixed(0)} আছে।",
//                         ),
//                       ),
//                     );
//                     setDialogState(() => isSubmitting = false);
//                     return;
//                   }
//
//                   // ✅ এখানে আসল Order API চালু হবে
//                   final url = Uri.parse("${backendUrl}/api/v1/packageorder");
//
//                   final body = {
//                     "topup_package_id": selectedPackageId,
//                     "product_id": widget.id,
//                     "name": selectedPackageName,
//                     "playerid": playerId,
//                     "ingamepassword": ingamepassword,
//                     "securitycode": securitycode,
//                     "payment_method": payment_method,
//                   };
//
//                   print("📦 Sending Order to $url");
//                   print("📤 Request Body: $body");
//
//                   try {
//                     final response = await http.post(
//                       url,
//                       headers: {
//                         "Content-Type": "application/json",
//                         "Authorization": "Bearer $token",
//                       },
//                       body: jsonEncode(body),
//                     );
//
//                     if (response.statusCode == 200 || response.statusCode == 201) {
//                       final data = jsonDecode(response.body);
//                       final paymentUrl = data['data']?['payment_url'];
//
//                       if (paymentUrl != null && selectedPayment == "Auto Payment") {
//                         print("🌐 Redirecting to Payment URL: $paymentUrl");
//
//                         Navigator.pop(context); // Close dialog first
//
//                         await Future.delayed(const Duration(milliseconds: 100));
//                         if (!mounted) return;
//
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => PaymentWebView(paymentUrl: paymentUrl),
//                           ),
//                         );
//                       } else {
//                         print("✅ API response: ${response.body}");
//
//                         Navigator.pop(context); // Close dialog first
//
//                         // ✅ ProfileProvider ইনিশিয়ালাইজ
//                         final profileProvider = Provider.of<UserProfileProvider>(
//                           context,
//                           listen: false,
//                         );
//                         await profileProvider.refreshProfile();
//
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text("✅ Order Confirmed Successfully!"),
//                             behavior: SnackBarBehavior.floating,
//                             margin: EdgeInsets.only(
//                               top: 20,
//                               left: 10,
//                               right: 10,
//                             ),
//                             backgroundColor: Colors.green,
//                           ),
//                         );
//
//                         // ✅ Redirect to orders page
//                         Future.microtask(() async {
//                           await Future.delayed(const Duration(seconds: 1));
//                           if (context.mounted) {
//                             Navigator.pushReplacementNamed(
//                               context,
//                               "/myOrdersPage",
//                             );
//                           }
//                         });
//                       }
//                     } else {
//                       print("❌ API Error: ${response.body}");
//                       setDialogState(() => isSubmitting = false);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text("⚠️ Order Failed (${response.statusCode})"),
//                         ),
//                       );
//                     }
//                   } catch (e) {
//                     print("❌ Exception: $e");
//                     setDialogState(() => isSubmitting = false);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text("🚫 Network Error! আবার চেষ্টা করুন"),
//                       ),
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.lightBlue,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 12,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                 ),
//                 child: isSubmitting
//                     ? const SizedBox(
//                   height: 20,
//                   width: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: Colors.white,
//                   ),
//                 )
//                     : const Text(
//                   "Confirm Order",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15,
//                   ),
//                 ),
//               ),
//               TextButton(
//                 onPressed: isSubmitting ? null : () => Navigator.pop(context),
//                 style: TextButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 12,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                 ),
//                 child: const Text(
//                   "Cancel",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15,
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }