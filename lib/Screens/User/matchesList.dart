import 'package:flutter/material.dart';
import 'package:projectapp/Models/Scholarship.dart';
import 'package:projectapp/Providers/MathesListProvider.dart';
import 'package:projectapp/Providers/ThemeProvider.dart';
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
    
      return Padding(
          padding : const EdgeInsets.fromLTRB(8, 12, 8, 12),
          child: Column(
      
            children: [
              
              // header
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Matches',
                  style: Theme.of(context).textTheme.titleLarge
                ),
                TextButton(
                  style: Theme.of(context).textButtonTheme.style,
                  onPressed: () {
                    // Navigate to see all matches
                  },
                  child: ElevatedButton.icon(
                    style: Theme.of(context).elevatedButtonTheme.style,
                    iconAlignment: IconAlignment.end,
                    icon: const Icon(Icons.print),
                    label: const Text('Print'),
                    onPressed: () async {
                      await MatchesPrint.generatePDF(matchesListProvider.matches!);
                      
                    },
                  ),
                ),
              ],
              ),
      
         
      
      
              // State
              _buildCurrentState(context, matchesListProvider),
            ]
        )
      
      );
    }
  }

// loading 
Widget _buildLoadingState(BuildContext context) {
  final isLight = Provider.of<ThemeProvider>(context).themeMode == ThemeMode.light;
  final baseColor = isLight ? Colors.grey.shade100 : Theme.of(context).colorScheme.onSurface.withOpacity(0.1);
  final BoxColor =  isLight ? Colors.grey.shade300 : Theme.of(context).colorScheme.onSurface.withOpacity(0.2);

  return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const SizedBox(height: 12),
    ListView.separated(
      shrinkWrap: true, // allows ListView inside Column
      physics: const NeverScrollableScrollPhysics(), // disable inner scrolling
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 12), // vertical spacing
      itemBuilder: (context, index) {
        return Shimmer(
          child: Container(
            width: double.infinity, // full width
            height: 100, // each card height
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title line
                Container(
                  height: 18,
                  width: 200,
                  decoration: BoxDecoration(
                    color: BoxColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),

                // Description lines
                Container(
                  height: 12,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 250,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  ],
);

}


  // ERROR 
  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            ' Error loading matches (${Provider.of<MatchesListProvider>(context).errorMsg})',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please try again later',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  // EMPTY STATE
  Widget _buildEmptyState(BuildContext context) {


    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No matches found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  // MATCHES LIST
  Widget _buildMatchesList(BuildContext context, List<Scholarship> matches,MatchesListProvider matchesListProvider) {
    return RefreshIndicator(
      displacement: 80,
      onRefresh: () async {await Future.delayed(Duration(seconds: 3));await matchesListProvider.loadScholarships(true);},
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(), 
        itemCount: matches.length,
        itemBuilder: (context, index) => Match(match: matches[index]), separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 30);},
      ),
    );
  }


Widget _buildCurrentState(BuildContext context, MatchesListProvider provider) {
  if (provider.status == Status.loading) return _buildLoadingState(context);
  if (provider.status == Status.error) return _buildErrorState(context);
  if (provider.matches == null || provider.matches!.isEmpty) {
    return _buildEmptyState(context);
  }
  return _buildMatchesList(context, provider.matches!, provider);
}