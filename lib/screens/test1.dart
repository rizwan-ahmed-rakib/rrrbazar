// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
// class TestHomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Footer Example")),
//       body: Column(
//         children: [
//           // 🔹 Expanded content area
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   // Dummy content
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: 50, // কমালে footer উপরে যাবে না
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text("Item $index"),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // 🔹 Footer Section
//           Container(
//             width: double.infinity,
//             color: Colors.lightBlueAccent,
//             padding: EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Text(
//                   "SUPPORT",
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//                 SizedBox(height: 10),
//                 SupportRow(icon: Icons.phone, text: "+8801929248067"),
//                 SizedBox(height: 10),
//                 SupportRow(icon: Icons.phone, text: "+8801929248067"),
//                 SizedBox(height: 10),
//
//                 // WhatsApp Row
//                 Row(
//                   children: [
//                     FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
//                     SizedBox(width: 8),
//                     Text(
//                       "WhatsApp",
//                       style: TextStyle(color: Colors.white, fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // 🔹 SupportRow Widget
// class SupportRow extends StatelessWidget {
//   final IconData icon;
//   final String text;
//
//   SupportRow({required this.icon, required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(icon, color: Colors.white),
//         SizedBox(width: 8),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("10AM - 10PM",
//                 style: TextStyle(color: Colors.white70, fontSize: 12)),
//             Text(text, style: TextStyle(color: Colors.white, fontSize: 14)),
//           ],
//         ),
//       ],
//     );
//   }
// }

//////////////////////////////////////////////

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TestHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Footer Example")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // 🔹 Main content
                    Expanded(
                      child: Column(
                        children: List.generate(
                          30, // এখানে কম item দিলে footer নিচে থাকবে, বেশি দিলে scroll হবে
                              (index) => ListTile(
                            title: Text("Item $index"),
                          ),
                        ),
                      ),
                    ),

                    // 🔹 Footer
                    Container(
                      width: double.infinity,
                      color: Colors.lightBlueAccent,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            "SUPPORT",
                            style:
                            TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          SupportRow(
                              icon: Icons.phone, text: "+8801929248067"),
                          SizedBox(height: 10),
                          SupportRow(
                              icon: Icons.phone, text: "+8801929248067"),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              FaIcon(FontAwesomeIcons.whatsapp,
                                  color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "WhatsApp",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// 🔹 Support Row Widget
class SupportRow extends StatelessWidget {
  final IconData icon;
  final String text;

  SupportRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("10AM - 10PM",
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            Text(text, style: TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ],
    );
  }
}
