import 'package:flutter/material.dart';

// ============================================================================
// INPUT DECORATIONS
// ============================================================================

InputDecoration customInputDecoration(
  BuildContext context, {
  String? labelText,
  String? hintText,
  Widget? prefixIcon,
  Widget? suffixIcon,
  bool isError = false,
  bool isFocused = false,
}) {


  ThemeData theme = Theme.of(context);

  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,

    contentPadding: const EdgeInsets.all(20.0),
    
    // Use theme colors
    labelStyle: theme.textTheme.bodyMedium?.copyWith(
      color: isError
          ? theme.colorScheme.error
          : isFocused
              ? theme.primaryColor
              : theme.colorScheme.onSurface.withValues(alpha: 0.6),
    ),

    hintStyle: theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
    ),

    // Background color from theme
    filled: true,
    fillColor: theme.inputDecorationTheme.fillColor,

    // Border styling using theme colors
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: theme.primaryColor,
        width: 2,
      ),
    ),

    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: theme.colorScheme.error,
        width: 2,
      ),
    ),

    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: theme.colorScheme.error,
        width: 2,
      ),
    ),

    

    // Error style
    errorStyle: theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.error,
    ),
  );
}

// Alternative input decoration styles
InputDecoration customInputDecorationRounded(
  BuildContext context, {
  String? labelText,
  String? hintText,
  Widget? prefixIcon,
  Widget? suffixIcon,
}) {


  ThemeData theme = Theme.of(context);

  return customInputDecoration(
    context,
    labelText: labelText,
    hintText: hintText,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
  ).copyWith(
    // Rounded borders
    border: theme.inputDecorationTheme.border,
    enabledBorder: theme.inputDecorationTheme.enabledBorder,
    focusedBorder: theme.inputDecorationTheme.focusedBorder,
    errorBorder: theme.inputDecorationTheme.errorBorder,

    // Padding inside the field
    contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),

    // Makes height more consistent
    isDense: true,
  );
}




// ============================================================================
// CONTAINER DECORATIONS
// ============================================================================

BoxDecoration customCardDecoration(BuildContext context, {
  double borderRadius = 12,
  double elevation = 4,
  Color? backgroundColor,
}) {
  ThemeData theme = Theme.of(context);

  return BoxDecoration(
    color: backgroundColor ?? Theme.of(context).cardColor,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: [
      BoxShadow(
        color: theme.shadowColor.withValues(alpha: 0.1),
        blurRadius: elevation * 2,
        offset: Offset(0, elevation / 2),
      ),
    ],
  );
}

BoxDecoration customContainerDecoration(
  BuildContext context, {
  double borderRadius = 8,
  Color? backgroundColor,
  Color? borderColor,
  double borderWidth = 1,
  String shadow = "sm", // "none", "sm", "md", "lg" (like Tailwind)
}) {
  ThemeData theme = Theme.of(context);
  List<BoxShadow>? boxShadows;
  switch (shadow) {
    case "sm": // shadow-sm
      boxShadows = [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          offset: const Offset(0, 1),
          blurRadius: 2,
          spreadRadius: 0,
        ),
      ];
      break;
    case "md": // shadow-md
      boxShadows = [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          offset: const Offset(0, 4),
          blurRadius: 6,
          spreadRadius: -1,
        ),
      ];
      break;
    case "lg": // shadow-lg
      boxShadows = [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          offset: const Offset(0, 10),
          blurRadius: 15,
          spreadRadius: -3,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          offset: const Offset(0, 4),
          blurRadius: 6,
          spreadRadius: -2,
        ),
      ];
      break;
    default:
      boxShadows = null;
  }

  return BoxDecoration(
    color: backgroundColor ?? theme.scaffoldBackgroundColor,
    borderRadius: BorderRadius.circular(borderRadius),
    border: borderColor != null
        ? Border.all(color: borderColor, width: borderWidth)
        : Border.all(
            color: theme.dividerColor,
            width: borderWidth,
          ),
    boxShadow: boxShadows,
  );
}


