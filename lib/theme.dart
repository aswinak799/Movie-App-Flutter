import 'package:flutter/material.dart';
import 'package:netflix/colors.dart';

class Customer {
  final String name;
  final bool prime;

  Customer({required this.name, required this.prime});
}

class AppTheme {
  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      accentColor: AppColors.accentColor,
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        headline6: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.secondaryColor,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
