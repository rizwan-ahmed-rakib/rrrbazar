// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// import '../provider/user_profile_provider.dart';
//
// class PaymentWebView extends StatefulWidget {
//   final String paymentUrl;
//
//   const PaymentWebView({super.key, required this.paymentUrl});
//
//   @override
//   State<PaymentWebView> createState() => _PaymentWebViewState();
// }
//
// class _PaymentWebViewState extends State<PaymentWebView> {
//   late final WebViewController _controller;
//   bool _isLoading = true; // ✅ Loading indicator
//   bool _isProfileUpdated = false;
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller =
//         WebViewController()
//           ..setJavaScriptMode(JavaScriptMode.unrestricted)
//           ..setNavigationDelegate(
//             NavigationDelegate(
//               onPageStarted: (url) {
//                 setState(() => _isLoading = true);
//               },
//
//               // onPageFinished: (url) {
//               //   setState(() => _isLoading = false);
//               //   print("🌐 Current URL: $url");
//               //
//               //   // ✅ success redirect
//               //   if (url.contains("u-order-success")) {
//               //     if (!mounted) return;
//               //     Navigator.pushReplacementNamed(context, "/myOrdersPage");
//               //   } else if (url.contains("auto-payment-success")) {
//               //     if (!mounted) return;
//               //     Navigator.pushReplacementNamed(context, "/myTransactionsPage");
//               //   }
//               //
//               //   // ❌ fail redirect
//               //   if (url.contains("payment-failed") || url.contains("cancel")) {
//               //     if (!mounted) return;
//               //     Navigator.pushReplacementNamed(context, "/myTransactionsPage");
//               //   }
//               // },
//
//
//               ////////////////////////////////////////
//
//               // onPageFinished: (url) async {
//               //   setState(() => _isLoading = false);
//               //   print("🌐 Current URL: $url");
//               //
//               //   // ✅ success redirect
//               //   if (url.contains("u-order-success")) {
//               //     // 🔹 প্রোফাইল আপডেট করো
//               //     final profileProvider = Provider.of<UserProfileProvider>(context, listen: false);
//               //     await profileProvider.refreshProfile();
//               //
//               //     if (!mounted) return;
//               //     Navigator.pushReplacementNamed(context, "/myOrdersPage");
//               //   }
//               //   else if (url.contains("auto-payment-success")) {
//               //     // 🔹 প্রোফাইল আপডেট করো
//               //     final profileProvider = Provider.of<UserProfileProvider>(context, listen: false);
//               //     await profileProvider.refreshProfile();
//               //
//               //     if (!mounted) return;
//               //     Navigator.pushReplacementNamed(context, "/myTransactionsPage");
//               //   }
//               //   else if (url.contains("payment-failed") || url.contains("cancel")) {
//               //     if (!mounted) return;
//               //     Navigator.pushReplacementNamed(context, "/myTransactionsPage");
//               //   }
//               // },
//
//
//               ////////////////////////////////
//
//
//               onPageFinished: (url) async {
//                 print("_isProfileUpdated value is=${_isProfileUpdated}");
//                 setState(() => _isLoading = false);
//                 print("🌐 Current URL: $url");
//
//                 if ((url.contains("u-order-success") ||
//                         url.contains("auto-payment-success")) &&
//                     !_isProfileUpdated) {
//                   _isProfileUpdated = true; // ✅ বারবার রিফ্রেশ ঠেকাতে
//
//                   final profileProvider = Provider.of<UserProfileProvider>(
//                     context,
//                     listen: false,
//                   );
//                   await profileProvider.refreshProfile();
//
//                   if (!mounted) return;
//                   Navigator.pushReplacementNamed(
//                     context,
//                     url.contains("u-order-success")
//                         ? "/myOrdersPage"
//                         : "/myTransactionsPage",
//                   );
//                 }
//
//                 if (url.contains("payment-failed") || url.contains("cancel")) {
//                   if (!mounted) return;
//                   Navigator.pushReplacementNamed(
//                     context,
//                     "/myTransactionsPage",
//                   );
//                 }
//
//                 if (url.contains("undefined") || url.contains("cancel")) {
//
//
//                   if (!mounted) return;
//
//                   // 🔹 SnackBar দেখানো
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text(
//                         "❌ Transaction ID match করে নাই! "
//                             "please try again",
//                         style: TextStyle(fontWeight: FontWeight.w600,color:Colors.red),
//                       ),
//                       backgroundColor: Colors.yellowAccent,
//                       behavior: SnackBarBehavior.floating,
//                       duration: Duration(seconds: 3),
//                     ),
//                   );
//
//
//                   // ⏳ 1 সেকেন্ড অপেক্ষা করো যাতে SnackBar দেখায়
//                   await Future.delayed(const Duration(milliseconds: 1200));
//
//                   // // 🔹 Redirect to My Transactions Page
//                   // Navigator.pushReplacementNamed(
//                   //   context,
//                   //   "/myTransactionsPage",
//                   // );
//
//
//                   // 🔙 আগের page এ ফিরে যাওয়ার চেষ্টা
//                   bool canGoBack = await _controller.canGoBack();   // <-- এখানেই লিখবে
//
//                   if (canGoBack) {
//                     _controller.goBack();   // 🔙 আগের পেজে ফিরে যাবে
//                   } else {
//                     print("❌ No previous page in WebView stack.");
//                   }
//                 }
//
//               },
//             ),
//           )
//           ..loadRequest(Uri.parse(widget.paymentUrl));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Complete Payment")),
//       body: Stack(
//         children: [
//           WebViewWidget(controller: _controller),
//           if (_isLoading) const Center(child: CircularProgressIndicator()),
//           // ✅ Loading spinner
//         ],
//       ),
//     );
//   }
// }


///////////////////////////////////////////////////
///////////////////////////////////////////////////

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import '../provider/user_profile_provider.dart';

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;
  final String orderType; // "auto_payment" বা "manual_payment"

  const PaymentWebView({
    super.key,
    required this.paymentUrl,
    this.orderType = "auto_payment",
  });

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasProcessed = false;
  bool _isNavigating = false;
  Timer? _timeoutTimer;
  Timer? _redirectCheckTimer;

  // ✅ সকল পেমেন্ট গেটওয়ে ডোমেইন
  final List<String> _paymentGateways = [
    'uddoktapay.com',
    'paymently.io',
    'sandbox.uddoktapay.com',
    'newpay.paymently.io',
    'sslcommerz.com',
    'aamarpay.com',
    'shurjopay.com',
  ];

  // ✅ সকল সফল রিডাইরেক্ট প্যাটার্ন
  final List<String> _successPatterns = [
    '/profile/order',
    'auto-payment-success',
    'u-order-success',
    'order-success',
    'payment-success',
    'success',
    'completed',
    'status=success',
    'transaction=success',
  ];

  // ✅ সকল ব্যর্থ প্যাটার্ন
  final List<String> _failurePatterns = [
    'payment-failed',
    'failed',
    'cancel',
    'error',
    'declined',
    'status=failed',
    'transaction=failed',
  ];

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    _startRedirectChecker();
    _startTimeoutTimer();
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    _redirectCheckTimer?.cancel();
    super.dispose();
  }

  void _initializeWebView() {
    print("🎯 Payment WebView Initialized");
    print("🌐 Payment URL: ${widget.paymentUrl}");
    print("📦 Order Type: ${widget.orderType}");

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            print("🚀 Page Started: $url");
            setState(() => _isLoading = true);
            _checkForRedirect(url);
          },
          onPageFinished: (url) async {
            print("🏁 Page Finished: $url");
            setState(() => _isLoading = false);
            await _checkForRedirect(url);
          },
          onNavigationRequest: (navigation) {
            print("🧭 Navigation Request: ${navigation.url}");
            return NavigationDecision.navigate;
          },
          onUrlChange: (change) {
            print("🔄 URL Changed: ${change.url}");
            _checkForRedirect(change.url ?? '');
          },
          onWebResourceError: (error) {
            print("❌ Web Resource Error: ${error.errorCode} - ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _startRedirectChecker() {
    // প্রতি ২ সেকেন্ডে চেক করে যদি রিডাইরেক্ট মিস করে
    _redirectCheckTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (_hasProcessed || _isNavigating) {
        timer.cancel();
        return;
      }

      try {
        final currentUrl = await _controller.currentUrl();
        if (currentUrl != null) {
          await _checkForRedirect(currentUrl);
        }
      } catch (e) {
        print("⚠️ Error checking URL: $e");
      }
    });
  }

  void _startTimeoutTimer() {
    // ৩ মিনিট পর টাইমআউট
    _timeoutTimer = Timer(const Duration(minutes: 3), () {
      if (!_hasProcessed && !_isNavigating && mounted) {
        print("⏰ Payment Timeout");

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Payment Timeout"),
            content: const Text("Payment is taking too long. Do you want to cancel?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Wait"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handlePaymentTimeout();
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
        );
      }
    });
  }

  Future<void> _checkForRedirect(String url) async {
    if (_hasProcessed || _isNavigating) return;

    print("🔍 Checking Redirect for: $url");

    // 1️⃣ চেক যদি পেমেন্ট গেটওয়েতে আছে
    bool isOnPaymentGateway = false;
    for (var gateway in _paymentGateways) {
      if (url.contains(gateway)) {
        isOnPaymentGateway = true;
        print("💳 On Payment Gateway: $gateway");
        break;
      }
    }

    // 2️⃣ যদি পেমেন্ট গেটওয়েতে না থাকে (রিডাইরেক্ট হয়েছে)
    if (!isOnPaymentGateway) {
      print("🔄 Not on payment gateway, checking redirect...");

      // 🔹 সফল পেমেন্ট চেক
      for (var pattern in _successPatterns) {
        if (url.contains(pattern)) {
          print("✅ Success pattern matched: $pattern");
          await _handleSuccess(url);
          return;
        }
      }

      // 🔹 ব্যর্থ পেমেন্ট চেক
      for (var pattern in _failurePatterns) {
        if (url.contains(pattern)) {
          print("❌ Failure pattern matched: $pattern");
          await _handleFailure(url);
          return;
        }
      }

      // 🔹 লগিন পেজে রিডাইরেক্ট (সেশন শেষ)
      if (url.contains('/login') || url.contains('redirect_url')) {
        print("🔐 Login redirect detected (session expired)");
        await _handleLoginRedirect(url);
        return;
      }

      // 🔹 আপনার নিজের ডোমেইনে রিডাইরেক্ট
      if (url.contains('zsshopbd.com') ||
          url.contains('cobratopups.com') ||
          url.contains('localhost')) {
        print("🏠 Redirected to own domain");
        await _handleOwnDomainRedirect(url);
        return;
      }
    }
  }

  Future<void> _handleSuccess(String url) async {
    _hasProcessed = true;
    _isNavigating = true;
    _timeoutTimer?.cancel();
    _redirectCheckTimer?.cancel();

    print("🎉 Payment Success!");

    // 🔹 প্রোফাইল রিফ্রেশ
    try {
      final profileProvider = Provider.of<UserProfileProvider>(
        context,
        listen: false,
      );
      await profileProvider.refreshProfile();
      print("✅ Profile refreshed");
    } catch (e) {
      print("⚠️ Profile refresh error: $e");
    }

    // 🔹 রিডাইরেক্ট
    if (mounted) {
      // Auto Payment এর জন্য My Orders
      // Manual Payment এর জন্য My Transactions
      String route = widget.orderType == "auto_payment"
          ? "/myOrdersPage"
          : "/myTransactionsPage";

      print("🔄 Redirecting to: $route");

      await Future.delayed(const Duration(milliseconds: 1500));

      Navigator.pushReplacementNamed(context, route);
    }
  }

  Future<void> _handleFailure(String url) async {
    _hasProcessed = true;
    _isNavigating = true;

    print("💔 Payment Failed");

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Payment failed. Please try again."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 1500));
      Navigator.pushReplacementNamed(context, "/myTransactionsPage");
    }
  }

  Future<void> _handleLoginRedirect(String url) async {
    print("🔐 Handling login redirect");

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Session Expired"),
          content: const Text("Your session has expired. Payment was successful. You'll be redirected to orders page."),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                // প্রোফাইল রিফ্রেশ
                try {
                  final profileProvider = Provider.of<UserProfileProvider>(
                    context,
                    listen: false,
                  );
                  await profileProvider.refreshProfile();
                } catch (e) {
                  print("Error: $e");
                }

                // রিডাইরেক্ট
                String route = widget.orderType == "auto_payment"
                    ? "/myOrdersPage"
                    : "/myTransactionsPage";

                Navigator.pushReplacementNamed(context, route);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _handleOwnDomainRedirect(String url) async {
    // আপনার নিজের ডোমেইনে রিডাইরেক্ট হলে সাধারণত সফল
    print("🏠 Own domain redirect - assuming success");
    await _handleSuccess(url);
  }

  Future<void> _handlePaymentTimeout() async {
    _hasProcessed = true;
    _isNavigating = true;

    if (mounted) {
      Navigator.pushReplacementNamed(context, "/myTransactionsPage");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Payment"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      "Loading payment gateway...",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Please wait",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _isLoading
          ? null
          : Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Complete payment in the opened gateway",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Cancel Payment?"),
                    content: const Text("Are you sure you want to cancel?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("No"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(
                              context,
                              "/myTransactionsPage"
                          );
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                );
              },
              child: const Text("Cancel Payment"),
            ),
          ],
        ),
      ),
    );
  }
}