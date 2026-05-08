import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/b2b_store/cart.dart';
import 'package:woloo_smart_hygiene/hygine_services/bloc/hygiene_service_bloc.dart';
import 'package:woloo_smart_hygiene/hygine_services/bloc/hygiene_service_event.dart';
import 'package:woloo_smart_hygiene/hygine_services/bloc/hygiene_service_state.dart';
import 'package:woloo_smart_hygiene/hygine_services/review_service_bottomsheet.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:woloo_smart_hygiene/utils/list.dart';
import 'package:woloo_smart_hygiene/b2b_store/address_change_bottomsheet.dart';

class GetTimeScheduleBottomSheet extends StatefulWidget {
  const GetTimeScheduleBottomSheet({
    super.key,
    required this.productId,
  });
  final String productId;

  @override
  State<GetTimeScheduleBottomSheet> createState() =>
      _GetTimeScheduleBottomSheetState();
}

class _GetTimeScheduleBottomSheetState
    extends State<GetTimeScheduleBottomSheet> {
  final HygieneServiceBloc _hygieneServiceBloc = HygieneServiceBloc();
  bool _isDataLoaded = false;
  String selectedBHKValue = "";
  String date = "";
  String time = "";
  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: _hygieneServiceBloc,
        listener: (context, state) {
          // print("dssa $state");
          if (state is HygieneServiceLoading) {
            EasyLoading.show(status: state.message);
          }
          if (state is HygieneServiceCartSuccess) {
            EasyLoading.dismiss();
            // setState(() {
            Navigator.pop(context);
            showModalBottomSheet(
                context: context,
                builder: (c) {
                  return ReviewServiceBottomsheet(
                    time: time,
                    date: date,
                    selectedBHKValue: selectedBHKValue,
                    productId: widget.productId,
                  );
                });
            // });
          }
          if (state is HygieneServiceError) {
            EasyLoading.dismiss();
            EasyLoading.showError(state.error);
            Navigator.pop(context);
          }
        },
        builder: (context, snapshot) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.45,
            // width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(40.r),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                spacing: 16.h,
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const XBottmSheetTopDecor(),
                  CartHeader(
                    imgPath: AppImages.timeCalender,
                    title: "Booking Schedule",
                    subtitle: 'Select or edit your Schedule',
                  ),
                  const Divider(),
                  LabeledFeaturePresentation(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2027),
                      ).then((pickedDate) {
                        if (pickedDate != null) {
                          setState(() {
                            date =
                                "${pickedDate.day.toString().padLeft(2, '0')} "
                                "${pickedDate.month.toString().padLeft(2, '0')} "
                                "${pickedDate.year}";
                          });
                        }
                      });
                    },
                    label: "Booking Date",
                    buttonHeader: date.isEmpty ? "Date" : date,
                    icon: Icons.calendar_month,
                  ),
                  LabeledFeaturePresentation(
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then((pickedTime) {
                        if (pickedTime != null) {
                          setState(() {
                            time = pickedTime.format(context);
                          });
                        }
                      });
                    },
                    label: "Booking Time",
                    buttonHeader: time.isEmpty ? "Time" : time,
                    icon: Icons.watch_later_outlined,
                  ),
                  const Divider(),
                  LongLabeledButton(
                      onTap: () {
                        if (date.isEmpty || time.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select all the fields"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        _hygieneServiceBloc.add(
                          AddToCart(
                            service_date: date,
                            service_time: time,
                            service_area: selectedBHKValue,
                            variant_id: widget.productId,
                            quantity: 1,
                          ),
                        );
                      },
                      label: "Next")
                ],
              ),
            ),
          );
        });
  }
}

class BHKSelecter extends StatelessWidget {
  const BHKSelecter({
    super.key,
    this.onTap,
    required this.label,
    this.isSelected = false,
  });
  final VoidCallback? onTap;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
            color: isSelected ? AppColors.lightCyanColor : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10.r)),
        child: Center(child: Text(label)),
      ),
    );
  }
}

class LabeledFeaturePresentation extends StatelessWidget {
  const LabeledFeaturePresentation({
    super.key,
    required this.label,
    required this.buttonHeader,
    this.onTap,
    required this.icon,
  });
  final String label;
  final String buttonHeader;
  final VoidCallback? onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        InkWell(
          onTap: onTap,
          child: Card(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: AppColors.themeBackground,
                  borderRadius: BorderRadius.circular(10.r)),
              child: Row(
                spacing: 8,
                children: [
                  Text(
                    buttonHeader,
                    style: AppTextStyle.font14bold,
                  ),
                  Icon(icon)
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
