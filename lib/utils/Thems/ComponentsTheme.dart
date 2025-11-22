import 'package:flutter/material.dart';
import 'Colors.dart';
import 'TextStyles.dart';

// ============================================================================
// LIGHT THEME COMPONENTS
// ============================================================================

final AppBarThemeData lightAppBarTheme = const AppBarThemeData(
  backgroundColor: AppColors.lightPrimary,
  foregroundColor: Colors.white,
  elevation: 0,
  centerTitle: true,
  iconTheme: IconThemeData(color: Colors.white),
  actionsIconTheme: IconThemeData(color: Colors.white),
);

final CardThemeData lightCardTheme = CardThemeData(
  color: AppColors.lightCard,
  shadowColor: AppColors.lightCardShadow,
  elevation: 5,
  margin: const EdgeInsets.all(10),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  
);

final ElevatedButtonThemeData lightElevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.lightPrimary,
    foregroundColor: Colors.white,
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 3,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    
  ),
);

final OutlinedButtonThemeData lightOutlinedButtonTheme = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    foregroundColor: AppColors.lightPrimary,
    side: const BorderSide(color: AppColors.lightPrimary, width: 1.5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  ),
);

final TextButtonThemeData lightTextButtonTheme = TextButtonThemeData(
  style: TextButton.styleFrom(
    foregroundColor: AppColors.lightPrimary,
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
);

final InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
  filled: true,
  fillColor: const Color.fromARGB(255, 255, 255, 255),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Colors.grey, width: 1),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Colors.red, width: 1),
  ),
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
);

final FloatingActionButtonThemeData lightFabTheme = const FloatingActionButtonThemeData(
  backgroundColor: AppColors.lightPrimary,
  foregroundColor: Colors.white,
  elevation: 6,
  shape: CircleBorder(),
);

final BottomNavigationBarThemeData lightBottomNavTheme = const BottomNavigationBarThemeData(
  backgroundColor: AppColors.lightCard,
  selectedItemColor: AppColors.lightPrimary,
  unselectedItemColor: Colors.grey,
  type: BottomNavigationBarType.fixed,
  elevation: 8,
);

final TabBarThemeData lightTabBarTheme = const TabBarThemeData(
  labelColor: AppColors.lightPrimary,
  unselectedLabelColor: Colors.grey,
  indicatorColor: AppColors.lightPrimary,
  labelStyle: TextStyle(fontWeight: FontWeight.w600),
  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
);

final SwitchThemeData lightSwitchTheme = SwitchThemeData(
  thumbColor: WidgetStateProperty.resolveWith<Color>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.lightPrimary;
      }
      return Colors.grey;
    },
  ),
  trackColor: WidgetStateProperty.resolveWith<Color>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.lightPrimary.withValues(alpha: 0.3);
      }
      return Colors.grey.withValues(alpha: 0.3);
    },
  ),
);

final CheckboxThemeData lightCheckboxTheme = CheckboxThemeData(
  fillColor: WidgetStateProperty.resolveWith<Color>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.lightPrimary;
      }
      return Colors.transparent;
    },
  ),
  checkColor: WidgetStateProperty.all(Colors.white),
  side: const BorderSide(color: Colors.grey, width: 1.5),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
);

final RadioThemeData lightRadioTheme = RadioThemeData(
  fillColor: WidgetStateProperty.resolveWith<Color>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.lightPrimary;
      }
      return Colors.grey;
    },
  ),
);


final SliderThemeData lightSliderTheme = const SliderThemeData(
  activeTrackColor: AppColors.lightPrimary,
  inactiveTrackColor: Colors.grey,
  thumbColor: AppColors.lightPrimary,
  overlayColor: Color.fromRGBO(33, 150, 243, 0.12),
);

final DialogThemeData lightDialogTheme = DialogThemeData(
  backgroundColor: AppColors.lightCard,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  elevation: 10,
);

final BottomSheetThemeData lightBottomSheetTheme = const BottomSheetThemeData(
  backgroundColor: AppColors.lightCard,
  elevation: 10,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
);

final DividerThemeData lightDividerTheme = const DividerThemeData(
  color: Colors.grey,
  thickness: 0.5,
  space: 1,
);

final TextTheme lightTextTheme = TextTheme(
  headlineLarge: AppTextStyles.lightHeadline,
  headlineMedium: AppTextStyles.lightSubheading,
  titleLarge: AppTextStyles.lightSubheading, 
  bodyLarge: AppTextStyles.lightBody,
  bodyMedium: AppTextStyles.lightBody,
  bodySmall: AppTextStyles.lightCaption,
  labelLarge: AppTextStyles.lightButton,

);

