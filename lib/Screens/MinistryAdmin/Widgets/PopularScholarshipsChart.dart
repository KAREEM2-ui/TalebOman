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
  late Size size;
  double scale = 1.0;
  int _selectedIndex = -1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = Theme.of(context);
    isDarkMode = theme.brightness == Brightness.dark;
    size = MediaQuery.of(context).size;
    scale = (size.width / 400).clamp(0.85, 1.2);
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
            height: 350 * scale,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(30 * scale),
              boxShadow:  [
                BoxShadow(
                  color: isDarkMode ? Colors.white24 : Colors.black12,
                  blurRadius: 4 * scale,
                  offset: Offset(0, 2 * scale),
                )
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(16 * scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            
                  // Title placeholder
                  Shimmer(
                    child: Container(
                      height: 32 * scale,
                      width: double.infinity,
                      constraints: BoxConstraints(maxWidth: 240 * scale),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.white24 : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12 * scale),
                      ),
                    ),
                  ),
            
                  SizedBox(height: 15 * scale),
            
                  // Pie chart + card side-by-side
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left: Big pie chart placeholder
                        Flexible(
                          flex: 2,
                          child: Center(
                            child: Shimmer(
                              child: Container(
                                width: 200 * scale,
                                height: 200 * scale,
                                decoration: BoxDecoration(
                                  color: isDarkMode ? Colors.white24 : Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
            
                        SizedBox(width: 12 * scale),
            
                        // Right: Stats card
                        Flexible(
                          flex: 3,
                          child: Shimmer(
                            child: Container(
                              padding: EdgeInsets.all(16 * scale),
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.white24 : Colors.grey[300],
                                borderRadius: BorderRadius.circular(20 * scale),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // GPA
                                  Row(
                                    children: [
                                      Container(
                                        width: 28 * scale,
                                        height: 28 * scale,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                          borderRadius: BorderRadius.circular(8 * scale),
                                        ),
                                      ),
                                      SizedBox(width: 12 * scale),
                                      Expanded(
                                        child: Container(
                                          height: 20 * scale,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            borderRadius: BorderRadius.circular(6 * scale),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16 * scale),
                                  // IELTS
                                  Row(
                                    children: [
                                      Container(
                                        width: 28 * scale,
                                        height: 28 * scale,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                          borderRadius: BorderRadius.circular(8 * scale),
                                        ),
                                      ),
                                      SizedBox(width: 12 * scale),
                                      Expanded(
                                        child: Container(
                                          height: 20 * scale,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            borderRadius: BorderRadius.circular(6 * scale),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16 * scale),
                                  // Tags
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: List.generate(3, (_) => Container(
                                      width: 70 * scale,
                                      height: 32 * scale,
                                      decoration: BoxDecoration(
                                        color: isDarkMode ? Colors.white24 : Colors.grey[400],
                                        borderRadius: BorderRadius.circular(20 * scale),
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
                  ),
                ],
              ),
            ),
          );
        }

        // Prepare PieChart sections with interactive touch
        final List<PieChartSectionData> sections =
            dashboardProvider.popularScholarships.isNotEmpty
                ? dashboardProvider.popularScholarships.map((item) {
                    final index = dashboardProvider.popularScholarships.indexOf(item);
                    return PieChartSectionData(
                      value: item.count.toDouble(),
                      title: item.scholarship.Title.length > 15
                          ? '${item.scholarship.Title.substring(0, 15)}...'
                          : item.scholarship.Title,
                      radius: 80 * scale,
                      gradient: LinearGradient(
                        colors: [
                          Colors.primaries[index % Colors.primaries.length]
                              .withValues(alpha: 0.5),
                          Colors.primaries[index % Colors.primaries.length],
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      titleStyle: TextStyle(
                        fontSize: 9 * scale,
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
                      radius: 80 * scale,
                      titleStyle: TextStyle(fontSize: 9 * scale, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: 118,
                      title: "Stem Fields",
                      color: const Color.fromARGB(255, 255, 121, 121),
                      radius: 80 * scale,
                      titleStyle: TextStyle(fontSize: 9 * scale, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: 150,
                      title: "Business",
                      color: const Color.fromARGB(255, 13, 85, 50),
                      radius: 80 * scale,
                      titleStyle: TextStyle(fontSize: 9 * scale, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: 18,
                      title: "Law",
                      color: const Color.fromARGB(255, 200, 200, 200),
                      radius: 80 * scale,
                      titleStyle: TextStyle(fontSize: 9 * scale, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ];

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16 * scale),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(30 * scale),
            boxShadow:  [
              BoxShadow(
                color: isDarkMode ? Colors.white24 : Colors.black12,
                blurRadius: 4 * scale,
                offset: Offset(0, 2 * scale),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Title + Dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(    
                      "Most Seen Scholarships",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: (theme.textTheme.headlineMedium?.fontSize ?? 5) * scale,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(width: 8 * scale),
                  Flexible(
                    flex: 2,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 140 * scale),
                      padding: EdgeInsets.symmetric(horizontal: 12 * scale),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(14 * scale),
                        boxShadow:  [
                          BoxShadow(
                            color: isDarkMode ? Colors.white12 : Colors.black12,
                            blurRadius: 10 * scale,
                            offset: Offset(0, 4 * scale),
                          ),
                        ],
                        border: Border.all(
                          color: const Color.fromRGBO(0, 0, 0, 0.06),
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
                            fontSize: 11 * scale,
                          ),
                          borderRadius: BorderRadius.circular(14 * scale),
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
                            if (value! == dashboardProvider.popularScholarshipFilter) return;
                            setState(() {
                              dashboardProvider.fetchPopularScholarships(value);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16 * scale),

              // Middle Row: Pie Chart + Right Column
              LayoutBuilder(builder: (context, constraints) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pie chart with touch interaction
                    Flexible(
                      flex: 2,
                      child: SizedBox(
                        height: 200 * scale,
                        child: PieChart(
                          PieChartData(
                            startDegreeOffset: -90,
                            sections: sections.asMap().entries.map((entry) {
                              int index = entry.key;
                              PieChartSectionData section = entry.value;
                              final isSelected = index == _selectedIndex;
                              final total = sections.fold<double>(0, (sum, s) => sum + s.value);
                              final percentage = (section.value / total * 100).toStringAsFixed(1);
                              
                              return PieChartSectionData(
                                value: section.value,
                                title: isSelected ? '$percentage%' : section.title,
                                radius: isSelected ? 95 * scale : 80 * scale,
                                gradient: isSelected
                                    ? LinearGradient(
                                        colors: [
                                          Colors.primaries[index % Colors.primaries.length].withValues(alpha: 0.8),
                                          Colors.primaries[index % Colors.primaries.length],
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : LinearGradient(
                                        colors: [
                                          Colors.primaries[index % Colors.primaries.length].withValues(alpha: 0.5),
                                          Colors.primaries[index % Colors.primaries.length],
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                titleStyle: TextStyle(
                                  fontSize: isSelected ? 12 * scale : 9 * scale,
                                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                                  overflow: TextOverflow.fade,
                                  color: Colors.white,
                                ),
                              );
                            }).toList(),
                            centerSpaceRadius: 0,
                            sectionsSpace: _selectedIndex >= 0 ? 4 * scale : 2 * scale,
                            pieTouchData: PieTouchData(
                              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    _selectedIndex = -1;
                                    return;
                                  }
                                  _selectedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                });
                              },
                            ),
                          ),
                          curve: Curves.easeInOutCubicEmphasized,
                          duration: const Duration(milliseconds: 500),
                        ),
                      ),
                    ),
                    SizedBox(width: 16 * scale),

                    // Right column with stats
                    Expanded(
                      flex: 3,
                      child: _selectedIndex >= 0 && _selectedIndex < dashboardProvider.popularScholarships.length
                          ? _buildSelectedScholarshipCard(dashboardProvider, scale)
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                StatRow(label: "Average CGPA", value: dashboardProvider.averageCgpa.toStringAsFixed(2), icon: Icon(Icons.school,color: Colors.blue.shade700,size: 20 * scale,), scale: scale),
                                StatRow(label: "Average IELTS", value: dashboardProvider.averageIelts.toStringAsFixed(1), icon: Icon(Icons.language,size: 20 * scale,color: Colors.blue.shade700,), scale: scale),
                                Column(
                                  children: [
                                    StatRow(label: "Common Fields", value: "", icon: Icon(Icons.engineering,size: 20 * scale,color: Colors.blue.shade700,), scale: scale),
                                    SizedBox(height: 8 * scale),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: dashboardProvider.commanFieldofInterest
                                          .map((field) => _FieldChip(label: field, scale: scale))
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

  Widget _buildSelectedScholarshipCard(DashboardProvider provider, double scale) {
    final item = provider.popularScholarships[_selectedIndex];
    final index = _selectedIndex;

    return Container(
      padding: EdgeInsets.all(12 * scale),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20 * scale),
        border: Border.all(
          color: Colors.primaries[index % Colors.primaries.length].withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.primaries[index % Colors.primaries.length].withValues(alpha: 0.15),
            blurRadius: 8 * scale,
            offset: Offset(0, 2 * scale),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10 * scale,
                height: 10 * scale,
                decoration: BoxDecoration(
                  color: Colors.primaries[index % Colors.primaries.length],
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8 * scale),
              Expanded(
                child: Text(
                  item.scholarship.Title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12 * scale,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 10 * scale),
          _buildDetailRow(Icons.school, 'University', item.scholarship.university, scale),
          SizedBox(height: 6 * scale),
          _buildDetailRow(Icons.location_on, 'Country', item.scholarship.country, scale),
          SizedBox(height: 6 * scale),
          _buildDetailRow(Icons.grade, 'Min CGPA', item.scholarship.minCGPA.toStringAsFixed(2), scale),
          SizedBox(height: 6 * scale),
          _buildDetailRow(Icons.language, 'Min IELTS', item.scholarship.minIelts.toStringAsFixed(1), scale),
          if (item.scholarship.fieldsOfStudy.isNotEmpty) ...[
            SizedBox(height: 8 * scale),
            Row(
              children: [
                Icon(Icons.menu_book, size: 14 * scale, color: Colors.blue.shade700),
                SizedBox(width: 6 * scale),
                Text('Fields:', style: theme.textTheme.bodySmall),
              ],
            ),
            SizedBox(height: 6 * scale),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: item.scholarship.fieldsOfStudy
                  .map((field) => _FieldChip(label: field, scale: scale * 0.8))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, double scale) {
    return Row(
      children: [
        Icon(icon, size: 14 * scale, color: Colors.blue.shade700),
        SizedBox(width: 6 * scale),
        Text(
          '$label: ',
          style: theme.textTheme.bodySmall?.copyWith(fontSize: 10 * scale),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 10 * scale,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Helper widget for stats
class StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Icon icon;
  final double scale;

  const StatRow({super.key, required this.label, required this.value, required this.icon, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8 * scale),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          SizedBox(width: 8 * scale),
          Text(
            "$label: ",
            style: theme.textTheme.bodySmall
          ),
          SizedBox(width: 8 * scale),
          value != "" ?
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4 * scale,horizontal: 8 * scale),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8 * scale),
                color: theme.cardColor,
                border: Border.all(
                  color: isDarkMode ? Colors.white12 : Colors.black12,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(0, 0, 0, 0.18),
                    blurRadius: 1 * scale,
                    offset: Offset(0, 1.5 * scale),
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
          ) : const SizedBox()
        ],
      ),
    );
  }
}

class _FieldChip extends StatelessWidget {
  final String label;
  final double scale;
  const _FieldChip({required this.label, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15 * scale, vertical: 6 * scale),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16 * scale),
        boxShadow:  [
          BoxShadow(
            color: isDarkMode ? Colors.white12 : Colors.black12, 
            blurRadius: 1 * scale,
            offset: Offset(0, 1.5 * scale),
          ),
        ],
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

