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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _uploadingScholarshipFlowProvider = Provider.of<UploadingScholarshipFlowProvider>(context, listen: true);
    theme = Theme.of(context);
    isDarkMode = theme.brightness == Brightness.dark;
  }

    //  FULL ADD / EDIT DIALOG (ALL FIELDS)
  void _openScholarshipDialog(BuildContext context,
      {Scholarship? scholarship,int? idx}) {
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


    final formKey = GlobalKey<FormState>();
    Widget _field(
      TextEditingController c,
      String label, {
      bool required = true,
      IconData? icon,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: c,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: icon == null ? null : Icon(icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator:
              required ? (v) => v!.isEmpty ? "$label required" : null : null,
        ),
      );
    }

    Widget _numberField(
      TextEditingController c,
      String label, {
      bool required = true,
      IconData? icon,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: c,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: icon == null ? null : Icon(icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: required
              ? (v) => v!.isEmpty ? "$label required" : null
              : null,
        ),
      );
    }


   showDialog(
  context: context,
  barrierDismissible: false,
  builder: (_) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 450,
        minWidth: 350,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ TITLE
              Row(
                children: [
                  Icon(
                    scholarship == null ? Icons.add : Icons.edit,
                    size: 26,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    scholarship == null
                        ? "Add Scholarship"
                        : "Edit Scholarship",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
        
              const SizedBox(height: 20),
        
              // ✅ FIELDS
              _field(titleCtrl, "Title", icon: Icons.title),
              _field(universityCtrl, "University", icon: Icons.school),
              _field(countryCtrl, "Country", icon: Icons.public),
              _field(typeCtrl, "Type", icon: Icons.category),
        
              _field(
                coverageCtrl,
                "Coverage (comma separated)",
                icon: Icons.list,
              ),
        
              Row(
                children: [
                  Expanded(
                      child: _numberField(
                    cgpaCtrl,
                    "Min CGPA",
                    icon: Icons.grade,
                  )),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _numberField(
                    ieltsCtrl,
                    "Min IELTS",
                    icon: Icons.language,
                  )),
                ],
              ),
        
              const SizedBox(height: 12),
        
              // ✅ DATE PICKER
              TextFormField(
                controller: deadlineCtrl,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Deadline",
                  prefixIcon: Icon(Icons.calendar_month),
                ),
                validator: (v) =>
                    v!.isEmpty ? "Deadline required" : null,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate:
                        scholarship?.deadline ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    deadlineCtrl.text =
                        picked.toIso8601String().split('T').first;
                  }
                },
              ),
        
              const SizedBox(height: 12),
        
              _field(
                fieldsCtrl,
                "Fields of Study (comma separated)",
                icon: Icons.menu_book,
              ),
        
           
        
              const SizedBox(height: 28),
        
              // ✅ ACTION BUTTONS
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text("Save"),
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
                          deadline:
                              DateTime.parse(deadlineCtrl.text),
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
      ),
    ),
  ),
);


}


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _uploadingScholarshipFlowProvider.uploadedScholarships.length,
      itemBuilder: (context, index) {
        final scholarship = _uploadingScholarshipFlowProvider.uploadedScholarships[index];
        return AdminScholarshipCard(scholarship: scholarship, onEdit: () {
          _openScholarshipDialog(context, scholarship: scholarship, idx: index);
        },isDarkMode: isDarkMode,);
      },
    );
  }
}
