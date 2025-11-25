import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:projectapp/Models/Scholarship.dart';

class MatchesPrint {
  static Future<void> generatePDF(List<Scholarship> matches) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.notoSansAdlamMedium();

    pw.Widget infoRow(String label, String text) {
      return pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(label,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
                font: font,
              )),
          pw.SizedBox(width: 6),
          pw.Text(
            text,
            style: pw.TextStyle(fontSize: 12, color: PdfColors.grey800, font: font),
          ),
        ],
      );
    }

    pw.Widget requirementItem(String text) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "• ",
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                font: font,
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                text,
                style: pw.TextStyle(fontSize: 12, color: PdfColors.grey800, font: font),
              ),
            ),
          ],
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) {
          return matches.map((scholarship) {
            final title = scholarship.Title;
            final university = scholarship.university ;
            final percent = scholarship.percentageScore != null
                ? scholarship.percentageScore!.toStringAsFixed(1)
                : '0.0';
            final daysLeft = scholarship.deadline.difference(DateTime.now()).inDays;
            final deadlineText = scholarship.deadline.toLocal().toString().split(' ')[0];
            final country = scholarship.country;
            final type = scholarship.type ;
            final fields = (scholarship.fieldsOfStudy).toList();
            final coverage = (scholarship.coverage).join(', ');

            return pw.Container(
              padding: const pw.EdgeInsets.all(20),
              margin: const pw.EdgeInsets.only(bottom: 24),
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(16),
                border: pw.Border.all(color: PdfColors.grey300, width: 1),
                color: PdfColors.white,
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // TOP ROW — Title & Score
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              title,
                              style: pw.TextStyle(
                                fontSize: 22,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blue800,
                                font: font,
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              university,
                              style: pw.TextStyle(
                                fontSize: 15,
                                color: PdfColors.grey700,
                                font: font,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Circular Badge
                      pw.Container(
                        width: 70,
                        height: 70,
                        alignment: pw.Alignment.center,
                        decoration: pw.BoxDecoration(
                          shape: pw.BoxShape.circle,
                          border: pw.Border.all(color: PdfColors.blue600, width: 3),
                        ),
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              "$percent%",
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blue900,
                                font: font,
                              ),
                            ),
                            pw.Text(
                              "Match",
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.grey600,
                                font: font,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 12),

                  // Deadline badge
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.red50,
                      borderRadius: pw.BorderRadius.circular(6),
                    ),
                    child: pw.Text(
                      daysLeft > 0 ? "$daysLeft Days Left" : "Closed",
                      style: pw.TextStyle(
                        color: PdfColors.red600,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                        font: font,
                      ),
                    ),
                  ),

                  pw.SizedBox(height: 16),

                  // INFO ROW (text labels)
                  pw.Row(
                    children: [
                      infoRow("Location:", country),
                      pw.SizedBox(width: 18),
                      infoRow("Date:", deadlineText),
                      pw.SizedBox(width: 18),
                      infoRow("Type:", type),
                    ],
                  ),

                  pw.SizedBox(height: 16),

                  // TAGS SECTION
                  pw.Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: fields.map((tag) {
                      final safeTag = (tag).toString();
                      return pw.Container(
                        padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.grey200,
                          borderRadius: pw.BorderRadius.circular(10),
                        ),
                        child: pw.Text(
                          safeTag,
                          style: pw.TextStyle(fontSize: 12, font: font),
                        ),
                      );
                    }).toList(),
                  ),

                  pw.SizedBox(height: 20),

                  // REQUIREMENTS SECTION
                  pw.Text(
                    "Requirements",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 17,
                      color: PdfColors.blue900,
                      font: font,
                    ),
                  ),
                  pw.SizedBox(height: 10),

                  pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey100,
                      borderRadius: pw.BorderRadius.circular(10),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        requirementItem("CGPA : ${scholarship.minCGPA.toStringAsFixed(1)}"),
                        requirementItem("IELTS : ${scholarship.minIelts.toStringAsFixed(1)}"),
                        requirementItem("Deadline: $deadlineText"),
                        requirementItem("Coverage: ${coverage.isNotEmpty ? coverage : 'N/A'}"),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList();
        },
      ),
    );

    // Save PDF
    try {
      final bytes = await pdf.save();
      final directory = Directory('/storage/emulated/0/Download');
      if (!directory.existsSync()) {
        await directory.create(recursive: true);
      }
      final file = File('${directory.path}/matched_scholarships_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(bytes);
      await OpenFilex.open(file.path);
    } catch (e) {
      // fallback: show print/share dialog if direct write/open fails
      try {
        final bytes = await pdf.save();
        await Printing.sharePdf(bytes: bytes, filename: 'matched_scholarships.pdf');
      } catch (_) {
        rethrow;
      }
    }
  }
}
