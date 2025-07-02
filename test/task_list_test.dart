




import 'dart:convert';
import 'dart:io';

import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';
import 'package:woloo_smart_hygiene/screens/task_list/data/model/create_task_model.dart';
import 'package:woloo_smart_hygiene/screens/task_list/data/model/task_list_model.dart';
import 'package:woloo_smart_hygiene/screens/task_list/data/network/task_list_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'task_list_test.mocks.dart';


@GenerateMocks( [ http.Client])
void main() {
  
 late TaskListService taskListService;
  String? mockToken = "";
    int? taskId;
    String allocationId = "";

  group("task list  testing", (){

       
    setUp(()async{
       
       var dio = Dio();
        taskListService = TaskListService(dio:  DioClient( dio)  );

                final file = File('assets/testData.json');
            final jsonData = json.decode(await file.readAsString());
            
          taskId =  jsonData["taskid"];
         mockToken = jsonData["mockToken"];
         allocationId =   jsonData["allocationId"]; 
         
    });
 


     
     test(" get all task  end point testing",  ()async {
       
      
          final client = MockClient();
        when(client
              .post(
                body: {
          "id":  taskId,
          
        },
                Uri.parse(APIConstants.BASE_URL+ APIConstants.GET_ALL_TASKS )))
          .thenAnswer((_) async =>
              http.Response('{"results": { "template_id": "267", "tasks": [{  "task_id": "97", "task_name": "Morning Cleaning"  }  ] }, "success": true}', 200));
     
          var response = await taskListService.getAllTasks( id: taskId!, token: mockToken);
       
       
         expect(response, isA<TaskListModel>());

     }, );


          test(" get all task  end point testing fail",  ()async {
       
      
          final client = MockClient();
        when(client
              .post(
                body: {
          "id":  taskId, 
        },
                Uri.parse(APIConstants.BASE_URL+ APIConstants.GET_ALL_TASKS )))
          .thenAnswer((_) async =>
           http.Response('{message: Forbidden, success: false, result: []}', 400));
            //  http.Response('{"results": { "template_id": "267", "tasks": [{  "task_id": "97", "task_name": "Morning Cleaning"  }  ] }, "success": true}', 200));
     


             try {
                   var response = await taskListService.getAllTasks( id: taskId!, token: "");
       
                     expect(response, throwsException );
                     // expect(response, isA<TaskListModel>());
               
             } catch (e) {
                expect( e.toString(),  '{message: Forbidden, success: false, result: []}');
             }
     

     }, );


          test(" submit task api testing",  ()async {
       
      
          final client = MockClient();
        when(client
              .post(
                body: {
             "data": "fake data", 
             
             
        },
                Uri.parse(APIConstants.BASE_URL+ APIConstants.SUBMIT_TASKS )))
          .thenAnswer((_) async =>  
           http.Response( ' { "results": "Task submitted!","success": true}', 200));
      
          
         var response = await taskListService.submitTask(  
          token: mockToken,
          createTaskModel:  CreateTaskModel(
             allocationId: allocationId,
            data: [InternalData(status: 1,
          taskId: "97",
          taskName: "Morning Cleaning",
         ) ]  ));

        expect(response, "Task submitted !" );


     }, );


               test(" submit task api testing fail",  ()async {
       
      
          final client = MockClient();
        when(client
              .post(
                body: {
             "data": "", 
             
             
        },
                Uri.parse(APIConstants.BASE_URL+ APIConstants.SUBMIT_TASKS )))
          .thenAnswer((_) async =>  
              http.Response('{message: "allocation_id" must be a number, success: false, results: []}', 400));
          // http.Response( ' { "results": "Task submitted!","success": true}', 200));
      
          

       try {
         await taskListService.submitTask(  
          token: mockToken,
          createTaskModel:  CreateTaskModel(
             allocationId: '',
            data: [InternalData(status: 1,
          taskId: "97",
          taskName: "Morning Cleaning",
         ) ]  ));

       
         
       } catch (e) {
          expect( e.toString(),  '{message: "allocation_id" must be a number, success: false, results: []}');
       }




     }, );


         test("  update all task  end point testing",  ()async {
       
      
          final client = MockClient();
        when(client
              .post(
                body: {
          "id":  taskId,
           "status":"4",
        },
                Uri.parse(APIConstants.BASE_URL+ APIConstants.UPDATE_STATUS )))
          .thenAnswer((_) async =>
              http.Response('{"results": { "template_id": "267", "tasks": [{  "task_id": "97", "task_name": "Morning Cleaning"  }  ] }, "success": true}', 200));
     
          var response = await taskListService.updateStatus( id:taskId.toString() , status:'3',  token: mockToken);
       
       
         expect(response, isA<TaskListModel>());

     }, );

  });

}