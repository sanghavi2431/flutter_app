

import 'dart:convert';
import 'dart:io';

import 'package:Woloo_Smart_hygiene/core/network/api_constant.dart';
import 'package:Woloo_Smart_hygiene/core/network/dio_client.dart';
import 'package:Woloo_Smart_hygiene/screens/my_account/data/model/profile_model.dart';
import 'package:Woloo_Smart_hygiene/screens/my_account/data/network/profile_service.dart';
import 'package:Woloo_Smart_hygiene/screens/selfie_screen/data/network/selfie_service.dart';
import 'package:Woloo_Smart_hygiene/utils/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'change_profile_test.mocks.dart';

@GenerateMocks( [ http.Client])
void main() {
  
 late SelfieService selfieService;
 late ProfileService profileService;
  String? mockToken = "";
   final file = File('assets/images/splash_logo.png');
    String type = '';
     Map<String, dynamic>? decodedToken;
       String remarks = '';


  group("Attendance Histort testing", (){

       
    setUp(()async{
       
       var dio = Dio();
        selfieService = SelfieService(dio:  DioClient( dio) );
        profileService = ProfileService(dio:  DioClient( dio) );
               final file = File('assets/testData.json');
              final jsonData = json.decode(await file.readAsString());
     
     mockToken =  jsonData["mockSupervisorToken"];
    // print("mock$mockToken"); 
     
     type = jsonData["profileImageType"];
     remarks = jsonData["remarks"];
      
       decodedToken = JwtDecoder.decode(mockToken!);
       print("idddd${decodedToken!["id"]}");
    });
 


     
     test("profile image upload end point testing",  ()async {
       
      
          final client = MockClient();
        when(client
              .post(
                body: {            
          "type": type,
          "id":decodedToken!["id"].toString(),
          "remarks": remarks,
          "image": file,
        },
                Uri.parse(APIConstants.BASE_URL+ APIConstants.CLUSTER_LIST )))
          .thenAnswer((_) async =>
              http.Response('{"results": "Image successfully uploaded!","success": true}', 200));
     
           var response = await selfieService.uploadSelfie( 
              type: MySelfieScreenConstants.IMAGE_TYPE_UPLOAD,
                          image:file,
                          id: decodedToken!["id"].toString(),
                          remarks: MySelfieScreenConstants.REMARKS,   
                          token: mockToken);

          expect(response, isA<String>());

     }, );

       

       test('Upload selfie  fail ', () async {
 
    final client = MockClient();
   
    
    // const remarks = 'Test remark';

    final response = Response(
      requestOptions: RequestOptions(path: APIConstants.UPLOAD_SELFIE),
      data: {'results': 'Upload successful'},
      statusCode: 200,
    );

    //  formData = FormData.fromMap({
    //     "type": type,
    //     "id": id,
    //     "remarks": remarks,
    //   });

         when(client
              .post(
                headers:{ 
   
    "x-woloo-token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTUyLCJyb2xlX2lkIjoxLCJpYXQiOjE3MzU4OTA0ODIsImV4cCI6MTczNjQ5NTI4Mn0.Uy90XgSfIlOyaPqDrxCkdbgV2grzHHaEKiG5FVNpRXE"
   
},
                body: {            
          "type": type,
          "id":decodedToken!["id"].toString(),
          "remarks": remarks,
          "image": file,
        },

                Uri.parse(APIConstants.BASE_URL+ APIConstants.UPLOAD_SELFIE )))
          .thenAnswer((_) async =>
            http.Response('Not Found', 400));

    // when(client.post(
    //   APIConstants.UPLOAD_SELFIE,
    //   data: anyNamed('data'),
    //   options: anyNamed('options'),
    // )).thenAnswer((_) async => response);


     try {
          final result = await selfieService.uploadSelfie(
      type: type,
      image: file,
      id: "",
      remarks: remarks,
      token: mockToken

    );

    expect(result, throwsException);
       
     } catch (e) {
       
     }


    // verify(mockDio.post(
    //   APIConstants.UPLOAD_SELFIE,
    //   data: anyNamed('data'),
    //   options: anyNamed('options'),
    // )).called(1);
  });




     test(" get profile end point testing",  ()async {
       
      
          final client = MockClient();
        when(client
              .get(
                Uri.parse("${APIConstants.BASE_URL}+ ${APIConstants.USER_DETAILS}?id=${decodedToken!["id"].toString()}")))
          .thenAnswer((_) async =>
              http.Response('{"results":{"start_time":null,"end_time":null,"mobile":"9820607568","address":"undefined","city":"Demo","profile_image":"[\"Images/Profile/1736319140069.jpg\"]","status":{"label":"ACTIVE","value":true},"role_id":2,"email":"abhijeet@test.com","client_id":null,"client_name":{"label":"","value":""},"first_name":"Abhijeet","last_name":"Test","pan_image":"","aadhar_image":"","wish_certificate_image":"","cluster":[{"value":52,"label":"Gannaur"},{"value":15,"label":"ghatkopar 29"},{"value":136,"label":"Demo Client _cluster"}],"base_url":"https://woloo-taskmanagement-s3bucket.s3.ap-south-1.amazonaws.com"},"success":true}', 200));

         //  var response = await clusterListService.getAllCluster( token: mockToken);
               var response =  await  profileService.getProfile(supervisorId: decodedToken!["id"], token: mockToken);
                 expect(response, isA<ProfileModel>());

     }, );



          test(" get profile end point testing execption",  ()async {
       
      
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
                 
                  print(response);
                   expect(response,  throwsException );
               
             } catch (e) {
               
             }
          
        
     }, );


  });

}