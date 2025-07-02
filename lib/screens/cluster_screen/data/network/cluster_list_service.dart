import 'package:dio/dio.dart';
import 'package:woloo_smart_hygiene/core/network/api_constant.dart';
import 'package:woloo_smart_hygiene/core/network/dio_client.dart';
import 'package:woloo_smart_hygiene/screens/cluster_screen/data/model/cluster_model.dart';

class ClusterListService {
  final DioClient dio;
  const ClusterListService({required this.dio});

  Future<List<ClusterModel>> getAllCluster({String? token }) async {
    try {
      var response = await dio.get(
        APIConstants.CLUSTER_LIST,
        options:
          token != null ?   Options(
            headers: {
              "x-woloo-token":  token
            },
          ) :
         Options(extra: {"auth": true}),
      );
      List<ClusterModel> output = [];
      for (var item in response['results']) {
        output.add(ClusterModel.fromJson(item));
      }
      return output;
    } catch (e) {
      rethrow;
    }
  }
}
