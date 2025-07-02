


  import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/model/tasktime_model.dart';

class DashBoardController extends GetxController {


    
    
     RxList<TimeOfDay> taskStartTime = <TimeOfDay>[].obs;
     RxList<String> facalityName = <String>[].obs;
     RxList<String> facalityType = <String>[].obs;
     RxList<TimeOfDay> taskEndTime = <TimeOfDay>[].obs;
     RxList<Map<String, String>> taskTimes = <Map<String, String>>[].obs;
     RxList<TaskTimeModel> taskTimeModel = <TaskTimeModel>[].obs;

     RxInt? estimatedTime;

  
  }