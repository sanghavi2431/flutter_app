


import 'package:flutter/foundation.dart';
import 'package:get/state_manager.dart';
import 'package:get_it/get_it.dart';


import '../data/model/dashboard_model_class.dart';
import '../data/network/dashboard_service.dart';

 

  class DashController extends GetxController {


     final DashboardService dashboardService =
      DashboardService(dio: GetIt.instance());
       RxList<DashboardModelClass> data = <DashboardModelClass>[].obs;
         RxList<DashboardModelClass> filterData = <DashboardModelClass>[].obs;
   
      
mapGetDashboardToState()async{

          try {
            data.value = await dashboardService.getTasksByJanitorId();

             filterData.value = data;
            debugPrint(" get x data $data" );
          } catch (e) {
            debugPrint(e.toString());
          }

         }
 
  }