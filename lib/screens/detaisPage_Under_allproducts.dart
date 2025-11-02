import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/base_url.dart';
import '../provider/site_provider.dart' show SiteProvider;
import '../provider/user_provider.dart';
import 'addMoneyPage.dart';
import 'custom_app_bar.dart';
import 'customdrawer.dart';
import 'footer.dart';
import 'home_screen.dart';

class ProductDetailsPage_under_allproducts extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage_under_allproducts({required this.product});

  @override
  Widget build(BuildContext context) {
    final siteProvider = Provider.of<SiteProvider>(context);
    final site = siteProvider.siteData;
    final logoUrl = "$backendUrl/images/${site?.logo}";
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider;
    return Scaffold(
      // appBar: AppBar(title: Text("Product Details")),
      drawer: CustomDrawer(),
      appBar: CustomAppBar( logoUrl: logoUrl, isLoggedIn: user.isLoggedIn,),
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
