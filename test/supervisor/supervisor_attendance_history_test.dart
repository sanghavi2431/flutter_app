


import 'dart:convert';
import 'dart:io';

import 'package:Woloo_Smart_hygiene/core/network/api_constant.dart';
import 'package:Woloo_Smart_hygiene/core/network/dio_client.dart';
import 'package:Woloo_Smart_hygiene/screens/attendance_history_screen/data/model/Attendance_history_model.dart';
import 'package:Woloo_Smart_hygiene/screens/attendance_history_screen/data/model/Month_list_model.dart';
import 'package:Woloo_Smart_hygiene/screens/janitor_details_screen/network/janitor_attendance_service.dart';
import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'supervisor_attendance_history_test.mocks.dart';
@GenerateMocks( [ http.Client])
void main() {


  JanitorAttendanceService? janitorAttendanceService ;
  String? mockToken = "";
  int? janitorId;

  group("Attendance Histort testing", (){
      


      setUp(()async{
       
       var dio = Dio();
        janitorAttendanceService = JanitorAttendanceService(dio:  DioClient( dio)  ); 
           final file = File('assets/testData.json');
           final jsonData = json.decode(await file.readAsString());
          
            mockToken = jsonData['mockSupervisorToken'];
            janitorId = jsonData['janitorId'];
         
  
    });


         test("attendace history get month end point testing",  ()async {
       
      
          final client = MockClient();
        when(client
              .get(
            
                Uri.parse("${APIConstants.BASE_URL}+${APIConstants.MONTH_LIST_SUP}?janitorId=$janitorId"))) 
                 
                
          .thenAnswer((_) async =>
             http.Response('{"results":[{"month":"2","year":"2024"},{"month":"3","year":"2024"},{"month":"4","year":"2024"},{"month":"5","year":"2024"},{"month":"6","year":"2024"},{"month":"7","year":"2024"},{"month":"8","year":"2024"},{"month":"9","year":"2024"},{"month":"10","year":"2024"},{"month":"11","year":"2024"},{"month":"12","year":"2024"}],"success":true} ', 200));
     
           var response = await janitorAttendanceService!.getAllMonths( janitorId!, token: mockToken);
          expect(response, isA<List<MonthListModel>>());

     }, );


            test("attendace history end point testing exception ",  ()async {
       
      
          final client = MockClient();
           when(client
              .get(
            
                Uri.parse("${APIConstants.BASE_URL}+${APIConstants.MONTH_LIST_SUP}?janitorId=$janitorId"))) 
                 
                
          .thenAnswer((_) async =>
              http.Response('Not Found', 400));
          //  http.Response(body, statusCode)
           //  http.Response('{"results":[{"month":"2","year":"2024"},{"month":"3","year":"2024"},{"month":"4","year":"2024"},{"month":"5","year":"2024"},{"month":"6","year":"2024"},{"month":"7","year":"2024"},{"month":"8","year":"2024"},{"month":"9","year":"2024"},{"month":"10","year":"2024"},{"month":"11","year":"2024"},{"month":"12","year":"2024"}],"success":true} ', 200));
     
          try {
                var response = await janitorAttendanceService!.getAllMonths( janitorId!, token: mockToken);
          expect(response, isA<List<MonthListModel>>());
            
          } catch (e) {
            
          }
       
     }, );



       test("attendace history end point testing",  ()async {
       
      
          final client = MockClient();
        when(client
              .post(
                body: {
          "month": "1",
          "year": "2025",
        },
                Uri.parse(APIConstants.BASE_URL+ APIConstants.ATTENDANCE_HISTORY_LIST )))
          .thenAnswer((_) async =>
              http.Response(' {"results":[{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"01","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"02","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"03","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"04","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sat","date":"05","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"06","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"07","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"08","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"09","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"10","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"11","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sat","date":"12","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"13","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"14","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"15","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"16","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"17","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"18","attendance":"Absent"},{"check_in":"05:15 PM","check_out":"04:40 PM","day_of_week":"Sat","date":"19","attendance":"Present"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"20","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"21","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"22","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"23","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"24","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"25","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sat","date":"26","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"27","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"28","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"29","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"30","attendance":"Absent"},{"check_in":"09:42 AM","check_out":"04:40 PM","day_of_week":"Thu","date":"31","attendance":"Present"}],"success":true}', 200));
     
           var response = await janitorAttendanceService!.getAllHistory( janiId: janitorId!,  month: "10", year: "2024", token: mockToken);
          expect(response, isA<List<AttendanceHistoryModel>>());

     }, );



        test("attendace history end point exception testing",  ()async {
       
      
          final client = MockClient();
        when(client
              .post(
                body: {
          "month": "",
          "year": "2024",
        },
                Uri.parse(APIConstants.BASE_URL+ APIConstants.ATTENDANCE_HISTORY_LIST )))
          .thenAnswer((_) async =>
               http.Response('Not Found', 400));
            //  http.Response(' {"results":[{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"01","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"02","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"03","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"04","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sat","date":"05","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"06","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"07","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"08","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"09","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"10","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"11","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sat","date":"12","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"13","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"14","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"15","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"16","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"17","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"18","attendance":"Absent"},{"check_in":"05:15 PM","check_out":"04:40 PM","day_of_week":"Sat","date":"19","attendance":"Present"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"20","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"21","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"22","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"23","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Thu","date":"24","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Fri","date":"25","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sat","date":"26","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Sun","date":"27","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Mon","date":"28","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Tue","date":"29","attendance":"Absent"},{"check_in":null,"check_out":null,"day_of_week":"Wed","date":"30","attendance":"Absent"},{"check_in":"09:42 AM","check_out":"04:40 PM","day_of_week":"Thu","date":"31","attendance":"Present"}],"success":true}', 200));
          try {
               var response = await janitorAttendanceService!.getAllHistory(janiId: janitorId!,  month: "", year: "2024", token: mockToken);
          expect(response, throwsException );
            
          } catch (e) {
            
          }
        

     }, );
        


  
  }
  );

  
}