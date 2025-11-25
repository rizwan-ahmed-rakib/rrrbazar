import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../provider/shared_local_storage.dart';
import '../provider/user_profile_provider.dart';
import 'payment_webview.dart';
import '../provider/base_url.dart';
import '../provider/site_provider.dart';
import '../provider/user_provider.dart';
import 'custom_app_bar.dart';
import 'customdrawer.dart';
import 'footer.dart';
import 'home_screen.dart';

class AddMoneyPage extends StatefulWidget {
  @override
  State<AddMoneyPage> createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage> {
  int selectedMethod = -1;
  bool showRequestStep = false;
  TextEditingController amountController = TextEditingController();

  final List<Map<String, String>> paymentMethods = [
    {
      "name": "Fast Add Money",
      "image": "https://api.rrrbazar.com/images/images-1663084868254.jpg"
    },
  ];

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
    final user = userProvider;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar( logoUrl: logoUrl, isLoggedIn: user.isLoggedIn,),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // ===== Scrollable অংশ =====
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ---------- Step 1 ----------
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header
                                Container(
                                  decoration: BoxDecoration(
                                    // color: Colors.lightBlueAccent,
                                    color: bgColor,
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
                                        "Select Payment Method",
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
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: paymentMethods.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 1.0,
                                  ),
                                  itemBuilder: (context, index) {
                                    final method = paymentMethods[index];
                                    final isSelected = selectedMethod == index;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedMethod = index;
                                          showRequestStep = true;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                              color: isSelected
                                                  // ? Colors.blue.shade600
                                                  ? bgColor.withOpacity(0.6)
                                                  : Colors.grey.shade300,
                                              width: 2),
                                          gradient: isSelected
                                              ? LinearGradient(
                                              colors: [
                                                // Colors.blue.shade300,
                                                // Colors.blue.shade500
                                                bgColor.withOpacity(0.5),
                                                bgColor.withOpacity(0.7)
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter)
                                              : null,
                                        ),

                                        //////////////////////////////

                                        // child: Column(
                                        //   mainAxisAlignment: MainAxisAlignment.center,
                                        //   children: [
                                        //     Image.network(
                                        //       method["image"]!,
                                        //       width: 180,
                                        //       height: 160,
                                        //     ),
                                        //
                                        //     // SizedBox(height: 8),
                                        //
                                        //     Row(
                                        //       mainAxisAlignment: MainAxisAlignment.center,
                                        //       children: [
                                        //         Flexible(
                                        //           child: Text(
                                        //             method["name"]!,
                                        //             textAlign: TextAlign.center,
                                        //             style: TextStyle(
                                        //                 color: isSelected
                                        //                     ? Colors.white
                                        //                     : Colors.black,
                                        //                 fontWeight: FontWeight.w600),
                                        //           ),
                                        //         ),
                                        //         if (isSelected) ...[
                                        //           SizedBox(width: 4),
                                        //           Icon(Icons.check_circle,
                                        //               color: Colors.white, size: 20),
                                        //         ],
                                        //       ],
                                        //     ),
                                        //   ],
                                        // ),

                                        //////////////////////////////

                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // 🖼️ Responsive image — সব স্ক্রিনে ঠিকভাবে দেখা যাবে
                                            Flexible(
                                              flex: 3,
                                              child: Padding(
                                                padding: const EdgeInsets.all(6),
                                                child: Image.network(
                                                  method["image"] ?? "",
                                                  width: MediaQuery.of(context).size.width * 0.4, // স্ক্রিন অনুযায়ী width
                                                  height: MediaQuery.of(context).size.width * 0.28, // responsive height
                                                  fit: BoxFit.contain, // image কাটা যাবে না
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return const Icon(Icons.broken_image, color: Colors.grey);
                                                  },
                                                ),
                                              ),
                                            ),

                                            const SizedBox(height: 6),

                                            // 🔹 Text + Check icon row
                                            Flexible(
                                              flex: 1,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      method["name"] ?? "",
                                                      textAlign: TextAlign.center,
                                                      overflow: TextOverflow.ellipsis, // বড় নাম হলে ... দেখাবে
                                                      maxLines: 2, // সর্বোচ্চ ২ লাইন
                                                      style: TextStyle(
                                                        color: isSelected ? Colors.white : Colors.black,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 14,
                                                        height: 1.2, // লাইন স্পেস ঠিক রাখবে
                                                      ),
                                                    ),
                                                  ),
                                                  if (isSelected) ...[
                                                    const SizedBox(width: 4),
                                                    const Icon(Icons.check_circle, color: Colors.white, size: 18),
                                                    // Icon(Icons.check_circle, color: bgColor, size: 18),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),



                                        //////////////////////////////
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20),

