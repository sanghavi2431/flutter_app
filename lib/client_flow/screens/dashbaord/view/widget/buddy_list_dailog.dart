

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/task_model.dart';
import 'package:woloo_smart_hygiene/screens/dashboard/bloc/dashboard_state.dart';

import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_textstyle.dart';
import '../../../../widgets/CustomButton.dart';
import '../../bloc/dashboard_bloc.dart';
import '../../bloc/dashboard_state.dart';


class BuddyListDailog extends StatefulWidget {
 final TaskModel? taskModel;
  const BuddyListDailog({super.key, required this.taskModel});

  @override
  State<BuddyListDailog> createState() => _BuddyListDailogState();
}

class _BuddyListDailogState extends State<BuddyListDailog> {
  ClientDashBoardBloc dashBoardBloc  = ClientDashBoardBloc();
  // GlobalStorage globalStorage = GetIt.instance();
  List janitors = ["John", "David", "Emma", "Sophia"];
  String? selectedJanitor;


  @override
  Widget build(BuildContext context) {
    return 
       AlertDialog(
                 backgroundColor: AppColors.white,

                 title:  Center(
                   child: Text("Choose an Existing Task Buddy",
                    style: AppTextStyle.font20bold,
                    textAlign: TextAlign.center,
                   ),
                 ),
                 content:
                 SingleChildScrollView(
                   child: ListBody(
                     children: <Widget>[



                       SizedBox(
                         height: 20.h,
                       ),

                   SizedBox(
                     height: 300,
                     width: 300,
                     child: ListView.builder(
                       shrinkWrap: true,
                       itemCount: widget.taskModel!.results.data.length,
                       itemBuilder: (context, index) {
                         final janitor = widget.taskModel!.results.data[index].name;
                         return RadioListTile<String>(
                           title: Text(janitor),
                           value: "$janitor + $index ",
                           groupValue: selectedJanitor,
                           onChanged: (value) {
                             setState(() {
                               selectedJanitor = value;
                             });
                           },
                         );
                       },
                     ),
                   ),


                      SizedBox(
                        height: 20.h,
                      ),


                        GestureDetector(
                          onTap: (){
                            // Navigator.of(context).push( MaterialPageRoute(builder: (context) {
                            //    return ClientDashboard();
                            // }, ) );
                            // taskBottomSheet();
                          },
                          child: Custombutton(
                              height: 30.h,
                              text:"Okay", width: 320.w ),
                        ),
                       SizedBox(
                         height: 10.h,
                       ),


                     ],
                   ),
                 ),
                
               ); 
  }
}
