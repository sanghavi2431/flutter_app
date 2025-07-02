


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/local/global_storage.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/app_textstyle.dart';
import '../../../../widgets/CustomButton.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../bloc/dashboard_event.dart';
import '../../bloc/dashboard_state.dart';

class SelectBuddyDailog extends StatefulWidget {
  const SelectBuddyDailog({super.key});

  @override
  State<SelectBuddyDailog> createState() => _SelectBuddyDailogState();
}

class _SelectBuddyDailogState extends State<SelectBuddyDailog> {
  // DashBoardBloc dashBoardBloc  = DashBoardBloc();
  ClientDashBoardBloc dashBoardBloc  = ClientDashBoardBloc();
  GlobalStorage globalStorage = GetIt.instance();
  @override
  Widget build(BuildContext context) {

    return
         AlertDialog(
                 backgroundColor: AppColors.white,


                 content:   BlocConsumer(
                   listener: (context, state) {
                        // print("dfsdfsd$state");
                     if ( state is DashboarLoading  ){

                       EasyLoading.show(status: state.message);
                     }
                     if(state is GetAllJanitor ){
                       EasyLoading.dismiss();

                      //  showDialog(context: context, builder:
                      //      (context) {
                      //    return BuddyListDailog( taskModel: state.taskModel, );
                      //  },
                      //  );
                       // taskModel =  state.taskModel;

                     }
                     if(state is DashboarError  ){
                       EasyLoading.dismiss();
                       EasyLoading.showError( state.error);

                     }
                   },
                   bloc: dashBoardBloc,
                   builder : (context, state) =>   SingleChildScrollView(
                     child: ListBody(
                       children: <Widget>[


                          // CustomImageProvider(
                          //   image: ClientImages.celebration,
                          //   width: 145,
                          //   height: 145,
                          // ),
                         // Text(DashboardConst.scheduleTask,
                         //   style: AppTextStyle.font14w7,
                         // ),
                         SizedBox(
                           height: 20.h,
                         ),

                         Text(
                            textAlign: TextAlign.center,
                          DashboardConst.taskBuddyPrompt,
                          style: AppTextStyle.font14w7,
                         ),

                       SizedBox(
                         height: 20.h,
                       ),

                       GestureDetector(
                         onTap: (){
                           Navigator.of(context).pop();
                           Navigator.of(context).pop();
                         },
                         child: Custombutton(
                              height: 30.h,
                             text:DashboardConst.assignNewTaskBuddy , width: 320.w ),
                       ),

                        SizedBox(
                          height: 20.h,
                        ),

                          GestureDetector(
                            onTap: () {

                               String clientId = globalStorage.getClientId();

                                print("dfgfd $clientId");
                               // context.read<ClientDashBoardBloc>().add(
                               //     GetAllJanitorEvent(
                               //       clientId: int.parse(clientId),
                               //     )
                               // );
                               dashBoardBloc.add(
                               GetAllJanitorEvent(clientId: int.parse(clientId),
                              )
                               );
                               
                            },
                            child: Custombutton(
                                height: 30.h,
                                text:DashboardConst.assignExistingTaskBuddy , width: 320.w ),
                          ),
                         SizedBox(
                           height: 10.h,
                         ),


                       ],
                     ),
                   ),
                 ),

               );
  }
}