
import 'package:equatable/equatable.dart';

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

const ClientSetUpEvent({
   
    required this.orgName,
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
    required this.facilityType
  });

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
 final  String roleId;
 final  String name;
 final  String mobile;
 final  String? clientId;
 final String? gender;
 final bool? isSelfAssign;
 final  List<int>? clusterId;
 

  const AddUserEvent({
   
             this.clientId,
             this.gender,
             this.isSelfAssign,
    required this.mobile,
    required this.roleId,
    required this.name,
    required this.clusterId,

 
  });

  @override
  List<Object?> get props => [
    clientId,
    gender,
    mobile,
    roleId,
    name

  ];
}

class AddJanitorEvent extends DashboardEvent {
 final  String roleId;
 final  String name;
 final  String mobile;
 final  String? clientId;
 final String? gender;
 final  List<int>? clusterId;
 

  const AddJanitorEvent({
   
             this.clientId,
             this.gender,
    required this.mobile,
    required this.roleId,
    required this.name,
    required this.clusterId,

 
  });

  @override
  List<Object?> get props => [
    clientId,
    gender,
    mobile,
    roleId,
    name

  ];
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

 final int locationId;
 final  String type;
 final  String clientId;
 final String janitorId;


  const GetDashbaordEvent({
           required  this.clientId,
           required  this.locationId,
           required  this.type,
           required this.janitorId

  });

  @override
  List<Object?> get props => [
    clientId,
    locationId,
    type
  ];
}



class AssignTaskEvent extends DashboardEvent {
   
   final int janitorId;
   final int clientId;
   final String shiftTime;
   final List<int?> taskIds;
   final String estimatedTime;
   final List<Map<String, String>> taskTimes;
   final String? facilityRef;
   final String? facilityId;


  const AssignTaskEvent({
    required  this.clientId,
    required  this.shiftTime,
    required  this.taskIds,
    required  this.estimatedTime,
    required  this.taskTimes,
    required   this.janitorId,
              this.facilityRef,
               this.facilityId
  });

  @override
  List<Object?> get props => [
    clientId,
    shiftTime,
    taskIds,
    estimatedTime,
    taskTimes,
    janitorId,
    facilityRef
  ];
}



class SubcriptionEvent extends DashboardEvent {
 final int id;
  const SubcriptionEvent({
           required  this.id,     
  });

  @override
  List<Object?> get props => [
    id,
  ];
}



class ExpiryEvent extends DashboardEvent {
  final int clientId;
  final int  days;
  const ExpiryEvent({ required this.clientId,  required this.days});

  @override
  List<Object?> get props => [
    clientId,
    days
    ];
}



class PaymentStatusEvent extends DashboardEvent {
  final String refId;
  // final int  days;
  const PaymentStatusEvent({ required this.refId, });

  @override
  List<Object?> get props => [
    refId
    ];
}



class GetAllJanitorEvent extends DashboardEvent {
 final int clientId;
  const GetAllJanitorEvent({
    required  this.clientId,     
  });


  @override
  List<Object?> get props => [
    clientId,
  ];
}



class FacilityByJanitorEvent extends DashboardEvent {
 final int clientId;
 final int facilityId;
  const FacilityByJanitorEvent({
    required  this.clientId,   
    required this.facilityId  
  });


  @override
  List<Object?> get props => [
    clientId,
  ];
}






class GetAllFacilityEvent extends DashboardEvent {
 final int clientId;
  const GetAllFacilityEvent({
           required  this.clientId,     
  });


  @override
  List<Object?> get props => [
    clientId,
  ];
}





class ClientEvent extends DashboardEvent {
 final int id;
  const ClientEvent({
      required  this.id,     
  });

  @override
  List<Object?> get props => [
    id,
  ];
}


class DeleteEvent extends DashboardEvent {
 final int taskId;
  const DeleteEvent({
      required  this.taskId,     
  });

  @override
  List<Object?> get props => [
    taskId,
  ];
}



class CheckSupvisorEvent extends DashboardEvent {
 final int id;
  const CheckSupvisorEvent({
      required  this.id,     
  });

  @override
  List<Object?> get props => [
    id,
  ];
}



class FacilityDeleteEvent extends DashboardEvent {
 final int locationId;
  final int clusterId;
   final int facilityId;
  const FacilityDeleteEvent({
      required  this.locationId,
      required this.clusterId,
      required this.facilityId     
  });

  @override
  List<Object?> get props => [
    locationId,
    clusterId,
    facilityId
  ];
}




class CheckTaskEvent extends DashboardEvent {
 final int janitorId;
 final String  startTime;
  final String  endTime;
  const CheckTaskEvent({
      required  this.janitorId,   
      required this.endTime,
      required this.startTime  
  });


  @override
  List<Object?> get props => [
    janitorId,
    startTime,
    endTime 
  ];
}