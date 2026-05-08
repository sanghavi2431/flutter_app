import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

/// White card: Select Tasks (with info tooltip) + duration, and [taskSelector] slot.
class SelectTasksDurationCard extends StatelessWidget {
  static const String _tasksInfoMessage =
      'Select the tasks and the time required to complete the tasks.';

  final Widget taskSelector;
  final TextEditingController hoursController;
  final TextEditingController minutesController;
  final FocusNode hoursFocusNode;
  final FocusNode minutesFocusNode;
  final int? totalMinutes;
  final String? errorText;
  final VoidCallback onDurationChanged;
  final VoidCallback onDurationCommit;

  const SelectTasksDurationCard({
    Key? key,
    required this.taskSelector,
    required this.hoursController,
    required this.minutesController,
    required this.hoursFocusNode,
    required this.minutesFocusNode,
    required this.totalMinutes,
    this.errorText,
    required this.onDurationChanged,
    required this.onDurationCommit,
  }) : super(key: key);

  static const Color _mutedGrey = Color(0xFF8F8F8F);
  static const Color _summaryGrey = Color(0xFF9E9E9E);

  static List<BoxShadow> get _softFieldShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static String _formatHm(int? minutes) {
    if (minutes == null || minutes <= 0) return '00:00';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final hintStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w300,
      color: _mutedGrey.withValues(alpha: 0.85),
    );
    final valueStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w300,
      color: _mutedGrey,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                AppImages.iconSelectTask,
                width: 22,
                height: 22,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Select Tasks', style: AppTextStyle.font16bold),
              ),
              Tooltip(
                message: _tasksInfoMessage,
                triggerMode: TooltipTriggerMode.tap,
                showDuration: const Duration(seconds: 4),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.info_outline,
                    size: 22,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          taskSelector,
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.iconSetTotalTime,
                width: 22,
                height: 22,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Set Total Task Duration',
                  style: AppTextStyle.font16bold,
                ),
              ),
              Text(
                _formatHm(totalMinutes),
                style: AppTextStyle.font14.copyWith(
                  color: _summaryGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _DurationField(
                  controller: hoursController,
                  focusNode: hoursFocusNode,
                  unitLabel: 'hours',
                  hintStyle: hintStyle,
                  valueStyle: valueStyle,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => onDurationChanged(),
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(minutesFocusNode);
                  },
                  shadow: _softFieldShadow,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _DurationField(
                  controller: minutesController,
                  focusNode: minutesFocusNode,
                  unitLabel: 'mins',
                  hintStyle: hintStyle,
                  valueStyle: valueStyle,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => onDurationChanged(),
                  onEditingComplete: onDurationCommit,
                  shadow: _softFieldShadow,
                ),
              ),
            ],
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 4),
              child: Text(
                errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

class _DurationField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String unitLabel;
  final TextStyle hintStyle;
  final TextStyle valueStyle;
  final TextInputAction textInputAction;
  final ValueChanged<String> onChanged;
  final VoidCallback onEditingComplete;
  final List<BoxShadow> shadow;

  const _DurationField({
    required this.controller,
    required this.focusNode,
    required this.unitLabel,
    required this.hintStyle,
    required this.valueStyle,
    required this.textInputAction,
    required this.onChanged,
    required this.onEditingComplete,
    required this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: shadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.number,
              textInputAction: textInputAction,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              style: valueStyle,
              decoration: InputDecoration(
                hintText: '00',
                hintStyle: hintStyle,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: onChanged,
              onSubmitted: (_) => onEditingComplete(),
              onEditingComplete: onEditingComplete,
            ),
          ),
          const SizedBox(width: 6),
          Text(unitLabel, style: AppTextStyle.font14bold),
        ],
      ),
    );
  }
}
