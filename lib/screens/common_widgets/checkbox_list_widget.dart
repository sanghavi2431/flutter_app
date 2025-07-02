import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_color.dart';

class CheckboxListWidget extends StatefulWidget {
  final String? name;
  final bool showCheckbox;
  final bool isChecked;
  final bool viewOnly;
  final Function onChecked;

  const CheckboxListWidget({
    super.key,
    required this.name,
    required this.onChecked,
    this.showCheckbox = true,
    this.isChecked = false,
    this.viewOnly = false,
  });

  @override
  State<CheckboxListWidget> createState() => _CheckboxListWidgetState();
}

class _CheckboxListWidgetState extends State<CheckboxListWidget> {
  bool check = false;
  bool isDisabled = false;

  @override
  void initState() {
    check = widget.isChecked;
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

                setState(() {
                  check = !check;
                  widget.onChecked(check, widget.name);
                });
              },
              child: Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: check ? AppColors.buttonColor : AppColors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                      color: check
                          ? Colors.transparent
                          : AppColors.checkboxGreyBorder),
                ),
                child: isDisabled || !check
                    ? null
                    : const Center(
                        child: Icon(
                          Icons.check,
                          size: 20,
                          color: AppColors.black,
                        ),
                      ),
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
                  widget.onChecked(check, widget.name);
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
                          AppTextStyle.font20bold.copyWith(
                            overflow: TextOverflow.visible,
                            color: AppColors.appBarTitleColor,
                          )
                          // TextStyle(
                          //   overflow: TextOverflow.visible,
                          //   color: AppColors.appBarTitleColor,
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
