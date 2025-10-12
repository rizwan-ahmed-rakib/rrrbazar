import 'package:flutter/material.dart';
import 'addMoneyPage.dart';
import 'customdrawer.dart';
import 'footer.dart';
import 'home_screen.dart';

class OrderSuggestionPage extends StatefulWidget {
  final String image, title, subtitle, price, description;

  OrderSuggestionPage({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.description,
  });

  @override
  _OrderSuggestionPageState createState() => _OrderSuggestionPageState();
}

class _OrderSuggestionPageState extends State<OrderSuggestionPage> {
  final TextEditingController playerIdController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  String selectedPayment = "RRR Bazar Wallet";
  double walletBalance = 0; // 🔥 Dummy balance
  int? selectedPackIndex;

  // Static Recharge Packs (API হলে list এ আসবে)

  final List<Map<String, dynamic>> rechargePacks = [
    {"title": "🕒 Weekly Lite 📕", "price": 42},
    {"title": "📘 Weekly (🤖 Ai)", "price": 150},
    {"title": "📙 Monthly (🤖 Ai)", "price": 770},
    {"title": "💎 25 Diamonds", "price": 22},
    {"title": "💎 50 Diamonds", "price": 40},
    {"title": "💎 115 Diamonds", "price": 78},
    {"title": "💎 240 Diamonds", "price": 155},
    {"title": "💎 610 Diamonds", "price": 399},
    {"title": "💎 1240 Diamonds", "price": 799},
    {"title": "💎 2530 Diamonds", "price": 1610},
    {"title": "💎 5060 Diamonds", "price": 3210},
    {"title": "💎 10,120 Diamonds", "price": 6400},
  ];

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

  void _confirmOrder() {
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

    final selectedPack = rechargePacks[selectedPackIndex!];
    final double price = selectedPack["price"].toDouble();

    // Popup দেখানো
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            title: const Text(
              "Confirm Order",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your current wallet is ৳${walletBalance.toStringAsFixed(0)}",
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
                const SizedBox(height: 6),
                Text(
                  "You need ৳${price.toStringAsFixed(0)} to purchase this product.",
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ],
            ),
            actionsPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),

            actionsAlignment: MainAxisAlignment.start, // 👉 বাম দিক থেকে বাটন শুরু হবে

