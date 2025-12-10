import 'package:flutter/material.dart';
import 'package:projectapp/Screens/Auth/ResetPassword.dart';
import '../../../utils/Thems/Widgetsdecorations.dart';
import 'package:provider/provider.dart';
import 'package:projectapp/Providers/AuthProvider.dart';
import '../../../utils/Enums/Status.dart';
import '../helpers/userDirector.dart';

class Loginform extends StatefulWidget
{
  const Loginform({super.key});

  
  @override
  State<StatefulWidget> createState() {
    return _LoginformState();
  }
}

class _LoginformState extends State<Loginform>
{
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;


  late AuthenticationProvider _authProvider;
  late ThemeData theme;


  @override
  void initState() {
    super.initState();
  }

 

  void _handleLogin(BuildContext context) async
  {
    if(!_formKey.currentState!.validate())
    {
      return;
    }

    try
    {
      await _authProvider.LoginWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );


      await Future.delayed(const Duration(seconds: 1));

      // direct user based on role
      // ignore: use_build_context_synchronously
      directUserBasedOnRole(context);

    }
    catch(e)
    {
     ScaffoldMessenger.of(context).showSnackBar(  
        SnackBar(content: Text('Login failed: ${e.toString()}', style: TextStyle(color: Colors.white),), backgroundColor: Colors.red,)

      );
    }




    
  }


  @override void didChangeDependencies() {
    super.didChangeDependencies();
    _authProvider = Provider.of<AuthenticationProvider>(context);
    theme = Theme.of(context);
  }




  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: bottomInset + 12),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 151, 151, 151).withValues(alpha: 0.05), // lighter shadow
              blurRadius: 2.0, // smaller blur
              offset: const Offset(0, 1), // smaller vertical offset
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
             children: [
               // Header
                   Text(
                     'Log-in',
                     style: customHeadlineStyle(context),
                     textAlign: TextAlign.center,
                 ),

          const SizedBox(height: 20),


          // Email Field
          TextFormField(
            controller: emailController,
            style: TextStyle(color: theme.colorScheme.onSurface),
            decoration: customInputDecoration(context,
              labelText: 'Email',
              hintText: 'Enter your email',
              prefixIcon: Icon(
                    Icons.email,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),    
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),


          const SizedBox(height: 20),

          // Password Field
          TextFormField(
            controller: passwordController,
            textInputAction: TextInputAction.done,
            style: TextStyle(color: theme.colorScheme.onSurface),
            decoration: customInputDecoration(context,
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icon(
                    Icons.lock,
                    color:  theme.colorScheme.primary,
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

             // Create Account Button
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _handleLogin(context),
                  style : Theme.of(context).elevatedButtonTheme.style,

                  child: _authProvider.loginStatus == Status.loading  
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
                        : _authProvider.loginStatus == Status.completed
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, color: const Color.fromARGB(255, 0, 255, 8),size: 25,weight: 100,applyTextScaling: true,),
                            const SizedBox(width: 8),
                            Text(
                              'Login Successful',
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(color: const Color.fromARGB(255, 0, 255, 8)),
                              
                            ),
                          ],
                        )                        
                        
                        // initial
                        : Text(
                          'Login ',
                          style: Theme.of(context).textTheme.labelLarge
                        ),
                ),
              ),


              const SizedBox(height: 10),

              // Forgot Password Button
              TextButton(
                onPressed: () {
                  // Navigate to Reset Password Screen
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const ResetPasswordScreen(),
                  ));
                  
                },
                child: Text(
                  'Forgot Password?',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),


              
         
        ],
    )
    )
    )
    );
  }
}