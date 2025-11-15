import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/user_profile_provider.dart';
import 'home_screen.dart';
import 'login.dart';
import 'registration_screen.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  // final String title;
  final String logoUrl;
  final bool isLoggedIn;

  const CustomAppBar({
    Key? key,
    // required this.title,
    required this.logoUrl,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String userName = "";
  String userPhoto = "";

  @override
  void initState() {
    super.initState();
    _loadUserFromPrefs();
  }



  /// ✅ SharedPreferences থেকে ইউজার ডাটা লোড করো
  Future<void> _loadUserFromPrefs() async {

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
      userPhoto = prefs.getString('userPhoto') ?? '';
    });
  }


  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<UserProfileProvider>(context);
    final profile = profileProvider.profileData?.data;


    // ✅ Provider থেকে ডাটা থাকলে সেটাকে অগ্রাধিকার দিচ্ছি
    final displayName = profile?.username ?? userName;
    final displayPhoto = profile?.avatar ?? userPhoto;



    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          GestureDetector(

            // onTap: () {
            //   // 🏠 হোম স্ক্রিনে নিয়ে যাও
            //   Navigator.pushReplacement(
            //                   context,
            //                   MaterialPageRoute(builder: (context) => HomeScreen()),
            //                 );
            // },

            // onTap: () {
            //   if (ModalRoute.of(context)?.settings.name == '/home') return;
            //
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(builder: (_) => HomeScreen()),
            //   );
            // },

            onTap: () {
              // 🔹 যদি তুমি ইতিমধ্যে HomeScreen এ থাকো, কিছুই করবে না
              if (ModalRoute.of(context)?.settings.name == '/home') {
                // print("Already on HomeScreen — no need to reload");
                return;
              }

              // 🔹 নইলে HomeScreen এ নিয়ে যাও
              Navigator.pushReplacementNamed(context, '/home');
            },






            // onTap: isHomePage
            //     // ? null // 🔹 হোম পেজে থাকলে Tap নিষ্ক্রিয় থাকবে
            //     ? (){
            //   // Navigator.pushReplacement(
            //   //   context,
            //   //   MaterialPageRoute(builder: (context) => HomeScreen()),
            //   // );
            // } // 🔹 হোম পেজে থাকলে Tap নিষ্ক্রিয় থাকবে
            //     : () {
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(builder: (context) => HomeScreen()),
            //   );
            // },





            // child: Image.network(widget.logoUrl, height: 30),

            child: Image.network(
              widget.logoUrl,
              height: 30,
              fit: BoxFit.contain,

              // 🔹 যদি ইমেজ লোড না হয় (যেমন লিংক ভুল বা সার্ভার ডাউন)
              errorBuilder: (context, error, stackTrace) {
                return const Text(
                  "logo", // ✅ Fallback টেক্সট
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                );
              },
            ),


          ),
          const SizedBox(width: 10),
          // Text(widget.title),
        ],
      ),
      actions: [
        Builder(
          builder: (context) {
            if (widget.isLoggedIn) {
              // ✅ লগইন করা আছে
              return InkWell(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: displayPhoto.isNotEmpty
                          ? NetworkImage(displayPhoto)
                          : const AssetImage("assets/user.png") as ImageProvider,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      displayName.isNotEmpty
                          ? "$displayName"
                          : "Hello, User",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Icon(Icons.arrow_drop_down),
                    const SizedBox(width: 10),
                  ],
                ),
              );
            } else {
              // ❌ লগইন করা নেই
              return Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      "Register",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: const BorderSide(
                          color: Colors.lightBlueAccent,
                          width: 2,
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              );
            }
          },
        ),
      ],
    );
  }
}





///////////////////////////////////////////////


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../provider/user_provider.dart';
// import '../provider/user_profile_provider.dart';
// import 'home_screen.dart';
// import 'login.dart';
// import 'registration_screen.dart';
//
// class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
//   // final String title;
//   final String logoUrl;
//   final bool isLoggedIn;
//
//   const CustomAppBar({
//     Key? key,
//     // required this.title,
//     required this.logoUrl,
//     required this.isLoggedIn,
//   }) : super(key: key);
//
//   @override
//   _CustomAppBarState createState() => _CustomAppBarState();
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
//
// class _CustomAppBarState extends State<CustomAppBar> {
//   // String userName = "";
//   // String userPhoto = "";
//
//   @override
//   // void initState() {
//   //   super.initState();
//   //   _loadUserFromPrefs();
//   // }
//
//
//
//   /// ✅ SharedPreferences থেকে ইউজার ডাটা লোড করো
//   // Future<void> _loadUserFromPrefs() async {
//   //
//   //   final prefs = await SharedPreferences.getInstance();
//   //   setState(() {
//   //     userName = prefs.getString('userName') ?? '';
//   //     userPhoto = prefs.getString('userPhoto') ?? '';
//   //   });
//   // }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final profileProvider = Provider.of<UserProfileProvider>(context);
//     final profile = profileProvider.profileData?.data;
//     final userProvider = Provider.of<UserProvider>(context);
//
//     // ✅ Provider থেকে ডাটা থাকলে সেটাকে অগ্রাধিকার দিচ্ছি
//
//     // final displayName = profile?.username ?? userName;
//     // final displayPhoto = profile?.avatar ?? userPhoto;
//
//     final displayName = userProvider.name ?? "";
//     final displayPhoto = userProvider.photoUrl ?? "";
//
//     return AppBar(
//       automaticallyImplyLeading: false,
//       title: Row(
//         children: [
//           GestureDetector(
//             onTap: () {
//               // 🏠 হোম স্ক্রিনে নিয়ে যাও
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => HomeScreen()),
//               );
//             },
//             // child: Image.network(widget.logoUrl, height: 30),
//
//             child: Image.network(
//               widget.logoUrl,
//               height: 30,
//               fit: BoxFit.contain,
//
//               // 🔹 যদি ইমেজ লোড না হয় (যেমন লিংক ভুল বা সার্ভার ডাউন)
//               errorBuilder: (context, error, stackTrace) {
//                 return const Text(
//                   "logo", // ✅ Fallback টেক্সট
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.lightBlueAccent,
//                   ),
//                 );
//               },
//             ),
//
//
//           ),
//           const SizedBox(width: 10),
//           // Text(widget.title),
//         ],
//       ),
//       actions: [
//         Builder(
//           builder: (context) {
//             if (widget.isLoggedIn) {
//               // ✅ লগইন করা আছে
//               return InkWell(
//                 onTap: () => Scaffold.of(context).openDrawer(),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       backgroundImage: displayPhoto.isNotEmpty
//                           ? NetworkImage(displayPhoto)
//                           : const AssetImage("assets/user.png") as ImageProvider,
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       displayName.isNotEmpty
//                           ? "$displayName"
//                           : "Hello, User",
//                       style: const TextStyle(fontWeight: FontWeight.w500),
//                     ),
//                     const Icon(Icons.arrow_drop_down),
//                     const SizedBox(width: 10),
//                   ],
//                 ),
//               );
//             } else {
//               // ❌ লগইন করা নেই
//               return Row(
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const RegisterScreen()),
//                       );
//                     },
//                     style: TextButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       foregroundColor: Colors.white,
//                     ),
//                     child: const Text(
//                       "Register",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const LoginScreen()),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6),
//                         side: const BorderSide(
//                           color: Colors.lightBlueAccent,
//                           width: 2,
//                         ),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: const Text(
//                       "Login",
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                 ],
//               );
//             }
//           },
//         ),
//       ],
//     );
//   }
// }
