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
    resizeToAvoidBottomInset: true; // ✅ Keyboard এ UI উপরে উঠে যায়, কিন্তু বন্ধ হয় না

    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;


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


      appBar: CustomAppBar(logoUrl: logoUrl, isLoggedIn: user.isLoggedIn),
      backgroundColor: const Color(0xfff9fafb),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight, // ✅ Footer নিচে রাখার জন্য
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // ✅ Main fix
                children: [
                  // 🔹 Main Content
                  Column(
                    children: [
                      // 🔹 Top Banner
                      Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.blueAccent,
                      ),

                      // 🔹 Profile Image & Details
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
                                image: DecorationImage(
                                  image: NetworkImage(userprofiledata?.avatar ?? ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              userprofiledata?.username ?? 'Unknown',
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),

                            // 🔹 Info Cards
                            _infoCard("User ID:", userprofiledata!.id.toString()),
                            _infoCard("Email:", userprofiledata.email ?? ''),
                            // _phoneSection(context),
                            PhoneEditSection(currentPhone: userprofiledata.phone),

                            // _changePasswordSection(),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // ✅ Footer সবসময় নিচে থাকবে
                  // const CustomFooter(),

                  // 🔹 Keyboard ওপেন থাকলে footer লুকিয়ে ফেলো
                  if (!isKeyboardOpen) const CustomFooter(),


                ],
              ),
            ),
          );
        },
      ),
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



  // Widget _phoneSection(BuildContext context) {
  //   final userProvider = Provider.of<UserProfileProvider>(context, listen: false);
  //   // final currentPhone = userProvider.profileData?.user?.phone ?? 'N/A';
  //   final currentPhone = userProvider.profileData?.data?.phone ?? 'N/A';
  //   final TextEditingController _phoneController =
  //   TextEditingController(text: currentPhone);
  //
  //   bool _isEditingPhone = false;
  //
  //   return StatefulBuilder(
  //     builder: (context, setInnerState) {
  //       return Container(
  //         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  //         padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(10),
  //           boxShadow: [
  //             BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 6)
  //           ],
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 const Text("Phone:",
  //                     style: TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.w600,
  //                         color: Colors.grey)),
  //                 Row(
  //                   children: [
  //                     Text(_phoneController.text),
  //                     const SizedBox(width: 8),
  //                     IconButton(
  //                       icon: Icon(
  //                         _isEditingPhone ? Icons.close : Icons.edit,
  //                         size: 20,
  //                         color: Colors.blueAccent,
  //                       ),
  //                       onPressed: () {
  //                         setInnerState(() {
  //                           _isEditingPhone = !_isEditingPhone;
  //                         });
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //
  //             // ✅ যদি edit mode অন থাকে তাহলে ইনপুট ফর্ম দেখাও
  //             if (_isEditingPhone) ...[
  //               const SizedBox(height: 16),
  //               TextField(
  //                 controller: _phoneController,
  //                 decoration: InputDecoration(
  //                   labelText: "Your phone",
  //                   border:
  //                   OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  //                   contentPadding:
  //                   const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  //                 ),
  //                 keyboardType: TextInputType.phone,
  //               ),
  //               const SizedBox(height: 12),
  //               ElevatedButton(
  //                 onPressed: () async {
  //                   final newPhone = _phoneController.text.trim();
  //                   if (newPhone.isEmpty) {
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       const SnackBar(
  //                         content: Text("⚠️ Phone number cannot be empty!"),
  //                         backgroundColor: Colors.red,
  //                       ),
  //                     );
  //                     return;
  //                   }
  //
  //                   try {
  //                     final prefs = await SharedPreferences.getInstance();
  //                     final token = prefs.getString('auth_token');
  //
  //                     final response = await http.post(
  //                       Uri.parse('$backendUrl/api/v1/change-phone'),
  //                       headers: {
  //                         "Content-Type": "application/json",
  //                         "Authorization": "Bearer $token",
  //                       },
  //                       body: jsonEncode({"phone": newPhone}),
  //                     );
  //
  //                     if (response.statusCode == 200) {
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         const SnackBar(
  //                           content: Text("✅ Phone updated successfully!"),
  //                           backgroundColor: Colors.green,
  //                         ),
  //                       );
  //
  //                       // 🔄 নতুন প্রোফাইল ফেচ করো
  //                       await userProvider.refreshProfile();
  //
  //                       setInnerState(() {
  //                         _isEditingPhone = false;
  //                       });
  //                     } else {
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         SnackBar(
  //                           content:
  //                           Text("❌ Update failed: ${response.body}"),
  //                           backgroundColor: Colors.red,
  //                         ),
  //                       );
  //                     }
  //                   } catch (e) {
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       SnackBar(
  //                         content: Text("🚫 Error: $e"),
  //                         backgroundColor: Colors.red,
  //                       ),
  //                     );
  //                   }
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   minimumSize: const Size(double.infinity, 45),
  //                   shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(8)),
  //                 ),
  //                 child: const Text("Change Phone"),
  //               ),
  //             ],
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }


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

class PhoneEditSection extends StatefulWidget {
  final String? currentPhone;
  const PhoneEditSection({Key? key, this.currentPhone}) : super(key: key);

  @override
  _PhoneEditSectionState createState() => _PhoneEditSectionState();
}

class _PhoneEditSectionState extends State<PhoneEditSection> {
  late TextEditingController _phoneController;
  bool _isEditingPhone = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.currentPhone ?? "");
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider =
    Provider.of<UserProfileProvider>(context, listen: false);

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
          // 🔹 টাইটেল + এডিট আইকন
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
                      setState(() {
                        _isEditingPhone = !_isEditingPhone;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),

          // ✅ যদি edit mode অন থাকে → TextField দেখাবে
          if (_isEditingPhone) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Enter phone",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ✅ Save Button
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

                    await userProvider.refreshProfile();
                    setState(() => _isEditingPhone = false);
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
              child: const Text("Save"),
            ),
          ],
        ],
      ),
    );
  }
}

