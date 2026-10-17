import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../janitorial_services/model/iotdata_model.dart';
import 'alter_card_item.dart';

class AlertsSection extends StatelessWidget {
  final List<AlertsNotification> apiAlerts;

  const AlertsSection({
    super.key,
    required this.apiAlerts,
  });

  @override
  Widget build(BuildContext context) {



    final previewList =
    apiAlerts.length > 3 ? apiAlerts.sublist(0, 3) : apiAlerts;

    return Column(
      children: [

        /// Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [

            Semantics(
            label: "alerts_section",
            value: "header",
            child:
              Text(
                key: ValueKey("Alerts header"),
                "Alerts",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ), ),

              const Spacer(),

          Semantics(
            label: "alerts_section",
            value: "view all",
            child:
              GestureDetector(
                onTap: () => _showAllAlerts(context),
                child: const Text(
                  key: ValueKey("View All"),
                  "View All",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ), ),
            ],
          ),
        ),

        const SizedBox(height: 10),
        Column(
          children: [

            if (apiAlerts == null || apiAlerts!.isEmpty) ...[
    Semantics(
    label: "alert_section",
    value: "No Data Found",
    child:
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    key: ValueKey("No Alerts"),
                    "No Alerts found",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),)

            ] else ...[
              ListView.builder(
                key: ValueKey("Alerts list"),
                padding: const EdgeInsets.all(16),
                itemCount: previewList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return AlertCard(item: previewList[index]);
                },
              ),
            ],

          ],
        )
      ],
    );
  }

  /// BottomSheet
  void _showAllAlerts(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, controller) {
            return Column(
              children: [

                /// drag handle
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                /// title
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    key: ValueKey("Alerts header"),
                    "Alerts",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                /// content
                Expanded(
                  child: apiAlerts == null || apiAlerts!.isEmpty
                      ? const Center(
                    child: Text(
                      key: ValueKey("No Alerts"),
                      "No Alerts found",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  )
                      : ListView.builder(
                    controller: controller,
                    padding: const EdgeInsets.all(16),
                    itemCount: apiAlerts!.length,
                    itemBuilder: (context, index) {
                      return AlertCard(item: apiAlerts![index]);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
