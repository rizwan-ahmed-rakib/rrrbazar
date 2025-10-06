import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nanokingfisher_assesment/screens/footer.dart';
import 'package:nanokingfisher_assesment/screens/login.dart';
import 'package:nanokingfisher_assesment/screens/ordersuggestion.dart';
import 'package:nanokingfisher_assesment/screens/privacy-policy.dart';
import 'package:nanokingfisher_assesment/screens/refund-policy.dart';
import 'package:nanokingfisher_assesment/screens/shipment.dart';
import 'package:nanokingfisher_assesment/screens/terms&condition.dart';
import 'package:nanokingfisher_assesment/screens/test_crud.dart';
import 'package:nanokingfisher_assesment/screens/testing.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart'; // 👈 splash screen আলাদা ফাইল

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
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
        '/testing': (context) => DynamicProductPage(),
        '/footer': (context) => CustomFooter(),
        '/terms&condition': (context) => TermsPage(),
        '/privacypolicy': (context) => PrivacyPage(),
        '/shipmentPage': (context) => ShipmentPage(),
        '/refundpolicyPage': (context) => RefundPage(),
        '/FirestoreCrudExample': (context) => FirestoreCrudExample(),
      },

      onGenerateRoute: (settings) {
        if (settings.name == '/ordersuggestion') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => OrderSuggestionPage(
              image: args['image'],
              title: args['title'],
              subtitle: args['subtitle'],
              price: args['price'],
            ),
          );
        }
        return null;
      },
    );
  }
}
