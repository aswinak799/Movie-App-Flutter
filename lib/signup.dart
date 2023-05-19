import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:netflix/colors.dart';
import 'package:netflix/home.dart';
import 'package:netflix/login.dart';
import 'package:netflix/main.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);
  final _nameCntrl = TextEditingController();
  final _emailCntrl = TextEditingController();
  final db = FirebaseFirestore.instance;
  final _passwdCntrl = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  Future<void> _submit(
      String name, String email, String pass, BuildContext context) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      User user = credential.user!;
      await user.updateDisplayName(name);

      final uid = credential.user?.uid;
      final userobj = <String, dynamic>{"name": name, "uid": uid};
      try {
        // Add a new document with a generated ID
        db.collection("users").add(userobj).then((DocumentReference doc) =>
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return LoginScreen();
            })));
      } catch (e) {
        print(e);
      }
      print(credential.user?.uid);
      print("Successful registration");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        customSnack(
            context, Colors.redAccent, "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        customSnack(context, Colors.redAccent,
            "The account already exists for that email.");
      }
    } catch (e) {
      customSnack(context, Colors.redAccent,
          "An error occurred during registration: $e");
      // print("An error occurred during registration: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                child: Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 45, color: Colors.black54),
                  ),
                ),
                width: screenWidth,
                height: screenHeight * 0.4,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(250),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter the name";
                          }
                          return null;
                        },
                        controller: _nameCntrl,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Name",
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter the email";
                          } else if (!isValidEmail(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        controller: _emailCntrl,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email",
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter the password";
                          } else if (value.length < 6) {
                            return 'Password contain must 6 characters';
                          }
                          return null;
                        },
                        controller: _passwdCntrl,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Password",
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          String name = _nameCntrl.text.trim();
                          String email = _emailCntrl.text.trim();
                          String password = _passwdCntrl.text.trim();
                          if (_formKey.currentState!.validate()) {
                            _submit(name, email, password, context);
                            // Form is valid, perform desired actions
                            // For example, submit the form or navigate to another screen
                          }
                        },
                        child: Text("Sign Up"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(
                          onPressed: (() {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (ctx) {
                              return LoginScreen();
                            }));
                          }),
                          child: Text("Already have an account ?"))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String value) {
    // Simple email validation using regular expression
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z\d-]+(\.[a-zA-Z\d-]+)*\.[a-zA-Z\d-]+$');
    return emailRegex.hasMatch(value);
  }
}
