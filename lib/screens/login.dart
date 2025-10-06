import 'package:flutter/material.dart';

import 'customdrawer.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f9fc),
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: [
            Image.asset(
              "logo.png",
              height: 30,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Register"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Login"),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            /// 🔹 Login Card
            Center(
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Login",
                      style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),

                    /// 🔹 Google Login Button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.grey),
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      icon: Image.network(
                        "https://img.icons8.com/color/48/000000/google-logo.png",
                        height: 22,
                      ),
                      label: const Text("Sign in with Google"),
                      onPressed: () {
                        // Google sign-in action
                      },
                    ),

                    const SizedBox(height: 20),

                    /// 🔹 Email Input
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// 🔹 Password Input
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// 🔹 Remember Me Checkbox
                    Row(
                      children: [
                        Checkbox(value: true, onChanged: (v) {}),
                        const Text("Remember me"),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// 🔹 Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Login"),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// 🔹 Forgot + Register
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text("Forgot password?"),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don’t have an account? "),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                "Create One",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// 🔹 Support Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Colors.lightBlueAccent,
              child: Column(
                children: const [
                  Text(
                    "SUPPORT",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  SupportRow(
                      icon: Icons.phone,
                      text: "+8801929248067",
                      time: "10AM - 10PM"),
                  SizedBox(height: 10),
                  SupportRow(
                      icon: Icons.phone,
                      text: "+8801929248067",
                      time: "10AM - 10PM"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Support Row Widget
class SupportRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final String time;

  const SupportRow(
      {super.key, required this.icon, required this.text, required this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(time, style: const TextStyle(color: Colors.white70)),
            Text(text,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
