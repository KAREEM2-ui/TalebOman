import 'package:flutter/material.dart';
import 'package:projectapp/Providers/AuthProvider.dart';
import 'package:projectapp/Providers/MainNavigationProvider.dart';
import 'package:projectapp/Screens/Auth/AuthScreen.dart';
import 'package:projectapp/Screens/User/MatchesScreen.dart';
import 'package:projectapp/Screens/User/ProfileDetails.dart';
import 'package:projectapp/utils/Thems/Widgetsdecorations.dart';
import 'package:provider/provider.dart';
import '../../Providers/userprofileProvider.dart';
import '../../Providers/ThemeProvider.dart';
import '../../utils/Enums/Status.dart';

class userHomeScreen extends StatefulWidget {
  const userHomeScreen({super.key});

  @override
  State<userHomeScreen> createState() => _userHomeScreenState();
}

class _userHomeScreenState extends State<userHomeScreen> {
  bool _showBottomBar = true;


  @override
  Widget build(BuildContext context) {
    AuthenticationProvider authProvider = Provider.of<AuthenticationProvider>(context);
    UserProfileProvider userProfileProvider = Provider.of<UserProfileProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    

    // loading User Profile
    if (userProfileProvider.status == Status.loading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: customCardDecoration(context, elevation: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.school,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Loading Profile...",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Preparing your personalized experience",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    void _handleLogout() {
      authProvider.logout();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    }

    // Main Navigation Provider to manage bottom Navigation
    return ChangeNotifierProvider<MainNavigationProvider>(
      create: (BuildContext context) => MainNavigationProvider(),
      builder: (context, child) {
      var Navigator = Provider.of<MainNavigationProvider>(context);

      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      
        // animated bottom nav: slides down when hidden
        bottomNavigationBar: AnimatedSlide(
          offset: _showBottomBar ? Offset.zero : const Offset(0, 1),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: SizedBox(
            height: kBottomNavigationBarHeight + 5,
            child: BottomNavigationBar(
              currentIndex: Navigator.currentPageIdx,
              onTap: (index) => Navigator.updateIndex(index),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.manage_accounts_sharp,
                    color: Theme.of(context).primaryColor,
                  ),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.format_list_numbered_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                  label: 'Mathches',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.notifications,
                    color: Theme.of(context).primaryColor,
                  ),
                  label: 'Alerts',
                ),
              ],
            ),
          ),
        ),
      
        // AppBar
        appBar: AppBar(
          title: Text(
            'User Home',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: GestureDetector(
            onTap: _handleLogout,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.logout_outlined,
                color: Theme.of(context).primaryColor,
                size: 28,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: Theme.of(context).primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme(value);
                      },
                      activeThumbColor: Theme.of(context).switchTheme.thumbColor!.resolve({}),
                      activeTrackColor: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      
        body: SafeArea(
          child: IndexedStack(
                index: Navigator.currentPageIdx,
                children: const [
                  ProfileDetails(),
                  MatchesPage(),
                  Text("Alerts Screen"),
                ],
              ),
      )
      );
      }
    );
  }
}
  