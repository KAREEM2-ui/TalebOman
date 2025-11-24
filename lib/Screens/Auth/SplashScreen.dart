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

   
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated emblem
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 0.8 + 0.2 * value,
                      child: Opacity(opacity: value, child: child),
                    );
                  },
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.primaryColor,
                          theme.primaryColor.withValues(alpha : 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withValues(alpha : 0.18),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Center(
                      // try to show app logo asset, fallback to icon
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 78,
                        height: 78,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) {
                          return Icon(
                            Icons.school,
                            size: 56,
                            color: theme.colorScheme.onPrimary,
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // App title
                Text(
                  'Scholarship Finder',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'Find scholarships tailored for you',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha : 0.7),
                    height: 1.25,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Card with brief info + loader
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: customCardDecoration(context, elevation: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      
                      
                      // Status 
                      SizedBox(
                        width: 28,
                        height: 28,
                        child:
                        
                        // loading
                         authProvider.loginStatus == Status.loading ?
                              CircularProgressIndicator(
                                strokeWidth: 2.6,
                                valueColor: AlwaysStoppedAnimation(theme.primaryColor),
                              )
                              
                         : Text("User Logged In ✅ \n Redirecting User...."),
                      ),


                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Preparing your experience',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Optimizing app performance...',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha : 0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Optional small footer
                Text(
                  'Powered by you • v1.0',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha : 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    
    
   
  }
}

