


  import 'package:get/state_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

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

             filterData.value = data.value;
           print(" get x data $data" );
          } catch (e) {
            print(e);
          }

         }
 
  }