import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DynamicProductPage extends StatefulWidget {
  const DynamicProductPage({super.key});

  @override
  State<DynamicProductPage> createState() => _DynamicProductPageState();
}

class _DynamicProductPageState extends State<DynamicProductPage> {
  List products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(
      Uri.parse("https://api.rrrbazar.com/images/"), // তোমার API URL
    );

    if (response.statusCode == 200) {
      setState(() {
        products = json.decode(response.body); // ধরে নিলাম API থেকে JSON array আসবে
        isLoading = false;
      });
    } else {
      throw Exception("Failed to load products");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dynamic Products")),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 2;
          if (constraints.maxWidth > 1200) {
            crossAxisCount = 6;
          } else if (constraints.maxWidth > 800) {
            crossAxisCount = 4;
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final product = products[index];

              return ProductCard(
                name: product["title"] ?? "No Title",
                img: product["image"] ?? "assets/placeholder.png",
                price: product["price"]?.toString() ?? "0",
              );
            },
          );
        },
      ),
    );
  }
}

// 🔹 Product Card
class ProductCard extends StatelessWidget {
  final String name, img, price;

  const ProductCard({
    super.key,
    required this.name,
    required this.img,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                img,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image, size: 50),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$ $price",
                  style: const TextStyle(color: Colors.green, fontSize: 12),
                ),
                const SizedBox(height: 6),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Confirm Order"),
                        content: Text("Do you want to buy $name for \$ $price ?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // এখানে Order confirm এর API call করা যাবে
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("$name Order Confirmed!")),
                              );
                            },
                            child: const Text("Confirm"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text("Buy Now"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
