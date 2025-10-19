// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
//
// import '../provider/base_url.dart';
// import '../provider/site_provider.dart';
// import 'customdrawer.dart';
// import 'footer.dart';
// import 'home_screen.dart';
// import 'settingsPage.dart';
//
// class UserProfilePage extends StatelessWidget {
//   const UserProfilePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final siteProvider = Provider.of<SiteProvider>(context);
//     final site = siteProvider.siteData;
//     final logoUrl = "$backendUrl/images/${site?.logo}";
//     return Scaffold(
//       drawer: CustomDrawer(),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         // 🔥 ডিফল্ট Hamburger আইকন লুকিয়ে দিলাম
//         title: Row(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 // 🏠 এখানে তোমার HomeScreen এ নিয়ে যাও
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomeScreen()),
//                 );
//               },
//               // child: Image.asset("assets/logo.png", height: 30,
//               child: Image.network(logoUrl, height: 30,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           Builder(
//             builder: (context) {
//               return InkWell(
//                 onTap: () {
//                   Scaffold.of(context).openDrawer(); // ✅ Drawer open হবে
//                 },
//                 child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     if (constraints.maxWidth < 400) {
//                       // Mobile এ শুধু Image
//                       return const Padding(
//                         padding: EdgeInsets.only(right: 10),
//                         child: CircleAvatar(
//                           backgroundImage: AssetImage("assets/user.png"),
//                         ),
//                       );
//                     } else {
//                       // Tablet/Desktop এ Full Profile
//                       return Row(
//                         children: const [
//                           CircleAvatar(backgroundImage: AssetImage("assets/user.png")),
//                           SizedBox(width: 6),
//                           Text("Hellowfarjan"),
//                           Icon(Icons.arrow_drop_down),
//                           SizedBox(width: 10),
//                         ],
//                       );
//                     }
//                   },
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView( // ← ✅ পুরো স্ক্রলেবল পেজ
//         child: Column(
//           children: [
//             // 🔹 Top Banner Section
//             Container(
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage("assets/5.jpg"),
//                   // NetworkImage(
//                   //   "https://lh3.googleusercontent.com/a/ACg8ocIYFrq63uiy7rJWZPC9CSYHAKyBMIcwy-Ccdg6Fpjl3O_zKDpE=s96-c",
//                   // ),
//                   fit: BoxFit.cover,
//                 ),
//                 gradient: LinearGradient(
//                   colors: [Colors.black87, Colors.transparent],
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 80, bottom: 30),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.white,
//                             border: Border.all(
//                                 color: Colors.grey.shade300, width: 3),
//                           ),
//                           padding: const EdgeInsets.all(2),
//                           child: const CircleAvatar(
//                             radius: 50,
//                             // backgroundImage: NetworkImage(
//                             //   "https://lh3.googleusercontent.com/a/ACg8ocIYFrq63uiy7rJWZPC9CSYHAKyBMIcwy-Ccdg6Fpjl3O_zKDpE=s96-c",
//                             // ),
//
//                                 backgroundImage: AssetImage("assets/user.png"),
//
//                           ),
//                         ),
//                         const SizedBox(width: 20),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "rizwan35-2579",
//                               style: GoogleFonts.poppins(
//                                 fontSize: 22,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             Text(
//                               "rizwan35-2579@diu.edu.bd",
//                               style: GoogleFonts.poppins(
//                                 fontSize: 14,
//                                 color: Colors.white70,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             ElevatedButton(
//                               onPressed: () {
//                                 Navigator.push(context,
//                                     MaterialPageRoute(builder: (context) => const SettingsScreen()));
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.white,
//                                 foregroundColor: Colors.grey[800],
//                                 shadowColor: Colors.black26,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(6),
//                                   side: const BorderSide(color: Colors.grey),
//                                 ),
//                               ),
//                               child: const Text("Settings"),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // 🔹 Stats Section
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: GridView.count(
//                 crossAxisCount:
//                 MediaQuery.of(context).size.width > 800 ? 4 : 2,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//                 children: [
//                   _buildStatCard("391434", "User ID"),
//                   _buildStatCard("৳ 0", "Total Wallet"),
//                   _buildStatCard("0", "Total Spent"),
//                   _buildStatCard("0", "Total Order"),
//                 ],
//               ),
//             ),
//
//             // 🔹 User Info Card
//             Container(
//               margin:
//               const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade100,
//                       borderRadius: const BorderRadius.vertical(
//                           top: Radius.circular(10)),
//                     ),
//                     child: Text(
//                       "User Info",
//                       style: GoogleFonts.poppins(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   const Divider(height: 0),
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Text(
//                       "📞 Phone: 01521416544",
//                       style: GoogleFonts.poppins(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // 🔹 Footer নিচে (Scroll করলে দেখা যাবে)
//              CustomFooter(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatCard(String value, String label) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade200),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             value,
//             style: GoogleFonts.poppins(
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             label,
//             style: GoogleFonts.poppins(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../provider/site_provider.dart';
import '../provider/base_url.dart';
import '../provider/user_profile_provider.dart';
import 'customdrawer.dart';
import 'footer.dart';
import 'home_screen.dart';
import 'settingsPage.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<UserProfileProvider>(context, listen: false)
            .fetchUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<UserProfileProvider>(context);
    final profile = profileProvider.profileData?.data;
    final siteProvider = Provider.of<SiteProvider>(context);
    final site = siteProvider.siteData;
    final logoUrl = "$backendUrl/images/${site?.logo}";

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => HomeScreen())),
              child: Image.network(logoUrl, height: 30),
            ),
          ],
        ),
        actions: [
          Builder(builder: (context) {
            return InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: const Padding(
                padding: EdgeInsets.only(right: 10),
                child: CircleAvatar(backgroundImage: AssetImage("assets/user.png")),
              ),
            );
          }),
        ],
      ),

      body: profileProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : profileProvider.hasError
          ? const Center(child: Text("⚠️ প্রোফাইল লোড করতে ব্যর্থ হয়েছে"))
          : SingleChildScrollView(
        child: Column(
          children: [
            // 🔹 Top Banner
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/5.jpg"),
                  fit: BoxFit.cover,
                ),
                gradient: LinearGradient(
                  colors: [Colors.black87, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Padding(
                padding:
                const EdgeInsets.only(top: 80, bottom: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.grey.shade300,
                                width: 3),
                          ),
                          padding: const EdgeInsets.all(2),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              profile?.avatar ??
                                  "https://cdn-icons-png.flaticon.com/512/149/149071.png",
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile?.username ?? "Unknown User",
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              profile?.email ?? "No email",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                        const SettingsScreen()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.grey[800],
                                shadowColor: Colors.black26,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(6),
                                  side: const BorderSide(
                                      color: Colors.grey),
                                ),
                              ),
                              child: const Text("Settings"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 Stats Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount:
                MediaQuery.of(context).size.width > 800 ? 4 : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildStatCard("${profile?.id ?? 0}", "User ID"),
                  _buildStatCard("৳ ${profile?.wallet ?? 0}", "Wallet"),
                  _buildStatCard("0", "Total Spent"),
                  _buildStatCard("0", "Total Order"),
                ],
              ),
            ),

            // 🔹 User Info Card
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10)),
                    ),
                    child: Text(
                      "User Info",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Divider(height: 0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "📞 Phone: ${profile?.phone ?? "Not added"}",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
