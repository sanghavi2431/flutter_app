
import 'dart:convert';
import 'dart:io';

import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';
import 'package:woloo_smart_hygiene/screens/janitor_screen/data/model/reassign_janitor_model.dart';
import 'package:woloo_smart_hygiene/screens/supervisor_dashboard/data/network/supervisor_dashboard_service.dart';
import 'package:woloo_smart_hygiene/screens/supervisor_dashboard/model/supervisor_model_dashboard.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'supervisor_dashboard_test.mocks.dart';
@GenerateMocks( [ http.Client])
void main() {
  
 late SupervisorDashboardService supervisorDashboardService;
  String? mockToken = "";
   String? taskId;


  group("Attendance Histort testing", (){

       
    setUp(()async{
       
       var dio = Dio();
        supervisorDashboardService = SupervisorDashboardService(dio:  DioClient( dio)  );

              final file = File('assets/testData.json');
            final jsonData = json.decode(await file.readAsString());
     mockToken = jsonData["mockSupervisorToken"];
     taskId =  jsonData["taskId"];     
    });
 




 
     
     test("get all task on supervisor dashboard end point testing",  ()async {
        
       var res =  {"task_allocation_id":2681881,"date":"07-01-2025","janitor_id":152,"updated_at":"2025-01-07T00:50:18.347Z","request_type":"Regular","start_time":"12:50 AM","end_time":"01:50 AM","facility_id":253,"template_id":267,"template_name":"Morning task template","description":"Cleaning task for janitor","facility_name":"Demo Client _facility","estimated_time":60,"total_tasks":1,"booths":1,"floor_number":0,"location":"location_1","lat":null,"lng":null,"janitor_name":"Shrirang Test","block_name":"Demo Client _block","pending_tasks":"0","status":"Pending","success":true};
      
          final client = MockClient();
        when(client
              .get(
                Uri.parse(APIConstants.BASE_URL+ APIConstants.GET_SUPERVISOR_DASHBOARD_DATA )))
          .thenAnswer((_) async =>
              http.Response(  jsonEncode(res) , 200));
     
           var response = await supervisorDashboardService.getSupervisorDashboardData( token: mockToken);
          expect(response, isA<List<SupervisorModelDashboard>>());

     }, );


          test("get all task on supervisor dashboard end point testing fail ",  ()async {
             
          final client = MockClient();
        when(client
              .get(
                Uri.parse(APIConstants.BASE_URL+ APIConstants.GET_SUPERVISOR_DASHBOARD_DATA )))
          .thenAnswer((_) async =>
               http.Response('{message: Forbidden, success: false, result: []}', 400));
          
          try {
             await supervisorDashboardService.getSupervisorDashboardData(token:"");

            
          } catch (e) {
             expect( e.toString(),  '{message: Forbidden, success: false, result: []}');
          }
     }, );


      // await _supervisorDashboardService.updateStatus(
      //     id: event.id, status: event.status);


        test(" task approve api testing  ", ()async{
          final client = MockClient();
        when(client
              .post(
                headers:{ 
            "x-woloo-token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTUyLCJyb2xlX2lkIjoxLCJpYXQiOjE3MzU4OTA0ODIsImV4cCI6MTczNjQ5NTI4Mn0.Uy90XgSfIlOyaPqDrxCkdbgV2grzHHaEKiG5FVNpRXE"
                 },
                body:
          {
          "id": [taskId],
          "status": 4,
        },
            Uri.parse(APIConstants.BASE_URL+ APIConstants.UPDATE_STATUS )))
          .thenAnswer((_) async =>
              http.Response(' {"results": { "current_Task_status": 4 },"success": true}', 200)
             );

          //  var response = await dashboardService.updateStatus(
          //   id: taskId,
          //   status: "2",
          //   token: mockToken
          //  );
           var response = await supervisorDashboardService.updateStatus(
            token: mockToken,
          id: taskId!, status: 4);
          expect(response, {'current_Task_status': 4} ,  );

  });


          test(" task reject api testing  ", ()async{
          final client = MockClient();
        when(client
              .post(
                headers:{ 
            "x-woloo-token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTUyLCJyb2xlX2lkIjoxLCJpYXQiOjE3MzU4OTA0ODIsImV4cCI6MTczNjQ5NTI4Mn0.Uy90XgSfIlOyaPqDrxCkdbgV2grzHHaEKiG5FVNpRXE"
                 },
                body:
          {
          "id": [taskId],
          "status": 7,
        },
            Uri.parse(APIConstants.BASE_URL+ APIConstants.UPDATE_STATUS )))
          .thenAnswer((_) async =>
              http.Response(' {"results": { "current_Task_status": 7 },"success": true}', 200)
             );

           var response = await supervisorDashboardService.updateStatus(
            token: mockToken,
          id: taskId!, status: 7);
          expect(response, {'current_Task_status': 7} ,  );

  });



      test("resassign task  supervisor dashboard end point testing",  ()async {
        
       var res =  {"task_allocation_id":2681881,"date":"07-01-2025","janitor_id":152,"updated_at":"2025-01-07T00:50:18.347Z","request_type":"Regular","start_time":"12:50 AM","end_time":"01:50 AM","facility_id":253,"template_id":267,"template_name":"Morning task template","description":"Cleaning task for janitor","facility_name":"Demo Client _facility","estimated_time":60,"total_tasks":1,"booths":1,"floor_number":0,"location":"location_1","lat":null,"lng":null,"janitor_name":"Shrirang Test","block_name":"Demo Client _block","pending_tasks":"0","status":"Pending","success":true};
      
          final client = MockClient();
        when(client
              .post(
                 body:  {  "id": [taskId],
                         "janitor_id": 126,},
                Uri.parse(APIConstants.BASE_URL+ APIConstants.GET_SUPERVISOR_DASHBOARD_DATA )))
          .thenAnswer((_) async =>
              http.Response(  jsonEncode(res) , 200));
     
           var response = await supervisorDashboardService.reAssignTaskToJanitor( 
             id: [taskId!],
            janitorId: "126",
             token: mockToken);
          expect(response, isA<ReassignJanitorModel>());

     }, );






  });

}