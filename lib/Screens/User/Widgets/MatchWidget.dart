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

  bool isTaped = false;

  @override
  Widget build(BuildContext context) {
   
  final theme = Theme.of(context);
  final deadlineRemaining = widget.match.deadline.difference(DateTime.now());
  final daysLeft = deadlineRemaining.inDays > 0 ? deadlineRemaining.inDays : 0;

  return InkWell(
    onTap: () => setState(() => isTaped = !isTaped),
    borderRadius: BorderRadius.circular(16),
    child: Card(
      elevation: 5,
      shadowColor: Colors.black26,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.match.university,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider
                Container(
                  width: 1,
                  height: 70,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  color: Colors.grey[300],
                ),

                // Right side: Progress circle + days left
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 65,
                        height: 65,
                        child: CustomPaint(
                          painter: CircleProgressPainter(percentage: 70),
                          child: Center(
                            child: Text("70 %"),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "$daysLeft Days Left",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: daysLeft <= 5 ? Colors.red : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ───── LOCATION + DEADLINE ─────
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    const SizedBox(width: 4),
                    Text(
                      widget.match.country,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.date_range, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    const SizedBox(width: 4),
                    Text(
                      "$daysLeft Days Left",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            AnimatedCrossFade(
              firstChild: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(child: const Text("Tap to view more details",textAlign: TextAlign.center,)),
              ),
              secondChild: _buildMatchDetails(context, widget.match),
              crossFadeState: isTaped ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 100),
            )
            
        ]),
      ),
    ),
  );
}


Widget _buildMatchDetails(BuildContext context, Scholarship match) {
  final theme = Theme.of(context);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      
      
         Wrap(
              spacing: 6,
              runSpacing: 6,
              children: widget.match.fieldsOfStudy.map((field) {
                return Chip(
                  label: Text(
                    field,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // ───── REQUIREMENTS ─────
            Text(
              "Requirements:",
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.school, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    const SizedBox(width: 4),
                    Text(
                      "CGPA ≥ ${match.minCGPA}",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.language, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    const SizedBox(width: 4),
                    Text(
                      "IELTS ≥ ${match.minIelts}",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ───── DEADLINE ─────
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                const SizedBox(width: 4),
                Text(
                  "Deadline: ${match.deadline.day}/${match.deadline.month}/${match.deadline.year}",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          
      
    ]
  );
}
}


