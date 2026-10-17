import 'package:flutter/material.dart';

import 'air_quality_model_from_api.dart';


class BreakdownListItem extends StatelessWidget {

  final BreakdownItemModel model;

  const BreakdownListItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(
            model.time,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 4),

          Row(
            children: [

              Text(
                "${model.value} ppb",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: model.usage / 100,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Text(
                "Usage - ${model.usage.toInt()}",
                style: const TextStyle(fontSize: 12),
              )
            ],
          ),

          const SizedBox(height: 4),

          Text(
            model.status,
            style: const TextStyle(
                color: Colors.green),
          ),
        ],
      ),
    );
  }
}
