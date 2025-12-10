import 'package:flutter/material.dart';
import 'package:projectapp/Providers/AuthProvider.dart';
import 'package:projectapp/Providers/DashboardProvider.dart';
import 'package:projectapp/Providers/RefreshEventProvider.dart';
import 'package:projectapp/Providers/ScholarshipCrudProvider.dart';
import 'package:projectapp/Providers/ThemeProvider.dart';
import 'package:projectapp/Providers/UploadingScholarshipFlowProvider.dart';
import 'package:projectapp/Screens/Auth/AuthScreen.dart';
import 'package:projectapp/Screens/MinistryAdmin/ChecklistGeneratorScreen.dart';
import 'package:projectapp/Screens/MinistryAdmin/DashboardScreen.dart';
import 'package:projectapp/Screens/MinistryAdmin/ImportScreen.dart';
import 'package:provider/provider.dart';
import 'ScholarshipCrudScreen.dart';

class ministryHomeScreen extends StatefulWidget {
  const ministryHomeScreen({super.key});

  @override
  State<ministryHomeScreen> createState() => _ministryHomeScreenState();
}

class _ministryHomeScreenState extends State<ministryHomeScreen> {
  int _currentIndex = 0;

  static const List<String> _titles = [
    'Dashboard',
    'Scholarships Management',
    'Checklist Generator',
    'Bulk Import',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    // Responsive scale based on device width (clamped for tablets/phones)
    final scale = (size.width / 400).clamp(0.85, 1.2);

    void handleLogout() {
      authProvider.logout();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => RefreshProvider(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            _titles[_currentIndex],
            style: theme.textTheme.titleLarge,
          ),
          actionsPadding: EdgeInsets.only(right: 8.0 * scale, bottom: 12.0 * scale),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: GestureDetector(
            onTap: handleLogout,
            child: Padding(
             padding: EdgeInsets.all(8.0 * scale),
              child: Icon(
                Icons.logout_outlined,
                color: theme.iconTheme.color,
               size: 28 * scale,
              ),
            ),
          ),
          actions: [
            Padding(
             padding: EdgeInsets.only(right: 16.0 * scale),
              child: Container(
               padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 8 * scale),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20 * scale),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withValues(alpha: 0.1),
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
                      activeTrackColor: theme.switchTheme.trackColor!.resolve({}),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: IndexedStack(
            index: _currentIndex,
            children: [
              // Dashboard
              ChangeNotifierProvider(
                create: (_) => DashboardProvider(),
                child: const DashboardScreen(),
              ),

              // Scholarships management
              ChangeNotifierProvider(
                create: (_) => ScholarshipCrudProvider(),
                child: ScholarshipCrudScreen(),
              ),

              // Checklist generator placeholder
              const ChecklistGeneratorScreen(),

              // Bulk import placeholder
              ChangeNotifierProvider(
                create: (_) => UploadingScholarshipFlowProvider(),
                child: const ImportScreen(),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
         iconSize: 32 * scale,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.colorScheme.onSurface.withValues(alpha: 0.3),
         selectedLabelStyle: theme.textTheme.bodySmall?.copyWith(fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * scale),
         unselectedLabelStyle: theme.textTheme.bodySmall?.copyWith(fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * scale),
          onTap: (idx) => setState(() => _currentIndex = idx),
          items: const [
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.dashboard),
              icon: Icon(Icons.dashboard_outlined),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.school),
              icon: Icon(Icons.school_outlined),
              label: 'Scholarships',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.checklist_rtl),
              icon: Icon(Icons.checklist_rtl_outlined),
              label: 'Checklist',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.upload_file),
              icon: Icon(Icons.upload_file_outlined),
              label: 'Bulk Import',
            ),
          ],
        ),
      ),
    );
  }
}