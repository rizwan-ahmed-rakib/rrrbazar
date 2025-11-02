import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSmartSignInButton extends StatefulWidget {
  const GoogleSmartSignInButton({super.key});

  @override
  State<GoogleSmartSignInButton> createState() =>
      _GoogleSmartSignInButtonState();
}

class _GoogleSmartSignInButtonState extends State<GoogleSmartSignInButton> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  GoogleSignInAccount? _account;

  @override
  void initState() {
    super.initState();
    _checkLoggedInAccount();
  }

  Future<void> _checkLoggedInAccount() async {
    final account = await _googleSignIn.signInSilently();
    setState(() => _account = account);
  }

  Future<void> _handleSignIn() async {
    final account = await _googleSignIn.signIn();
    if (account != null) {
      debugPrint("✅ Signed in: ${account.displayName}");
      setState(() => _account = account);
      // এখানে তোমার backend API তে পাঠাতে পারো
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _account;

    return InkWell(
      onTap: _handleSignIn,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF4285F4), // Google blue
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (user != null)
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(user.photoUrl ?? ""),
              )
            else
              const CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                    "https://img.icons8.com/color/48/000000/google-logo.png"),
                backgroundColor: Colors.white,
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user != null
                        ? "Sign in as ${user.displayName}"
                        : "Sign in with Google",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (user != null)
                    Text(
                      user.email,
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Image.network(
                "https://img.icons8.com/color/48/000000/google-logo.png",
                height: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
