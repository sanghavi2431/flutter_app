

import 'dart:convert';
import 'dart:io';


import 'package:Woloo_Smart_hygiene/core/model/App_launch_model.dart';

import 'package:Woloo_Smart_hygiene/core/network/api_constant.dart';
import 'package:Woloo_Smart_hygiene/core/network/dio_client.dart';
import 'package:Woloo_Smart_hygiene/screens/dashboard/data/model/Attendance_model.dart';
import 'package:Woloo_Smart_hygiene/screens/dashboard/data/model/dashboard_model_class.dart';
import 'package:Woloo_Smart_hygiene/screens/dashboard/data/network/dashboard_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// import 'attendace_history_test.mocks.dart';
import 'dashbaord_test.mocks.dart';
// import 'unit_test.mocks.dart';

@GenerateMocks( [ http.Client])
void main()async{
  WidgetsFlutterBinding.ensureInitialized();

late DashboardService dashboardService;
  String mockToken = "";
  String taskId = "";


 group("Test Dashbaord Module API Endpoints", (){
    
    setUp(()async{
       
       var dio = Dio();
        dashboardService = DashboardService(dio: DioClient( dio));
      
           final file = File('assets/testData.json');
           final jsonData = json.decode(await file.readAsString());
            

              mockToken = jsonData['mockToken'];
              taskId = jsonData['taskId'];

    });



 
 
  test("test mark attendance api check in ", ()async{
        
           
        
             final client = MockClient();
        when(client
              .post(
                headers:{ 
   
    "x-woloo-token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTUyLCJyb2xlX2lkIjoxLCJpYXQiOjE3MzU4OTA0ODIsImV4cCI6MTczNjQ5NTI4Mn0.Uy90XgSfIlOyaPqDrxCkdbgV2grzHHaEKiG5FVNpRXE"
   
},
                body: {    
          "type": "check_in",
          "location": [19.0760,72.8777],
        },

                Uri.parse(APIConstants.BASE_URL+ APIConstants.ATTENDANCE )))
          .thenAnswer((_) async =>
              http.Response('{ "message": type is not allowed to be empty", "success": false,  "results": [] }', 404)   
             );
     

           var response = await dashboardService.markAttendance(
          type: "check_in", locations: [19.0760,72.8777 ], token: mockToken
          );
           // print("api reposnce  ${response.message} ");
          expect(response,  isA<AttendanceModel>() );

  });


   test("test mark attendance api check in expction ", ()async{
   

             final client = MockClient();
        when(client
              .post(
                headers:{ 
   
    "x-woloo-token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NDE2LCJyb2xlX2lkIjoxLCJpYXQiOjE3MzA4MDc5MzIsImV4cCI6MTczMTQxMjczMn0.cxN_JTM5VPmufui4DLFz2WcDfXmM9-HibkBgEJZpOfk"
   
},
                body: {    
          "type": "",
          "location": [19.0760,72.8777],
        },

                Uri.parse(APIConstants.BASE_URL+ APIConstants.ATTENDANCE )))
                //.thenThrow((e) { http.ClientException('Failed to load album'); } );
          .thenAnswer((_) async =>
              http.Response('Not Found', 400)
              
              );
     
               try {

            var response = await dashboardService.markAttendance(
          type: "", locations: [19.0760,72.8777 ]
          , token: mockToken
          );

            expect(response,  throwsException );
               }on Exception catch (exception) {

}
     catch ( e) {

                 
               }
 

  });







   test("test mark attendance api check out ", ()async{
      

             final client = MockClient();
        when(client
              .post(
                headers:{ 
    // "Accept": "application/json",
    // "Content-type": "application/json",
    "x-woloo-token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NDE2LCJyb2xlX2lkIjoxLCJpYXQiOjE3MzA4MDc5MzIsImV4cCI6MTczMTQxMjczMn0.cxN_JTM5VPmufui4DLFz2WcDfXmM9-HibkBgEJZpOfk"
    //  "x-woloo-token": "${mockGlobalStorage!.getToken()}"
    
   // "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NDE2LCJyb2xlX2lkIjoxLCJpYXQiOjE3MzA4MDc5MzIsImV4cCI6MTczMTQxMjczMn0.cxN_JTM5VPmufui4DLFz2WcDfXmM9-HibkBgEJZpOfk"
},
                body: {    
          "type": "check_out",
          "location": [19.0760,72.8777],
        },

                Uri.parse(APIConstants.BASE_URL+ APIConstants.ATTENDANCE )))
          .thenAnswer((_) async =>
              http.Response(' {"results":{"message":"Janitor checked_out successfully","attendance":{"last_attendance":{"time":"2024-11-06T10:31:10.009Z","type":"check_out","location":[19,20]},"last_attendance_date":"2024-11-05T23:30:39.421Z"}},"success":true} ', 200));
     

           var response = await dashboardService.markAttendance(
          type: "check_out", locations: [19.0760,72.8777], token: mockToken);

            // print("api reposnce  ${response.message} ");
          expect(response, isA<AttendanceModel>());

  });


     test("test mark attendance api check out exception  ", ()async{
    

             final client = MockClient();
        when(client
              .post(
                headers:{ 
   
    "x-woloo-token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NDE2LCJyb2xlX2lkIjoxLCJpYXQiOjE3MzA4MDc5MzIsImV4cCI6MTczMTQxMjczMn0.cxN_JTM5VPmufui4DLFz2WcDfXmM9-HibkBgEJZpOfk"
},
                body: {    
          "type": "",
          "location": [19.0760,72.8777],
        },

                Uri.parse(APIConstants.BASE_URL+ APIConstants.ATTENDANCE )))
                //.thenThrow((e) { http.ClientException('Failed to load album'); } );
          .thenAnswer((_) async =>
              http.Response('Not Found', 400)
              
              );
     
            try {

         var response = await dashboardService.markAttendance(
          type: "", locations: [19.0760,72.8777 ], token: mockToken
          );

            expect(response,  throwsException );
              
            } catch (e) {
              
            }


       

  });



      test("test on app load api ", ()async{
          
             final client = MockClient();
        when(client
              .post(
                Uri.parse(APIConstants.BASE_URL+ APIConstants.APP_LAUNCH )))
          .thenAnswer((_) async =>
              http.Response('  "results": {  "last_attendance": "check_in",  "last_attendance_date": "2024-11-05T23:30:39.421Z" },"success": true', 200)
              );
     

           var response = await dashboardService.appLaunch( token: mockToken );
          expect(response, isA<AppLaunchModel>());

  });


        test("test on app load api exception ", ()async{
          
             final client = MockClient();
        when(client
              .post(
                Uri.parse(APIConstants.BASE_URL+ APIConstants.APP_LAUNCH )))
          .thenAnswer((_) async =>
                           http.Response('Not Found', 400)
              );
      
           try {
                  var response = await dashboardService.appLaunch(
                    token: mockToken
                  );
          expect(response, throwsException );
             
           } catch (e) {
             
           }

     

  });



    test("test janitor list api ", ()async{
          
             final client = MockClient();
        when(client
              .get(


        //         body: {  
                    
        //   "type": "",
        //   "location": "",
        // },
                Uri.parse(APIConstants.BASE_URL+ APIConstants.JANITOR_LIST )))
          .thenAnswer((_) async =>
              http.Response(' {"results":[{"task_allocation_id":54190,"date":"06-11-2024","janitor_id":416,"request_type":"Regular","issue_description":null,"start_time":"04:00 AM","end_time":"07:00 AM","facility_id":474,"template_id":230,"template_name":"TemplateFloor","task_description":"Daily tasks","facility_name":"FacilityDustingFloors","estimated_time":120,"total_tasks":2,"booths":10,"floor_number":2,"location":"LocationHadpsar","lat":19.076,"lng":72.8777,"block_name":"BuildingBeta","pending_tasks":"0","status":"Request for closure"}],"success":true} ', 200));
     

           var response = await dashboardService.getTasksByJanitorId(
            token: mockToken
           );
          expect(response, isA<List<DashboardModelClass>>());

  });


    test("test janitor Attendance History ", ()async{
          
             final client = MockClient();
        when(client
              .get(
                Uri.parse(APIConstants.BASE_URL+ APIConstants.ATTENDANCE_HISTORY_LIST )))
          .thenAnswer((_) async =>
              http.Response(' {"results":[{"task_allocation_id":54190,"date":"06-11-2024","janitor_id":416,"request_type":"Regular","issue_description":null,"start_time":"04:00 AM","end_time":"07:00 AM","facility_id":474,"template_id":230,"template_name":"TemplateFloor","task_description":"Daily tasks","facility_name":"FacilityDustingFloors","estimated_time":120,"total_tasks":2,"booths":10,"floor_number":2,"location":"LocationHadpsar","lat":19.076,"lng":72.8777,"block_name":"BuildingBeta","pending_tasks":"0","status":"Request for closure"}],"success":true} ', 200));
     

           var response = await dashboardService.getTasksByJanitorId(
            token: mockToken
           );
          expect(response, isA<List<DashboardModelClass>>());

  });

     test("accept task testing  ", ()async{
          final client = MockClient();
        when(client
              .post(
                headers:{ 
            "x-woloo-token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTUyLCJyb2xlX2lkIjoxLCJpYXQiOjE3MzU4OTA0ODIsImV4cCI6MTczNjQ5NTI4Mn0.Uy90XgSfIlOyaPqDrxCkdbgV2grzHHaEKiG5FVNpRXE"
                 },
                body:
          {
          "id": [taskId],
          "status": "2",
        },
            Uri.parse(APIConstants.BASE_URL+ APIConstants.UPDATE_STATUS )))
          .thenAnswer((_) async =>
              http.Response(' {"results": { "current_Task_status": 2 },"success": true}', 200)
             );

           var response = await dashboardService.updateStatus(
            id: taskId,
            status: "2",
            token: mockToken
           );
          expect(response, "{current_Task_status: 2}" );

  });

    test("start task testing  ", ()async{
      final client = MockClient();
      when(client
          .post(
          headers:{
            "x-woloo-token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTUyLCJyb2xlX2lkIjoxLCJpYXQiOjE3MzU4OTA0ODIsImV4cCI6MTczNjQ5NTI4Mn0.Uy90XgSfIlOyaPqDrxCkdbgV2grzHHaEKiG5FVNpRXE"
          },
          body:
          {
            "id": [taskId],
            "status": "3",
          },
          Uri.parse(APIConstants.BASE_URL+ APIConstants.UPDATE_STATUS )))
          .thenAnswer((_) async =>
          http.Response(' {"results": { "current_Task_status": 2 },"success": true}', 200)
      );

      var response = await dashboardService.updateStatus(
          id: taskId,
          status: "3",
          token: mockToken
      );
      expect(response, "{current_Task_status: 3}" );

    });



    test(" request for closure task testing  ", ()async{
      final client = MockClient();
      when(client
          .post(
          headers:{
            "x-woloo-token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTUyLCJyb2xlX2lkIjoxLCJpYXQiOjE3MzU4OTA0ODIsImV4cCI6MTczNjQ5NTI4Mn0.Uy90XgSfIlOyaPqDrxCkdbgV2grzHHaEKiG5FVNpRXE"
          },
          body:
          {
            "id": [taskId],
            "status": "6",
          },
          Uri.parse(APIConstants.BASE_URL+ APIConstants.UPDATE_STATUS )))
          .thenAnswer((_) async =>
          http.Response(' {"results": { "current_Task_status": 2 },"success": true}', 200)
      );

      var response = await dashboardService.updateStatus(
          id: taskId,
          status: "6",
          token: mockToken
      );
      expect(response, "{current_Task_status: 6}" );

    });








 });


}