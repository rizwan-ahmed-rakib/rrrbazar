import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider/base_url.dart';
import '../provider/site_provider.dart';
import '../provider/topup_banner_provider.dart';
import '../provider/topup_products_provider.dart';
import 'customdrawer.dart';
import 'footer.dart';
import 'ordersuggestion.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselSliderController _controller = CarouselSliderController();


  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  @override
  void initState() {
    super.initState();
    // প্রোভাইডার থেকে ডেটা লোড করুন
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TopupBannerProvider>(context, listen: false).fetchBanners();
      Provider.of<Topup_Products_Provider>(
        context,
        listen: false,
      ).fetchTopupProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    // আপনার existing build method এখানে paste করুন

    final siteProvider = Provider.of<SiteProvider>(context);
    final site = siteProvider.siteData;
    final logoUrl = "$backendUrl/images/${site?.logo}";


    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                // 🏠 HomeScreen এ নিয়ে যাও
              },
              // child: Image.asset("assets/logo.png", height: 30),
              child: Image.network(logoUrl, height: 30),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) {
              return InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 400) {
                      return const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: CircleAvatar(
                          backgroundImage: AssetImage("assets/user.png"),
                        ),
                      );
                    } else {
                      return Row(
                        children: const [
                          CircleAvatar(
                            backgroundImage: AssetImage("assets/user.png"),
                          ),
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

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 2),

                  // 🔥 DYNAMIC BANNER CAROUSEL SECTION
                  Consumer<TopupBannerProvider>(
                    builder: (context, bannerProvider, child) {
                      if (bannerProvider.isLoading) {
                        return Container(
                          height: 150,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (bannerProvider.banners.isEmpty) {
                        return Container(
                          height: 150,
                          child: Center(
                            child: Text(
                              'কোন ব্যানার পাওয়া যায়নি',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }

                      return Container(
                        height: 150,
                        child: CarouselSlider(
                          carouselController: _controller,
                          options: CarouselOptions(
                            height: 150,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 0.94,
                            autoPlayInterval: Duration(seconds: 3),
                          ),
                          items:
                              bannerProvider.banners.map((banner) {
                                return GestureDetector(
                                  onTap: () {
                                    if (banner.link != null &&
                                        banner.link!.isNotEmpty) {
                                      _launchURL(banner.link!);
                                    }
                                  },
                                  child: ClipRRect(
                                    child: Container(
                                      color: Colors.white,
                                      child: Image.network(
                                        '$backendUrl/images/${banner.banner}',
                                        fit: BoxFit.contain,
                                        width: double.infinity,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Container(
                                            color: Colors.grey[200],
                                            child: Icon(
                                              Icons.error,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 20),

                  // 🔥 BD GAME SHOP TITLE SECTION
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          MediaQuery.of(context).size.width > 600 ? 24 : 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "BD Game Shop",
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width > 600
                                    ? 24
                                    : 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        if (MediaQuery.of(context).size.width > 600)
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_back_ios,
                                size: 16,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 15),

                  // 🔥 DYNAMIC PRODUCT GRID SECTION

                  // Consumer<Topup_Products_Provider>(
                  //   builder: (context, productProvider, child) {
                  //     if (productProvider.isLoading) {
                  //       return Center(
                  //         child: Padding(
                  //           padding: EdgeInsets.all(20),
                  //           child: CircularProgressIndicator(),
                  //         ),
                  //       );
                  //     }
                  //
                  //     if (productProvider.products.isEmpty) {
                  //       return Container(
                  //         padding: EdgeInsets.all(20),
                  //         child: Center(
                  //           child: Text(
                  //             'কোন প্রোডাক্ট পাওয়া যায়নি',
                  //             style: TextStyle(
                  //               color: Colors.grey,
                  //               fontSize: 16,
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     }
                  //
                  //     return LayoutBuilder(
                  //       builder: (context, constraints) {
                  //         int crossAxisCount = 2;
                  //         double aspectRatio = 0.75;
                  //
                  //         if (constraints.maxWidth > 1200) {
                  //           crossAxisCount = 5;
                  //           aspectRatio = 0.7;
                  //         } else if (constraints.maxWidth > 800) {
                  //           crossAxisCount = 4;
                  //           aspectRatio = 0.7;
                  //         } else if (constraints.maxWidth > 600) {
                  //           crossAxisCount = 3;
                  //           aspectRatio = 0.75;
                  //         }
                  //
                  //         return GridView.builder(
                  //           physics: NeverScrollableScrollPhysics(),
                  //           shrinkWrap: true,
                  //           itemCount: productProvider.products.length,
                  //           padding: EdgeInsets.symmetric(
                  //             horizontal:
                  //                 MediaQuery.of(context).size.width > 600
                  //                     ? 24
                  //                     : 12,
                  //           ),
                  //           gridDelegate:
                  //               SliverGridDelegateWithFixedCrossAxisCount(
                  //                 crossAxisCount: crossAxisCount,
                  //                 childAspectRatio: aspectRatio,
                  //                 crossAxisSpacing: 8,
                  //                 mainAxisSpacing: 8,
                  //               ),
                  //           itemBuilder: (context, index) {
                  //             final product = productProvider.products[index];
                  //             return GestureDetector(
                  //               onTap: () {
                  //                 Navigator.pushNamed(
                  //                   context,
                  //                   '/ordersuggestion',
                  //                   arguments: {
                  //                     'id': product.id ?? 0,
                  //                     'image': '$backendUrl/images/${product.logo}',
                  //                     'title': product.name ?? 'Unnamed Product',
                  //                     'subtitle': product.topupType ?? 'Topup',
                  //                     'price': 'ক্রয় করুন',
                  //                     'description': _stripHtmlTags(product.rules ?? 'কোন নিয়ম নেই'),
                  //                   },
                  //                 );
                  //
                  //
                  //               },
                  //               child: GameCard(
                  //                 image: '$backendUrl/images/${product.logo}',
                  //                 title: product.name ?? 'Unnamed Product',
                  //                 subtitle: product.topupType ?? 'Topup',
                  //                 price: "ক্রয় করুন",
                  //               ),
                  //             );
                  //           },
                  //         );
                  //       },
                  //     );
                  //   },
                  // ),


                  Consumer<Topup_Products_Provider>(
                    builder: (context, productProvider, child) {
                      // 🔄 লোডিং চলাকালীন
                      if (productProvider.isLoading) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      // ❌ যদি কোনো প্রোডাক্ট না থাকে
                      if (productProvider.products.isEmpty) {
                        return Container(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: Text(
                              'কোন প্রোডাক্ট পাওয়া যায়নি',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }

                      // ✅ Responsive Grid
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount = 2; // 📱 মোবাইলে প্রতি সারিতে ২টি
                          double aspectRatio = 0.75;

                          // 💻 বড় স্ক্রিনে column বাড়ানো হবে
                          if (constraints.maxWidth > 1200) {
                            crossAxisCount = 5;
                            aspectRatio = 0.75;
                          } else if (constraints.maxWidth > 800) {
                            crossAxisCount = 4;
                            aspectRatio = 0.8;
                          } else if (constraints.maxWidth > 600) {
                            crossAxisCount = 3;
                            aspectRatio = 0.8;
                          }

                          return GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: productProvider.products.length,
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width > 600
                                      ? 24
                                      : 12,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  childAspectRatio: aspectRatio,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemBuilder: (context, index) {
                              final product = productProvider.products[index];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/ordersuggestion',
                                    arguments: {
                                      'id': product.id ?? 0,
                                      'image':
                                          '$backendUrl/images/${product.logo}',
                                      'title':
                                          product.name ?? 'Unnamed Product',
                                      'subtitle': product.topupType ?? 'Topup',
                                      'price': 'ক্রয় করুন',
                                      'description': _stripHtmlTags(
                                        product.rules ?? 'কোন নিয়ম নেই',
                                      ),
                                    },
                                  );
                                },
                                child: GameCard(
                                  image: '$backendUrl/images/${product.logo}',
                                  title: product.name ?? 'Unnamed Product',
                                  subtitle: product.topupType ?? 'Topup',
                                  price: "ক্রয় করুন",
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),

                  SizedBox(height: 20),

                  // 🔥 FOOTER SECTION
                  CustomFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🔥 GAME CARD WIDGET (Updated for dynamic data)
// class GameCard extends StatelessWidget {
//   final String image, title, subtitle, price;
//
//   GameCard({
//     required this.image,
//     required this.title,
//     required this.subtitle,
//     required this.price,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(0),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       elevation: 1,
//       child: Container(
//         height: 230,
//         padding: EdgeInsets.all(4),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // PRODUCT IMAGE with top curve
//             ClipRRect(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(8),
//                 topRight: Radius.circular(8),
//               ),
//               child: Container(
//                 // height: 140, // Height কমিয়ে দিলাম better view এর জন্য
//                 height: 210,
//                 width: double.infinity,
//                 child: Image.network(
//                   image,
//                   fit: BoxFit.contain,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       color: Colors.grey[200],
//                       child: Icon(
//                         Icons.shopping_bag,
//                         color: Colors.grey[400],
//                         size: 40,
//                       ),
//                     );
//                   },
//                   loadingBuilder: (context, child, loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return Container(
//                       color: Colors.grey[200],
//                       child: Center(
//                         child: CircularProgressIndicator(
//                           value:
//                               loadingProgress.expectedTotalBytes != null
//                                   ? loadingProgress.cumulativeBytesLoaded /
//                                       loadingProgress.expectedTotalBytes!
//                                   : null,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 8),
//
//             // Product Title
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 4),
//               child: Text(
//                 title,
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                 textAlign: TextAlign.center,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//
//             // SizedBox(height: 4),
//
//             // Product Subtitle (Topup Type)
//
//             // Container(
//             //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//             //   decoration: BoxDecoration(
//             //     color: _getTopupTypeColor(subtitle),
//             //     borderRadius: BorderRadius.circular(4),
//             //   ),
//             //   child: Text(
//             //     subtitle,
//             //     style: TextStyle(
//             //       color: Colors.white,
//             //       fontSize: 10,
//             //       fontWeight: FontWeight.bold,
//             //     ),
//             //   ),
//             // ),
//
//             // Spacer(),
//
//             // Price/Buy Button
//
//             // Container(
//             //   width: double.infinity,
//             //   margin: EdgeInsets.symmetric(horizontal: 4),
//             //   child: ElevatedButton(
//             //     onPressed: () {},
//             //     style: ElevatedButton.styleFrom(
//             //       backgroundColor: Colors.blue,
//             //       foregroundColor: Colors.white,
//             //       padding: EdgeInsets.symmetric(vertical: 6),
//             //       shape: RoundedRectangleBorder(
//             //         borderRadius: BorderRadius.circular(6),
//             //       ),
//             //     ),
//             //     child: Text(price, style: TextStyle(fontSize: 12)),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // টপআপ টাইপ অনুযায়ী কালার
//   Color _getTopupTypeColor(String topupType) {
//     switch (topupType.toLowerCase()) {
//       case 'id_code':
//         return Colors.green;
//       case 'phone':
//         return Colors.orange;
//       case 'voucher':
//         return Colors.purple;
//       default:
//         return Colors.grey;
//     }
//   }
// }

class GameCard extends StatelessWidget {
  final String image, title, subtitle, price;

  GameCard({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    // 🧮 স্ক্রিন ডেনসিটি অনুযায়ী Dynamic Height
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageHeight =
        screenWidth < 600 ? 210 : 250; // 📱 মোবাইলে ছোট, 💻 বড়
    final double fontSize = screenWidth < 600 ? 13 : 15;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      shadowColor: Colors.grey.shade300,
      child: Padding(
        padding: EdgeInsets.all(6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 🖼️ প্রোডাক্ট ইমেজ
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: imageHeight,
                width: double.infinity,
                color: Colors.grey.shade100,
                child: Image.network(
                  image,
                  fit: BoxFit.contain, // contain ব্যবহার করলে distortion হয় না
                  errorBuilder:
                      (context, error, stackTrace) => Icon(
                        Icons.shopping_bag,
                        size: 50,
                        color: Colors.grey.shade400,
                      ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: 8),

            // 🏷️ প্রোডাক্ট নাম
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          ],
        ),
      ),
    );
  }

  // 🎨 টপআপ টাইপ অনুযায়ী রঙ
  Color _getTopupTypeColor(String topupType) {
    switch (topupType.toLowerCase()) {
      case 'id_code':
        return Colors.green;
      case 'phone':
        return Colors.orange;
      case 'voucher':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

String _stripHtmlTags(String htmlString) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  return htmlString.replaceAll(exp, '');
}

