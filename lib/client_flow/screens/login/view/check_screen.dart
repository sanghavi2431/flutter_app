import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/bloc/dashboard_state.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/login/view/choose_service.dart';

import '../../../../core/local/global_storage.dart';
import '../../dashbaord/bloc/dashboard_bloc.dart';
import '../../dashbaord/bloc/dashboard_event.dart';
import '../../dashbaord/view/dashboard.dart';

class CheckScreen extends StatefulWidget {
  const CheckScreen({super.key});

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> with WidgetsBindingObserver {
  ClientDashBoardBloc dashBoardBloc = ClientDashBoardBloc();
  GlobalStorage globalStorage = GetIt.instance();
  Map<String, dynamic>? decodedToken;
  int? roleId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var some = globalStorage.getClientToken();
    roleId = globalStorage.getRoleId();

    // Check if token exists and is valid before decoding
    if (some.isEmpty) {
      print("Error: Client token is empty");
      EasyLoading.showError("Authentication error. Please login again.");
      // Navigate back or handle error appropriately
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
      return;
    }

    try {
      decodedToken = JwtDecoder.decode(some);
      print("aarati print client token $decodedToken , $roleId ");

      if (decodedToken != null && decodedToken!["id"] != null) {
        dashBoardBloc.add(ClientEvent(id: decodedToken!["id"]));
      } else {
        print("Error: Token decoded but missing 'id' field");
        EasyLoading.showError("Authentication error. Please login again.");
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
    } catch (e) {
      print("Error decoding JWT token: $e");
      EasyLoading.showError("Authentication error. Please login again.");
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('Current state = $state');

    if (state == AppLifecycleState.resumed &&
        decodedToken != null &&
        decodedToken!["id"] != null) {
      dashBoardBloc.add(ClientEvent(id: decodedToken!["id"]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: dashBoardBloc,
        listener: (context, state) {
          if (state is DashboarLoading) {
            EasyLoading.show(status: state.message);
          }

          if (state is GetClient) {
            EasyLoading.dismiss();

            if (roleId == 16) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => ClientDashboard(
                          dashIndex: 2,
                        )),
                (route) => false,
              );
            } else {
              if (state.client.results!.isOnboardComplete!) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ClientDashboard(
                            dashIndex: roleId == 16 ? 2 : 0,
                          )),
                  (route) => false,
                );
              } else {
                /*  if(roleId == 16)
                {
                  MaterialPageRoute(
                      builder: (context) => ClientDashboard(
                        dashIndex:  2 ,
                      ));
                }
              else {*/
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChooseService()),
                  (route) => false,
                );
              }
            }
          }

          if (state is DashboarError) {
            EasyLoading.showError(state.error);
          }
        },
        builder: (context, state) {
          return const Scaffold(
              // appBar: AppBar(
              //   title: const Text("Check Screen"),
              // ),
              body: SizedBox());
        });

    // const Placeholder();
  }
}
