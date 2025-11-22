import 'package:flutter/material.dart';
import 'package:projectapp/Models/UserProfile.dart';
import '../../utils/Thems/Widgetsdecorations.dart';
import '../../Providers/userprofileProvider.dart';
import 'package:provider/provider.dart';

class ProfileDetails extends StatefulWidget {

  const ProfileDetails({super.key});


  @override
  // ignore: no_logic_in_create_state
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _fullNameController = TextEditingController();
  final _cgpaController = TextEditingController();
  final _ieltsScoreController = TextEditingController();



  late UserProfileProvider _userProfileProvider;
  late Userprofile _userProfile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // if Profile Exist show it , otherwise create new 
    _userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
    _userProfile = _userProfileProvider.userProfile?.copy() ?? Userprofile.newUserProfile();


    // Initialize controllers with existing data if available
    _fullNameController.text = _userProfile.fullName ;
    _cgpaController.text = _userProfile.cgpa.toString() ;
    _ieltsScoreController.text = _userProfile.ieltsScore.toString() ;

  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _cgpaController.dispose();
    _ieltsScoreController.dispose();
    super.dispose();
  }


  void _handleProfileSave() async 
  {
    if(!_formKey.currentState!.validate())
      {
        return;
      }

    // Save profile logic
    try
    {
      _userProfile.fullName = _fullNameController.text.trim();

      _userProfile.cgpa = double.parse(_cgpaController.text.trim());

      _userProfile.ieltsScore = double.parse(_ieltsScoreController.text.trim());

      await _userProfileProvider.updateUserProfile(_userProfile);
     
    }
    catch(e){}
  }

  @override
  Widget build(BuildContext context) {

    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile Details ${_userProfile.fullName}',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary.withValues(alpha: 0.1),
                        theme.colorScheme.primary.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person,
                        size: 60,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Complete Your Profile',
                        style: theme.textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Help us find the best scholarships for you',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
        
                const SizedBox(height: 32),
        
                // Personal Information Section
                _buildSectionTitle('Personal Information'),
                const SizedBox(height: 16),
        
                // Full Name
                TextFormField(
                  controller: _fullNameController,
                  decoration: customInputDecoration(
                    context,
                    labelText: 'Full Name *',
                    hintText: 'Enter your full name',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: theme.colorScheme.primary
                    ),
                  ),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                      if(value == null || value.isEmpty)
                      {
                        return "Please enter your full name";
                      }
                      return null;
                  },
                ),
                       
                const SizedBox(height: 20),
                
                // Field of Interest Dropdown
                DropdownButtonFormField<String>(
                  initialValue: _userProfile.fieldOfInterest,
                  decoration: customInputDecoration(
                    context,
                    labelText: 'Field of Interest *',
                    hintText: 'Select your field of interest',
                    prefixIcon: Icon(
                      Icons.people_outline,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Select Field of Interest')),
                    // STEM
                    DropdownMenuItem(
                      value: 'STEM',
                      child: SizedBox(
                        width: 300,  
                        child: Text(
                          'STEM (Science, Technology, Engineering, Mathematics)',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),

                    // Health & Medicine
                    DropdownMenuItem(value: 'Health', child: Text('Health & Medicine')),

                    // Business & Economics
                    DropdownMenuItem(value: 'Business', child: Text('Business & Economics')),

                    // Arts & Humanities
                    DropdownMenuItem(value: 'Arts', child: Text('Arts & Humanities')),

                    // Social Sciences
                    DropdownMenuItem(value: 'Social', child: Text('Social Sciences')),

                    // Law & Public Policy
                    DropdownMenuItem(value: 'Law', child: Text('Law & Public Policy')),

                  ],
                  onChanged: (value) {
                    setState(() {
                      _userProfile.fieldOfInterest = value;
                    });
                  },
        
                  validator: (value){
                    if(value == null)
                    {
                      return "Field of Interest is required";
                    }
                    return null;
                  },
                ),
        
        
                
        
                const SizedBox(height: 20),
        
                // CGPA
                TextFormField(
                  controller: _cgpaController,
                  decoration: customInputDecoration(
                    context,
                    labelText: 'CGPA',
                    hintText: 'Enter your CGPA (e.g., 3.5)',
                    prefixIcon: Icon(
                      Icons.grade_outlined,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
        
                  validator: (value){
                    if(value != null)
                    {
                      final double? cgpa = double.tryParse(value.trim());
                      if(cgpa == null || cgpa < 0 || cgpa > 4)
                      {
                        return "Invalid CGPA. Please enter a CGPA between 0 and 4.";
                      }
                    }
                    return null;
                  }
                ),
        
                const SizedBox(height: 20),
        
        
                // Language Proficiency Section
                _buildSectionTitle('Language Proficiency'),
                const SizedBox(height: 16),
        
                // IELTS Score
                TextFormField(
                  controller: _ieltsScoreController,
                  decoration: customInputDecoration(
                    context,
                    labelText: 'IELTS Score',
                    hintText: 'Enter your IELTS score (e.g., 7.5)',
                    prefixIcon: Icon(
                      Icons.quiz_outlined,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  validator: (value){
                    if(value != null)
                    {
                      final double? ielts = double.tryParse(value.trim());
                      if(ielts == null || ielts < 0 || ielts > 9)
                      {
                        return "Invalid IELTS score. Please enter a score between 0 and 9.";
                      }
                    }
                    return null;
                  }
                ),
                
                const SizedBox(height: 48),
        
                // Save Button
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    style: theme.elevatedButtonTheme.style,
                    onPressed: () {
                      _handleProfileSave();
                    },
                    icon: const Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Save Profile',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
        
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}