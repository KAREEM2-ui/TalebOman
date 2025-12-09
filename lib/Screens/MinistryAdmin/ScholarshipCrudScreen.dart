import 'package:flutter/material.dart';
import 'package:projectapp/Providers/RefreshEventProvider.dart';
import 'package:projectapp/Screens/MinistryAdmin/Widgets/AdminScholarshipCard.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../Models/Scholarship.dart';
import '../../Providers/ScholarshipCrudProvider.dart';
import '../../utils/Enums/Status.dart';

class ScholarshipCrudScreen extends StatefulWidget {
  const ScholarshipCrudScreen({super.key});

  @override
  State<ScholarshipCrudScreen> createState() => ScholarshipCrudScreenState();
}

class ScholarshipCrudScreenState extends State<ScholarshipCrudScreen> {

  late ScholarshipCrudProvider _scholarshipCrudProvider;
  late RefreshProvider _refreshProvider;
  late ThemeData theme;
  late bool isDarkMode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scholarshipCrudProvider = Provider.of<ScholarshipCrudProvider>(context);
    theme = Theme.of(context);
    isDarkMode = theme.brightness == Brightness.dark;

    // subscribe to refresh events
    _refreshProvider = Provider.of<RefreshProvider>(context, listen: false);
    _refreshProvider.addEventListener(refreshScholarshipList);
  }

  Future<void> refreshScholarshipList() async {
    await _scholarshipCrudProvider.fetchAllScholarships();
  }

  @override
  void dispose() {
    _refreshProvider.removeEventListener(refreshScholarshipList);
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      // ✅ ADD BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openScholarshipDialog(context),
        child: const Icon(Icons.add),
      ),

      body: Consumer<ScholarshipCrudProvider>(
        builder: (context, provider, _) {
          switch (provider.status) {
            case Status.loading:
              return _buildShimmer(isDarkMode);

            case Status.error:
              return _buildError();

            case Status.completed:
              if (provider.scholarships == null ||
                  provider.scholarships!.isEmpty) {
                return _buildEmpty();
              }

              return Column(
                children: [
                  
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                    child: Column(
                      children: [
                        const Text(
                        'Scholarships List',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text("Total Scholarships: ${provider.scholarships!.length} ",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      ],
                    ),
                  ),


                  const SizedBox(height: 12),

                  // filter
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 12, 30, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            fillColor: isDarkMode ? Colors.white12 : Colors.grey[200]!,
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.6,
                            ),
                            labelText: 'Search Scholarships',
                            prefixIcon: const Icon(Icons.search),
                            
                           
                            
                          ),
                          
                          onChanged: (value) {
                          },
                        ),
                    
                        const SizedBox(width: 12),
                    
                        ElevatedButton.icon(
                          onPressed: () {
                            
                            // open filter bottom sheet
                            showModalBottomSheet(
                            context: context,
                            showDragHandle: true,
                            useSafeArea: true,
                            isScrollControlled: true, // ✅ IMPORTANT for height control & keyboard
                            backgroundColor: Colors.lightBlueAccent[100], // ✅ allows rounded gradient container
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom, // ✅ keyboard safe
                                ),
                                child: Container(
                                  width: double.infinity,
                                  constraints: BoxConstraints(
                                    minHeight: MediaQuery.of(context).size.height * 0.5,
                                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.lightBlueAccent.shade100,
                                        Colors.white,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min, // ✅ VERY IMPORTANT
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Filter Scholarships',
                                        style: Theme.of(context).textTheme.titleLarge,
                                      ),
                                      const SizedBox(height: 16),

                                      // ✅ PLACE FILTERS HERE
                                      const Text('Filter options will go here'),

                                      const Spacer(),

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
                                            child: ElevatedButton(
                                              onPressed: () {
                                                // ✅ apply filters here
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Apply"),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );

                          },
                          icon: const Icon(Icons.filter_list),
                          label: Text('Filter',style: theme.textTheme.bodyMedium,),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                                backgroundColor: theme.cardColor,
                                shadowColor: isDarkMode ? Colors.white12 : Colors.grey[300],
                                iconColor: isDarkMode ? Colors.white : theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),



                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: provider.scholarships!.length,
                      itemBuilder: (_, index) {
                        final scholarship = provider.scholarships![index];
                        return _buildScholarshipCard(scholarship, context);
                      },
                    ),
                  ),
                ],
              );

            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  // ✅ CARD
  Widget _buildScholarshipCard(Scholarship scholarship, BuildContext context) {
    return AdminScholarshipCard(
      isDarkMode: isDarkMode,
      scholarship: scholarship,
      onEdit: () => _openScholarshipDialog(context, scholarship: scholarship),
    );

  }


  void _openScholarshipDialog(BuildContext mainContext,
    {Scholarship? scholarship}) {
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


  final theme = Theme.of(mainContext);

  final titleCtrl = TextEditingController(text: scholarship?.Title ?? '');
  final universityCtrl =
      TextEditingController(text: scholarship?.university ?? '');
  final countryCtrl =
      TextEditingController(text: scholarship?.country ?? '');
  final typeCtrl =
      TextEditingController(text: scholarship?.type ?? '');
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

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450, minWidth: 350),
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                            size: 26,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            scholarship == null
                                ? "Add Scholarship"
                                : "Edit Scholarship",
                            style: theme.textTheme.titleLarge,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      _field(titleCtrl, "Title", icon: Icons.title),
                      _field(universityCtrl, "University", icon: Icons.school),
                      _field(countryCtrl, "Country", icon: Icons.public),

                      /// ✅ TYPE DROPDOWN (SENT AS TEXT)
                      DropdownButtonFormField<String>(
                        value: scholarshipTypes.contains(typeCtrl.text)
                            ? typeCtrl.text
                            : null,
                        decoration: const InputDecoration(
                          labelText: "Type",
                          prefixIcon: Icon(Icons.category),
                        ),
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

                      const SizedBox(height: 12),

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

                      const SizedBox(height: 16),

                      /// ✅ MULTI-SELECT FIELDS (STILL SAVED AS STRING)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Fields of Study",
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 8,
                        children: availableFields.map((field) {
                          final isSelected =
                              selectedFields.contains(field);
                          return FilterChip(
                            label: Text(field),
                            selected: isSelected,
                            onSelected: (value) {
                              setState(() {
                                if (value) {
                                  selectedFields.add(field);
                                } else {
                                  selectedFields.remove(field);
                                }

                                /// ✅ CRITICAL: STILL STORE AS STRING
                                fieldsCtrl.text =
                                    selectedFields.join(', ');
                              });
                            },
                          );
                        }).toList(),
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

                                final provider = Provider.of<ScholarshipCrudProvider>(mainContext,listen: false);

                                /// ✅ EVERYTHING BELOW IS 100% UNCHANGED
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
                                  minIelts:
                                      double.parse(ieltsCtrl.text),
                                  deadline:
                                      DateTime.parse(deadlineCtrl.text),
                                  fieldsOfStudy: fieldsCtrl.text
                                      .split(',')
                                      .map((e) => e.trim())
                                      .toList(),
                                );

                                if (scholarship == null) {
                                   provider.addScholarship(newScholarship);
                                } else {
                                   provider.updateScholarship(newScholarship);
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

  //  loading skeleton
  Widget _buildShimmer(bool isDarkMode) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer(
        child: Container(
          height: 80,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.white, borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  // ✅ ERROR
  Widget _buildError() {
    return const Center(
        child: Text("Something went wrong",
            style: TextStyle(color: Colors.red)));
  }

  // ✅ EMPTY
  Widget _buildEmpty() {
    return const Center(child: Text("No scholarships found"));
  }
}
