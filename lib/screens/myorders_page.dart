import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order_model.dart';
import '../provider/base_url.dart' show backendUrl;
import '../provider/site_provider.dart';
import '../provider/order_provider.dart';
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

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>  HomeScreen()),
              ),
              child: Image.network(logoUrl, height: 30),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) {
              return InkWell(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/user.png"),
                  ),
                ),
              );
            },
          ),
        ],
      ),

      body: Builder(
        builder: (context) {
          if (orderProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (orderProvider.hasError) {
            return _errorView(context);
          } else if (orderProvider.orders.isEmpty) {
            return _emptyView();
          }

          // ✅ ডেটা সফলভাবে লোড হলে
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "My Orders",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: orderProvider.orders
                            .map((order) => _buildOrderCard(order))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const CustomFooter(), // ✅ Footer সবসময় নিচে থাকবে
            ],
          );
        },
      ),
    );
  }

  // 🔹 প্রতিটি অর্ডার কার্ড ডিজাইন
  Widget _buildOrderCard(OrderModel order) {
    final isCompleted = order.status.toLowerCase() == "completed";
    final isCancelled = order.status.toLowerCase() == "cancel";
    final color = isCompleted
        ? Colors.green.shade100
        : isCancelled
        ? Colors.red.shade100
        : Colors.orange.shade100;

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
                _orderLine("Name:", order.name),
                _orderLine("Total Price:", "${order.amount}৳"),
                _orderLine("Player ID:", order.playerId),
                _orderLine(
                  "Package Name:",
                  order.topupProduct != null ? order.topupProduct!.name : "N/A",
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              order.status,
              style: TextStyle(
                fontSize: 13,
                color: isCompleted
                    ? Colors.green.shade700
                    : isCancelled
                    ? Colors.red.shade700
                    : Colors.orange.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 প্রতিটি লাইন স্টাইল

  Widget _orderLine(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
          text: "$title ",
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
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


