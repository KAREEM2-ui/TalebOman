import 'package:flutter/material.dart';
import 'package:projectapp/Screens/MinistryAdmin/Widgets/PopularScholarshipsChart.dart';
import 'package:projectapp/Screens/MinistryAdmin/Widgets/SummaryWidget.dart';


class DashboardScreen extends StatelessWidget {

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    
    final theme = Theme.of(context);



    return  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
          
             
              PopularScholarshipsWidget(),
        
        
              const SizedBox(height: 16),
        
        
            
              SummaryWidget()
        
        
          
            ],
          
          ),
        ),
      );
      
    

  }
}