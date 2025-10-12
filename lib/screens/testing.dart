// /////////////////////////////////////////////////
//
// import 'package:flutter/material.dart';
//
// class OrderSuggestionPage extends StatefulWidget {
//   final String image, title, subtitle, price, description;
//
//   OrderSuggestionPage({
//     required this.image,
//     required this.title,
//     required this.subtitle,
//     required this.price,
//     required this.description,
//   });
//
//   @override
//   _OrderSuggestionPageState createState() => _OrderSuggestionPageState();
// }
//
// class _OrderSuggestionPageState extends State<OrderSuggestionPage> {
//   final TextEditingController playerIdController = TextEditingController();
//   int? selectedIndex;
//
//   final List<Map<String, dynamic>> rechargePacks = [
//     {"title": "🕒 Weekly Lite", "price": 42},
//     {"title": "📘 Weekly Pass", "price": 150},
//     {"title": "📙 Monthly Pass", "price": 770},
//     {"title": "💎 50 Diamonds", "price": 40},
//     {"title": "💎 115 Diamonds", "price": 78},
//     {"title": "💎 240 Diamonds", "price": 155},
//   ];
//
//   void _buyNow() {
//     if (playerIdController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Please enter Player ID first")),
//       );
//       return;
//     }
//
//     if (selectedIndex == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Please select a Recharge Pack")),
//       );
//       return;
//     }
//
//     final pack = rechargePacks[selectedIndex!];
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("✅ Buying ${pack['title']} for ৳${pack['price']}")),
//     );
//
//     // 🔥 এখানেই পরে API Call যাবে
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.title)),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Product Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.asset(widget.image, fit: BoxFit.cover),
//             ),
//             SizedBox(height: 10),
//
//             Text(widget.title,
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             SizedBox(height: 5),
//             Text(widget.subtitle,
//                 style: TextStyle(fontSize: 16, color: Colors.grey)),
//             SizedBox(height: 10),
//             Text(widget.description, style: TextStyle(fontSize: 14)),
//
//             SizedBox(height: 20),
//
//             // Player ID
//             TextField(
//               controller: playerIdController,
//               decoration: InputDecoration(
//                 labelText: "Enter Player ID",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//
//             Text("Select Recharge Pack",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),
//
//             GridView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 1.5,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//               ),
//               itemCount: rechargePacks.length,
//               itemBuilder: (context, index) {
//                 final pack = rechargePacks[index];
//                 final isSelected = selectedIndex == index;
//
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() => selectedIndex = index);
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                           color: isSelected ? Colors.blue : Colors.grey),
//                       borderRadius: BorderRadius.circular(12),
//                       gradient: isSelected
//                           ? LinearGradient(
//                           colors: [Colors.blue, Colors.blueAccent])
//                           : null,
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(pack["title"],
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: isSelected ? Colors.white : Colors.black,
//                             )),
//                         SizedBox(height: 6),
//                         Text("৳ ${pack["price"]}",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: isSelected ? Colors.white : Colors.black54,
//                             )),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//
//             SizedBox(height: 20),
//
//             // Buy Now + Add Money
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: _buyNow,
//                     child: Text("Buy Now"),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton(
//                     style:
//                     ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                     onPressed: () {
//                       // 🔥 Add Money flow
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text("💰 Add Money clicked")),
//                       );
//                     },
//                     child: Text("Add Money"),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// //////////////////////////////////////////////////////////