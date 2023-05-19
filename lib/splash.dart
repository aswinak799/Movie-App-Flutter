import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:netflix/home.dart';
import 'package:netflix/login.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    checkLogedIn();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "A K Movies",
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> gotoLogin() async {
    await Future.delayed(
      Duration(seconds: 3),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) {
          return LoginScreen();
        },
      ),
    );
  }

  Future<void> checkLogedIn() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      gotoLogin();
    } else {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) {
              return HomeScreen();
            },
          ),
        );
      });
    }
  }
}
