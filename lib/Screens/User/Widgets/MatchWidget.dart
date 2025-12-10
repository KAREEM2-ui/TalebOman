import 'package:flutter/material.dart';
import 'package:projectapp/Models/Scholarship.dart';
import 'package:projectapp/utils/Painter.dart';

class Match extends StatefulWidget {
  const Match({super.key, required this.match});

  final Scholarship match;

  @override
  State<Match> createState() => _MatchState();
}

class _MatchState extends State<Match> {


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final scale = (size.width / 400).clamp(0.85, 1.2);
    
    final deadlineRemaining = widget.match.deadline.difference(DateTime.now());

    final daysLeft = deadlineRemaining.isNegative
        ? 0
        : (deadlineRemaining.inSeconds / Duration.secondsPerDay).ceil();

    return InkWell(
      onTap: () => _showDetailsDialog(context, widget.match, scale),
      borderRadius: BorderRadius.circular(16 * scale),
      highlightColor: theme.primaryColor.withValues(alpha: 0.2),
      child: Card(
        borderOnForeground: true,
        elevation: 5 * scale,
        shadowColor: isDarkMode ? const Color.fromARGB(115, 158, 153, 153) : Colors.grey.withValues(alpha: 0.3),
        margin: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 8 * scale),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16 * scale),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0 * scale),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // ───── TOP ROW: Title + University + Progress ─────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side: Title + University
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.match.Title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: (theme.textTheme.bodyLarge?.fontSize ?? 16) * scale,
                        ),
                      ),
                      SizedBox(height: 4 * scale),
                      Text(
                        widget.match.university,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * scale,
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider
                Container(
                  width: 1,
                  height: 70 * scale,
                  margin: EdgeInsets.symmetric(horizontal: 16 * scale),
                  color: isDarkMode ? Colors.white12 : Colors.grey[300],
                ),

                // Right side: Progress circle + days left
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 90 * scale,
                        height: 90 * scale,
                        child: CustomPaint(
                          size: Size(90 * scale, 90 * scale),
                          painter: CircleProgressPainter(percentage: widget.match.percentageScore!),
                          child: Center(
                            child: Text(
                              "${widget.match.percentageScore!.toStringAsFixed(1)} %",
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * scale,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8 * scale),
                      Text(
                        "$daysLeft Days Left",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: daysLeft <= 5 ? Colors.red : (isDarkMode ? Colors.grey[400] : Colors.grey[700]),
                          fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * scale,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12 * scale),

            // ───── LOCATION + DEADLINE ─────
            Wrap(
              spacing: 12 * scale,
              runSpacing: 4 * scale,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16 * scale,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    SizedBox(width: 4 * scale),
                    Text(
                      widget.match.country,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * scale,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.date_range,
                      size: 16 * scale,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    SizedBox(width: 4 * scale),
                    Text(
                      "$daysLeft Days Left",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * scale,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 12 * scale),

            // hint
            Padding(
              padding: EdgeInsets.only(top: 10.0 * scale),
              child: Center(
                child: Text(
                  "Tap to view more details",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * scale,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, Scholarship match, double scale) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (ctx) {
        final maxHeight = MediaQuery.of(ctx).size.height * 0.75;
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(18 * scale, 18 * scale, 18 * scale, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16 * scale),
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: 520 * scale),
            child: SingleChildScrollView(
              child: _buildMatchDetails(ctx, match, scale),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 8 * scale),
              ),
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Close',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * scale,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget _buildMatchDetails(BuildContext context, Scholarship match, double scale) {
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;

  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Wrap(
      spacing: 6 * scale,
      runSpacing: 6 * scale,
      children: (match.fieldsOfStudy ?? <String>[]).map((field) {
        return Chip(
          label: Text(
            field,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * scale,
            ),
          ),
          backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
          padding: EdgeInsets.symmetric(horizontal: 8 * scale, vertical: 4 * scale),
        );
      }).toList(),
    ),

    SizedBox(height: 16 * scale),

    // ───── REQUIREMENTS ─────
    Text(
      "Requirements:",
      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * scale,
      ),
    ),
    SizedBox(height: 8 * scale),
    Wrap(
      spacing: 16 * scale,
      runSpacing: 4 * scale,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.school,
              size: 16 * scale,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            SizedBox(width: 4 * scale),
            Text(
              "CGPA ≥ ${match.minCGPA}",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * scale,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.language,
              size: 16 * scale,
              color: theme.colorScheme.onSurface,
            ),
            SizedBox(width: 4 * scale),
            Text(
              "IELTS ≥ ${match.minIelts}",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * scale,
              ),
            ),
          ],
        ),
      ],
    ),

    SizedBox(height: 16 * scale),

    // ───── DEADLINE ─────
    Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 16 * scale,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        SizedBox(width: 4 * scale),
        Text(
          "Deadline: ${match.deadline.day}/${match.deadline.month}/${match.deadline.year}",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * scale,
          ),
        ),
      ],
    ),
    SizedBox(height: 12 * scale),
  ]);
}


