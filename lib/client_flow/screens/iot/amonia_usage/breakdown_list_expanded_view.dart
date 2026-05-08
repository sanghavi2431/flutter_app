import 'package:flutter/material.dart';

import 'breakdown_expanded_list_item.dart';
import 'air_quality_model_from_api.dart';


class BreakdownListView extends StatelessWidget {

  final List<BreakdownItemModel> list;

  const BreakdownListView({super.key, required this.list});

  @override
  Widget build(BuildContext context) {

    return ListView.builder(

      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      itemCount: list.length,

      itemBuilder: (context, index) {

        return BreakdownListItem(
          model: list[index],
        );
      },
    );
  }
}
