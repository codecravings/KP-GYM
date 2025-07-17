import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF1E88E5);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF64B5F6);

  // Secondary colors
  static const Color secondary = Color(0xFFFF5722);
  static const Color secondaryDark = Color(0xFFE64A19);
  static const Color secondaryLight = Color(0xFFFF8A65);

  // Background colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Card colors for Morning and Night shift
  static const Color morningCard = Color(0xFF64B5F6);
  static const Color nightCard = Color(0xFF5C6BC0);

  // Gradient colors
  static const List<Color> morningGradient = [
    Color(0xFF90CAF9),
    Color(0xFF42A5F5),
  ];

  static const List<Color> nightGradient = [
    Color(0xFF7986CB),
    Color(0xFF3949AB),
  ];

  // Splash screen gradient
  static const List<Color> splashGradient = [
    Color(0xFF1E88E5),
    Color(0xFF0D47A1),
  ];
}
