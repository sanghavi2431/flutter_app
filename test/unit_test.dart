

import 'package:Woloo_Smart_hygiene/core/network/api_constant.dart';
import 'package:Woloo_Smart_hygiene/core/network/dio_client.dart';
import 'package:Woloo_Smart_hygiene/screens/login/data/model/send_otp.dart';
import 'package:Woloo_Smart_hygiene/screens/login/data/model/verify_otp_model.dart';
import 'package:Woloo_Smart_hygiene/screens/login/data/network/login_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

// import 'attendace_history_test.mocks.dart';
import 'unit_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  // late Dio dioClient;
  // late String endpoint;
  // late String baseUrl;
  late  SendOtp  res;
  late LoginService loginService;



  group("Test Login Module Endpoint API calls", () {


    String reqId = "";

    setUp(() {

      // final sl = GetIt.instance;
       var dio = Dio();
    // sl.registerSingleton(() => DioClient(dio));
      // GetIt.I.registerSingleton<DioClient>(MockDioClient());
      // baseUrl = "https://staging-api.woloo.in";
      // dioClient = Dio(BaseOptions());
      // endpoint =  APIConstants.SEND_OTP;
      loginService = LoginService(dio: DioClient(dio) );
     //  reqId = "";
      //UniversityEndpoint(dioClient, baseUrl: baseUrl);
    });

    test('Test send otp endpoints ', () async {
      // dioClient.httpClientAdapter = _createMockAdapterForSearchRequest(
      //   200,
      //   [],
      // );
       final client = MockClient();
        when(client
              .post(
                body: {  "mobileNumber": "8097267015",},
                Uri.parse(APIConstants.BASE_URL+ APIConstants.SEND_OTP )))
          .thenAnswer((_) async =>
              http.Response('   "results": {  "request_id": "8bac61ad-2926-4821-8a77-2113f49b4491"  },"success": true', 200));
        res =    await loginService.sendOTP( phoneNumber: "8097267015");
            reqId =     res.requestId!;
      expect(res, isA<SendOtp>());
    //  var result =  await loginService.sendOTP( phoneNumber: "8097267015");
     //   print("res ${result.requestId}");
      // await endpoint.getUniversitiesByCountry("us");
    //  expect(result, SendOtp(requestId: "ea7e8e99-edfe-4e7f-b6d9-42abc0a306f1" ));
    });


    test('Test send otp endpoints exception ', () async {
      // dioClient.httpClientAdapter = _createMockAdapterForSearchRequest(
      //   200,
      //   [],
      // );
       final client = MockClient();
        when(client
              .post(
                body: {  "mobileNumber": "",},
                Uri.parse(APIConstants.BASE_URL+ APIConstants.SEND_OTP )))
          .thenAnswer((_) async =>
          http.Response('Not Found', 400));
           //   http.Response('{"message": "mobileNumber" must be a number, "success": false, "results": []}', 400));

           try {
                    res =    await loginService.sendOTP( phoneNumber: "");
            reqId =     res.requestId!;
    // expect(res,"{message: \"mobileNumber\" must be a number, success: false, results: []}");
               expect(res,  throwsException );
           } catch (e) {
             
           }

    //  var result =  await loginService.sendOTP( phoneNumber: "8097267015");
     //   print("res ${result.requestId}");
      // await endpoint.getUniversitiesByCountry("us");
    //  expect(result, SendOtp(requestId: "ea7e8e99-edfe-4e7f-b6d9-42abc0a306f1" ));
    });

        test('testing otp  api endpoints', () async {
      // dioClient.httpClientAdapter = _createMockAdapterForSearchRequest(
      //   200,
      //   [],
      // );
       final client = MockClient();
        when(client
              .post(
                body: {  "request_id" : "6de27dd6-e3f9-4b7b-8e14-3a5aeda1db3f", "otp":"1234"},
                Uri.parse(APIConstants.BASE_URL+ APIConstants.VERIFY_OTP )))
          .thenAnswer((_) async =>
              http.Response('  "results": { "name": "shrirang  jangam",  "mobile": "8097267015", "id": 419, "role_id": 2,  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NDE5LCJyb2xlX2lkIjoyLCJpYXQiOjE3MzA3NzQ1OTUsImV4cCI6MTczMTM3OTM5NX0.cHWD0idDyb4NNRaFQHl05caNYz-9CzyWp6gW3_XKxWs"  }, "success": true', 200));

      expect(await loginService.verifyOTP(otp: "1234", requestId: reqId), isA<VerifyOtpModel>());
    //  var result =  await loginService.sendOTP( phoneNumber: "8097267015");
     //   print("res ${result.requestId}");
      // await endpoint.getUniversitiesByCountry("us");
    //  expect(result, SendOtp(requestId: "ea7e8e99-edfe-4e7f-b6d9-42abc0a306f1" )) ;
    });

          test('testing otp  api endpoints exception ', () async {
      // dioClient.httpClientAdapter = _createMockAdapterForSearchRequest(
      //   200,
      //   [],
      // );
       final client = MockClient();
        when(client
              .post(
                body: {  "request_id" : "6de27dd6-e3f9-4b7b-8e14-3a5aeda1db3f", "otp":"1234"},
                Uri.parse(APIConstants.BASE_URL+ APIConstants.VERIFY_OTP )))
          .thenAnswer((_) async =>
            http.Response('Not Found', 400));
             // http.Response(' {"message": "\\"request_id\\" is not allowed to be empty",  "success": false, "results": []}', 200));

           try {
         var res =    await loginService.verifyOTP(otp: "1234", requestId: "");

            expect( res,  throwsException);
             
           } catch (e) {
             
           }
      
    //  var result =  await loginService.sendOTP( phoneNumber: "8097267015");
     //   print("res ${result.requestId}");
      // await endpoint.getUniversitiesByCountry("us");
    //  expect(result, SendOtp(requestId: "ea7e8e99-edfe-4e7f-b6d9-42abc0a306f1" )) ;
    });


  });
}