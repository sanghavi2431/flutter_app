


import 'dart:convert';
import 'dart:io';

import 'package:woloo_smart_hygiene/screens/janitor_screen/data/model/janitor_list_model.dart';
import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';
import 'package:woloo_smart_hygiene/screens/janitor_screen/data/model/reassign_janitor_model.dart';
import 'package:woloo_smart_hygiene/screens/janitor_screen/data/netwrok/janitor_list_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'janitor_list_test.mocks.dart';

@GenerateMocks( [ http.Client])
void main() {
  
 late JanitorListService clusterListService;
  String? mockToken = "";


  group("Attendance Histort testing", (){

       
    setUp(()async{
       
       var dio = Dio();
        clusterListService = JanitorListService(dio:  DioClient( dio)  );
     
                  final file = File('assets/testData.json');
            final jsonData = json.decode(await file.readAsString());
              mockToken =  jsonData["mockSupervisorToken"];
     // "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTUxLCJyb2xlX2lkIjoyLCJpYXQiOjE3MzYxNzg4NjksImV4cCI6MTczNjc4MzY2OX0.A9D7jTgG4-f2zkUbwouhjliYfPb2V3Nj2BWXsMKJcs8";

    });
 


     
     test(" get all janitors end point testing",  ()async {
       
      
          final client = MockClient();
        when(client
              .post(
                body: {
           "cluster_id": "0",
        },
                Uri.parse(APIConstants.BASE_URL+ APIConstants.JANITOR_LIST )))
          .thenAnswer((_) async =>
              http.Response(' {"id":52,"name":"sakshi sakshi","mobile":"9702102791","cluster_id":52,"cluster_name":"Gannaur","profile_image":null,"gender":"Female","base_url":"https://woloo-taskmanagement-s3bucket.s3.ap-south-1.amazonaws.com","pincode":null,"start_time":"29th Nov, 12:55 PM","end_time":"29th Nov, 01:10 PM","shift":"Evening","isPresent":true,"total":"25318","completed":"8","pending":"25289","ongoing":"1","accepted":"11","reopen":"0","requestForClosure":"6","rejects":"3","success":true} ', 200));
     
             

          var response = await clusterListService.getAllJanitors( clusterId: "0",  token: mockToken);

           expect(response, isA<List<JanitorListModel>>());
               
           


     }, );


          test(" get all janitors end point exception testing",  ()async {
       
      
          final client = MockClient();

        when(client

              .post(
                body:  {
           "cluster_id": "0",
        },
                Uri.parse(APIConstants.BASE_URL+ APIConstants.JANITOR_LIST ))
                )
          .thenAnswer((_) async =>
              http.Response('Not Found', 400));
            //  http.Response(' {"results":[{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"01","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"02","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"03","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"04","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sat","date":"05","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"06","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"07","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"08","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"09","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"10","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"11","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sat","date":"12","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"13","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"14","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"15","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"16","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"17","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"18","attendance":"Absent"},{"check_in":"05:15 PM","check_out":"04:40 PM","day_of_week":"Sat","date":"19","attendance":"Present"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"20","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"21","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"22","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"23","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"24","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"25","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sat","date":"26","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"27","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"28","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"29","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"30","attendance":"Absent"},{"check_in":"09:42 AM","check_out":"04:40 PM","day_of_week":"Thu","date":"31","attendance":"Present"}],"success":true}', 200));
          try {
              var response = await clusterListService.getAllJanitors( clusterId: "0", token: "");
                 expect(response, throwsException);
            
          } catch (e) {
                expect( e.toString(),  '{message: Forbidden, success: false, result: []}'); 
          }
        
     }, );


          test("  reassing janitor task end point testing",  ()async {
       
      
          final client = MockClient();
        when(client
              .post(
                body: 
             {
        "id": [122323],
        "janitor_id": "125",
        "Reassign": true
            },
                Uri.parse(APIConstants.BASE_URL+ APIConstants.JANITOR_LIST )))
          .thenAnswer((_) async =>
              http.Response(' {"id":52,"name":"sakshi sakshi","mobile":"9702102791","cluster_id":52,"cluster_name":"Gannaur","profile_image":null,"gender":"Female","base_url":"https://woloo-taskmanagement-s3bucket.s3.ap-south-1.amazonaws.com","pincode":null,"start_time":"29th Nov, 12:55 PM","end_time":"29th Nov, 01:10 PM","shift":"Evening","isPresent":true,"total":"25318","completed":"8","pending":"25289","ongoing":"1","accepted":"11","reopen":"0","requestForClosure":"6","rejects":"3","success":true} ', 200));

          var response = await clusterListService.reAssignTaskToJanitor(  id: [], isRejected: false, janitorId: "",   token: mockToken);
         expect(response, isA<ReassignJanitorModel>());
               
     }, );







  });

}