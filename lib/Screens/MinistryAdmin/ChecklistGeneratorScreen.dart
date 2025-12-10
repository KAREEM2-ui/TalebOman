import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../Repositories/ScholarshipRepo.dart';

class ChecklistGeneratorScreen extends StatefulWidget {
  const ChecklistGeneratorScreen({super.key});

  @override
  State<ChecklistGeneratorScreen> createState() => _ChecklistGeneratorScreenState();
}

class _ChecklistGeneratorScreenState extends State<ChecklistGeneratorScreen> {
  static const List<String> countries = [
    'Afghanistan', 'Albania', 'Algeria', 'Andorra', 'Angola', 'Argentina', 'Armenia', 'Austria',
    'Azerbaijan', 'Bahamas', 'Bahrain', 'Bangladesh', 'Barbados', 'Belarus', 'Belgium', 'Belize',
    'Benin', 'Bhutan', 'Bolivia', 'Bosnia and Herzegovina', 'Botswana', 'Brazil', 'Brunei',
    'Bulgaria', 'Burkina Faso', 'Burundi', 'Cambodia', 'Cameroon', 'Canada', 'Cape Verde',
    'Central African Republic', 'Chad', 'Chile', 'China', 'Colombia', 'Comoros', 'Congo',
    'Costa Rica', 'Croatia', 'Cuba', 'Cyprus', 'Czech Republic', 'Czechia', 'Denmark', 'Djibouti',
    'Dominica', 'Dominican Republic', 'East Timor', 'Ecuador', 'Egypt', 'El Salvador',
    'Equatorial Guinea', 'Eritrea', 'Estonia', 'Ethiopia', 'Fiji', 'Finland', 'France',
    'Gabon', 'Gambia', 'Georgia', 'Germany', 'Ghana', 'Greece', 'Grenada', 'Guatemala',
    'Guinea', 'Guinea-Bissau', 'Guyana', 'Haiti', 'Honduras', 'Hong Kong', 'Hungary', 'Iceland',
    'India', 'Indonesia', 'Iran', 'Iraq', 'Ireland', 'Italy', 'Ivory Coast', 'Jamaica', 'Japan',
    'Jordan', 'Kazakhstan', 'Kenya', 'Kiribati', 'Kosovo', 'Kuwait', 'Kyrgyzstan', 'Laos',
    'Latvia', 'Lebanon', 'Lesotho', 'Liberia', 'Libya', 'Liechtenstein', 'Lithuania',
    'Luxembourg', 'Macao', 'Madagascar', 'Malawi', 'Malaysia', 'Maldives', 'Mali', 'Malta',
    'Marshall Islands', 'Mauritania', 'Mauritius', 'Mexico', 'Micronesia', 'Moldova', 'Monaco',
    'Mongolia', 'Montenegro', 'Morocco', 'Mozambique', 'Myanmar', 'Namibia', 'Nauru', 'Nepal',
    'Netherlands', 'New Zealand', 'Nicaragua', 'Niger', 'Nigeria', 'North Korea', 'North Macedonia',
    'Norway', 'Oman', 'Pakistan', 'Palau', 'Palestine', 'Panama', 'Papua New Guinea', 'Paraguay',
    'Peru', 'Philippines', 'Poland', 'Portugal', 'Qatar', 'Republic of the Congo', 'Romania',
    'Russia', 'Rwanda', 'Saint Kitts and Nevis', 'Saint Lucia', 'Saint Vincent and the Grenadines',
    'Samoa', 'San Marino', 'Sao Tome and Principe', 'Saudi Arabia', 'Senegal', 'Serbia',
    'Seychelles', 'Sierra Leone', 'Singapore', 'Slovakia', 'Slovenia', 'Solomon Islands', 'Somalia',
    'South Africa', 'South Korea', 'South Sudan', 'Spain', 'Sri Lanka', 'Sudan', 'Suriname',
    'Sweden', 'Switzerland', 'Syria', 'Taiwan', 'Tajikistan', 'Tanzania', 'Thailand', 'Togo',
    'Tonga', 'Trinidad and Tobago', 'Tunisia', 'Turkey', 'Turkmenistan', 'Tuvalu', 'Uganda',
    'Ukraine', 'United Arab Emirates', 'United Kingdom', 'United States', 'Uruguay', 'Uzbekistan',
    'Vanuatu', 'Vatican City', 'Venezuela', 'Vietnam', 'Yemen', 'Zambia', 'Zimbabwe',
  ];

