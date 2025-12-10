

import 'package:flutter/material.dart';
import 'package:projectapp/Models/Scholarship.dart';

class AdminScholarshipCard extends StatelessWidget {
  final Scholarship scholarship;
  final VoidCallback onEdit;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool isDarkMode;

  const AdminScholarshipCard({
    super.key,
    required this.scholarship,
    required this.onEdit,
    this.onTap,
    required this.isDarkMode,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isExpired = scholarship.deadline.isBefore(DateTime.now());

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isExpired ? Colors.red.shade400 : Colors.grey.shade300,
          width: isExpired ? 2 : 1.2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + Edit/Delete Buttons Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      scholarship.Title,
                      style: TextStyle(
                        fontSize: 17.5,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Edit Button
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.edit_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      tooltip: 'Edit',
                      onPressed: onEdit,
                    ),
                  ),
                  // Delete Button
                  if (onDelete != null)
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red.shade400,
                          size: 20,
                        ),
                        tooltip: 'Delete',
                        onPressed: onDelete,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),

              // University
              _infoRow(Icons.school_outlined, scholarship.university,
                  color: Theme.of(context).colorScheme.primary,
                  weight: FontWeight.w600),

              const SizedBox(height: 8),

              // Country • Type
              _infoRow(Icons.public_outlined,
                  '${scholarship.country} • ${scholarship.type}',
                  color: Colors.grey.shade700),

              const SizedBox(height: 10),

              // Coverage
              _infoRow(Icons.check_circle_outline, _formatList(scholarship.coverage)),
              const SizedBox(height: 6),

              // Requirements
              Row(
                children: [
                  Expanded(
                    child: _infoRow(Icons.bar_chart, 'Min CGPA: ${scholarship.minCGPA}'),
                  ),
                  Expanded(
                    child: _infoRow(Icons.language, 'Min IELTS: ${scholarship.minIelts}'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Fields of Study
              _infoRow(Icons.menu_book_outlined,
                  _formatList(scholarship.fieldsOfStudy, maxItems: 3)),

              const SizedBox(height: 12),

              // Deadline - Highlighted
              Row(
                children: [
                  Icon(
                    isExpired ? Icons.warning_amber_rounded : Icons.schedule,
                    size: 18,
                    color: isExpired ? Colors.red.shade700 : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDeadline(scholarship.deadline),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isExpired ? Colors.red.shade700 : Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, {Color? color, FontWeight? weight}) {
    return Row(
      children: [
        Icon(icon, size: 17, color: color ?? Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: color ?? Colors.grey.shade700,
              fontWeight: weight ?? FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatList(List<String> items, {int maxItems = 5}) {
    if (items.isEmpty) return 'None specified';
    if (items.length <= maxItems) return items.join(', ');
    return '${items.take(maxItems).join(', ')} +${items.length - maxItems} more';
  }

  String _formatDeadline(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;

    if (diff == 0) return 'Deadline: TODAY';
    if (diff == 1) return 'Deadline: Tomorrow';
    if (diff < 0) return 'EXPIRED • ${date.day}/${date.month}/${date.year}';
    return 'Deadline: ${date.day}/${date.month}/${date.year}';
  }
}