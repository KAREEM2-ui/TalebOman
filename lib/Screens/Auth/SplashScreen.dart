import 'package:flutter/material.dart';
import 'package:projectapp/Screens/Auth/AuthScreen.dart';
import '../../utils/Thems/Widgetsdecorations.dart';
import './helpers/userDirector.dart';
import '../../Providers/AuthProvider.dart';
import 'package:provider/provider.dart';
import '../../utils/Enums/Status.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late AuthenticationProvider authProvider;



  @override 
  void didChangeDependencies() {
    super.didChangeDependencies();
    authProvider = Provider.of<AuthenticationProvider>(context);
  }


  void applyNavigation(BuildContext context)
  {
    
    Timer(const Duration(milliseconds: 2000), () {
     
      if(authProvider.isLoggedIn)
      {
        // navigate to user specific screen
        directUserBasedOnRole(context);
      }
      else
      {
        // navigate to auth screen
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => const AuthScreen(),
        ));
      }

    });
  }

  @override
  Widget build(BuildContext context) {

    
    // if loaded , start navigating
    if(authProvider.loginStatus != Status.loading)
      {
        applyNavigation(context);
      }


      
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

   
    return Scaffold(
        body: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.primaryColor.withValues(alpha: 0.95),
                  theme.colorScheme.surface,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
          
                      /// LOGO WITH SAFE BOUNCE ANIMATION
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 1200),
                        curve: Curves.easeOutBack,
                        builder: (context, value, child) {
                          final safeOpacity = value.clamp(0.0, 1.0);
                          final safeScale = 0.8 + 0.2 * value; // subtle scale
                          return Transform.scale(
                            scale: safeScale,
                            child: Opacity(
                              opacity: safeOpacity,
                              child: child,
                            ),
                          );
                        },
                        child: SizedBox(
                          height: size.height * 0.12,
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
          
                      const SizedBox(height: 28),
          
                      /// APP NAME
                      Text(
                        'Scholarship Finder',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
          
                      const SizedBox(height: 10),
          
                      /// TAGLINE
                      Text(
                        'Your Path to Opportunity Starts Here',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.primary.withValues(alpha: 0.85),
                        ),
                        textAlign: TextAlign.center,
                      ),
          
                      const SizedBox(height: 20),
          
                      /// STATUS CARD
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                        decoration: customCardDecoration(context, elevation: 10).copyWith(
                          color: theme.cardColor,
                          boxShadow: [
                            BoxShadow(
                              color: theme.brightness == Brightness.dark
                                  ? Colors.black.withValues(alpha: 0.3)
                                  : Colors.grey.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
          
                            /// LOADER / STATUS ICON
                            if (authProvider.loginStatus == Status.loading)
                              SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation(theme.primaryColor),
                                ),
                              )
                            else
                              const Icon(
                                Icons.verified_rounded,
                                color: Colors.green,
                                size: 28,
                              ),
          
                            const SizedBox(width: 14),
          
                            /// STATUS TEXT
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  authProvider.loginStatus == Status.loading
                                      ? "Preparing your experience"
                                      : "User Logged In Successfully",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  authProvider.loginStatus == Status.loading
                                      ? "Please wait..."
                                      : "Redirecting user...",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
          
                      const SizedBox(height: 136),
          
                      /// FOOTER
                      Text(
                        'v1.0 • Built with Flutter & Firebase\n© 2025 Abdulkarim',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );


   
  }
}

