import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nanokingfisher_assesment/screens/footer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'customdrawer.dart';
import 'ordersuggestion.dart';

class HomeScreen extends StatelessWidget {
  final CarouselSliderController _controller = CarouselSliderController();

  final List<Map<String, String>> banners = [
    {
      "image": "banner1.png",
      "url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
    },
    {
      "image": "banner2.png",
      "url": "https://www.youtube.com/watch?v=HryDzwBE4AQ",
    },
  ];

  final List<Map<String, String>> categories = const [
    {"title": "Bdgazvar", "subtitle": "FREE FIRE", "image": "freefire.png"},
    {
      "title": "Free Fire (Id Code)",
      "subtitle": "",
      "image": "freefire_id.png",
    },
    {"title": "TikTok Coin", "subtitle": "TikTok Coin", "image": "tiktok.png"},
    {
      "title": "Unipin",
      "subtitle": "Bdgazvar\nFREE FIRE",
      "image": "unipin.png",
    },
    {"title": "Unipin", "subtitle": "IBSASS", "image": "voucher.png"},
  ];

  final List<Map<String, String>> products = const [
    {
      "image": "product_image/freefire.jpg",
      "title": "Free Fire (Id Code)",
      "subtitle": "Bd sarvar",
      "price": "42",
    },
    {
      "image": "product_image/freefirelike.jpg",
      "title": "Free Fire Like",
      "subtitle": "1 দিনে 100 Like",
      "price": "155",
    },
    {
      "image": "product_image/tiktokCoin.jpg",
      "title": "Weekly Pass",
      "subtitle": "7 days offer",
      "price": "299",
    },
    {
      "image": "product_image/unpinvoutcher.jpg",
      "title": "Monthly Pack",
      "subtitle": "30 days special",
      "price": "999",
    },
    {
      "image": "product_image/levelup_pass.jpg",
      "title": "Free Fire (Id Code)",
      "subtitle": "Bd sarvar",
      "price": "42",
    },
    {
      "image": "product_image/airdrop_uid_code.jpg",
      "title": "Free Fire Like",
      "subtitle": "1 দিনে 100 Like",
      "price": "155",
    },
    {
      "image": "product_image/evo_access_id_code.jpg",
      "title": "Weekly Pass",
      "subtitle": "7 days offer",
      "price": "299",
    },
    {
      "image": "product_image/freefire_singapore_server.jpg",
      "title": "Monthly Pack",
      "subtitle": "30 days special",
      "price": "999",
    },
    {
      "image": "product_image/id_code_indonesia.jpg",
      "title": "id code indonesia",
      "subtitle": "30 days special",
      "price": "999",
    },
    {
      "image": "product_image/pubg.jpg",
      "title": "PUBG",
      "subtitle": "30 days special",
      "price": "999",
    },
    {
      "image": "product_image/clash_of_clan.jpg",
      "title": "clash_of_clan.jpg",
      "subtitle": "30 days special",
      "price": "999",
    },
    {
      "image": "product_image/efootball.jpg",
      "title": "efootball.jpg",
      "subtitle": "30 days special",
      "price": "999",
    },
    {
      "image": "product_image/youtube_premium.jpg",
      "title": "youtube_premium.jpg",
      "subtitle": "30 days special",
      "price": "999",
    },
    {
      "image": "product_image/twitter_premium.jpg",
      "title": "twitter_premium.jpg",
      "subtitle": "30 days special",
      "price": "999",
    },
    {
      "image": "product_image/apple_music.jpg",
      "title": "apple_music.jpg",
      "subtitle": "30 days special",
      "price": "999",
    },
    {
      "image": "product_image/netflix.jpg",
      "title": "netflix.jpg",
      "subtitle": "30 days special",
      "price": "999",
    },
    {
      "image": "product_image/amazon.jpg",
      "title": "amazon.jpg",
      "subtitle": "30 days special",
      "price": "999",
    },
    {
      "image": "product_image/zee-5.jpg",
      "title": "zee-5.jpg",
      "subtitle": "30 days special",
      "price": "999",
    },
    {
      "image": "product_image/disnep.jpg",
      "title": "disnep.jpg",
      "subtitle": "30 days special",
      "price": "999",
    },
    {
      "image": "product_image/chorki.jpg",
      "title": "chorki.jpg",
      "subtitle": "30 days special",
      "price": "999",
    },
    {
      "image": "product_image/spotify.jpg",
      "title": "spotify.jpg",
      "subtitle": "30 days special",
      "price": "999",
    },
    {
      "image": "product_image/hoichoi.jpg",
      "title": "hoichoi.jpg",
      "subtitle": "30 days special",
      "price": "999",
    },
    {
      "image": "product_image/curnchyroll.jpg",
      "title": "curnchyroll.jpg",
      "subtitle": "30 days special",
      "price": "999",
    },
    {
      "image": "product_image/hbo_max.jpg",
      "title": "hbo_max.jpg",
      "subtitle": "30 days special",
      "price": "999",
    },

  ];

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:const CustomDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false, // 🔥 ডিফল্ট Hamburger আইকন লুকিয়ে দিলাম
        title: Row(children: [Image.asset("logo.png", height: 30)]),
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
                          CircleAvatar(backgroundImage: AssetImage("user.png")),
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
                  SizedBox(height: 10),

