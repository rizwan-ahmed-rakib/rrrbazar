// import 'package:flutter/material.dart';
// import 'footer.dart'; // 🔹 তোমার custom footer ফাইল import করো
//
// class AllProductsPage extends StatelessWidget {
//   const AllProductsPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // 🔸 Dummy product list (তুমি API থেকে ডাটা আনলে এখানেই বসাবে)
//     final products = [
//       {
//         "id": 1,
//         "title":
//         "Ak66 Trigger / Free Fire Ak66 Six-Finger Gaming Trigger Shooter Gamepad L1R1 Controller Game Fire Button - Finger Sleeve",
//         "price": "৳ 950",
//         "image":
//         "https://api.rrrbazar.com/images/images-1729233940771.png",
//       },
//       {
//         "id": 1,
//         "title":
//         "Ak66 Trigger / Free Fire Ak66 Six-Finger Gaming Trigger Shooter Gamepad L1R1 Controller Game Fire Button - Finger Sleeve",
//         "price": "৳ 950",
//         "image":
//         "https://api.rrrbazar.com/images/images-1729233940771.png",
//       },
//       {
//         "id": 1,
//         "title":
//         "Ak66 Trigger / Free Fire Ak66 Six-Finger Gaming Trigger Shooter Gamepad L1R1 Controller Game Fire Button - Finger Sleeve",
//         "price": "৳ 950",
//         "image":
//         "https://api.rrrbazar.com/images/images-1729233940771.png",
//       },
//       {
//         "id": 1,
//         "title":
//         "Ak66 Trigger / Free Fire Ak66 Six-Finger Gaming Trigger Shooter Gamepad L1R1 Controller Game Fire Button - Finger Sleeve",
//         "price": "৳ 950",
//         "image":
//         "https://api.rrrbazar.com/images/images-1729233940771.png",
//       },
//       {
//         "id": 1,
//         "title":
//         "Ak66 Trigger / Free Fire Ak66 Six-Finger Gaming Trigger Shooter Gamepad L1R1 Controller Game Fire Button - Finger Sleeve",
//         "price": "৳ 950",
//         "image":
//         "https://api.rrrbazar.com/images/images-1729233940771.png",
//       },
//       {
//         "id": 1,
//         "title":
//         "Ak66 Trigger / Free Fire Ak66 Six-Finger Gaming Trigger Shooter Gamepad L1R1 Controller Game Fire Button - Finger Sleeve",
//         "price": "৳ 950",
//         "image":
//         "https://api.rrrbazar.com/images/images-1729233940771.png",
//       },
//       {
//         "id": 1,
//         "title":
//         "Ak66 Trigger / Free Fire Ak66 Six-Finger Gaming Trigger Shooter Gamepad L1R1 Controller Game Fire Button - Finger Sleeve",
//         "price": "৳ 950",
//         "image":
//         "https://api.rrrbazar.com/images/images-1729233940771.png",
//       },
//       {
//         "id": 1,
//         "title":
//         "Ak66 Trigger / Free Fire Ak66 Six-Finger Gaming Trigger Shooter Gamepad L1R1 Controller Game Fire Button - Finger Sleeve",
//         "price": "৳ 950",
//         "image":
//         "https://api.rrrbazar.com/images/images-1729233940771.png",
//       },
//       {
//         "id": 1,
//         "title":
//         "Ak66 Trigger / Free Fire Ak66 Six-Finger Gaming Trigger Shooter Gamepad L1R1 Controller Game Fire Button - Finger Sleeve",
//         "price": "৳ 950",
//         "image":
//         "https://api.rrrbazar.com/images/images-1729233940771.png",
//       },
//     ];
//
//     return Scaffold(
//       backgroundColor: const Color(0xfff9fafb),
//
//       // 🔹 AppBar (optional)
//       appBar: AppBar(
//         title: const Text("All Products"),
//         backgroundColor: Colors.blueAccent,
//         centerTitle: true,
//       ),
//
//       // 🔹 Body: Products Grid
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "All Products",
//               style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87),
//             ),
//             const SizedBox(height: 16),
//
//             // 🔸 Product Grid
//             GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: products.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2, // 🔹 মোবাইলে 2টা কলাম দেখাবে
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//                 childAspectRatio: 0.7,
//               ),
//               itemBuilder: (context, index) {
//                 final product = products[index];
//                 return _buildProductCard(context, product);
//               },
//             ),
//             CustomFooter(),
//
//           ],
//         ),
//
//       ),
//
//     );
//   }
//
//   // 🔸 Product Card Widget
//   Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
//     return GestureDetector(
//       onTap: () {
//         // 🔹 Product Details Page এ যাওয়ার জায়গা
//         Navigator.pushNamed(context, '/product/${product["id"]}');
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12.withOpacity(0.05),
//               blurRadius: 5,
//               offset: const Offset(0, 2),
//             )
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🔸 Product Image
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Image.network(
//                 product["image"],
//                 width: double.infinity,
//                 height: 130,
//                 fit: BoxFit.contain,
//               ),
//             ),
//
//             // 🔸 Title & Price
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product["title"],
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         height: 1.3),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     product["price"],
//                     style: const TextStyle(
//                         color: Colors.blueAccent,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 15),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'customdrawer.dart';
import 'detaisPage_Under_allproducts.dart';
import 'footer.dart';
import 'home_screen.dart';

