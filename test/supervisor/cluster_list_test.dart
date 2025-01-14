import 'dart:convert';
import 'dart:io';

import 'package:Woloo_Smart_hygiene/core/network/api_constant.dart';
import 'package:Woloo_Smart_hygiene/core/network/dio_client.dart';
import 'package:Woloo_Smart_hygiene/screens/cluster_screen/data/model/Cluster_model.dart';
import 'package:Woloo_Smart_hygiene/screens/cluster_screen/data/network/cluster_list_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'cluster_list_test.mocks.dart';

@GenerateMocks( [ http.Client])
void main() {
  
 late ClusterListService clusterListService;
  String? mockToken = "";


  group("Attendance Histort testing", (){

       
    setUp(()async{
       
       var dio = Dio();
        clusterListService = ClusterListService(dio:  DioClient( dio)  );
     
                 final file = File('assets/testData.json');
           final jsonData = json.decode(await file.readAsString());
     mockToken = jsonData["mockSupervisorToken"];
     

    });
 


     
     test(" get all cluster end point testing",  ()async {
       
      
          final client = MockClient();
        when(client
              .post(
                body: {
          "month": "1",
          "year": "2025",
        },
                Uri.parse(APIConstants.BASE_URL+ APIConstants.CLUSTER_LIST )))
          .thenAnswer((_) async =>
              http.Response(' { "results": [ { "cluster_id": 15,"cluster_name": "ghatkopar 29",  "pincode": null,"pending_tasks": "26",  "completed_tasks": "0","ongoing_tasks": "0","accepted_tasks": "0","reopen_tasks": "0", "requestforclosuer_tasks": "0",  "rejects_tasks": "0","total_tasks": "26" },],"success": true} ', 200));
     
           var response = await clusterListService.getAllCluster( token: mockToken);

          expect(response, isA<List<ClusterModel>>());

     }, );


          test(" get all cluster end point exception testing",  ()async {
       
      
          final client = MockClient();

        when(client
              .get(
                Uri.parse(APIConstants.BASE_URL+ APIConstants.CLUSTER_LIST )))
          .thenAnswer((_) async =>
               http.Response('Not Found', 400));
            //  http.Response(' {"results":[{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"01","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"02","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"03","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"04","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sat","date":"05","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"06","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"07","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"08","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"09","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"10","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"11","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sat","date":"12","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"13","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"14","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"15","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"16","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"17","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"18","attendance":"Absent"},{"check_in":"05:15 PM","check_out":"04:40 PM","day_of_week":"Sat","date":"19","attendance":"Present"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"20","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"21","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"22","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"23","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"24","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"25","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sat","date":"26","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"27","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"28","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"29","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"30","attendance":"Absent"},{"check_in":"09:42 AM","check_out":"04:40 PM","day_of_week":"Thu","date":"31","attendance":"Present"}],"success":true}', 200));
          try {
               var response = await clusterListService.getAllCluster(token: "");
               expect(response, throwsException );
            
          } catch (e) {
            

          }
        

     }, );

  });

}