// ============================================================================
// DARK THEME COMPONENTS
// ============================================================================

final AppBarThemeData darkAppBarTheme = const AppBarThemeData(
  backgroundColor: AppColors.darkPrimary,
  foregroundColor: Colors.white,
  elevation: 0,
  centerTitle: true,
  iconTheme: IconThemeData(color: Colors.white),
  actionsIconTheme: IconThemeData(color: Colors.white),
);

final CardThemeData darkCardTheme = CardThemeData(
  color: AppColors.darkBackground,
  shadowColor: AppColors.darkCardShadow,
  elevation: 5,
  margin: const EdgeInsets.all(10),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
);

final ElevatedButtonThemeData darkElevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.darkPrimary,
    foregroundColor: Colors.white,
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    elevation: 3,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  ),
);

final OutlinedButtonThemeData darkOutlinedButtonTheme = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    foregroundColor: AppColors.darkPrimary,
    side: const BorderSide(color: AppColors.darkPrimary, width: 1.5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  ),
);

final TextButtonThemeData darkTextButtonTheme = TextButtonThemeData(
  style: TextButton.styleFrom(
    foregroundColor: AppColors.darkPrimary,
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
);

final InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
  filled: true,
  fillColor: AppColors.darkBackground,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Colors.grey, width: 1),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Colors.grey, width: 1),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Colors.red, width: 1),
  ),
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
);

final FloatingActionButtonThemeData darkFabTheme = const FloatingActionButtonThemeData(
  backgroundColor: AppColors.darkPrimary,
  foregroundColor: Colors.white,
  elevation: 6,
  shape: CircleBorder(),
);

final BottomNavigationBarThemeData darkBottomNavTheme = const BottomNavigationBarThemeData(
  backgroundColor: AppColors.darkBackground,
  selectedItemColor: AppColors.darkPrimary,
  unselectedItemColor: Colors.grey,
  type: BottomNavigationBarType.fixed,
  elevation: 8,
);

final TabBarThemeData darkTabBarTheme = const TabBarThemeData(
  labelColor: AppColors.darkPrimary,
  unselectedLabelColor: Colors.grey,
  indicatorColor: AppColors.darkPrimary,
  labelStyle: TextStyle(fontWeight: FontWeight.w600),
  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
);

final SwitchThemeData darkSwitchTheme = SwitchThemeData(
  thumbColor: WidgetStateProperty.resolveWith<Color>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.darkPrimary;
      }
      return Colors.grey;
    },
  ),
  trackColor: WidgetStateProperty.resolveWith<Color>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.darkPrimary.withValues(alpha: 0.3);
      }
      return Colors.grey.withValues(alpha: 0.3);
    },
  ),
);

final CheckboxThemeData darkCheckboxTheme = CheckboxThemeData(
  fillColor: WidgetStateProperty.resolveWith<Color>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.darkPrimary;
      }
      return Colors.transparent;
    },
  ),
  checkColor: WidgetStateProperty.all(Colors.white),
  side: const BorderSide(color: Colors.grey, width: 1.5),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
);

final RadioThemeData darkRadioTheme = RadioThemeData(
  fillColor: WidgetStateProperty.resolveWith<Color>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.darkPrimary;
      }
      return Colors.grey;
    },
  ),
);

final SliderThemeData darkSliderTheme = const SliderThemeData(
  activeTrackColor: AppColors.darkPrimary,
  inactiveTrackColor: Colors.grey,
  thumbColor: AppColors.darkPrimary,
  overlayColor: Color.fromRGBO(33, 150, 243, 0.12),
);

final DialogThemeData darkDialogTheme = DialogThemeData(
  backgroundColor: AppColors.darkBackground,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  elevation: 10,
);

final BottomSheetThemeData darkBottomSheetTheme = const BottomSheetThemeData(
  backgroundColor: AppColors.darkBackground,
  elevation: 10,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
);

final DividerThemeData darkDividerTheme = const DividerThemeData(
  color: Colors.grey,
  thickness: 0.5,
  space: 1,
);


final TextTheme darkTextTheme = TextTheme(
  headlineLarge: AppTextStyles.darkHeadline,
  headlineMedium: AppTextStyles.darkSubheading,
  titleLarge: AppTextStyles.darkSubheading,
  bodyLarge: AppTextStyles.darkBody,
  bodyMedium: AppTextStyles.darkBody,
  bodySmall: AppTextStyles.darkCaption,
  labelLarge: AppTextStyles.darkButton,
);





