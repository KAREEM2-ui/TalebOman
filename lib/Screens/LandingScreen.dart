import 'package:flutter/material.dart';


class Landingscreen extends StatefulWidget
{
  const Landingscreen({super.key});

  
  @override
  State<StatefulWidget> createState() {
    return _LandingscreenState();
  }
}


class _LandingscreenState extends State<Landingscreen>
    with SingleTickerProviderStateMixin
{

  late AnimationController _animationController;
  late Animation<double> _animation;


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animationController.repeat();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/lan10.jpg",
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.3,
            fit: BoxFit.cover,
            ),

            const SizedBox(height: 5,),

            FadeTransition(
              opacity: _animation,
              child: Text("Scholarship Finder",
              style: Theme.of(context).textTheme.headlineMedium,
            )
            )
          ],

        )
      ),
    );
  }
}
