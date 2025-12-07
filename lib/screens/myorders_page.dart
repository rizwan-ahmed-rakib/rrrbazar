import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/order_model.dart';
import '../provider/base_url.dart' show backendUrl;
import '../provider/site_provider.dart';
import '../provider/order_provider.dart';
import '../provider/user_provider.dart';
import 'custom_app_bar.dart';
import 'customdrawer.dart';
import 'footer.dart';
import 'home_screen.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  @override
  void initState() {
    super.initState();

    // ✅ পেজ লোড হওয়ার সাথে সাথে অর্ডার ডেটা ফেচ হবে
    Future.microtask(() {
      Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final siteProvider = Provider.of<SiteProvider>(context);
    final site = siteProvider.siteData;
    final logoUrl = "$backendUrl/images/${site?.logo}";
    final orderProvider = Provider.of<OrderProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider;

    return Scaffold(
      drawer:  CustomDrawer(),
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Row(
      //     children: [
      //       GestureDetector(
      //         onTap: () => Navigator.pushReplacement(
      //           context,
      //           MaterialPageRoute(builder: (context) =>  HomeScreen()),
      //         ),
      //         child: Image.network(logoUrl, height: 30),
      //       ),
      //     ],
      //   ),
      //   actions: [
      //     Builder(
      //       builder: (context) {
      //         return InkWell(
      //           onTap: () => Scaffold.of(context).openDrawer(),
      //           child: const Padding(
      //             padding: EdgeInsets.only(right: 10),
      //             child: CircleAvatar(
      //               backgroundImage: AssetImage("assets/user.png"),
      //             ),
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      // ),



      appBar: CustomAppBar( logoUrl: logoUrl, isLoggedIn: user.isLoggedIn,),







      body: Builder(
        builder: (context) {
          if (orderProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (orderProvider.hasError) {
            return _errorView(context);
          } else if (orderProvider.orders.isEmpty) {
            return _emptyView();
          }

          // ✅ শুধু একটি layout - Footer সবসময় content-এর পরে
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height, // ✅ Minimum screen height
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "My Orders",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: orderProvider.orders
                              .map((order) => _buildOrderCard(order))
                              .toList(),
                        ),
                      ),
                    ],
                  ),

                  // ✅ Footer সবসময় নিচে (কম elements থাকলে screen-এর নিচে, বেশি থাকলে content-এর পরে)
                  const CustomFooter(),
                ],
              ),
            ),
          );
        },
      ),

    );
  }

  Widget _voucherBox(String voucherCode) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              voucherCode,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),

          // Copy Icon
          IconButton(
            icon: const Icon(Icons.copy, size: 20),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: voucherCode));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Voucher copied!"),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }


  // 🔹 প্রতিটি অর্ডার কার্ড ডিজাইন

  // Widget _buildOrderCard(OrderModel order) {
  //   final isCompleted = order.status.toLowerCase() == "completed";
  //   final isCancelled = order.status.toLowerCase() == "cancel";
  //   final hasVoucher = order.voucher != null && order.voucher!.isNotEmpty;
  //
  //   // final color = isCompleted
  //   //     ? Colors.green.shade100
  //   //     : isCancelled
  //   //     ? Colors.red.shade100
  //   //     : Colors.orange.shade100;
  //
  //
  //   final color = isCompleted
  //       ? Colors.green.shade100
  //       : isCancelled
  //       ? Colors.red.shade100
  //       : Colors.orange.shade100;
  //
  //   final textColor = isCompleted
  //       ? Colors.green.shade700
  //       : isCancelled
  //       ? Colors.red.shade700
  //       : Colors.orange.shade700;
  //
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 12),
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: Colors.grey.shade300),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.03),
  //           blurRadius: 3,
  //           offset: const Offset(0, 1),
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               _orderLine("Order ID:", order.id),
  //               _orderLine("Date:", order.date),
  //               // _orderLine("Name:", order.name),
  //               _orderLine("Total Price:", "${order.amount}৳"),
  //               _orderLine("Player ID:", order.playerId),
  //               // _orderLine(
  //               //   "Package Name:",
  //               //   order.topupProduct != null ? order.topupProduct!.name : "N/A",
  //               // ),
  //               _orderLine("Package Name:", order.name),
  //
  //
  //               // 🔥 Voucher থাকলে কেবল তখনই দেখাও
  //
  //               if (order.voucher != null) ...[
  //                 const SizedBox(height: 6),
  //                 // _voucherBox(order.voucher!)
  //                 _orderLine("Voucher:",order.voucher!)
  //               ],
  //
  //
  //             ],
  //           ),
  //         ),
  //         const SizedBox(width: 8),
  //         Container(
  //           alignment: Alignment.center,
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //           decoration: BoxDecoration(
  //             color: hasVoucher ? Colors.blue.shade100 : color,
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           child: Text(
  //             hasVoucher ? "Redeem Code" : order.status, // ✅ এখানে পরিবর্তন
  //
  //             // style: TextStyle(
  //             //   fontSize: 13,
  //             //   color: isCompleted
  //             //       ? Colors.green.shade700
  //             //       : isCancelled
  //             //       ? Colors.red.shade700
  //             //       : Colors.orange.shade700,
  //             //   fontWeight: FontWeight.w500,
  //             // ),
  //
  //             style: TextStyle(
  //               fontSize: 13,
  //               color: hasVoucher ? Colors.green.shade700 : textColor,
  //               fontWeight: FontWeight.w500,
  //             ),
  //
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }



  Widget _buildOrderCard(OrderModel order) {
    final isCompleted = order.status.toLowerCase() == "completed";
    final isCancelled = order.status.toLowerCase() == "cancel";
    final hasVoucher = order.voucher != null && order.voucher!.isNotEmpty;

    final color = isCompleted
        ? Colors.green.shade100
        : isCancelled
        ? Colors.red.shade100
        : Colors.orange.shade100;

    final textColor = isCompleted
        ? Colors.green.shade700
        : isCancelled
        ? Colors.red.shade700
        : Colors.orange.shade700;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _orderLine("Order ID:", order.id),
                _orderLine("Date:", order.date),
                _orderLine("Total Price:", "${order.amount}৳"),
                if (!hasVoucher) ...[
                  _orderLine("Player ID:", order.playerId),

                ],
                _orderLine("Package Name:", order.name),

                // 🔥 Voucher থাকলে "Redeem Code" section দেখাও
                if (hasVoucher) ...[
                  const SizedBox(height: 6),
                  _orderLine("Voucher:",order.voucher!),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),

          // ✅ Voucher থাকলে "Redeem Code" দেখাবে, না থাকলে status

          // Container(
          //   alignment: Alignment.center,
          //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          //   decoration: BoxDecoration(
          //     color: hasVoucher ? Colors.green.shade400 : color,
          //     borderRadius: BorderRadius.circular(20),
          //   ),
          //   child: Text(
          //     hasVoucher ? "Reedeem Code" : order.status, // ✅ এখানে পরিবর্তন
          //     style: TextStyle(
          //       fontSize: 13,
          //       color: hasVoucher ? Colors.blue.shade700 : textColor,
          //       fontWeight: FontWeight.w500,
          //     ),
          //   ),
          // ),


          GestureDetector(
            onTap: hasVoucher
                ? () {
              // ✅ Voucher থাকলে link এ নিয়ে যাবে

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => VoucherDetailsPage(
              //       voucherCode: order.voucher!,
              //       orderId: order.id,
              //     ),
              //   ),
              // );

              // অথবা যদি Web URL এ নিয়ে যেতে চাও:
              launchUrl(Uri.parse("https://shop.garena.my/"));
            }
                : null, // ✅ Voucher না থাকলে clickable হবে না
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: hasVoucher ? Colors.green.shade400 : color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                hasVoucher ? "Redeem Code" : order.status,
                style: TextStyle(
                  fontSize: 13,
                  color: hasVoucher ? Colors.white : textColor, // ✅ সাদা রঙ দেখাবে
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }







///// selected /////////////

  Widget _orderLine(String title, dynamic value) {
    bool isVoucher = title.toLowerCase().contains("voucher");

    // 🔥 Voucher হলে আলাদা সুন্দর UI
    if (isVoucher && value != null && value.toString().isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Text(
              "$title ",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),

            // 🔥 Voucher Text Container (Fixed width based on text length)
            Flexible( // ✅ Flexible instead of Expanded
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6, // ✅ Maximum width
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Text(
                  value.toString(),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 6),

            // Copy Button (Now properly on the right)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: value.toString()));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Voucher copied!"),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green.shade400,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.copy, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
      );
    }

    // 🔹 Default Line (non-voucher)
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
          text: "$title ",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          children: [
            TextSpan(
              text: value?.toString() ?? '',
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }



  // Widget _orderLine(String title, dynamic value) {
  //   bool isVoucher = title.toLowerCase().contains("voucher");
  //
  //   if (isVoucher && value != null && value.toString().isNotEmpty) {
  //     return Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 6),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween, // ✅ সারি জুড়ে স্পেস
  //         children: [
  //           // Label (Title)
  //           Text(
  //             "$title:",
  //             style: const TextStyle(
  //               color: Colors.black,
  //               fontWeight: FontWeight.w600,
  //               fontSize: 14,
  //             ),
  //           ),
  //
  //           const SizedBox(width: 8),
  //
  //           // Voucher Code Container (Flexible width)
  //           Expanded(
  //             child: Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //               decoration: BoxDecoration(
  //                 color: Colors.green.shade100,
  //                 borderRadius: BorderRadius.circular(8),
  //                 border: Border.all(color: Colors.green.shade300),
  //               ),
  //               child: Center(
  //                 child: Text(
  //                   value.toString(),
  //                   textAlign: TextAlign.center,
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w500,
  //                     color: Colors.black87,
  //                     fontFamily: 'Monospace',
  //                     letterSpacing: 0.5,
  //                   ),
  //                   overflow: TextOverflow.ellipsis,
  //                   maxLines: 1,
  //                 ),
  //               ),
  //             ),
  //           ),
  //
  //           const SizedBox(width: 8),
  //
  //           // Copy Button
  //           GestureDetector(
  //             onTap: () {
  //               Clipboard.setData(ClipboardData(text: value.toString()));
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 const SnackBar(
  //                   content: Text("Voucher copied!"),
  //                   duration: Duration(seconds: 1),
  //                 ),
  //               );
  //             },
  //             child: Container(
  //               padding: const EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 color: Colors.green.shade400,
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: const Icon(Icons.copy, color: Colors.white, size: 18),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //
  //   // 🔹 Default Line (non-voucher)
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           "$title:",
  //           style: const TextStyle(
  //             color: Colors.black,
  //             fontWeight: FontWeight.w600,
  //             fontSize: 14,
  //           ),
  //         ),
  //         const SizedBox(width: 8),
  //         Expanded(
  //           child: Text(
  //             value?.toString() ?? '',
  //             style: const TextStyle(
  //               color: Colors.black87,
  //               fontWeight: FontWeight.normal,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  //////////////////////

  // Widget _orderLine(String title, dynamic value) {
  //   bool isVoucher = title.toLowerCase().contains("voucher");
  //
  //   if (isVoucher && value != null && value.toString().isNotEmpty) {
  //     final voucherText = value.toString();
  //
  //     return Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 4),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Label
  //           Text(
  //             "$title ",
  //             style: const TextStyle(
  //               color: Colors.black,
  //               fontWeight: FontWeight.w600,
  //               fontSize: 14,
  //             ),
  //           ),
  //
  //           // 🔥 Voucher Text (IntrinsicWidth ব্যবহার করে)
  //           IntrinsicWidth(
  //             child: Container(
  //               // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  //               padding: const EdgeInsets.symmetric( vertical: 6),
  //               decoration: BoxDecoration(
  //                 color: Colors.green.shade100,
  //                 borderRadius: BorderRadius.circular(6),
  //                 border: Border.all(color: Colors.green.shade300),
  //               ),
  //               child: Text(
  //                 voucherText,
  //                 style: const TextStyle(
  //                   color: Colors.black87,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //             ),
  //           ),
  //
  //           const SizedBox(width: 6),
  //
  //           // Copy Button
  //           GestureDetector(
  //             onTap: () {
  //               Clipboard.setData(ClipboardData(text: voucherText));
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 const SnackBar(
  //                   content: Text("Voucher copied!"),
  //                   duration: Duration(seconds: 1),
  //                 ),
  //               );
  //             },
  //             child: Container(
  //               padding: const EdgeInsets.all(6),
  //               decoration: BoxDecoration(
  //                 color: Colors.green.shade400,
  //                 borderRadius: BorderRadius.circular(6),
  //               ),
  //               child: const Icon(Icons.copy, color: Colors.white, size: 16),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //
  //   // 🔹 Default Line (non-voucher)
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 2),
  //     child: RichText(
  //       text: TextSpan(
  //         text: "$title ",
  //         style: const TextStyle(
  //           color: Colors.black,
  //           fontWeight: FontWeight.w600,
  //           fontSize: 14,
  //         ),
  //         children: [
  //           TextSpan(
  //             text: value?.toString() ?? '',
  //             style: const TextStyle(
  //               color: Colors.black87,
  //               fontWeight: FontWeight.normal,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }



// 🔥 Voucher Widget

  Widget _buildVoucherWidget(String voucherText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              voucherText,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: voucherText));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Voucher copied!"),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.green.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.copy, color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }


  Widget _emptyView() {
    return Column(
      children: const [
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search, size: 70, color: Colors.grey),
                SizedBox(height: 20),
                Text("Sorry",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text("You don’t have any orders yet.",
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          ),
        ),
        CustomFooter(),
      ],
    );
  }

  // 🔹 এরর ভিউ
  Widget _errorView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 12),
          const Text("Something went wrong!",
              style: TextStyle(fontSize: 18, color: Colors.red)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Provider.of<OrderProvider>(context, listen: false).refreshOrders();
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}




