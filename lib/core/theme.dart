import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: const TextTheme(
      labelLarge: TextStyle(
        fontFamily: "Poppins",
        fontSize: 14,
        fontWeight: FontWeight.w500,
        inherit: true, // explicitly same
      ),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: const TextTheme(
      labelLarge: TextStyle(
        fontFamily: "Poppins",
        fontSize: 14,
        fontWeight: FontWeight.w500,
        inherit: true, // MUST MATCH
      ),
    ),
  );
}
