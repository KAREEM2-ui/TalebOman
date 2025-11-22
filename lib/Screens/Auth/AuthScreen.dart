import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Widgets/LoginForm.dart';
import 'Widgets/RegistrationScreen.dart';
import '../../Providers/ThemeProvider.dart';
import '../../Providers/AuthTabProvider.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  ThemeProvider? themeProvider;
  bool get isDarkMode => themeProvider?.themeMode == ThemeMode.dark;

  

  @override void initState() {
    
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }


  @override void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    themeProvider = Provider.of<ThemeProvider>(context);

    // pass down the TabController 
    return ChangeNotifierProvider<AuthTabProvider>(
      create: (_) => AuthTabProvider(_tabController),
      child: Scaffold(
        
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0,0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
      
      
      
              // Theme Switcher
              Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      
                      value: isDarkMode, // ✅ Fix: Use isDarkMode
                      onChanged: (value) {
                        // ✅ Fix: Pass the correct boolean value
                        themeProvider?.toggleTheme(value);
                      },
                      thumbColor: Theme.of(context).switchTheme.thumbColor,
                      trackColor: Theme.of(context).switchTheme.trackColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isDarkMode ? "Dark" : "Light", // ✅ Fix: Simplified text
                      style: Theme.of(context).textTheme.headlineMedium,
                      
                    ),
                    const SizedBox(width: 16),
                  ],
              ),
            
            
      
      
              Container(
                height: 150,
                width: 150,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/lan11.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text("Welcome to Scholarship Finder",
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
              ),
      
      
              const SizedBox(height: 20,),
      
             
              // Tab Bar
              Material(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).tabBarTheme.overlayColor?.resolve({}),
                child: TabBar(
                  controller: _tabController,
                  
                  tabs: const [
                    Tab(text: "Login"),
                    Tab(text: "User Registeration"),
                  ],
                ),
              ),
      
              const SizedBox(height: 20,),
      
             Expanded(
      
              child : Consumer<AuthTabProvider>(
                builder: (context, authTabProvider, child) {
                  return TabBarView(
                    controller: _tabController,
                    children:  [
                      Loginform(),
                      RegistrationForm(),
                    ],
                  );
                },
              ),
      
             )
      
      
      
            ],
          ),
        )
      )
      ),
    );
  }
}