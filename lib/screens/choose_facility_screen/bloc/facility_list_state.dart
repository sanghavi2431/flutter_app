import 'dart:math';

import 'package:Woloo_Smart_hygiene/core/network/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:Woloo_Smart_hygiene/screens/choose_facility_screen/data/model/Facility_list_model.dart';

abstract class FacilityListState extends Equatable {
  const FacilityListState();
}

class FacilityListInitial extends FacilityListState {
  @override
  List<Object> get props => [];
}

class FacilityListLoading extends FacilityListState {
  @override
  List<Object> get props => [];
}

class FacilityListSuccess extends FacilityListState {
  final List<FacilityListModel> data;

  const FacilityListSuccess({required this.data});

  @override
  List<Object?> get props => [data, Random().nextInt(100)];
}

class FacilityListError extends FacilityListState {
  final Failure error;
  const FacilityListError({required this.error});

  @override
  List<Object> get props => [error];
}


class FacilityListSelect extends FacilityListState {
final List<bool>? checkList;
  final  List<FacilityListModel>? list;
final  bool selectAll;
final List<String>? selectedIds;

const FacilityListSelect({required this.checkList, required this.selectAll, this.list, this.selectedIds });

  @override
  List<Object?> get props =>  [checkList];
}

class FacilityListUnSelect extends FacilityListState {
  final List<bool>? checkList;
  final  List<FacilityListModel>? list;
  final  bool selectAll;
  final List<String>? selectedIds;

  const FacilityListUnSelect({required this.checkList, required this.selectAll, this.list, this.selectedIds });

  @override
  List<Object?> get props =>  [checkList, list, checkList ];
}



// class  SelectIndivualsFacility extends FacilityListState {
//   final List<bool>? checkList;
//   final  List<FacilityListModel>? list;
//   final  bool selectAll;

//   const SelectIndivualsFacility({required this.checkList, required this.selectAll, this.list });

//   @override
//   List<Object?> get props =>  [checkList, selectAll, list ];
// }