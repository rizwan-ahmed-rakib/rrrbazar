import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../provider/site_provider.dart';
import '../provider/base_url.dart';
import '../provider/user_profile_provider.dart';
import '../provider/user_provider.dart';
import 'custom_app_bar.dart';
import 'customdrawer.dart';
import 'footer.dart';
import 'home_screen.dart';
import 'login.dart';
import 'registration_screen.dart';
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
    Future.microtask(
      () =>
          Provider.of<UserProfileProvider>(
            context,
            listen: false,
          ).fetchUserProfile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<UserProfileProvider>(context);
    final profile = profileProvider.profileData?.data;
    final siteProvider = Provider.of<SiteProvider>(context);
    final site = siteProvider.siteData;
    final logoUrl = "$backendUrl/images/${site?.logo}";
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider;

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(logoUrl: logoUrl, isLoggedIn: user.isLoggedIn),

      ////////////////////////////  with refresh profile page is coded bellow ////////////////////
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<UserProfileProvider>(context, listen: false).refreshProfile();

        },
        child:
            profileProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : profileProvider.hasError
                ? const Center(child: Text("⚠️ প্রোফাইল লোড করতে ব্যর্থ হয়েছে"))
                // : _buildProfileContent(context, profileProvider, siteProvider),
                : LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(), // ✅ রিফ্রেশ কাজের জন্য দরকার
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight:
                              constraints.maxHeight, // ✅ footer নিচে রাখার জন্য
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 🔹 মূল কনটেন্ট
                            Column(
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
                                      colors: [
                                        Colors.black87,
                                        Colors.transparent,
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 80,
                                      bottom: 30,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: Colors.grey.shade300,
                                                  width: 3,
                                                ),
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
                                                  profile?.username ??
                                                      "Unknown User",
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
                                                        builder:
                                                            (_) =>
                                                                const SettingsScreen(),
                                                      ),
                                                    );
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    foregroundColor:
                                                        Colors.grey[800],
                                                    shadowColor: Colors.black26,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                      side: const BorderSide(
                                                        color: Colors.grey,
                                                      ),
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
                                        MediaQuery.of(context).size.width > 800
                                            ? 4
                                            : 2,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    children: [
                                      _buildStatCard(
                                        "${profile?.id ?? 0}",
                                        "User ID",
                                      ),
                                      _buildStatCard(
                                        "৳ ${profile?.wallet ?? 0}",
                                        "Wallet",
                                      ),
                                      // _buildStatCard("0", "Total Spent"),
                                      // _buildStatCard("0", "Total Order"),
                                    ],
                                  ),
                                ),

                                // 🔹 User Info Card
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                top: Radius.circular(10),
                                              ),
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
                                const SizedBox(height: 30),
                              ],
                            ),

                            // 🔹 Footer সবসময় নিচে থাকবে
                            const CustomFooter(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),

      //////////////////////////////////////////////////////////////

      //////////////// without refresh profile page is coded bellow//////////////////////////////////////

      // body: profileProvider.isLoading
      //     ? const Center(child: CircularProgressIndicator())
      //     : profileProvider.hasError
      //     ? const Center(child: Text("⚠️ প্রোফাইল লোড করতে ব্যর্থ হয়েছে"))
      //     : LayoutBuilder(
      //   builder: (context, constraints) {
      //     return SingleChildScrollView(
      //       child: ConstrainedBox(
      //         constraints: BoxConstraints(
      //           minHeight: constraints.maxHeight, // ✅ footer নিচে রাখার জন্য
      //         ),
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             // 🔹 মূল কনটেন্ট
      //             Column(
      //               children: [
      //                 // 🔹 Top Banner
      //                 Container(
      //                   width: double.infinity,
      //                   decoration: const BoxDecoration(
      //                     image: DecorationImage(
      //                       image: AssetImage("assets/5.jpg"),
      //                       fit: BoxFit.cover,
      //                     ),
      //                     gradient: LinearGradient(
      //                       colors: [Colors.black87, Colors.transparent],
      //                       begin: Alignment.bottomCenter,
      //                       end: Alignment.topCenter,
      //                     ),
      //                   ),
      //                   child: Padding(
      //                     padding:
      //                     const EdgeInsets.only(top: 80, bottom: 30),
      //                     child: Column(
      //                       children: [
      //                         Row(
      //                           mainAxisAlignment:
      //                           MainAxisAlignment.center,
      //                           children: [
      //                             Container(
      //                               decoration: BoxDecoration(
      //                                 shape: BoxShape.circle,
      //                                 color: Colors.white,
      //                                 border: Border.all(
      //                                   color: Colors.grey.shade300,
      //                                   width: 3,
      //                                 ),
      //                               ),
      //                               padding: const EdgeInsets.all(2),
      //                               child: CircleAvatar(
      //                                 radius: 50,
      //                                 backgroundImage: NetworkImage(
      //                                   profile?.avatar ??
      //                                       "https://cdn-icons-png.flaticon.com/512/149/149071.png",
      //                                 ),
      //                               ),
      //                             ),
      //                             const SizedBox(width: 20),
      //                             Column(
      //                               crossAxisAlignment:
      //                               CrossAxisAlignment.start,
      //                               children: [
      //                                 Text(
      //                                   profile?.username ??
      //                                       "Unknown User",
      //                                   style: GoogleFonts.poppins(
      //                                     fontSize: 22,
      //                                     color: Colors.white,
      //                                     fontWeight: FontWeight.w600,
      //                                   ),
      //                                 ),
      //                                 Text(
      //                                   profile?.email ?? "No email",
      //                                   style: GoogleFonts.poppins(
      //                                     fontSize: 14,
      //                                     color: Colors.white70,
      //                                   ),
      //                                 ),
      //                                 const SizedBox(height: 8),
      //                                 ElevatedButton(
      //                                   onPressed: () {
      //                                     Navigator.push(
      //                                       context,
      //                                       MaterialPageRoute(
      //                                         builder: (_) =>
      //                                         const SettingsScreen(),
      //                                       ),
      //                                     );
      //                                   },
      //                                   style: ElevatedButton.styleFrom(
      //                                     backgroundColor: Colors.white,
      //                                     foregroundColor:
      //                                     Colors.grey[800],
      //                                     shadowColor: Colors.black26,
      //                                     shape: RoundedRectangleBorder(
      //                                       borderRadius:
      //                                       BorderRadius.circular(6),
      //                                       side: const BorderSide(
      //                                         color: Colors.grey,
      //                                       ),
      //                                     ),
      //                                   ),
      //                                   child: const Text("Settings"),
      //                                 ),
      //                               ],
      //                             ),
      //                           ],
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //
      //                 // 🔹 Stats Section
      //                 Padding(
      //                   padding: const EdgeInsets.all(16.0),
      //                   child: GridView.count(
      //                     crossAxisCount:
      //                     MediaQuery.of(context).size.width > 800
      //                         ? 4
      //                         : 2,
      //                     shrinkWrap: true,
      //                     physics:
      //                     const NeverScrollableScrollPhysics(),
      //                     crossAxisSpacing: 12,
      //                     mainAxisSpacing: 12,
      //                     children: [
      //                       _buildStatCard(
      //                           "${profile?.id ?? 0}", "User ID"),
      //                       _buildStatCard(
      //                           "৳ ${profile?.wallet ?? 0}", "Wallet"),
      //                       // _buildStatCard("0", "Total Spent"),
      //                       // _buildStatCard("0", "Total Order"),
      //                     ],
      //                   ),
      //                 ),
      //
      //                 // 🔹 User Info Card
      //                 Container(
      //                   margin: const EdgeInsets.symmetric(
      //                     horizontal: 16,
      //                     vertical: 10,
      //                   ),
      //                   decoration: BoxDecoration(
      //                     border:
      //                     Border.all(color: Colors.grey.shade300),
      //                     borderRadius: BorderRadius.circular(10),
      //                   ),
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Container(
      //                         padding: const EdgeInsets.symmetric(
      //                           horizontal: 16,
      //                           vertical: 12,
      //                         ),
      //                         decoration: BoxDecoration(
      //                           color: Colors.grey.shade100,
      //                           borderRadius:
      //                           const BorderRadius.vertical(
      //                             top: Radius.circular(10),
      //                           ),
      //                         ),
      //                         child: Text(
      //                           "User Info",
      //                           style: GoogleFonts.poppins(
      //                             fontSize: 16,
      //                             fontWeight: FontWeight.w600,
      //                           ),
      //                         ),
      //                       ),
      //                       const Divider(height: 0),
      //                       Padding(
      //                         padding: const EdgeInsets.all(16.0),
      //                         child: Text(
      //                           "📞 Phone: ${profile?.phone ?? "Not added"}",
      //                           style: GoogleFonts.poppins(
      //                             fontSize: 15,
      //                             fontWeight: FontWeight.w500,
      //                           ),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 const SizedBox(height: 30),
      //               ],
      //             ),
      //
      //             // 🔹 Footer সবসময় নিচে থাকবে
      //             const CustomFooter(),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),

      ////////////////////////////////////////////////////
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
