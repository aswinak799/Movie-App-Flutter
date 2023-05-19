import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFE50914);
  static const Color secondaryColor = Color(0xFF221F1F);
  static const Color accentColor = Color(0xFFFFBA00);
}

void customSnack(BuildContext ctx, Color c, String txt) {
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
      margin: EdgeInsets.all(20),
      behavior: SnackBarBehavior.floating,
      backgroundColor: c,
      content: Text(txt),
    ),
  );
}
