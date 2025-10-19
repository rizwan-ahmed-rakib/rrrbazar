// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class CustomFooter extends StatelessWidget {
//   final String phoneNumber = "+8801929248067";
//
//   /// ☎️ Call Function
//   Future<void> _launchPhone(BuildContext context, String number) async {
//     final Uri url = Uri(scheme: "tel", path: number);
//
//     if (await canLaunchUrl(url)) {
//       await launchUrl(
//         url,
//         mode: LaunchMode.externalApplication, // ✅ important for Android
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Unable to open dialer.")),
//       );
//     }
//   }
//
//   /// 💬 WhatsApp Function
//   Future<void> _launchWhatsApp(BuildContext context, String number) async {
//     final Uri url = Uri.parse("https://wa.me/$number");
//
//     if (await canLaunchUrl(url)) {
//       await launchUrl(
//         url,
//         mode: LaunchMode.externalApplication, // ✅ must for Android
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("WhatsApp not available on this device.")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.lightBlueAccent.shade200,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 if (constraints.maxWidth < 600) {
//                   return Column(
//                     children: [
//                       _buildSupportSection(context),
//                     ],
//                   );
//                 } else {
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildSupportSection(context),
//                       _buildAboutSection(context),
//                       _buildStayConnectedSection(),
//                     ],
//                   );
//                 }
//               },
//             ),
//           ),
//
//           const Divider(color: Colors.white30, thickness: 0.5),
//
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text(
//               "© Copyright 2025. All Rights Reserved. Developed by RRRBazar",
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.white70, fontSize: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ✅ Support Section
//   Widget _buildSupportSection(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         const Text(
//           "SUPPORT",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 2,
//             fontSize: 20,
//           ),
//         ),
//         const SizedBox(height: 12),
//
//         // Phone Support
//         InkWell(
//           onTap: () => _launchPhone(context, phoneNumber),
//           child: _supportCard(
//             icon: Icons.phone,
//             title: "10AM - 10PM",
//             number: phoneNumber,
//           ),
//         ),
//         const SizedBox(height: 12),
//
//         // WhatsApp Support
//         InkWell(
//           // onTap: () => _launchWhatsApp(context, phoneNumber.replaceAll("+", "")),
//           onTap: () => _launchWhatsApp(context, phoneNumber),
//           child: _supportCard(
//             icon: FontAwesomeIcons.whatsapp,
//             title: "10AM - 10PM",
//             number: phoneNumber,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _supportCard({
//     required IconData icon,
//     required String title,
//     required String number,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(30),
//         border: Border.all(color: Colors.white.withOpacity(0.3)),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: Colors.white.withOpacity(0.2),
//             child: Icon(icon, color: Colors.white, size: 18),
//           ),
//           const SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: Colors.white70,
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 number,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAboutSection(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "ABOUT",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 2,
//           ),
//         ),
//         const SizedBox(height: 12),
//         _buildFooterLink("Terms & Conditions", context, "/terms&condition"),
//         _buildFooterLink("Privacy Policy", context, "/privacypolicy"),
//         _buildFooterLink("Shipment Info", context, "/shipmentPage"),
//         _buildFooterLink("Refund Policy", context, "/refundpolicyPage"),
//       ],
//     );
//   }
//
//   Widget _buildStayConnectedSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         Text(
//           "STAY CONNECTED",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 2,
//           ),
//         ),
//         SizedBox(height: 12),
//         Text("RRRBazar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
//         Text("Dhaka, Bangladesh", style: TextStyle(color: Colors.white70, fontSize: 12)),
//         SizedBox(height: 4),
//         Text("rrrbazarofficial@gmail.com", style: TextStyle(color: Colors.white, fontSize: 12)),
//       ],
//     );
//   }
//
//   Widget _buildFooterLink(String text, BuildContext context, String route) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 4),
//       child: GestureDetector(
//         onTap: () => Navigator.pushNamed(context, route),
//         child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12)),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/site_model.dart';
import '../provider/base_url.dart';
import '../provider/site_provider.dart';

class CustomFooter extends StatefulWidget {
  const CustomFooter({super.key});

  @override
  State<CustomFooter> createState() => _CustomFooterState();
}

class _CustomFooterState extends State<CustomFooter> {
  Future<void> _launchPhone(BuildContext context, String number) async {
    final Uri url = Uri(scheme: "tel", path: number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to open dialer.")),
      );
    }
  }

  Future<void> _launchWhatsApp(BuildContext context, String number) async {
    final Uri url = Uri.parse("https://wa.me/$number");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("WhatsApp not available on this device.")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final siteProvider = Provider.of<SiteProvider>(context, listen: false);
    siteProvider.fetchSiteData();
  }

  @override
  Widget build(BuildContext context) {
    final siteProvider = Provider.of<SiteProvider>(context);
    final site = siteProvider.siteData;

    if (siteProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (siteProvider.hasError || site == null) {
      return const Center(child: Text("⚠️ Footer data load error!"));
    }

    // 🔹 Dynamic background color
    Color bgColor = Colors.lightBlueAccent;
    try {
      bgColor = Color(int.parse("0xff${site.color}"));
    } catch (_) {}

    return Container(
      color: bgColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  return Column(children: [
                    _buildSupport(context, site.phone ?? "", site.whatsapp ?? ""),
                  ]);
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSupport(context, site.phone ?? "", site.whatsapp ?? ""),
                      _buildAboutSection(context),
                      _buildStayConnected(site),
                    ],
                  );
                }
              },
            ),
          ),
          const Divider(color: Colors.white30, thickness: 0.5),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "© Copyright 2025. All Rights Reserved.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupport(BuildContext context, String phone, String whatsapp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "SUPPORT",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _launchPhone(context, phone),
          child: _supportCard(Icons.phone, "Call Us", phone),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => _launchWhatsApp(context, whatsapp),
          child: _supportCard(FontAwesomeIcons.whatsapp, "WhatsApp", whatsapp),
        ),
      ],
    );
  }

  Widget _supportCard(IconData icon, String title, String number) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Text(number, style: const TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("ABOUT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _link(context, "Terms & Conditions", "/terms"),
        _link(context, "Privacy Policy", "/privacy"),
        _link(context, "Refund Policy", "/refund"),
      ],
    );
  }

  Widget _link(BuildContext context, String text, String route) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12)),
    ),
  );

  Widget _buildStayConnected(SiteModel site) {
    final logoUrl = "$backendUrl/images/${site.logo}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("STAY CONNECTED",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Image.network(logoUrl, height: 40, errorBuilder: (_, __, ___) => const Icon(Icons.image)),
        const SizedBox(height: 6),
        Text(site.name, style: const TextStyle(color: Colors.white)),
        Text(site.email, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Text(site.facebook, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}


