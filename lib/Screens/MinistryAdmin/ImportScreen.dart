import 'package:flutter/material.dart';
import 'package:projectapp/Providers/RefreshEventProvider.dart';
import 'package:projectapp/Screens/MinistryAdmin/Widgets/ReviewScholarshipsUploaded.dart';
import 'package:projectapp/Screens/MinistryAdmin/Widgets/SuccessfulInsertionWidget.dart';
import 'package:projectapp/Screens/MinistryAdmin/Widgets/UploadScholarshipListWidget.dart';
import 'package:provider/provider.dart';
import '../../Providers/UploadingScholarshipFlowProvider.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {



  late UploadingScholarshipFlowProvider _flowProvider;
  late RefreshProvider _refreshProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _flowProvider = Provider.of<UploadingScholarshipFlowProvider>(context, listen: true);
    _refreshProvider = Provider.of<RefreshProvider>(context, listen: false);
  }


  List<Widget> stepWidgets = const [
    ScholarshipExcelUploadWidget(), // UploadExcel
    ReviewWidget(), // Review
    SuccessScreen(), // Confirm
  ];

    final stepDetails = [
    {'title': 'Upload Excel', 'icon': Icons.upload_file},
    {'title': 'Review', 'icon': Icons.rate_review},
    {'title': 'Confirm', 'icon': Icons.check_circle},
]; 


  Future<void> _handleSave() async {
    await _flowProvider.saveAll();
    _refreshProvider.refresh(); // Notify other widgets to refresh
  }




  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

        // Step indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: stepDetails.asMap().entries.map((entry) {
            final index = entry.key;
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor:
                              _flowProvider.currentStep >= index ? Colors.blue : Colors.grey,
                          child: Icon(
                            entry.value['icon'] as IconData,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                    if (index < stepDetails.length - 1)
                      Container(
                        width: 120, 
                        height: 2,
                        color: _flowProvider.currentStep > index ? Colors.blue : Colors.grey,
                        margin: const EdgeInsets.only(bottom: 12.0),
                      ),
                  ],
                )
              ],
            );
          }).toList(),
        ),

        // steps titles — 100% untouched
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: stepDetails.asMap().entries.map((entry) {
            final index = entry.key;
            return Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 43.0),
              child: Text(
                textAlign: TextAlign.center,
                entry.value['title'] as String,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _flowProvider.currentStep >= index ? Colors.blue : Colors.grey,
                ),
              ),
            );
          }).toList(),
        ),







          const SizedBox(height: 3),

          // Current step widget
          Expanded(
            child: stepWidgets[_flowProvider.currentStep],
          ),





          // Next button & cancel button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _flowProvider.currentStep > 0 && _flowProvider.currentStep < stepWidgets.length -1 ? 
              TextButton(
                onPressed: _flowProvider.cancel,
                child: const Text('Cancel'),
              )
              : SizedBox.shrink(),
            
              
              // last step shows 'Save' 
              _flowProvider.currentStep == stepWidgets.length - 2 ? 
                ElevatedButton.icon(
                  
                  iconAlignment: IconAlignment.end,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    iconColor: Colors.white,
                    elevation: 4,
                    backgroundColor: const Color.fromARGB(199, 76, 175, 79),
                    foregroundColor: Colors.white
                  ),
                  onPressed: _handleSave,
                  icon: Icon(Icons.save),
                  label: const Text('Save'),
                ) : SizedBox.shrink(),
            ],
          ),












        ],
      ),
    );
  }
}


