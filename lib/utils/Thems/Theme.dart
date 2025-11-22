import 'package:flutter/material.dart';
import 'Colors.dart';
import 'ComponentsTheme.dart';

class Themes {

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    fontFamily: 'Tajawal',
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.lightPrimary, brightness: Brightness.light),
    useMaterial3: true,

    // App Bar
    appBarTheme: lightAppBarTheme,

    // Cards
    cardTheme: lightCardTheme,

    // Buttons
    elevatedButtonTheme: lightElevatedButtonTheme,
    outlinedButtonTheme: lightOutlinedButtonTheme,
    textButtonTheme: lightTextButtonTheme,

    // Input Fields
    inputDecorationTheme: lightInputDecorationTheme,

    // Floating Action Button
    floatingActionButtonTheme: lightFabTheme,

    // Navigation
    bottomNavigationBarTheme: lightBottomNavTheme,
    tabBarTheme: lightTabBarTheme,

    // Interactive Components
    switchTheme: lightSwitchTheme,
    checkboxTheme: lightCheckboxTheme,
    radioTheme: lightRadioTheme,
    sliderTheme: lightSliderTheme,

    // Dialogs and Sheets
    dialogTheme: lightDialogTheme,
    bottomSheetTheme: lightBottomSheetTheme,

    
    // Dividers
    dividerTheme: lightDividerTheme,

    // Text Themes
    textTheme: lightTextTheme,
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    fontFamily: 'Tajawal',
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.darkPrimary, brightness: Brightness.dark),
    useMaterial3: true,
    
    // App Bar
    appBarTheme: darkAppBarTheme,

    // Cards
    cardTheme: darkCardTheme,

    // Buttons
    elevatedButtonTheme: darkElevatedButtonTheme,
    outlinedButtonTheme: darkOutlinedButtonTheme,
    textButtonTheme: darkTextButtonTheme,

    // Input Fields
    inputDecorationTheme: darkInputDecorationTheme,

    // Floating Action Button
    floatingActionButtonTheme: darkFabTheme,

    // Navigation
    bottomNavigationBarTheme: darkBottomNavTheme,
    tabBarTheme: darkTabBarTheme,

    // Interactive Components
    switchTheme: darkSwitchTheme,
    checkboxTheme: darkCheckboxTheme,
    radioTheme: darkRadioTheme,
    sliderTheme: darkSliderTheme,

    // Dialogs and Sheets
    dialogTheme: darkDialogTheme,
    bottomSheetTheme: darkBottomSheetTheme,

    // Dividers
    dividerTheme: darkDividerTheme,

    // Text Themes
    textTheme: darkTextTheme,
  );
}