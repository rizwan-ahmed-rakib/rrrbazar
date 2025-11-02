import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/user_profile_provider.dart';
import 'login.dart';


class CustomDrawer extends StatelessWidget {
  String userName = "";
  String userPhoto = "";
  CustomDrawer({Key? key}) : super(key: key);


  final List<Map<String, dynamic>> menuItems = const [
    {"icon": Icons.account_balance_wallet_outlined, "text": "Top up", "route": "/topup"},
    {"icon": Icons.store_mall_directory, "text": "Shop", "route": "/allProductsPage"},
    {"divider": true},
    {"icon": Icons.person_outline, "text": "My Profile", "route": "/userProfilePage"},
    {"icon": Icons.account_balance_wallet, "text": "Add Money", "route": "/addMoneyPage"},
    {"icon": Icons.shopping_bag_outlined, "text": "My Order", "route": "/myOrdersPage"},
    {"icon": Icons.swap_horiz_outlined, "text": "My Transaction", "route": "/myTransactionsPage"},
    {"icon": Icons.store, "text": "My Shop", "route": "/ordersuggestion"},
    {"icon": Icons.contact_support_outlined, "text": "Contact Us", "route": "/contact"},
    {"icon": Icons.logout_rounded, "text": "logout", "route": "/login"},
    {"divider": true},
  ];

  @override
  Widget build(BuildContext context) {
    // ✅ বর্তমানে কোন route এ আছি সেটা বের করা
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final profileProvider = Provider.of<UserProfileProvider>(context);
    final profile = profileProvider.profileData?.data;


    // ✅ Provider থেকে ডাটা থাকলে সেটাকে অগ্রাধিকার দিচ্ছি
    final displayName = profile?.username ?? userName;
    final displayPhoto = profile?.avatar ?? userPhoto;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // ---------- HEADER ----------
          Container(
            color: const Color(0xFFF9FAFE),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                // ✅ Profile Image
                // const CircleAvatar(
                //   radius: 25,
                //   backgroundImage: NetworkImage(
                //     "https://lh3.googleusercontent.com/a/ACg8ocIYFrq63uiy7rJWZPC9CSYHAKyBMIcwy-Ccdg6Fpjl3O_zKDpE=s96-c",
                //   ),
                // ),

                CircleAvatar(
                  backgroundImage: displayPhoto.isNotEmpty
                      ? NetworkImage(displayPhoto)
                      : const AssetImage("assets/user.png") as ImageProvider,
                ),


                const SizedBox(width: 12),

                // ✅ Username & Email
                 Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName.isNotEmpty
                            ? "$displayName"
                            : "Hello, User",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        // "rizwan35-2579@diu.edu.bd",
                       " ${profile?.email}",
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // ✅ Logout Button (Blue background)

                // ElevatedButton(
                //   onPressed: () {
                //
                //     // LoginScreen.handleLogout(context);
                //
                //     Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                //
                //
                //     // Navigator.push(
                //     //   context,
                //     //   MaterialPageRoute(
                //     //     builder: (context) => LoginScreen(),
                //     //   ),
                //     // );
                //
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.blue,
                //     foregroundColor: Colors.white,
                //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                //   ),
                //   child: const Text(
                //     "Logout",
                //     style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                //   ),
                // ),






              ],
            ),
          ),

          _dividerLine(),

          // ---------- MENU ----------
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                if (item["divider"] == true) {
                  return _dividerLine();
                }

                // ✅ বর্তমানে active route এর সাথে মিললে active দেখাবে
                final bool isActive = currentRoute == item["route"];

                return InkWell(

                  // onTap: () {
                  //   if (currentRoute != item["route"]) {
                  //     Navigator.pushNamed(context, item["route"]);
                  //   }
                  // },

                  onTap: () async {
                    // 🔹 Drawer বন্ধ করো
                    Navigator.pop(context);

                    if (item["text"] == "Contact Us") {
                      const phoneNumber = "+8801711223344"; // ✅ তোমার WhatsApp নম্বর
                      final Uri whatsappUrl = Uri.parse("https://wa.me/$phoneNumber?text=Hello%20Rangvo%20Support!");

                      if (await canLaunchUrl(whatsappUrl)) {
                        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Could not open WhatsApp")),
                        );
                      }

                    } else if (currentRoute != item["route"]) {
                      Navigator.pushNamed(context, item["route"]);
                    }
                  },

                  child: Container(
                    color: isActive ? Colors.blue.withOpacity(0.08) : null,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Icon(
                          item["icon"],
                          color: isActive ? Colors.blue : Colors.grey[700],
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          item["text"],
                          style: TextStyle(
                            color: isActive ? Colors.blue : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );

              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _dividerLine() {
    return Container(
      width: double.infinity,
      height: 1.5,
      color: const Color(0xFFF1F1FF),
      margin: const EdgeInsets.symmetric(vertical: 5),
    );
  }
}


