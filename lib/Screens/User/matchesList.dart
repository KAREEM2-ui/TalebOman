import 'package:flutter/material.dart';
import 'package:projectapp/Models/Scholarship.dart';
import 'package:projectapp/Providers/MathesListProvider.dart';
import 'package:projectapp/Screens/User/Printing/MatchesPrint.dart';
import 'package:projectapp/Screens/User/Widgets/MatchWidget.dart';
import 'package:provider/provider.dart';
import '../../utils/Enums/Status.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class MatchedList extends StatelessWidget {
  const MatchedList({super.key});

  @override
  Widget build(BuildContext context) {
    final matchesListProvider = Provider.of<MatchesListProvider>(context);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final scale = (size.width / 400).clamp(0.85, 1.2);
    
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(8 * scale, 12 * scale, 8 * scale, 12 * scale),
        child: Column(
          children: [
            // header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Matches',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: (theme.textTheme.titleLarge?.fontSize ?? 20) * scale,
                  ),
                ),
                ElevatedButton.icon(
                  style: theme.elevatedButtonTheme.style?.copyWith(
                    backgroundColor: WidgetStatePropertyAll(
                      theme.cardColor
                    ),
                    side: WidgetStatePropertyAll(
                      BorderSide(
                        width: 2,
                        color: theme.brightness == Brightness.dark 
                          ? Colors.white24 
                          : Colors.black12,
                      ),
                    ),
                    shadowColor: theme.brightness == Brightness.dark
                      ? WidgetStatePropertyAll(Colors.black12)
                      : WidgetStatePropertyAll(Colors.black26),
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 8 * scale),
                    ),
                  ),
                  iconAlignment: IconAlignment.end,
                  icon: Icon(Icons.print, size: 18 * scale, color: theme.colorScheme.onSurface),
                  label: Text(

                    'Print',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * scale,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  onPressed: () async {
                    await MatchesPrint.generatePDF(matchesListProvider.matches!);
                  },
                ),
              ],
            ),
            SizedBox(height: 12 * scale),

            // State
            Expanded(child: _buildCurrentState(context, matchesListProvider, scale)),
          ],
        ),
      ),
    );
  }
}

// loading 
Widget _buildLoadingState(BuildContext context, double scale) {
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;
  final baseColor = isDarkMode 
    ? theme.colorScheme.onSurface.withValues(alpha: 0.1)
    : Colors.grey.shade100;
  final boxColor = isDarkMode 
    ? theme.colorScheme.onSurface.withValues(alpha: 0.2)
    : Colors.grey.shade300;

  return SingleChildScrollView(
    physics: const NeverScrollableScrollPhysics(),
    child: Column(
      children: List.generate(
        4,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: 30 * scale),
          child: Shimmer(
            child: Container(
              width: double.infinity,
              height: 100 * scale,
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: BorderRadius.circular(12 * scale),
              ),
              padding: EdgeInsets.all(16 * scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Title line
                  Container(
                    height: 18 * scale,
                    width: 200 * scale,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(4 * scale),
                    ),
                  ),

                  // Description lines
                  Container(
                    height: 12 * scale,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(4 * scale),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

// ERROR 
Widget _buildErrorState(BuildContext context, double scale) {
  final theme = Theme.of(context);
  
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 64 * scale,
          color: theme.colorScheme.error,
        ),
        SizedBox(height: 16 * scale),
        Text(
          'Error loading matches\n(${Provider.of<MatchesListProvider>(context).errorMsg})',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.error,
            fontSize: (theme.textTheme.titleLarge?.fontSize ?? 20) * scale,
          ),
        ),
        SizedBox(height: 8 * scale),
        Text(
          'Please try again later',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * scale,
          ),
        ),
      ],
    ),
  );
}

// EMPTY STATE
Widget _buildEmptyState(BuildContext context, double scale) {
  final theme = Theme.of(context);
  
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.search_off,
          size: 64 * scale,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        SizedBox(height: 16 * scale),
        Text(
          'No matches found',
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: (theme.textTheme.titleLarge?.fontSize ?? 20) * scale,
          ),
        ),
        SizedBox(height: 8 * scale),
        Text(
          'Try adjusting your search criteria',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * scale,
          ),
        ),
      ],
    ),
  );
}

// MATCHES LIST
Widget _buildMatchesList(
  BuildContext context,
  List<Scholarship> matches,
  MatchesListProvider matchesListProvider,
  double scale,
) {
  return RefreshIndicator(
    displacement: 80 * scale,
    onRefresh: () async {
      await matchesListProvider.loadScholarships(true);
    },
    child: ListView.separated(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: matches.length,
      itemBuilder: (context, index) => Match(match: matches[index]),
      separatorBuilder: (BuildContext context, int index) => SizedBox(height: 20 * scale),
    ),
  );
}

Widget _buildCurrentState(
  BuildContext context,
  MatchesListProvider provider,
  double scale,
) {
  if (provider.status == Status.loading) {
    return _buildLoadingState(context, scale);
  }
  if (provider.status == Status.error) {
    return _buildErrorState(context, scale);
  }
  if (provider.matches == null || provider.matches!.isEmpty) {
    return _buildEmptyState(context, scale);
  }
  return _buildMatchesList(context, provider.matches!, provider, scale);
}