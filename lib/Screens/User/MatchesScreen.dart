import 'package:flutter/material.dart';
import 'package:projectapp/Providers/MainNavigationProvider.dart';
import 'package:projectapp/Providers/MathesListProvider.dart';
import 'package:projectapp/Providers/userprofileProvider.dart';
import 'package:projectapp/Screens/User/matchesList.dart';
import 'package:projectapp/utils/Thems/Widgetsdecorations.dart';
import 'package:provider/provider.dart';

class MatchesPage extends StatelessWidget {
  const MatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    var userProfileProvider = Provider.of<UserProfileProvider>(context);
    var theme = Theme.of(context);

   return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
    Padding(
      padding: const EdgeInsets.only(left: 12.0,top: 30.0),
      child: Text(
        "Welcome Back, ${userProfileProvider.userProfile?.fullName ?? 'Guest'} 👋",
        style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold ),
      ),
    ),
    const SizedBox(height: 16),
   
    // This is the CORRECT way to conditionally show different widgets
    if (userProfileProvider.userProfile == null)
      _buildUsernotRegistered(context)
    else
      ChangeNotifierProvider(
        create: (_) => MatchesListProvider(userProfileProvider.userProfile!,userProfileProvider.didUpdated),
        child: Expanded(child: const MatchedList()),
      ),
     ],
   );
    
  }
}




Widget _buildUsernotRegistered(BuildContext context) {

  var theme = Theme.of(context);
  var MainNavigatorProvider = Provider.of<MainNavigationProvider>(context,listen: false);


  return Center(
    child: Container(
      padding: const EdgeInsets.all(32),
      decoration: customCardDecoration(context, elevation: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_add,
              size: 60,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No profile found.\nPlease complete your profile.",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Help us find the perfect scholarships for you",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.primaryColor,
                  theme.primaryColor.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                MainNavigatorProvider.updateIndex(EnPages.profile.index);
              },
              icon: const Icon(
                Icons.manage_accounts_sharp,
                color: Colors.white,
              ),
              label: Text(
                "Fill Profile Details",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}