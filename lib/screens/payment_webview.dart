import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../provider/user_profile_provider.dart';

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;

  const PaymentWebView({super.key, required this.paymentUrl});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;
  bool _isLoading = true; // ✅ Loading indicator
  bool _isProfileUpdated = false;

  @override
  void initState() {
    super.initState();

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (url) {
                setState(() => _isLoading = true);
              },

              // onPageFinished: (url) {
              //   setState(() => _isLoading = false);
              //   print("🌐 Current URL: $url");
              //
              //   // ✅ success redirect
              //   if (url.contains("u-order-success")) {
              //     if (!mounted) return;
              //     Navigator.pushReplacementNamed(context, "/myOrdersPage");
              //   } else if (url.contains("auto-payment-success")) {
              //     if (!mounted) return;
              //     Navigator.pushReplacementNamed(context, "/myTransactionsPage");
              //   }
              //
              //   // ❌ fail redirect
              //   if (url.contains("payment-failed") || url.contains("cancel")) {
              //     if (!mounted) return;
              //     Navigator.pushReplacementNamed(context, "/myTransactionsPage");
              //   }
              // },

              // onPageFinished: (url) async {
              //   setState(() => _isLoading = false);
              //   print("🌐 Current URL: $url");
              //
              //   // ✅ success redirect
              //   if (url.contains("u-order-success")) {
              //     // 🔹 প্রোফাইল আপডেট করো
              //     final profileProvider = Provider.of<UserProfileProvider>(context, listen: false);
              //     await profileProvider.refreshProfile();
              //
              //     if (!mounted) return;
              //     Navigator.pushReplacementNamed(context, "/myOrdersPage");
              //   }
              //   else if (url.contains("auto-payment-success")) {
              //     // 🔹 প্রোফাইল আপডেট করো
              //     final profileProvider = Provider.of<UserProfileProvider>(context, listen: false);
              //     await profileProvider.refreshProfile();
              //
              //     if (!mounted) return;
              //     Navigator.pushReplacementNamed(context, "/myTransactionsPage");
              //   }
              //   else if (url.contains("payment-failed") || url.contains("cancel")) {
              //     if (!mounted) return;
              //     Navigator.pushReplacementNamed(context, "/myTransactionsPage");
              //   }
              // },
              onPageFinished: (url) async {
                print("_isProfileUpdated value is=${_isProfileUpdated}");
                setState(() => _isLoading = false);
                print("🌐 Current URL: $url");

                if ((url.contains("u-order-success") ||
                        url.contains("auto-payment-success")) &&
                    !_isProfileUpdated) {
                  _isProfileUpdated = true; // ✅ বারবার রিফ্রেশ ঠেকাতে

                  final profileProvider = Provider.of<UserProfileProvider>(
                    context,
                    listen: false,
                  );
                  await profileProvider.refreshProfile();

                  if (!mounted) return;
                  Navigator.pushReplacementNamed(
                    context,
                    url.contains("u-order-success")
                        ? "/myOrdersPage"
                        : "/myTransactionsPage",
                  );
                }

                if (url.contains("payment-failed") || url.contains("cancel")) {
                  if (!mounted) return;
                  Navigator.pushReplacementNamed(
                    context,
                    "/myTransactionsPage",
                  );
                }
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Payment")),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          // ✅ Loading spinner
        ],
      ),
    );
  }
}
