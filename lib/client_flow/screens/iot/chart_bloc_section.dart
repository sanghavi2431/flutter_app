import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../dashbaord/data/model/facility_dropdown_model.dart';
import '../dashbaord/bloc/dashboard_event.dart';
import '../dashbaord/bloc/dashboard_state.dart';


class ChartsBlocListener {

  static void handle(
      BuildContext context,
      DashboardState state,
      widget,
      bloc,
      List<FacilityDropdownModel> facilitydropdownNames,
      Function(FacilityDropdownModel) setSelectItem,
      String clientId,
      ) {

    if (state is DashboarLoading) {
      EasyLoading.show(status: state.message);
    }

    if (state is GetAllJanitor) {

      EasyLoading.dismiss();

      final janitors = state.taskModel!.results!.data!;

      for (var janitor in janitors) {
        facilitydropdownNames.add(
          FacilityDropdownModel(
            facilityName: janitor.name,
            id: janitor.id,
          ),
        );
      }

      setSelectItem(facilitydropdownNames.first);

      bloc.add(
        GetDashbaordEvent(
          type: widget.daysType ?? "today",
          clientId: clientId,
          janitorId: facilitydropdownNames.first.id.toString(),
          locationId: widget.facilityId,
        ),
      );
    }

    if (state is DashboarError) {
      EasyLoading.dismiss();
      EasyLoading.showError(state.error);
    }
  }
}