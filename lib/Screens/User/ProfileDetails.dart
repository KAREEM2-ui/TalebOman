import 'package:flutter/material.dart';
import 'package:projectapp/Models/UserProfile.dart';
import '../../utils/Thems/Widgetsdecorations.dart';
import '../../Providers/userprofileProvider.dart';
import 'package:provider/provider.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _fullNameController;
  late TextEditingController _cgpaController;
  late TextEditingController _ieltsScoreController;

  late UserProfileProvider _userProfileProvider;
  late Userprofile _userProfile;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _cgpaController = TextEditingController();
    _ieltsScoreController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
      _userProfile = _userProfileProvider.userProfile?.copy() ?? Userprofile.newUserProfile();

      _fullNameController.text = _userProfile.fullName ?? '';
      _cgpaController.text = (_userProfile.cgpa ?? 0.0).toString();
      _ieltsScoreController.text = (_userProfile.ieltsScore ?? 0.0).toString();
      
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _cgpaController.dispose();
    _ieltsScoreController.dispose();
    super.dispose();
  }

  void _handleProfileSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      _userProfile.fullName = _fullNameController.text.trim();
      _userProfile.cgpa = double.tryParse(_cgpaController.text.trim()) ?? 0.0;
      _userProfile.ieltsScore = double.tryParse(_ieltsScoreController.text.trim()) ?? 0.0;
      
      await _userProfileProvider.updateUserProfile(_userProfile);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profile updated successfully',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error updating profile: ${e.toString()}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final scale = (size.width / 400).clamp(0.85, 1.2);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile Details ${_userProfile.fullName ?? 'User'}',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: (theme.textTheme.titleLarge?.fontSize ?? 20) * scale,
            color: theme.colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 16 * scale),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Card
                Container(
                  padding: EdgeInsets.all(20 * scale),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary.withValues(alpha: 0.1),
                        theme.colorScheme.primary.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20 * scale),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withValues(alpha: 0.1),
                        blurRadius: 20 * scale,
                        offset: Offset(0, 10 * scale),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person,
                        size: 60 * scale,
                        color: theme.colorScheme.primary,
                      ),
                      SizedBox(height: 16 * scale),
                      Text(
                        'Complete Your Profile',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: (theme.textTheme.headlineMedium?.fontSize ?? 24) * scale,
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8 * scale),
                      Text(
                        'Help us find the best scholarships for you',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * scale,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32 * scale),

                // Personal Information Section
                _buildSectionTitle('Personal Information', scale, theme),
                SizedBox(height: 16 * scale),

                // Full Name
                TextFormField(
                  controller: _fullNameController,
                  decoration: customInputDecoration(
                    context,
                    labelText: 'Full Name *',
                    hintText: 'Enter your full name',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: theme.colorScheme.primary,
                      size: 20 * scale,
                    ),
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * scale,
                    color: theme.colorScheme.onSurface,
                  ),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your full name";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20 * scale),

                // Field of Interest Dropdown
                DropdownButtonFormField<String>(
                  value: _userProfile.fieldOfInterest,
                  decoration: customInputDecoration(
                    context,
                    labelText: 'Field of Interest *',
                    hintText: 'Select your field of interest',
                    prefixIcon: Icon(
                      Icons.people_outline,
                      color: theme.colorScheme.primary,
                      size: 20 * scale,
                    ),
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * scale,
                    color: theme.colorScheme.onSurface,
                  ),
                  isExpanded: true,
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(
                        'Select Field of Interest',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * scale,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    ..._buildDropdownItems(scale, theme),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _userProfile.fieldOfInterest = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Field of Interest is required";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20 * scale),

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
                      size: 20 * scale,
                    ),
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * scale,
                    color: theme.colorScheme.onSurface,
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      final double? cgpa = double.tryParse(value.trim());
                      if (cgpa == null || cgpa <= 0 || cgpa > 4) {
                        return "Invalid CGPA. Please enter a value between 0 and 4.";
                      }
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20 * scale),

                // Language Proficiency Section
                _buildSectionTitle('Language Proficiency', scale, theme),
                SizedBox(height: 16 * scale),

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
                      size: 20 * scale,
                    ),
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * scale,
                    color: theme.colorScheme.onSurface,
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      final double? ielts = double.tryParse(value.trim());
                      if (ielts == null || ielts < 0 || ielts > 9) {
                        return "Invalid IELTS score.\n Please enter a value between 0 and 9.";
                      }
                    }
                    return null;
                  },
                ),

                SizedBox(height: 48 * scale),

                // Save Button
                Container(
                  height: 56 * scale,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(28 * scale),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 15 * scale,
                        offset: Offset(0, 8 * scale),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    style: theme.elevatedButtonTheme.style?.copyWith(
                      padding: MaterialStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 20 * scale, vertical: 12 * scale),
                      ),
                    ),
                    onPressed: _handleProfileSave,
                    icon: Icon(
                      Icons.save,
                      color: Colors.white,
                      size: 20 * scale,
                    ),
                    label: Text(
                      'Save Profile',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16 * scale,
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

  List<DropdownMenuItem<String>> _buildDropdownItems(double scale, ThemeData theme) {
    final items = ['STEM', 'Health', 'Business', 'Arts', 'Social', 'Law'];
    final labels = [
      'STEM',
      'Health & Medicine',
      'Business & Economics',
      'Arts & Humanities',
      'Social Sciences',
      'Law & Public Policy',
    ];

    return List.generate(
      items.length,
      (index) => DropdownMenuItem(
        value: items[index],
        child: Text(
          labels[index],
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * scale,
            color: theme.colorScheme.onSurface,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, double scale, ThemeData theme) {
    return Row(
      children: [
        Container(
          width: 4 * scale,
          height: 24 * scale,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2 * scale),
          ),
        ),
        SizedBox(width: 12 * scale),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
              fontSize: (theme.textTheme.titleLarge?.fontSize ?? 20) * scale,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}