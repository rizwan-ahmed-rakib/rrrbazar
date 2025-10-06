import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms & Conditions"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Effective Date: 2029-12-31",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),

            Text(
              "Welcome to RRR Bazar (“we”, “us”, “our”) at https://rrrbazar.com. "
                  "By accessing or using our site and services (collectively the “Service”), you agree to these Terms & Conditions (the “Terms”). "
                  "If you do not accept these Terms, please do not use the Service.",
              style: TextStyle(fontSize: 15),
            ),

            _buildSection("1. Eligibility",
                "You must be at least 18 years old (or the age of majority in your region). "
                    "You agree to use our Service lawfully and not for any illegal purposes."),

            _buildSection("2. Account & Security",
                "You are responsible for maintaining the confidentiality of your account and password. "
                    "You must notify us immediately of any unauthorized use of your account."),

            _buildListSection("3. Online Store Terms", [
              "We may refuse service to anyone for any reason.",
              "Product listings may contain errors; we reserve the right to update or cancel orders without notice."
            ]),

            _buildListSection("4. Pricing & Payment", [
              "All prices are in Bangladeshi Taka (BDT).",
              "Payments are processed securely via third-party gateways.",
              "Orders are only processed upon successful payment. We may cancel unpaid or out-of-stock orders."
            ]),

            _buildListSection("5. Shipping, Delivery & Returns", [
              "We offer fast delivery and free shipping on eligible orders.",
              "Returns are accepted within 7 days in original condition (if applicable).",
              "Refunds are issued within 14 days once the returned item is received."
            ]),

            _buildListSection("6. Use Restrictions", [
              "Do not upload viruses, malware, or harmful content.",
              "Do not violate laws or third-party rights while using our service."
            ]),

            _buildSection("7. User Content",
                "You retain ownership of the content you post, but grant us the right to use, modify, and publish it. "
                    "You must not upload illegal or harmful content."),

            _buildSection("8. Third-Party Links",
                "We are not responsible for the privacy or content practices of any third-party websites linked from our site."),

            _buildSection("9. Disclaimers & Warranties",
                "All products and services are provided “as is” without warranties of any kind. "
                    "We do not guarantee error-free service or accuracy of content."),

            _buildSection("10. Limitation of Liability",
                "RRR Bazar is not liable for indirect or consequential damages (e.g. data loss, business interruption) to the fullest extent permitted by law."),

            _buildSection("11. Indemnification",
                "You agree to defend and indemnify us against any claims arising from your misuse of the site or violation of these Terms."),

            _buildSection("12. Severability & Waiver",
                "If any part of these Terms is found invalid, the rest remains enforceable. Failure to enforce any provision is not a waiver of that right."),

            _buildSection("13. Termination",
                "We may suspend or terminate access to our Service at any time for violation of these Terms."),

            _buildSection("14. Entire Agreement",
                "These Terms, along with our Privacy Policy, constitute the entire agreement between you and RRR Bazar."),

            SizedBox(height: 20),
            Text("Contact Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Email: support@rrrbazar.com", style: TextStyle(fontSize: 15)),
            Text("Phone: +8801929248067", style: TextStyle(fontSize: 15)),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // 🔹 Section helper widget
  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text(content, style: TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  // 🔹 List section helper widget
  Widget _buildListSection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          ...items.map(
                (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("• ", style: TextStyle(fontSize: 15)),
                  Expanded(child: Text(item, style: TextStyle(fontSize: 15))),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
