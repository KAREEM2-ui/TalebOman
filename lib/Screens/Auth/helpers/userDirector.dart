import 'package:flutter/material.dart';
import 'package:projectapp/Providers/userprofileProvider.dart';
import 'package:provider/provider.dart';
import '../../../Providers/AuthProvider.dart';
import '../../MinistryAdmin/ministryHomeScreen.dart';
import '../../User/userHomeScreen.dart';





void directUserBasedOnRole(BuildContext context) {
  final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);

  switch (authProvider.userDetails!.role) {
    case 'ministry':
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ministryHomeScreen()),
      );
      break;

    case 'user':
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<UserProfileProvider>(
            create: (context) => UserProfileProvider(authProvider.userDetails!.uid),
            child: userHomeScreen(),
          ),
        ),
      );
      break;

    default:
      break;
  }
}