class AllProductsPage extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {
      "title":
      "Ak66 Trigger / Free Fire Ak66 Six-Finger Gaming Trigger Shooter Gamepad L1R1 Controller Game Fire Button - Finger Sleeve",
      "price": "৳ 950",
      "oldPrice": "৳ 950",
      "image": "https://api.rrrbazar.com/images/images-1729233940771.png",
      "description": "AK66 Six Fingers PUBG Game Controller Gamepad Metal Trigger Shooting Free Fire Gamepad Joystick For IOS Android Mobile PhoneDesigned for Free Fire, it triggers the touch, does not block the screen,does not block the buttons, and is suitable for mobile phones.Physical compression, sensitive without delay.The lever can be rotated 90 degrees without blocking the screen.Colour: Black",
    },
    {
      "title":
      "Ak66 Trigger / Free Fire Ak66 Six-Finger Gaming Trigger Shooter Gamepad L1R1 Controller Game Fire Button - Finger Sleeve",
      "price": "৳ 950",
      "image": "https://api.rrrbazar.com/images/images-1729233940771.png",
    },
    {
      "title":
      "Ak66 Trigger / Free Fire Ak66 Six-Finger Gaming Trigger Shooter Gamepad L1R1 Controller Game Fire Button - Finger Sleeve",
      "price": "৳ 950",
      "image": "https://api.rrrbazar.com/images/images-1729233940771.png",
    },
    {
      "title":
      "Ak66 Trigger / Free Fire Ak66 Six-Finger Gaming Trigger Shooter Gamepad L1R1 Controller Game Fire Button - Finger Sleeve",
      "price": "৳ 950",
      "image": "https://api.rrrbazar.com/images/images-1729233940771.png",
    },
    {
      "title":
      "Ak66 Trigger / Free Fire Ak66 Six-Finger Gaming Trigger Shooter Gamepad L1R1 Controller Game Fire Button - Finger Sleeve",
      "price": "৳ 950",
      "image": "https://api.rrrbazar.com/images/images-1729233940771.png",
    },
    {
      "title":
      "Ak66 Trigger / Free Fire Ak66 Six-Finger Gaming Trigger Shooter Gamepad L1R1 Controller Game Fire Button - Finger Sleeve",
      "price": "৳ 950",
      "image": "https://api.rrrbazar.com/images/images-1729233940771.png",
    },
    {
      "title":
      "Ak66 Trigger / Free Fire Ak66 Six-Finger Gaming Trigger Shooter Gamepad L1R1 Controller Game Fire Button - Finger Sleeve",
      "price": "৳ 950",
      "image": "https://api.rrrbazar.com/images/images-1729233940771.png",
    },
    {
      "title": "Gaming Mouse XYZ",
      "price": "৳ 1200",
      "image": "https://via.placeholder.com/150",
    },
    {
      "title": "Mechanical Keyboard ABC",
      "price": "৳ 2500",
      "image": "https://via.placeholder.com/150",
    },
    // আরও প্রোডাক্ট এখানে যোগ করা যাবে
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("All Products"), centerTitle: true),

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
          // Grid এর উচ্চতা হিসাব
          final gridHeight = ((products.length / 2).ceil()) * 250.0; // 250 = approx card height

          // যদি grid + footer screen এর চেয়ে ছোট হয়, তখন footer নিচে থাকবে
          if (gridHeight + 70 < constraints.maxHeight) {
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: products[index]);
                    },
                  ),
                ),
                CustomFooter(),
              ],
            );
          } else {
            // অনেক আইটেম থাকলে scrollable + footer scrollable হবে
            return SingleChildScrollView(
              child: Column(
                children: [
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: products[index]);
                    },
                  ),
                  CustomFooter(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        onTap: () {
          // এখানে প্রোডাক্টের পেজে যাবে
          // এখানে Navigator.push দিয়ে Details page এ পাঠানো
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsPage_under_allproducts(product: product),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  product["image"],
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                product["title"],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                product["price"],
                style: TextStyle(
                  color: Colors.orange.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
