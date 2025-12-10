import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/Thems/Widgetsdecorations.dart';
import '../../../Providers/AuthProvider.dart';
import '../../../Providers/AuthTabProvider.dart';
import '../../../utils/Enums/Status.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Parent TabController
  late TabController parentTabController;
  late AuthenticationProvider _authProvider;

  
  bool _obscurePassword = true;
  
  // Animation controller
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;


  // bottom padding to avoid keyboard overlap
  late MediaQueryData mediaQueryData; 
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _fadeController.forward();


   
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mediaQueryData = MediaQuery.of(context);
    theme = Theme.of(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }




  void _handleRegistration(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }


      try
      {
        await _authProvider.RegisterWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text,
        );


          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 3),
              content: Text('Registration successful! we have sent a verification email to ${_emailController.text.trim()}.'),
              backgroundColor: Colors.green,
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {
                  // Dismiss snackbar
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
          await Future.delayed(const Duration(seconds: 2));

          parentTabController.animateTo(0);
      }
      catch(e)
      {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 4),
            content: Text('Registration failed: ${_authProvider.errorMessage}'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {
                // Dismiss snackbar
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
        return;
      }
      
    

    

  }


   

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthenticationProvider>(context);
    parentTabController = Provider.of<AuthTabProvider>(context).tabController;
    
    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: mediaQueryData.viewInsets.bottom + 12),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: customCardDecoration(context, elevation: 8),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Text(
                    'Create Account',
                    style: customHeadlineStyle(context),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  const Text(
                    'Join us today! Create your account to explore scholarships tailored for you.',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
            
                  // Email Field
                  TextFormField(
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    controller: _emailController,
                    decoration: customInputDecoration(
                      context,
                      labelText: 'Email Address',
                      hintText: 'Enter your email',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Password Field
                  TextFormField(
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    controller: _passwordController,
                    decoration: customInputDecoration(
                      context,
                      labelText: 'Password',
                      hintText: 'Enter a strong password',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
                        return 'Password must contain letters and numbers';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 12),
              
                   // Create Account Button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _handleRegistration(context),
                      style : Theme.of(context).elevatedButtonTheme.style,
                  
                      child: _authProvider.registrationStatus == Status.loading  
                          // loading 
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                  
                            // completed
                            : _authProvider.registrationStatus == Status.completed
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_outline, color: const Color.fromARGB(255, 0, 255, 8),size: 25,weight: 100,applyTextScaling: true,),
                                const SizedBox(width: 8),
                                Text(
                                  'Registered',
                                  style: Theme.of(context).textTheme.labelLarge!.copyWith(color: const Color.fromARGB(255, 0, 255, 8)),
                                  
                                ),
                              ],
                            )
                  
                  
                            // initial
                            : Text(
                              'Create Account',
                              style: Theme.of(context).textTheme.labelLarge
                            ),
                    ),
                  ),
                  
                  
                
                  ],
                  ),
                  
                  
                 
                  
                  
                  
                                
                 
                
              ),
            ),
        ),
        ),
    );
  }
}