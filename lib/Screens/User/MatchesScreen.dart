import 'package:flutter/material.dart';
import 'package:projectapp/Providers/MainNavigationProvider.dart';
import 'package:projectapp/Providers/MathesListProvider.dart';
import 'package:projectapp/Providers/userprofileProvider.dart';
import 'package:projectapp/Screens/User/matchesList.dart';
import 'package:projectapp/utils/Thems/Widgetsdecorations.dart';
import 'package:provider/provider.dart';

class MatchesPage extends StatelessWidget {
  const MatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final scale = (size.width / 400).clamp(0.85, 1.2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.0 * scale, top: 30.0 * scale),
          child: Text(
            "Welcome Back, ${userProfileProvider.userProfile?.fullName ?? 'Guest'} 👋",
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: (theme.textTheme.headlineLarge?.fontSize ?? 28) * scale,
            ),
          ),
        ),
        SizedBox(height: 16 * scale),
      
        // This is the CORRECT way to conditionally show different widgets
        if (userProfileProvider.userProfile == null)
          _buildUsernotRegistered(context, scale)
        else
          ChangeNotifierProvider(
            create: (_) => MatchesListProvider(userProfileProvider.userProfile!, userProfileProvider.didUpdated),
            child: Expanded(child: const MatchedList()),
          ),
      ],
    );
  }
}

Widget _buildUsernotRegistered(BuildContext context, double scale) {
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;
  final mainNavigatorProvider = Provider.of<MainNavigationProvider>(context, listen: false);

  return Center(
    child: Container(
      padding: EdgeInsets.all(32 * scale),
      decoration: customCardDecoration(context, elevation: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120 * scale,
            height: 120 * scale,
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_add,
              size: 60 * scale,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 24 * scale),
          Text(
            "No profile found.\nPlease complete your profile.",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: (theme.textTheme.titleLarge?.fontSize ?? 20) * scale,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8 * scale),
          Text(
            "Help us find the perfect scholarships for you",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * scale,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32 * scale),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.primaryColor,
                  theme.primaryColor.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(25 * scale),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 15 * scale,
                  offset: Offset(0, 8 * scale),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20 * scale, vertical: 14 * scale),
                backgroundColor: theme.cardColor.withValues(alpha: 0.7),
                elevation: 0,
                shadowColor: isDarkMode ? Colors.black12 : Colors.black26,
                side: BorderSide(color: isDarkMode ? Colors.white24 : Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25 * scale),
                ),
              ),
              onPressed: () {
                mainNavigatorProvider.updateIndex(EnPages.profile.index);
              },
              icon: Icon(
                Icons.manage_accounts_sharp,
                color: Colors.white,
                size: 20 * scale,
              ),
              label: Text(
                "Fill Profile Details",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: (theme.textTheme.labelLarge?.fontSize ?? 14) * scale,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}