  String? selectedCountry;
  final ScholarshipRepo _scholarshipRepo = ScholarshipRepo();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final scale = (size.width / 400).clamp(0.85, 1.2);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
         padding: EdgeInsets.all(16 * scale),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Scholarship List Generator',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: (theme.textTheme.headlineSmall?.fontSize ?? 20) * scale,
                ),
              ),
              SizedBox(height: 20 * scale),
              Text(
                'Select a country to generate a PDF with all available scholarships:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * scale,
                ),
              ),
              SizedBox(height: 12 * scale),
              DropdownButtonFormField<String>(
                value: selectedCountry,
                decoration: InputDecoration(
                  labelText: 'Country',
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 14 * scale,
                  ),
                  border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(8 * scale),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(8 * scale),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(8 * scale),
                   borderSide: BorderSide(color: theme.primaryColor, width: 2 * scale),
                  ),
                 prefixIcon: Icon(Icons.public, color: theme.colorScheme.primary, size: 22 * scale),
                  filled: true,
                  fillColor: theme.cardColor,
                 contentPadding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 14 * scale),
                ),
                dropdownColor: theme.cardColor,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * scale,
                ),
                icon: Icon(Icons.arrow_drop_down, size: 24 * scale),
                items: countries
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(
                            c,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * scale,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => selectedCountry = v),
                validator: (v) => v == null ? 'Please select a country' : null,
              ),
              SizedBox(height: 20 * scale),
              SizedBox(
                width: double.infinity,
                height: 48 * scale,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(8 * scale),
                    ),
                    disabledBackgroundColor: theme.disabledColor,
                   padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 12 * scale),
                  ),
                  icon: _isLoading
                      ? SizedBox(
                          width: 20 * scale,
                          height: 20 * scale,
                          child: CircularProgressIndicator(
                           strokeWidth: 2 * scale,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(Icons.picture_as_pdf, size: 20 * scale),
                  label: Text(
                    _isLoading ? 'Generating...' : 'Generate Scholarship List',
                   style: TextStyle(fontSize: 15 * scale, fontWeight: FontWeight.w600),
                  ),
                  onPressed: (selectedCountry == null || _isLoading) ? null : () => _generatePDF(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generatePDF() async {
    if (selectedCountry == null) return;

    setState(() => _isLoading = true);

    try {
      final theme = Theme.of(context);
      
      // Fetch scholarships for the selected country from Firebase
      final scholarships = await _scholarshipRepo.getScholarshipsByCountry(selectedCountry!);

      if (scholarships.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No scholarships found for $selectedCountry'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      final pdf = pw.Document();
      final font = await PdfGoogleFonts.notoSansRegular();
      final fontBold = await PdfGoogleFonts.notoSansBold();

      // Generate PDF with scholarship details
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (context) {
            return [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue50,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Scholarship Opportunities',
                      style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, font: fontBold, color: PdfColors.blue900),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Country: $selectedCountry',
                      style: pw.TextStyle(fontSize: 16, font: fontBold, color: PdfColors.blue700),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Total Scholarships: ${scholarships.length}',
                          style: pw.TextStyle(fontSize: 14, font: font, color: PdfColors.grey700),
                        ),
                        pw.Text(
                          'Generated: ${DateTime.now().toString().split('.')[0]}',
                          style: pw.TextStyle(fontSize: 12, font: font, color: PdfColors.grey600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 24),

              // Scholarships list
              ...scholarships.asMap().entries.map((entry) {
                final index = entry.key;
                final scholarship = entry.value;
                
                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 16),
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300, width: 1),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Scholarship number and title
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                            width: 28,
                            height: 28,
                            decoration: pw.BoxDecoration(
                              color: PdfColors.blue,
                              borderRadius: pw.BorderRadius.circular(14),
                            ),
                            child: pw.Center(
                              child: pw.Text(
                                '${index + 1}',
                                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.white, font: fontBold),
                              ),
                            ),
                          ),
                          pw.SizedBox(width: 12),
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  scholarship.Title,
                                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, font: fontBold, color: PdfColors.blue900),
                                ),
                                pw.SizedBox(height: 4),
                                pw.Text(
                                  scholarship.university,
                                  style: pw.TextStyle(fontSize: 14, font: fontBold, color: PdfColors.grey800),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      pw.SizedBox(height: 12),
                      pw.Divider(color: PdfColors.grey300, thickness: 1),
                      pw.SizedBox(height: 12),

                      // Details grid
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow('Type', scholarship.type, font, fontBold),
                                pw.SizedBox(height: 8),
                                _buildDetailRow('Min CGPA', scholarship.minCGPA.toString(), font, fontBold),
                                pw.SizedBox(height: 8),
                                _buildDetailRow('Min IELTS', scholarship.minIelts.toString(), font, fontBold),
                              ],
                            ),
                          ),
                          pw.SizedBox(width: 16),
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow('Deadline', scholarship.deadline.toString().split(' ')[0], font, fontBold),
                                pw.SizedBox(height: 8),
                                _buildDetailRow('Coverage', scholarship.coverage.join(', '), font, fontBold),
                              ],
                            ),
                          ),
                        ],
                      ),

                      pw.SizedBox(height: 12),

                      // Fields of study
                      if (scholarship.fieldsOfStudy.isNotEmpty) ...[
                        pw.Text(
                          'Fields of Study:',
                          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, font: fontBold, color: PdfColors.grey800),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: scholarship.fieldsOfStudy.map((field) {
                            return pw.Container(
                              padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: pw.BoxDecoration(
                                color: PdfColors.blue50,
                                borderRadius: pw.BorderRadius.circular(12),
                                border: pw.Border.all(color: PdfColors.blue200),
                              ),
                              child: pw.Text(
                                field,
                                style: pw.TextStyle(fontSize: 9, font: font, color: PdfColors.blue900),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),

              pw.SizedBox(height: 24),

              // Footer
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Text(
                  'For more information and application procedures, please contact the respective universities or scholarship providers.',
                  style: pw.TextStyle(fontSize: 10, font: font, color: PdfColors.grey700, fontStyle: pw.FontStyle.italic),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ];
          },
        ),
      );

      // Save PDF to Downloads folder
      final bytes = await pdf.save();
      final directory = Directory('/storage/emulated/0/Download');
      if (!directory.existsSync()) {
        await directory.create(recursive: true);
      }
      final fileName = 'Scholarships_${selectedCountry}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes);

      // Open the PDF
      await OpenFilex.open(file.path);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF saved: $fileName'),
            backgroundColor: theme.snackBarTheme.backgroundColor ?? Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('Error generating PDF: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  pw.Widget _buildDetailRow(String label, String value, pw.Font font, pw.Font fontBold) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '$label: ',
          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, font: fontBold, color: PdfColors.grey700),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            style: pw.TextStyle(fontSize: 11, font: font, color: PdfColors.grey900),
          ),
        ),
      ],
    );
  }
}

