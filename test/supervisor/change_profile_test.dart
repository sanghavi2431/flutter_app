import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';
import 'package:woloo_smart_hygiene/screens/selfie_screen/data/network/selfie_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'change_profile_test.mocks.dart';

// import 'upload_image_test.mocks.dart';

// import 'your_file.dart'; // Import the file containing `uploadSelfie`

// class MockDio extends Mock implements Dio {}

@GenerateMocks( [ http.Client])
void main() {
  //late MockDio mockDio;
    String reqId = "";
     String mockToken = "";
  late SelfieService service;
   final client = MockClient();
    Map<String, dynamic>? decodedToken;
  setUp(() async{

         final file = File('assets/testData.json');
           final jsonData = json.decode(await file.readAsString());       
      
      mockToken = jsonData["mockToken"];
      
      // "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTUyLCJyb2xlX2lkIjoxLCJpYXQiOjE3MzU5MTUyOTEsImV4cCI6MTczNjUyMDA5MX0.GWrrMseWa1lsvr5FUjudP8jWiiEVCt-U7_jlPrde2tw";
     var dio = Dio();


       decodedToken = JwtDecoder.decode(mockToken);

      reqId =  jsonData["allocationId"];
      
      //'2527523';
   // mockDio = MockDio();
    service = SelfieService(dio:  DioClient( dio)); // Replace with your actual service class
  });

  test(' change profile api testing ', () async {
    final file = File('assets/images/splash_logo.png');
    const type = 'profile';
   
    
    const remarks = 'Test remark';

    // final response = Response(
    //   requestOptions: RequestOptions(path: APIConstants.UPLOAD_SELFIE),
    //   data: {'results': 'Upload successful'},
    //   statusCode: 200,
    // );

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
              http.Response('{"results": "Image successfully uploaded!","success": true}', 200)   
             );

    // when(client.post(
    //   APIConstants.UPLOAD_SELFIE,
    //   data: anyNamed('data'),
    //   options: anyNamed('options'),
    // )).thenAnswer((_) async => response);

        
          final result = await service.uploadSelfie(
      type: type,
      image: file,
      id: decodedToken!["id"].toString(),
      remarks: remarks,
      token: mockToken
    );
     expect(result, 'Image successfully uploaded!');
    
  

   
    // verify(mockDio.post(
    //   APIConstants.UPLOAD_SELFIE,
    //   data: anyNamed('data'),
    //   options: anyNamed('options'),
    // )).called(1);
  });



    test(' change profile api testing exception', () async {
    final file = File('assets/images/splash_logo.png');
    const type = 'selfie';
   
    
    const remarks = 'Test remark';

    // final response = Response(
    //   requestOptions: RequestOptions(path: APIConstants.UPLOAD_SELFIE),
    //   data: {'results': 'Upload successful'},
    //   statusCode: 200,
    // );

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
          "id":reqId,
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
        await service.uploadSelfie(
      type: type,
      image: file,
      id: "",
      remarks: remarks,
      token: mockToken

    );

       
     } catch (e) {
         expect( e.toString(),  '{message: "id" must be a number, success: false, results: []}');  
     }


    // verify(mockDio.post(
    //   APIConstants.UPLOAD_SELFIE,
    //   data: anyNamed('data'),
    //   options: anyNamed('options'),
    // )).called(1);
  });


}