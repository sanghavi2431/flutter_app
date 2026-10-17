import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/tasklist_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/assign_task/widgets/task_details_dialog.dart';

const Color _chipBg = Color(0xFFEFF6FF);
const Color _accentBlue = Color(0xFF1E7CF2);

/// Expands [task_names] when the API returns a single comma- or semicolon-separated string.
List<String> normalizeTaskNamesForChips(List<String>? raw) {
  if (raw == null || raw.isEmpty) return [];
  final trimmed =
      raw.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  if (trimmed.length == 1) {
    final s = trimmed.first;
    if (s.contains(',') || s.contains(';')) {
      return s
          .split(RegExp(r'[,;]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
  }
  return trimmed;
}

/// Horizontally scrollable task chips; shows **View All** when
/// `names.length > viewAllMinCount` (default **1** → 2+ chips, matching new tasks).
class HorizontalTaskChipsBar extends StatelessWidget {
  final List<String> names;
  final List<TaskDropdownModel> facilityNames;

  /// Show the View All action when `names.length > viewAllMinCount`.
  /// Default `1` → show when there are **2 or more** task names (was 3, so API rows
  /// with 3 tasks never showed View All).
  final int viewAllMinCount;

  final VoidCallback onViewAll;

  const HorizontalTaskChipsBar({
    super.key,
    required this.names,
    required this.facilityNames,
    required this.onViewAll,
    this.viewAllMinCount = 1,
  });

  Widget _chip(String taskName) {
    final taskModel = taskDropdownForChipName(taskName, facilityNames);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        avatar: taskModel.imageUrl != null && taskModel.imageUrl!.isNotEmpty
            ? Image.network(
                taskModel.imageUrl!,
                width: 16,
                height: 16,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const SizedBox(width: 16, height: 16),
              )
            : null,
        label: Text(
          taskName,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xff4A4A4A),
          ),
        ),
        backgroundColor: _chipBg,
        side: BorderSide(color: Colors.blue.shade100, width: 1),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (names.isEmpty) return const SizedBox.shrink();

    final showViewAll = names.length > viewAllMinCount;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: names.map(_chip).toList(),
            ),
          ),
        ),
        if (showViewAll) ...[
          const SizedBox(width: 4),
          TextButton(
            onPressed: onViewAll,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'View All',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _accentBlue,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
