import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFFF9FAFE)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      // backgroundImage: AssetImage("assets/user.jpg"), // প্রোফাইল ছবি
                      backgroundImage: AssetImage("user.png"), // প্রোফাইল ছবি
                    ),
                    SizedBox(width: 6),
                    Text("Hellowrizwan"),
                    // Text("rizwan1163018@gmail.com"),
                    Icon(Icons.arrow_drop_down),
                    SizedBox(width: 10),
                  ],
                ),

                // ✅ PNG Image (auto size)
                Flexible(
                  child:Image.asset(
                    'logo.png',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                // const SizedBox(height: 12),

                // ✅ Text without overflow
                // const Flexible(
                //   child: Text(
                //     'Freelane IT Software Solution',
                //     style: TextStyle(
                //       color: Color(0xFF24E6FC),
                //       fontSize: 18,
                //       overflow: TextOverflow.ellipsis, // বা fade ব্যবহার করো
                //     ),
                //     maxLines: 2,
                //   ),
                // ),
              ],
            ),
          ),

          // DrawerHeader(
          //   decoration: const BoxDecoration(color: Colors.blue),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       // ✅ SVG Image
          //       SvgPicture.asset(
          //         'assets/icon/market_logo.svg', // তোমার SVG ফাইলের path
          //         height: 60,
          //         color: Colors.white, // চাইলে সাদা রঙে রঙিন করো
          //       ),
          //       const SizedBox(height: 12),
          //
          //       // ✅ Text
          //       const Text(
          //         'Business Manager',
          //         style: TextStyle(color: Colors.white, fontSize: 24),
          //       ),
          //     ],
          //   ),
          // ),



          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => Navigator.pushNamed(context, '/home'),
          ),

          ListTile(
            leading: Icon(Icons.account_balance_wallet_outlined),
            title: Text('Topup'),
            // onTap: () => Navigator.pushNamed(context, '/users'),
          ),
          ListTile(
            leading: Icon(Icons.shop_2),
            title: Text('Shop'),
            // onTap: () => Navigator.pushNamed(context, '/attendanceScreen_'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('My Profile'),
            onTap: () => Navigator.pushNamed(context, '/personalAttendanceReportScreen_'),
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet_rounded),
            title: Text('Add Money '),
            // onTap: () => Navigator.pushNamed(context, '/marketVisitScreen'),
          ),
          ListTile(
            leading: Icon(Icons.border_all_outlined),
            title: Text('My Order'),
            // onTap: () => Navigator.pushNamed(context, '/PersonalMarketVisitingLogHistryScreen'),
          ),
          ListTile(
            leading: Icon(Icons.add_shopping_cart_sharp),
            title: Text('My Transaction'),
            // onTap: () => Navigator.pushNamed(context, '/PersonalTaDaEntryScreen'),
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text('My Shop'),
            onTap: () => Navigator.pushNamed(context, '/ordersuggestion'),
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text('testing'),
            onTap: () => Navigator.pushNamed(context, '/testing'),
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text('test1'),
            onTap: () => Navigator.pushNamed(context, '/FirestoreCrudExample'),
          ),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Contact Us '),
            onTap: () => Navigator.pushNamed(context, '/MarketingPlanEntryScreen'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),

        ],
      ),
    );
  }
}
