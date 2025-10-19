// // import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'firebase_options.dart';
// import 'provider/topup_banner_provider.dart' show TopupBannerProvider;
// import 'provider/topup_products_provider.dart' show Topup_Products_Provider;
// import 'screens/addMoneyPage.dart' show AddMoneyPage;
// import 'screens/allProductsShop.dart' show AllProductsPage;
// import 'screens/detaisPage_Under_allproducts.dart' show ProductDetailsPage_under_allproducts;
// import 'screens/footer.dart' show CustomFooter;
// import 'screens/home_screen.dart';
// import 'screens/login.dart';
// import 'screens/myTransaction_page.dart' show MyTransactionsPage;
// import 'screens/myorders_page.dart' show MyOrdersPage;
// import 'screens/ordersuggestion.dart' show OrderSuggestionPage;
// import 'screens/privacy-policy.dart' show PrivacyPage;
// import 'screens/refund-policy.dart' show RefundPage;
// import 'screens/registration_screen.dart' show RegisterScreen;
// import 'screens/settingsPage.dart' show SettingsScreen;
// import 'screens/shipment.dart' show ShipmentPage;
// import 'screens/splash_screen.dart';
// import 'screens/terms&condition.dart' show TermsPage;
// import 'screens/userProfile_screen.dart' show UserProfilePage; // 👈 splash screen আলাদা ফাইল
//
// Future<void> main() async {
//   // WidgetsFlutterBinding.ensureInitialized();
//   // await Firebase.initializeApp(
//   //   options: DefaultFirebaseOptions.currentPlatform,
//   // );
//
//   // runApp(MyApp());
//
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => Topup_Products_Provider()),
//         ChangeNotifierProvider(create: (_) => TopupBannerProvider()),
//       ],
//       child: MyApp(),
//     ),
//   );
//
// }
//
//
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'RRR Bazar',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xFF009FE7),
//           primary: const Color(0xFF009FE7),
//         ),
//         useMaterial3: true,
//         fontFamily: 'Roboto',
//       ),
//       home: const SplashScreen(),
//
//       routes: {
//         '/login': (context) => const LoginScreen(),
//         '/home': (context) => HomeScreen(),
//         // '/testing': (context) => DynamicProductPage(),
//         '/footer': (context) => CustomFooter(),
//         '/terms&condition': (context) => TermsPage(),
//         '/privacypolicy': (context) => PrivacyPage(),
//         '/shipmentPage': (context) => ShipmentPage(),
//         '/refundpolicyPage': (context) => RefundPage(),
//         '/registerScreen': (context) => RegisterScreen(),
//         // '/FirestoreCrudExample': (context) => FirestoreCrudExample(),
//         '/userProfilePage': (context) => UserProfilePage(),
//         '/settingsScreen': (context) => SettingsScreen(),
//         '/allProductsPage': (context) => AllProductsPage(),
//         '/addMoneyPage': (context) => AddMoneyPage(),
//         '/myOrdersPage': (context) => MyOrdersPage(),
//         '/myTransactionsPage': (context) => MyTransactionsPage(),
//         '/productDetailsPage_under_allproducts': (context) => ProductDetailsPage_under_allproducts(product: {},),
//       },
//
//       onGenerateRoute: (settings) {
//         if (settings.name == '/ordersuggestion') {
//           final args = settings.arguments as Map<String, dynamic>;
//           return MaterialPageRoute(
//             builder: (context) => OrderSuggestionPage(
//               image: args['image'],
//               title: args['title'],
//               subtitle: args['subtitle'],
//               price: args['price'], description: '',
//             ),
//           );
//         }
//         return null;
//       },
//     );
//   }
// }





// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'provider/order_provider.dart' show OrderProvider;
import 'provider/site_provider.dart' show SiteProvider;
import 'provider/topup_banner_provider.dart' show TopupBannerProvider;
import 'provider/topup_products_provider.dart' show Topup_Products_Provider;
import 'provider/user_profile_provider.dart' show UserProfileProvider;
import 'provider/user_transaction_provider.dart' show UserTransactionProvider;
import 'screens/addMoneyPage.dart' show AddMoneyPage;
import 'screens/allProductsShop.dart' show AllProductsPage;
import 'screens/detaisPage_Under_allproducts.dart' show ProductDetailsPage_under_allproducts;
import 'screens/footer.dart' show CustomFooter;
import 'screens/home_screen.dart';
import 'screens/login.dart';
import 'screens/myTransaction_page.dart' show MyTransactionsPage;
import 'screens/myorders_page.dart' show MyOrdersPage;
import 'screens/ordersuggestion.dart' show OrderSuggestionPage;
import 'screens/privacy-policy.dart' show PrivacyPage;
import 'screens/refund-policy.dart' show RefundPage;
import 'screens/registration_screen.dart' show RegisterScreen;
import 'screens/settingsPage.dart' show SettingsScreen;
import 'screens/shipment.dart' show ShipmentPage;
import 'screens/splash_screen.dart';
import 'screens/terms&condition.dart' show TermsPage;
import 'screens/userProfile_screen.dart' show UserProfilePage;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // WidgetsFlutterBinding.ensureInitialized(); // 🔹 এটা অত্যাবশ্যক  for shared_preferaences

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Topup_Products_Provider()),
        ChangeNotifierProvider(create: (_) => TopupBannerProvider()),
        ChangeNotifierProvider(create: (_) => SiteProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => UserTransactionProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),

      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RRR Bazar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF009FE7),
          primary: const Color(0xFF009FE7),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/footer': (context) => CustomFooter(),
        '/terms&condition': (context) => TermsPage(),
        '/privacypolicy': (context) => PrivacyPage(),
        '/shipmentPage': (context) => ShipmentPage(),
        '/refundpolicyPage': (context) => RefundPage(),
        '/registerScreen': (context) => RegisterScreen(),
        '/userProfilePage': (context) => UserProfilePage(),
        '/settingsScreen': (context) => SettingsScreen(),
        '/allProductsPage': (context) => AllProductsPage(),
        '/addMoneyPage': (context) => AddMoneyPage(),
        '/myOrdersPage': (context) => MyOrdersPage(),
        '/myTransactionsPage': (context) => MyTransactionsPage(),
        '/productDetailsPage_under_allproducts': (context) =>
            ProductDetailsPage_under_allproducts(product: {}),
      },



      onGenerateRoute: (settings) {
        if (settings.name == '/ordersuggestion') {
          final args = settings.arguments as Map<String, dynamic>;

          return MaterialPageRoute(
            builder: (context) => OrderSuggestionPage(
              id: args['id'] as int,
              image: args['image'] as String,
              title: args['title'] as String,
              subtitle: args['subtitle'] as String,
              price: args['price'] as String,
              description: args['description'] as String,
            ),
          );
        }
        return null;
      },


    );
  }
}