import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rrrbazar/provider/user_profile_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider/base_url.dart';
import '../provider/site_provider.dart';
import '../provider/topup_banner_provider.dart';
import '../provider/topup_products_provider.dart';
import '../provider/user_provider.dart';
import 'custom_app_bar.dart';
import 'customdrawer.dart';
import 'footer.dart';
import 'login.dart';
import 'ordersuggestion.dart';
import 'registration_screen.dart';

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
      Provider.of<Topup_Products_Provider>(context, listen: false,).fetchTopupProducts();
      Provider.of<SiteProvider>(context, listen: false).fetchSiteData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // আপনার existing build method এখানে paste করুন

    final siteProvider = Provider.of<SiteProvider>(context);
    final site = siteProvider.siteData;
    final logoUrl = "$backendUrl/images/${site?.logo}";
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider;

    final profileProvider = Provider.of<UserProfileProvider>(context);
    final profile = profileProvider.profileData?.data;
    // final userImage = profile?.avatar;
    // final userImage = user.photoUrl;
    final userImage = "$backendUrl/images/${site?.logo}";

    return Scaffold(
      drawer:  CustomDrawer(),

      appBar: CustomAppBar( logoUrl: logoUrl, isLoggedIn: user.isLoggedIn,),


      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Row(
      //     children: [
      //       GestureDetector(
      //         onTap: () {
      //           // 🏠 HomeScreen এ নিয়ে যাও
      //         },
      //         // child: Image.asset("assets/logo.png", height: 30),
      //         child: Image.network(logoUrl, height: 30),
      //       ),
      //     ],
      //   ),
      //   actions: [
      //     Builder(
      //       builder: (context) {
      //         return InkWell(
      //           onTap: () {
      //             Scaffold.of(context).openDrawer();
      //           },
      //           child: LayoutBuilder(
      //             builder: (context, constraints) {
      //               if (constraints.maxWidth < 400) {
      //                 return  Padding(
      //                   padding: EdgeInsets.only(right: 10),
      //                   child: CircleAvatar(
      //                     // backgroundImage: AssetImage("assets/user.png"),
      //                     // backgroundImage: NetworkImage(userImage),
      //                     backgroundImage: NetworkImage(userImage),
      //                   ),
      //                 );
      //               } else {
      //                 return Row(
      //                   children: const [
      //                     CircleAvatar(
      //                       backgroundImage: AssetImage("assets/user.png"),
      //                     ),
      //                     SizedBox(width: 6),
      //                     Text("Hellow user"),
      //                     Icon(Icons.arrow_drop_down),
      //                     SizedBox(width: 10),
      //                   ],
      //                 );
      //               }
      //             },
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      // ),



//////////////////// screen refreshing effect  bellow ////////////////

      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<TopupBannerProvider>(context, listen: false).refreshBanners();
          Provider.of<Topup_Products_Provider>(context, listen: false).refreshTopupProducts();
          Provider.of<SiteProvider>(context, listen: false).refreshSiteData();
          print("✅ Page Refreshed!");
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(), // Important
          child: Column(
            // children: [
            //   // তোমার পুরো আগের UI এখানে থাকবে ⬇
            // ],

            children: [
              SizedBox(height: 2),

              // 🔥 DYNAMIC BANNER CAROUSEL SECTION

              ///////////////////////////////////////////////////

              // Consumer<TopupBannerProvider>(
              //   builder: (context, bannerProvider, child) {
              //     if (bannerProvider.isLoading) {
              //       return Container(
              //         height: 150,
              //         child: Center(child: CircularProgressIndicator()),
              //       );
              //     }
              //
              //     if (bannerProvider.banners.isEmpty) {
              //       return Container(
              //         height: 150,
              //         child: Center(
              //           child: Text(
              //             'কোন ব্যানার পাওয়া যায়নি',
              //             style: TextStyle(color: Colors.grey),
              //           ),
              //         ),
              //       );
              //     }
              //
              //     return Container(
              //       height: 150,
              //       child: CarouselSlider(
              //         carouselController: _controller,
              //         options: CarouselOptions(
              //           height: 150,
              //           autoPlay: true,
              //           enlargeCenterPage: true,
              //           viewportFraction: 0.94,
              //           autoPlayInterval: Duration(seconds: 3),
              //         ),
              //         items:
              //         bannerProvider.banners.map((banner) {
              //           return GestureDetector(
              //             onTap: () {
              //               if (banner.link != null &&
              //                   banner.link!.isNotEmpty) {
              //                 _launchURL(banner.link!);
              //               }
              //             },
              //             child: ClipRRect(
              //               child: Container(
              //                 color: Colors.white,
              //                 child: Image.network(
              //                   '$backendUrl/images/${banner.banner}',
              //                   fit: BoxFit.contain,
              //                   width: double.infinity,
              //                   errorBuilder: (
              //                       context,
              //                       error,
              //                       stackTrace,
              //                       ) {
              //                     return Container(
              //                       color: Colors.grey[200],
              //                       child: Icon(
              //                         Icons.error,
              //                         color: Colors.grey,
              //                       ),
              //                     );
              //                   },
              //                 ),
              //               ),
              //             ),
              //           );
              //         }).toList(),
              //       ),
              //     );
              //
              //
              //
              //
              //     // return Container(
              //     //   // 🔹 স্ক্রিনের উচ্চতার সাথে মিলিয়ে Banner Height অ্যাডজাস্ট হবে
              //     //   height: MediaQuery.of(context).size.height * 0.22, // প্রায় 22% স্ক্রিন হাইট
              //     //
              //     //   child: CarouselSlider(
              //     //     carouselController: _controller,
              //     //     options: CarouselOptions(
              //     //       height: MediaQuery.of(context).size.height * 0.22, // একই height
              //     //       autoPlay: true,
              //     //       enlargeCenterPage: true,
              //     //       viewportFraction: 0.94,
              //     //       autoPlayInterval: const Duration(seconds: 3),
              //     //     ),
              //     //     items: bannerProvider.banners.map((banner) {
              //     //       return GestureDetector(
              //     //         onTap: () {
              //     //           if (banner.link != null && banner.link!.isNotEmpty) {
              //     //             _launchURL(banner.link!);
              //     //           }
              //     //         },
              //     //         child: ClipRRect(
              //     //           borderRadius: BorderRadius.circular(12),
              //     //           child: Container(
              //     //             color: Colors.white,
              //     //             child: Image.network(
              //     //               '$backendUrl/images/${banner.banner}',
              //     //               // fit: BoxFit.cover, // ✅ contain → cover এ পরিবর্তন করলে ভালো অ্যাডজাস্ট হবে
              //     //               fit: BoxFit.contain, // ✅ contain → cover এ পরিবর্তন করলে ভালো অ্যাডজাস্ট হবে
              //     //               width: double.infinity,
              //     //               errorBuilder: (context, error, stackTrace) {
              //     //                 return Container(
              //     //                   color: Colors.grey[200],
              //     //                   child: const Icon(
              //     //                     Icons.error,
              //     //                     color: Colors.grey,
              //     //                   ),
              //     //                 );
              //     //               },
              //     //             ),
              //     //           ),
              //     //         ),
              //     //       );
              //     //     }).toList(),
              //     //   ),
              //     // );
              //
              //
              //   },
              // ),



              Consumer<TopupBannerProvider>(
                builder: (context, bannerProvider, child) {
                  if (bannerProvider.isLoading) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.22,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (bannerProvider.banners.isEmpty) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.22,
                      child: Center(
                        child: Text('কোন ব্যানার পাওয়া যায়নি', style: TextStyle(color: Colors.grey)),
                      ),
                    );
                  }

                  return AspectRatio( // ✅ Ensures perfect proportion
                    aspectRatio: 16 / 6, // Banner ratio (Changeable: 16/9 or 3/1)
                    child: CarouselSlider(
                      carouselController: _controller,
                      options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.94,
                        autoPlayInterval: Duration(seconds: 3),
                      ),
                      items: bannerProvider.banners.map((banner) {
                        return GestureDetector(
                          onTap: () {
                            if (banner.link != null && banner.link!.isNotEmpty) {
                              _launchURL(banner.link!);
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              '$backendUrl/images/${banner.banner}',
                              fit: BoxFit.cover, // ✅ Full beautiful fill, no empty space
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(Icons.error, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),



              ////////////////////////////////////////////////////

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
                                  'description': _stripHtmlTags(
                                    product.rules ?? 'কোন নিয়ম নেই',
                                  ),
                                },
                              );
                            },
                            child: GameCard(
                              image: '$backendUrl/images/${product.logo}',
                              title: product.name ?? 'Unnamed Product',
                              // subtitle: product.topupType ?? 'Topup',
                              // price: "ক্রয় করুন",
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

/////////////////////////////////////////////////////////////////////


/////////////////////////main home scrren without refreshing  bellow////////////////


//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SizedBox(height: 2),
//
//                   // 🔥 DYNAMIC BANNER CAROUSEL SECTION
//                   Consumer<TopupBannerProvider>(
//                     builder: (context, bannerProvider, child) {
//                       if (bannerProvider.isLoading) {
//                         return Container(
//                           height: 150,
//                           child: Center(child: CircularProgressIndicator()),
//                         );
//                       }
//
//                       if (bannerProvider.banners.isEmpty) {
//                         return Container(
//                           height: 150,
//                           child: Center(
//                             child: Text(
//                               'কোন ব্যানার পাওয়া যায়নি',
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           ),
//                         );
//                       }
//
//                       return Container(
//                         height: 150,
//                         child: CarouselSlider(
//                           carouselController: _controller,
//                           options: CarouselOptions(
//                             height: 150,
//                             autoPlay: true,
//                             enlargeCenterPage: true,
//                             viewportFraction: 0.94,
//                             autoPlayInterval: Duration(seconds: 3),
//                           ),
//                           items:
//                               bannerProvider.banners.map((banner) {
//                                 return GestureDetector(
//                                   onTap: () {
//                                     if (banner.link != null &&
//                                         banner.link!.isNotEmpty) {
//                                       _launchURL(banner.link!);
//                                     }
//                                   },
//                                   child: ClipRRect(
//                                     child: Container(
//                                       color: Colors.white,
//                                       child: Image.network(
//                                         '$backendUrl/images/${banner.banner}',
//                                         fit: BoxFit.contain,
//                                         width: double.infinity,
//                                         errorBuilder: (
//                                           context,
//                                           error,
//                                           stackTrace,
//                                         ) {
//                                           return Container(
//                                             color: Colors.grey[200],
//                                             child: Icon(
//                                               Icons.error,
//                                               color: Colors.grey,
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                         ),
//                       );
//
//
//
//
//                       // return Container(
//                       //   // 🔹 স্ক্রিনের উচ্চতার সাথে মিলিয়ে Banner Height অ্যাডজাস্ট হবে
//                       //   height: MediaQuery.of(context).size.height * 0.22, // প্রায় 22% স্ক্রিন হাইট
//                       //
//                       //   child: CarouselSlider(
//                       //     carouselController: _controller,
//                       //     options: CarouselOptions(
//                       //       height: MediaQuery.of(context).size.height * 0.22, // একই height
//                       //       autoPlay: true,
//                       //       enlargeCenterPage: true,
//                       //       viewportFraction: 0.94,
//                       //       autoPlayInterval: const Duration(seconds: 3),
//                       //     ),
//                       //     items: bannerProvider.banners.map((banner) {
//                       //       return GestureDetector(
//                       //         onTap: () {
//                       //           if (banner.link != null && banner.link!.isNotEmpty) {
//                       //             _launchURL(banner.link!);
//                       //           }
//                       //         },
//                       //         child: ClipRRect(
//                       //           borderRadius: BorderRadius.circular(12),
//                       //           child: Container(
//                       //             color: Colors.white,
//                       //             child: Image.network(
//                       //               '$backendUrl/images/${banner.banner}',
//                       //               // fit: BoxFit.cover, // ✅ contain → cover এ পরিবর্তন করলে ভালো অ্যাডজাস্ট হবে
//                       //               fit: BoxFit.contain, // ✅ contain → cover এ পরিবর্তন করলে ভালো অ্যাডজাস্ট হবে
//                       //               width: double.infinity,
//                       //               errorBuilder: (context, error, stackTrace) {
//                       //                 return Container(
//                       //                   color: Colors.grey[200],
//                       //                   child: const Icon(
//                       //                     Icons.error,
//                       //                     color: Colors.grey,
//                       //                   ),
//                       //                 );
//                       //               },
//                       //             ),
//                       //           ),
//                       //         ),
//                       //       );
//                       //     }).toList(),
//                       //   ),
//                       // );
//
//
//                     },
//                   ),
//
//                   SizedBox(height: 20),
//
//                   // 🔥 BD GAME SHOP TITLE SECTION
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal:
//                           MediaQuery.of(context).size.width > 600 ? 24 : 16,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "BD Game Shop",
//                           style: TextStyle(
//                             fontSize:
//                                 MediaQuery.of(context).size.width > 600
//                                     ? 24
//                                     : 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue.shade800,
//                           ),
//                         ),
//                         if (MediaQuery.of(context).size.width > 600)
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.arrow_back_ios,
//                                 size: 16,
//                                 color: Colors.grey,
//                               ),
//                               SizedBox(width: 8),
//                               Icon(
//                                 Icons.arrow_forward_ios,
//                                 size: 16,
//                                 color: Colors.grey,
//                               ),
//                             ],
//                           ),
//                       ],
//                     ),
//                   ),
//
//                   SizedBox(height: 15),
//
//                   // 🔥 DYNAMIC PRODUCT GRID SECTION
//                   Consumer<Topup_Products_Provider>(
//                     builder: (context, productProvider, child) {
//                       // 🔄 লোডিং চলাকালীন
//                       if (productProvider.isLoading) {
//                         return Center(
//                           child: Padding(
//                             padding: EdgeInsets.all(20),
//                             child: CircularProgressIndicator(),
//                           ),
//                         );
//                       }
//
//                       // ❌ যদি কোনো প্রোডাক্ট না থাকে
//                       if (productProvider.products.isEmpty) {
//                         return Container(
//                           padding: EdgeInsets.all(20),
//                           child: Center(
//                             child: Text(
//                               'কোন প্রোডাক্ট পাওয়া যায়নি',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                         );
//                       }
//
//                       // ✅ Responsive Grid
//                       return LayoutBuilder(
//                         builder: (context, constraints) {
//                           int crossAxisCount = 2; // 📱 মোবাইলে প্রতি সারিতে ২টি
//                           double aspectRatio = 0.75;
//
//                           // 💻 বড় স্ক্রিনে column বাড়ানো হবে
//                           if (constraints.maxWidth > 1200) {
//                             crossAxisCount = 5;
//                             aspectRatio = 0.75;
//                           } else if (constraints.maxWidth > 800) {
//                             crossAxisCount = 4;
//                             aspectRatio = 0.8;
//                           } else if (constraints.maxWidth > 600) {
//                             crossAxisCount = 3;
//                             aspectRatio = 0.8;
//                           }
//
//                           return GridView.builder(
//                             physics: NeverScrollableScrollPhysics(),
//                             shrinkWrap: true,
//                             itemCount: productProvider.products.length,
//                             padding: EdgeInsets.symmetric(
//                               horizontal:
//                                   MediaQuery.of(context).size.width > 600
//                                       ? 24
//                                       : 12,
//                             ),
//                             gridDelegate:
//                                 SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: crossAxisCount,
//                                   childAspectRatio: aspectRatio,
//                                   crossAxisSpacing: 12,
//                                   mainAxisSpacing: 12,
//                                 ),
//                             itemBuilder: (context, index) {
//                               final product = productProvider.products[index];
//
//                               return GestureDetector(
//                                 onTap: () {
//                                   Navigator.pushNamed(
//                                     context,
//                                     '/ordersuggestion',
//                                     arguments: {
//                                       'id': product.id ?? 0,
//                                       'image':
//                                           '$backendUrl/images/${product.logo}',
//                                       'title':
//                                           product.name ?? 'Unnamed Product',
//                                       'subtitle': product.topupType ?? 'Topup',
//                                       'description': _stripHtmlTags(
//                                         product.rules ?? 'কোন নিয়ম নেই',
//                                       ),
//                                     },
//                                   );
//                                 },
//                                 child: GameCard(
//                                   image: '$backendUrl/images/${product.logo}',
//                                   title: product.name ?? 'Unnamed Product',
//                                   // subtitle: product.topupType ?? 'Topup',
//                                   // price: "ক্রয় করুন",
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       );
//                     },
//                   ),
//
//                   SizedBox(height: 20),
//
//                   // 🔥 FOOTER SECTION
//                   CustomFooter(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),

////////////////////////////////////////////////////////////////////////////////////////
    );
  }
}

// 🔥 GAME CARD WIDGET (Updated for dynamic data)


class GameCard extends StatelessWidget {
  final String image, title;

  const GameCard({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = screenWidth < 600 ? 13 : 15;

    // GameCard build method-এর ভিতরে:    jemon image temon e thakbe card er vitor,

    // return LayoutBuilder(
    //   builder: (context, constraints) {
    //     final double imageHeight = constraints.maxHeight * 0.75; // 75% image, 25% text
    //     final double fontSize = MediaQuery.of(context).size.width < 600 ? 13 : 15;
    //
    //     return Card(
    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //       elevation: 2,
    //       shadowColor: Colors.grey.shade300,
    //       child: Padding(
    //         padding: EdgeInsets.all(6),
    //         child: Column(
    //           children: [
    //             ClipRRect(
    //               borderRadius: BorderRadius.circular(8),
    //               child: Container(
    //                 height: imageHeight,
    //                 width: double.infinity,
    //                 color: Colors.grey.shade100,
    //                 child: Image.network(
    //                   image,
    //                   fit: BoxFit.contain,
    //                   errorBuilder: (context, error, stackTrace) =>
    //                       Icon(Icons.shopping_bag, size: 50, color: Colors.grey.shade400),
    //                 ),
    //               ),
    //             ),
    //             const SizedBox(height: 6),
    //             Text(
    //               title,
    //               textAlign: TextAlign.center,
    //               style: TextStyle(
    //                 fontWeight: FontWeight.w600,
    //                 fontSize: fontSize,
    //               ),
    //               maxLines: 2,
    //               overflow: TextOverflow.ellipsis,
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      shadowColor: Colors.grey.shade300,
      clipBehavior: Clip.antiAlias,
      // ⚡ Rounded corner image clipping
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch, // ✅ full width image
        children: [
          // 🖼️ প্রোডাক্ট ইমেজ অংশ
          AspectRatio(
            aspectRatio: 1, // ✅ সবসময় স্কয়ার রেশিও রাখবে (width == height)
            child: Container(
              color: Colors.grey.shade100,
              child: Image.network(
                image,
                fit: BoxFit.cover, // 📸 image পুরো জায়গা cover করবে
                errorBuilder:
                    (context, error, stackTrace) => Icon(
                      Icons.shopping_bag,
                      size: 50,
                      color: Colors.grey.shade400,
                    ),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value:
                          progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!
                              : null,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 🏷️ নাম অংশ
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: fontSize,
                height: 1.3, // 🔥 line height একটু কমানো যাতে gap কমে
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    // return  AspectRatio(
    //   aspectRatio: 1, // এখানে ratio manually set করে fine-tune করা যাবে
    //   child: Card(
    //     child: Column(
    //       children: [
    //         Expanded(
    //           flex: 3,
    //           child: Image.network(image, fit: BoxFit.contain),
    //         ),
    //         Expanded(
    //           flex: 1,
    //           child: Text(title, textAlign: TextAlign.center),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

String _stripHtmlTags(String htmlString) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  return htmlString.replaceAll(exp, '');
}



