


import 'dart:math';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/check_task_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/client_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/facility_model.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/supervisor_model.dart';
import 'package:woloo_smart_hygiene/screens/task_list/data/model/task_list_model.dart';

import '../../../../../core/network/api_constant.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../../../screens/report_issue_screen/data/model/facility_dropdown_model.dart';
import '../model/check_supervisor.dart';
import '../model/client_setup_model.dart';
import '../model/dashboard_task_model.dart';
import '../model/delete_facility.dart';
import '../model/delete_model.dart';
import '../model/extend_expiry.dart';
import '../model/janitor_model.dart';
import '../model/payment_status.dart';
import '../model/subscription_model.dart';
import '../model/task_model.dart';
import '../model/tasklist_model.dart';

class DashboardService {
  final DioClient dio;
  const DashboardService({required this.dio});



Future<ClientSetupModel> clientSetup({

  required String orgName,
  required String unitNo,
  required String locality,
  required String clientId,
   required String address,
   String? building,
   String? floor,
   String? landmark,
   String? pincode,
  String? locationId,
  String? clusterId,
  required String? mobile,
 required String? city,
 required String? faciltyType,

}) async {
  try {

     ClientSetupModel clientSetupModel;
    // Data payload with all parameters
    Map<String, dynamic> data =
    {
  "location": locality,
  "address": address,
  "city": city,
  "client_id": clientId,
  "facility_name": orgName,
  "cluster_id": "",
  "facility_type": faciltyType,
  "pincode": pincode,
  "mobile": mobile,
  };
    // {
    //   "org_name": orgName,
    //   "unit_no": unitNo,
    //   "locality": locality,
    //   "location": locality,
    //   "address": address,
    //   "city": city,
    //   "building": "",
    //   "floor": "",
    //   "landmark": "",
    //   "pincode": pincode,
    //   "location_id": "sd" ?? "",  // Optional parameter with default value
    //   "cluster_id":  "",    // Optional parameter with default value
    //   "client_id": clientId,
    //   "facility_name": orgName,
    //   "facility_type": "Home"
    //
    // };


    var response = await dio.post(
      APIConstants.CLIENT_SETUP,
      data: data,
      options:  Options(extra: {"auth": true, "isSupervisor": true}),
    );

    clientSetupModel =  ClientSetupModel.fromJson(response);

    return clientSetupModel;
  } catch (e) {
    rethrow;
  }
}


 Future<SuperVisorModel> addUser({
 
  required String roleId,
  required String name,
  required String mobile,
  required String clientId,
           String? gender,
           bool? isSelfAssign,
  required  List<int>? clusterId,
  

}) async {
  try {
      SuperVisorModel superVisorModel;
    // Data payload with all parameters

      FormData formData = FormData();

      formData = FormData.fromMap({
        "role_id": roleId,
        "first_name": name,
        "cluster_ids":clusterId.toString(),
        // "last_name": locality,
        "mobile": mobile,
        "gender": gender,
        "isSelfAssign": isSelfAssign
      });


    var response = await dio.post(
      APIConstants.ADD_USER,
      data: formData,
      options:  Options(extra: {"auth": true, "isSupervisor": true}),
    );

    superVisorModel =  SuperVisorModel.fromJson(response);
    // clientModel =  ClientModel.fromJson(response);

    return superVisorModel;
  } catch (e) {
    rethrow;
  }
}



