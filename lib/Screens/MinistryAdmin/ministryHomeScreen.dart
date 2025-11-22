import 'package:flutter/material.dart';

class ministryHomeScreen extends StatelessWidget {
  const ministryHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ministry Home'),
      ),
      body: const Center(
        child: Text('Welcome to the Ministry Home Screen!'),
      ),
    );
  }
}