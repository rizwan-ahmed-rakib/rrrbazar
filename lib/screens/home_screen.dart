import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'customdrawer.dart';
import 'footer.dart';
import 'ordersuggestion.dart';

class HomeScreen extends StatelessWidget {
  final CarouselSliderController _controller = CarouselSliderController();

  final List<Map<String, String>> banners = [
    {
      "image": "assets/banner1.png",
      "url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
    },
    {
      "image": "assets/banner2.png",
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
      "image": "assets/product_image/freefire.jpg",
      "title": "Free Fire (Id Code)",
      "subtitle": "Bd sarvar",
      "price": "42",
      "description": "⚠️ player I'd ভুল দিয়ে অরডার করে Diamond না পেলে"
          " RRRBAZAR কর্তৃপক্ষ দায়ি থাকবে না।🇧🇩 এই সেকশন থেকে শুধু বাংলাদেশ সার্ভার এ টপ-আপ করতে পারবেন।"
          "🤖 যেই অরডার এর পাশে [ 🤖 👈 ] এইটা আছে সেই অরডার Ai দারা কমপ্লিট হয়।"
          "🎯 যাদের আইডিতে আগে থেকে Level up pass📗 নেওয়া আছে, তারা আবার নিলে সেটার পরিবর্তে [243💎] টপ-আপ হয়ে যাবে।",
    },
    {
      "image": "assets/product_image/freefirelike.jpg",
      "title": "Free Fire Like",
      "subtitle": "1 দিনে 100 Like",
      "description": "⚠️ player I'd ভুল দিয়ে অরডার করে Diamond না পেলে"
          " RRRBAZAR কর্তৃপক্ষ দায়ি থাকবে না।🇧🇩 এই সেকশন থেকে শুধু বাংলাদেশ সার্ভার এ টপ-আপ করতে পারবেন।"
          "🤖 যেই অরডার এর পাশে [ 🤖 👈 ] এইটা আছে সেই অরডার Ai দারা কমপ্লিট হয়।"
          "🎯 যাদের আইডিতে আগে থেকে Level up pass📗 নেওয়া আছে, তারা আবার নিলে সেটার পরিবর্তে [243💎] টপ-আপ হয়ে যাবে।",
      "price": "155",
    },
    {
      "image": "assets/product_image/tiktokCoin.jpg",
      "title": "Weekly Pass",
      "subtitle": "7 days offer",
      "description": "⚠️ player I'd ভুল দিয়ে অরডার করে Diamond না পেলে"
          " RRRBAZAR কর্তৃপক্ষ দায়ি থাকবে না।🇧🇩 এই সেকশন থেকে শুধু বাংলাদেশ সার্ভার এ টপ-আপ করতে পারবেন।"
          "🤖 যেই অরডার এর পাশে [ 🤖 👈 ] এইটা আছে সেই অরডার Ai দারা কমপ্লিট হয়।"
          "🎯 যাদের আইডিতে আগে থেকে Level up pass📗 নেওয়া আছে, তারা আবার নিলে সেটার পরিবর্তে [243💎] টপ-আপ হয়ে যাবে।",
      "price": "299",
    },
    {
      "image": "assets/product_image/unpinvoutcher.jpg",
      "title": "Monthly Pack",
      "subtitle": "30 days special",
      "price": "999",
      "description": "⚠️ player I'd ভুল দিয়ে অরডার করে Diamond না পেলে"
          " RRRBAZAR কর্তৃপক্ষ দায়ি থাকবে না।🇧🇩 এই সেকশন থেকে শুধু বাংলাদেশ সার্ভার এ টপ-আপ করতে পারবেন।"
          "🤖 যেই অরডার এর পাশে [ 🤖 👈 ] এইটা আছে সেই অরডার Ai দারা কমপ্লিট হয়।"
          "🎯 যাদের আইডিতে আগে থেকে Level up pass📗 নেওয়া আছে, তারা আবার নিলে সেটার পরিবর্তে [243💎] টপ-আপ হয়ে যাবে।",
    },
    {
      "image": "assets/product_image/levelup_pass.jpg",
      "title": "Free Fire (Id Code)",
      "subtitle": "Bd sarvar",
      "price": "42",
      "description": "⚠️ player I'd ভুল দিয়ে অরডার করে Diamond না পেলে"
          " RRRBAZAR কর্তৃপক্ষ দায়ি থাকবে না।🇧🇩 এই সেকশন থেকে শুধু বাংলাদেশ সার্ভার এ টপ-আপ করতে পারবেন।"
          "🤖 যেই অরডার এর পাশে [ 🤖 👈 ] এইটা আছে সেই অরডার Ai দারা কমপ্লিট হয়।"
          "🎯 যাদের আইডিতে আগে থেকে Level up pass📗 নেওয়া আছে, তারা আবার নিলে সেটার পরিবর্তে [243💎] টপ-আপ হয়ে যাবে।",
    },
    {
      "image": "assets/product_image/airdrop_uid_code.jpg",
      "title": "Free Fire Like",
      "subtitle": "1 দিনে 100 Like",
      "price": "155",
      "description": "⚠️ player I'd ভুল দিয়ে অরডার করে Diamond না পেলে"
          " RRRBAZAR কর্তৃপক্ষ দায়ি থাকবে না।🇧🇩 এই সেকশন থেকে শুধু বাংলাদেশ সার্ভার এ টপ-আপ করতে পারবেন।"
          "🤖 যেই অরডার এর পাশে [ 🤖 👈 ] এইটা আছে সেই অরডার Ai দারা কমপ্লিট হয়।"
          "🎯 যাদের আইডিতে আগে থেকে Level up pass📗 নেওয়া আছে, তারা আবার নিলে সেটার পরিবর্তে [243💎] টপ-আপ হয়ে যাবে।",
    },
    {
      "image": "assets/product_image/evo_access_id_code.jpg",
      "title": "Weekly Pass",
      "subtitle": "7 days offer",
      "price": "299",
      "description": "⚠️ player I'd ভুল দিয়ে অরডার করে Diamond না পেলে"
          " RRRBAZAR কর্তৃপক্ষ দায়ি থাকবে না।🇧🇩 এই সেকশন থেকে শুধু বাংলাদেশ সার্ভার এ টপ-আপ করতে পারবেন।"
          "🤖 যেই অরডার এর পাশে [ 🤖 👈 ] এইটা আছে সেই অরডার Ai দারা কমপ্লিট হয়।"
          "🎯 যাদের আইডিতে আগে থেকে Level up pass📗 নেওয়া আছে, তারা আবার নিলে সেটার পরিবর্তে [243💎] টপ-আপ হয়ে যাবে।",
    },
    {
      "image": "assets/product_image/freefire_singapore_server.jpg",
      "title": "Monthly Pack",
      "subtitle": "30 days special",
      "price": "999",
      "description": "⚠️ player I'd ভুল দিয়ে অরডার করে Diamond না পেলে"
          " RRRBAZAR কর্তৃপক্ষ দায়ি থাকবে না।🇧🇩 এই সেকশন থেকে শুধু বাংলাদেশ সার্ভার এ টপ-আপ করতে পারবেন।"
          "🤖 যেই অরডার এর পাশে [ 🤖 👈 ] এইটা আছে সেই অরডার Ai দারা কমপ্লিট হয়।"
          "🎯 যাদের আইডিতে আগে থেকে Level up pass📗 নেওয়া আছে, তারা আবার নিলে সেটার পরিবর্তে [243💎] টপ-আপ হয়ে যাবে।",
    },
    {
      "image": "assets/product_image/id_code_indonesia.jpg",
      "title": "id code indonesia",
      "subtitle": "30 days special",
      "price": "999",
      "description": "⚠️ player I'd ভুল দিয়ে অরডার করে Diamond না পেলে"
          " RRRBAZAR কর্তৃপক্ষ দায়ি থাকবে না।🇧🇩 এই সেকশন থেকে শুধু বাংলাদেশ সার্ভার এ টপ-আপ করতে পারবেন।"
          "🤖 যেই অরডার এর পাশে [ 🤖 👈 ] এইটা আছে সেই অরডার Ai দারা কমপ্লিট হয়।"
          "🎯 যাদের আইডিতে আগে থেকে Level up pass📗 নেওয়া আছে, তারা আবার নিলে সেটার পরিবর্তে [243💎] টপ-আপ হয়ে যাবে।",
    },
    {
      "image": "assets/product_image/pubg.jpg",
      "title": "PUBG",
      "subtitle": "30 days special",
      "price": "999",
      "description": "⚠️ player I'd ভুল দিয়ে অরডার করে Diamond না পেলে"
          " RRRBAZAR কর্তৃপক্ষ দায়ি থাকবে না।🇧🇩 এই সেকশন থেকে শুধু বাংলাদেশ সার্ভার এ টপ-আপ করতে পারবেন।"
          "🤖 যেই অরডার এর পাশে [ 🤖 👈 ] এইটা আছে সেই অরডার Ai দারা কমপ্লিট হয়।"
          "🎯 যাদের আইডিতে আগে থেকে Level up pass📗 নেওয়া আছে, তারা আবার নিলে সেটার পরিবর্তে [243💎] টপ-আপ হয়ে যাবে।",
    },
    {
      "image": "assets/product_image/clash_of_clan.jpg",
      "title": "clash_of_clan.jpg",
      "subtitle": "30 days special",
      "price": "999",
      "description":"",
    },
    {
      "image": "assets/product_image/efootball.jpg",
      "title": "efootball.jpg",
      "subtitle": "30 days special",
      "price": "999",
      "description":"",

    },
    {
      "image": "assets/product_image/youtube_premium.jpg",
      "title": "youtube_premium.jpg",
      "subtitle": "30 days special",
      "price": "999",
      "description":"",

    },
    {
      "image": "assets/product_image/twitter_premium.jpg",
      "title": "twitter_premium.jpg",
      "subtitle": "30 days special",
      "price": "999",
      "description":"",

    },
    {
      "image": "assets/product_image/apple_music.jpg",
      "title": "apple_music.jpg",
      "subtitle": "30 days special",
      "price": "999",
      "description":"",

    },
    {
      "image": "assets/product_image/netflix.jpg",
      "title": "netflix.jpg",
      "subtitle": "30 days special",
      "price": "999",
      "description":"",

    },
    {
      "image": "assets/product_image/amazon.jpg",
      "title": "amazon.jpg",
      "subtitle": "30 days special",
      "price": "999",
      "description":"",

    },
    {
      "image": "assets/product_image/zee-5.jpg",
      "title": "zee-5.jpg",
      "subtitle": "30 days special",
      "price": "999",
      "description":"",

    },
    {
      "image": "assets/product_image/disnep.jpg",
      "title": "disnep.jpg",
      "subtitle": "30 days special",
      "price": "999",
      "description":"",

    },
    {
      "image": "assets/product_image/chorki.jpg",
      "title": "chorki.jpg",
      "subtitle": "30 days special",
      "price": "999",
      "description":"",

    },
    {
      "image": "assets/product_image/spotify.jpg",
      "title": "spotify.jpg",
      "subtitle": "30 days special",
      "price": "999",
      "description":"",

    },
    {
      "image": "assets/product_image/hoichoi.jpg",
      "title": "hoichoi.jpg",
      "subtitle": "30 days special",
      "price": "999",
      "description":"",

    },
    {
      "image": "assets/product_image/curnchyroll.jpg",
      "title": "curnchyroll.jpg",
      "subtitle": "30 days special",
      "price": "999",
      "description":"",

    },
    {
      "image": "assets/product_image/hbo_max.jpg",
      "title": "hbo_max.jpg",
      "subtitle": "30 days special",
      "price": "999",
      "description":"",

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
      drawer: const CustomDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // 🔥 ডিফল্ট Hamburger আইকন লুকিয়ে দিলাম
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                // 🏠 এখানে তোমার HomeScreen এ নিয়ে যাও
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => HomeScreen()),
                // );
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

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 2),

