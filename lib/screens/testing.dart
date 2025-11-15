// return Scaffold(
//   drawer: CustomDrawer(),
//   // appBar: AppBar(
//   //   automaticallyImplyLeading: false,
//   //   // 🔥 ডিফল্ট Hamburger আইকন লুকিয়ে দিলাম
//   //   title: Row(
//   //     children: [
//   //       GestureDetector(
//   //         onTap: () {
//   //           // 🏠 এখানে তোমার HomeScreen এ নিয়ে যাও
//   //           Navigator.pushReplacement(
//   //             context,
//   //             MaterialPageRoute(builder: (context) => HomeScreen()),
//   //           );
//   //         },
//   //         // child: Image.asset("assets/logo.png", height: 30,
//   //         child: Image.network(logoUrl, height: 30,
//   //         ),
//   //       ),
//   //     ],
//   //   ),
//   //   actions: [
//   //     Builder(
//   //       builder: (context) {
//   //         return InkWell(
//   //           onTap: () {
//   //             Scaffold.of(context).openDrawer(); // ✅ Drawer open হবে
//   //           },
//   //           child: LayoutBuilder(
//   //             builder: (context, constraints) {
//   //               if (constraints.maxWidth < 400) {
//   //                 // Mobile এ শুধু Image
//   //                 return const Padding(
//   //                   padding: EdgeInsets.only(right: 10),
//   //                   child: CircleAvatar(
//   //                     backgroundImage: AssetImage("assets/user.png"),
//   //                   ),
//   //                 );
//   //               } else {
//   //                 // Tablet/Desktop এ Full Profile
//   //                 return Row(
//   //                   children: const [
//   //                     CircleAvatar(backgroundImage: AssetImage("assets/user.png")),
//   //                     SizedBox(width: 6),
//   //                     Text("Hellowfarjan"),
//   //                     Icon(Icons.arrow_drop_down),
//   //                     SizedBox(width: 10),
//   //                   ],
//   //                 );
//   //               }
//   //             },
//   //           ),
//   //         );
//   //       },
//   //     ),
//   //   ],
//   // ),
//
//
//   appBar: CustomAppBar( logoUrl: logoUrl, isLoggedIn: user.isLoggedIn,),
//
//
//
//   backgroundColor: const Color(0xfff9fafb),
//
//
//
//   body: SingleChildScrollView(
//     child: Column(
//       children: [
//         // 🔹 Top Banner
//         Container(
//           height: 150,
//           width: double.infinity,
//           color: Colors.blueAccent,
//         ),
//
//         // 🔹 Profile Image and Info
//         Transform.translate(
//           offset: const Offset(0, -75),
//           child: Column(
//             children: [
//               Container(
//                 width: 130,
//                 height: 130,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(100),
//                   border: Border.all(color: Colors.white, width: 4),
//                   image:  DecorationImage(
//                     // image: AssetImage("assets/user.png"),
//                     image: NetworkImage(userprofiledata?.avatar ?? ''),
//                     // NetworkImage(
//                     //     'https://lh3.googleusercontent.com/a/ACg8ocIYFrq63uiy7rJWZPC9CSYHAKyBMIcwy-Ccdg6Fpjl3O_zKDpE=s96-c'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(userprofiledata?.username ?? 'Unknown',
//                   style: const TextStyle(
//                       fontSize: 22, fontWeight: FontWeight.bold)),
//
//               const SizedBox(height: 20),
//
//               // 🔹 Info Cards
//               _infoCard("User ID:", userprofiledata!.id.toString()),
//               _infoCard("Email:", userprofiledata.email ?? ''),
//               _phoneSection(context),
//               // _changePasswordSection(),
//             ],
//           ),
//         ),
//
//
//         CustomFooter(),
//
//       ],
//
//     ),
//   ),
//   // bottomNavigationBar: CustomFooter(),
// );

//////////////////////////////////////////////////////////////




// appBar: AppBar(
//     automaticallyImplyLeading: false,
//     // 🔥 ডিফল্ট Hamburger আইকন লুকিয়ে দিলাম
//     title: Row(
//       children: [
//         GestureDetector(
//           onTap: () {
//             // 🏠 এখানে তোমার HomeScreen এ নিয়ে যাও
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => HomeScreen()),
//             );
//           },
//           // child: Image.asset("assets/logo.png", height: 30,
//           child: Image.network(logoUrl, height: 30,
//           ),
//         ),
//       ],
//     ),
//     actions: [
//       Builder(
//         builder: (context) {
//           return InkWell(
//             onTap: () {
//               Scaffold.of(context).openDrawer(); // ✅ Drawer open হবে
//             },
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 if (constraints.maxWidth < 400) {
//                   // Mobile এ শুধু Image
//                   return const Padding(
//                     padding: EdgeInsets.only(right: 10),
//                     child: CircleAvatar(
//                       backgroundImage: AssetImage("assets/user.png"),
//                     ),
//                   );
//                 } else {
//                   // Tablet/Desktop এ Full Profile
//                   return Row(
//                     children: const [
//                       CircleAvatar(backgroundImage: AssetImage("assets/user.png")),
//                       SizedBox(width: 6),
//                       Text("Hellowfarjan"),
//                       Icon(Icons.arrow_drop_down),
//                       SizedBox(width: 10),
//                     ],
//                   );
//                 }
//               },
//             ),
//           );
//         },
//       ),
//     ],
//   ),