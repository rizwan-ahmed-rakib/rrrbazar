// privacy_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      // যদি লিঙ্ক না খোলে, snackbar দেখাও
      // (প্রোডাকশনে এখানে better error handling রাখতে হবে)
    }
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0, bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Privacy Policy",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Effective Date: 2029-12-31",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),

                const SizedBox(height: 16),
                const Text(
                  "At RRR Bazar, accessible from https://rrrbazar.com, one of our main priorities is the privacy of our visitors. "
                      "This Privacy Policy document contains types of information that is collected and recorded by RRR Bazar and how we use it.",
                  style: TextStyle(fontSize: 15),
                ),

                _sectionTitle("1. Information We Collect"),
                _bullet("Personal details like name, email, phone number, and address"),
                _bullet("Order and payment information (securely processed)"),
                _bullet("Browser and device details (via cookies and analytics)"),

                _sectionTitle("2. How We Use Your Information"),
                _bullet("To process orders and payments"),
                _bullet("To improve our website and user experience"),
                _bullet("To communicate offers and updates"),

                _sectionTitle("3. Sharing of Information"),
                const Text(
                  "We do not sell or rent your personal data. We may share information with trusted third parties such as payment processors and delivery services.",
                  style: TextStyle(fontSize: 15),
                ),

                _sectionTitle("4. Cookies"),
                const Text(
                  "We use cookies to enhance your browsing experience and to analyze site traffic. You can control cookies through your browser settings.",
                  style: TextStyle(fontSize: 15),
                ),

                _sectionTitle("5. Data Security"),
                const Text(
                  "We implement security measures to safeguard your data, including SSL encryption and secure hosting infrastructure.",
                  style: TextStyle(fontSize: 15),
                ),

                _sectionTitle("6. Your Rights"),
                const Text(
                  "You may access, update, or delete your personal information by contacting us.",
                  style: TextStyle(fontSize: 15),
                ),

                _sectionTitle("7. Contact Us"),
                const Text(
                  "If you have any questions about this Privacy Policy, please contact us:",
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 8),

                // Email (tapable)
                Row(
                  children: [
                    const Icon(Icons.email, size: 18, color: Colors.black54),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => _launchUrl('mailto:support@rrrbazar.com'),
                      child: const Text(
                        "support@rrrbazar.com",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                          // decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                // Phone (tapable)
                Row(
                  children: [
                    const Icon(Icons.phone, size: 18, color: Colors.black54),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => _launchUrl('tel:+8801929248067'),
                      child: const Text(
                        "+8801929248067",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                          // decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                // small footer note
                const Divider(),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    "© 2029 RRR Bazar. All Rights Reserved.",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
