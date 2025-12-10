import 'package:flutter/material.dart';
import 'package:projectapp/Providers/RefreshEventProvider.dart';
import 'package:projectapp/Screens/MinistryAdmin/Widgets/ReviewScholarshipsUploaded.dart';
import 'package:projectapp/Screens/MinistryAdmin/Widgets/SuccessfulInsertionWidget.dart';
import 'package:projectapp/Screens/MinistryAdmin/Widgets/UploadScholarshipListWidget.dart';
import 'package:projectapp/utils/Enums/Status.dart';
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
  late Size size;
  late double scale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _flowProvider = Provider.of<UploadingScholarshipFlowProvider>(context, listen: true);
    _refreshProvider = Provider.of<RefreshProvider>(context, listen: false);
    size = MediaQuery.of(context).size;
    scale = (size.width / 400).clamp(0.85, 1.2);
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
      padding: EdgeInsets.fromLTRB(8 * scale, 16 * scale, 8 * scale, 16 * scale),
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
                          radius: 20 * scale,
                          backgroundColor:
                              _flowProvider.currentStep >= index ? Colors.blue : Colors.grey,
                          child: Icon(
                            entry.value['icon'] as IconData,
                            color: Colors.white,
                            size: 20 * scale,
                          ),
                        ),
                        SizedBox(height: 4 * scale),
                      ],
                    ),
                    if (index < stepDetails.length - 1)
                      Container(
                        width: 100 * scale, 
                        height: 2 * scale,
                        color: _flowProvider.currentStep > index ? Colors.blue : Colors.grey,
                        margin: EdgeInsets.only(bottom: 12.0 * scale),
                      ),
                  ],
                )
              ],
            );
          }).toList(),
        ),

        // steps titles
        SizedBox(height: 8 * scale),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: stepDetails.asMap().entries.map((entry) {
            final index = entry.key;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4 * scale),
                child: Text(
                  textAlign: TextAlign.center,
                  entry.value['title'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13 * scale,
                    color: _flowProvider.currentStep >= index ? Colors.blue : Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }).toList(),
        ),

        SizedBox(height: 16 * scale),

        // Current step widget
        Expanded(
          child: stepWidgets[_flowProvider.currentStep],
        ),

        SizedBox(height: 12 * scale),

        // Next button & cancel button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _flowProvider.currentStep > 0 && _flowProvider.currentStep < stepWidgets.length - 1 ? 
            TextButton(
              onPressed: _flowProvider.cancel,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 10 * scale),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 14 * scale),
              ),
            )
            : const SizedBox.shrink(),
          
            
            // last step shows 'Save' 
            _flowProvider.currentStep == stepWidgets.length - 2 ? 
              ElevatedButton.icon(
                iconAlignment: IconAlignment.end,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 12 * scale),
                  iconColor: Colors.white,
                  elevation: 4,
                  backgroundColor: const Color.fromARGB(199, 76, 175, 79),
                  foregroundColor: Colors.white,
                ),
                onPressed: _handleSave,
                icon: Icon(Icons.save, size: 18 * scale),
                label: Text(
                  _flowProvider.uploadStatus == Status.loading ? 'Saving...' : 'Save',
                  style: TextStyle(fontSize: 14 * scale),
                ),
              ) : const SizedBox.shrink(),
          ],
        ),

        ],
      ),
    );
  }
}


