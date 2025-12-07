import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../app_flavor.dart';
import '../provider/base_url.dart' show ClientOrigin, backendUrl;
import '../provider/shared_local_storage.dart';
import '../provider/site_provider.dart';
import '../provider/user_profile_provider.dart';
import '../provider/user_provider.dart';
import 'addMoneyPage.dart';
import 'custom_app_bar.dart';
import 'customdrawer.dart';
import 'footer.dart';
import 'home_screen.dart';
import 'login.dart';
import 'myorders_page.dart';
import 'payment_webview.dart';
import 'registration_screen.dart';

class OrderSuggestionPage extends StatefulWidget {
  final String image, title, subtitle, description;
  final int id;

  OrderSuggestionPage({
    required this.id,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
  });

  @override
  _OrderSuggestionPageState createState() => _OrderSuggestionPageState();
}

class _OrderSuggestionPageState extends State<OrderSuggestionPage> {
  final TextEditingController playerIdController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  List<dynamic> rechargePacks = [];
  bool isLoading = true;
  final walletName = AppConfig.instance.walletName;

  // String selectedPayment = "RRR Bazar Wallet";
  String selectedPayment = AppConfig.instance.walletName;

  int? selectedPackIndex;
  double? selectedPackagePrice; // nullable কারণ শুরুতে কিছু সিলেক্ট থাকে না

  var selectedPackageName;