 Future<List<TaskDropdownModel>> getTask({
 
  required String category,


}) async {
   
  try {
      // List<TaskListModel> output = [];
 
    var response = await dio.get(
      '${APIConstants.GET_TASK}?category=$category',
      
      options:  Options(extra: {"auth": true, "isSupervisor": true}),
    );


    //  output.add();

      List<TaskDropdownModel> output = [];
      for (var item in response['results']) {
           // print( "testing ${item["required_time"] = 15 }");
           item["required_time"] = 15;
           output.add(TaskDropdownModel.fromJson(item));
      }


   return output;
  } catch (e) {
    rethrow;
  }
}


Future<DashbaordModel> getTaskDashboard({
 
  required int facilityId,
  required String type,
  required String clientId,
  required String janitorId
}) async {
  try {
      
     DashbaordModel dashbaordModel;
    // Data payload with all parameters
    Map<String, dynamic> data = 
     {
    // "location_id": locationId,
    "type": type,
    "client_id": int.parse(clientId),
       "facility_id": facilityId,
       "janitor_id": janitorId
	};

    var response = await dio.post(
      APIConstants.GET_TASK_DASHBOARD,
      data: data,
      options:  Options(
         
        extra: {"auth": true, "isSupervisor": true}),
    );

  dashbaordModel =  DashbaordModel.fromJson(response);

    return dashbaordModel;
  } catch (e) {
    rethrow;
  }
}

Future<TaskModel> getAllJanitor({
 
  // required int locationId,
  // required String type,
  required int clientId,
}) async {
  try {
      
     TaskModel dashbaordModel;
    // Data payload with all parameters
    Map<String, dynamic> data =
    {
      // "pageIndex": 1,
      // "pageSize": 10,
      // "sort": {
      //     "order": "",
      //     "key": ""
      // },
      // "query": "",
      // "total": 1,
      "role_id": 1,
      // "client_id": clientId
    };
//     {
//     "pageIndex": 1,
//     "pageSize": 10,
//     "sort": {
//         "order": "",
//         "key": ""
//     },
//     "query": "",
//     "total": 1,
//     "role_id": 1,
//     "client_id": clientId
// };
  //    {
  //   "location_id": locationId,
  //   "type": type,
  //   "client_id": clientId
	// };

    var response = await dio.post(
      APIConstants.GET_ALL_USER,
      data: data,
      options:  Options(extra: {"auth": true, "isSupervisor": true}),
    );

  dashbaordModel =  TaskModel.fromJson(response);

   print("all janitor $dashbaordModel");

    return dashbaordModel;
  } catch (e) {
    rethrow;
  }
}



 Future<SubscriptionModel> getSubscriptionExpiry({
 
  required int id,

}) async {
  try {
      
     SubscriptionModel subscriptionModel;
    // Data payload with all parameters
 

    var response = await dio.get(
     "${APIConstants.SubscriptionExpiry}?id=$id",
      options:  Options(extra: {"auth": true, "isSupervisor": true }),
    );

     subscriptionModel =  SubscriptionModel.fromJson(response);

    return subscriptionModel;
  } catch (e) {
    rethrow;
  }
}




  Future<bool> assignTask({

    required int clientId,
    required String shiftTime,
    required List<int?> taskIds,
    required String estimatedTime,
    required List<Map<String, String>> taskTimes,
    required int janitorId,
    required String facilityRef,
             String? facilityId,
  }) async {
    try {

      // DashbaordModel dashbaordModel;
      // Data payload with all parameters
      Map<String, dynamic> data =
      facilityId == null ? 
      {
        "client_id": clientId,
        "shift_time": shiftTime,
        "task_ids":taskIds,
        "estimated_time": estimatedTime,
        "task_times": taskTimes,
        "janitor_id": janitorId,
        "facility_ref": facilityRef,
      } :
      {
        "client_id": clientId,
        "shift_time": shiftTime,
        "task_ids":taskIds,
        "estimated_time": estimatedTime,
        "task_times": taskTimes,
        "janitor_id": janitorId,
        // "facility_ref": facilityRef,
        
        "facility_id": facilityId, // Assuming facility_id is not required here

      };
      var response = await dio.post(
        APIConstants.ASSIGN_TASK,
        data: data,
        options:  Options(extra: {"auth": true, "isSupervisor": true}),
      );

      // dashbaordModel =  DashbaordModel.fromJson(response);

      return response["results"];
    } catch (e) {
      rethrow;
    }
  }




 Future<ClientModel> getClient({
 
  required int id,

}) async {
  try {
      
     ClientModel clientModel;
    // Data payload with all parameters
 

    var response = await dio.get(
     "${APIConstants.GET_CLIENT_ID}?user_id=$id",
      options:  Options(extra: {"auth": true, "isSupervisor": true }),
    );

     clientModel =  ClientModel.fromJson(response);

    return clientModel;
  } catch (e) {
    rethrow;
  }
}


 Future<CheckSupervisorModel> checkSuperVisor({
 
  required int id,

}) async {
  try {
      
     CheckSupervisorModel checkSupervisor;
    // Data payload with all parameters
 

    var response = await dio.get(
     "${APIConstants.SUPERVISOR_CHECK}?client_id=$id",
      options:  Options(extra: {"auth": true, "isSupervisor": true}),
    );

     checkSupervisor =  CheckSupervisorModel.fromJson(response);

    return checkSupervisor;
  } catch (e) {
    rethrow;
  }
}





