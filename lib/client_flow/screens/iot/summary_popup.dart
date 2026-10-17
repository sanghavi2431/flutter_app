import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../b2b_store/models/payment_provider.dart';
import '../../../janitorial_services/model/get_task_dashboard_data.dart';
import '../../../janitorial_services/screens/network/iot_services.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_textstyle.dart';

void showSummaryPopup(BuildContext context ,GeneratedAiSummery? _summaryData) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'AI Generated Summary',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.appBarTitleColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),
                SizedBox(
                  child: SingleChildScrollView(
                    child: _summaryData != null &&
                        _summaryData.results != null &&
                        _summaryData.results!.isNotEmpty
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_summaryData!.success == true)
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.green.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 16.sp,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Summary generated successfully',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 15),
                        if (_summaryData!.results != null &&
                            _summaryData!.results!.isNotEmpty)
                          if (_summaryData!.results is String)
                            Container(
                              height: 200.h,
                              width: 300.w,
                              // margin: const EdgeInsets.only(bottom: 15),
                              // padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.lightCyanColor
                                      .withOpacity(0.3),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(
                                        alpha: 0.2), // Shadow color
                                    spreadRadius:
                                    1, // How wide the shadow should spread
                                    blurRadius:
                                    10, // The blur effect of the shadow
                                    offset: const Offset(0,
                                        0), // No offset for shadow on all sides
                                  ),
                                ],
                              ),
                              child: SingleChildScrollView(
                                  child: Html(
                                      data: _summaryData!.results)),
                            )
                          else
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _summaryData!.results.toString(),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.textgreyColor,
                                ),
                              ),
                            )
                        // })
                      ],
                    )
                        : const Center(
                      child: Text('No summary data available'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      // margin: EdgeInsets.only(bottom: 10.h),
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        "Close",
                        style: AppTextStyle.font12bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
