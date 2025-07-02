import 'package:dio/dio.dart';
import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';
import 'package:woloo_smart_hygiene/screens/choose_facility_screen/data/model/facility_list_model.dart';

class FacilityListService {
  final DioClient dio;
  const FacilityListService({required this.dio});

  Future<List<FacilityListModel>> getAllFacility(
      {required String janitorId}) async {
    try {
      var response = await dio.post(
        APIConstants.FACILITY_LIST,
        data: {
          "janitor_id": janitorId,
        },
        options: Options(extra: {"auth": true}),
      );

      List<FacilityListModel> output = [];
      for (var item in response['results']) {
        output.add(FacilityListModel.fromJson(item));
      }
      return output;
    } catch (e) {

      rethrow;
    }
  }
}
