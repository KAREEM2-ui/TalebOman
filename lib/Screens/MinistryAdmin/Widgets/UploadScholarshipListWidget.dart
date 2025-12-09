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

  @override didChangeDependencies() {
    super.didChangeDependencies();
    _uploadingScholarshipFlowProvider = Provider.of<UploadingScholarshipFlowProvider>(context, listen: true);
    theme = Theme.of(context);
    isDarkMode = theme.brightness == Brightness.dark;
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
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Main Card
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: theme.dividerColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.upload_file_rounded,
                          color: isDarkMode ? theme.primaryColorLight : theme.primaryColorDark,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upload Scholarships',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Import scholarships from Excel file',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Divider(color: theme.dividerColor.withOpacity(0.2)),
                  
                  const SizedBox(height: 24),

                  // Instructions
                  _buildInstructionSection(
                    theme,
                    'Required Format',
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Column names in a clean box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.primaryColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Title | university | country | type | coverage | minCGPA | minIelts | deadline | fieldsOfStudy',
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),


                  // Example section
                  _buildInstructionSection(
                    theme,
                    'Example Row'
                  ),
                  
                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.dividerColor.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      '"Global Scholarship","Oxford University","UK","Fully Funded","Tuition,Living","3.7","7.0","2025-01-15","Medicine,Law"',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Important notes
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
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
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Important Tips',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '• Use commas to separate multiple values\n'
                                '• All columns are mandatory\n'
                                '• Date format: YYYY-MM-DD',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Upload Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _uploadingScholarshipFlowProvider.uploadStatus == Status.loading
                          ? null
                          : () => _handleUploadFile(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: theme.disabledColor,
                      ),
                      icon: _uploadingScholarshipFlowProvider.uploadStatus == Status.loading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.cloud_upload_rounded, size: 24),
                      label: Text(
                        _uploadingScholarshipFlowProvider.uploadStatus == Status.loading
                            ? 'Uploading...'
                            : 'Choose Excel File',
                        style: const TextStyle(
                          fontSize: 16,
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
          ),
        ),
        
      ],
    );
  }
}