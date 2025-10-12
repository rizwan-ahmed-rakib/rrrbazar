import 'package:flutter/material.dart';

import 'addMoneyPage.dart';
import 'customdrawer.dart';
import 'footer.dart';
import 'home_screen.dart';

class ProductDetailsPage_under_allproducts extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage_under_allproducts({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Product Details")),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              // Product Image
              Container(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  product["image"],
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),


              // Product Title
              Text(
                product["title"],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),

              // Price Section
              Row(
                children: [
                  Text(
                    product["price"],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade600,
                    ),
                  ),
                  SizedBox(width: 10),
                  if (product.containsKey("oldPrice"))
                    Text(
                      product["oldPrice"],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 12),

              // Add Money / Buy Button
              ElevatedButton(
                onPressed: () {
                  // এখানে add money বা buy action
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddMoneyPage(),
                    ),
                  );
                  // Navigator.push(context, route)
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.orange.shade600),
                  foregroundColor: Colors.orange.shade600,
                  minimumSize: Size(double.infinity, 45),
                ),
                child: Text("Add Money"),
              ),
              SizedBox(height: 20),



              // Description Section
              Text(
                "Description:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                product["description"] ??
                    "No description available for this product.",
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 30),

              // Footer
              CustomFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
