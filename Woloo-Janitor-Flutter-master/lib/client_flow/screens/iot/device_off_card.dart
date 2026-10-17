import 'package:flutter/material.dart';

import '../../../utils/app_images.dart';
import 'dashboard_strings.dart';


class DeviceOffCard extends StatelessWidget {
  const DeviceOffCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DashboardSizes.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        children: [
          Image.asset(
            AppImages.iconAlertsIotOff,
            width: 25,
            height: 25,
          ),
          SizedBox(height: DashboardSizes.space8),

          const Text(
            DashboardStrings.deviceOffTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: DashboardSizes.space8),

          const Text(
            DashboardStrings.deviceOffSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}