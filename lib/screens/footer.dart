import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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





  // Future<void> _launchPhone(BuildContext context, String number) async {
  //   print("📞 Original Number: $number");
  //
  //   if (number.isEmpty) {
  //     print("⚠️ Number is empty");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Phone number not available.")),
  //     );
  //     return;
  //   }
  //
  //   // ✅ প্লাস, স্পেস বা অন্য character remove করে clean number
  //   String cleanNumber = number.replaceAll(RegExp(r'[^0-9+]'), '');
  //   print("📞 Clean Number: $cleanNumber");
  //
  //   final Uri url = Uri(scheme: "tel", path: cleanNumber);
  //   print("📞 Launching URL: $url");
  //
  //   try {
  //     if (await canLaunchUrl(url)) {
  //       print("✅ Device supports dialer. Launching...");
  //       await launchUrl(url, mode: LaunchMode.externalApplication);
  //     } else {
  //       print("❌ Device does NOT support dialer or cannot handle URL.");
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("Cannot open dialer. Please call: $cleanNumber"),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     print("⚠️ Exception while launching dialer: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error launching dialer: $e")),
  //     );
  //   }
  // }




  Future<void> _launchPhone(BuildContext context, String number) async {
    print("📞 Original Number: $number");

    if (number.isEmpty) {
      print("⚠️ Number is empty");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone number not available.")),
      );
      return;
    }

    String cleanNumber = number.replaceAll(RegExp(r'[^0-9+]'), '');
    print("📞 Clean Number: $cleanNumber");

    final Uri url = Uri(scheme: "tel", path: cleanNumber);
    print("📞 Launching URL: $url");

    try {
      if (await canLaunchUrl(url)) {
        print("✅ Device supports dialer. Launching...");
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        print("❌ Dialer not supported on this device");
        _showDialerFallback(context, cleanNumber);
      }
    } catch (e) {
      print("⚠️ Exception while launching dialer: $e");
      _showDialerFallback(context, cleanNumber);
    }
  }

  void _showDialerFallback(BuildContext context, String number) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Dialer Not Available"),
        content: Text("Please call this number manually:\n$number"),
        actions: [
          TextButton(
            onPressed: () {
              // ✅ Clipboard copy
              Clipboard.setData(ClipboardData(text: number));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Copied: $number")),
              );
            },
            child: const Text("Copy"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }






  ////////////////////////////////////////


  // Future<void> _launchWhatsApp(BuildContext context, String number) async {
  //   if (number.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("WhatsApp number not available.")),
  //     );
  //     return;
  //   }
  //
  //   // ✅ প্লাস বা স্পেস রিমুভ করে সঠিক ফরম্যাটে কনভার্ট
  //   String cleanNumber = number.replaceAll("+", "").replaceAll(" ", "");
  //
  //   // ✅ WA-এর অফিসিয়াল লিংক
  //   final Uri url = Uri.parse("https://wa.me/$cleanNumber");
  //   print("WhatsApp Number: $cleanNumber");
  //   print("Launching URL: $url");
  //
  //
  //   try {
  //     if (await canLaunchUrl(url)) {
  //       await launchUrl(url, mode: LaunchMode.externalApplication); // ✅ WhatsApp App খুলবে
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("❌ WhatsApp not available on this device.")),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("⚠️ Error: $e")),
  //     );
  //   }
  // }

  /////////////////////////////////////////////////


  Future<void> _launchWhatsApp(BuildContext context, String number) async {
    if (number.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("WhatsApp number not available.")),
      );
      return;
    }

    // ✅ নম্বর পরিষ্কার (remove "+", spaces)
    String cleanNumber = number.replaceAll("+", "").replaceAll(" ", "");
    if (cleanNumber.startsWith("0")) {
      cleanNumber = "88${cleanNumber.substring(1)}"; // ০১৭… হলে → ৮৮০১৭…
    }

    // ✅ Direct whatsapp intent (best way)
    final Uri url = Uri.parse("whatsapp://send?phone=$cleanNumber&text=Hello");

    print("Launching WhatsApp with → $url");

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("❌ WhatsApp not available on this device."),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error: $e")),
      );
    }
  }



  @override
  // void initState() {
  //   super.initState();
  //   final siteProvider = Provider.of<SiteProvider>(context, listen: false);
  //   siteProvider.fetchSiteData();
  // }
  //
  // @override

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


