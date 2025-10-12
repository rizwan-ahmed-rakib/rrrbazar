import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'footer.dart';
import 'home_screen.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:

      // AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 2,
      //   title: Row(
      //     children: [
      //       Image.asset(
      //         "logo.png",
      //         height: 30,
      //       ),
      //     ],
      //   ),
      //   actions: [
      //     TextButton(
      //       onPressed: () {},
      //       child: const Text(
      //         "Register",
      //         style: TextStyle(color: Colors.black87),
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
      //       child: ElevatedButton(
      //         onPressed: () {
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (context) => const LoginScreen()));
      //         },
      //         child: const Text("Login"),
      //       ),
      //     ),
      //   ],
      // ),

      AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                // 🏠 এখানে তোমার HomeScreen এ নিয়ে যাও
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Image.asset(
                "assets/logo.png",
                height: 30,
              ),
            ),
          ],
        ),
        actions: [
          // Register Button
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Primary background
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 0,
            ),

            child: Text(
              "Register",
              style: TextStyle(
                color: Colors.white, // Primary color
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Login Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                // Login action
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Primary background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: BorderSide(color: Colors.lightBlueAccent, width: 2), // 🔹 ব্লু বর্ডার


                ),
                elevation: 0,
              ),
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.black,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),


        // ✅ পুরো স্ক্রলযোগ্য পেজ + নিচে footer থাকবে
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: width < 700 ? width * 0.9 : 650,
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.only(bottom: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Register",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Google Sign-In Button
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: OutlinedButton.icon(
                        icon: Image.network(
                          "https://img.icons8.com/color/48/000000/google-logo.png",
                          height: 22,
                        ),
                        label: const Text(
                          "Sign up with Google",
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                        onPressed: () {
                          print("Google Sign-In Clicked");
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // OR Divider
                    Row(
                      children: [
                        Expanded(
                            child: Divider(
                                color: Colors.grey[300], thickness: 1.3)),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child:
                          Text("Or", style: TextStyle(color: Colors.black54)),
                        ),
                        Expanded(
                            child: Divider(
                                color: Colors.grey[300], thickness: 1.3)),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // Username & Phone
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 500) {
                          return Column(
                            children: [
                              _buildTextField("Username", _usernameController),
                              const SizedBox(height: 15),
                              _buildTextField("Phone", _phoneController),
                            ],
                          );
                        } else {
                          return Row(
                            children: [
                              Expanded(
                                  child: _buildTextField(
                                      "Username", _usernameController)),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: _buildTextField(
                                      "Phone", _phoneController)),
                            ],
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 15),

                    _buildTextField("Email", _emailController),

                    const SizedBox(height: 15),

                    // Password Fields
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 500) {
                          return Column(
                            children: [
                              _buildPasswordField(
                                "Password",
                                _passwordController,
                                _showPassword,
                                    () => setState(
                                        () => _showPassword = !_showPassword),
                              ),
                              const SizedBox(height: 15),
                              _buildPasswordField(
                                "Confirm Password",
                                _confirmPasswordController,
                                _showConfirmPassword,
                                    () => setState(() => _showConfirmPassword =
                                !_showConfirmPassword),
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            children: [
                              Expanded(
                                child: _buildPasswordField(
                                  "Password",
                                  _passwordController,
                                  _showPassword,
                                      () => setState(() =>
                                  _showPassword = !_showPassword),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildPasswordField(
                                  "Confirm Password",
                                  _confirmPasswordController,
                                  _showConfirmPassword,
                                      () => setState(() => _showConfirmPassword =
                                  !_showConfirmPassword),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 25),

                    // Create Account Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          print("Create Account clicked");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Create Account",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        const Text("Have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          child: const Text(
                            "Login here",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ✅ এখন Footer scroll এর অংশ, fixed না
             CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelStyle: const TextStyle(color: Colors.blueAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      String label, TextEditingController controller, bool isVisible, VoidCallback toggle) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelStyle: const TextStyle(color: Colors.blueAccent),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: toggle,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }
}