                          // ---------- Step 2 ----------
                          if (showRequestStep)
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      // color: Colors.lightBlueAccent,
                                      color: bgColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 14,
                                          backgroundColor: Colors.transparent,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white, width: 2),
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
                                          "Request Add Money",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  TextField(
                                    controller: amountController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "Amount",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () async {
                                      // ✅ Validation check
                                      if (amountController.text.isEmpty || selectedMethod == -1) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Please select a method and enter amount"),
                                          ),
                                        );
                                        return;
                                      }

                                      // ✅ Data প্রস্তুত
                                      final double amount = double.tryParse(amountController.text.trim()) ?? 0;
                                      // final int paymentMethod = selectedMethod; // e.g. 1=Wallet, 2=Auto Payment
                                      final int paymentMethod = 2; // e.g. 1=Wallet, 2=Auto Payment
                                      const String purpose = "addwallet";

                                      // ✅ Token নিতে হবে (ধরা যাক SharedPreferences এ সংরক্ষিত)
                                      final token = await getTokenFromLocalStorage();

                                      if (token == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("⚠️ Please login again! Token missing.")),
                                        );
                                        return;
                                      }

                                      // ✅ API Endpoint
                                      final url = Uri.parse("${backendUrl}/api/v1/addwallet");

                                      // ✅ Body তৈরি
                                      final body = {
                                        "purpose": purpose,
                                        "amount": amount,
                                        "payment_method": paymentMethod,
                                      };

                                      // ✅ Loading indicator দেখানো
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => const Center(child: CircularProgressIndicator()),
                                      );

                                      try {
                                        print("✅ POST request sending to $url");
                                        // ✅ POST request পাঠানো
                                        final response = await http.post(
                                          url,
                                          headers: {
                                            "Content-Type": "application/json",
                                            "Authorization": "Bearer $token",
                                          },
                                          body: jsonEncode(body),
                                        );

                                        Navigator.pop(context); // 🔹 Loading বন্ধ করো

                                        print("payment gateway url= $url 📦 Sending Order: $body");


                                        if (response.statusCode == 200 || response.statusCode == 201) {
                                          final data = jsonDecode(response.body);
                                          final paymentUrl = data['data']?['payment_url'];

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => PaymentWebView(paymentUrl: paymentUrl),
                                            ),
                                          );

                                          // ✅ যদি backend থেকে payment_url ফেরত আসে

                                        } else {
                                          print("❌ Error Response: ${response.body}");
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("❌ Failed: ${response.statusCode}")),
                                          );
                                        }
                                      } catch (e) {
                                        Navigator.pop(context); // 🔹 Loading বন্ধ করো
                                        print("🚫 Exception: $e");
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Network error! Please try again.")),
                                        );
                                      }
                                    },



                                    child: Text(
                                      "Add Money",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      // backgroundColor: Colors.lightBlueAccent,
                                      backgroundColor: bgColor,
                                      minimumSize: Size(double.infinity, 45),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // ===== Footer সবসময় নিচে থাকবে =====
                  // CustomFooter(),

                  // 🔹 Keyboard ওপেন থাকলে footer লুকিয়ে ফেলো
                  if (!isKeyboardOpen) const CustomFooter(),


                ],
              ),
            ),
          );
        },
      ),


    );
  }
}




