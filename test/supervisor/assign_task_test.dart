
import 'dart:convert';
import 'dart:io';

import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';
import 'package:woloo_smart_hygiene/screens/assign_screen/network/assign_services.dart';
import 'package:woloo_smart_hygiene/screens/dashboard/data/model/dashboard_model_class.dart';
import 'package:woloo_smart_hygiene/screens/janitor_screen/data/model/reassign_janitor_model.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:woloo_smart_hygiene/screens/assign_screen/data/janitor_list_model.dart';
import 'assign_task_test.mocks.dart';

@GenerateMocks( [ http.Client])
void main() {
  
 late AssignService assignService;
  String? mockToken = "";
  int? id;
  int? facilityId;
  String?  taskId;


  group("Attendance Histort testing", (){

       
    setUp(()async{
       
       var dio = Dio();
        assignService = AssignService(dio:  DioClient( dio)  ); 
           final file = File('assets/testData.json');
           final jsonData = json.decode(await file.readAsString());
            id = jsonData['id'];
            facilityId = jsonData['facilityId'];
            taskId = jsonData['taskId'];
            mockToken = jsonData['mockSupervisorToken'];
    });
 


     
     test(" get all template end point testing",  ()async {

          final client = MockClient();
        when(client
              .get(
                Uri.parse("${APIConstants.BASE_URL}+ ${APIConstants.GET_ALL_TASK_TAMPLATES}?janitor_id=$id")))
          .thenAnswer((_) async =>
              http.Response(' {"results":[{"id":65,"facility_name":"womens powder room"},{"id":66,"facility_name":"womens powder room"},{"id":101,"facility_name":"metro washroom"}],"success":true} ', 200));
     
         //  var response = await clusterListService.getAllCluster( token: mockToken);
               var response =  await  assignService.getTasksByJanitorId(id! ,token: mockToken );
                 expect(response, isA<List<DashboardModelClass>>());

     }, );


          test(" get all template end point exception testing",  ()async {
       
      
          final client = MockClient();

        when(client
              .get(
                Uri.parse("${APIConstants.BASE_URL}+ ${APIConstants.GET_ALL_TASK_TAMPLATES}?janitor_id=$id")))
          .thenAnswer((_) async =>
               http.Response('Not Found', 400));
            //  http.Response(' {"results":[{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"01","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"02","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"03","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"04","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sat","date":"05","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"06","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"07","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"08","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"09","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"10","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"11","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sat","date":"12","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"13","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"14","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"15","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"16","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"17","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"18","attendance":"Absent"},{"check_in":"05:15 PM","check_out":"04:40 PM","day_of_week":"Sat","date":"19","attendance":"Present"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"20","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"21","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"22","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"23","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"24","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"25","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sat","date":"26","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"27","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"28","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"29","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"30","attendance":"Absent"},{"check_in":"09:42 AM","check_out":"04:40 PM","day_of_week":"Thu","date":"31","attendance":"Present"}],"success":true}', 200));
          try {
               await assignService.getTasksByJanitorId(id!,token: "" );
              ///  expect(response, throwsException );
            
          } 
          catch 
          (e) {

            expect( e.toString(),  '{message: Forbidden, success: false, result: []}');
          }
        

     }, );




      test(" get janitor list by facility id end point testing",  ()async {
       
      
          final client = MockClient();
        when(client
              .get(
                Uri.parse("${APIConstants.BASE_URL}+ ${APIConstants.JANITOR_LIST_FACILITY}?janitor_id=$id")))
          .thenAnswer((_) async =>
              http.Response('{"results": { "data": [   {  "id": 156, "name": "priya  M","mobile": "8485066527",  "city": "pune", "address": "test", "status": true,"email": "priya@gmail.com",  "total": 8  } ], "total": 8}, "success": true}', 200));
     
         //  var response = await clusterListService.getAllCluster( token: mockToken);
               var response =  await assignService.getanitorListByFacilityId(facilityId!,token: mockToken );
                 expect(response, isA<List<JanitorListModel>>());

     }, );



          test(" get janitor list by facility exception testing",  ()async {
       
      
          final client = MockClient();

        when(client
              .get(
                Uri.parse("${APIConstants.BASE_URL}+ ${APIConstants.JANITOR_LIST_FACILITY}?janitor_id=$id")))
          .thenAnswer((_) async =>
               http.Response('Not Found', 400));
            //  http.Response(' {"results":[{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"01","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"02","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"03","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"04","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sat","date":"05","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"06","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"07","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"08","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"09","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"10","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"11","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sat","date":"12","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"13","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"14","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"15","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"16","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"17","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"18","attendance":"Absent"},{"check_in":"05:15 PM","check_out":"04:40 PM","day_of_week":"Sat","date":"19","attendance":"Present"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"20","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"21","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"22","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"23","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"24","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"25","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sat","date":"26","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"27","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"28","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"29","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"30","attendance":"Absent"},{"check_in":"09:42 AM","check_out":"04:40 PM","day_of_week":"Thu","date":"31","attendance":"Present"}],"success":true}', 200));
          try {
            
              var response = await assignService.getanitorListByFacilityId(id!, token: "" );

                expect(response, throwsException );
            
          } catch (e) {
            expect( e.toString(),  '{message: Forbidden, success: false, result: []}');

          }
        

     }, );






        test(" get janitor list by facility id end point testing",  ()async {
       
      
          final client = MockClient();
        when(client
              .get(
                Uri.parse("${APIConstants.BASE_URL}+ ${APIConstants.JANITOR_LIST_FACILITY}?janitor_id=$id")))
          .thenAnswer((_) async =>
              http.Response('{"results": { "data": [   {  "id": 156, "name": "priya  M","mobile": "8485066527",  "city": "pune", "address": "test", "status": true,"email": "priya@gmail.com",  "total": 8  } ], "total": 8}, "success": true}', 200));
     
         //  var response = await clusterListService.getAllCluster( token: mockToken);
               var response =  await assignService.getanitorListByFacilityId(facilityId!,token: mockToken );
                 expect(response, isA<List<JanitorListModel>>());

     }, );





         test(" reassing task end point testing",  ()async {
       
      
          final client = MockClient();
        when(client
              .get(
                Uri.parse("${APIConstants.BASE_URL}+ ${APIConstants.GET_ALL_TASK_TAMPLATES}?janitor_id=$id")))
          .thenAnswer((_) async =>
              http.Response(' {"results":[{"id":65,"facility_name":"womens powder room"},{"id":66,"facility_name":"womens powder room"},{"id":101,"facility_name":"metro washroom"}],"success":true} ', 200));
     
         //  var response = await clusterListService.getAllCluster( token: mockToken);
               var response =         await  assignService.reAssignPendingTaskToJanitor(
        id: [taskId.toString()],
        endTime: "2025-01-07 13:13:00",
        startTime: "2025-01-07 12:13:00",
        isAssign:  true,
        janitorId: 156,
        isRejected:  false,
        token: mockToken
        // status: event.status

      ) ;
               
               // assignService.getTasksByJanitorId(id! ,token: mockToken );
                 expect(response, isA<ReassignJanitorModel>());

     }, );



             test(" reassing task end point testing fail",  ()async {
       
      
          final client = MockClient();
        when(client
              .get(
                Uri.parse("${APIConstants.BASE_URL}+ ${APIConstants.GET_ALL_TASK_TAMPLATES}?janitor_id=$id")))
          .thenAnswer((_) async =>
                  http.Response('Not Found', 400));
           //   http.Response(' {"results":[{"id":65,"facility_name":"womens powder room"},{"id":66,"facility_name":"womens powder room"},{"id":101,"facility_name":"metro washroom"}],"success":true} ', 200));
     
               try {

        var response =  
         await  assignService.reAssignPendingTaskToJanitor(
        id: [taskId.toString()],
        endTime: "2025-01-07 13:13:00",
        startTime: "",
        isAssign:  true,
        janitorId: 156,
        isRejected:  false,
        token: mockToken
        // status: event.status
      ) ;
          
               // assignService.getTasksByJanitorId(id! ,token: mockToken );
              expect(response, throwsException);
                 
               } catch (e) {
                 expect( e.toString(),  '{message: invalid input syntax for type timestamp: "", success: false}');
               }
      
         //  var response = await clusterListService.getAllCluster( token: mockToken);

     }, );

  });

}