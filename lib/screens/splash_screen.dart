import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';
import 'home_screen.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int _activeDot = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );

    // Change dots periodically
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return false;
      setState(() => _activeDot = (_activeDot + 1) % 3);
      return true;
    });

    // Navigate after delay
    Future.delayed(const Duration(seconds: 3), () async {
      if (mounted) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.loadUserFromPrefs(); // 🔹 Load user

        if (userProvider.isLoggedIn) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 800),
              pageBuilder: (_, __, ___) => HomeScreen(),
              transitionsBuilder: (_, anim, __, child) => FadeTransition(
                opacity: anim,
                child: child,
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 800),
              // pageBuilder: (_, __, ___) => const LoginScreen(),
              pageBuilder: (_, __, ___) => HomeScreen(),
              transitionsBuilder: (_, anim, __, child) => FadeTransition(
                opacity: anim,
                child: child,
              ),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final color = const Color(0xFF009FE7); //rrbazar color
    // final color = const Color(0xFF5E0000); //zs shop bd color
    // final color = const Color(0xFFFF1C1C); //bd gamebazar color  #FF1C1C
    // final color = const Color(0xFFDF232B);   // cobra topup color  #FF1C1C
    // final color = const Color(0xFF3E8A49);    // pipo bazar color  #FF1C1C
    // final color = const Color(0xFF9C0000);    // evo topup color  #9C0000
    final color = const Color(0xFFFF3B68);    // rangvo topup color  #FF3B68


    return Scaffold(
      backgroundColor: color,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  // color: Colors.white,
                  color:color,
                  shape: BoxShape.circle,
                ),
                // child: const Image(image: AssetImage('assets/appicon/zs.png')),
                // child: const Image(image: AssetImage('assets/appicon/pipo.png')),
                // child: const Image(image: AssetImage('assets/appicon/evo.png')),
                child: const Image(image: AssetImage('assets/appicon/rangvo.png')),

                // child: Padding(
                //   padding: const EdgeInsets.all(24),
                //   child: Image.asset('logo_2.png'),
                // ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _activeDot == index
                        ? Colors.white
                        // : Colors.white.withOpacity(0.4),
                        : Colors.white.withValues(alpha: 0.4),

                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text(
              // 'ZS Shop BD',
              // 'BD Game Bazar',
              // 'Cobra Topups',
              // 'Pipo Bazar',
              // 'Evo Topup',
              'Rangvo Topup',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
