import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../janitorial_services/model/iotdata_model.dart';

class AlertCard extends StatelessWidget {
  final AlertsNotification item;

  const AlertCard({super.key, required this.item});

  String formatAlertDate(DateTime? date) {
    if (date == null) return "";

    final dayMonth = DateFormat("dd MMM").format(date);
    final time = DateFormat("hh:mm a").format(date);

    return "$dayMonth | $time";
  }

  @override
  Widget build(BuildContext context) {

  //  final value = int.tryParse(item.ppmValue ?? "0") ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
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

      child: Row(
        children: [

        Semantics(
        label: "Alerts list",
        value: "alerts icon",
        child:
          Icon(
            key: ValueKey("Alerts icon"),
            Icons.warning_amber_rounded,
            color: Colors.grey.shade500,
            size: 26,
          ),),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// message
              Semantics(
              label: "Alerts list",
              value: "${item.message}",
              child:
                Text(
                  key: ValueKey("message item ${item.message}"),
                  item.message ?? "",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
                const SizedBox(height: 6),

                /// formatted date
            Semantics(
              label: "Alerts list",
              value: "${item.ppmTime}",
              child:
                Text(
                  key: ValueKey("date item ${item.ppmTime}"),
                  formatAlertDate(item.ppmTime),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
            ),
              ],
            ),
          ),

          /// value
      Semantics(
        label: "Alerts list",
        value: "${item.ppmValue}",
        child:
          Text(
            key: ValueKey("value item ${item.ppmValue}"),
            item.ppmValue.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),),
        ],
      ),
    );
  }
}
