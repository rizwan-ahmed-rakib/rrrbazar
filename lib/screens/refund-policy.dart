import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RefundPage extends StatelessWidget {
  const RefundPage({Key? key}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
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
        title: const Text("Refund & Return Policy"),
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
                  "Refund & Return Policy",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Thank you for shopping at RRR Bazar. We strive to ensure our customers are satisfied with every purchase. "
                      "Please read our refund and return policy carefully.",
                  style: TextStyle(fontSize: 15),
                ),

                _sectionTitle("1. Return Eligibility"),
                const Text("Returns are accepted within 7 days of receiving your order, only if:"),
                _bullet("The item is damaged, defective, or incorrect"),
                _bullet("The item is unused and in its original condition and packaging"),

                _sectionTitle("2. Non-Returnable Items"),
                const Text("Certain items are not eligible for return or refund, including:"),
                _bullet("Digital top-ups or game recharge once processed"),
                _bullet("Items marked as non-refundable"),
                _bullet("Items without proof of purchase"),

                _sectionTitle("3. Refund Process"),
                const Text(
                  "Once your return is approved and the product is received, your refund will be processed within "
                      "14 business days via the original payment method.",
                  style: TextStyle(fontSize: 15),
                ),

                _sectionTitle("4. Cancellation Policy"),
                const Text(
                  "Orders can be cancelled before processing. If your order has already been shipped or completed "
                      "(especially digital top-ups), it cannot be cancelled.",
                  style: TextStyle(fontSize: 15),
                ),

                _sectionTitle("5. How to Request a Return"),
                const Text("To initiate a return or refund, please contact our support team with the following:"),
                _bullet("Order ID"),
                _bullet("Reason for return or refund"),
                _bullet("Photo/video proof (if the item is defective or incorrect)"),

                _sectionTitle("6. Contact Us"),
                const Text("If you have any questions about our refund and return policy, please contact us:"),
                const SizedBox(height: 8),
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
                Row(
                  children: const [
                    Icon(Icons.phone, size: 18, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(
                      "+8801929248067",
                      style: TextStyle(fontSize: 15),
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
