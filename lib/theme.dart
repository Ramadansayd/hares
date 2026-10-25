import 'package:flutter/material.dart';

class AppColors {
  static const gold = Color(0xFFD4A94F);
  static const goldLight = Color(0xFFF1D78F);
  static const cream = Color(0xFFFFF1CF);
  static const ink = Color(0xFF2A211A);
  static const blue = Color(0xFF4F7BB5);
  static const green = Color(0xFF58A16A);
  static const grey = Color(0xFF9A9A9A);
  static const amber = Color(0xFFD9A441);
}

const appBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFD9CDB8), Color(0xFF8C7B64), Color(0xFF2A211A)],
    stops: [0.0, 0.45, 1.0],
  ),
);

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    // fontFamily: 'Cairo', // فعّلها بعد ما تضيف الخط في pubspec.yaml
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.gold,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: AppColors.ink,
  );
}
