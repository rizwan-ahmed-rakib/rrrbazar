import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../provider/base_url.dart';
import '../provider/site_provider.dart' show SiteProvider;
import '../provider/user_provider.dart';
import '../provider/shared_local_storage.dart';
import 'custom_app_bar.dart';
import 'customdrawer.dart' show CustomDrawer;
import 'footer.dart';
import 'home_screen.dart';
import 'registration_screen.dart' show RegisterScreen;
import 'testing.dart';
import 'userProfile_screen.dart'
    show UserProfilePage; // 🔸 তোমার backend URL এখানে থাকবে

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
        "895753625041-1eqels2t6o99ieit8mr157oqkt4sl4lu.apps.googleusercontent.com",
    // তোমার Web Client ID  Rizwan
    // "895753625041-2f11rtjpcgt2rgq9rg3303hee3s5aa1g.apps.googleusercontent.com", // তোমার Android Client ID  Rizwan
    // "590339419279-68oe6vvg86t9chn5ruj83okftjuji2d7.apps.googleusercontent.com", //  Web Client ID  RRRBazar
    // "895753625041-pcnvuttdiu3oekaip8akh8r90g3fs39t.apps.googleusercontent.com", //  Web Client ID  RRRBazar
    scopes: ['email', 'profile', 'openid'],
  );

  GoogleSignInAccount? _currentUser;
  bool _isCheckingLogin = true; // ✅ নতুন state যোগ করো

  @override
  void initState() {
    super.initState();
    _checkIfAlreadySignedIn(); // 🔹 অ্যাপ চালু হলে আগের লগইন চেক করবে
  }

  // 🔹 আগের Google লগইন চেক করা
  // Future<void> _checkIfAlreadySignedIn() async {
  //   final user = await _googleSignIn.signInSilently();
  //   if (user != null) {
  //     setState(() {
  //       _currentUser = user;
  //       _isCheckingLogin = false; // ✅ চেক শেষ
  //
  //     });
  //     print("🔁 আগের লগইন পাওয়া গেছে: ${user.displayName}");
  //
  //     // ✅ Provider-এ সেট করো
  //     Provider.of<UserProvider>(context, listen: false).setUser(
  //       user.displayName ?? '',
  //       user.email,
  //       user.photoUrl ?? '',
  //     );
  //
  //     // ✅ যদি আগেই লগইন করা থাকে তাহলে সরাসরি প্রোফাইল পেজে নিয়ে যাও
  //
  //     // Future.microtask(() {
  //     //   Navigator.pushReplacement(
  //     //     context,
  //     //     MaterialPageRoute(builder: (context) => const UserProfilePage()),
  //     //   );
  //     // });
  //
  //   } else {
  //     setState(() {
  //       _isCheckingLogin = false; // ✅ চেক শেষ, কিন্তু ইউজার নেই
  //     });
  //     print("ℹ️ কোনো ইউজার লগইন করা নেই।");
  //   }
  // }

  Future<void> _checkIfAlreadySignedIn() async {
    try {
      final user = await _googleSignIn.signInSilently();
      if (user != null) {
        setState(() {
          _currentUser = user;
          _isCheckingLogin = false; // ✅ চেক শেষ
        });
        print("🔁 আগের লগইন পাওয়া গেছে: ${user.displayName}");

        Provider.of<UserProvider>(
          context,
          listen: false,
        ).setUser(user.displayName ?? '', user.email, user.photoUrl ?? '');
      } else {
        setState(() {
          _isCheckingLogin = false; // ✅ চেক শেষ, কিন্তু ইউজার নেই
        });
        print("ℹ️ কোনো ইউজার লগইন করা নেই।");
      }
    } catch (e) {
      setState(() {
        _isCheckingLogin = false; // ✅ চেক শেষ, error হলেও
      });
      print("❌ সাইলেন্ট লগইন চেক ব্যর্থ: $e");
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
      final accessToken = googleAuth.accessToken;

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
        print(
          "⚠️ Warning: ID Token পাওয়া যায়নি (সম্ভবত ভুল clientId ব্যবহৃত হয়েছে)।",
        );
      }

      setState(() {
        _currentUser = googleUser;
      });

      // 🔹 এখন Backend এ টোকেন পাঠানো হবে
      await _sendTokenToBackend(idToken, googleUser);

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
    // final clientOrigin = "http://localhost:3000"; // 🔹 তোমার client origin এখানে থাকবে
    final clientOrigin = ClientOrigin; // 🔹 তোমার client origin এখানে থাকবে

    try {
      print("🔹 ব্যবহৃত Google Client ID: ${_googleSignIn.clientId}");
      print("📡 টোকেন পাঠানো হচ্ছে সার্ভারে...");
      print("🔗 API URL: $url");
      print(
        "🛰️ ব্যবহৃত x-client-origin: $clientOrigin",
      ); // 👈 এখন কনসোলে দেখা যাবে

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
            // googleUser.displayName ?? '',
            googleUser.displayName ?? '',
            googleUser.email,
            googleUser.photoUrl ?? '',
          );

          // ✅ Login সফল হলে Profile Page / Home Page এ redirect করো
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserProfilePage()),
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

      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
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
    await removeTokenFromLocalStorage();

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
    // ✅ লোডিং হলে CircularProgressIndicator দেখাও
    if (_isCheckingLogin) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    final siteProvider = Provider.of<SiteProvider>(context);
    final site = siteProvider.siteData;
    final logoUrl = "$backendUrl/images/${site?.logo}";
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider;
    // 🔹 যদি ইউজার লগইন করে থাকে, তাহলে তার প্রোফাইল ছবি দেখাও
    final String profileImage =
        _currentUser?.photoUrl ??
        "https://img.icons8.com/color/48/000000/google-logo.png";

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(
          context,
          '/home',
        ); //back button e home screen e ferar jonno
        return false; // default back-block
      },
      child: Scaffold(
        backgroundColor: const Color(0xfff7f9fc),
        drawer: CustomDrawer(),

        appBar: CustomAppBar(logoUrl: logoUrl, isLoggedIn: user.isLoggedIn),

        // 🟢 Body
        body: SingleChildScrollView(
          child:
              _currentUser == null
                  ?
                  // Center(
                  //   child: _buildLoginCard(),
                  // )
                  Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // 🔥 এখানে magic!
                    children: [
                      const SizedBox(height: 150),
                      _buildLoginCard(),

                      // const SizedBox(height: 300),
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
                        margin: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 40,
                        ),
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
                              backgroundImage: NetworkImage(
                                _currentUser!.photoUrl ?? "",
                              ),
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                ),
                                icon: const Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "Logout",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
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
                  ),
        ),

        // 🟢 Footer নিচে ফিক্সড থাকবে
        bottomNavigationBar: CustomFooter(),
      ),
    );
  }

  Widget _buildLoginCard() {
    final siteProvider = Provider.of<SiteProvider>(context);
    final site = siteProvider.siteData;
    // 🔹 Dynamic background color

    // Color bgColor = Colors.lightBlueAccent;
    Color bgColor = Colors.transparent;
    try {
      bgColor = Color(int.parse("0xff${site?.color}"));
    } catch (_) {}

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
                // side: const BorderSide(color: Colors.grey),
                side: BorderSide(color: bgColor),
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
          ],
        ),
      ),
    );
  }
}
