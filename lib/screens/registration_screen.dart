import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
// import '../provider/base_url.dart' show backendUrl, saveTokenToLocalStorage;
import '../provider/base_url.dart';
import '../provider/shared_local_storage.dart';
import '../provider/site_provider.dart';
import '../provider/user_provider.dart';
import 'custom_app_bar.dart';
import 'footer.dart';
import 'home_screen.dart';
import 'login.dart';
import 'userProfile_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {


  final GoogleSignIn _googleSignUp = GoogleSignIn(
    clientId:
    "895753625041-1eqels2t6o99ieit8mr157oqkt4sl4lu.apps.googleusercontent.com", // তোমার Web Client ID  Rizwan
    // "895753625041-2f11rtjpcgt2rgq9rg3303hee3s5aa1g.apps.googleusercontent.com", // তোমার Android Client ID  Rizwan
    // "590339419279-68oe6vvg86t9chn5ruj83okftjuji2d7.apps.googleusercontent.com", //  Web Client ID  RRRBazar
    scopes: ['email', 'profile','openid'],
  );


  Future<void> _checkIfAlreadySignedUp() async {
    final user = await _googleSignUp.signInSilently();
    if (user != null) {
      setState(() {
      });
      print("🔁 আগের signup পাওয়া গেছে: ${user.displayName}");
    } else {
      print("ℹ️ কোনো ইউজার signup করা নেই।");
    }
  }

  Future<void> _handleGoogleSignUp() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignUp.signIn();

      if (googleUser == null) {
        print("❌ ইউজার লগইন বাতিল করেছে।");
        return;
      }

      // 🔹 Google Authentication থেকে টোকেন নেওয়া
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final idToken = googleAuth.idToken;
      final accessToken =  googleAuth.accessToken;

      print("🔹 ব্যবহৃত Google Client ID: ${_googleSignUp.clientId}");
      print("✅ Google Login সফল!");
      print("👤 নাম: ${googleUser.displayName}");
      print("📧 ইমেইল: ${googleUser.email}");
      print("🖼️ ছবি: ${googleUser.photoUrl}");
      print("🔑 ID Token: $idToken");
      print("🔑 Access Token: $accessToken");

      // 🔹 যদি ID Token পাওয়া যায়, তাহলে সেটা ডিকোড করে দেখি
      if (idToken != null) {

        _printDecodedIdToken(idToken);
      } else {
        print("⚠️ Warning: ID Token পাওয়া যায়নি (সম্ভবত ভুল clientId ব্যবহৃত হয়েছে)।");
      }

      setState(() {
      });

      // 🔹 এখন Backend এ টোকেন পাঠানো হবে
      await _sendTokenToBackend(idToken,googleUser);

    } catch (error) {
      print("🔹 ব্যবহৃত Google Client ID: ${_googleSignUp.clientId}");

      // print(
      //     "🔹 ব্যবহৃত Redirect Scheme: com.googleusercontent.apps.895753625041-2f11rtjpcgt2rgq9rg3303hee3s5aa1g");

      print("🚫 signup করতে সমস্যা হয়েছে: $error");
    }
  }

  Future<void> _sendTokenToBackend(String? idToken, googleUser) async {
    if (idToken == null) {
      print("❌ টোকেন পাওয়া যায়নি, Backend এ পাঠানো যাবে না।");
      return;
    }

    final url = Uri.parse("$backendUrl/api/v1/google-signup");
    // final clientOrigin = "http://localhost:3000"; // 🔹 তোমার client origin এখানে থাকবে
    final clientOrigin = ClientOrigin; // 🔹 তোমার client origin এখানে থাকবে

    try {
      print("🔹 ব্যবহৃত Google Client ID: ${_googleSignUp.clientId}");
      print("📡 টোকেন পাঠানো হচ্ছে সার্ভারে...");
      print("🔗 API URL: $url");
      print("🛰️ ব্যবহৃত x-client-origin: $clientOrigin"); // 👈 এখন কনসোলে দেখা যাবে

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "x-client-origin": clientOrigin, // ✅ এখানে ব্যবহার হচ্ছে
        },
        body: jsonEncode({"idToken": idToken}),
      );

      if (response.statusCode == 200) {
        print("✅ সার্ভার রেসপন্স (200 OK): ${response.body}");

        // ✅ টোকেন লোকালি সংরক্ষণ করা হবে
        final data = jsonDecode(response.body);
        final token = data['data']?['token'];

        if (token != null) {
          await saveTokenToLocalStorage(token);

          // ✅ Provider-এ সেট করো

          Provider.of<UserProvider>(context, listen: false).setUser(
            googleUser.displayName ?? '',
            googleUser.email,
            googleUser.photoUrl ?? '',
          );

          // ✅ Login সফল হলে Profile Page / Home Page এ redirect করো
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  UserProfilePage()),
          );
          print("💾 টোকেন লোকালি সেভ করা হয়েছে: $token");
        } else {
          print("⚠️ সার্ভার থেকে কোনো টোকেন পাওয়া যায়নি।");
        }
      } else {
        print("❌ সার্ভার ত্রুটি [${response.statusCode}]: ${response.body}");
      }
    } catch (e) {
      print("🚫 লোকাল স্টোরেজ সংযোগ ব্যর্থ: $e");
    }
  }


  void _printDecodedIdToken(String idToken) {
    try {
      final parts = idToken.split('.');
      if (parts.length != 3) {
        print("⚠️ Invalid ID Token format!");
        return;
      }

      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      print("🧾 Full Google ID Token Payload from google signup:");
      print(payload);

      final Map<String, dynamic> decoded = jsonDecode(payload);
      print("📋 নাম: ${decoded['name']}");
      print("📧 ইমেইল: ${decoded['email']}");
      print("🖼️ ছবি: ${decoded['picture']}");
      print("🆔 ইউজার আইডি: ${decoded['sub']}");
    } catch (e) {
      print("❌ ID Token ডিকোড করতে সমস্যা: $e");
    }
  }






  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    final siteProvider = Provider.of<SiteProvider>(context);
    final site = siteProvider.siteData;
    final logoUrl = "$backendUrl/images/${site?.logo}";
    final width = MediaQuery.of(context).size.width;
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider;


    // 🔹 Dynamic background color

    // Color bgColor = Colors.lightBlueAccent;
    Color bgColor = Colors.transparent;
    try {
      bgColor = Color(int.parse("0xff${site?.color}"));
    } catch (_) {}

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CustomAppBar( logoUrl: logoUrl, isLoggedIn: user.isLoggedIn,),

        // ✅ পুরো স্ক্রলযোগ্য পেজ + নিচে footer থাকবে
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: width < 700 ? width * 0.9 : 650,
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.only(bottom: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Register",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Google Sign-In Button
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: OutlinedButton.icon(
                        icon: Image.network(
                          "https://img.icons8.com/color/48/000000/google-logo.png",
                          height: 22,
                        ),
                        label: const Text(
                          "Sign up with Google",
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                        onPressed: _handleGoogleSignUp,
                        style: OutlinedButton.styleFrom(
                          // side: const BorderSide(color: Colors.grey),
                          side: BorderSide(color:bgColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // OR Divider
                    // Row(
                    //   children: [
                    //     Expanded(
                    //         child: Divider(
                    //             color: Colors.grey[300], thickness: 1.3)),
                    //     const Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: 8),
                    //       child:
                    //       Text("Or", style: TextStyle(color: Colors.black54)),
                    //     ),
                    //     Expanded(
                    //         child: Divider(
                    //             color: Colors.grey[300], thickness: 1.3)),
                    //   ],
                    // ),
                    //
                    // const SizedBox(height: 25),
                    //
                    // // Username & Phone
                    // LayoutBuilder(
                    //   builder: (context, constraints) {
                    //     if (constraints.maxWidth < 500) {
                    //       return Column(
                    //         children: [
                    //           _buildTextField("Username", _usernameController),
                    //           const SizedBox(height: 15),
                    //           _buildTextField("Phone", _phoneController),
                    //         ],
                    //       );
                    //     } else {
                    //       return Row(
                    //         children: [
                    //           Expanded(
                    //               child: _buildTextField(
                    //                   "Username", _usernameController)),
                    //           const SizedBox(width: 10),
                    //           Expanded(
                    //               child: _buildTextField(
                    //                   "Phone", _phoneController)),
                    //         ],
                    //       );
                    //     }
                    //   },
                    // ),
                    //
                    // const SizedBox(height: 15),
                    //
                    // _buildTextField("Email", _emailController),
                    //
                    // const SizedBox(height: 15),
                    //
                    // // Password Fields
                    // LayoutBuilder(
                    //   builder: (context, constraints) {
                    //     if (constraints.maxWidth < 500) {
                    //       return Column(
                    //         children: [
                    //           _buildPasswordField(
                    //             "Password",
                    //             _passwordController,
                    //             _showPassword,
                    //                 () => setState(
                    //                     () => _showPassword = !_showPassword),
                    //           ),
                    //           const SizedBox(height: 15),
                    //           _buildPasswordField(
                    //             "Confirm Password",
                    //             _confirmPasswordController,
                    //             _showConfirmPassword,
                    //                 () => setState(() => _showConfirmPassword =
                    //             !_showConfirmPassword),
                    //           ),
                    //         ],
                    //       );
                    //     } else {
                    //       return Row(
                    //         children: [
                    //           Expanded(
                    //             child: _buildPasswordField(
                    //               "Password",
                    //               _passwordController,
                    //               _showPassword,
                    //                   () => setState(() =>
                    //               _showPassword = !_showPassword),
                    //             ),
                    //           ),
                    //           const SizedBox(width: 10),
                    //           Expanded(
                    //             child: _buildPasswordField(
                    //               "Confirm Password",
                    //               _confirmPasswordController,
                    //               _showConfirmPassword,
                    //                   () => setState(() => _showConfirmPassword =
                    //               !_showConfirmPassword),
                    //             ),
                    //           ),
                    //         ],
                    //       );
                    //     }
                    //   },
                    // ),
                    //
                    // const SizedBox(height: 25),
                    //
                    // // Create Account Button
                    // SizedBox(
                    //   width: double.infinity,
                    //   height: 50,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       print("Create Account clicked");
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.lightBlueAccent,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //     ),
                    //     child: const Text(
                    //       "Create Account",
                    //       style: TextStyle(fontSize: 16, color: Colors.white),
                    //     ),
                    //   ),
                    // ),
                    //
                    // const SizedBox(height: 20),
                    //
                    // Wrap(
                    //   alignment: WrapAlignment.center,
                    //   children: [
                    //     const Text("Have an account? "),
                    //     GestureDetector(
                    //       onTap: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => const LoginScreen()),
                    //         );
                    //       },
                    //       child: const Text(
                    //         "Login here",
                    //         style: TextStyle(
                    //           color: Colors.blueAccent,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),

            // ✅ এখন Footer scroll এর অংশ, fixed না
            //  CustomFooter(),
          ],
        ),
      ),
      bottomNavigationBar: CustomFooter()
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelStyle: const TextStyle(color: Colors.blueAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      String label, TextEditingController controller, bool isVisible, VoidCallback toggle) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelStyle: const TextStyle(color: Colors.blueAccent),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: toggle,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }
}
