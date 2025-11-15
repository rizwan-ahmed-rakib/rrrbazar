// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     drawer: CustomDrawer(),
//     appBar: CustomAppBar(
//       logoUrl: logoUrl,
//       isLoggedIn: isLoggedIn,
//     ),
//     body: RefreshIndicator(
//       onRefresh: () async {
//         // ✅ Reload user profile
//         await Provider.of<UserProfileProvider>(context, listen: false)
//             .fetchUserProfile();
//
//         // ✅ Reload Site Data
//         Provider.of<SiteProvider>(context, listen: false).siteData = null;
//         await Provider.of<SiteProvider>(context, listen: false)
//             .fetchSiteData();
//
//         // ✅ Optional Snackbar
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("✅ Page Refreshed!")),
//         );
//
//         setState(() {}); // UI refresh
//       },
//       child: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(), // very important!
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// আপনার আগের সব widget code 그대로 থাকবে এখানে...
//           ],
//         ),
//       ),
//     ),
//   );
// }