  Future<FacilityModel> getFacility({

    required int clientId,
   
  }) async {
    try {
        FacilityModel facilityModel;
      // Data payload with all parameters
      Map<String, dynamic> data =
     {
    "client_id": clientId,
    "isAll": 1
    };
      var response = await dio.post(
        APIConstants.GET_ALL_FACILITY,
        data: data,
        options:  Options(extra: {"auth": true, "isSupervisor": true}),
      );

       print("response: $response");

      facilityModel = FacilityModel.fromJson(response);
       print("response: $response");
      // dashbaordModel =  DashbaordModel.fromJson(response);

      return facilityModel;
    } catch (e) {
      rethrow;
    }
  }


  Future<CheckTaskModel> checkTaskTime({

    required int janitorId,
    required String startTime,
    required String endTime,
   
  }) async {
    try {
        CheckTaskModel checkTaskModel;
      // Data payload with all parameters
      Map<String, dynamic> data =
     {
    "janitor_id": janitorId,
    "start_time": startTime,
    "end_time": endTime,
      };

      var response = await dio.post(
        APIConstants.CHECK_TASK_TIME,
        data: data,
        options:  Options(extra: {"auth": true, "isSupervisor": true}),
      );




      checkTaskModel = CheckTaskModel.fromJson(response);
        print("dsfsd  $checkTaskModel");
      // dashbaordModel =  DashbaordModel.fromJson(response);

      return checkTaskModel;
    } catch (e) {
       print(" check modelr ressssss $e");
      rethrow;
    }
  }



//  {
//     "location_id": 42,
//     "type": "today",
//     "client_id": "62578"
// 	}


 Future<DeleteModel> deleteTask({
 
  required int taskId,

}) async {
  try {
      
     DeleteModel checkSupervisor;
    // Data payload with all parameters
 

    var response = await dio.delete(
     "${APIConstants.DELETE_TASK}?task_id=$taskId",
      options:  Options(extra: {"auth": true, "isSupervisor": true}),
    );

     checkSupervisor =  DeleteModel.fromJson(response);

    return checkSupervisor;
  } catch (e) {
    rethrow;
  }
}



 Future<DeleteFacilityModel> deleteFacility({
 
  required  int? locationId,
  required  int? clusterId,
  required int? facilityId,

}) async {
  try {
      
     DeleteFacilityModel checkSupervisor;
    // Data payload with all parameters

         Map<String, dynamic> data =
     {
    "location_id": locationId,
    "cluster_id": clusterId,
    "facility_id": facilityId
      };
 

    var response = await dio.delete(
     APIConstants.DELETE_FACILITY,
      options:  Options(extra: {"auth": true, "isSupervisor": true}),
      data: data
    );

     checkSupervisor =  DeleteFacilityModel.fromJson(response);

    return checkSupervisor;
  } catch (e) {
    rethrow;
  }
}


Future<ExtendExpiryModel> extendExpiry({
  required int clientId,
  required int days,
  // required int clientUserId,

    }) async {
    try {
      var response = await dio.post(
        APIConstants.EXTEND_EXPIRY,
       options:  Options(extra: {"auth": true, "isSupervisor": true}),
        data: {
             "client_id": clientId,
             "days": 15
        },
      );


      return ExtendExpiryModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }



  Future<PaymentStatusModel> paymentStatus({
  required String refranceId,
  // required int days,
  // required int clientUserId,

    }) async {
    try {
      var response = await dio.get(
       "${APIConstants.PAYMENT_STATUS}/$refranceId",
        options:  Options(extra: {"auth": true, "isSupervisor": true}),
        // data: {
        //      "client_id": clientId,
        //      "days": 15
        // },
      );


      return PaymentStatusModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

    Future<JanitorModel> facilityByJanitor({
  required int clientId,
  required int facilityId,
  // required int days,
  // required int clientUserId,

    }) async {
    try {
      
      var response = await dio.get(
       "${APIConstants.FACILITY_BY_JANITOR}?client_id=$clientId&facility_id=$facilityId",
        options:  Options(extra: {"auth": true, "isSupervisor": true}),
        // data: {
        //      "client_id": clientId,
        //      "days": 15
        // },
      );


      return JanitorModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }






}