import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

import '../../../../../widgets/CustomButton.dart';
import '../view/assign_tasks_screen.dart';

/// Assign Supervisor: radios (monitor vs assign) + name / mobile fields.
class AssignSupervisorCard extends StatefulWidget {

  /// `true` = "Monitor Yourself", `false` = "Assign a Supervisor".
 /* final bool monitorYourself;
  final ValueChanged<bool> onMonitorYourselfChanged;

  final TextEditingController nameController;
  final TextEditingController mobileController;
  final bool nameReadOnly;
  final bool mobileReadOnly;*/

  const AssignSupervisorCard({
    Key? key,
   /* required this.monitorYourself,
    required this.onMonitorYourselfChanged,
    required this.nameController,
    required this.mobileController,
    this.nameReadOnly = false,
    this.mobileReadOnly = false,*/
  }) : super(key: key);

  @override
  State<AssignSupervisorCard> createState() =>
      _AssignSupervisorCardState();
}

class _AssignSupervisorCardState extends State<AssignSupervisorCard> {

  static const String _infoMessage =
      'Choose whether to monitor tasks yourself or assign a supervisor to oversee and manage them.';
  static const Color _cardBg = Color(0xFFF7F7F7);
  static const Color _iconGrey = Color(0xFF9E9E9E);
  static const Color _fieldGreyHint = Color(0xFF8F8F8F);
  bool monitorYourself = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  bool nameReadOnly = false;
  bool mobileReadOnly = false;

  // 👇 keep all your required data here instead of passing
  bool isClientSupervisor = false;
  List<String> facilityNames = [];
  String? selectedFacility;
  String facilityName = "";
  String loc = "";
  int roleId = 0;
  String defaultHostLocation = "";
  int clusterId = 0;
  int selectedIndex = 0;
  List<String> facilitydropdownNames = [];
  dynamic selectedbuddy;
  List<dynamic> facilityType = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline, size: 24, color: _iconGrey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Assign Supervisor',
                  style: AppTextStyle.font16bold,
                ),
              ),
              Tooltip(
                message: _infoMessage,
                triggerMode: TooltipTriggerMode.tap,
                showDuration: const Duration(seconds: 5),
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
          const SizedBox(height: 18),
          Theme(
            data: Theme.of(context).copyWith(
              radioTheme: RadioThemeData(
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.black;
                  }
                  return Colors.grey.shade400;
                }),
              ),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () =>
                      setState(() {
                        monitorYourself = true;
                      }),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Radio<bool>(
                          value: true,
                          groupValue: monitorYourself,
                          onChanged: (v) {
                            if (v != null) monitorYourself = v;
                          },
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        Expanded(
                          child: Text(
                            'Monitor Yourself',
                            style: AppTextStyle.font16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => monitorYourself = (false),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Radio<bool>(
                          value: false,
                          groupValue: monitorYourself,
                          onChanged: (v) {
                            if (v != null) monitorYourself = v;
                          },
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        Expanded(
                          child: Text(
                            'Assign a Supervisor',
                            style: AppTextStyle.font16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _ShadowField(
            child: TextField(
              controller: nameController,
              readOnly: nameReadOnly,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              style: AppTextStyle.font16,
              decoration: InputDecoration(
                hintText: 'Supervisor Name*',
                hintStyle: const TextStyle(
                  color: _fieldGreyHint,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _ShadowField(
            child: TextField(
              controller: mobileController,
              readOnly: mobileReadOnly,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              style: AppTextStyle.font16,
              decoration: InputDecoration(
                hintText: 'Mobile Number*',
                hintStyle: const TextStyle(
                  color: _fieldGreyHint,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildNextButton(),
        ],
      ),
    );
  }


  Widget _buildNextButton() {
    return GestureDetector(
      onTap: () {
       /* AssignTasksScreen(
          isClientSupervisor: isClientSupervisor,
          facilityNames: facilityNames,
          selectedFacility: selectedFacility,
          facilityName: facilityController.text,
          locality:
          roleId == 16 ? defaultHostLocation : loc,
          clusterId: clusterId,
          selectedIndex: selectedIndex,
          facilitydropdownNames: facilitydropdownNames,
          existingBuddy: selectedbuddy,
          faciltyType: facilityType[selectedIndex].typeName ==
              "Others"
              ? typeController.text
              : facilityType[selectedIndex].typeName,
        );*/
      },
      child: const Custombutton(
        text: "Next",
        width: double.infinity,
      ),
    );
  }

}
class _ShadowField extends StatelessWidget {
  final Widget child;

  const _ShadowField({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
      child: child,
    );
  }
}