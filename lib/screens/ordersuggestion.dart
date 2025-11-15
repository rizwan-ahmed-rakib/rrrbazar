import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/base_url.dart' show backendUrl;
import '../provider/site_provider.dart';
import '../provider/user_profile_provider.dart';
import '../provider/user_provider.dart';
import 'addMoneyPage.dart';
import 'custom_app_bar.dart';
import 'customdrawer.dart';
import 'footer.dart';
import 'home_screen.dart';
import 'login.dart';
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
  String selectedPayment = "RRR Bazar Wallet";
  int? selectedPackIndex;
  double? selectedPackagePrice; // nullable কারণ শুরুতে কিছু সিলেক্ট থাকে না

  var selectedPackageName;

  var selectedPackageId;

  @override
  void initState() {
    super.initState();
    fetchRechargePacks();
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

  // --- Confirm Order ---

  // void _confirmOrder() {
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
  //   final selectedPack = rechargePacks[selectedPackIndex!];
  //   final double price = selectedPack["price"].toDouble();
  //
  //   // Popup দেখানো
  //   showDialog(
  //     context: context,
  //     builder:
  //         (context) => AlertDialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           title: const Text(
  //             "Confirm Order",
  //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
  //           ),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 "Your current wallet is ৳${walletBalance.toStringAsFixed(0)}",
  //                 style: const TextStyle(fontSize: 15, color: Colors.black87),
  //               ),
  //               const SizedBox(height: 6),
  //               Text(
  //                 "You need ৳${price.toStringAsFixed(0)} to purchase this product.",
  //                 style: const TextStyle(fontSize: 15, color: Colors.black87),
  //               ),
  //             ],
  //           ),
  //           actionsPadding: const EdgeInsets.symmetric(
  //             horizontal: 15,
  //             vertical: 10,
  //           ),
  //
  //           actionsAlignment: MainAxisAlignment.start, // 👉 বাম দিক থেকে বাটন শুরু হবে
  //
  //           actions: [
  //             // ✅ Confirm Order Button (Light Blue)
  //             ElevatedButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //
  //                 // Balance Check
  //                 if (selectedPayment == "RRR Bazar Wallet") {
  //                   if (walletBalance < price) {
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       SnackBar(
  //                         content: Text(
  //                           "❌ পর্যাপ্ত ব্যালেন্স নেই! আপনার ওয়ালেটে ৳${walletBalance.toStringAsFixed(0)} আছে।",
  //                         ),
  //                       ),
  //                     );
  //                     return;
  //                   }
  //                 }
  //
  //                 // 🔥 Payment Redirect
  //                 if (selectedPayment == "Auto Payment") {
  //                   print("➡️ Redirecting to Auto Payment API...");
  //                 } else {
  //                   print("➡️ Wallet দিয়ে Order Confirm!");
  //                 }
  //
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(
  //                     content: Text("✅ Order Confirmed Successfully!"),
  //                   ),
  //                 );
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: Colors.lightBlue,
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 20,
  //                   vertical: 12,
  //                 ),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(6),
  //                 ),
  //               ),
  //               child: const Text(
  //                 "Confirm order",
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 15,
  //                 ),
  //               ),
  //             ),
  //
  //             // ❌ Cancel Button (Red)
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               style: TextButton.styleFrom(
  //                 backgroundColor: Colors.red,
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 20,
  //                   vertical: 12,
  //                 ),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(6),
  //                 ),
  //               ),
  //               child: const Text(
  //                 "Cancel",
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 15,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //   );
  // }

  // String/dynamic থেকে double-এ convert করার helper method

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

  Future<void> _confirmOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final profileProvider = Provider.of<UserProfileProvider>(
      context,
      listen: false,
    );
    final profile = profileProvider.profileData?.data;
    final double walletBalance = _convertToDouble(
      profile?.wallet,
    ); // ✅ Dynamic wallet balance
    final ingamepassword = "IDCODE"; //confirm order korle pathate hobe
    final securitycode = "IDCODE"; //confirm order korle pathate hobe
    // ✅ এখন selectedPayment অনুযায়ী payment_method নির্ধারণ
    int payment_method = selectedPayment == "RRR Bazar Wallet" ? 1 : 2;
    String playerId = playerIdController.text; // 🔹 এখানে Player ID পাওয়া গেলো
    // "topup_package_id": 84, **
    // "product_id": 16,   ***  ei variable gula ami globally pabo  ja ----
    // "name": "Tesst1",***  ---- buildRechargeGrid() e setState diye tule dewa hoyese.

    print("🔹 Wallet Balance from Provider: $walletBalance");
    print("✅✅✅confirm order function is clicked✅✅");
    if (playerIdController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("❌ Player ID দিন!")));
      return;
    }

    if (selectedPackIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Recharge Pack Select করুন!")),
      );
      return;
    }

    // final selectedPack = rechargePacks[selectedPackIndex!];
    // final double price = _convertToDouble(selectedPack["price"]);
    //
    // setState(() {
    //   selectedPackagePrice = price; // local package price take global e pathiye dilam
    // });

    print("🟢 Selected package price set: $selectedPackagePrice");
    // ✅ Popup দেখানো

    print("🟢 Showing popup now...");

    showDialog(
      context: context,
      useRootNavigator: true,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),

            title: const Text(
              "Confirm Order",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            content: SingleChildScrollView(
              // ✅ overflow fix
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your current wallet is ৳${walletBalance.toStringAsFixed(0)}",
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "You need ৳${selectedPackagePrice} to purchase this product.",
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
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
                // onPressed: () async {
                //   // Navigator.pop(context);
                //
                //   // ✅ ব্যালেন্স চেক
                //   if (selectedPayment == "RRR Bazar Wallet" &&
                //       walletBalance < (selectedPackagePrice ?? 0)) {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(content: Text("❌ পর্যাপ্ত ব্যালেন্স নেই! আপনার ওয়ালেটে ৳${walletBalance.toStringAsFixed(0)} আছে।")),
                //     );
                //     return;
                //   }
                //
                //   // ✅ API Call শুরু
                //   final url = Uri.parse("https://2db87a7fde03.ngrok-free.app/api/v1/packageorder");
                //
                //   // ✅ ডাটা তৈরি
                //   final body = {
                //     "topup_package_id": selectedPackageId , // ← global variable
                //     "product_id": widget.id,           // ← global variable
                //     "name": selectedPackageName,                      // ← global variable
                //     "playerid": playerId,
                //     "ingamepassword": ingamepassword,
                //     "securitycode": securitycode,
                //     "payment_method": payment_method,
                //   };
                //
                //   print("payment gateway url= $url 📦 Sending Order: $body");
                //
                //   try {
                //     final response = await http.post(
                //       url,
                //       headers: {"Content-Type": "application/json","Authorization": "Bearer $token"},
                //       body: jsonEncode(body),
                //     );
                //
                //     // if (response.statusCode == 200 || response.statusCode == 201) {
                //     //   // ScaffoldMessenger.of(context).showSnackBar(
                //     //     // const SnackBar(content: Text("✅ Order Confirmed Successfully!")),
                //     //   // );
                //     //   print(" success ----${response.body}");
                //     // }
                //
                //
                //
                //     if (response.statusCode == 200 || response.statusCode == 201) {
                //       final data = jsonDecode(response.body);
                //       final paymentUrl = data['data']?['payment_url'];
                //
                //
                //
                //       Navigator.pop(context);
                //
                //       if (paymentUrl != null) {
                //         print("🌐 Redirecting to Payment URL: $paymentUrl");
                //
                //         // ✅ dialog pop হওয়ার পরে একটুখানি delay দাও
                //         await Future.delayed(const Duration(milliseconds: 100));
                //
                //         // ✅ এইখানে mounted চেক দাও
                //         if (!mounted) return;
                //
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (_) => PaymentWebView(paymentUrl: paymentUrl),
                //           ),
                //         );
                //
                //       } else {
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           const SnackBar(content: Text("⚠️ Payment URL not found!")),
                //         );
                //       }
                //     }
                //
                //
                //     else {
                //       print("❌ API Error: ${response.body}");
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(content: Text("⚠️ Order Failed (${response.statusCode})")),
                //       );
                //     }
                //   } catch (e) {
                //     print("❌ Exception: $e");
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(content: Text("🚫 Network Error! আবার চেষ্টা করুন")),
                //     );
                //   }
                // },
                onPressed: () async {
                  // ✅ ব্যালেন্স চেক শুধু Wallet-এর জন্য
                  if (selectedPayment == "RRR Bazar Wallet" &&
                      walletBalance < (selectedPackagePrice ?? 0)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "❌ পর্যাপ্ত ব্যালেন্স নেই! আপনার ওয়ালেটে ৳${walletBalance.toStringAsFixed(0)} আছে।",
                        ),
                      ),
                    );
                    return;
                  }

                  // ✅ এখানে আসল Order API চালু হবে
                  final url = Uri.parse("${backendUrl}/api/v1/packageorder");

                  // ✅ ডাটা তৈরি
                  final body = {
                    "topup_package_id": selectedPackageId,
                    "product_id": widget.id,
                    "name": selectedPackageName,
                    "playerid": playerId,
                    "ingamepassword": ingamepassword,
                    "securitycode": securitycode,
                    "payment_method": payment_method,
                    // 1 = Wallet, 2 = Auto Payment
                  };

                  print("📦 Sending Order to $url");
                  print("📤 Request Body: $body");

                  try {
                    final response = await http.post(
                      url,
                      headers: {
                        "Content-Type": "application/json",
                        "Authorization": "Bearer $token",
                      },
                      body: jsonEncode(body),
                    );

                    // ✅ সফল হলে
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      final data = jsonDecode(response.body);
                      final paymentUrl = data['data']?['payment_url'];

                      // Navigator.pop(context);

                      if (paymentUrl != null &&
                          selectedPayment == "Auto Payment") {
                        // ✅ Auto Payment এর ক্ষেত্রে Payment WebView খুলবে
                        print("🌐 Redirecting to Payment URL: $paymentUrl");

                        await Future.delayed(const Duration(milliseconds: 100));
                        if (!mounted) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => PaymentWebView(paymentUrl: paymentUrl),
                          ),
                        );
                      } else {
                        print("✅ API response: ${response.body}");

                        // ✅ Snackbar স্ক্রিনের উপরে দেখানো
                        if (mounted) {
                          // ✅ ProfileProvider ইনিশিয়ালাইজ (listen:false কারণ আমরা শুধু কল করব)
                          final profileProvider =
                              Provider.of<UserProfileProvider>(
                                context,
                                listen: false,
                              );
                          // ✅ প্রোফাইল রিফ্রেশ (ওয়ালেট ব্যালেন্স আপডেটের জন্য)
                          await profileProvider.refreshProfile();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("✅ Order Confirmed Successfully!"),
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.only(
                                top: 20,
                                left: 10,
                                right: 10,
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }

                        // ✅ Future.microtask ব্যবহার করো — context stable হওয়ার পরে redirect করবে
                        Future.microtask(() async {
                          await Future.delayed(const Duration(seconds: 1));

                          if (context.mounted) {
                            Navigator.pushReplacementNamed(
                              context,
                              "/myOrdersPage",
                            );
                          }
                        });
                      }
                    } else {
                      print("❌ API Error: ${response.body}");
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("🚫 Network Error! আবার চেষ্টা করুন"),
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
                child: const Text(
                  "Confirm Order",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
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
          ),
    );
    print("🟢 After showDialog()");
  }

  // --- Payment Option Widget ---

  Widget paymentOption(String name, String imagePath) {
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
            color: isSelected ? Colors.blue : Colors.grey.shade400,
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(imagePath, height: 45),
            ),

            // 🔹 নিচের টেক্সট অংশ (সিলেক্ট করলে রঙ বদলাবে)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.white,
                // ✅ সিলেক্ট হলে ব্যাকগ্রাউন্ড নীল
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(4),
                ),
                border: Border(
                  top: BorderSide(
                    color: isSelected ? Colors.blue : Colors.grey.shade300,
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


  /////////////////////////////////////

  // Widget buildRechargeGrid() {
  //   return GridView.builder(
  //     itemCount: rechargePacks.length,
  //     shrinkWrap: true,
  //     // GridView parent অনুযায়ী adjust হবে
  //     physics: const NeverScrollableScrollPhysics(),
  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 2, // প্রতি Row তে 2টা Box
  //       crossAxisSpacing: 10,
  //       mainAxisSpacing: 10,
  //       // childAspectRatio: 2.4, // ✅ সামান্য কমানো হয়েছে যেন height একটু বাড়ে
  //       childAspectRatio: 2, // ✅ সামান্য কমানো হয়েছে যেন height একটু বাড়ে
  //     ),
  //     itemBuilder: (context, index) {
  //       bool isSelected = selectedPackIndex == index;
  //       final pack = rechargePacks[index];
  //
  //       return GestureDetector(
  //         // onTap: () => setState(() => selectedPackIndex = index),
  //         onTap: () {
  //           setState(() {
  //             selectedPackIndex = index;
  //             selectedPackagePrice = _convertToDouble(
  //               pack["price"],
  //             ); // ✅ এখানেই দাম আপডেট হচ্ছে
  //             selectedPackageName = pack["name"]; // চাইলে নামও রাখো
  //             selectedPackageId = pack["id"]; // চাইলে নামও রাখো
  //           });
  //         },
  //         child: AnimatedContainer(
  //           duration: const Duration(milliseconds: 200),
  //           margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
  //           padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
  //           decoration: BoxDecoration(
  //             color: isSelected ? Colors.blue[50] : Colors.white,
  //             border: Border.all(
  //               color: isSelected ? Colors.blue : Colors.grey.shade400,
  //               width: 1.3,
  //             ),
  //             borderRadius: BorderRadius.circular(4),
  //             boxShadow: [
  //               if (isSelected)
  //                 BoxShadow(
  //                   color: Colors.blue.withOpacity(0.2),
  //                   blurRadius: 6,
  //                   offset: const Offset(0, 3),
  //                 ),
  //             ],
  //           ),
  //
  //           // ✅ এখানে Flexible বাদ দিয়ে Center Column ব্যবহার করা হয়েছে
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               // 🟦 Title Text
  //               Text(
  //                 pack["name"] ?? "",
  //                 textAlign: TextAlign.center,
  //                 maxLines: 4, // সর্বোচ্চ ২ লাইন পর্যন্ত অনুমতি
  //                 overflow: TextOverflow.ellipsis,
  //                 style: const TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 14,
  //                   color: Colors.black87,
  //                   height: 1.2, // টেক্সটের line-height ঠিক রাখা হয়েছে
  //                 ),
  //               ),
  //
  //               const SizedBox(height: 4),
  //               const Divider(height: 6, thickness: 0.8),
  //
  //               // 🟩 Price Text
  //               Text(
  //                 "৳${pack["price"] ?? ""}",
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   color: Colors.lightBlueAccent[700],
  //                   fontWeight: FontWeight.w600,
  //                   fontSize: 13.5,
  //                   height: 1.3, // ✅ নিচে ডোবে না
  //                 ),
  //               ),
  //
  //               // Text(
  //               //   "pac id=${pack["id"] ?? ""}",
  //               //   textAlign: TextAlign.center,
  //               //   style: TextStyle(
  //               //     color: Colors.lightBlueAccent[700],
  //               //     fontWeight: FontWeight.w600,
  //               //     fontSize: 13.5,
  //               //     height: 1.3, // ✅ নিচে ডোবে না
  //               //   ),
  //               // ),
  //
  //               // Text(
  //               //   "product id=${pack["product_id"] ?? ""}",
  //               //   textAlign: TextAlign.center,
  //               //   style: TextStyle(
  //               //     color: Colors.lightBlueAccent[700],
  //               //     fontWeight: FontWeight.w600,
  //               //     fontSize: 13.5,
  //               //     height: 1.3, // ✅ নিচে ডোবে না
  //               //   ),
  //               // ),
  //
  //               // Text(
  //               //   "product id=${pack["product_id"] ?? ""}",
  //               //   textAlign: TextAlign.center,
  //               //   style: TextStyle(
  //               //     color: Colors.lightBlueAccent[700],
  //               //     fontWeight: FontWeight.w600,
  //               //     fontSize: 13.5,
  //               //     height: 1.3, // ✅ নিচে ডোবে না
  //               //   ),
  //               // ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }




  Widget buildRechargeGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // ছোট স্ক্রিন হলে childAspectRatio কমিয়ে দিচ্ছি
        double aspectRatio = constraints.maxWidth < 360 ? 1.6 : 2.0;

        return GridView.builder(
          itemCount: rechargePacks.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: (context, index) {
            bool isSelected = selectedPackIndex == index;
            final pack = rechargePacks[index];

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedPackIndex = index;
                  selectedPackagePrice = _convertToDouble(pack["price"]);
                  selectedPackageName = pack["name"];
                  selectedPackageId = pack["id"];
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[50] : Colors.white,
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey.shade400,
                    width: 1.3,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ✅ Title auto-adjust + no overflow
                    Flexible(
                      child: Text(
                        pack["name"] ?? "",
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          // height: 1.2,
                          height:1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),
                    const Divider(height: 6, thickness: 0.8),

                    // ✅ Price section (never overflows)
                    FittedBox(
                      child: Text(
                        "৳${pack["price"] ?? ""}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.lightBlueAccent[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }



  /////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final siteProvider = Provider.of<SiteProvider>(context);
    final site = siteProvider.siteData;
    final logoUrl = "$backendUrl/images/${site?.logo}";
    final userProvider = Provider.of<UserProvider>(context);
    final profileProvider = Provider.of<UserProfileProvider>(context);
    final profile =
        profileProvider.profileData?.data; // ✅ Dynamic wallet balance
    final double walletBalance = _convertToDouble(profile?.wallet);
    print("*********dynamic wallet balance= ${walletBalance}***********");

    final user = userProvider;
    // final selectedPack = rechargePacks[selectedPackIndex!];
    // final double selected_package_price = _convertToDouble(selectedPack["price"]);

    final bool isLoggedIn = user.isLoggedIn;
    // final bool canBuy = isLoggedIn &&
    //     ((selectedPayment == "RRR Bazar Wallet" && walletBalance > (selectedPackagePrice ?? 0) ) ||
    //         selectedPayment == "Auto Payment");

    // ✅ canBuy কন্ডিশন
    final bool canBuy =
        isLoggedIn &&
        (selectedPayment ==
                "Auto Payment" || // Auto Payment এ সবসময় buy করা যাবে
            (selectedPayment == "RRR Bazar Wallet" &&
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
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // very important!
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      const Icon(Icons.warning, color: Colors.orange, size: 30),
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
                          backgroundColor: Colors.blue,
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
                      const Icon(Icons.warning, color: Colors.orange),
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
                            MaterialPageRoute(builder: (_) => AddMoneyPage()),
                          );
                        },
                        child: const Text("Add Money"),
                      ),
                    ],
                  ),
                ),

              Center(child: Image.network(widget.image, width: 100)),
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

              Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "1",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Account Info",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                  ],
                ),
              ),

              SizedBox(height: 12),



              TextField(
                controller: playerIdController,
                decoration: InputDecoration(
                  labelText: "Enter Player ID",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                enabled: isLoggedIn, // ❌ লগইন না থাকলে টাইপ করা যাবে না
              ),

              const SizedBox(height: 20),

              //////////////////recharge pack ////////////////

              // const Text(
              //   "Select Recharge Pack",
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),

              Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "2",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Select Recharge Pack",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
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
                      "RRR Bazar Wallet",
                      "assets/wallet.png",
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
                  if (isLoggedIn && selectedPayment == "RRR Bazar Wallet")
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AddMoneyPage()),
                          );
                        },
                        icon: const Icon(Icons.add, color: Colors.blue),
                        label: const Text(
                          "Add Money",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            color: Colors.blue,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor:
                              canBuy ? Colors.blue : Colors.grey[400],
                          side: BorderSide(
                            color: canBuy ? Colors.blueAccent : Colors.grey,
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: canBuy ? 2 : 0,
                        ),
                        onPressed: canBuy ? _confirmOrder : null,
                        child: const Text(
                          "Buy Now",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              CustomFooter(),
            ],
          ),
        ),
      ),

      ////////////////////////////////////////////////////////////

      //////////////////// page without refreshing code is given bellow //////

      // body: SingleChildScrollView(
      //   padding: const EdgeInsets.all(16),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       // ⚠️ যদি user লগইন না করে থাকে তাহলে warning box দেখাও
      //       if (!isLoggedIn)
      //         Container(
      //           padding: const EdgeInsets.all(12),
      //           margin: const EdgeInsets.only(bottom: 20),
      //           decoration: BoxDecoration(
      //             color: Colors.amber[100],
      //             borderRadius: BorderRadius.circular(8),
      //             border: Border.all(color: Colors.orange),
      //           ),
      //           child: Row(
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               const Icon(Icons.warning, color: Colors.orange, size: 30),
      //               const SizedBox(width: 10),
      //               const Expanded(
      //                 child: Text(
      //                   "You must be logged in to order. Please login first.",
      //                   style: TextStyle(
      //                     fontWeight: FontWeight.w500,
      //                     color: Colors.black87,
      //                   ),
      //                 ),
      //               ),
      //               TextButton(
      //                 onPressed: () {
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(builder: (_) => const LoginScreen()),
      //                   );
      //                 },
      //                 style: TextButton.styleFrom(
      //                   backgroundColor: Colors.blue,
      //                   foregroundColor: Colors.white,
      //                   padding: const EdgeInsets.symmetric(
      //                       horizontal: 16, vertical: 8),
      //                 ),
      //                 child: const Text("Login"),
      //               ),
      //             ],
      //           ),
      //         ),
      //
      //       // ✅ Wallet Warning শুধু লগইনকৃত ইউজারদের জন্য
      //       if (isLoggedIn && walletBalance <= 0)
      //         Container(
      //           padding: const EdgeInsets.all(10),
      //           margin: const EdgeInsets.only(bottom: 20),
      //           decoration: BoxDecoration(
      //             color: Colors.amber[100],
      //             borderRadius: BorderRadius.circular(8),
      //             border: Border.all(color: Colors.amber),
      //           ),
      //           child: Row(
      //             children: [
      //               const Icon(Icons.warning, color: Colors.orange),
      //               const SizedBox(width: 8),
      //               const Expanded(
      //                 child: Text(
      //                   "Wallet balance নেই। প্রথমে Add Money করুন।",
      //                   style: TextStyle(color: Colors.black87),
      //                 ),
      //               ),
      //               TextButton(
      //                 onPressed: () {
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(builder: (_) =>  AddMoneyPage()),
      //                   );
      //                 },
      //                 child: const Text("Add Money"),
      //               ),
      //             ],
      //           ),
      //         ),
      //
      //       Center(child: Image.network(widget.image, width: 300)),
      //       const SizedBox(height: 10),
      //       Center(
      //         child: Text(
      //           widget.title,
      //           style:
      //           const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //         ),
      //       ),
      //
      //       const SizedBox(height: 20),
      //
      //       TextField(
      //         controller: playerIdController,
      //         decoration: InputDecoration(
      //           labelText: "Enter Player ID",
      //           border: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(10),
      //           ),
      //         ),
      //         enabled: isLoggedIn, // ❌ লগইন না থাকলে টাইপ করা যাবে না
      //       ),
      //
      //       const SizedBox(height: 20),
      //       const Text(
      //         "Select Recharge Pack",
      //         style: TextStyle(fontWeight: FontWeight.bold),
      //       ),
      //       buildRechargeGrid(),
      //
      //       const SizedBox(height: 20),
      //       const Text(
      //         "Select Payment Method",
      //         style: TextStyle(fontWeight: FontWeight.bold),
      //       ),
      //       const SizedBox(height: 10),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           paymentOption("RRR Bazar Wallet", "assets/wallet.png"),
      //           paymentOption("Auto Payment", "assets/auto_payment.jpeg"),
      //         ],
      //       ),
      //
      //       const SizedBox(height: 30),
      //
      //       Row(
      //         children: [
      //           // ✅ শুধুমাত্র লগইনকৃত ইউজার হলে Add Money দেখাও
      //           if (isLoggedIn && selectedPayment == "RRR Bazar Wallet")
      //             Expanded(
      //               child: ElevatedButton.icon(
      //                 onPressed: () {
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(builder: (_) =>  AddMoneyPage()),
      //                   );
      //                 },
      //                 icon: const Icon(Icons.add, color: Colors.blue),
      //                 label: const Text(
      //                   "Add Money",
      //                   style: TextStyle(
      //                       color: Colors.blue, fontWeight: FontWeight.w600),
      //                 ),
      //                 style: ElevatedButton.styleFrom(
      //                   minimumSize: const Size(double.infinity, 50),
      //                   backgroundColor: Colors.white,
      //                   side: const BorderSide(color: Colors.blue, width: 1.5),
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(8),
      //                   ),
      //                   elevation: 0,
      //                 ),
      //               ),
      //             ),
      //
      //           const SizedBox(width: 10),
      //
      //           // ✅ Buy Now Button (disabled if not logged in)
      //
      //           Expanded(
      //             child: Opacity(
      //               opacity: canBuy ? 1 : 0.5,
      //               child:
      //               ElevatedButton(
      //                 style: ElevatedButton.styleFrom(
      //                   minimumSize: const Size(double.infinity, 50),
      //                   backgroundColor:
      //                   canBuy ? Colors.blue : Colors.grey[400],
      //                   side: BorderSide(
      //                     color: canBuy ? Colors.blueAccent : Colors.grey,
      //                     width: 1.2,
      //                   ),
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(8),
      //                   ),
      //                   elevation: canBuy ? 2 : 0,
      //                 ),
      //                 onPressed: canBuy ? _confirmOrder : null,
      //                 child: const Text(
      //                   "Buy Now",
      //                   style: TextStyle(fontSize: 18, color: Colors.white),
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //
      //       const SizedBox(height: 30),
      //       CustomFooter(),
      //     ],
      //   ),
      // ),

      ////////////////////////////////////////////////////////////////
    );
  }
}
