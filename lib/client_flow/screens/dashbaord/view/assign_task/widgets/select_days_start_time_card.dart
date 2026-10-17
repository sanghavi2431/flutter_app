import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

/// Light grey card: day picker (S–S circles), start time field + AM/PM switch + add.
class SelectDaysStartTimeCard extends StatelessWidget {
  static const String _daysInfoMessage =
      'Select the days on which the tasks should be done and at what time.';

  static const List<String> _dayKeys = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  static const List<String> _dayLetters = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  static const Color _cardBg = Color(0xFFF5F5F5);
  static const Color _accent = Color(0xFFA0E1FA);
  static const Color _letterBlack = Color(0xFF1A1A1A);

  final List<String> selectedDayKeys;
  final ValueChanged<String> onDayToggled;
  final bool isAM;
  final ValueChanged<bool> onAmPmChanged;
  /// [TextField] only; this widget wraps it in the white shadow container.
  final Widget startTimeTextField;
  final VoidCallback onAddPressed;

  const SelectDaysStartTimeCard({
    Key? key,
    required this.selectedDayKeys,
    required this.onDayToggled,
    required this.isAM,
    required this.onAmPmChanged,
    required this.startTimeTextField,
    required this.onAddPressed,
  }) : super(key: key);

  static List<BoxShadow> get _circleShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get _cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: _cardShadow,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                AppImages.iconSelectDays,
                width: 22,
                height: 22,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Select Days', style: AppTextStyle.font16bold),
              ),
              Tooltip(
                message: _daysInfoMessage,
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final key = _dayKeys[index];
              final letter = _dayLetters[index];
              final isSelected = selectedDayKeys.contains(key);

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < 6 ? 6 : 0,
                  ),
                  child: GestureDetector(
                    onTap: () => onDayToggled(key),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? _accent : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: _circleShadow,
                        ),
                        child: Text(
                          letter,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _letterBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.iconStartTime,
                width: 22,
                height: 22,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Enter Start Time',
                  style: AppTextStyle.font16bold,
                ),
              ),
              Text(
                'PM',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isAM ? FontWeight.w400 : FontWeight.w700,
                  color: isAM ? Colors.grey.shade600 : _letterBlack,
                ),
              ),
              const SizedBox(width: 6),
              Switch(
                value: isAM,
                onChanged: (v) => onAmPmChanged(v),
                activeTrackColor: _accent,
                inactiveTrackColor: _accent.withValues(alpha: 0.45),
                thumbColor: WidgetStateProperty.all(Colors.white),
                trackOutlineColor:
                    WidgetStateProperty.all(Colors.transparent),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(width: 6),
              Text(
                'AM',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isAM ? FontWeight.w700 : FontWeight.w400,
                  color: isAM ? _letterBlack : Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: startTimeTextField,
                ),
              ),
              const SizedBox(width: 10),
              Material(
                color: _accent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: onAddPressed,
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(
                      child: Text(
                        '+',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          height: 1,
                          color: _letterBlack,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
