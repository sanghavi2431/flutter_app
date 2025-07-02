

import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';
import 'package:woloo_smart_hygiene/screens/login/data/model/send_otp.dart';
import 'package:woloo_smart_hygiene/screens/login/data/model/verify_otp_model.dart';
import 'package:woloo_smart_hygiene/screens/login/data/network/login_services.dart';
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
    SendOtp  res;
  late LoginService loginService;



  group("Test Login Module Endpoint API calls", () {


    String reqId = "";

    setUp(() {

   
       var dio = Dio();
   
      loginService = LoginService(dio: DioClient(dio) );
   
    });

    test('Test send otp endpoints ', () async {
   
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
   
    });



    test('Test send otp endpoints exception ', () async {
     
       final client = MockClient();
        when(client
              .post(
                body: {  "mobileNumber": "",},
                Uri.parse(APIConstants.BASE_URL+ APIConstants.SEND_OTP )))
          .thenAnswer((_) async =>
        //http.Response('Not Found', 400));
            http.Response('{"message": "mobileNumber" must be a number, "success": false, "results": []}', 400));

           try {
                    res =    await loginService.sendOTP( phoneNumber: "");
                   reqId =     res.requestId!;
         
    // expect(res,"{message: \"mobileNumber\" must be a number, success: false, results: []}");
                 
           } catch (e) {
            //    expect(e,  throwsException );
              expect(e.toString(),'{message: "mobileNumber" must be a number, success: false, results: []}' );
           }
    });







        test('testing otp  api endpoints', () async {
    
       final client = MockClient();
        when(client
              .post(
                body: {  "request_id" : "6de27dd6-e3f9-4b7b-8e14-3a5aeda1db3f", "otp":"1234"},
                Uri.parse(APIConstants.BASE_URL+ APIConstants.VERIFY_OTP )))
          .thenAnswer((_) async =>
              http.Response('  "results": { "name": "shrirang  jangam",  "mobile": "8097267015", "id": 419, "role_id": 2,  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NDE5LCJyb2xlX2lkIjoyLCJpYXQiOjE3MzA3NzQ1OTUsImV4cCI6MTczMTM3OTM5NX0.cHWD0idDyb4NNRaFQHl05caNYz-9CzyWp6gW3_XKxWs"  }, "success": true', 200));

      expect(await loginService.verifyOTP(otp: "1234", requestId: reqId), isA<VerifyOtpModel>());
 
    });

          test('testing otp verify  api endpoints exception ', () async {
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
           // http.Response('Not Found', 400));
             http.Response('{message: "otp" is not allowed to be empty, success: false, results: []}', 200));

           try {
             await loginService.verifyOTP(otp: "", requestId: reqId);

   
             
           } catch (e) {
            
                      expect( e.toString(),  '{message: "otp" is not allowed to be empty, success: false, results: []}');
           }
      
  
    });


  });
}