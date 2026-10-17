import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:woloo_smart_hygiene/screens/assign_screen/data/janitor_list_model.dart'
    as assign_models;
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

/// Task Buddy section: header + single-select dropdown with
/// "Add Task Buddy" first, then janitors (name + mobile, radio).
class TaskBuddyCard extends StatelessWidget {
  static const int addTaskBuddyValue = -1;

  /// Accent (Add row, radios) — sky blue to match design.
  static const Color accentBlue = Color(0xFF42A5F5);

  final List<assign_models.Datum> janitors;
  final int? selectedJanitorId;
  final bool isLoading;
  final VoidCallback onAddTaskBuddy;
  final ValueChanged<int> onJanitorSelected;

  const TaskBuddyCard({
    super.key,
    required this.janitors,
    required this.selectedJanitorId,
    required this.isLoading,
    required this.onAddTaskBuddy,
    required this.onJanitorSelected,
  });

  static const Color _cardBg = Color(0xFFF7F7F7);
  static const Color _borderColor = Color(0xFFDEDEDE);
  static const Color _iconGrey = Color(0xFF9E9E9E);
  static const Color _mobileGrey = Color(0xFF757575);

  @override
  Widget build(BuildContext context) {
    final withIds =
        janitors.where((e) => e.id != null).toList(growable: false);
    final bool hasJanitors = withIds.isNotEmpty;

    final String hintText;
    if (isLoading) {
      hintText = "Loading Task Buddies...";
    } else if (!hasJanitors) {
      hintText = "No Task Buddy available";
    } else {
      hintText = "Select Task Buddy";
    }

    final items = <DropdownMenuItem<int>>[];

    // "Add Task Buddy" first (matches design).
    items.add(
      DropdownMenuItem<int>(
        value: addTaskBuddyValue,
        enabled: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Icon(Icons.add, size: 20, color: accentBlue),
              const SizedBox(width: 10),
              Text(
                "Add Task Buddy",
                style: AppTextStyle.font16.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: accentBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    for (final janitor in withIds) {
      final janitorId = janitor.id!;

      final mobile = janitor.mobile?.trim() ?? "";

      items.add(
        DropdownMenuItem<int>(
          value: janitorId,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Radio<int>(
                    value: janitorId,
                    groupValue: selectedJanitorId,
                    onChanged: null,
                    activeColor: accentBlue,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        janitor.name ?? "",
                        style: AppTextStyle.font16.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (mobile.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          mobile,
                          style: AppTextStyle.font16.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: _mobileGrey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Closed button: name (+ mobile) + chevron — no radio in the field.
    List<Widget> selectedItemBuilder(BuildContext context) {
      final builders = <Widget>[
        const SizedBox.shrink(), // Add row — never held as value
      ];
      for (final janitor in withIds) {
        final janitorId = janitor.id!;
        final mobile = janitor.mobile?.trim() ?? "";
        builders.add(
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        janitor.name ?? "",
                        style: AppTextStyle.font16.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      if (mobile.isNotEmpty)
                        Text(
                          mobile,
                          style: AppTextStyle.font16.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: _mobileGrey,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return builders;
    }

    return Card(
      color: _cardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: _borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, size: 22, color: _iconGrey),
                const SizedBox(width: 8),
                Text('Task Buddy', style: AppTextStyle.font16bold),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonHideUnderline(
              child: DropdownButton2<int>(
                isExpanded: true,
                value: selectedJanitorId,
                hint: Text(
                  hintText,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                items: items,
                selectedItemBuilder: selectedItemBuilder,
                onChanged: (val) {
                  if (val == null) return;
                  if (val == addTaskBuddyValue) {
                    onAddTaskBuddy();
                    return;
                  }
                  onJanitorSelected(val);
                },
                iconStyleData: IconStyleData(
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey.shade400,
                    size: 26,
                  ),
                ),
                buttonStyleData: ButtonStyleData(
                  height: 58,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _borderColor.withOpacity(0.6)),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 280,
                  elevation: 8,
                  offset: const Offset(0, -4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 72,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
