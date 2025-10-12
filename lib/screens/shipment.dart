import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShipmentPage extends StatelessWidget {
  const ShipmentPage({Key? key}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      // Handle error if URL cannot be launched
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
        title: const Text("Shipment Information"),
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
                  "Shipment Information",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Welcome to RRR Bazar – your trusted gaming top-up service provider in Bangladesh.",
                  style: TextStyle(fontSize: 15),
                ),

                _sectionTitle("🎯 Fast Delivery"),
                const Text(
                  "We are committed to delivering your top-up or product in the fastest time possible. "
                      "Most of our deliveries are processed within 5–15 minutes after successful payment confirmation.",
                  style: TextStyle(fontSize: 15),
                ),

                _sectionTitle("✅ Order Processing Time"),
                _bullet("Top-up orders are usually processed instantly."),
                _bullet("In rare cases, delivery may take up to 24 hours due to verification or system delays."),

                _sectionTitle("📦 Shipment Method"),
                const Text(
                  "For digital products (like game top-ups), we use in-game user ID or account info to complete the transaction – "
                      "there is no physical delivery.",
                  style: TextStyle(fontSize: 15),
                ),

                _sectionTitle("🕒 Business Hours"),
                _bullet("We operate from 10:00 AM – 12:00 AM (Midnight), Bangladesh Time."),
                _bullet("Orders placed outside these hours may be delayed until the next day."),

                _sectionTitle("❗ Delays & Contact"),
                const Text(
                  "If your order is delayed beyond the expected time, please contact our support team via live chat, Facebook page, "
                      "or email for immediate assistance.",
                  style: TextStyle(fontSize: 15),
                ),

                _sectionTitle("💬 Need Help?"),
                const Text(
                  "Contact us:",
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 8),

                // Email
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
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                // Facebook
                Row(
                  children: [
                    const Icon(Icons.facebook, size: 18, color: Colors.black54),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => _launchUrl('https://facebook.com/rrrbazar'),
                      child: const Text(
                        "fb.com/rrrbazar",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
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
