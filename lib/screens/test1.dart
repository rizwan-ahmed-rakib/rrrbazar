// import 'package:flutter/material.dart';
// import 'customdrawer.dart';
// import 'footer.dart';
// import 'home_screen.dart';
// import 'registration_screen.dart';
//
// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff7f9fc),
//       drawer: CustomDrawer(),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         elevation: 2,
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
//               child: Image.asset(
//                 "assets/logo.png",
//                 height: 30,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//
//           TextButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => RegisterScreen()),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.lightBlueAccent, // Primary background
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               elevation: 0,
//             ),
//
//             child: Text(
//               "Register",
//               style: TextStyle(
//                 color: Colors.white, // Primary color
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//
//
//           // Login Button
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 // Login action
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue, // Primary background
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 elevation: 0,
//               ),
//               child: Text(
//                 "Login",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//
//
//         // 🟢 Body
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 30),
//             _buildLoginCard(),
//             const SizedBox(height: 60),
//             CustomFooter(),
//           ],
//         ),
//       ),
//
//       // 🟢 Footer নিচে ফিক্সড থাকবে
//       // bottomNavigationBar: CustomFooter(),
//     );
//   }
//
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
//             const Text(
//               "Login",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 15),
//             ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.black,
//                 side: const BorderSide(color: Colors.grey),
//                 minimumSize: const Size(double.infinity, 45),
//               ),
//               icon: Image.network(
//                 "https://img.icons8.com/color/48/000000/google-logo.png",
//                 height: 22,
//               ),
//               label: const Text("Sign in with Google"),
//               onPressed: () {},
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               decoration: InputDecoration(
//                 labelText: "Email",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             TextField(
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: "Password",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 Checkbox(value: true, onChanged: (v) {}),
//                 const Text("Remember me"),
//               ],
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               width: double.infinity,
//               height: 45,
//               child: ElevatedButton(
//                 onPressed: () {},
//                 child: const Text("Login"),
//               ),
//             ),
//             const SizedBox(height: 15),
//             TextButton(
//               onPressed: () {},
//               child: const Text("Forgot password?"),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text("Don’t have an account? "),
//                 GestureDetector(
//                   onTap: () {},
//                   child: const Text(
//                     "Create One",
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



/////////////////////////////////////



/////////////////////////////////////////////////


/////////////////////////////////////////////


////////////////////////////////////////////////

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../provider/base_url.dart';
import 'customdrawer.dart' show CustomDrawer;
import 'home_screen.dart'; // 🔸 তোমার backend URL এখানে থাকবে

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
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
      await _sendTokenToBackend(idToken);

    } catch (error) {
      print("🔹 ব্যবহৃত Google Client ID: ${_googleSignIn.clientId}");
      print(
          "🔹 ব্যবহৃত Redirect Scheme: com.googleusercontent.apps.895753625041-2f11rtjpcgt2rgq9rg3303hee3s5aa1g");
      print("🚫 লগইন করতে সমস্যা হয়েছে: $error");
    }
  }

  // 🔹 Backend এ ID Token পাঠানো
  Future<void> _sendTokenToBackend(String? idToken) async {
    if (idToken == null) {
      print("❌ টোকেন পাওয়া যায়নি, Backend এ পাঠানো যাবে না।");
      return;
    }

    final url = Uri.parse("$backendUrl/api/v1/google-login");
    try {
      print("🔹 ব্যবহৃত Google Client ID: ${_googleSignIn.clientId}");
      print(
          "🔹 ব্যবহৃত Redirect Scheme: com.googleusercontent.apps.895753625041-1eqels2t6o99ieit8mr157oqkt4sl4lu");
      print("📡 টোকেন পাঠানো হচ্ছে সার্ভারে...");
      print("🔗 API URL: $url");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"idToken": idToken}),
      );

      if (response.statusCode == 200) {
        print("✅ সার্ভার রেসপন্স (200 OK): ${response.body}");
      } else {
        print("❌ সার্ভার ত্রুটি [${response.statusCode}]: ${response.body}");
      }
    } catch (e) {
      print("🚫 সার্ভারে সংযোগ ব্যর্থ: $e");
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
  Future<void> _handleLogout() async {
    await _googleSignIn.signOut();
    print("🚪 লগআউট সম্পন্ন হয়েছে।");
    setState(() {
      _currentUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 যদি ইউজার লগইন করে থাকে, তাহলে তার প্রোফাইল ছবি দেখাও
    final String profileImage = _currentUser?.photoUrl ??
        "https://img.icons8.com/color/48/000000/google-logo.png";

    return Scaffold(
      backgroundColor: const Color(0xfff7f9fc),
      drawer: CustomDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // 🔥 ডিফল্ট Hamburger আইকন লুকিয়ে দিলাম
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                // 🏠 এখানে তোমার HomeScreen এ নিয়ে যাও
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
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
                          backgroundImage: AssetImage("user.png"),
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
      ),      body: Center(
      child: Container(
        width: 380,
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
        child: _currentUser == null
            ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Sign in to Continue",
              style:
              TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 🟢 Google Sign-In Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.grey),
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: CircleAvatar(
                backgroundImage: NetworkImage(profileImage),
                radius: 14,
              ),
              label: const Text(
                "Sign in with Google",
                style: TextStyle(fontSize: 16),
              ),
              onPressed: _handleGoogleSignIn,
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.grey),
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: CircleAvatar(
                // backgroundImage: NetworkImage(profileImage),
                radius: 14,
              ),
              label: const Text(
                "Go to home page",
                style: TextStyle(fontSize: 16),
              ),
              // onPressed: _handleGoogleSignIn,
              onPressed: () {
                // 🏠 এখানে তোমার HomeScreen এ নিয়ে যাও
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },

            ),

          ],
        )
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundImage:
              NetworkImage(_currentUser!.photoUrl ?? ""),
              radius: 40,
            ),
            const SizedBox(height: 10),
            Text(
              _currentUser!.displayName ?? "No Name",
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(_currentUser!.email),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleLogout,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent),
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    ),
    );
  }
}





