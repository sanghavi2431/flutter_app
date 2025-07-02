import 'dart:convert';
import 'dart:io';

import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';
import 'package:woloo_smart_hygiene/screens/my_account/data/model/profile_model.dart';
import 'package:woloo_smart_hygiene/screens/my_account/data/network/profile_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'get_profile_test.mocks.dart';

@GenerateMocks( [ http.Client])
void main() {
  

 late ProfileService profileService;
  String? mockToken = "";
    // String type = '';
     Map<String, dynamic>? decodedToken;
      //  String remarks = '';


  group("get proflie api testing ", (){

       
    setUp(()async{
       
       var dio = Dio();
       
        profileService = ProfileService(dio:  DioClient( dio) );
               final file = File('assets/testData.json');
              final jsonData = json.decode(await file.readAsString());
     
     mockToken =  jsonData["mockSupervisorToken"];
    
     
    //  type = jsonData["profileImageType"];
    //  remarks = jsonData["remarks"];
      
       decodedToken = JwtDecoder.decode(mockToken!);

     
    });
 



     test(" get profile end point testing",  ()async {
       
      
          final client = MockClient();
        when(client
              .get(
                Uri.parse("${APIConstants.BASE_URL}+ ${APIConstants.USER_DETAILS}?id=${decodedToken!["id"].toString()}")))
          .thenAnswer((_) async =>
              http.Response('{"results":{"start_time":null,"end_time":null,"mobile":"9820607568","address":"undefined","city":"Demo","profile_image":"["Images/Profile/1736319140069.jpg"]","status":{"label":"ACTIVE","value":true},"role_id":2,"email":"abhijeet@test.com","client_id":null,"client_name":{"label":"","value":""},"first_name":"Abhijeet","last_name":"Test","pan_image":"","aadhar_image":"","wish_certificate_image":"","cluster":[{"value":52,"label":"Gannaur"},{"value":15,"label":"ghatkopar 29"},{"value":136,"label":"Demo Client _cluster"}],"base_url":"https://woloo-taskmanagement-s3bucket.s3.ap-south-1.amazonaws.com"},"success":true}', 200));

         //  var response = await clusterListService.getAllCluster( token: mockToken);
               var response =  await  profileService.getProfile(supervisorId: decodedToken!["id"], token: mockToken);
                 expect(response, isA<ProfileModel>());

     }, );



          test(" get profile end point testing execption",  ()async {
        //  "${APIConstants.USER_DETAILS}?id=${supervisorId.toString()}",
      
          final client = MockClient();
        when(client
              .get(
                Uri.parse("${APIConstants.BASE_URL}+ ${APIConstants.USER_DETAILS}?id=${decodedToken!["id"].toString()}")))
          .thenAnswer((_) async =>
              http.Response('Not Found', 400));
            //  http.Response('{"results":{"start_time":null,"end_time":null,"mobile":"9820607568","address":"undefined","city":"Demo","profile_image":"[\"Images/Profile/1736319140069.jpg\"]","status":{"label":"ACTIVE","value":true},"role_id":2,"email":"abhijeet@test.com","client_id":null,"client_name":{"label":"","value":""},"first_name":"Abhijeet","last_name":"Test","pan_image":"","aadhar_image":"","wish_certificate_image":"","cluster":[{"value":52,"label":"Gannaur"},{"value":15,"label":"ghatkopar 29"},{"value":136,"label":"Demo Client _cluster"}],"base_url":"https://woloo-taskmanagement-s3bucket.s3.ap-south-1.amazonaws.com"},"success":true}', 200));

         //     var response = await clusterListService.getAllCluster( token: mockToken);

             try {

                    var response =  await  profileService.getProfile(supervisorId: decodedToken!["0"], token: mockToken );
                 
                 
                   expect(response,  throwsException );
               
             } catch (e) {
                 expect( e.toString(),  'type \'Null\' is not a subtype of type \'int\''); 
             }
          
        
     }, );


  });

}