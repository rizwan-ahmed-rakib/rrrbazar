import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../provider/user_provider.dart';
import '../provider/user_transaction_provider.dart';
import '../provider/base_url.dart';
import '../provider/site_provider.dart';
import 'custom_app_bar.dart';
import 'customdrawer.dart';
import 'footer.dart';
import 'home_screen.dart';

class MyTransactionsPage extends StatefulWidget {
  const MyTransactionsPage({super.key});

  @override
  State<MyTransactionsPage> createState() => _MyTransactionsPageState();
}

class _MyTransactionsPageState extends State<MyTransactionsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<UserTransactionProvider>(context, listen: false)
            .fetchTransactions());
  }

  @override
  Widget build(BuildContext context) {
    final siteProvider = Provider.of<SiteProvider>(context);
    final site = siteProvider.siteData;
    final logoUrl = "$backendUrl/images/${site?.logo}";
    final txProvider = Provider.of<UserTransactionProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider;

    return Scaffold(
      drawer:  CustomDrawer(),
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Row(
      //     children: [
      //       GestureDetector(
      //         onTap: () {
      //           Navigator.pushReplacement(
      //             context,
      //             MaterialPageRoute(builder: (context) =>  HomeScreen()),
      //           );
      //         },
      //         child: Image.network(logoUrl, height: 30),
      //       ),
      //     ],
      //   ),
      //   actions: [
      //     Builder(
      //       builder: (context) {
      //         return InkWell(
      //           onTap: () {
      //             Scaffold.of(context).openDrawer();
      //           },
      //           child: LayoutBuilder(
      //             builder: (context, constraints) {
      //               if (constraints.maxWidth < 400) {
      //                 return const Padding(
      //                   padding: EdgeInsets.only(right: 10),
      //                   child: CircleAvatar(
      //                     backgroundImage: AssetImage("assets/user.png"),
      //                   ),
      //                 );
      //               } else {
      //                 return Row(
      //                   children: const [
      //                     CircleAvatar(
      //                         backgroundImage: AssetImage("assets/user.png")),
      //                     SizedBox(width: 6),
      //                     Text("Hello Farjan"),
      //                     Icon(Icons.arrow_drop_down),
      //                     SizedBox(width: 10),
      //                   ],
      //                 );
      //               }
      //             },
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      // ),


      appBar: CustomAppBar( logoUrl: logoUrl, isLoggedIn: user.isLoggedIn,),



      // 🔥 Stack ব্যবহার করা হয়েছে Footer নিচে রাখার জন্য
      // body: Stack(
      //   children: [
      //     // 🔹 মূল কনটেন্ট
      //     txProvider.isLoading
      //         ? const Center(child: CircularProgressIndicator())
      //         : txProvider.hasError
      //         ? const Center(child: Text("❌ ডাটা লোড ব্যর্থ হয়েছে"))
      //         : txProvider.transactions.isEmpty
      //         ? Column(
      //       children: const [
      //         Expanded(
      //           child: Center(
      //             child: Text(
      //               "কোন ট্রান্সাকশন পাওয়া যায়নি",
      //               style: TextStyle(fontSize: 16),
      //             ),
      //           ),
      //         ),
      //         CustomFooter(), // ✅ Footer নিচে থাকবে
      //       ],
      //     )
      //         : Padding(
      //       padding: const EdgeInsets.only(bottom: 70),
      //       // Footer এর জায়গা রেখে Scrollable কনটেন্ট
      //       child: SingleChildScrollView(
      //         padding: const EdgeInsets.all(16),
      //         child:
      //         _buildTransactionTable(txProvider.transactions),
      //       ),
      //     ),
      //
      //     // 🔹 Footer নিচে স্থির থাকবে (সব সময় দৃশ্যমান বা শেষে দেখা যাবে)
      //     const Align(
      //       alignment: Alignment.bottomCenter,
      //       child: CustomFooter(),
      //     ),
      //   ],
      // ),


      body: Builder(
        builder: (context) {
          if (txProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (txProvider.hasError) {
            return _errorView(context);
          } else if (txProvider.transactions.isEmpty) {
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
                            "My Transactions",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Padding(
                      //   padding: const EdgeInsets.all(16),
                      //   child: Column(
                      //     children: orderProvider.orders
                      //         .map((order) => _buildOrderCard(order))
                      //         .toList(),
                      //   ),
                      // ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 70),
                        // Footer এর জায়গা রেখে Scrollable কনটেন্ট
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child:
                          _buildTransactionTable(txProvider.transactions),
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
                Text("You don’t have any transaction yet.",
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
              Provider.of<UserTransactionProvider>(context, listen: false).refreshTransactions();
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTable(List<UserTransaction> transactions) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStatePropertyAll(Colors.grey.shade100),
        border: TableBorder.all(color: Colors.grey.shade300, width: 0.8),
        columns: const [
          DataColumn(label: Text("Amount")),
          DataColumn(label: Text("Number")),
          DataColumn(label: Text("Status")),
          DataColumn(label: Text("Date")),
        ],
        rows: transactions.map((tx) {
          final isCompleted = tx.status.toLowerCase() == "completed";
          return DataRow(cells: [
            DataCell(Text(tx.amount.toString())),
            DataCell(Text(tx.number)),
            DataCell(
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tx.status,
                  style: TextStyle(
                    color: isCompleted
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            DataCell(Text(tx.createdAt)),
          ]);
        }).toList(),
      ),
    );
  }
}