                  // 🔥 BANNER CAROUSEL SECTION - Mobile friendly height
                  Container(
                    height: 130, // 🔥 Mobile এ height কমিয়ে overlap avoid
                    child: CarouselSlider(
                      carouselController: _controller,
                      options: CarouselOptions(
                        height: 130,
                        // 🔥 Options এও same height set করুন
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.75,
                        // 🔥 Mobile এ viewport fraction adjust
                        autoPlayInterval: Duration(seconds: 3),
                      ),
                      items:
                          banners.map((banner) {
                            return GestureDetector(
                              onTap: () => _launchURL(banner["url"]!),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  color: Colors.white,
                                  child: Image.asset(
                                    banner["image"]!,
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),

                  SizedBox(height: 20),

                  // 🔥 BD GAME SHOP TITLE SECTION - Mobile responsive padding

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          MediaQuery.of(context).size.width > 600 ? 24 : 16,
                    ), // 🔥 Screen size অনুযায়ী padding adjust
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        // 🔥 SCROLL INDICATOR - শুধু large screen এ show করবে
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

                  // SizedBox(height: 15),

                  // 🔥 CATEGORY HORIZONTAL LIST SECTION - Mobile এ height optimize

                  // Container(
                  //   height: MediaQuery.of(context).size.width > 600 ? 140 : 120,
                  //   // 🔥 Screen size অনুযায়ী height
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     padding: EdgeInsets.symmetric(
                  //       horizontal:
                  //           MediaQuery.of(context).size.width > 600 ? 24 : 16,
                  //     ),
                  //     itemCount: categories.length,
                  //     itemBuilder: (context, index) {
                  //       final category = categories[index];
                  //       return Container(
                  //         width:
                  //             MediaQuery.of(context).size.width > 600
                  //                 ? 110
                  //                 : 90, // 🔥 Responsive width
                  //         margin: EdgeInsets.only(right: 12),
                  //         child: Column(
                  //           children: [
                  //             // 🔥 CATEGORY IMAGE - Size responsive
                  //             Container(
                  //               width:
                  //                   MediaQuery.of(context).size.width > 600
                  //                       ? 75
                  //                       : 65,
                  //               height:
                  //                   MediaQuery.of(context).size.width > 600
                  //                       ? 75
                  //                       : 65,
                  //               decoration: BoxDecoration(
                  //                 color: Colors.white,
                  //                 borderRadius: BorderRadius.circular(12),
                  //                 boxShadow: [
                  //                   BoxShadow(
                  //                     color: Colors.black12,
                  //                     blurRadius: 4,
                  //                     offset: Offset(0, 2),
                  //                   ),
                  //                 ],
                  //               ),
                  //               child: ClipRRect(
                  //                 borderRadius: BorderRadius.circular(12),
                  //                 child: Image.asset(
                  //                   category["image"]!,
                  //                   fit: BoxFit.cover,
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(height: 6),
                  //             // 🔥 CATEGORY TITLE - Font size responsive
                  //             Text(
                  //               category["title"]!,
                  //               style: TextStyle(
                  //                 fontSize:
                  //                     MediaQuery.of(context).size.width > 600
                  //                         ? 13
                  //                         : 11,
                  //                 fontWeight: FontWeight.w600,
                  //                 color: Colors.blue.shade800,
                  //               ),
                  //               textAlign: TextAlign.center,
                  //               maxLines: 2, // 🔥 Mobile এ 2 line allow
                  //               overflow: TextOverflow.ellipsis,
                  //             ),
                  //             // 🔥 CATEGORY SUBTITLE - Mobile এ smaller font
                  //             if (category["subtitle"]!.isNotEmpty)
                  //               Padding(
                  //                 padding: const EdgeInsets.only(top: 2),
                  //                 child: Text(
                  //                   category["subtitle"]!,
                  //                   style: TextStyle(
                  //                     fontSize:
                  //                         MediaQuery.of(context).size.width >
                  //                                 600
                  //                             ? 11
                  //                             : 9,
                  //                     color: Colors.grey.shade600,
                  //                   ),
                  //                   textAlign: TextAlign.center,
                  //                   maxLines: 2,
                  //                 ),
                  //               ),
                  //           ],
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),

                  // SizedBox(height: 25),

                  // 🔥 ALL PRODUCTS TITLE SECTION - Responsive design

                  // Padding(
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal:
                  //         MediaQuery.of(context).size.width > 600 ? 24 : 16,
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         "All Products",
                  //         style: TextStyle(
                  //           fontSize:
                  //               MediaQuery.of(context).size.width > 600
                  //                   ? 20
                  //                   : 18,
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.blue.shade800,
                  //         ),
                  //       ),
                  //       // 🔥 SCROLL INDICATOR - শুধু large screen এ
                  //       if (MediaQuery.of(context).size.width > 600)
                  //         Row(
                  //           children: [
                  //             Icon(
                  //               Icons.arrow_back_ios,
                  //               size: 16,
                  //               color: Colors.grey,
                  //             ),
                  //             SizedBox(width: 8),
                  //             Icon(
                  //               Icons.arrow_forward_ios,
                  //               size: 16,
                  //               color: Colors.grey,
                  //             ),
                  //           ],
                  //         ),
                  //     ],
                  //   ),
                  // ),

                  SizedBox(height: 15),

                  // 🔥 PRODUCT GRID SECTION - Aspect ratio adjust করুন
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 2;
                      double aspectRatio =
                          0.75; // 🔥 CHANGE: 1.1 থেকে 0.75 এ কমিয়ে দিন

                      if (constraints.maxWidth > 1200) {
                        crossAxisCount = 5;
                        aspectRatio = 0.7;
                      } else if (constraints.maxWidth > 800) {
                        crossAxisCount = 4;
                        aspectRatio = 0.7;
                      } else if (constraints.maxWidth > 600) {
                        crossAxisCount = 3;
                        aspectRatio = 0.75;
                      }

                      return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: products.length,
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width > 600 ? 24 : 12,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: aspectRatio, // 🔥 এটি important
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,

                        ),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => OrderSuggestionPage(
                                        image: product["image"]!,
                                        title: product["title"]!,
                                        subtitle: product["subtitle"]!,
                                        price: product["price"]!,
                                      ),
                                ),
                              );
                            },
                            child: GameCard(
                              image: product["image"]!,
                              title: product["title"]!,
                              subtitle: product["subtitle"]!,
                              price: product["price"]!,
                            ),
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

// 🔥 SIMPLER GAME CARD WIDGET - Without Expanded/Flexible
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
    return Card(
      margin: EdgeInsets.all(4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Container(
        padding: EdgeInsets.all(4),
        // 🔥 FIX: Fixed height দিয়ে দিন
        height: 230, // Fixed height set করুন
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔥 PRODUCT IMAGE - Fixed height
            Container(
              height: 210, // Fixed height for image
              width: double.infinity,
              child: Image.asset(image, fit: BoxFit.contain),
            ),

            // SizedBox(height: 8),

            Expanded(
              child: SizedBox(), // Flexible space নেবে
            ),

            // 🔥 PRODUCT TITLE
            Text(
              title,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width > 600 ? 14 :14,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade800,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // 🔥 PRODUCT SUBTITLE

            // if (subtitle.isNotEmpty) ...[
            //   SizedBox(height: 4),
            //   Text(
            //     subtitle,
            //     style: TextStyle(
            //       fontSize: MediaQuery.of(context).size.width > 600 ? 12 : 10,
            //       color: Colors.grey.shade600,
            //     ),
            //     maxLines: 1, // 2 থেকে 1 এ কমিয়ে দিন
            //     overflow: TextOverflow.ellipsis,
            //   ),
            // ],

            // 🔥 Spacer এর বদলে flexible space

            // Expanded(
            //   child: SizedBox(), // Flexible space নেবে
            // ),

            // 🔥 PRICE AND BUY BUTTON

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "৳$price",
            //       style: TextStyle(
            //         fontSize: MediaQuery.of(context).size.width > 600 ? 14 : 12,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.green.shade700,
            //       ),
            //     ),
            //     Container(
            //       padding: EdgeInsets.symmetric(
            //         horizontal:
            //             MediaQuery.of(context).size.width > 600 ? 10 : 6,
            //         vertical: 4,
            //       ),
            //       decoration: BoxDecoration(
            //         color: Colors.blue.shade600,
            //         borderRadius: BorderRadius.circular(6),
            //       ),
            //       child: Text(
            //         "Buy",
            //         style: TextStyle(
            //           fontSize:
            //               MediaQuery.of(context).size.width > 600 ? 12 : 10,
            //           color: Colors.white,
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

// 🔥 SUPPORT ROW WIDGET (Footer এর জন্য)
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
            Text(
              "10AM - 10PM",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(text, style: TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ],
    );
  }
}
