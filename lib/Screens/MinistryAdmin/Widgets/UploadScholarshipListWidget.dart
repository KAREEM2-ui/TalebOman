import 'dart:io';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Providers/UploadingScholarshipFlowProvider.dart';
import '../../../utils/Enums/Status.dart';

class ScholarshipExcelUploadWidget extends StatefulWidget {
  const ScholarshipExcelUploadWidget({super.key});

  @override
  State<ScholarshipExcelUploadWidget> createState() => _ScholarshipExcelUploadWidgetState();
}

class _ScholarshipExcelUploadWidgetState extends State<ScholarshipExcelUploadWidget> {


  late UploadingScholarshipFlowProvider _uploadingScholarshipFlowProvider;
  late ThemeData theme;
  late bool isDarkMode;
  late double scale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _uploadingScholarshipFlowProvider = Provider.of<UploadingScholarshipFlowProvider>(context, listen: true);
    theme = Theme.of(context);
    isDarkMode = theme.brightness == Brightness.dark;
    scale = (MediaQuery.of(context).size.width / 400).clamp(0.85, 1.2);
  }


  



  Future<void> _handleUploadFile(BuildContext context) async
  {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    // if not selected 
    if(result == null || result.files.single.path == null)
    {
      return;
    }

    
    File file = File(result.files.single.path!);
    await _uploadingScholarshipFlowProvider.upload(file);

    // if error occurred, show snackbar
    if(_uploadingScholarshipFlowProvider.uploadStatus == Status.error)
    {
      final snackBar = SnackBar(
        content: Text(
          'Error: ${_uploadingScholarshipFlowProvider.errorMessage}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );
      if(context.mounted)
      {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }


  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(8.0 * scale),
      child: Column(
        children: [
          // Main Card
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16 * scale),
              side: BorderSide(
                color: theme.dividerColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0 * scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10 * scale),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12 * scale),
                        ),
                        child: Icon(
                          Icons.upload_file_rounded,
                          color: isDarkMode ? theme.primaryColorLight : theme.primaryColorDark,
                          size: 24 * scale,
                        ),
                      ),
                      SizedBox(width: 12 * scale),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upload Scholarships',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: (theme.textTheme.titleLarge?.fontSize ?? 20) * scale,
                              ),
                            ),
                            SizedBox(height: 4 * scale),
                            Text(
                              'Import scholarships from Excel file',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                                fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * scale,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16 * scale),
                  
                  Divider(color: theme.dividerColor.withOpacity(0.2)),
                  
                  SizedBox(height: 16 * scale),

                  // Instructions
                  _buildInstructionSection(
                    theme,
                    'Required Format',
                  ),
                  
                  SizedBox(height: 8 * scale),
                  
                  // Column names in a clean box
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12 * scale),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12 * scale),
                      border: Border.all(
                        color: theme.primaryColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Title | university | country | type | coverage | minCGPA | minIelts | deadline | fieldsOfStudy',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: (theme.textTheme.bodySmall?.fontSize ?? 11) * scale,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(height: 12 * scale),

                  // Example section
                  _buildInstructionSection(
                    theme,
                    'Example Row'
                  ),
                  
                  SizedBox(height: 8 * scale),
                  
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12 * scale),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12 * scale),
                      border: Border.all(
                        color: theme.dividerColor.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      '"Global Scholarship","Oxford University","UK","Fully Funded","Tuition,Living","3.7","7.0","2025-01-15","Medicine,Law"',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        height: 1.5,
                        fontSize: (theme.textTheme.bodySmall?.fontSize ?? 10) * scale,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(height: 12 * scale),

                  // Important notes
                  Container(
                    padding: EdgeInsets.all(12 * scale),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12 * scale),
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb_outline_rounded,
                          color: Colors.orange.shade700,
                          size: 20 * scale,
                        ),
                        SizedBox(width: 10 * scale),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Important Tips',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade700,
                                  fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) * scale,
                                ),
                              ),
                              SizedBox(height: 6 * scale),
                              Text(
                                '• Use commas to separate multiple values\n'
                                '• All columns are mandatory\n'
                                '• Date format: YYYY-MM-DD',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  height: 1.6,
                                  fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * scale,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16 * scale),

                  // Upload Button
                  SizedBox(
                    width: double.infinity,
                    height: 48 * scale,
                    child: ElevatedButton.icon(
                      onPressed: _uploadingScholarshipFlowProvider.uploadStatus == Status.loading
                          ? null
                          : () => _handleUploadFile(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12 * scale),
                        ),
                        disabledBackgroundColor: theme.disabledColor,
                        padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 12 * scale),
                      ),
                      icon: _uploadingScholarshipFlowProvider.uploadStatus == Status.loading
                          ? SizedBox(
                              width: 20 * scale,
                              height: 20 * scale,
                              child: CircularProgressIndicator(
                                strokeWidth: 2 * scale,
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Icon(Icons.cloud_upload_rounded, size: 20 * scale),
                      label: Text(
                        _uploadingScholarshipFlowProvider.uploadStatus == Status.loading
                            ? 'Uploading...'
                            : 'Choose Excel File',
                        style: TextStyle(
                          fontSize: 15 * scale,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  
                  
                ],
              ),
            ),
          ),


          
        ],
      ),
    );
  }

  Widget _buildInstructionSection(ThemeData theme, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: (theme.textTheme.titleMedium?.fontSize ?? 16) * scale,
          ),
        ),
        
      ],
    );
  }
}