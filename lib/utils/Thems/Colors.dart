import 'package:flutter/material.dart';

class AppColors {
  // Light theme colors
  static const Color lightPrimary = Colors.blue;
  static const Color lightSecondary = Color(0xFF03DAC6);
  static const Color lightBackground = Colors.white;
  static const Color lightSurface = Colors.white;
  static const Color lightCard = Colors.white;
  static const Color lightCardShadow = Color.fromARGB(49, 193, 193, 193);
  
  // Light theme text colors
  static const Color lightOnPrimary = Colors.white;
  static const Color lightOnSecondary = Colors.black;
  static const Color lightOnBackground = Colors.black87;
  static const Color lightOnSurface = Colors.black54;

  // Dark theme colors - lighter/softer dark mode
  static const Color darkPrimary = Color(0xFF42A5F5); // Lighter blue
  static const Color darkSecondary = Color(0xFF03DAC6);
  static const Color darkBackground = Color(0xFF1A1A1A); // Lighter dark background
  static const Color darkSurface = Color(0xFF2A2A2A); // Lighter surface
  static const Color darkCard = Color(0xFF2D2D2D); // Lighter card
  static const Color darkCardShadow = Color.fromARGB(50, 0, 0, 0);
  
  // Dark theme text colors
  static const Color darkOnPrimary = Colors.white;
  static const Color darkOnSecondary = Colors.black;
  static const Color darkOnBackground = Color(0xFFE0E0E0); // Brighter text
  static const Color darkOnSurface = Color(0xFFB0B0B0); // Brighter secondary text

  // Status colors (used in both themes)
  static const Color error = Color(0xFFB00020);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // Additional utility colors
  static const Color transparent = Colors.transparent;
  static const Color disabled = Colors.grey;
  static const Color divider = Color(0xFFE0E0E0);
}