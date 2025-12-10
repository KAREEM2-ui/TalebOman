import 'package:flutter/material.dart';
import 'package:projectapp/Providers/AuthProvider.dart';
import 'package:projectapp/Providers/MainNavigationProvider.dart';
import 'package:projectapp/Screens/Auth/AuthScreen.dart';
import 'package:projectapp/Screens/User/MatchesScreen.dart';
import 'package:projectapp/Screens/User/ProfileDetails.dart';
import 'package:projectapp/Screens/User/alertsScreen.dart';
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

  late AuthenticationProvider authProvider = Provider.of<AuthenticationProvider>(context);
  late UserProfileProvider userProfileProvider;
  late ThemeProvider themeProvider;
  late Size size;
  late double scale;
  late ThemeData theme;
  late bool isDarkMode;
  late MainNavigationProvider mainNavigator;


  @override void didChangeDependencies() {
    super.didChangeDependencies();
    authProvider = Provider.of<AuthenticationProvider>(context);
    userProfileProvider = Provider.of<UserProfileProvider>(context);
    themeProvider = Provider.of<ThemeProvider>(context);
    isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    size = MediaQuery.of(context).size;
    scale = (size.width / 400).clamp(0.85, 1.2);
    theme = Theme.of(context);
  }
  @override
  Widget build(BuildContext context) {

    // loading User Profile
    if (userProfileProvider.status == Status.loading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: Container(
            padding: EdgeInsets.all(32 * scale),
            decoration: customCardDecoration(context, elevation: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80 * scale,
                  height: 80 * scale,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.school,
                    size: 40 * scale,
                    color: theme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 24 * scale),
                SizedBox(
                  width: 40 * scale,
                  height: 40 * scale,
                  child: CircularProgressIndicator(
                    strokeWidth: 3 * scale,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(height: 20 * scale),
                Text(
                  "Loading Profile...",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: (theme.textTheme.titleLarge?.fontSize ?? 20) * scale,
                  ),
                ),
                SizedBox(height: 8 * scale),
                Text(
                  "Preparing your personalized experience",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * scale,
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
        var mainNavigator = Provider.of<MainNavigationProvider>(context);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
        
          // animated bottom nav: slides down when hidden
          
          bottomNavigationBar: AnimatedSlide(
            offset: _showBottomBar ? Offset.zero : const Offset(0, 1),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: SizedBox(
              height: kBottomNavigationBarHeight + 5,
              child: BottomNavigationBar(
                currentIndex: mainNavigator.currentPageIdx,
                onTap: (int index) {
                            if(index == 2 && userProfileProvider.alertsCount > 0) {
                              userProfileProvider.markAllAlertsAsRead();
                            }

                            mainNavigator.updateIndex(index);
                },

                iconSize: 20 * scale,
                selectedItemColor: theme.colorScheme.primary,
                unselectedItemColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.manage_accounts_sharp,
                    ),
                    label: 'Profile',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.format_list_numbered_rounded,
                    ),
                    label: 'Matches',
                  ),
                  BottomNavigationBarItem(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          Icons.notifications_active_outlined,
                        ),
                        // Red notification badge
                        if (userProfileProvider.userProfile != null &&
                            userProfileProvider.alertsCount > 0)
                          Positioned(
                            right: -12 * scale,
                            top: -12 * scale,
                            child: Container(
                              width: 20 * scale,
                              height: 20 * scale,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withValues(alpha: 0.4),
                                    blurRadius: 8 * scale,
                                    spreadRadius: 2 * scale,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '${userProfileProvider.alertsCount > 9 ? '9+' : userProfileProvider.alertsCount}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9 * scale,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    label: 'Alerts',
                  ),
                ],
                selectedLabelStyle: theme.textTheme.bodySmall?.copyWith(
                  fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * scale,
                ),
                unselectedLabelStyle: theme.textTheme.bodySmall?.copyWith(
                  fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * scale,
                ),
              ),
            ),
          ),
        
          // AppBar
          appBar: AppBar(
            title: Text(
              'User Home',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: (theme.textTheme.headlineMedium?.fontSize ?? 20) * scale,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: GestureDetector(
              onTap: _handleLogout,
              child: Padding(
                padding: EdgeInsets.all(8.0 * scale),
                child: Icon(
                  Icons.logout_outlined,
                  color: theme.iconTheme.color,
                  size: 24 * scale,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 12.0 * scale),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 8 * scale),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(20 * scale),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withValues(alpha: 0.1),
                        blurRadius: 8 * scale,
                        offset: Offset(0, 2 * scale),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: theme.iconTheme.color,
                        size: 18 * scale,
                      ),
                      SizedBox(width: 6 * scale),
                      Switch(
                        value: isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme(value);
                        },
                        activeThumbColor: theme.switchTheme.thumbColor!.resolve({}),
                        activeTrackColor: theme.colorScheme.primary.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          extendBody: true,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            bottom: false,
            child: IndexedStack(
              index: mainNavigator.currentPageIdx,
              children: const [
                ProfileDetails(),
                MatchesPage(),
                AlertsScreen(),
              ],
            ),
          ),
        );
      },
    );
  }
}