  var selectedPackageId;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    fetchRechargePacks();
    Future.microtask(
          () =>
          Provider.of<UserProfileProvider>(
            context,
            listen: false,
          ).fetchUserProfile(),
    );
  }

  Future<void> fetchRechargePacks() async {
    try {
      final url = Uri.parse('${backendUrl}/api/v1/topuppackage/${widget.id}');
      final response = await http.get(url);

      print("📡 Fetching: $url");
      print("🔢 Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print("✅ Full API Response:");
        print(data); // পুরো JSON দেখতে

        // এখন packages লিস্টটা বের করা যাক
        final List<dynamic> packages = data['data']['packages'] ?? [];

        print("📦 Extracted Packages:");
        print(packages);

        setState(() {
          rechargePacks = packages;
          isLoading = false;
        });
      } else {
        print("❌ Failed with status: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e, stackTrace) {
      print("🚨 Error fetching recharge packs: $e");
      print("🔍 StackTrace: $stackTrace");
      setState(() => isLoading = false);
    }
  }

  // --- Add Money Popup (Step 1 + Step 2 একসাথে) ---
  void _showAddMoneyPopup() {
    showDialog(
      context: context,
      builder: (ctx) {
        bool showStep2 = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Center(child: Text("Add Money")),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() => showStep2 = true);
                    },
                    child: Column(
                      children: [
                        Text("Step 1: First Add Money"),
                        Image.asset("assets/add_money.jpg", height: 100),
                        SizedBox(height: 10),
                        Text(
                          "Tap Here to Add Money",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  if (showStep2) ...[
                    Text("Step 2: Enter Amount"),
                    SizedBox(height: 8),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Enter Amount",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        // 🔥 এখানে API Call হবে
                        print("➡️ Add Money Request: ${amountController.text}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "✅ Add Money Request Sent Successfully",
                            ),
                          ),
                        );
                      },
                      child: Text("Confirm Add Money"),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  double _convertToDouble(dynamic value) {
    if (value == null) return 0.0;

    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      // String থেকে number extract করুন
      String numericString = value.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(numericString) ?? 0.0;
    } else {
      return 0.0;
    }
  }

  //////////////////////--main confirm order function--///////////////////////////////////////////

  // Future<void> _confirmOrder() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('auth_token');
  //
  //
  //   final profileProvider = Provider.of<UserProfileProvider>(
  //     context,
  //     listen: false,
  //   );
  //   final profile = profileProvider.profileData?.data;
  //   final double walletBalance = _convertToDouble(
  //     profile?.wallet,
  //   ); // ✅ Dynamic wallet balance
  //   final ingamepassword = "IDCODE"; //confirm order korle pathate hobe
  //   final securitycode = "IDCODE"; //confirm order korle pathate hobe
  //   // ✅ এখন selectedPayment অনুযায়ী payment_method নির্ধারণ
  //   int payment_method = selectedPayment == "RRR Bazar Wallet" ? 1 : 2;
  //   String playerId = playerIdController.text; // 🔹 এখানে Player ID পাওয়া গেলো
  //   // "topup_package_id": 84, **
  //   // "product_id": 16,   ***  ei variable gula ami globally pabo  ja ----
  //   // "name": "Tesst1",***  ---- buildRechargeGrid() e setState diye tule dewa hoyese.
  //
  //   print("🔹 Wallet Balance from Provider: $walletBalance");
  //   print("✅✅✅confirm order function is clicked✅✅");
  //   if (playerIdController.text.isEmpty) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text("❌ Player ID দিন!")));
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
  //   // final selectedPack = rechargePacks[selectedPackIndex!];
  //   // final double price = _convertToDouble(selectedPack["price"]);
  //   //
  //   // setState(() {
  //   //   selectedPackagePrice = price; // local package price take global e pathiye dilam
  //   // });
  //
  //   print("🟢 Selected package price set: $selectedPackagePrice");
  //   // ✅ Popup দেখানো
  //
  //   print("🟢 Showing popup now...");
  //
  //   showDialog(
  //     context: context,
  //     useRootNavigator: true,
  //     builder:
  //         (context) => AlertDialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //
  //       title: const Text(
  //         "Confirm Order",
  //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
  //       ),
  //       content: SingleChildScrollView(
  //         // ✅ overflow fix
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               "Your current wallet is ৳${walletBalance.toStringAsFixed(0)}",
  //               style: const TextStyle(fontSize: 15, color: Colors.black87),
  //             ),
  //             const SizedBox(height: 6),
  //             Text(
  //               "You need ৳${selectedPackagePrice} to purchase this product.",
  //               style: const TextStyle(fontSize: 15, color: Colors.black87),
  //             ),
  //           ],
  //         ),
  //       ),
  //       actionsPadding: const EdgeInsets.symmetric(
  //         horizontal: 15,
  //         vertical: 10,
  //       ),
  //       actionsAlignment: MainAxisAlignment.start,
  //       actions: [
  //         ElevatedButton(
  //
  //
  //           // onPressed: () async {
  //           onPressed: isSubmitting
  //               ? null   // 🔥 Loading থাকলে আর চাপা যাবে না
  //               : () async {
  //             print("at first issubmiting=${isSubmitting}");
  //
  //             setState(() => isSubmitting = true);
  //             print("by click true issubmiting=${isSubmitting}");
  //
  //
  //             // ✅ ব্যালেন্স চেক শুধু Wallet-এর জন্য
  //             if (selectedPayment == "RRR Bazar Wallet" &&
  //                 walletBalance < (selectedPackagePrice ?? 0)) {
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 SnackBar(
  //                   content: Text(
  //                     "❌ পর্যাপ্ত ব্যালেন্স নেই! আপনার ওয়ালেটে ৳${walletBalance.toStringAsFixed(0)} আছে।",
  //                   ),
  //                 ),
  //               );
  //               return;
  //             }
  //
  //             // ✅ এখানে আসল Order API চালু হবে
  //             final url = Uri.parse("${backendUrl}/api/v1/packageorder");
  //
  //             // ✅ ডাটা তৈরি
  //             final body = {
  //               "topup_package_id": selectedPackageId,
  //               "product_id": widget.id,
  //               "name": selectedPackageName,
  //               "playerid": playerId,
  //               "ingamepassword": ingamepassword,
  //               "securitycode": securitycode,
  //               "payment_method": payment_method,
  //               // 1 = Wallet, 2 = Auto Payment
  //             };
  //
  //             print("📦 Sending Order to $url");
  //             print("📤 Request Body: $body");
  //
  //             try {
  //               final response = await http.post(
  //                 url,
  //                 headers: {
  //                   "Content-Type": "application/json",
  //                   "Authorization": "Bearer $token",
  //                 },
  //                 body: jsonEncode(body),
  //               );
  //
  //               // ✅ সফল হলে
  //               if (response.statusCode == 200 ||
  //                   response.statusCode == 201) {
  //                 final data = jsonDecode(response.body);
  //                 final paymentUrl = data['data']?['payment_url'];
  //
  //                 // Navigator.pop(context);
  //
  //                 if (paymentUrl != null &&
  //                     selectedPayment == "Auto Payment") {
  //                   // ✅ Auto Payment এর ক্ষেত্রে Payment WebView খুলবে
  //                   print("🌐 Redirecting to Payment URL: $paymentUrl");
  //
  //                   await Future.delayed(const Duration(milliseconds: 100));
  //                   if (!mounted) return;
  //
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder:
  //                           (_) => PaymentWebView(paymentUrl: paymentUrl),
  //                     ),
  //                   );
  //                 } else {
  //                   print("✅ API response: ${response.body}");
  //
  //                   // ✅ Snackbar স্ক্রিনের উপরে দেখানো
  //                   if (mounted) {
  //                     // ✅ ProfileProvider ইনিশিয়ালাইজ (listen:false কারণ আমরা শুধু কল করব)
  //                     final profileProvider =
  //                     Provider.of<UserProfileProvider>(
  //                       context,
  //                       listen: false,
  //                     );
  //                     // ✅ প্রোফাইল রিফ্রেশ (ওয়ালেট ব্যালেন্স আপডেটের জন্য)
  //                     await profileProvider.refreshProfile();
  //
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       const SnackBar(
  //                         content: Text("✅ Order Confirmed Successfully!"),
  //                         behavior: SnackBarBehavior.floating,
  //                         margin: EdgeInsets.only(
  //                           top: 20,
  //                           left: 10,
  //                           right: 10,
  //                         ),
  //                         backgroundColor: Colors.green,
  //                       ),
  //                     );
  //                   }
  //
  //                   // ✅ Future.microtask ব্যবহার করো — context stable হওয়ার পরে redirect করবে
  //                   Future.microtask(() async {
  //                     await Future.delayed(const Duration(seconds: 1));
  //
  //                     if (context.mounted) {
  //                       Navigator.pushReplacementNamed(
  //                         context,
  //                         "/myOrdersPage",
  //                       );
  //                     }
  //                   });
  //                 }
  //               } else {
  //                 print("❌ API Error: ${response.body}");
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(
  //                     content: Text(
  //                       "⚠️ Order Failed (${response.statusCode})",
  //                     ),
  //                   ),
  //                 );
  //               }
  //             } catch (e) {
  //               print("❌ Exception: $e");
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 const SnackBar(
  //                   content: Text("🚫 Network Error! আবার চেষ্টা করুন"),
  //                 ),
  //               );
  //             }
  //             if (mounted) setState(() => isSubmitting = false);
  //             print("at last issubmiting=${isSubmitting}");
  //
  //           },
  //
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.lightBlue,
  //             padding: const EdgeInsets.symmetric(
  //               horizontal: 20,
  //               vertical: 12,
  //             ),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(6),
  //             ),
  //           ),
  //           ///////////     ///////
  //
  //           // child: const Text(
  //           //   "Confirm Order",
  //           //   style: TextStyle(
  //           //     color: Colors.white,
  //           //     fontWeight: FontWeight.bold,
  //           //     fontSize: 15,
  //           //   ),
  //           // ),
  //
  //
  //
  //           child: isSubmitting
  //               ? const SizedBox(
  //             height: 20,
  //             width: 20,
  //             child: CircularProgressIndicator(
  //               strokeWidth: 2,
  //               color: Colors.white,
  //             ),
  //           )
  //               : const Text(
  //             "Confirm Order",
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontWeight: FontWeight.bold,
  //               fontSize: 15,
  //             ),
  //           ),
  //
  //
  //           /////////////////////////
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           style: TextButton.styleFrom(
  //             backgroundColor: Colors.red,
  //             padding: const EdgeInsets.symmetric(
  //               horizontal: 20,
  //               vertical: 12,
  //             ),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(6),
  //             ),
  //           ),
  //           child: const Text(
  //             "Cancel",
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontWeight: FontWeight.bold,
  //               fontSize: 15,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  //   print("🟢 After showDialog()");
  // }

  /////////////////**modified confirm order function for bind unnecessary /////////////////////////////////////////////

  // Future<void> _confirmOrder() async {
  //   final token = await getTokenFromLocalStorage();
  //
  //   final profileProvider = Provider.of<UserProfileProvider>(
  //     context,
  //     listen: false,
  //   );
  //   final profile = profileProvider.profileData?.data;
  //   final double walletBalance = _convertToDouble(profile?.wallet);
  //   final ingamepassword = "IDCODE";
  //   final securitycode = "IDCODE";
  //   // int payment_method = selectedPayment == "RRR Bazar Wallet" ? 1 : 2;
  //   int payment_method = selectedPayment == walletName ? 1 : 2;
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
  //                   // if (selectedPayment == "RRR Bazar Wallet" &&
  //                   if (selectedPayment == walletName &&
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
  //                           // if (context.mounted) {
  //                           //   Navigator.pushReplacementNamed(
  //                           //     context,
  //                           //     "/myOrdersPage",
  //                           //   );
  //                           // }
  //
  //                           if (context.mounted) {
  //                             Navigator.pushAndRemoveUntil(
  //                               context,
  //                               MaterialPageRoute(builder: (_) => MyOrdersPage()), // আপনার Orders Page
  //                                   (route) => false, // সব previous route remove করবে
  //                             );
  //                           }
  //
  //                           // if (context.mounted) {
  //                           //   Navigator.of(context).pushNamedAndRemoveUntil(
  //                           //     '/myOrdersPage',
  //                           //         (route) => false,
  //                           //   );
  //                           // }
  //
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

  void printLong(Object data) {
    final text = data.toString();
    const chunk = 800;
    for (int i = 0; i < text.length; i += chunk) {
      print(
        text.substring(i, i + chunk > text.length ? text.length : i + chunk),
      );
    }
  }

  Future<void> _confirmOrder() async {
    final token = await getTokenFromLocalStorage();

    final profileProvider = Provider.of<UserProfileProvider>(
      context,
      listen: false,
    );
    final profile = profileProvider.profileData?.data;
    final double walletBalance = _convertToDouble(profile?.wallet);
    final ingamepassword = "IDCODE";
    final securitycode = "IDCODE";
    int payment_method = selectedPayment == walletName ? 1 : 2;
    String playerId = playerIdController.text;


    // ✅ শুধুমাত্র UniPin Voucher না হলে Player ID validation চেক করবে

    // if (!widget.title.toLowerCase().contains("unipin voucher")) {
    //   // validation code
    // }       //🔹 Case insensitive করার জন্য

    if (!widget.title.contains("UniPin Voucher")) {
      if (playerIdController.text.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("❌ Player ID দিন!")));
        return;
      }
    }

    if (selectedPackIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Recharge Pack Select করুন!")),
      );
      return;
    }

    print("✅✅✅ Confirm order function is clicked ✅✅");

    showDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (context) {
        bool isSubmitting = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            void safeSetState(void Function() fn) {
              if (context.mounted) {
                setDialogState(fn);
              }
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              title: const Text(
                "Confirm Order",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your current wallet is ৳${walletBalance
                          .toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "You need ৳${selectedPackagePrice} to purchase this product.",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              actionsAlignment: MainAxisAlignment.start,
              actions: [
                ElevatedButton(
                  onPressed:
                  isSubmitting
                      ? null
                      : () async {
                    print("🔄 Starting order submission...");

                    safeSetState(() => isSubmitting = true);

                    // ✅ ব্যালেন্স চেক শুধু Wallet-এর জন্য
                    if (selectedPayment == walletName &&
                        walletBalance < (selectedPackagePrice ?? 0)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "❌ পর্যাপ্ত ব্যালেন্স নেই! আপনার ওয়ালেটে ৳${walletBalance
                                .toStringAsFixed(0)} আছে।",
                          ),
                        ),
                      );
                      safeSetState(() => isSubmitting = false);
                      return;
                    }

                    // ✅ এখানে আসল Order API চালু হবে
                    final url = Uri.parse(
                      "${backendUrl}/api/v1/packageorder",
                    );

                    final body = {
                      "topup_package_id": selectedPackageId,
                      "product_id": widget.id,
                      "name": selectedPackageName,
                      "playerid": playerId,
                      "ingamepassword": ingamepassword,
                      "securitycode": securitycode,
                      "payment_method": payment_method,
                    };

                    print("📦 Sending Order to $url");
                    print("📤 Request Body: $body");

                    try {
                      final response = await http.post(
                        url,
                        headers: {
                          "Content-Type": "application/json",
                          "Authorization": "Bearer $token",
                          "x-client-origin": ClientOrigin, // ✅ এখানে ব্যবহার হচ্ছে

                        },
                        body: jsonEncode(body),
                      );

                      // print("🔵 API Response Status: ${response.statusCode}");
                      // print("🔵 API Response Body: ${response.body}");

                      print(
                        "🔵 API Response Status: ${response.statusCode}",
                      );
                      // debugPrint("🔵 API Response Body: ${response.body}", wrapWidth: 2024);
                      debugPrint("🔵 API Response Body:🔵");
                      printLong(response.body);
                      debugPrint("🔵🔵 API Response Body close 🔵🔵");

                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        final data = jsonDecode(response.body);
                        final paymentUrl = data['data']?['payment_url'];
                        debugPrint(
                          "🔵 after 200 API Response Body: ${response.body}",
                          wrapWidth: 2024,
                        );
                        debugPrint(
                          "🔵🔵🔵 API Response Body after 200 :🔵🔵🔵",
                        );
                        printLong(data);
                        debugPrint(
                          "🔵🔵🔵 API Response Body close after 200 :🔵🔵🔵",
                        );

                        print("🔵 Payment URL: $paymentUrl");
                        print("🔵 Selected Payment: $selectedPayment");

                        // ✅ Auto Payment Case
                        ///////////////main condition live payment misssing/////////////////////////

                        // if (paymentUrl != null && selectedPayment == "Auto Payment") {
                        //   print(
                        //     "🌐 Redirecting to Payment URL: $paymentUrl",
                        //   );
                        //
                        //   Navigator.pop(context); // Close dialog
                        //
                        //   await Future.delayed(
                        //     const Duration(milliseconds: 100),
                        //   );
                        //
                        //   if (context.mounted) {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder:
                        //             (_) => PaymentWebView(
                        //               paymentUrl: paymentUrl,
                        //             ),
                        //       ),
                        //     );
                        //   }
                        // }

                        //////////////////////testing if lively payment work!! //////////////////////////////////////////////////

                        if (paymentUrl != null && selectedPayment == "Auto Payment") {
                          print(
                            "🌐 Redirecting to Payment URL: $paymentUrl",
                          );

                          Navigator.pop(context); // Close dialog

                          await Future.delayed(
                            const Duration(milliseconds: 100),
                          );

                          if (context.mounted) {
                            // Auto Payment এর জন্য

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentWebView(
                                  paymentUrl: paymentUrl,
                                  orderType: "auto_payment", // ✅ Auto Payment
                                ),
                              ),
                            );                          }
                        }

                        ///////////////////////////////////////////////////////////////


                        // if (paymentUrl != null && selectedPayment == "Auto Payment") {
                        //   print("🌐 Redirecting to Payment URL: $paymentUrl");
                        //
                        //   Navigator.pop(context); // Close dialog first
                        //
                        //   await Future.delayed(
                        //       const Duration(milliseconds: 300));
                        //   if (!mounted) return;
                        //
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (_) =>
                        //           PaymentWebView(paymentUrl: paymentUrl),
                        //     ),
                        //   );
                        // }

                        // // ✅ Wallet Payment Case - FIXED VERSION
                        else {
                          print(
                            "✅ Wallet Payment Success - Starting redirect process",
                          );

                          // ✅ Profile refresh FIRST
                          final profileProvider =
                          Provider.of<UserProfileProvider>(
                            context,
                            listen: false,
                          );
                          await profileProvider.refreshProfile();
                          print("✅ Profile refreshed");

                          // ✅ Show success message BEFORE closing dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "✅ Order Confirmed Successfully!",
                              ),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          print("✅ Snackbar shown");

                          // ✅ Store the parent context before closing dialog
                          final BuildContext parentContext =
                              this.context;

                          // ✅ Close dialog
                          Navigator.pop(context);
                          print("✅ Dialog closed");

                          // ✅ Use direct Navigator with parent context after delay
                          Future.delayed(const Duration(milliseconds: 500), () {
                            print(
                              "🔄 Attempting navigation with parent context...",
                            );

                            if (parentContext.mounted) {
                              // print("✅ Parent context is mounted, navigating...");
                              print(
                                "🔄 Navigating with pushReplacement...",
                              );

                              // ✅ Method 1: Direct Navigator.pushAndRemoveUntil
                              // Navigator.pushAndRemoveUntil(
                              Navigator.pushReplacement(
                                parentContext,
                                MaterialPageRoute(
                                  builder: (_) => MyOrdersPage(),
                                ),
                                // (route) => false,
                              );
                              print(
                                "✅ Navigation to MyOrdersPage completed",
                              );
                            } else {
                              print("❌ Parent context not mounted");

                              // ✅ Method 2: Try with navigatorKey if available
                              try {
                                // যদি আপনার main.dart-এ navigatorKey থাকে
                                // Navigator.pushAndRemoveUntil(
                                //   navigatorKey.currentContext!,
                                //   MaterialPageRoute(builder: (_) => MyOrdersPage()),
                                //   (route) => false,
                                // );
                                print("⚠️ No navigatorKey available");
                              } catch (e) {
                                print(
                                  "❌ All navigation methods failed: $e",
                                );
                              }
                            }
                          });
                        }
                      } else {
                        print(
                          "❌ API Error: ${response.statusCode} - ${response
                              .body}",
                        );
                        safeSetState(() => isSubmitting = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "⚠️ Order Failed (${response.statusCode})",
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      print("❌ Exception: $e");
                      safeSetState(() => isSubmitting = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "🚫 Network Error! আবার চেষ্টা করুন",
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child:
                  isSubmitting
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    "Confirm Order",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  ////////////////////////////////////////////////////////////////////

  // --- Payment Option Widget  ---
  // ✅  Universal Image Loader (asset + network)
  Widget loadImage(String path, {double size = 45}) {
    if (path.startsWith("http")) {
      return Image.network(
        path,
        height: size,
        errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported),
      );
    } else {
      return Image.asset(
        path,
        height: size,
        errorBuilder: (c, e, s) => const Icon(Icons.broken_image),
      );
    }
  }

  Widget paymentOption(String name, String imagePath) {
    final siteProvider = Provider.of<SiteProvider>(context);
    final site = siteProvider.siteData;
    bool isNetwork = imagePath.startsWith("http");

    // 🔹 Dynamic background color

    // Color bgColor = Colors.lightBlueAccent;
    Color bgColor = Colors.transparent;
    try {
      bgColor = Color(int.parse("0xff${site?.color}"));
    } catch (_) {}
    bool isSelected = selectedPayment == name;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = name;
        });
      },
      child: Container(
        // width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white, // 🔹 উপরের পুরো কার্ডের ব্যাকগ্রাউন্ড সাদা
          border: Border.all(
            // color: isSelected ? Colors.blue : Colors.grey.shade400,
            color: isSelected ? bgColor : Colors.grey.shade400,
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.blue.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔹 উপরের Image অংশ (সাদা থাকবে সবসময়)

            // Padding(
            //   padding: const EdgeInsets.all(10),
            //   // child: Image.asset(imagePath, height: 45),
            //   // child: Image.network(imagePath, height: 45),
            //
            //   child: loadImage(imagePath, size: 45), // 🔥 auto asset/network
            //
            //
            // ),
            Padding(
              padding: const EdgeInsets.all(10),
              child:
              isNetwork
                  ? Image.network(imagePath, height: 45)
                  : Image.asset(imagePath, height: 45),
            ),

            // 🔹 নিচের টেক্সট অংশ (সিলেক্ট করলে রঙ বদলাবে)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                // color: isSelected ? Colors.blue : Colors.white,
                color: isSelected ? bgColor : Colors.white,
                // ✅ সিলেক্ট হলে ব্যাকগ্রাউন্ড নীল
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(4),
                ),
                border: Border(
                  top: BorderSide(
                    // color: isSelected ? Colors.blue : Colors.grey.shade300,
                    color: isSelected ? bgColor : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // 🔹 নিচে underline effect দিতে নিচের Container ব্যবহার করেছি
                  Container(
                    decoration: BoxDecoration(
                      // border: Border(
                      //   bottom: BorderSide(
                      //     color: isSelected ? Colors.white : Colors.black54, // ✅ underline রঙ
                      //     width: 1.2,
                      //   ),
                      // ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),

                        // ✅ সিলেক্ট হলে টিক মার্ক দেখাবে
                        if (isSelected) ...[
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////

  // Widget buildRechargeGrid() {
  //   final siteProvider = Provider.of<SiteProvider>(context);
  //   final site = siteProvider.siteData;
  //
  //
  //   // 🔹 Dynamic background color
  //
  //   // Color bgColor = Colors.lightBlueAccent;
  //   Color bgColor = Colors.transparent;
  //   try {
  //     bgColor = Color(int.parse("0xff${site?.color}"));
  //   } catch (_) {}
  //
  //
  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //       double aspectRatio;
  //
  //       if (constraints.maxWidth < 360) {
  //         aspectRatio = 2.9; // আরও ছোট
  //       } else if (constraints.maxWidth < 480) {
  //         // aspectRatio = 1.25;
  //         aspectRatio = 2.9;
  //       } else {
  //         // aspectRatio = 1.45;
  //         aspectRatio = 2.9;
  //       }
  //
  //       return GridView.builder(
  //         itemCount: rechargePacks.length,
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 2,
  //           crossAxisSpacing: 8,
  //           mainAxisSpacing: 11,
  //           childAspectRatio: aspectRatio,
  //         ),
  //
  //
  //         itemBuilder: (context, index) {
  //           bool isSelected = selectedPackIndex == index;
  //           final pack = rechargePacks[index];
  //
  //           bool isOutOfStock = pack["in_stock"] == 0;
  //
  //           return GestureDetector(
  //             onTap: isOutOfStock
  //                 ? null
  //                 : () {
  //               setState(() {
  //                 selectedPackIndex = index;
  //                 selectedPackagePrice = _convertToDouble(pack["price"]);
  //                 selectedPackageName = pack["name"];
  //                 selectedPackageId = pack["id"];
  //               });
  //             },
  //
  //             child: Stack(
  //               clipBehavior: Clip.none, // badge overlap allow করবে
  //               children: [
  //                 // 🌟 MAIN CARD
  //                 AnimatedContainer(
  //                   duration: const Duration(milliseconds: 180),
  //                   padding: const EdgeInsets.all(6),
  //                   decoration: BoxDecoration(
  //                     color: isOutOfStock
  //                         ? Colors.grey.shade300
  //                         // ? Colors.white
  //                         : (isSelected ? bgColor.withOpacity(0.1) : Colors.white),
  //                     border: Border.all(
  //                       color: isOutOfStock
  //                           ? Colors.grey
  //                           // ? bgColor
  //                           : (isSelected ? bgColor : Colors.grey.shade400),
  //                       width: 1.2,
  //                     ),
  //                     borderRadius: BorderRadius.circular(8),
  //                   ),
  //                   child:
  //
  //
  //
  //                   Column(
  //                     children: [
  //                       // 🔵 Name
  //                       // Expanded(
  //                       //   flex: 4,
  //                       //   child: Text(
  //                       //     pack["name"] ?? "",
  //                       //     textAlign: TextAlign.center,
  //                       //     maxLines: 3,
  //                       //     overflow: TextOverflow.ellipsis,
  //                       //     style: TextStyle(
  //                       //       fontWeight: FontWeight.w600,
  //                       //       fontSize: 12.5,
  //                       //       height: 1.5,
  //                       //       color: isOutOfStock ? Colors.grey : Colors.black,
  //                       //       // color: isOutOfStock ? Colors.black : Colors.black,
  //                       //     ),
  //                       //   ),
  //                       // ),
  //
  //                       Expanded(
  //                         flex: 4,
  //                         child: LayoutBuilder(
  //                           builder: (context, boxConstraints) {
  //                             final name = pack["name"] ?? "";
  //
  //                             return Column(
  //                               children: [
  //                                 // 🔹 Auto fitting box
  //                                 Expanded(
  //                                   child: FittedBox(
  //                                     fit: BoxFit.scaleDown,
  //                                     alignment: Alignment.center, // ছোট হলে সেন্টার
  //                                     child: ConstrainedBox(
  //                                       constraints: BoxConstraints(
  //                                         maxWidth: boxConstraints.maxWidth,
  //                                       ),
  //                                       child: Text(
  //                                         name,
  //                                         textAlign: TextAlign.center,
  //                                         maxLines: 3,
  //                                         style: TextStyle(
  //                                           fontWeight: FontWeight.w600,
  //                                           fontSize: 13,
  //                                           height: 1.3,
  //                                           color: isOutOfStock ? Colors.grey : Colors.black,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //
  //                               ],
  //                             );
  //                           },
  //                         ),
  //                       ),
  //
  //                       const Divider(height: 6, thickness: 0.6),
  //
  //                       // 🟢 Price
  //                       Expanded(
  //                         flex: 2,
  //                         child: FittedBox(
  //                           child: Text(
  //                             "৳${pack["price"] ?? ""}",
  //                             style: TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                               fontSize: 11,
  //                               height: 1.3,
  //                               color: isOutOfStock ? Colors.grey : bgColor,
  //                               // color: isOutOfStock ? bgColor : bgColor,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //
  //                 // 🔴 OUT OF STOCK BADGE (TOP-RIGHT)
  //                 if (isOutOfStock)
  //                   Positioned(
  //                     right: 14,
  //                     top: -8,
  //                     // left: 4,
  //                     // bottom: 4,
  //                     child: Container(
  //                       padding:
  //                       const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  //                       decoration: BoxDecoration(
  //                         color: Colors.red,
  //                         borderRadius: BorderRadius.circular(6),
  //                       ),
  //                       child: const Text(
  //                         "Out of Stock",
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 10,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //               ],
  //             ),
  //
  //               // child: Stack(
  //               //   clipBehavior: Clip.none, // badge overlap allow করবে
  //               //   children: [
  //               //     // 🌟 MAIN CARD
  //               //     AnimatedContainer(
  //               //       duration: const Duration(milliseconds: 180),
  //               //       padding: const EdgeInsets.all(10),
  //               //       decoration: BoxDecoration(
  //               //         color: isOutOfStock
  //               //             ? Colors.grey.shade200
  //               //             : (isSelected ? bgColor.withOpacity(0.1) : Colors.white),
  //               //         border: Border.all(
  //               //           color: isOutOfStock
  //               //               ? Colors.orange
  //               //               : (isSelected ? bgColor : Colors.grey.shade300),
  //               //           width: 1.3,
  //               //         ),
  //               //         borderRadius: BorderRadius.circular(12),
  //               //       ),
  //               //       child: Column(
  //               //         crossAxisAlignment: CrossAxisAlignment.start,
  //               //         children: [
  //               //           Expanded(
  //               //             child: Text(
  //               //               pack["name"] ?? "",
  //               //               maxLines: 2,
  //               //               overflow: TextOverflow.ellipsis,
  //               //               style: TextStyle(
  //               //                 fontWeight: FontWeight.w600,
  //               //                 fontSize: 14,
  //               //                 color: isOutOfStock ? Colors.grey : Colors.black,
  //               //               ),
  //               //             ),
  //               //           ),
  //               //           const SizedBox(height: 6),
  //               //           FittedBox(
  //               //             child: Text(
  //               //               "৳${pack["price"]}",
  //               //               style: TextStyle(
  //               //                 fontWeight: FontWeight.bold,
  //               //                 color: isOutOfStock ? Colors.grey : bgColor,
  //               //               ),
  //               //             ),
  //               //           ),
  //               //         ],
  //               //       ),
  //               //     ),
  //               //
  //               //     // 🔥 BORDER-FOLLOWING BADGE (top-right, screenshot style)
  //               //     if (isOutOfStock)
  //               //       Positioned(
  //               //         top: -10, // border overlap
  //               //         // right: 50, // border radius অনুযায়ী perfect fit
  //               //         child: Container(
  //               //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
  //               //           decoration: BoxDecoration(
  //               //             color: Colors.orange.shade600,
  //               //             borderRadius: BorderRadius.circular(20),
  //               //             border: Border.all(
  //               //               color: Colors.white,
  //               //               width: 1.2, // border er sathe clean cut effect
  //               //             ),
  //               //           ),
  //               //           child: const Text(
  //               //             "Out of stock",
  //               //             style: TextStyle(
  //               //               color: Colors.white,
  //               //               fontSize: 10,
  //               //               fontWeight: FontWeight.bold,
  //               //             ),
  //               //           ),
  //               //         ),
  //               //       ),
  //               //   ],
  //               // )
  //
  //           );
  //         },
  //
  //
  //       );
  //     },
  //   );
  //
  //
  //   ///////////////////////////////////
  //
  // }

  // Widget buildRechargeGrid() {
  //   final siteProvider = Provider.of<SiteProvider>(context);
  //   final site = siteProvider.siteData;
  //
  //   Color bgColor = Colors.transparent;
  //   try {
  //     bgColor = Color(int.parse("0xff${site?.color}"));
  //   } catch (_) {}
  //
  //   // Group items by rows (2 items per row)
  //   List<List<dynamic>> rows = [];
  //   for (int i = 0; i < rechargePacks.length; i += 2) {
  //     List<dynamic> row = [];
  //     if (i < rechargePacks.length) row.add(rechargePacks[i]);
  //     if (i + 1 < rechargePacks.length) row.add(rechargePacks[i + 1]);
  //     rows.add(row);
  //   }
  //
  //   return Column(
  //     children: rows.map((rowItems) {
  //       // Calculate max height needed for this row
  //       double maxHeight = _calculateRowHeight(rowItems);
  //
  //       return Container(
  //         margin: const EdgeInsets.only(bottom: 11),
  //         child: Row(
  //           children: rowItems.map((pack) {
  //             int index = rechargePacks.indexOf(pack);
  //             bool isSelected = selectedPackIndex == index;
  //             bool isOutOfStock = pack["in_stock"] == 0;
  //
  //             return Expanded(
  //               child: Container(
  //                 height: maxHeight, // Same height for all items in this row
  //                 margin: const EdgeInsets.symmetric(horizontal: 4),
  //                 child: GestureDetector(
  //                   onTap: isOutOfStock
  //                       ? null
  //                       : () {
  //                     setState(() {
  //                       selectedPackIndex = index;
  //                       selectedPackagePrice = _convertToDouble(pack["price"]);
  //                       selectedPackageName = pack["name"];
  //                       selectedPackageId = pack["id"];
  //                     });
  //                   },
  //                   child: Stack(
  //                     clipBehavior: Clip.none,
  //                     children: [
  //                       // 🌟 MAIN CARD
  //                       AnimatedContainer(
  //                         duration: const Duration(milliseconds: 180),
  //                         padding: const EdgeInsets.all(8),
  //                         decoration: BoxDecoration(
  //                           color: isOutOfStock
  //                               ? Colors.grey.shade300
  //                               : (isSelected ? bgColor.withOpacity(0.1) : Colors.white),
  //                           border: Border.all(
  //                             color: isOutOfStock
  //                                 ? Colors.grey
  //                                 : (isSelected ? bgColor : Colors.grey.shade400),
  //                             width: 1.2,
  //                           ),
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             // 🔵 Name - Flexible space
  //                             Expanded(
  //                               child: Container(
  //                                 width: double.infinity,
  //                                 alignment: Alignment.center,
  //                                 child: Text(
  //                                   pack["name"] ?? "",
  //                                   textAlign: TextAlign.center,
  //                                   maxLines: 3,
  //                                   overflow: TextOverflow.ellipsis,
  //                                   style: TextStyle(
  //                                     fontWeight: FontWeight.w600,
  //                                     fontSize: _getOptimalFontSize(pack["name"] ?? ""),
  //                                     height: 1.2,
  //                                     color: isOutOfStock ? Colors.grey : Colors.black,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //
  //                             // 🔷 Divider
  //                             Divider(
  //                               height: 1,
  //                               thickness: 0.8,
  //                               color: isOutOfStock ? Colors.grey : Colors.grey.shade400,
  //                             ),
  //
  //                             const SizedBox(height: 4),
  //
  //                             // 🟢 Price
  //                             Container(
  //                               height: 18,
  //                               alignment: Alignment.center,
  //                               child: FittedBox(
  //                                 child: Text(
  //                                   "৳${pack["price"] ?? ""}",
  //                                   style: TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     color: isOutOfStock ? Colors.grey : bgColor,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //
  //                       // 🔴 OUT OF STOCK BADGE
  //                       if (isOutOfStock)
  //                         Positioned(
  //                           right: 8,
  //                           top: -6,
  //                           child: Container(
  //                             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  //                             decoration: BoxDecoration(
  //                               color: Colors.red,
  //                               borderRadius: BorderRadius.circular(6),
  //                             ),
  //                             child: const Text(
  //                               "Out of Stock",
  //                               style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 9,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }).toList(),
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }

  Widget buildRechargeGrid() {
    final siteProvider = Provider.of<SiteProvider>(context);
    final site = siteProvider.siteData;

    Color bgColor = Colors.transparent;
    try {
      bgColor = Color(int.parse("0xff${site?.color}"));
    } catch (_) {}

    // Group items by rows (2 items per row)
    List<List<dynamic>> rows = [];
    for (int i = 0; i < rechargePacks.length; i += 2) {
      List<dynamic> row = [];
      if (i < rechargePacks.length) row.add(rechargePacks[i]);
      if (i + 1 < rechargePacks.length) row.add(rechargePacks[i + 1]);
      rows.add(row);
    }

    return Column(
      children:
      rows.map((rowItems) {
        // Calculate max height needed for this row
        double maxHeight = _calculateRowHeight(rowItems);

        return Container(
          margin: const EdgeInsets.only(bottom: 11),
          child: Row(
            children: [
              // ✅ প্রথম item (বাম পাশের)
              if (rowItems.isNotEmpty)
                _buildPackageItem(rowItems[0], 0, maxHeight, bgColor),

              const SizedBox(width: 8),
              // Spacing between items

              // ✅ দ্বিতীয় item (ডান পাশের) - থাকলে show করবে, না থাকলে খালি জায়গা
              if (rowItems.length > 1)
                _buildPackageItem(rowItems[1], 1, maxHeight, bgColor)
              else
                Container(
                  width:
                  (MediaQuery
                      .of(context)
                      .size
                      .width - 48) /
                      2, // ✅ Exactly half width
                  height: maxHeight,
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ✅ Helper method to build individual package item
  Widget _buildPackageItem(dynamic pack,
      int position,
      double maxHeight,
      Color bgColor,) {
    int index = rechargePacks.indexOf(pack);
    bool isSelected = selectedPackIndex == index;
    bool isOutOfStock = pack["in_stock"] == 0;

    return Container(
      width: (MediaQuery
          .of(context)
          .size
          .width - 48) / 2,
      // ✅ Exactly half width
      height: maxHeight,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      // ✅ No horizontal margin
      child: GestureDetector(
        onTap:
        isOutOfStock
            ? null
            : () {
          setState(() {
            selectedPackIndex = index;
            selectedPackagePrice = _convertToDouble(pack["price"]);
            selectedPackageName = pack["name"];
            selectedPackageId = pack["id"];
          });
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 🌟 MAIN CARD
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                isOutOfStock
                    ? Colors.grey.shade300
                    : (isSelected
                    ? bgColor.withOpacity(0.1)
                    : Colors.white),
                border: Border.all(
                  color:
                  isOutOfStock
                      ? Colors.grey
                      : (isSelected ? bgColor : Colors.grey.shade400),
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 🔵 Name - Flexible space
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        pack["name"] ?? "",
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: _getOptimalFontSize(pack["name"] ?? ""),
                          height: 1.2,
                          color: isOutOfStock ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                  ),

                  // 🔷 Divider
                  Divider(
                    height: 1,
                    thickness: 0.8,
                    color: isOutOfStock ? Colors.grey : Colors.grey.shade400,
                  ),

                  const SizedBox(height: 4),

                  // 🟢 Price
                  Container(
                    height: 18,
                    alignment: Alignment.center,
                    child: FittedBox(
                      child: Text(
                        "৳${pack["price"] ?? ""}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isOutOfStock ? Colors.grey : bgColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔴 OUT OF STOCK BADGE
            if (isOutOfStock)
              Positioned(
                right: 20,
                top: -6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "Out of Stock",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Calculate row height based on the tallest content in the row
  double _calculateRowHeight(List<dynamic> rowItems) {
    double maxHeight = 40.0; // Minimum height

    for (var pack in rowItems) {
      String name = pack["name"] ?? "";
      int lineCount = (name.length / 15).ceil(); // Approximate lines needed
      double estimatedHeight =
          60.0 + (lineCount * 12.0); // Base height + line height

      if (estimatedHeight > maxHeight) {
        maxHeight = estimatedHeight;
      }
    }

    return maxHeight;
  }

  // Optimal font size based on text length
  double _getOptimalFontSize(String text) {
    // if (text.length <= 12) return 10.0;
    // if (text.length <= 18) return 10.0;
    // if (text.length <= 24) return 10.0;
    // if (text.length <= 30) return 10.0;
    return 12.0;
  }

  /////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final siteProvider = Provider.of<SiteProvider>(context);
    final site = siteProvider.siteData;

    // 🔹 Dynamic background color

    // Color bgColor = Colors.lightBlueAccent;
    Color bgColor = Colors.transparent;
    try {
      bgColor = Color(int.parse("0xff${site?.color}"));
    } catch (_) {}

    final logoUrl = "$backendUrl/images/${site?.logo}";
    final userProvider = Provider.of<UserProvider>(context);
    final profileProvider = Provider.of<UserProfileProvider>(context);
    // final profileProvider = Provider.of<UserProfileProvider>(context, listen: false,).fetchUserProfile();
    final profile =
        profileProvider.profileData?.data; // ✅ Dynamic wallet balance
    // final profile = profileProvider.profileData?.data; // ✅ Dynamic wallet balance
    final double walletBalance = _convertToDouble(profile?.wallet);
    print("*********dynamic wallet balance=? ${walletBalance}***********");

    final user = userProvider;
    // final selectedPack = rechargePacks[selectedPackIndex!];
    // final double selected_package_price = _convertToDouble(selectedPack["price"]);

    final bool isLoggedIn = user.isLoggedIn;

    // final bool canBuy = isLoggedIn &&
    //     // ((selectedPayment == "RRR Bazar Wallet" && walletBalance > (selectedPackagePrice ?? 0) ) ||
    //     ((selectedPayment == walletName && walletBalance > (selectedPackagePrice ?? 0) ) ||
    //     // ((selectedPayment == "RRR Bazar Wallet" && walletBalance > (selected_package_price ?? 0) ) ||
    //         selectedPayment == "Auto Payment");

    // ✅ canBuy কন্ডিশন
    final bool canBuy =
        isLoggedIn &&
            (selectedPayment ==
                "Auto Payment" || // Auto Payment এ সবসময় buy করা যাবে
                (selectedPayment == walletName &&
                    selectedPackagePrice !=
                        null && // প্রথমে চেক করছি price select হয়েছে কিনা
                    walletBalance >=
                        selectedPackagePrice! // এখন চেক করছি ব্যালেন্স যথেষ্ট কি না
                ));

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(logoUrl: logoUrl, isLoggedIn: isLoggedIn),

      ////////// page with refresh code is given bellow ///////
      body: RefreshIndicator(
        onRefresh: () async {
          // ✅ Reload user profile

          // await Provider.of<UserProfileProvider>(context, listen: false)
          //     .fetchUserProfile();
          //
          // // ✅ Reload Site Data
          //
          // Provider.of<SiteProvider>(context, listen: false).siteData = null;
          // await Provider.of<SiteProvider>(context, listen: false)
          //     .fetchSiteData();
          //
          // // ✅ Optional Snackbar
          //
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text("✅ Page Refreshed!")),
          // );

          fetchRechargePacks();

          setState(() {}); // UI refresh
        },

        // child: SingleChildScrollView(
        //   physics: const AlwaysScrollableScrollPhysics(),
        //
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //
        //       // 🟦 পুরো content-এ padding দিন
        //       Padding(
        //         padding: const EdgeInsets.all(16),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           // children: [
        //           //   /// 🔹 আপনার পুরো content (warning, grid, form, buttons etc.)
        //           //   /// এগুলো এখানেই থাকবে
        //           // ],
        //
        //
        //           children: [
        //             // ⚠️ যদি user লগইন না করে থাকে তাহলে warning box দেখাও
        //             if (!isLoggedIn)
        //               Container(
        //                 padding: const EdgeInsets.all(12),
        //                 margin: const EdgeInsets.only(bottom: 20),
        //                 decoration: BoxDecoration(
        //                   color: Colors.amber[100],
        //                   borderRadius: BorderRadius.circular(8),
        //                   border: Border.all(color: Colors.orange),
        //                 ),
        //                 child: Row(
        //                   crossAxisAlignment: CrossAxisAlignment.center,
        //                   children: [
        //                     const Icon(Icons.warning, color: Colors.orange, size: 30),
        //                     const SizedBox(width: 10),
        //                     const Expanded(
        //                       child: Text(
        //                         "You must be logged in to order. Please login first.",
        //                         style: TextStyle(
        //                           fontWeight: FontWeight.w500,
        //                           color: Colors.black87,
        //                         ),
        //                       ),
        //                     ),
        //                     TextButton(
        //                       onPressed: () {
        //                         Navigator.push(
        //                           context,
        //                           MaterialPageRoute(
        //                             builder: (_) => const LoginScreen(),
        //                           ),
        //                         );
        //                       },
        //                       style: TextButton.styleFrom(
        //                         // backgroundColor: Colors.blue,
        //                         backgroundColor: bgColor,
        //                         foregroundColor: Colors.white,
        //                         padding: const EdgeInsets.symmetric(
        //                           horizontal: 16,
        //                           vertical: 8,
        //                         ),
        //                       ),
        //                       child: const Text("Login"),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //
        //             // ✅ Wallet Warning শুধু লগইনকৃত ইউজারদের জন্য
        //             if (isLoggedIn && walletBalance <= 0)
        //               Container(
        //                 padding: const EdgeInsets.all(10),
        //                 margin: const EdgeInsets.only(bottom: 20),
        //                 decoration: BoxDecoration(
        //                   color: Colors.amber[100],
        //                   borderRadius: BorderRadius.circular(8),
        //                   border: Border.all(color: Colors.amber),
        //                 ),
        //                 child: Row(
        //                   children: [
        //                     const Icon(Icons.warning, color: Colors.orange),
        //                     const SizedBox(width: 8),
        //                     const Expanded(
        //                       child: Text(
        //                         "Wallet balance নেই। প্রথমে Add Money করুন।",
        //                         style: TextStyle(color: Colors.black87),
        //                       ),
        //                     ),
        //                     TextButton(
        //                       onPressed: () {
        //                         Navigator.push(
        //                           context,
        //                           MaterialPageRoute(builder: (_) => AddMoneyPage()),
        //                         );
        //                       },
        //                       // child: const Text("Add Money"),
        //                       // child: const Text("Add Money",style: TextStyle(color: Colors.black87),),
        //                       child: Text("Add Money",style: TextStyle(color:bgColor),),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //
        //             Center(child: Image.network(widget.image, width: 100)),
        //             const SizedBox(height: 10),
        //             Center(
        //               child: Text(
        //                 widget.title,
        //                 style: const TextStyle(
        //                   fontSize: 20,
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //               ),
        //             ),
        //
        //             const SizedBox(height: 20),
        //
        //             Container(
        //               decoration: BoxDecoration(
        //                 // color: Colors.lightBlueAccent,
        //                 color: bgColor,
        //                 borderRadius: BorderRadius.circular(8),
        //               ),
        //               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        //               child: Row(
        //                 children: [
        //                   CircleAvatar(
        //                     radius: 14,
        //                     backgroundColor: Colors.transparent,
        //                     child: Container(
        //                       decoration: BoxDecoration(
        //                         shape: BoxShape.circle,
        //                         border: Border.all(color: Colors.white, width: 2),
        //                       ),
        //                       alignment: Alignment.center,
        //                       child: Text(
        //                         "1",
        //                         style: TextStyle(
        //                             color: Colors.white,
        //                             fontWeight: FontWeight.bold),
        //                       ),
        //                     ),
        //                   ),
        //                   SizedBox(width: 10),
        //                   Text(
        //                     "Account Info",
        //                     style: TextStyle(
        //                         color: Colors.white,
        //                         fontSize: 16,
        //                         fontWeight: FontWeight.bold),
        //                   ),
        //                   Spacer(),
        //                 ],
        //               ),
        //             ),
        //
        //             SizedBox(height: 12),
        //
        //
        //
        //             TextField(
        //               controller: playerIdController,
        //               decoration: InputDecoration(
        //                 labelText: "Enter Player ID",
        //                 border: OutlineInputBorder(
        //                   borderRadius: BorderRadius.circular(10),
        //                 ),
        //               ),
        //               enabled: isLoggedIn, // ❌ লগইন না থাকলে টাইপ করা যাবে না
        //             ),
        //
        //             const SizedBox(height: 20),
        //
        //             //////////////////recharge pack ////////////////
        //
        //             // const Text(
        //             //   "Select Recharge Pack",
        //             //   style: TextStyle(fontWeight: FontWeight.bold),
        //             // ),
        //
        //             Container(
        //               decoration: BoxDecoration(
        //                 // color: Colors.lightBlueAccent,
        //                 color: bgColor,
        //                 borderRadius: BorderRadius.circular(8),
        //               ),
        //               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        //               child: Row(
        //                 children: [
        //                   CircleAvatar(
        //                     radius: 14,
        //                     backgroundColor: Colors.transparent,
        //                     child: Container(
        //                       decoration: BoxDecoration(
        //                         shape: BoxShape.circle,
        //                         border: Border.all(color: Colors.white, width: 2),
        //                       ),
        //                       alignment: Alignment.center,
        //                       child: Text(
        //                         "2",
        //                         style: TextStyle(
        //                             color: Colors.white,
        //                             fontWeight: FontWeight.bold),
        //                       ),
        //                     ),
        //                   ),
        //                   SizedBox(width: 10),
        //                   Text(
        //                     "Select Recharge Pack",
        //                     style: TextStyle(
        //                         color: Colors.white,
        //                         fontSize: 16,
        //                         fontWeight: FontWeight.bold),
        //                   ),
        //                   Spacer(),
        //                 ],
        //               ),
        //             ),
        //
        //             SizedBox(height: 12),
        //
        //
        //
        //
        //             buildRechargeGrid(),
        //
        //             /////////////////////////////////////////////////////
        //
        //             const SizedBox(height: 20),
        //
        //             //////////////////////// payment part/////////////
        //
        //             const Text(
        //               "Select Payment Method",
        //               style: TextStyle(fontWeight: FontWeight.bold),
        //             ),
        //             const SizedBox(height: 10),
        //
        //
        //             // Row(
        //             //   mainAxisAlignment: MainAxisAlignment.center,
        //             //   children: [
        //             //     paymentOption("RRR Bazar Wallet", "assets/wallet.png"),
        //             //     paymentOption("Auto Payment", "assets/auto_payment.jpeg"),
        //             //   ],
        //
        //             // ),
        //
        //             Row(
        //               children: [
        //                 Expanded(
        //                   child:
        //                   paymentOption(
        //                     // "RRR Bazar Wallet",
        //                     // "assets/wallet.png",
        //                     ///////////////////////
        //
        //                     // "ZS Shop Wallet",
        //                     // "assets/walletimage/zs_wallet.png",
        //
        //                     ///////////////////////////////////
        //
        //                     // "BDGBazar Wallet",
        //                     // "assets/walletimage/bd_wallet.png",
        //
        //                     ///////////////////////////////////
        //
        //                     // "Cobratop.. wallet",
        //                     // "assets/walletimage/cobra_wallet.png",
        //
        //                     ///////////////////////////////////
        //
        //                     // "Pipo Ba.. wallet",
        //                     // "assets/walletimage/pipo_wallet.png",
        //
        //                     ///////////////////////////////////
        //                     // "Evo Topup wallet",
        //                     // "assets/walletimage/evo_wallet.png",
        //
        //                     ///////////////////////////////////
        //                     // "Rangvo wallet",
        //                     // "assets/walletimage/rangvo_wallet.png",
        //
        //                     walletName,
        //                     logoUrl,
        //
        //                   ),
        //                 ),
        //                 Expanded(
        //                   child: paymentOption(
        //                     "Auto Payment",
        //                     "assets/auto_payment.jpeg",
        //                   ),
        //                 ),
        //               ],
        //             ),
        //
        //             //////////////////////////////////////////////
        //             const SizedBox(height: 30),
        //
        //             Row(
        //               children: [
        //                 // ✅ শুধুমাত্র লগইনকৃত ইউজার হলে Add Money দেখাও
        //                 if (isLoggedIn && selectedPayment == "RRR Bazar Wallet")
        //                   Expanded(
        //                     child: ElevatedButton.icon(
        //                       onPressed: () {
        //                         Navigator.push(
        //                           context,
        //                           MaterialPageRoute(builder: (_) => AddMoneyPage()),
        //                         );
        //                       },
        //                       // icon: const Icon(Icons.add, color: Colors.blue),
        //                       icon: Icon(Icons.add, color: bgColor),
        //                       label: Text(
        //                         "Add Money",
        //                         style: TextStyle(
        //                           // color: Colors.blue,
        //                           color: bgColor,
        //                           fontWeight: FontWeight.w600,
        //                         ),
        //                       ),
        //                       style: ElevatedButton.styleFrom(
        //                         minimumSize: const Size(double.infinity, 50),
        //                         backgroundColor: Colors.white,
        //                         side: BorderSide(
        //                           // color: Colors.blue,
        //                           color: bgColor,
        //                           width: 1.5,
        //                         ),
        //                         shape: RoundedRectangleBorder(
        //                           borderRadius: BorderRadius.circular(8),
        //                         ),
        //                         elevation: 0,
        //                       ),
        //                     ),
        //                   ),
        //
        //                 const SizedBox(width: 10),
        //
        //                 // ✅ Buy Now Button (disabled if not logged in)
        //                 Expanded(
        //                   child: Opacity(
        //                     opacity: canBuy ? 1 : 0.5,
        //                     child: ElevatedButton(
        //                       style: ElevatedButton.styleFrom(
        //                         minimumSize: const Size(double.infinity, 50),
        //                         backgroundColor:
        //                         // canBuy ? Colors.blue : Colors.grey[400],
        //                         canBuy ? bgColor : Colors.grey[400],
        //                         side: BorderSide(
        //                           // color: canBuy ? Colors.blueAccent : Colors.grey,
        //                           color: canBuy ? bgColor : Colors.grey,
        //                           width: 1.2,
        //                         ),
        //                         shape: RoundedRectangleBorder(
        //                           borderRadius: BorderRadius.circular(8),
        //                         ),
        //                         elevation: canBuy ? 2 : 0,
        //                       ),
        //                       onPressed: canBuy ? _confirmOrder : null,
        //                       child: const Text(
        //                         "Buy Now",
        //                         style: TextStyle(fontSize: 18, color: Colors.white),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //
        //             const SizedBox(height: 30),
        //             // CustomFooter(),
        //           ],
        //
        //
        //
        //         ),
        //       ),
        //
        //       // 🟥 Footer Outside Padding
        //       CustomFooter(), // এখানে আর padding লাগবে না
        //     ],
        //   ),
        //
        // ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🟦 All main content with padding
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        // children: [
                        //   // 👉 আপনার সমস্ত content এখানেই থাকবে
                        //   // warning, grid, buttons, form etc.
                        // ],
                        children: [
                          // ⚠️ যদি user লগইন না করে থাকে তাহলে warning box দেখাও
                          if (!isLoggedIn)
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.amber[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.orange),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.warning,
                                    color: Colors.orange,
                                    size: 30,
                                  ),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                    child: Text(
                                      "You must be logged in to order. Please login first.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const LoginScreen(),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      // backgroundColor: Colors.blue,
                                      backgroundColor: bgColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                    ),
                                    child: const Text("Login"),
                                  ),
                                ],
                              ),
                            ),

                          // ✅ Wallet Warning শুধু লগইনকৃত ইউজারদের জন্য
                          if (isLoggedIn && walletBalance <= 0)
                            Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.amber[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.amber),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.warning,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Text(
                                      "Wallet balance নেই। প্রথমে Add Money করুন।",
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AddMoneyPage(),
                                        ),
                                      );
                                    },
                                    // child: const Text("Add Money"),
                                    // child: const Text("Add Money",style: TextStyle(color: Colors.black87),),
                                    child: Text(
                                      "Add Money",
                                      style: TextStyle(color: bgColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          Center(
                            child: Image.network(widget.image, width: 100),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          ///////////////// account info /////////////

                          // ✅ শুধুমাত্র UniPin Voucher না হলে Account Info section দেখাবে
                          if (!widget.title.contains("UniPin Voucher")) ...[
                            Container(
                              decoration: BoxDecoration(
                                // color: Colors.lightBlueAccent,
                                color: bgColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.transparent,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "1",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Account Info",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),

                            SizedBox(height: 12),

                            // TextField(
                            //   controller: playerIdController,
                            //   decoration: InputDecoration(
                            //     labelText: "Enter Player ID",
                            //     border: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //   ),
                            //   enabled: isLoggedIn, // ❌ লগইন না থাকলে টাইপ করা যাবে না
                            // ),
                            TextField(
                              controller: playerIdController,
                              decoration: InputDecoration(
                                labelText: "Enter Player ID",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              enabled: isLoggedIn,
                              // লগইন না থাকলে টাইপ করা যাবে না
                              keyboardType: TextInputType.number,
                              // 🔥 Number keyboard
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                // 🔥 Only digits allowed
                              ],
                            ),

                            const SizedBox(height: 20),
                          ],

                          //////////////////recharge pack ////////////////

                          // const Text(
                          //   "Select Recharge Pack",
                          //   style: TextStyle(fontWeight: FontWeight.bold),
                          // ),
                          Container(
                            decoration: BoxDecoration(
                              // color: Colors.lightBlueAccent,
                              color: bgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                // ✅ শুধুমাত্র UniPin Voucher না হলে Account Info section দেখাবে
                                if (!widget.title.contains("UniPin Voucher"))
                                  ...[
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "2",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                SizedBox(width: 10),
                                Text(
                                  "Select Recharge Pack",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),

                          SizedBox(height: 12),

                          buildRechargeGrid(),

                          /////////////////////////////////////////////////////
                          const SizedBox(height: 20),

                          //////////////////////// payment part/////////////
                          const Text(
                            "Select Payment Method",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     paymentOption("RRR Bazar Wallet", "assets/wallet.png"),
                          //     paymentOption("Auto Payment", "assets/auto_payment.jpeg"),
                          //   ],

                          // ),
                          Row(
                            children: [
                              Expanded(
                                child: paymentOption(
                                  // "RRR Bazar Wallet",
                                  // "assets/wallet.png",
                                  ///////////////////////

                                  // "ZS Shop Wallet",
                                  // "assets/walletimage/zs_wallet.png",

                                  ///////////////////////////////////

                                  // "BDGBazar Wallet",
                                  // "assets/walletimage/bd_wallet.png",

                                  ///////////////////////////////////

                                  // "Cobratop.. wallet",
                                  // "assets/walletimage/cobra_wallet.png",

                                  ///////////////////////////////////

                                  // "Pipo Ba.. wallet",
                                  // "assets/walletimage/pipo_wallet.png",

                                  ///////////////////////////////////
                                  // "Evo Topup wallet",
                                  // "assets/walletimage/evo_wallet.png",

                                  ///////////////////////////////////
                                  // "Rangvo wallet",
                                  // "assets/walletimage/rangvo_wallet.png",
                                  walletName,
                                  logoUrl,
                                ),
                              ),
                              Expanded(
                                child: paymentOption(
                                  "Auto Payment",
                                  "assets/auto_payment.jpeg",
                                ),
                              ),
                            ],
                          ),

                          //////////////////////////////////////////////
                          const SizedBox(height: 30),

                          Row(
                            children: [
                              // ✅ শুধুমাত্র লগইনকৃত ইউজার হলে Add Money দেখাও
                              if (isLoggedIn && selectedPayment == walletName)
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AddMoneyPage(),
                                        ),
                                      );
                                    },
                                    // icon: const Icon(Icons.add, color: Colors.blue),
                                    icon: Icon(Icons.add, color: bgColor),
                                    label: Text(
                                      "Add Money",
                                      style: TextStyle(
                                        // color: Colors.blue,
                                        color: bgColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(
                                        double.infinity,
                                        50,
                                      ),
                                      backgroundColor: Colors.white,
                                      side: BorderSide(
                                        // color: Colors.blue,
                                        color: bgColor,
                                        width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            8),
                                      ),
                                      elevation: 0,
                                    ),
                                  ),
                                ),

                              const SizedBox(width: 10),

                              // ✅ Buy Now Button (disabled if not logged in)
                              Expanded(
                                child: Opacity(
                                  opacity: canBuy ? 1 : 0.5,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(
                                        double.infinity,
                                        50,
                                      ),
                                      backgroundColor:
                                      // canBuy ? Colors.blue : Colors.grey[400],
                                      canBuy ? bgColor : Colors.grey[400],
                                      side: BorderSide(
                                        // color: canBuy ? Colors.blueAccent : Colors.grey,
                                        color: canBuy ? bgColor : Colors.grey,
                                        width: 1.2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            8),
                                      ),
                                      elevation: canBuy ? 2 : 0,
                                    ),
                                    onPressed: canBuy ? _confirmOrder : null,
                                    child: const Text(
                                      "Buy Now",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),
                          // CustomFooter(),
                        ],
                      ),
                    ),

                    // 🔥 Push footer to bottom even if content is small
                    const SizedBox(height: 20),
                    // Footer উপরে উঠে না আসার জন্য
                    // 🟥 Footer without padding
                    CustomFooter(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
