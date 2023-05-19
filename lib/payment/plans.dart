import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netflix/payment/razorpay.dart';

class PrimeMember extends StatefulWidget {
  const PrimeMember({super.key});

  @override
  State<PrimeMember> createState() => _PrimeMemberState();
}

class _PrimeMemberState extends State<PrimeMember> {
  String _userName = "";
  final RazorPayIntegration _integration = RazorPayIntegration();
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    _integration.intiateRazorPay();
    _getUser();
    super.initState();
  }

  Future<void> _getUser() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user!.uid) // Add your condition here
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        print('Name: ${doc['name']},');

        if (mounted) {
          setState(() {
            _userName = doc['name'];
          });
        }
      }
    } catch (e) {
      print('Error reading documents: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Unlock Premium")),
      body: SafeArea(
          child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.2, 0.8],
                colors: [
                  Color.fromRGBO(0, 0, 0, 1),
                  Color.fromRGBO(72, 240, 210, 0.4),
                ],
              )),
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _userName,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white60),
                        ),
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKnkHmiO0N4mdQR_9SeuyNnU1Jd2CCedHdk7IKmrvU-Q3AKtGcLr5gnT7yRR_RYMjhWEQ&usqp=CAU"),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        Text(
                          "PLANS",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white60),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      color: Colors.indigo,
                      elevation: 10,
                      child: ListTile(
                        onTap: () async {
                          _integration.openSession(amount: 150);
                          await Future.delayed(
                            Duration(seconds: 3),
                          );
                          Navigator.of(context).pop();
                        },
                        leading: Text(
                          "₹ 150",
                          style: GoogleFonts.andika(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        title: Text(
                          "Normal",
                          style: GoogleFonts.andika(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        trailing: Icon(Icons.workspace_premium_rounded),
                        subtitle: Text(
                          "One month subscription",
                          style: GoogleFonts.andika(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      color: Colors.yellow[400],
                      elevation: 10,
                      child: ListTile(
                        onTap: () async {
                          _integration.openSession(amount: 250);
                          await Future.delayed(
                            Duration(seconds: 3),
                          );
                          Navigator.of(context).pop();
                        },
                        leading: Text(
                          "₹ 250",
                          style: GoogleFonts.andika(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        title: Text(
                          "Premium Pass",
                          style: GoogleFonts.andika(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        trailing: Icon(Icons.workspace_premium_rounded),
                        subtitle: Text(
                          "Two month subscription",
                          style: GoogleFonts.andika(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      color: Colors.deepOrange[200],
                      elevation: 10,
                      child: ListTile(
                        onTap: () async {
                          _integration.openSession(amount: 450);
                          await Future.delayed(
                            Duration(seconds: 3),
                          );
                          Navigator.of(context).pop();
                        },
                        leading: Text(
                          "₹ 450",
                          style: GoogleFonts.andika(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        title: Text(
                          "Extra Premium",
                          style: GoogleFonts.andika(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        trailing: Icon(Icons.workspace_premium_rounded),
                        subtitle: Text(
                          "Five month subscription",
                          style: GoogleFonts.andika(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Card(
                      color: Colors.cyan[200],
                      elevation: 10,
                      child: ListTile(
                        title: Text(
                          "Eneble Premium Features",
                          style: GoogleFonts.andika(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        trailing: Icon(Icons.workspace_premium_rounded),
                        subtitle: Text(
                          "Movie searching ,Trailer watching,Movie Details",
                          style: GoogleFonts.andika(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}