/////////////////////////////////////


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../provider/user_profile_provider.dart';
// import 'payment_webview.dart';
// import '../provider/base_url.dart';
// import '../provider/site_provider.dart';
// import '../provider/user_provider.dart';
// import 'custom_app_bar.dart';
// import 'customdrawer.dart';
// import 'footer.dart';
// import 'home_screen.dart';
//
// class AddMoneyPage extends StatefulWidget {
//   @override
//   State<AddMoneyPage> createState() => _AddMoneyPageState();
// }
//
// class _AddMoneyPageState extends State<AddMoneyPage> {
//   int selectedMethod = -1;
//   bool showRequestStep = false;
//   TextEditingController amountController = TextEditingController();
//
//   final List<Map<String, String>> paymentMethods = [
//     {
//       "name": "Fast Add Money",
//       "image": "https://api.rrrbazar.com/images/images-1663084868254.jpg"
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final siteProvider = Provider.of<SiteProvider>(context);
//     final site = siteProvider.siteData;
//     final logoUrl = "$backendUrl/images/${site?.logo}";
//     final userProvider = Provider.of<UserProvider>(context);
//     final user = userProvider;
//
//     return Scaffold(
//       drawer: CustomDrawer(),
//       appBar: CustomAppBar(
//         logoUrl: logoUrl,
//         isLoggedIn: user.isLoggedIn,
//       ),
//
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           // আনুমানিক কনটেন্টের উচ্চতা বের করা
//           final contentHeight = showRequestStep ? 800.0 : 500.0;
//
//           // যদি কনটেন্ট ছোট হয় → footer নিচে স্থির থাকবে
//           if (contentHeight + 100 < constraints.maxHeight) {
//             return Column(
//               children: [
//                 Expanded(child: _buildMainContent(context)),
//                 const CustomFooter(),
//               ],
//             );
//           }
//           // অনেক কনটেন্ট থাকলে scrollable হবে এবং footer নিচে স্ক্রলে আসবে
//           else {
//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   _buildMainContent(context),
//                   const CustomFooter(),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   // 🔹 আলাদা করে মূল কনটেন্ট অংশটা তৈরি করেছি যাতে কোড পরিষ্কার থাকে
//   Widget _buildMainContent(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ---------- Step 1 ----------
//           _buildStep1(),
//
//           const SizedBox(height: 20),
//
//           // ---------- Step 2 ----------
//           if (showRequestStep) _buildStep2(context),
//         ],
//       ),
//     );
//   }
//
//   // 🔹 Step 1: Select Payment Method
//   Widget _buildStep1() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildHeader("1", "Select Payment Method"),
//           const SizedBox(height: 12),
//           GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: paymentMethods.length,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               mainAxisSpacing: 10,
//               crossAxisSpacing: 10,
//               childAspectRatio: 1.0,
//             ),
//             itemBuilder: (context, index) {
//               final method = paymentMethods[index];
//               final isSelected = selectedMethod == index;
//               return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     selectedMethod = index;
//                     showRequestStep = true;
//                   });
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                         color: isSelected
//                             ? Colors.blue.shade600
//                             : Colors.grey.shade300,
//                         width: 2),
//                     gradient: isSelected
//                         ? LinearGradient(
//                         colors: [
//                           Colors.blue.shade300,
//                           Colors.blue.shade500
//                         ],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter)
//                         : null,
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.network(
//                         method["image"]!,
//                         width: 90,
//                         height: 90,
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Flexible(
//                             child: Text(
//                               method["name"]!,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: isSelected
//                                     ? Colors.white
//                                     : Colors.black,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                           if (isSelected) ...[
//                             const SizedBox(width: 4),
//                             const Icon(Icons.check_circle,
//                                 color: Colors.white, size: 20),
//                           ],
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   // 🔹 Step 2: Request Add Money
//   Widget _buildStep2(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildHeader("2", "Request Add Money"),
//           const SizedBox(height: 12),
//           TextField(
//             controller: amountController,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               labelText: "Amount",
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           ElevatedButton(
//             onPressed: () => _handleAddMoney(context),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.lightBlueAccent,
//               minimumSize: const Size(double.infinity, 45),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: const Text(
//               "Add Money",
//               style: TextStyle(
//                   color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // 🔹 Common Header Builder
//   Widget _buildHeader(String step, String title) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.lightBlueAccent,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 14,
//             backgroundColor: Colors.transparent,
//             child: Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: Colors.white, width: 2),
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 step,
//                 style: const TextStyle(
//                     color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Text(
//             title,
//             style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // 🔹 Handle Add Money Function
//   Future<void> _handleAddMoney(BuildContext context) async {
//     if (amountController.text.isEmpty || selectedMethod == -1) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please select a method and enter amount"),
//         ),
//       );
//       return;
//     }
//
//     final double amount =
//         double.tryParse(amountController.text.trim()) ?? 0;
//     const int paymentMethod = 2;
//     const String purpose = "addwallet";
//
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');
//
//     if (token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("⚠️ Please login again! Token missing.")),
//       );
//       return;
//     }
//
//     final url = Uri.parse("${backendUrl}/api/v1/addwallet");
//     final body = {
//       "purpose": purpose,
//       "amount": amount,
//       "payment_method": paymentMethod,
//     };
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const Center(child: CircularProgressIndicator()),
//     );
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode(body),
//       );
//
//       Navigator.pop(context); // loading বন্ধ করো
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         final paymentUrl = data['data']?['payment_url'];
//
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => PaymentWebView(paymentUrl: paymentUrl),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("❌ Failed: ${response.statusCode}")),
//         );
//       }
//     } catch (e) {
//       Navigator.pop(context);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Network error! Please try again.")),
//       );
//     }
//   }
// }
