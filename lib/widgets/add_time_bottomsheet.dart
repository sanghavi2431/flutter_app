import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:woloo_smart_hygiene/widgets/checkout_button.dart';

class AddTimeBottomSheet extends StatelessWidget {
  const AddTimeBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40.r))),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "When should the proffesional arrive?",
            style: AppTextStyle.font14bold,
          ),
          Text(
            "Service will take approx. 3 hrs & 30 mins",
            style: AppTextStyle.font14,
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 70,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (c, i) {
                          return const DateListTile(
                            day: "Mon",
                            dateNumeric: "12",
                          );
                        },
                        separatorBuilder: (c, i) => const SizedBox(
                              width: 10,
                            ),
                        itemCount: 8),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(6.r)),
                    child: Row(
                      children: [
                        const Icon(Icons.credit_card),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          "Online payment only for selected date",
                          style: AppTextStyle.font14,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Select start time of service",
                    style: AppTextStyle.font16w6,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 9,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            crossAxisCount: 3,
                            childAspectRatio: 3 / 1),
                    itemBuilder: (c, i) => Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("10:00 AM"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          const CheckOutButton()
        ],
      ),
    );
  }
}

class DateListTile extends StatelessWidget {
  final String day;
  final String dateNumeric;
  final bool isSelected;
  final VoidCallback? onTap;
  const DateListTile({
    super.key,
    required this.day,
    required this.dateNumeric,
    this.isSelected = false,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 70,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : null,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: isSelected ? Colors.deepPurple : Colors.grey[300]!,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.grey[300],
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              dateNumeric,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.grey[300],
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
