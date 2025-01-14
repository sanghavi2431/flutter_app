import 'package:Woloo_Smart_hygiene/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_color.dart';

class DisabledCheckboxListWidget extends StatefulWidget {
  final String? name;
  final bool showCheckbox;
  final bool isChecked;
  final bool viewOnly;

  const DisabledCheckboxListWidget({
    Key? key,
    required this.name,
    this.showCheckbox = true,
    this.isChecked = false,
    this.viewOnly = false,
  }) : super(key: key);

  @override
  State<DisabledCheckboxListWidget> createState() =>
      _DisabledCheckboxListWidgetState();
}

class _DisabledCheckboxListWidgetState
    extends State<DisabledCheckboxListWidget> {
  bool check = false;
  bool isDisabled = true;
  @override
  void initState() {
    check = widget.isChecked;
    print("isChecked ---> " + widget.isChecked.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.showCheckbox) ...[
            GestureDetector(
              onTap: () {
                if (isDisabled) {
                  return;
                }
              },
              child: Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color:
                      check ? AppColors.disabledCheckBoxColor : AppColors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                      color: check
                          ? Colors.transparent
                          : AppColors.disabledContainerBorder),
                ),
                child: check
                    ? Center(
                        child: Icon(
                          Icons.check,
                          size: 15,
                          color: AppColors.disabledCheckColor,
                        ),
                      )
                    : null,
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
          ],
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!widget.showCheckbox) {
                  return;
                }

                if (isDisabled) {
                  return;
                }

                setState(() {
                  check = !check;
                });
              },
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name ?? '',
                          style:
                          AppTextStyle.font20.copyWith(
                            overflow: TextOverflow.visible,
                            color: AppColors.disabledTextColor,
                          )
                          
                          //  TextStyle(
                          //   overflow: TextOverflow.visible,
                          //   color: AppColors.disabledTextColor,
                          //   fontSize: 20.sp,
                          //   fontWeight: FontWeight.w400,
                          // ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
