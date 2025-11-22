import 'package:flutter/material.dart';
import 'Colors.dart';

class AppTextStyles {
  // Light theme text styles
  static const TextStyle lightHeadline = TextStyle(
    fontFamily: 'Roboto', 
    fontSize: 30, 
    fontWeight: FontWeight.bold, 
    color: AppColors.lightPrimary
  );
  
  static const TextStyle lightSubheading = TextStyle(
    fontFamily: 'Roboto', 
    fontSize: 20, 
    fontWeight: FontWeight.w600, 
    color: AppColors.lightPrimary
  );
  
  static const TextStyle lightBody = TextStyle(
    fontFamily: 'Roboto', 
    fontSize: 16, 
    color: AppColors.lightPrimary
  );
  
  static const TextStyle lightCaption = TextStyle(
    fontFamily: 'Roboto', 
    fontSize: 12, 
    color: AppColors.lightPrimary
  );
  
  static const TextStyle lightButton = TextStyle(
    fontFamily: 'Roboto', 
    fontSize: 16, 
    fontWeight: FontWeight.w600, 
    color: AppColors.lightOnPrimary
  );

  // Dark theme text styles
  static const TextStyle darkHeadline = TextStyle(
    fontFamily: 'Roboto', 
    fontSize: 24, 
    fontWeight: FontWeight.bold, 
    color: AppColors.darkPrimary
  );
  
  static const TextStyle darkSubheading = TextStyle(
    fontFamily: 'Roboto', 
    fontSize: 20, 
    fontWeight: FontWeight.w600, 
    color: AppColors.darkSecondary
  );
  
  static const TextStyle darkBody = TextStyle(
    fontFamily: 'Roboto', 
    fontSize: 16, 
    color: AppColors.darkOnBackground
  );
  
  static const TextStyle darkCaption = TextStyle(
    fontFamily: 'Roboto', 
    fontSize: 12, 
    color: AppColors.darkOnSurface
  );
  
  static const TextStyle darkButton = TextStyle(
    fontFamily: 'Roboto', 
    fontSize: 16, 
    fontWeight: FontWeight.w600, 
    color: AppColors.darkOnPrimary
  );

  // Error text styles
  static const TextStyle errorText = TextStyle(
    fontFamily: 'Roboto', 
    fontSize: 14, 
    color: AppColors.error,
    fontWeight: FontWeight.w500
  );

  // Success text styles
  static const TextStyle successText = TextStyle(
    fontFamily: 'Roboto', 
    fontSize: 14, 
    color: AppColors.success,
    fontWeight: FontWeight.w500
  );

  // Warning text styles
  static const TextStyle warningText = TextStyle(
    fontFamily: 'Roboto', 
    fontSize: 14, 
    color: AppColors.warning,
    fontWeight: FontWeight.w500
  );

  // Info text styles
  static const TextStyle infoText = TextStyle(
    fontFamily: 'Roboto', 
    fontSize: 14, 
    color: AppColors.info,
    fontWeight: FontWeight.w500
  );

  // Link text styles
  static const TextStyle lightLink = TextStyle(
    fontFamily: 'Roboto', 
    fontSize: 16, 
    color: AppColors.lightPrimary,
    decoration: TextDecoration.underline,
    fontWeight: FontWeight.w500
  );

  static const TextStyle darkLink = TextStyle(
    fontFamily: 'Roboto', 
    fontSize: 16, 
    color: AppColors.darkPrimary,
    decoration: TextDecoration.underline,
    fontWeight: FontWeight.w500
  );
}

