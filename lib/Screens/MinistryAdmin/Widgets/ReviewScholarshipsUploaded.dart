import 'package:flutter/material.dart';
import 'package:projectapp/Models/Scholarship.dart';
import 'package:projectapp/Providers/UploadingScholarshipFlowProvider.dart';
import 'package:provider/provider.dart';
import 'package:projectapp/Screens/MinistryAdmin/Widgets/AdminScholarshipCard.dart';

class ReviewWidget extends StatefulWidget {
  const ReviewWidget({super.key});

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {

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

    //  FULL ADD / EDIT DIALOG (ALL FIELDS)
  void _openScholarshipDialog(BuildContext mainContext,
      {Scholarship? scholarship, int? idx}) {
    final List<String> scholarshipTypes = [
      "Fully Funded",
      "Partially Funded",
    ];

    final List<String> availableFields = [
      "Computer Science",
      "Engineering",
      "Business",
      "Medicine",
      "Law",
      "AI",
      "Data Science",
      "Cyber Security",
      "Arts",
    ];

    final titleCtrl = TextEditingController(text: scholarship?.Title ?? '');
    final universityCtrl =
        TextEditingController(text: scholarship?.university ?? '');
    final countryCtrl =
        TextEditingController(text: scholarship?.country ?? '');
    final typeCtrl = TextEditingController(text: scholarship?.type ?? '');
    final coverageCtrl = TextEditingController(
        text: scholarship?.coverage.join(', ') ?? '');
    final cgpaCtrl = TextEditingController(
        text: scholarship?.minCGPA.toString() ?? '');
    final ieltsCtrl = TextEditingController(
        text: scholarship?.minIelts.toString() ?? '');
    final deadlineCtrl = TextEditingController(
        text: scholarship?.deadline.toIso8601String().split('T').first ?? '');
    final fieldsCtrl = TextEditingController(
        text: scholarship?.fieldsOfStudy.join(', ') ?? '');

    /// ✅ FOR MULTI SELECT UI (NO BACKEND CHANGE)
    final List<String> selectedFields =
        scholarship?.fieldsOfStudy.toList() ?? [];

    final formKey = GlobalKey<FormState>();
    
    Widget field(
      TextEditingController c,
      String label, {
      bool required = true,
      IconData? icon,
    }) {
      return Padding(
        padding: EdgeInsets.only(bottom: 12 * scale),
        child: TextFormField(
          controller: c,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(fontSize: 14 * scale),
            prefixIcon: icon == null ? null : Icon(icon, size: 20 * scale),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12 * scale)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 14 * scale),
          ),
          style: TextStyle(fontSize: 14 * scale),
          validator: required ? (v) => v!.isEmpty ? "$label required" : null : null,
        ),
      );
    }

    Widget numberField(
      TextEditingController c,
      String label, {
      bool required = true,
      IconData? icon,
    }) {
      return Padding(
        padding: EdgeInsets.only(bottom: 8 * scale),
        child: TextFormField(
          controller: c,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(fontSize: 14 * scale),
            prefixIcon: icon == null ? null : Icon(icon, size: 20 * scale),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12 * scale)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 14 * scale),
          ),
          style: TextStyle(fontSize: 14 * scale),
          validator: required ? (v) => v!.isEmpty ? "$label required" : null : null,
        ),
      );
    }

    showDialog(
      context: mainContext,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16 * scale)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 450 * scale,
            minWidth: 350 * scale,
            maxHeight: MediaQuery.of(mainContext).size.height * 0.85,
          ),
          child: Padding(
            padding: EdgeInsets.all(20 * scale),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ✅ TITLE
                        Row(
                          children: [
                            Icon(
                              scholarship == null ? Icons.add : Icons.edit,
                              size: 26 * scale,
                            ),
                            SizedBox(width: 10 * scale),
                            Expanded(
                              child: Text(
                                scholarship == null
                                    ? "Add Scholarship"
                                    : "Edit Scholarship",
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontSize: (theme.textTheme.titleLarge?.fontSize ?? 20) * scale,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
              
                        SizedBox(height: 20 * scale),
              
                        // ✅ FIELDS
                        field(titleCtrl, "Title", icon: Icons.title),
                        field(universityCtrl, "University", icon: Icons.school),
                        field(countryCtrl, "Country", icon: Icons.public),
              
                        /// ✅ TYPE DROPDOWN (SENT AS TEXT)
                        Padding(
                          padding: EdgeInsets.only(bottom: 12 * scale),
                          child: DropdownButtonFormField<String>(
                            value: scholarshipTypes.contains(typeCtrl.text)
                                ? typeCtrl.text
                                : null,
                            decoration: InputDecoration(
                              labelText: "Type",
                              labelStyle: TextStyle(fontSize: 14 * scale),
                              prefixIcon: Icon(Icons.category, size: 20 * scale),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12 * scale)),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 14 * scale),
                            ),
                            style: TextStyle(fontSize: 14 * scale),
                            items: scholarshipTypes
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              typeCtrl.text = value!;
                            },
                            validator: (v) =>
                                v == null ? "Type required" : null,
                          ),
                        ),
              
                        field(
                          coverageCtrl,
                          "Coverage (comma separated)",
                          icon: Icons.list,
                        ),
              
                        Row(
                          children: [
                            Expanded(
                              child: numberField(
                                cgpaCtrl,
                                "CGPA",
                                icon: Icons.grade,
                              ),
                            ),
                            SizedBox(width: 12 * scale),
                            Expanded(
                              child: numberField(
                                ieltsCtrl,
                                "IELTS",
                                icon: Icons.language,
                              ),
                            ),
                          ],
                        ),
              
                        SizedBox(height: 12 * scale),
              
                        // ✅ DATE PICKER
                        Padding(
                          padding: EdgeInsets.only(bottom: 12 * scale),
                          child: TextFormField(
                            controller: deadlineCtrl,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Deadline",
                              labelStyle: TextStyle(fontSize: 14 * scale),
                              prefixIcon: Icon(Icons.calendar_month, size: 20 * scale),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12 * scale)),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 14 * scale),
                            ),
                            style: TextStyle(fontSize: 14 * scale),
                            validator: (v) => v!.isEmpty ? "Deadline required" : null,
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: scholarship?.deadline ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                deadlineCtrl.text = picked.toIso8601String().split('T').first;
                              }
                            },
                          ),
                        ),
              
                        SizedBox(height: 16 * scale),
              
                        /// ✅ MULTI-SELECT FIELDS (STILL SAVED AS STRING)
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Fields of Study",
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontSize: (theme.textTheme.titleSmall?.fontSize ?? 14) * scale,
                            ),
                          ),
                        ),
                        SizedBox(height: 8 * scale),
              
                        Wrap(
                          spacing: 6 * scale,
                          runSpacing: 6 * scale,
                          children: availableFields.map((field) {
                            final isSelected = selectedFields.contains(field);
                            return FilterChip(
                              label: Text(
                                field,
                                style: TextStyle(fontSize: 13 * scale),
                              ),
                              selected: isSelected,
                              onSelected: (value) {
                                setState(() {
                                  if (value) {
                                    selectedFields.add(field);
                                  } else {
                                    selectedFields.remove(field);
                                  }
                                  /// ✅ CRITICAL: STILL STORE AS STRING
                                  fieldsCtrl.text = selectedFields.join(', ');
                                });
                              },
                            );
                          }).toList(),
                        ),
              
                        SizedBox(height: 28 * scale),
              
                        // ✅ ACTION BUTTONS
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12 * scale),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(fontSize: 14 * scale),
                                ),
                              ),
                            ),
                            SizedBox(width: 12 * scale),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12 * scale),
                                ),
                                icon: Icon(Icons.save, size: 18 * scale),
                                label: Text(
                                  "Save",
                                  style: TextStyle(fontSize: 14 * scale),
                                ),
                                onPressed: () async {
                                  if (!formKey.currentState!.validate()) return;
              
                                  final newScholarship = Scholarship(
                                    id: scholarship?.id,
                                    Title: titleCtrl.text,
                                    university: universityCtrl.text,
                                    country: countryCtrl.text,
                                    type: typeCtrl.text,
                                    coverage: coverageCtrl.text
                                        .split(',')
                                        .map((e) => e.trim())
                                        .toList(),
                                    minCGPA: double.parse(cgpaCtrl.text),
                                    minIelts: double.parse(ieltsCtrl.text),
                                    deadline: DateTime.parse(deadlineCtrl.text),
                                    fieldsOfStudy: fieldsCtrl.text
                                        .split(',')
                                        .map((e) => e.trim())
                                        .toList(),
                                  );
              
                                  if (scholarship == null) {
                                    // ADD
                                    _uploadingScholarshipFlowProvider.addNew(newScholarship);
                                  } else {
                                    // UPDATE
                                    _uploadingScholarshipFlowProvider.update(idx!, newScholarship);
                                  }
              
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _uploadingScholarshipFlowProvider.uploadedScholarships.isEmpty
        ? Center(
            child: Padding(
              padding: EdgeInsets.all(24 * scale),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_open_rounded,
                    size: 64 * scale,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                  SizedBox(height: 16 * scale),
                  Text(
                    'No scholarships uploaded yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: (theme.textTheme.titleMedium?.fontSize ?? 16) * scale,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 8 * scale, vertical: 8 * scale),
            itemCount: _uploadingScholarshipFlowProvider.uploadedScholarships.length,
            itemBuilder: (context, index) {
              final scholarship = _uploadingScholarshipFlowProvider.uploadedScholarships[index];
              return AdminScholarshipCard(
                scholarship: scholarship,
                onEdit: () {
                  _openScholarshipDialog(context, scholarship: scholarship, idx: index);
                },
                onDelete: () {
                  _uploadingScholarshipFlowProvider.removeAt(index);
                },
                isDarkMode: isDarkMode,
              );
            },
          );
  }
}
