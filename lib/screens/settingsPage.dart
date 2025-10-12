import 'package:flutter/material.dart';

import 'customdrawer.dart';
import 'footer.dart';
import 'home_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isEditingPhone = false;
  final TextEditingController _phoneController =
  TextEditingController(text: "01521416544");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // 🔥 ডিফল্ট Hamburger আইকন লুকিয়ে দিলাম
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
          Builder(
            builder: (context) {
              return InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer(); // ✅ Drawer open হবে
                },
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 400) {
                      // Mobile এ শুধু Image
                      return const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: CircleAvatar(
                          backgroundImage: AssetImage("assets/user.png"),
                        ),
                      );
                    } else {
                      // Tablet/Desktop এ Full Profile
                      return Row(
                        children: const [
                          CircleAvatar(backgroundImage: AssetImage("assets/user.png")),
                          SizedBox(width: 6),
                          Text("Hellowfarjan"),
                          Icon(Icons.arrow_drop_down),
                          SizedBox(width: 10),
                        ],
                      );
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xfff9fafb),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔹 Top Banner
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.blueAccent,
            ),

            // 🔹 Profile Image and Info
            Transform.translate(
              offset: const Offset(0, -75),
              child: Column(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white, width: 4),
                      image: const DecorationImage(
                        image: AssetImage("assets/user.png"),
                        // NetworkImage(
                        //     'https://lh3.googleusercontent.com/a/ACg8ocIYFrq63uiy7rJWZPC9CSYHAKyBMIcwy-Ccdg6Fpjl3O_zKDpE=s96-c'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "rizwan35-2579",
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Info Cards
                  _infoCard("User ID:", "391434"),
                  _infoCard("Email:", "rizwan35-2579@diu.edu.bd"),
                  _phoneSection(),
                  _changePasswordSection(),
                ],
              ),
            ),
            CustomFooter(),

          ],

        ),
      ),

      // 🔹 Fixed Custom Footer
      // bottomNavigationBar: Container(
      //   color: Colors.white,
      //   padding: const EdgeInsets.symmetric(vertical: 12),
      //   child: const Text(
      //     "© 2025 Freelance Digital IT",
      //     textAlign: TextAlign.center,
      //     style: TextStyle(fontSize: 14, color: Colors.grey),
      //   ),
      // ),


    );
  }

  // 🔸 Info Card Widget
  Widget _infoCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 6)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey)),
          Text(value,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // 🔸 Phone Section (Edit Feature)
  Widget _phoneSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 6)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Phone:",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey)),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade50,
                      foregroundColor: Colors.blueAccent,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      textStyle: const TextStyle(fontSize: 13),
                    ),
                    child: const Text("Verify phone"),
                  ),
                  const SizedBox(width: 8),
                  Text(_phoneController.text),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      _isEditingPhone ? Icons.close : Icons.edit,
                      size: 20,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        _isEditingPhone = !_isEditingPhone;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),

          // 🔸 Editable Form (toggle)
          if (_isEditingPhone) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: "Your phone",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isEditingPhone = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Phone changed to ${_phoneController.text}"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Change Phone"),
            ),
          ],
        ],
      ),
    );
  }

  // 🔸 Change Password Section
  Widget _changePasswordSection() {
    final oldController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 6)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Change Password",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey)),
          const SizedBox(height: 16),
          TextField(
            controller: oldController,
            decoration: const InputDecoration(
              hintText: "Old password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: newController,
            decoration: const InputDecoration(
              hintText: "New password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: confirmController,
            decoration: const InputDecoration(
              hintText: "Confirm password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45)),
            child: const Text("Change Password"),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text("Forgot password?"),
            ),
          ),
        ],
      ),
    );
  }
}
