import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nanokingfisher_assesment/screens/terms&condition.dart';

class CustomFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent.shade200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- Top Section ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Mobile view (single column)
                if (constraints.maxWidth < 600) {
                  return Column(
                    children: [
                      _buildSupportSection(),
                      SizedBox(height: 20),
                      _buildAboutSection(context),
                      SizedBox(height: 20),
                      _buildStayConnectedSection(),
                    ],
                  );
                }
                // Tablet/Desktop view (three columns)
                else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSupportSection(),
                      _buildAboutSection(context),
                      _buildStayConnectedSection(),
                    ],
                  );
                }
              },
            ),
          ),

          Divider(color: Colors.white30, thickness: 0.5),

          // --- Bottom Section ---
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "© Copyright 2025. All Rights Reserved. Developed by RRRBazar",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // Support Section Widget
  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "SUPPORT",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 12),

        // Phone Support
        Row(
          children: [
            Icon(Icons.phone, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "10AM - 10PM",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  "+8801929248067",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12),

        // WhatsApp Support
        Row(
          children: [
            FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "10AM - 10PM",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  "+8801929248067",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ABOUT",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 12),
        _buildFooterLink("Terms & Conditions", context, "/terms&condition"),
        _buildFooterLink("Privacy Policy", context, "/privacypolicy"),
        _buildFooterLink("Shipment Info", context, "/shipmentPage"),
        _buildFooterLink("Refund Policy", context, "/refundpolicyPage"),
      ],
    );
  }

  // Stay Connected Section Widget
  Widget _buildStayConnectedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "STAY CONNECTED",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 12),
        Text(
          "RRRBazar",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        Text(
          "Dhaka, Bangladesh",
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        SizedBox(height: 4),
        Text(
          "rrrbazarofficial@gmail.com",
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.facebook, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Icon(Icons.play_arrow, color: Colors.white, size: 20),
            // YouTube icon
          ],
        ),
      ],
    );
  }



  // Footer Link Widget
  Widget _buildFooterLink(String text, BuildContext context, String route) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            // decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
