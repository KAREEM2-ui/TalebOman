import 'package:flutter/material.dart';
import 'package:projectapp/Providers/DashboardProvider.dart';
import 'package:projectapp/Providers/RefreshEventProvider.dart';
import 'package:projectapp/utils/Enums/Status.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class SummaryWidget extends StatefulWidget {
  const SummaryWidget({super.key});

  @override
  State<SummaryWidget> createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {
  late DashboardProvider dashboardProvider;
  late RefreshProvider refreshEventProvider;
  late ThemeData theme;
  late bool isDarkMode;
  late Size size;
  double scale = 1.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dashboardProvider = Provider.of<DashboardProvider>(context, listen: true);
    refreshEventProvider = Provider.of<RefreshProvider>(context, listen: false);
    theme = Theme.of(context);
    isDarkMode = theme.brightness == Brightness.dark;
    size = MediaQuery.of(context).size;
    scale = (size.width / 400).clamp(0.85, 1.2);

    // Listen for refresh events
    refreshEventProvider.addEventListener(dashboardProvider.fetchSummaryDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<DashboardProvider, Status>(
      selector: (_, provider) => provider.summaryStatus,
      builder: (context, summaryStatus, child) {
        // Loading state
        if (summaryStatus == Status.loading) {
          return Padding(
            padding: EdgeInsets.all(16 * scale),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // ✅ LEFT ALIGN
              children: [
                // ✅ TITLE SHIMMER (TOP LEFT)
                Shimmer(
                  interval: const Duration(milliseconds: 900),
                  color: isDarkMode ? Colors.white24 : Colors.grey[300]!,
                  colorOpacity: 0.3,
                  enabled: true,
                  direction: const ShimmerDirection.fromLTRB(),
                  child: Container(
                    height: 22 * scale,
                    width: 180 * scale,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white24 : Colors.grey[300]!,
                      borderRadius: BorderRadius.circular(8 * scale),
                    ),
                  ),
                ),

                SizedBox(height: 24 * scale),

                // ✅ LIST OF SHIMMER LINES
                Column(
                  children: List.generate(6, (index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 14 * scale),
                      child: Shimmer(
                        interval: const Duration(milliseconds: 900),
                        color: isDarkMode ? Colors.white24 : Colors.grey[300]!,
                        colorOpacity: 0.3,
                        enabled: true,
                        direction: const ShimmerDirection.fromLTRB(),
                        child: Container(
                          height: 14 * scale,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.white24 : Colors.grey[300]!,
                            borderRadius: BorderRadius.circular(6 * scale),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        }

        // Error state
        if (summaryStatus == Status.error) {
          return Center(
            child: Text(
              "Error loading summary data",
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: Colors.redAccent),
            ),
          );
        }

        final metrics = [
          SummaryMetric(
              label: "Total Scholarships",
              value: dashboardProvider.totalScholarships.toString(),
              icon: Icons.school),
          SummaryMetric(
              label: "Total Users",
              value: dashboardProvider.totalUsers.toString(),
              icon: Icons.people),
          SummaryMetric(
              label: "Active Scholarships",
              value: dashboardProvider.activeScholarships.toString(),
              icon: Icons.check_circle),

        ];

        return Container(
          padding: EdgeInsets.all(20 * scale),
          
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16 * scale),
            boxShadow:  [
              BoxShadow(
                color: isDarkMode ? Colors.white12 : Colors.black12,
                blurRadius: 8 * scale,
                offset: Offset(0, 6 * scale),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ✅ Title 
              Text(
                "Your Summary",
                style: theme.textTheme.headlineMedium
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: (theme.textTheme.headlineMedium?.fontSize ?? 24) * scale,
                    ),
              ),

              SizedBox(height: 16 * scale),

              /// ✅ List rows
              ...metrics.map(
                (metric) => Padding(
                  padding: EdgeInsets.only(bottom: 14 * scale),
                  child: SummaryRow(metric: metric, scale: scale),
                ),
              ),

              SizedBox(height: 8 * scale),
            ],
          ),
        );
      },
    );
  }
}



class SummaryRow extends StatelessWidget {
  final SummaryMetric metric;
  final double scale;
  const SummaryRow({super.key, required this.metric, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Row(
      children: [
        /// ✅ Icon Avatar
        CircleAvatar(
          radius: 22 * scale,
          backgroundColor: isDarkMode ? Colors.white12 : Colors.grey[200]!,
          child: Icon(
            metric.icon,
            color: theme.primaryColor,
            size: 22 * scale,
          ),
        ),

        SizedBox(width: 12 * scale),

        /// ✅ Title + Subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metric.label,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * scale,
                    ),
              ),
              SizedBox(height: 4 * scale),
              Text(
                "Updated just now",
                style: theme.textTheme.bodySmall
                    ?.copyWith(
                      color: Colors.grey,
                      fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * scale,
                    ),
              ),
            ],
          ),
        ),

        /// ✅ Value (Right Side)
        Text(
          metric.value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * scale,
          )
        ),
      ],
    );
  }
}




class SummaryMetric {
  final String label;
  final String value;
  final IconData icon;

  SummaryMetric({
    required this.label,
    required this.value,
    required this.icon,
  });
}
