import 'dart:math';

import 'package:equatable/equatable.dart';

import '../data/model/facility_list_model.dart';

abstract class FacilityListEvent extends Equatable {
  const FacilityListEvent();
}

class GetAllFacility extends FacilityListEvent {
  final String janitorId;

  const GetAllFacility({required this.janitorId});

  @override
  List<Object?> get props => [janitorId, Random().nextInt(100)];
}




class SelectAllFacility extends FacilityListEvent {
//  final List<bool>? checkList;
 final  bool? selectAll;
 final  List<FacilityListModel>? facilityListModel;
  const SelectAllFacility({ this.selectAll ,this.facilityListModel});

  @override
  List<Object?> get props =>  [];
}


class SelectOneFacility extends FacilityListEvent {
//  final List<bool>? checkList;
 final  bool? selectAll;
 final  List<FacilityListModel>? facilityListModel;
 final List<String>? selectedIds;
 const SelectOneFacility({ this.selectAll ,this.facilityListModel,this.selectedIds });

  @override
  List<Object?> get props =>  [];
}