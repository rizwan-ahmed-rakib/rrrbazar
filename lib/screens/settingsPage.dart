import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/base_url.dart';
import '../provider/site_provider.dart';
import '../provider/user_profile_provider.dart' show UserProfileProvider;
import '../provider/user_provider.dart';
import 'custom_app_bar.dart';
import 'customdrawer.dart';
import 'footer.dart';
import 'home_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // bool _isEditingPhone = false;
  // final TextEditingController _phoneController =
  // TextEditingController(text: "01521416544");

  @override
  Widget build(BuildContext context) {
    final siteProvider = Provider.of<SiteProvider>(context);
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider;

    final site = siteProvider.siteData;
    final logoUrl = "$backendUrl/images/${site?.logo}";


    if (userProfileProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userProfileProvider.hasError || userProfileProvider.profileData == null) {
      return const Center(child: Text("⚠️ প্রোফাইল লোড করা যায়নি"));
    }

    final userprofiledata = userProfileProvider.profileData!.data;
    return Scaffold(
      drawer: CustomDrawer(),
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   // 🔥 ডিফল্ট Hamburger আইকন লুকিয়ে দিলাম
      //   title: Row(
      //     children: [
      //       GestureDetector(
      //         onTap: () {
      //           // 🏠 এখানে তোমার HomeScreen এ নিয়ে যাও
      //           Navigator.pushReplacement(
      //             context,
      //             MaterialPageRoute(builder: (context) => HomeScreen()),
      //           );
      //         },
      //         // child: Image.asset("assets/logo.png", height: 30,
      //         child: Image.network(logoUrl, height: 30,
      //         ),
      //       ),
      //     ],
      //   ),
      //   actions: [
      //     Builder(
      //       builder: (context) {
      //         return InkWell(
      //           onTap: () {
      //             Scaffold.of(context).openDrawer(); // ✅ Drawer open হবে
      //           },
      //           child: LayoutBuilder(
      //             builder: (context, constraints) {
      //               if (constraints.maxWidth < 400) {
      //                 // Mobile এ শুধু Image
      //                 return const Padding(
      //                   padding: EdgeInsets.only(right: 10),
      //                   child: CircleAvatar(
      //                     backgroundImage: AssetImage("assets/user.png"),
      //                   ),
      //                 );
      //               } else {
      //                 // Tablet/Desktop এ Full Profile
      //                 return Row(
      //                   children: const [
      //                     CircleAvatar(backgroundImage: AssetImage("assets/user.png")),
      //                     SizedBox(width: 6),
      //                     Text("Hellowfarjan"),
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


      appBar: CustomAppBar( logoUrl: logoUrl, isLoggedIn: user.isLoggedIn,),



      backgroundColor: const Color(0xfff9fafb),



      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔹 Top Banner
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.blueAccent,
            ),

            // 🔹 Profile Image and Info
            Transform.translate(
              offset: const Offset(0, -75),
              child: Column(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white, width: 4),
                      image:  DecorationImage(
                        // image: AssetImage("assets/user.png"),
                        image: NetworkImage(userprofiledata?.avatar ?? ''),
                        // NetworkImage(
                        //     'https://lh3.googleusercontent.com/a/ACg8ocIYFrq63uiy7rJWZPC9CSYHAKyBMIcwy-Ccdg6Fpjl3O_zKDpE=s96-c'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(userprofiledata?.username ?? 'Unknown',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 20),

                  // 🔹 Info Cards
                  _infoCard("User ID:", userprofiledata!.id.toString()),
                  _infoCard("Email:", userprofiledata.email ?? ''),
                  _phoneSection(context),
                  _changePasswordSection(),
                ],
              ),
            ),
            CustomFooter(),

          ],

        ),
      ),



      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       const SizedBox(height: 20),
      //
      //
      //       // CircleAvatar(
      //       //   radius: 50,
      //       //   backgroundImage: NetworkImage(user?.avatar ?? ''),
      //       // ),
      //
      //
      //
      //       Container(
      //         width: 130,
      //         height: 130,
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(100),
      //           border: Border.all(color: Colors.white, width: 4),
      //           image:  DecorationImage(
      //             // image: AssetImage("assets/user.png"),
      //             image:  NetworkImage(user?.avatar ?? ''),
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //       ),
      //
      //       const SizedBox(height: 10),
      //       Text(user?.username ?? 'Unknown',
      //           style: const TextStyle(
      //               fontSize: 22, fontWeight: FontWeight.bold)),
      //       const SizedBox(height: 20),
      //       _infoCard("User ID:", user!.id.toString()),
      //       _infoCard("Email:", user.email ?? ''),
      //       _phoneSection(context),
      //       _changePasswordSection(),
      //       CustomFooter(),
      //     ],
      //
      //   ),
      //
      // ),

    );
  }

  // 🔸 Info Card Widget
  Widget _infoCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 6)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey)),
          Text(value,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // 🔸 Phone Section (Edit Feature)

  // Widget _phoneSection() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  //     padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(10),
  //       boxShadow: [
  //         BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 6)
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             const Text("Phone:",
  //                 style: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600,
  //                     color: Colors.grey)),
  //             Row(
  //               children: [
  //                 ElevatedButton(
  //                   onPressed: () {},
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Colors.blue.shade50,
  //                     foregroundColor: Colors.blueAccent,
  //                     padding:
  //                     const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  //                     textStyle: const TextStyle(fontSize: 13),
  //                   ),
  //                   child: const Text("Verify phone"),
  //                 ),
  //                 const SizedBox(width: 8),
  //                 Text(_phoneController.text),
  //                 const SizedBox(width: 8),
  //                 IconButton(
  //                   icon: Icon(
  //                     _isEditingPhone ? Icons.close : Icons.edit,
  //                     size: 20,
  //                     color: Colors.blueAccent,
  //                   ),
  //                   onPressed: () {
  //                     setState(() {
  //                       _isEditingPhone = !_isEditingPhone;
  //                     });
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //
  //         // 🔸 Editable Form (toggle)
  //         if (_isEditingPhone) ...[
  //           const SizedBox(height: 16),
  //           TextField(
  //             controller: _phoneController,
  //             decoration: InputDecoration(
  //               labelText: "Your phone",
  //               border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(8)),
  //               contentPadding:
  //               const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  //             ),
  //             keyboardType: TextInputType.phone,
  //           ),
  //           const SizedBox(height: 12),
  //           ElevatedButton(
  //             onPressed: () {
  //               setState(() {
  //                 _isEditingPhone = false;
  //               });
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 SnackBar(
  //                   content: Text("Phone changed to ${_phoneController.text}"),
  //                   backgroundColor: Colors.green,
  //                 ),
  //               );
  //             },
  //             style: ElevatedButton.styleFrom(
  //               minimumSize: const Size(double.infinity, 45),
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(8)),
  //             ),
  //             child: const Text("Change Phone"),
  //           ),
  //         ],
  //       ],
  //     ),
  //   );
  // }



  Widget _phoneSection(BuildContext context) {
    final userProvider = Provider.of<UserProfileProvider>(context, listen: false);
    // final currentPhone = userProvider.profileData?.user?.phone ?? 'N/A';
    final currentPhone = userProvider.profileData?.data?.phone ?? 'N/A';
    final TextEditingController _phoneController =
    TextEditingController(text: currentPhone);

    bool _isEditingPhone = false;

    return StatefulBuilder(
      builder: (context, setInnerState) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 6)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Phone:",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey)),
                  Row(
                    children: [
                      Text(_phoneController.text),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          _isEditingPhone ? Icons.close : Icons.edit,
                          size: 20,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          setInnerState(() {
                            _isEditingPhone = !_isEditingPhone;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),

              // ✅ যদি edit mode অন থাকে তাহলে ইনপুট ফর্ম দেখাও
              if (_isEditingPhone) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: "Your phone",
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    final newPhone = _phoneController.text.trim();
                    if (newPhone.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("⚠️ Phone number cannot be empty!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    try {
                      final prefs = await SharedPreferences.getInstance();
                      final token = prefs.getString('auth_token');

                      final response = await http.post(
                        Uri.parse('$backendUrl/api/v1/change-phone'),
                        headers: {
                          "Content-Type": "application/json",
                          "Authorization": "Bearer $token",
                        },
                        body: jsonEncode({"phone": newPhone}),
                      );

                      if (response.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("✅ Phone updated successfully!"),
                            backgroundColor: Colors.green,
                          ),
                        );

                        // 🔄 নতুন প্রোফাইল ফেচ করো
                        await userProvider.refreshProfile();

                        setInnerState(() {
                          _isEditingPhone = false;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                            Text("❌ Update failed: ${response.body}"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("🚫 Error: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Change Phone"),
                ),
              ],
            ],
          ),
        );
      },
    );
  }


  // 🔸 Change Password Section
  Widget _changePasswordSection() {
    final oldController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 6)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Change Password",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey)),
          const SizedBox(height: 16),
          TextField(
            controller: oldController,
            decoration: const InputDecoration(
              hintText: "Old password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: newController,
            decoration: const InputDecoration(
              hintText: "New password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: confirmController,
            decoration: const InputDecoration(
              hintText: "Confirm password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45)),
            child: const Text("Change Password"),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text("Forgot password?"),
            ),
          ),
        ],
      ),
    );
  }
}
