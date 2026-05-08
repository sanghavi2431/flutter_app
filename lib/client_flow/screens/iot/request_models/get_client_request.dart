import '../../../../../../core/network/api_constant.dart';

class GetClientRequest {
  final int id;

  GetClientRequest({required this.id});

  String get endpoint => "${APIConstants.GET_CLIENT_ID}?user_id=$id";
}
