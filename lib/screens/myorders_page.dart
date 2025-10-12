import 'package:flutter/material.dart';
import 'customdrawer.dart';
import 'footer.dart';
import 'home_screen.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example orders. খালি list দিলে "Sorry" দেখাবে

    // final List<Map<String, String>> orders = [];

    final List<Map<String, String>> orders = List.generate(
      50,
      (index) => {"title": "Order #${index + 1}", "details": "Order details here"},
    );

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // 🔥 ডিফল্ট Hamburger আইকন লুকিয়ে দিলাম
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                // 🏠 এখানে তোমার HomeScreen এ নিয়ে যাও
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Image.asset(
                "assets/logo.png",
                height: 30,
              ),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) {
              return InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer(); // ✅ Drawer open হবে
                },
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 400) {
                      // Mobile এ শুধু Image
                      return const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: CircleAvatar(
                          backgroundImage: AssetImage("assets/user.png"),
                        ),
                      );
                    } else {
                      // Tablet/Desktop এ Full Profile
                      return Row(
                        children: const [
                          CircleAvatar(backgroundImage: AssetImage("assets/user.png")),
                          SizedBox(width: 6),
                          Text("Hellowfarjan"),
                          Icon(Icons.arrow_drop_down),
                          SizedBox(width: 10),
                        ],
                      );
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (orders.isEmpty) {
            // =====================
            // যদি কোনো অর্ডার না থাকে
            // =====================
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.search, size: 70, color: Colors.grey),
                        SizedBox(height: 20),
                        Text(
                          "Sorry",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "We found nothing for you.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                 CustomFooter(),
              ],
            );
          } else {
            // =====================
            // অর্ডার আছে → ListView + footer
            // =====================
            final listHeight = orders.length * 90.0;

            if (listHeight + 70 < constraints.maxHeight) {
              // content কম → footer bottom
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.shopping_bag_outlined,
                                color: Colors.blue),
                            title: Text(order["title"]!),
                            subtitle: Text(order["details"]!),
                            trailing:
                            const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {},
                          ),
                        );
                      },
                    ),
                  ),
                   CustomFooter(),
                ],
              );
            } else {
              // content বেশি → scrollable
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.shopping_bag_outlined,
                                color: Colors.blue),
                            title: Text(order["title"]!),
                            subtitle: Text(order["details"]!),
                            trailing:
                            const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {},
                          ),
                        );
                      },
                    ),
                     CustomFooter(),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}
