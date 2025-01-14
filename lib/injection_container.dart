import 'package:Woloo_Smart_hygiene/screens/issue_list_screen/bloc/issue_list_bloc.dart';
import 'package:Woloo_Smart_hygiene/screens/supervisor_dashboard/bloc/supervisor_dashboard_bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio_log/interceptor/dio_log_interceptor.dart';
import 'package:flutter/widgets.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

import 'core/interceptor/auth_interceptor.dart';
import 'core/interceptor/error_interceptor.dart';
import 'core/local/global_storage.dart';
import 'core/network/dio_client.dart';
import 'screens/dashboard/bloc/dashboard_bloc.dart';
import 'screens/my_account/view/bloc/profile_bloc.dart';

// import 'data/services/network/dio_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// Dio
  var dio = Dio();
  DioLogInterceptor.enablePrintLog = false;
  dio.interceptors.add(DioLogInterceptor());
  dio.interceptors.add(AuthInterceptor());
  dio.interceptors.add(ErrorInterceptor());
  GlobalKey<DropdownSearchState> dropDownKey = GlobalKey<DropdownSearchState>();

  sl.registerLazySingleton(() => DioClient(dio));
  sl.registerLazySingleton(() => GlobalStorage(GetStorage()));
  sl.registerLazySingleton(() => SupervisorDashboardBloc());
   sl.registerLazySingleton(() => DashboardBloc());
  sl.registerLazySingleton(() => IssueListBloc());
  sl.registerLazySingleton(() => ProfileBloc());
  sl.registerSingleton(dropDownKey);
}
