// import 'package:flutter/material.dart';
// // import 'package:flutter_svg/flutter_svg.dart';
//
// class CustomDrawer extends StatelessWidget {
//   const CustomDrawer({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           DrawerHeader(
//             decoration: const BoxDecoration(color: Color(0xFFF9FAFE)),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       // backgroundImage: AssetImage("assets/user.jpg"), // প্রোফাইল ছবি
//                       backgroundImage: AssetImage("user.png"), // প্রোফাইল ছবি
//                     ),
//                     SizedBox(width: 6),
//                     Text("Hellowrizwan"),
//                     // Text("rizwan1163018@gmail.com"),
//                     Icon(Icons.arrow_drop_down),
//                     SizedBox(width: 10),
//                   ],
//                 ),
//
//                 // ✅ PNG Image (auto size)
//                 Flexible(
//                   child:Image.asset(
//                     'logo.png',
//                     height: 100,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//                 // const SizedBox(height: 12),
//
//                 // ✅ Text without overflow
//                 // const Flexible(
//                 //   child: Text(
//                 //     'Freelane IT Software Solution',
//                 //     style: TextStyle(
//                 //       color: Color(0xFF24E6FC),
//                 //       fontSize: 18,
//                 //       overflow: TextOverflow.ellipsis, // বা fade ব্যবহার করো
//                 //     ),
//                 //     maxLines: 2,
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//
//           // DrawerHeader(
//           //   decoration: const BoxDecoration(color: Colors.blue),
//           //   child: Column(
//           //     crossAxisAlignment: CrossAxisAlignment.start,
//           //     mainAxisAlignment: MainAxisAlignment.center,
//           //     children: [
//           //       // ✅ SVG Image
//           //       SvgPicture.asset(
//           //         'assets/icon/market_logo.svg', // তোমার SVG ফাইলের path
//           //         height: 60,
//           //         color: Colors.white, // চাইলে সাদা রঙে রঙিন করো
//           //       ),
//           //       const SizedBox(height: 12),
//           //
//           //       // ✅ Text
//           //       const Text(
//           //         'Business Manager',
//           //         style: TextStyle(color: Colors.white, fontSize: 24),
//           //       ),
//           //     ],
//           //   ),
//           // ),
//
//
//
//           // ListTile(
//           //   leading: Icon(Icons.home),
//           //   title: Text('Home'),
//           //   onTap: () => Navigator.pushNamed(context, '/home'),
//           // ),
//
//           ListTile(
//             leading: Icon(Icons.account_balance_wallet_outlined),
//             title: Text('Topup'),
//             // onTap: () => Navigator.pushNamed(context, '/users'),
//           ),
//           ListTile(
//             leading: Icon(Icons.shop_2),
//             title: Text('Shop'),
//             onTap: () => Navigator.pushNamed(context, '/allProductsPage'),
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.person),
//             title: Text('My Profile'),
//             onTap: () => Navigator.pushNamed(context, '/userProfilePage'),
//           ),
//           ListTile(
//             leading: Icon(Icons.account_balance_wallet_rounded),
//             title: Text('Add Money '),
//             onTap: () => Navigator.pushNamed(context, '/addMoneyPage'),
//           ),
//           ListTile(
//             leading: Icon(Icons.border_all_outlined),
//             title: Text('My Order'),
//             // onTap: () => Navigator.pushNamed(context, '/PersonalMarketVisitingLogHistryScreen'),
//           ),
//           ListTile(
//             leading: Icon(Icons.add_shopping_cart_sharp),
//             title: Text('My Transaction'),
//             // onTap: () => Navigator.pushNamed(context, '/PersonalTaDaEntryScreen'),
//           ),
//           ListTile(
//             leading: Icon(Icons.list_alt),
//             title: Text('My Shop'),
//             onTap: () => Navigator.pushNamed(context, '/ordersuggestion'),
//           ),
//           // ListTile(
//           //   leading: Icon(Icons.list_alt),
//           //   title: Text('testing'),
//           //   onTap: () => Navigator.pushNamed(context, '/testing'),
//           // ),
//           // ListTile(
//           //   leading: Icon(Icons.list_alt),
//           //   title: Text('test1'),
//           //   onTap: () => Navigator.pushNamed(context, '/FirestoreCrudExample'),
//           // ),
//           ListTile(
//             leading: Icon(Icons.assignment),
//             title: Text('Contact Us '),
//             onTap: () => Navigator.pushNamed(context, '/MarketingPlanEntryScreen'),
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.logout),
//             title: Text('Logout'),
//             onTap: () {
//               Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
//             },
//           ),
//
//         ],
//       ),
//     );
//   }
// }

//////////////////////////////////////////////////////////////////