                  // 🔥 BANNER CAROUSEL SECTION - Mobile friendly height
                  Container(
                    height: 150, // 🔥 Mobile এ height কমিয়ে overlap avoid
                    child: CarouselSlider(
                      carouselController: _controller,
                      options: CarouselOptions(
                        height: 150,
                        // 🔥 Options এও same height set করুন
                        autoPlay: true,
                        enlargeCenterPage: true,
                        // viewportFraction: 0.75,
                        viewportFraction: 0.94,
                        // 🔥 Mobile এ viewport fraction adjust
                        autoPlayInterval: Duration(seconds: 3),
                      ),
                      items:
                          banners.map((banner) {
                            return GestureDetector(
                              onTap: () => _launchURL(banner["url"]!),
                              child: ClipRRect(
                                // borderRadius: BorderRadius.circular(16),
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
                                        description: product["description"]!,
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
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Card-এর curve
      ),
      elevation: 1,
      child: Container(
        height: 230,
        padding: EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // PRODUCT IMAGE with top curve
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), // Card-এর curve match করবে
                topRight: Radius.circular(8),
              ),
              child: Container(
                height: 210,
                width: double.infinity,
                child: Image.asset(
                  image,
                  fit: BoxFit.contain, // contain চাইলে contain দিন othoba cover
                ),
              ),
            ),

            SizedBox(height: 6),

            // Product Title
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              textAlign: TextAlign.center,
            ),
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
