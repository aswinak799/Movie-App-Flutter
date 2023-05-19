import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:netflix/colors.dart';
import 'package:netflix/home.dart';
import 'package:netflix/signup.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _emailCntrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _passwdCntrl = TextEditingController();
  Future<void> _login(String email, String pass, BuildContext ctx) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
      User user = credential.user!;
      // print(credential.user!.email);
      Navigator.of(ctx).pushReplacement(MaterialPageRoute(builder: (ctx) {
        return HomeScreen();
      }));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        customSnack(ctx, Colors.redAccent, "No user found for that email");
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        customSnack(
            ctx, Colors.redAccent, "Wrong password provided for that user.");
      }
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
                    "Sign In",
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
                          String email = _emailCntrl.text.trim();
                          String password = _passwdCntrl.text.trim();
                          if (_formKey.currentState!.validate()) {
                            // _submit(name, email, password, context);
                            // Form is valid, perform desired actions
                            _login(email, password, context);
                            // For example, submit the form or navigate to another screen
                          }
                        },
                        child: Text("Sign In"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (ctx) {
                              return SignUpScreen();
                            }));
                          },
                          child: Text("Dont have any account ?"))
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
