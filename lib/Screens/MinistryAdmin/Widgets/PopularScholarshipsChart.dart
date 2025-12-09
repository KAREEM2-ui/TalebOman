import 'package:flutter/material.dart';
import 'package:projectapp/Providers/DashboardProvider.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../utils/Enums/Status.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class PopularScholarshipsWidget extends StatefulWidget {
  const PopularScholarshipsWidget({super.key});

  @override
  State<PopularScholarshipsWidget> createState() =>
      _PopularScholarshipsWidgetState();
}

class _PopularScholarshipsWidgetState extends State<PopularScholarshipsWidget> {
  
  late ThemeData theme;
  late bool isDarkMode; 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = Theme.of(context);
    isDarkMode = theme.brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {

    return Selector<DashboardProvider, Status>(
      selector: (_, provider) => provider.popularScholarshipsStatus,
      builder: (context, popularScholarshipsStatus, child) {
        final dashboardProvider = context.read<DashboardProvider>();

        // Loading state
     if (popularScholarshipsStatus == Status.loading) {
        return Container(
          height: 400,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow:  [
              BoxShadow(
                color: isDarkMode ? Colors.white24 : Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          
                // Title placeholder
                Shimmer(
                  child: Container(
                    height: 32,
                    width: 240,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white24 : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
          
                const SizedBox(height: 20),
          
                // Pie chart + card side-by-side (or stacked on small screens)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: Big pie chart placeholder
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: Shimmer(
                          child: Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              color: isDarkMode ? Colors.white24 : Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
          
                    const SizedBox(width: 20),   // ← width = correct for Row
          
                    // Right: Stats card
                    Expanded(
                      flex: 5,
                      child: Shimmer(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.white24 : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // GPA
                              Row(
                                children: [
                                  Container(width: 32, height: 32, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(8))),
                                  const SizedBox(width: 12),
                                  Container(width: 120, height: 20, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(6))),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // IELTS
                              Row(
                                children: [
                                  Container(width: 32, height: 32, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(8))),
                                  const SizedBox(width: 12),
                                  Container(width: 120, height: 20, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(6))),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // Tags
                              Wrap(
                                spacing: 3,
                                runSpacing: 2,
                                children: List.generate(3, (_) => Container(
                                  width: 80,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: isDarkMode ? Colors.white24 : Colors.grey[400],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
        // Prepare PieChart sections
        final List<PieChartSectionData> sections =
            dashboardProvider.popularScholarships.isNotEmpty
                ? dashboardProvider.popularScholarships.map((item) {
                    final index = dashboardProvider.popularScholarships.indexOf(item);
                    return PieChartSectionData(
                      value: item.count.toDouble(),
                      title: item.scholarship.Title.length > 15
                          ? '${item.scholarship.Title.substring(0, 15)}...'
                          : item.scholarship.Title,
                      radius: 120,
                      gradient: LinearGradient(
                        colors: [
                          Colors.primaries[index % Colors.primaries.length]
                              .withValues(alpha: 0.5),
                          Colors.primaries[index % Colors.primaries.length],
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      titleStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.fade,
                        color: Colors.white,
                        
                      ),
                    );
                  }).toList()
                : [
                    PieChartSectionData(
                      value: 22,
                      title: "Arts Fields",
                      color: const Color.fromARGB(255, 132, 232, 132),
                      radius: 120,
                      
                    ),
                    PieChartSectionData(
                      value: 118,
                      title: "Stem Fields",
                      color: const Color.fromARGB(255, 255, 121, 121),
                      radius: 120,
                    ),
                    PieChartSectionData(
                      value: 150,
                      title: "Business",
                      color: const Color.fromARGB(255, 13, 85, 50),
                      radius: 120,
                    ),
                    PieChartSectionData(
                      value: 18,
                      title: "Law",
                      color: const Color.fromARGB(255, 200, 200, 200),
                      radius: 120,
                    ),
                  ];

                  return Container(
                    
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow:  [
                        BoxShadow(
                          color: isDarkMode ? Colors.white24 : Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Row: Title + Dropdown
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Most Seen Scholarships",
                              style: theme.textTheme.headlineMedium
                            ),
                          Container(
                        width: 150,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(14),

                          /// card shadow 
                          boxShadow:  [
                            BoxShadow(
                              color: isDarkMode ? Colors.white12 : Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],

                          /// ✅ Soft border like analytics cards
                          border: Border.all(
                            color: Color.fromRGBO(0, 0, 0, 0.06),
                          ),
                        ),

                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<EnPopularScholarshipFilter>(
                            value: dashboardProvider.popularScholarshipFilter,

                            icon: const Icon(
                              Icons.filter_list_rounded,
                              color: Colors.blue,
                              size: 20,
                            ),

                            

                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),

                            borderRadius: BorderRadius.circular(14),
                            dropdownColor: theme.cardColor,
                            isExpanded: true,

                            items: EnPopularScholarshipFilter.values
                                .map(
                                  (filter) => DropdownMenuItem(
                                    value: filter,
                                    child: Text(filter.name),
                                  ),
                                )
                                .toList(),

                            onChanged: (value) {
                              // Avoid redundant fetch
                              if (value! == dashboardProvider.popularScholarshipFilter) return;

                              setState(() {
                                dashboardProvider.fetchPopularScholarships(value);
                              });
                            },
                          ),
                        ),
                      )


                            ],
                          ),
                          const SizedBox(height: 16),

                          // Middle Row: Pie Chart + Right Column
                          LayoutBuilder(builder: (context, constraints) {
                            return Row(

                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Pie chart
                                SizedBox(
                                  width: constraints.maxWidth * 0.55,
                                  height: 250,
                                  child: PieChart(
                                    PieChartData(
                                      startDegreeOffset: -90,
                                      sections: sections,
                                      centerSpaceRadius: 0,
                                      sectionsSpace: 2,
                                    //  titleSunbeamLayout: true,
                                      pieTouchData: PieTouchData(enabled: true),
                                    ),
                                    curve: Curves.easeInOutCubicEmphasized,
                                    duration: Duration(milliseconds: 1000),
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Right column with stats
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      StatRow(label: "Average CGPA", value: "3.5", icon: Icon(Icons.school,color: Colors.blue.shade700,size: 24,)),
                                      StatRow(label: "Average IELTS", value: "7.0", icon: Icon(Icons.language,size: 24,color: Colors.blue.shade700,)),
                                      Column(
                                        children: [
                                          StatRow(label: "Common Fields", value: "", icon: Icon(Icons.engineering,size: 24,color: Colors.blue.shade700,)),
                                          const SizedBox(height: 8),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: dashboardProvider.commanFieldofInterest
                                                .map((field) => _FieldChip(label: field))
                                                .toList(),
                                          ),
                                  
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    );
                  },
                );
              }
}

// Helper widget for stats
class StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Icon icon;

  const StatRow({super.key, required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 8),

          
          Text(
            "$label: ",
            style: theme.textTheme.bodySmall
          ),

          const SizedBox(width: 8),

          value != "" ?
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: theme.cardColor,
                border: Border.all(
                  color: isDarkMode ? Colors.white12 : Colors.black12,
                ),
                boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.18),
                  blurRadius: 1,
                  offset: Offset(0, 1.5),
                ),
              ],
              ),
              child: Text(
                textAlign: TextAlign.center,
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ): SizedBox()
        ] ,
      ),
    );
  }
}

class _FieldChip extends StatelessWidget {
  final String label;
  const _FieldChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),

        boxShadow:  [
          BoxShadow(
            color: isDarkMode ? Colors.white12 : Colors.black12, 
            blurRadius: 1,
            offset: Offset(0, 1.5),
          ),
        ],

        /// ✅ Soft border for premium feel
        border: Border.all(
          color: isDarkMode ? Colors.white12 : Colors.black12, 
        ),
      ),

      child: Text(
        label,
        style: theme.textTheme.bodyMedium
      ),
    );
  }
}

