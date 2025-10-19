import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../provider/base_url.dart';
import '../provider/site_provider.dart';
import 'customdrawer.dart';
import 'footer.dart';
import 'home_screen.dart';

class AddMoneyPage extends StatefulWidget {
  @override
  State<AddMoneyPage> createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage> {
  int selectedMethod = -1;
  bool showRequestStep = false;
  TextEditingController amountController = TextEditingController();

  final List<Map<String, String>> paymentMethods = [
    {
      "name": "Fast Add Money",
      "image": "https://api.rrrbazar.com/images/images-1663084868254.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final siteProvider = Provider.of<SiteProvider>(context);
    final site = siteProvider.siteData;
    final logoUrl = "$backendUrl/images/${site?.logo}";
    return Scaffold(
      // appBar: AppBar(title: Text("Add Money")),
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
              // child: Image.asset("assets/logo.png", height: 30,
              child: Image.network(logoUrl, height: 30,
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
      // body: LayoutBuilder(
      //   builder: (context, constraints) {
      //     return Column(
      //       children: [
      //         // Scrollable content
      //         Expanded(
      //           child: SingleChildScrollView(
      //             padding:
      //             const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      //             child: Column(
      //               children: [
      //                 // Step 1
      //                 Container(
      //                   padding: EdgeInsets.all(12),
      //                   decoration: BoxDecoration(
      //                     border: Border.all(color: Colors.grey.shade300),
      //                     borderRadius: BorderRadius.circular(12),
      //                   ),
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       // Header
      //                       Container(
      //                         decoration: BoxDecoration(
      //                           color: Colors.lightBlueAccent,
      //                           borderRadius: BorderRadius.circular(8),
      //                         ),
      //                         padding: EdgeInsets.symmetric(
      //                             horizontal: 12, vertical: 8),
      //                         child: Row(
      //                           children: [
      //                             CircleAvatar(
      //                               radius: 14,
      //                               backgroundColor: Colors.transparent,
      //                               child: Container(
      //                                 decoration: BoxDecoration(
      //                                   shape: BoxShape.circle,
      //                                   border: Border.all(
      //                                       color: Colors.white, width: 2),
      //                                 ),
      //                                 alignment: Alignment.center,
      //                                 child: Text(
      //                                   "1",
      //                                   style: TextStyle(
      //                                       color: Colors.white,
      //                                       fontWeight: FontWeight.bold),
      //                                 ),
      //                               ),
      //                             ),
      //                             SizedBox(width: 10),
      //                             Text(
      //                               "Select Payment Method",
      //                               style: TextStyle(
      //                                   color: Colors.white,
      //                                   fontSize: 16,
      //                                   fontWeight: FontWeight.bold),
      //                             ),
      //                             Spacer(),
      //
      //                           ],
      //                         ),
      //                       ),
      //                       SizedBox(height: 12),
      //                       GridView.builder(
      //                         shrinkWrap: true,
      //                         physics: NeverScrollableScrollPhysics(),
      //                         itemCount: paymentMethods.length,
      //                         gridDelegate:
      //                         SliverGridDelegateWithFixedCrossAxisCount(
      //                           crossAxisCount: 2,
      //                           mainAxisSpacing: 10,
      //                           crossAxisSpacing: 10,
      //                           childAspectRatio: 1.0,
      //                         ),
      //                         itemBuilder: (context, index) {
      //                           final method = paymentMethods[index];
      //                           final isSelected = selectedMethod == index;
      //                           return GestureDetector(
      //                             onTap: () {
      //                               setState(() {
      //                                 selectedMethod = index;
      //                                 showRequestStep = true;
      //                               });
      //                             },
      //                             child: Container(
      //                               decoration: BoxDecoration(
      //                                 borderRadius: BorderRadius.circular(12),
      //                                 border: Border.all(
      //                                     color: isSelected
      //                                         ? Colors.blue.shade600
      //                                         : Colors.grey.shade300,
      //                                     width: 2),
      //                                 gradient: isSelected
      //                                     ? LinearGradient(
      //                                     colors: [
      //                                       Colors.blue.shade300,
      //                                       Colors.blue.shade500
      //                                     ],
      //                                     begin: Alignment.topCenter,
      //                                     end: Alignment.bottomCenter)
      //                                     : null,
      //                               ),
      //                               child: Column(
      //                                 mainAxisAlignment: MainAxisAlignment.center,
      //                                 children: [
      //                                   // Image উপরে
      //                                   Image.network(
      //                                     method["image"]!,
      //                                     width: 90,  // Image বড় করা
      //                                     height: 90,
      //                                   ),
      //                                   SizedBox(height: 8),
      //                                   // Text + Tick icon একই লাইনে
      //                                   Row(
      //                                     mainAxisAlignment: MainAxisAlignment.center,
      //                                     children: [
      //                                       Flexible(
      //                                         child: Text(
      //                                           method["name"]!,
      //                                           textAlign: TextAlign.center,
      //                                           style: TextStyle(
      //                                               color: isSelected ? Colors.white : Colors.black,
      //                                               fontWeight: FontWeight.w600),
      //                                         ),
      //                                       ),
      //                                       if (isSelected) ...[
      //                                         SizedBox(width: 4),
      //                                         Icon(
      //                                           Icons.check_circle,
      //                                           color: Colors.white,
      //                                           size: 20,
      //                                         ),
      //                                       ],
      //                                     ],
      //                                   ),
      //                                 ],
      //                               ),
      //                             ),
      //                           );
      //                         },
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //
      //                 SizedBox(height: 20),
      //
      //                 // Step 2
      //                 if (showRequestStep)
      //                   Container(
      //                     padding: EdgeInsets.all(12),
      //                     decoration: BoxDecoration(
      //                       border: Border.all(color: Colors.grey.shade300),
      //                       borderRadius: BorderRadius.circular(12),
      //                     ),
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         // Header
      //                         Container(
      //                           decoration: BoxDecoration(
      //                             color: Colors.lightBlueAccent,
      //                             borderRadius: BorderRadius.circular(8),
      //                           ),
      //                           padding: EdgeInsets.symmetric(
      //                               horizontal: 12, vertical: 8),
      //                           child: Row(
      //                             children: [
      //                               CircleAvatar(
      //                                 radius: 14,
      //                                 backgroundColor: Colors.transparent,
      //                                 child: Container(
      //                                   decoration: BoxDecoration(
      //                                     shape: BoxShape.circle,
      //                                     border: Border.all(
      //                                         color: Colors.white, width: 2),
      //                                   ),
      //                                   alignment: Alignment.center,
      //                                   child: Text(
      //                                     "2",
      //                                     style: TextStyle(
      //                                         color: Colors.white,
      //                                         fontWeight: FontWeight.bold),
      //                                   ),
      //                                 ),
      //                               ),
      //                               SizedBox(width: 10),
      //                               Text(
      //                                 "Request Add Money",
      //                                 style: TextStyle(
      //                                     color: Colors.white,
      //                                     fontSize: 16,
      //                                     fontWeight: FontWeight.bold),
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //                         SizedBox(height: 12),
      //                         TextField(
      //                           controller: amountController,
      //                           keyboardType: TextInputType.number,
      //                           decoration: InputDecoration(
      //                             labelText: "Amount",
      //                             border: OutlineInputBorder(
      //                               borderRadius: BorderRadius.circular(8),
      //                             ),
      //                           ),
      //                         ),
      //                         SizedBox(height: 12),
      //                         ElevatedButton(
      //                           onPressed: () async {
      //                             if (amountController.text.isEmpty || selectedMethod == -1) {
      //                               ScaffoldMessenger.of(context).showSnackBar(
      //                                 SnackBar(
      //                                   content: Text("Please select a method and enter amount"),
      //                                 ),
      //                               );
      //                               return;
      //                             }
      //
      //                             // এখানে API call করবে
      //                             String amount = amountController.text;
      //                             int methodIndex = selectedMethod;
      //
      //                             try {
      //                               // উদাহরণ হিসেবে http POST request
      //                               // 'http' প্যাকেজ ব্যবহার করতে হবে: import 'package:http/http.dart' as http;
      //                               final response = await http.post(
      //                                 Uri.parse("https://your-api-url.com/add-money/"),
      //                                 body: {
      //                                   "amount": amount,
      //                                   "payment_method": methodIndex.toString(),
      //                                 },
      //                               );
      //
      //                               if (response.statusCode == 200) {
      //                                 ScaffoldMessenger.of(context).showSnackBar(
      //                                   SnackBar(content: Text("Money added successfully!")),
      //                                 );
      //                                 amountController.clear();
      //                                 setState(() {
      //                                   selectedMethod = -1;
      //                                   showRequestStep = false;
      //                                 });
      //                               } else {
      //                                 ScaffoldMessenger.of(context).showSnackBar(
      //                                   SnackBar(content: Text("Failed to add money")),
      //                                 );
      //                               }
      //                             } catch (e) {
      //                               ScaffoldMessenger.of(context).showSnackBar(
      //                                 SnackBar(content: Text("Error: $e")),
      //                               );
      //                             }
      //                           },
      //                           child: Text(
      //                             "Add Money",
      //                             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      //                           ),
      //                           style: ElevatedButton.styleFrom(
      //                             backgroundColor: Colors.lightBlueAccent, // blue background
      //                             minimumSize: Size(double.infinity, 45),
      //                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //
      //                 // SizedBox(height: 50),
      //                 CustomFooter(),
      //               ],
      //             ),
      //           ),
      //         ),
      //         // SizedBox(height: 50),
      //
      //         // Footer
      //         // CustomFooter(),
      //       ],
      //     );
      //   },
      // ),



      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // ===== Scrollable অংশ =====
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ---------- Step 1 ----------
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlueAccent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundColor: Colors.transparent,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 2),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "1",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Select Payment Method",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: paymentMethods.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 1.0,
                                  ),
                                  itemBuilder: (context, index) {
                                    final method = paymentMethods[index];
                                    final isSelected = selectedMethod == index;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedMethod = index;
                                          showRequestStep = true;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                              color: isSelected
                                                  ? Colors.blue.shade600
                                                  : Colors.grey.shade300,
                                              width: 2),
                                          gradient: isSelected
                                              ? LinearGradient(
                                              colors: [
                                                Colors.blue.shade300,
                                                Colors.blue.shade500
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter)
                                              : null,
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.network(
                                              method["image"]!,
                                              width: 90,
                                              height: 90,
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    method["name"]!,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: isSelected
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ),
                                                if (isSelected) ...[
                                                  SizedBox(width: 4),
                                                  Icon(Icons.check_circle,
                                                      color: Colors.white, size: 20),
                                                ],
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20),

                          // ---------- Step 2 ----------
                          if (showRequestStep)
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 14,
                                          backgroundColor: Colors.transparent,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white, width: 2),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "2",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "Request Add Money",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  TextField(
                                    controller: amountController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "Amount",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (amountController.text.isEmpty ||
                                          selectedMethod == -1) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "Please select a method and enter amount"),
                                          ),
                                        );
                                        return;
                                      }
                                      // এখানে API call হবে
                                    },
                                    child: Text(
                                      "Add Money",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.lightBlueAccent,
                                      minimumSize: Size(double.infinity, 45),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // ===== Footer সবসময় নিচে থাকবে =====
                  CustomFooter(),

                ],
              ),
            ),
          );
        },
      ),


    );
  }
}
