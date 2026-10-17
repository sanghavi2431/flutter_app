import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/model/tasktime_model.dart';

class DashBoardController extends GetxController {
  RxList<TimeOfDay> taskStartTime = <TimeOfDay>[].obs;
  RxList<String> facalityName = <String>[].obs;
  RxList<String> facalityType = <String>[].obs;
  RxList<TimeOfDay> taskEndTime = <TimeOfDay>[].obs;
  RxList<Map<String, dynamic>> taskTimes = <Map<String, dynamic>>[].obs;
  RxList<TaskTimeModel> taskTimeModel = <TaskTimeModel>[].obs;
  RxList<String> selectedDays = <String>[].obs;

  RxInt? estimatedTime;

   // ---------------- TASK TIME ----------------

  // ---------------- ADMIN FLOW ----------------
  RxInt selectedAdmin = (-1).obs;
  RxBool isAdminSelected = false.obs;
  RxBool isSelfAssign = false.obs;
  RxString errorAdminMessage = ''.obs;

  // ---------------- JANITOR FLOW ----------------
  RxInt selectedJanitor = (-1).obs;
  RxString errorJanitorMessage = ''.obs;

  // ---------------- FORM ----------------
  final GlobalKey<FormState> addSuperVisorKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  // ---------------- DATA LISTS ----------------
  List<dynamic> admin = [];
  List<dynamic> janitorList = [];

  // ---------------- VALIDATORS ----------------
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Enter full name";
    }
    return null;
  }

  String? validateMobile(String? value) {
    if (value == null || value.length != 10) {
      return "Enter valid mobile number";
    }
    return null;
  }
}