            actions: [
              // ✅ Confirm Order Button (Light Blue)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);

                  // Balance Check
                  if (selectedPayment == "RRR Bazar Wallet") {
                    if (walletBalance < price) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "❌ পর্যাপ্ত ব্যালেন্স নেই! আপনার ওয়ালেটে ৳${walletBalance.toStringAsFixed(0)} আছে।",
                          ),
                        ),
                      );
                      return;
                    }
                  }

                  // 🔥 Payment Redirect
                  if (selectedPayment == "Auto Payment") {
                    print("➡️ Redirecting to Auto Payment API...");
                  } else {
                    print("➡️ Wallet দিয়ে Order Confirm!");
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("✅ Order Confirmed Successfully!"),
                    ),
                  );
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
                  "Confirm order",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),

              // ❌ Cancel Button (Red)
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
        width: 150,
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

  // --- Recharge Pack GridView ---
  // Widget buildRechargeGrid() {
  //   return GridView.builder(
  //     itemCount: rechargePacks.length,
  //     shrinkWrap: true,
  //     physics: NeverScrollableScrollPhysics(),
  //     gridDelegate:
  //     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
  //     itemBuilder: (context, index) {
  //       bool isSelected = selectedPackIndex == index;
  //       final pack = rechargePacks[index];
  //
  //       return GestureDetector(
  //         onTap: () => setState(() => selectedPackIndex = index),
  //         child: Container(
  //           margin: EdgeInsets.all(8),
  //           padding: EdgeInsets.all(8),
  //           decoration: BoxDecoration(
  //             color: isSelected ? Colors.blue[100] : Colors.white,
  //             border: Border.all(
  //                 color: isSelected ? Colors.blue : Colors.grey, width: 1.2),
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(pack["title"],
  //                   style:
  //                   TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  //               // SizedBox(height: 8),
  //               Text("৳${pack["price"]}",
  //                   style: TextStyle(color: Colors.green, fontSize: 14)),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // ✅ Recharge Pack Grid Design (Rectangle Box + Overflow Safe + Commented)
  // ✅ Improved Rectangle GridView (Text আর ডুববে না)

  Widget buildRechargeGrid() {
    return GridView.builder(
      itemCount: rechargePacks.length,
      shrinkWrap: true,
      // GridView parent অনুযায়ী adjust হবে
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // প্রতি Row তে 2টা Box
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.4, // ✅ সামান্য কমানো হয়েছে যেন height একটু বাড়ে
      ),
      itemBuilder: (context, index) {
        bool isSelected = selectedPackIndex == index;
        final pack = rechargePacks[index];

        return GestureDetector(
          onTap: () => setState(() => selectedPackIndex = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue[50] : Colors.white,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey.shade400,
                width: 1.3,
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

            // ✅ এখানে Flexible বাদ দিয়ে Center Column ব্যবহার করা হয়েছে
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🟦 Title Text
                Text(
                  pack["title"] ?? "",
                  textAlign: TextAlign.center,
                  maxLines: 2, // সর্বোচ্চ ২ লাইন পর্যন্ত অনুমতি
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.2, // টেক্সটের line-height ঠিক রাখা হয়েছে
                  ),
                ),

                const SizedBox(height: 4),
                const Divider(height: 6, thickness: 0.8),

                // 🟩 Price Text
                Text(
                  "৳${pack["price"] ?? ""}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.lightBlueAccent[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                    height: 1.3, // ✅ নিচে ডোবে না
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool canBuy =
        (selectedPayment == "RRR Bazar Wallet" && walletBalance > 0) ||
        selectedPayment == "Auto Payment";

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
                          backgroundImage: AssetImage("user.png"),
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet Warning
            if (walletBalance <= 0)
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Wallet balance নেই। প্রথমে Add Money করুন।",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                    ///////////////////popup commented///////////////////////
                    TextButton(
                      // onPressed: _showAddMoneyPopup,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddMoneyPage()),
                        );
                      },

                      child: Text("Add Money"),
                    ),
                    ////////////////////////////////////////
                  ],
                ),
              ),

            Center(child: Image.asset(widget.image, width: 300)),
            SizedBox(height: 10),
            Center(
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),

            TextField(
              controller: playerIdController,
              decoration: InputDecoration(
                labelText: "Enter Player ID",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            SizedBox(height: 20),
            Text(
              "Select Recharge Pack",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            buildRechargeGrid(),

            SizedBox(height: 20),
            Text(
              "Select Payment Method",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                paymentOption("RRR Bazar Wallet", "assets/wallet.png"),
                paymentOption("Auto Payment", "assets/auto_payment.jpeg"),
              ],
            ),

            SizedBox(height: 30),

            Row(
              children: [
                // ✅ শুধুমাত্র Wallet সিলেক্ট থাকলে Add Money দেখাবে
                if (selectedPayment == "RRR Bazar Wallet")
                  Expanded(
                    /////////////////popup commented///////////////////////
                    child: ElevatedButton.icon(
                      // onPressed: _showAddMoneyPopup,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddMoneyPage()),
                        );
                      },
                      /////////////////////////////////

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
                        // ✅ Border Color এবং Rounded Shape
                        side: const BorderSide(color: Colors.blue, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0, // Shadow বাদ দিলে clean দেখায়
                      ),
                    ),
                  ),

                const SizedBox(width: 10),

                // ✅ Buy Now Button
                Expanded(
                  child: Opacity(
                    opacity: canBuy ? 1 : 0.5, // Balance না থাকলে ফিকে দেখাবে
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor:
                            canBuy ? Colors.blue : Colors.grey[400],
                        // ✅ Border যোগ করা হয়েছে
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

            SizedBox(height: 30),

            // Description Box
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),
            CustomFooter(),
          ],
        ),
      ),
    );
  }
}
