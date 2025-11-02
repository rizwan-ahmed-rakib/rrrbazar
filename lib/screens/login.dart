import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../provider/base_url.dart';
import '../provider/site_provider.dart' show SiteProvider;
import '../provider/user_provider.dart';
import 'custom_app_bar.dart';
import 'customdrawer.dart' show CustomDrawer;
import 'footer.dart';
import 'home_screen.dart';
import 'registration_screen.dart' show RegisterScreen;
import 'testing.dart';
import 'userProfile_screen.dart' show UserProfilePage; // 🔸 তোমার backend URL এখানে থাকবে

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

  static void handleLogout(BuildContext context) {}
}

class _LoginScreenState extends State<LoginScreen> {
  // 🔹 Google SignIn object (এখানে তোমার Web Client ID দিতে হবে)
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
    "895753625041-1eqels2t6o99ieit8mr157oqkt4sl4lu.apps.googleusercontent.com", // তোমার Web Client ID  Rizwan
    // "895753625041-2f11rtjpcgt2rgq9rg3303hee3s5aa1g.apps.googleusercontent.com", // তোমার Android Client ID  Rizwan
    // "590339419279-68oe6vvg86t9chn5ruj83okftjuji2d7.apps.googleusercontent.com", //  Web Client ID  RRRBazar
    scopes: ['email', 'profile','openid'],
  );

  GoogleSignInAccount? _currentUser;


  @override
  void initState() {
    super.initState();
    _checkIfAlreadySignedIn(); // 🔹 অ্যাপ চালু হলে আগের লগইন চেক করবে
  }

  // 🔹 আগের Google লগইন চেক করা
  Future<void> _checkIfAlreadySignedIn() async {
    final user = await _googleSignIn.signInSilently();
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
      print("🔁 আগের লগইন পাওয়া গেছে: ${user.displayName}");

      // ✅ যদি আগেই লগইন করা থাকে তাহলে সরাসরি প্রোফাইল পেজে নিয়ে যাও
      // Future.microtask(() {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => const UserProfilePage()),
      //   );
      // });
    } else {
      print("ℹ️ কোনো ইউজার লগইন করা নেই।");
    }
  }

  // 🔹 Google দিয়ে লগইন
  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print("❌ ইউজার লগইন বাতিল করেছে।");
        return;
      }

      // ✅ Provider-এ সেট করো

      // Provider.of<UserProvider>(context, listen: false).setUser(
      //   googleUser.displayName ?? '',
      //   googleUser.email,
      //   googleUser.photoUrl ?? '',
      // );

      // 🔹 Google Authentication থেকে টোকেন নেওয়া
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final idToken = googleAuth.idToken;
      final accessToken =  googleAuth.accessToken;

      print("🔹 ব্যবহৃত Google Client ID: ${_googleSignIn.clientId}");
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
        _currentUser = googleUser;
      });

      // 🔹 এখন Backend এ টোকেন পাঠানো হবে
      await _sendTokenToBackend(idToken,googleUser);

      // ✅ Login সফল হলে Profile Page / Home Page এ redirect করো
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) =>  UserProfilePage()),
      // );

    } catch (error) {
      print("🔹 ব্যবহৃত Google Client ID: ${_googleSignIn.clientId}");

      // print(
      //     "🔹 ব্যবহৃত Redirect Scheme: com.googleusercontent.apps.895753625041-2f11rtjpcgt2rgq9rg3303hee3s5aa1g");

      print("🚫 লগইন করতে সমস্যা হয়েছে: $error");
    }
  }

  // 🔹 Backend এ ID Token পাঠানো

  Future<void> _sendTokenToBackend(dynamic idToken, googleUser) async {
    if (idToken == null) {
      print("❌ টোকেন পাওয়া যায়নি, Backend এ পাঠানো যাবে না।");
      return;
    }

    final url = Uri.parse("$backendUrl/api/v1/google-login");
    final clientOrigin = "http://localhost:3000"; // 🔹 তোমার client origin এখানে থাকবে

    try {
      print("🔹 ব্যবহৃত Google Client ID: ${_googleSignIn.clientId}");
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


  // 🔹 ID Token ডিকোড করে Full Payload দেখা (Raw User Info)
  void _printDecodedIdToken(String idToken) {
    try {
      final parts = idToken.split('.');
      if (parts.length != 3) {
        print("⚠️ Invalid ID Token format!");
        return;
      }

      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      print("🧾 Full Google ID Token Payload:");
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

  // 🔹 Logout ফাংশন
  Future<void> handleLogout() async {
    await _googleSignIn.signOut();


    // ✅ Provider-এ সেট করো

    Provider.of<UserProvider>(context, listen: false).logout();

    print("🚪 লগআউট সম্পন্ন হয়েছে।");
    print("🚪 লগআউট korar por sob data mmuse dewar kaj সম্পন্ন হয়েছে।");
    setState(() {
      _currentUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final siteProvider = Provider.of<SiteProvider>(context);
    final site = siteProvider.siteData;
    final logoUrl = "$backendUrl/images/${site?.logo}";
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider;
    // 🔹 যদি ইউজার লগইন করে থাকে, তাহলে তার প্রোফাইল ছবি দেখাও
    final String profileImage = _currentUser?.photoUrl ??
        "https://img.icons8.com/color/48/000000/google-logo.png";

    return Scaffold(
      backgroundColor: const Color(0xfff7f9fc),
      drawer: CustomDrawer(),


      appBar: CustomAppBar( logoUrl: logoUrl, isLoggedIn: user.isLoggedIn,),

        // 🟢 Body
      body: SingleChildScrollView(


        child: _currentUser == null
            ? Column(
          children: [
            const SizedBox(height: 30),
            _buildLoginCard(),
            const SizedBox(height: 60),
            // CustomFooter(),

            // const SizedBox(height: 100),
            // const CustomFooter(), // scrollable footer


          ],
        )

          : Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔹 Profile Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🔹 Profile Image
                  CircleAvatar(
                    backgroundImage: NetworkImage(_currentUser!.photoUrl ?? ""),
                    radius: 50,
                  ),
                  const SizedBox(height: 16),

                  // 🔹 Name
                  Text(
                    _currentUser!.displayName ?? "No Name",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // 🔹 Email
                  Text(
                    _currentUser!.email ?? "",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 🔹 Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: handleLogout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        "Logout",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 নিচে footer বা অন্যান্য widget রাখতে পারো
            // const Spacer(),
            // CustomFooter(),

            // const SizedBox(height: 100),
            // const CustomFooter(), // scrollable footer
          ],
        )
      ),

      // 🟢 Footer নিচে ফিক্সড থাকবে



      bottomNavigationBar: CustomFooter(),



    );
  }



  Widget _buildLoginCard() {
    return Center(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              "Login",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.grey),
                minimumSize: const Size(double.infinity, 45),
              ),
              icon: Image.network(
                "https://img.icons8.com/color/48/000000/google-logo.png",
                height: 22,
              ),
              label: const Text("Sign in with Google"),
              onPressed: _handleGoogleSignIn,
            ),
            const SizedBox(height: 20),

            // TextButton(
            //   onPressed: () {
            //     // ✅ চাইলে এখান থেকেও Sign-in পেজে যাও
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (_) => const GoogleSmartSignInButton()),
            //     );              },
            //   child: const Text("test login page"),
            // ),

            // TextField(
            //   decoration: InputDecoration(
            //     labelText: "Email",
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 15),
            // TextField(
            //   obscureText: true,
            //   decoration: InputDecoration(
            //     labelText: "Password",
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 10),
            // Row(
            //   children: [
            //     Checkbox(value: true, onChanged: (v) {}),
            //     const Text("Remember me"),
            //   ],
            // ),
            // const SizedBox(height: 10),
            // SizedBox(
            //   width: double.infinity,
            //   height: 45,
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     child: const Text("Login"),
            //   ),
            // ),
            // const SizedBox(height: 15),
            // TextButton(
            //   onPressed: () {},
            //   child: const Text("Forgot password?"),
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     const Text("Don’t have an account? "),
            //     GestureDetector(
            //       onTap: () {},
            //       child: const Text(
            //         "Create One",
            //         style: TextStyle(color: Colors.blue),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
//
// import '../provider/base_url.dart';
// import '../provider/site_provider.dart' show SiteProvider;
// import '../provider/user_provider.dart';
// import 'custom_app_bar.dart';
// import 'customdrawer.dart' show CustomDrawer;
// import 'footer.dart';
// import 'userProfile_screen.dart' show UserProfilePage;
//
// // ✅ মূল LoginScreen
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     clientId:
//     "895753625041-1eqels2t6o99ieit8mr157oqkt4sl4lu.apps.googleusercontent.com", // Web Client ID
//     scopes: ['email', 'profile', 'openid'],
//   );
//
//   GoogleSignInAccount? _currentUser;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkIfAlreadySignedIn();
//   }
//
//   // 🔹 আগের Google লগইন চেক করা
//   Future<void> _checkIfAlreadySignedIn() async {
//     final user = await _googleSignIn.signInSilently();
//     if (user != null) {
//       setState(() => _currentUser = user);
//       print("🔁 আগের লগইন পাওয়া গেছে: ${user.displayName}");
//     } else {
//       print("ℹ️ কোনো ইউজার লগইন করা নেই।");
//     }
//   }
//
//   // 🔹 Google দিয়ে লগইন
//   Future<void> _handleGoogleSignIn() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//
//       if (googleUser == null) {
//         print("❌ ইউজার লগইন বাতিল করেছে।");
//         return;
//       }
//
//       final GoogleSignInAuthentication googleAuth =
//       await googleUser.authentication;
//
//       final idToken = googleAuth.idToken;
//       final accessToken = googleAuth.accessToken;
//
//       print("✅ Google Login সফল!");
//       print("👤 নাম: ${googleUser.displayName}");
//       print("📧 ইমেইল: ${googleUser.email}");
//       print("🖼️ ছবি: ${googleUser.photoUrl}");
//       print("🔑 ID Token: $idToken");
//       print("🔑 Access Token: $accessToken");
//
//       if (idToken != null) _printDecodedIdToken(idToken);
//
//       setState(() => _currentUser = googleUser);
//
//       await _sendTokenToBackend(idToken, googleUser);
//     } catch (error) {
//       print("🚫 লগইন করতে সমস্যা হয়েছে: $error");
//     }
//   }
//
//   // 🔹 Backend এ ID Token পাঠানো
//   Future<void> _sendTokenToBackend(dynamic idToken, googleUser) async {
//     if (idToken == null) {
//       print("❌ টোকেন পাওয়া যায়নি, Backend এ পাঠানো যাবে না।");
//       return;
//     }
//
//     final url = Uri.parse("$backendUrl/api/v1/google-login");
//     final clientOrigin = "http://localhost:3000";
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           "Content-Type": "application/json",
//           "x-client-origin": clientOrigin,
//         },
//         body: jsonEncode({"idToken": idToken}),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final token = data['data']?['token'];
//
//         if (token != null) {
//           await saveTokenToLocalStorage(token);
//
//           Provider.of<UserProvider>(context, listen: false).setUser(
//             googleUser.displayName ?? '',
//             googleUser.email,
//             googleUser.photoUrl ?? '',
//           );
//
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const UserProfilePage()),
//           );
//
//           print("💾 টোকেন লোকালি সেভ করা হয়েছে: $token");
//         } else {
//           print("⚠️ সার্ভার থেকে কোনো টোকেন পাওয়া যায়নি।");
//         }
//       } else {
//         print("❌ সার্ভার ত্রুটি [${response.statusCode}]: ${response.body}");
//       }
//     } catch (e) {
//       print("🚫 Backend সংযোগ ব্যর্থ: $e");
//     }
//   }
//
//   void _printDecodedIdToken(String idToken) {
//     try {
//       final parts = idToken.split('.');
//       if (parts.length != 3) return;
//       final payload =
//       utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
//       final Map<String, dynamic> decoded = jsonDecode(payload);
//       print("📋 নাম: ${decoded['name']}");
//       print("📧 ইমেইল: ${decoded['email']}");
//       print("🖼️ ছবি: ${decoded['picture']}");
//     } catch (e) {
//       print("❌ ID Token ডিকোড করতে সমস্যা: $e");
//     }
//   }
//
//   Future<void> handleLogout() async {
//     await _googleSignIn.signOut();
//     Provider.of<UserProvider>(context, listen: false).logout();
//     setState(() => _currentUser = null);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final siteProvider = Provider.of<SiteProvider>(context);
//     final site = siteProvider.siteData;
//     final logoUrl = "$backendUrl/images/${site?.logo}";
//     final userProvider = Provider.of<UserProvider>(context);
//
//     return Scaffold(
//       backgroundColor: const Color(0xfff7f9fc),
//       drawer:  CustomDrawer(),
//       appBar: CustomAppBar(
//           logoUrl: logoUrl, isLoggedIn: userProvider.isLoggedIn),
//
//       body: SingleChildScrollView(
//         child: _currentUser == null
//             ? Column(
//           children: [
//             const SizedBox(height: 30),
//             _buildLoginCard(),
//             const SizedBox(height: 60),
//           ],
//         )
//             : _buildProfileCard(),
//       ),
//
//       // body: SingleChildScrollView(
//       //   child: Column(
//       //     children: [
//       //       const SizedBox(height: 30),
//       //       _buildLoginCard(),
//       //       const SizedBox(height: 60),
//       //     ],
//       //   )
//       // ),
//       bottomNavigationBar: const CustomFooter(),
//     );
//   }
//
//   // ✅ Login card — smart sign-in সহ
//   Widget _buildLoginCard() {
//     return Center(
//       child: Container(
//         width: 400,
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             const Text("Login",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 15),
//
//             // 🔹 Smart Google Sign-In button এখানে
//             GoogleSmartSignInButton(onLogin: (user) async {
//               await _handleGoogleSignIn();
//             }),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ✅ Profile card after login
//   Widget _buildProfileCard() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               CircleAvatar(
//                 backgroundImage: NetworkImage(_currentUser!.photoUrl ?? ""),
//                 radius: 50,
//               ),
//               const SizedBox(height: 16),
//               Text(_currentUser!.displayName ?? "No Name",
//                   style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87)),
//               const SizedBox(height: 4),
//               Text(_currentUser!.email ?? "",
//                   style: const TextStyle(color: Colors.grey, fontSize: 14)),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: handleLogout,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.redAccent,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     elevation: 3,
//                   ),
//                   icon: const Icon(Icons.logout, color: Colors.white),
//                   label: const Text("Logout",
//                       style: TextStyle(fontSize: 16, color: Colors.white)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // ✅ Smart Google Sign-in Button Widget
// class GoogleSmartSignInButton extends StatefulWidget {
//   final Function(GoogleSignInAccount user) onLogin;
//   const GoogleSmartSignInButton({super.key, required this.onLogin});
//
//   @override
//   State<GoogleSmartSignInButton> createState() =>
//       _GoogleSmartSignInButtonState();
// }
//
// class _GoogleSmartSignInButtonState extends State<GoogleSmartSignInButton> {
//   final GoogleSignIn _googleSignIn =
//   GoogleSignIn(scopes: ['email', 'profile', 'openid']);
//   GoogleSignInAccount? _account;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkLoggedInAccount();
//   }
//
//   Future<void> _checkLoggedInAccount() async {
//     final acc = await _googleSignIn.signInSilently();
//     setState(() => _account = acc);
//   }
//
//   Future<void> _signIn() async {
//     try {
//       final acc = await _googleSignIn.signIn();
//       if (acc != null) {
//         setState(() => _account = acc);
//         widget.onLogin(acc);
//       }
//     } catch (e) {
//       debugPrint("❌ Google Sign-in ব্যর্থ: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final user = _account;
//
//     return InkWell(
//       onTap: _signIn,
//       borderRadius: BorderRadius.circular(40),
//       child: Container(
//         height: 50,
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         decoration: BoxDecoration(
//           color: const Color(0xFF4285F4),
//           borderRadius: BorderRadius.circular(40),
//         ),
//         child: Row(
//           children: [
//             if (user != null)
//               CircleAvatar(
//                   radius: 16, backgroundImage: NetworkImage(user.photoUrl ?? ""))
//             else
//               const CircleAvatar(
//                 radius: 16,
//                 backgroundImage: NetworkImage(
//                     "https://img.icons8.com/color/48/000000/google-logo.png"),
//                 backgroundColor: Colors.white,
//               ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     user != null
//                         ? "Sign in as ${user.displayName}"
//                         : "Sign in with Google",
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   if (user != null)
//                     Text(
//                       user.email,
//                       style:
//                       const TextStyle(color: Colors.white70, fontSize: 12),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 10),
//             Container(
//               padding: const EdgeInsets.all(5),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//               child: Image.network(
//                 "https://img.icons8.com/color/48/000000/google-logo.png",
//                 height: 20,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
