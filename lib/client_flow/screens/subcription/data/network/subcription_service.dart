import 'package:dio/dio.dart';

import '../../../../../core/network/api_constant.dart';
import '../../../../../core/network/dio_client.dart';
import '../model/coins_model.dart';
import '../model/facility_status_model.dart';
import '../model/order_model.dart';
import '../model/plan_model.dart';
import '../model/plan_req_model.dart';

class SubcriptionService {
  final DioClient dio;
  const SubcriptionService({required this.dio});

  Future<OrderModel> creatOrder({

  required String clientId,
  required List<PlanReqModel> planReqModel,
  required bool isFromFacility,
   
   }) async {
    try {

      var response = await dio.post(
          options:  Options(extra: {"auth": true, "isSupervisor": true }),
        APIConstants.CREATE_OREDER,
        data:
      {
      "items": planReqModel.map((e) => e.toJson(isFromFacility)).toList(),
      // [
      //   {
      //       "item_type": "plan",
      //       "qty": 1,
      //       "item_id": 5
      //   }
      //    ],
      "client_id": clientId
    }
      );


       return OrderModel.fromJson(response);

    } catch (e) {
        print("erroeee$e");
      rethrow;
    }
  }



 Future<CoinsModel> getTask(
 
  

) async {
   
  try {
      

      CoinsModel coinsModel;


 
    var response = await dio.get(
      APIConstants.GET_USER_COINS,
      
      options:  Options(extra: {"auth": true, "isSupervisor": true}),
    );


    coinsModel = CoinsModel.fromJson(response);
     

   return coinsModel;
  } catch (e) {
    rethrow;
  }
}


 Future<FacilityStatusModel> getFacilityStatus({
  String? clientId,
  String? plan
  }
) async {
   
  try {
      

     FacilityStatusModel  facilityStatusModel;

    var response = await dio.get(
      "${APIConstants.GET_FACILITIES_STATUS}?clientId=$clientId&plan=$plan",  
      options:  Options(extra: {"auth": true, "isSupervisor": true}),
    );
    facilityStatusModel = FacilityStatusModel.fromJson(response);
    
   return facilityStatusModel;
  } catch (e) {
    rethrow;
  }
}





  Future<PlanModel> getPlan({

   String? clientId
   
   }) async {
    try {

      var response = await dio.post(
          options:  Options(extra: {"auth": true, "isSupervisor": true }),
        APIConstants.GET_PLAN,
        data:
      {
    "pageIndex":1,
    "pageSize":10,
    "query":"",
   "sort" : {
       "key" : "",
       "order" : ""
   }}
      );


       return PlanModel.fromJson(response);

    } catch (e) {
        print("erroeee$e");
      rethrow;
    }
  }








}
