import 'package:equatable/equatable.dart';

import '../view/assign_task/others/client_setup_request_model.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class ClientSetUpEvent extends DashboardEvent {
  final String orgName;
  final String? unitNo;
  final String locality;
  final String? building;
  final String? floor;
  final String? landmark;
  final String? pincode;
  final String? locationId;
  final String? clusterId;
  final String? clientId;
  final String? address;
  final String? city;
  final String? facilityType;
  final String? mobile;
  // final String? clientId;

  const ClientSetUpEvent(
      {required this.orgName,
      this.unitNo,
      required this.locality,
      this.building,
      this.floor,
      this.landmark,
      this.pincode,
      //  this.clientId,
      this.locationId,
      this.clusterId,
      required this.mobile,
      required this.address,
      required this.city,
      required this.clientId,
      required this.facilityType});

  @override
  List<Object?> get props => [
        orgName,
        unitNo,
        locality,
        building,
        floor,
        landmark,
        pincode,
        locationId,
        clusterId,
        address,
        city,
        clientId,
        facilityType
      ];
}

class AddUserEvent extends DashboardEvent {
  final String roleId;
  final String name;
  final String mobile;
  final String? clientId;
  final String? gender;
  final bool? isSelfAssign;
  final List<int>? clusterId;
  final List<String>? languageCodes;

  const AddUserEvent({
    this.clientId,
    this.gender,
    this.isSelfAssign,
    required this.mobile,
    required this.roleId,
    required this.name,
    required this.clusterId,
    this.languageCodes,
  });

  @override
  List<Object?> get props =>
      [clientId, gender, mobile, roleId, name, languageCodes];
}

class AddJanitorEvent extends DashboardEvent {
  final String roleId;
  final String name;
  final String mobile;
  final String? clientId;
  final String? gender;
  final List<int>? clusterId;
  final List<String>? languageCodes;

  const AddJanitorEvent({
    this.clientId,
    this.gender,
    required this.mobile,
    required this.roleId,
    required this.name,
    required this.clusterId,
    this.languageCodes,
  });

  @override
  List<Object?> get props =>
      [clientId, gender, mobile, roleId, name, languageCodes];
}

class GetTaskEvent extends DashboardEvent {
  final String? category;
  const GetTaskEvent({
    this.category,
  });

  @override
  List<Object?> get props => [
        category,
      ];
}

class GetDashbaordEvent extends DashboardEvent {
  final int? locationId;
  final String type;
  final String clientId;
  final String janitorId;

  const GetDashbaordEvent(
      {required this.clientId,
      this.locationId,
      required this.type,
      required this.janitorId});

  @override
  List<Object?> get props => [clientId, locationId, type];
}

class AssignTaskEvent extends DashboardEvent {
  final int janitorId;
  final int clientId;
  final String shiftTime;
  final List<Map<String, dynamic>>
      taskTimes; // Now includes days, task_ids, estimated_time inside each item
  final String? facilityRef;
  final String? facilityId; // String type

  const AssignTaskEvent({
    required this.clientId,
    required this.shiftTime,
    required this.taskTimes,
    required this.janitorId,
    this.facilityRef,
    this.facilityId,
  });

  @override
  List<Object?> get props => [
        clientId,
        shiftTime,
        taskTimes,
        janitorId,
        facilityRef,
        facilityId,
      ];
}

class SubcriptionEvent extends DashboardEvent {
  final int id;
  const SubcriptionEvent({
    required this.id,
  });

  @override
  List<Object?> get props => [
        id,
      ];
}

class GetHostDetailsData extends DashboardEvent {
  final String id;
  const GetHostDetailsData({required this.id});

  @override
  List<Object?> get props => [id];
}

class ExpiryEvent extends DashboardEvent {
  final int clientId;
  final int days;
  const ExpiryEvent({required this.clientId, required this.days});

  @override
  List<Object?> get props => [clientId, days];
}

class PaymentStatusEvent extends DashboardEvent {
  final String refId;
  // final int  days;
  const PaymentStatusEvent({
    required this.refId,
  });

  @override
  List<Object?> get props => [refId];
}

class GetAllJanitorEvent extends DashboardEvent {
  final int clientId;
  const GetAllJanitorEvent({
    required this.clientId,
  });

  @override
  List<Object?> get props => [
        clientId,
      ];
}

class FacilityByJanitorEvent extends DashboardEvent {
  final int clientId;
  final int facilityId;
  const FacilityByJanitorEvent(
      {required this.clientId, required this.facilityId});

  @override
  List<Object?> get props => [
        clientId,
      ];
}

class FacilityTypeEvent extends DashboardEvent {
  final int clientId;

  const FacilityTypeEvent({
    required this.clientId,
  });

  @override
  List<Object?> get props => [
        clientId,
      ];
}

class GetAllFacilityEvent extends DashboardEvent {
  final int clientId;
  final int? clusterId;
  const GetAllFacilityEvent({
    required this.clientId,
    this.clusterId,
  });

  @override
  List<Object?> get props => [
        clientId,
        clusterId,
      ];
}

class ClientEvent extends DashboardEvent {
  final int id;
  const ClientEvent({
    required this.id,
  });

  @override
  List<Object?> get props => [
        id,
      ];
}

class DeleteEvent extends DashboardEvent {
  final int taskId;
  const DeleteEvent({
    required this.taskId,
  });

  @override
  List<Object?> get props => [
        taskId,
      ];
}

class CheckSupvisorEvent extends DashboardEvent {
  final int id;
  const CheckSupvisorEvent({
    required this.id,
  });

  @override
  List<Object?> get props => [
        id,
      ];
}

class GetSupvisorListEvent extends DashboardEvent {
  final int roleId;
  const GetSupvisorListEvent({
    required this.roleId,
  });

  @override
  List<Object?> get props => [
        roleId,
      ];
}

class FacilityDeleteEvent extends DashboardEvent {
  final int locationId;
  final int clusterId;
  final int facilityId;
  const FacilityDeleteEvent(
      {required this.locationId,
      required this.clusterId,
      required this.facilityId});

  @override
  List<Object?> get props => [locationId, clusterId, facilityId];
}

class CheckTaskEvent extends DashboardEvent {
  final int janitorId;
  final String startTime;
  final String endTime;
  const CheckTaskEvent(
      {required this.janitorId,
      required this.endTime,
      required this.startTime});

  @override
  List<Object?> get props => [janitorId, startTime, endTime];
}

class GetLanguagesEvent extends DashboardEvent {
  const GetLanguagesEvent();

  @override
  List<Object?> get props => [];
}

class SubmitClientFullSetupEvent extends DashboardEvent {
  final ClientFullSetupRequest request;

  SubmitClientFullSetupEvent({
    required this.request,
  });

  @override
  List<Object?> get props => [request];
}