// ============================================================================
// BUTTON DECORATIONS
// ============================================================================

BoxDecoration customButtonDecoration(BuildContext context, {
  double borderRadius = 12,
  Color? backgroundColor,
  double elevation = 3,
}) {
  return BoxDecoration(
    color: Theme.of(context).primaryColor,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).shadowColor.withValues(alpha: 0.2),
        blurRadius: elevation * 2,
        offset: Offset(0, elevation),
      ),
    ],
    
  );
}

BoxDecoration customOutlinedButtonDecoration(BuildContext context, {
  double borderRadius = 12,
  Color? borderColor,
  Color? backgroundColor,
  double borderWidth = 2,
}) {
  return BoxDecoration(
    color: backgroundColor ?? Colors.transparent,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: borderColor ?? Theme.of(context).primaryColor,
      width: borderWidth,
    ),
  );
}

// ============================================================================
// STATUS DECORATIONS
// ============================================================================

BoxDecoration customSuccessDecoration(BuildContext context, String s, {
  double borderRadius = 8,
}) {
  return BoxDecoration(
    color: Theme.of(context).brightness == Brightness.light
        ? Colors.green.withValues(alpha: 0.1)
        : Colors.green.withValues(alpha: 0.2),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: Colors.green,
      width: 1,
    ),
  );
}

BoxDecoration customErrorDecoration(BuildContext context, {
  double borderRadius = 8,
}) {
  return BoxDecoration(
    color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: Theme.of(context).colorScheme.error,
      width: 1,
    ),
  );
}

BoxDecoration customWarningDecoration(BuildContext context, {
  double borderRadius = 8,
}) {
  return BoxDecoration(
    color: Colors.orange.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: Colors.orange,
      width: 1,
    ),
  );
}

BoxDecoration customInfoDecoration(BuildContext context, {
  double borderRadius = 8,
}) {
  return BoxDecoration(
    color: Colors.blue.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: Colors.blue,
      width: 1,
    ),
  );
}

// ============================================================================
// DIALOG DECORATIONS
// ============================================================================

BoxDecoration customDialogDecoration(BuildContext context, {
  double borderRadius = 16,
}) {
  return BoxDecoration(
    color: Theme.of(context).dialogTheme.backgroundColor,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).shadowColor.withValues(alpha: 0.3),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ],
  );
}

BoxDecoration customBottomSheetDecoration(BuildContext context) {
  return BoxDecoration(
    color: Theme.of(context).bottomSheetTheme.backgroundColor,
    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).shadowColor.withValues(alpha: 0.2),
        blurRadius: 16,
        offset: const Offset(0, -4),
      ),
    ],
  );
}

// ============================================================================
// TEXT STYLES THAT FOLLOW THEME
// ============================================================================

TextStyle customHeadlineStyle(BuildContext context) {
  return Theme.of(context).textTheme.headlineMedium?.copyWith(
    fontWeight: FontWeight.bold,
  ) ?? const TextStyle();
}

TextStyle customSubtitleStyle(BuildContext context) {
  return Theme.of(context).textTheme.titleMedium?.copyWith(
    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
  ) ?? const TextStyle();
}

TextStyle customBodyStyle(BuildContext context) {
  return Theme.of(context).textTheme.bodyMedium ?? const TextStyle();
}

TextStyle customCaptionStyle(BuildContext context) {
  return Theme.of(context).textTheme.bodySmall?.copyWith(
    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
  ) ?? const TextStyle();
}

TextStyle customLinkStyle(BuildContext context) {
  return Theme.of(context).textTheme.bodyMedium?.copyWith(
    color: Theme.of(context).primaryColor,
    decoration: TextDecoration.underline,
    fontWeight: FontWeight.w500,
  ) ?? const TextStyle();
}