// import 'package:flutter/material.dart';
//
// class CustomDrawer extends StatefulWidget {
//   const CustomDrawer({Key? key}) : super(key: key);
//
//   @override
//   State<CustomDrawer> createState() => _CustomDrawerState();
// }
//
// class _CustomDrawerState extends State<CustomDrawer> {
//   String activeRoute = "/contact"; // প্রাথমিকভাবে যেটা active থাকবে
//
//   final List<Map<String, dynamic>> menuItems = [
//     {"icon": Icons.account_balance_wallet_outlined, "text": "Top up", "route": "/topup"},
//     {"icon": Icons.store_mall_directory, "text": "Shop", "route": "/allProductsPage"},
//     {"divider": true},
//     {"icon": Icons.person_outline, "text": "My Profile", "route": "/userProfilePage"},
//     {"icon": Icons.account_balance_wallet, "text": "Add Money", "route": "/addMoneyPage"},
//     {"icon": Icons.shopping_bag_outlined, "text": "My Order", "route": "/order"},
//     {"icon": Icons.swap_horiz_outlined, "text": "My Transaction", "route": "/transaction"},
//     {"icon": Icons.store, "text": "My Shop", "route": "/ordersuggestion"},
//     {"icon": Icons.contact_support_outlined, "text": "Contact Us", "route": "/contact"},
//     {"divider": true},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       width: MediaQuery.of(context).size.width * 0.75,
//       backgroundColor: Colors.white,
//       child: Column(
//         children: [
//           // ---------- HEADER ----------
//           Container(
//             color: const Color(0xFFF9FAFE),
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//             child: Row(
//               children: [
//                 // ✅ Profile Image
//                 CircleAvatar(
//                   radius: 25,
//                   backgroundColor: Colors.grey[200],
//                   backgroundImage: const NetworkImage(
//                     "https://lh3.googleusercontent.com/a/ACg8ocIYFrq63uiy7rJWZPC9CSYHAKyBMIcwy-Ccdg6Fpjl3O_zKDpE=s96-c",
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//
//                 // ✅ Username & Email
//                 const Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "rizwan35-2579",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       Text(
//                         "rizwan35-2579@diu.edu.bd",
//                         style: TextStyle(fontSize: 13, color: Colors.black54),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // ✅ Logout Button (Blue background)
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//                   ),
//                   child: const Text("Logout", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
//                 ),
//               ],
//             ),
//           ),
//
//           // ---------- Divider ----------
//           Container(
//             height: 1.5,
//             color: const Color(0xFFF1F1FF),
//             margin: const EdgeInsets.symmetric(vertical: 5),
//           ),
//
//           // ---------- MENU ----------
//           Expanded(
//             child: ListView.builder(
//               padding: EdgeInsets.zero,
//               itemCount: menuItems.length,
//               itemBuilder: (context, index) {
//                 final item = menuItems[index];
//                 if (item["divider"] == true) {
//                   return _dividerLine();
//                 }
//
//                 final bool isActive = item["route"] == activeRoute;
//
//                 return InkWell(
//                   onTap: () {
//                     setState(() {
//                       activeRoute = item["route"];
//                     });
//                     Navigator.pushNamed(context, item["route"]);
//                   },
//                   child: Container(
//                     color: isActive ? Colors.blue.withOpacity(0.08) : null,
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     child: Row(
//                       children: [
//                         Icon(
//                           item["icon"],
//                           color: isActive ? Colors.blue : Colors.grey[700],
//                           size: 22,
//                         ),
//                         const SizedBox(width: 12),
//                         Text(
//                           item["text"],
//                           style: TextStyle(
//                             color: isActive ? Colors.blue : Colors.black87,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ---------- Divider ----------
//   Widget _dividerLine() {
//     return Container(
//       width: double.infinity,
//       height: 1.5,
//       color: const Color(0xFFF1F1FF),
//       margin: const EdgeInsets.symmetric(vertical: 5),
//     );
//   }
// }



import 'package:flutter/material.dart';

import 'login.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

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
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    "https://lh3.googleusercontent.com/a/ACg8ocIYFrq63uiy7rJWZPC9CSYHAKyBMIcwy-Ccdg6Fpjl3O_zKDpE=s96-c",
                  ),
                ),
                const SizedBox(width: 12),

                // ✅ Username & Email
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "rizwan35-2579",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "rizwan35-2579@diu.edu.bd",
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // ✅ Logout Button (Blue background)

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);


                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => LoginScreen(),
                    //   ),
                    // );

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),


                // ElevatedButton(
                //   onPressed: () {
                //     // 🔹 আগে Drawer বন্ধ করো
                //     Navigator.pop(context);
                //
                //     // 🔹 তারপর login পেজে নিয়ে যাও
                //     Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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
                  onTap: () {
                    if (currentRoute != item["route"]) {
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


