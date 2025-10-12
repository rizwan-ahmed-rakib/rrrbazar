import 'package:flutter/material.dart';
import 'customdrawer.dart';
import 'footer.dart';
import 'home_screen.dart';

class MyTransactionsPage extends StatelessWidget {
  const MyTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example transactions. খালি list দিলে empty state দেখাবে

    // final List<Map<String, String>> transactions = [];

    // যদি transaction দেখাতে চাও:
    final List<Map<String, String>> transactions = List.generate(
      80,
      (index) => {
        "title": "Transaction #${index + 1}",
        "details": "Details about transaction #${index + 1}",
        "amount": "৳ ${(index + 1) * 100}"
      },
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
          if (transactions.isEmpty) {
            // =====================
            // যদি কোনো transaction না থাকে
            // =====================
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.account_balance_wallet_outlined,
                            size: 70, color: Colors.grey),
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
            // Transaction আছে → ListView + footer
            // =====================
            final listHeight = transactions.length * 90.0;

            if (listHeight + 70 < constraints.maxHeight) {
              // content কম → footer bottom
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final tx = transactions[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.account_balance_wallet,
                                color: Colors.blue),
                            title: Text(tx["title"]!),
                            subtitle: Text(tx["details"]!),
                            trailing: Text(
                              tx["amount"] ?? "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
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
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final tx = transactions[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.account_balance_wallet,
                                color: Colors.blue),
                            title: Text(tx["title"]!),
                            subtitle: Text(tx["details"]!),
                            trailing: Text(
                              tx["amount"] ?? "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
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
