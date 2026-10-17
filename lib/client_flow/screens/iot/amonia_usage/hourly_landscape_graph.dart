import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/iot/amonia_usage/landscape_vice_versa_chart.dart';

import '../../../../janitorial_services/model/iotdata_model.dart';

void openLandscapeDialog(
    BuildContext context, {
      required List<HourlyData> ammoniaList,
      required double threshold,
      required String selectedRange,
    }) async {
  // Force landscape
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10), // ✅ 10px margin
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10), // ✅ corner radius
          child: Container(
            color: Colors.white, // ✅ white background
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height-40,
                  //height: 570,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height - 90,
                        child: CombinedChartLandscape(
                          ammoniaList:ammoniaList ?? [],
                          threshold: double.tryParse(
                              threshold?.toString() ??
                                  "0") ??
                              0.0,
                          selectedRange : selectedRange,
                        ),
                      ),



                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  ).then((_) async {
    // Safety restore (if user taps outside)
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  });
}