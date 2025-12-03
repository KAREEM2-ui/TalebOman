import 'package:flutter/material.dart';
import 'package:projectapp/Providers/ScholarshipCrudProvider.dart';
import 'package:provider/provider.dart';
import 'ScholarshipCrudScreen.dart';

class ministryHomeScreen extends StatefulWidget {
  const ministryHomeScreen({super.key});

  @override
  State<ministryHomeScreen> createState() => _ministryHomeScreenState();
}

class _ministryHomeScreenState extends State<ministryHomeScreen> {
  int _currentIndex = 0;

  static const List<String> _titles = [
    'Dashboard',
    'Scholarships Management',
    'Checklist Generator',
    'Bulk Import',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children:  [
            // Dashboard
            Center(child: Text('Dashboard - overview and metrics')),
        
            // Scholarships management
            ChangeNotifierProvider(
              create: (_) => ScholarshipCrudProvider(),
              child: ScholarshipCrudScreen(),
            ),
        
            // Checklist generator placeholder
            Center(child: Text('Checklist Generator - create and manage checklists')),
        
            // Bulk import placeholder
            Center(child: Text('Bulk Import - CSV / Excel import tools')),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: theme.disabledColor,
        onTap: (idx) => setState(() => _currentIndex = idx),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            label: 'Scholarships',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rtl_outlined),
            label: 'Checklist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_file_outlined),
            label: 'Bulk Import',
          ),
        ],
      ),
    );
  }
}