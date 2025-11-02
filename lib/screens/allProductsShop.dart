import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/base_url.dart' show backendUrl;
import '../provider/site_provider.dart';
import '../provider/user_provider.dart';
import 'custom_app_bar.dart';
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
  ];

  @override
  Widget build(BuildContext context) {
    final siteProvider = Provider.of<SiteProvider>(context);
    final site = siteProvider.siteData;
    final logoUrl = "$backendUrl/images/${site?.logo}";
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider;
    return Scaffold(
      // appBar: AppBar(title: Text("All Products"), centerTitle: true),

      drawer: CustomDrawer(),

      appBar: CustomAppBar( logoUrl: logoUrl, isLoggedIn: user.isLoggedIn,),



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
