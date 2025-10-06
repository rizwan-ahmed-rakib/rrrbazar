import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'customdrawer.dart';
import 'home_screen.dart';

class OrderSuggestionPage extends StatefulWidget {
  final String image, title, subtitle, price;

  OrderSuggestionPage({required this.image, required this.title, required this.subtitle, required this.price});

  @override
  _OrderSuggestionPageState createState() => _OrderSuggestionPageState();
}

class _OrderSuggestionPageState extends State<OrderSuggestionPage> {
  final TextEditingController playerIdController = TextEditingController();
  String selectedPayment = "RRR Bazar Wallet";

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Confirm Order"),
          content: Text(
            "Player ID: ${playerIdController.text}\n"
                "Product: ${widget.title}\n"
                "Price: ৳${widget.price}\n"
                "Payment: $selectedPayment",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("✅ Order Confirmed!")),
                );
              },
              child: Text("Confirm Order"),
            ),
          ],
        );
      },
    );
  }

  Widget paymentOption(String name) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = name;
        });
      },
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          border: Border.all(color: selectedPayment == name ? Colors.blue : Colors.grey),
          borderRadius: BorderRadius.circular(10),
          color: selectedPayment == name ? Colors.blue[50] : Colors.white,
        ),
        child: Text(name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Order Suggestion")),
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Row(children: [Image.asset("logo.png", height: 30)]),
        actions: [
          Row(
            children: [
              CircleAvatar(backgroundImage: AssetImage("user.png")),
              SizedBox(width: 6),
              Text("Hellowfarjan"),
              Icon(Icons.arrow_drop_down),
              SizedBox(width: 10),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(widget.image, height: 120),
            SizedBox(height: 10),
            Text(widget.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(widget.subtitle, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 10),
            Text("৳${widget.price}", style: TextStyle(fontSize: 18, color: Colors.green)),

            SizedBox(height: 20),
            TextField(
              controller: playerIdController,
              decoration: InputDecoration(
                labelText: "Enter Player ID",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),

            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                paymentOption("RRR Bazar Wallet"),
                paymentOption("bKash"),
                paymentOption("Nagad"),
              ],
            ),

            Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _showConfirmationDialog,
              child: Text("Buy Now", style: TextStyle(fontSize: 18)),
            ),


            Container(
              padding: EdgeInsets.all(16),
              color: Colors.lightBlueAccent,
              child: Column(
                children: [
                  Text(
                    "SUPPORT",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  SupportRow(icon: Icons.phone, text: "+8801929248067"),
                  SizedBox(height: 10),
                  SupportRow(icon: Icons.phone, text: "+8801929248067"),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}