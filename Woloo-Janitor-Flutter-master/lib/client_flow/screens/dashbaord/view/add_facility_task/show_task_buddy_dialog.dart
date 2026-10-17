import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/bloc/dashboard_bloc.dart';
import '../../../../../core/local/global_storage.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_textstyle.dart';
import '../../../../widgets/CustomButton.dart';
import '../../bloc/dashboard_event.dart';
import '../../data/model/task_model.dart';
import '../widget/select_buddy_dailog.dart';


showTaskBuddyDailog(TaskModel? taskModel ,  String? selectedJanitor ,bool isBuddySelected , BuildContext context , ClientDashBoardBloc dashBoardBloc) {
  GlobalStorage globalStorage = GetIt.instance();
  Datum? selectedbuddy ;
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          backgroundColor: AppColors.white,

          //  title:
          //  ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                  child: Text(
                    "Choose an Existing Task Buddy",
                    style: AppTextStyle.font20bold,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  height: 300,
                  width: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: taskModel!.results!.data!.length,
                    itemBuilder: (context, index) {
                      final janitor = taskModel!.results!.data![index].name;
                      return RadioListTile<String>(
                        contentPadding: const EdgeInsets.all(0),
                        title: Text(janitor!),
                        value: "$janitor + $index ",
                        groupValue: selectedJanitor,
                        onChanged: (value) {
                          setState(() {
                            selectedJanitor = value!;
                            print(
                                "selected ${taskModel.results!.data![index]} ");

                            selectedbuddy = taskModel.results!.data![index];
                          });
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                selectedbuddy == null && isBuddySelected == true
                    ? const Text(
                  "Please select task buddy",
                  style: TextStyle(
                      fontSize: 15, color: AppColors.redTextColor),
                )
                    : const SizedBox(),
                SizedBox(
                  height: 20.h,
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push( MaterialPageRoute(builder: (context) {
                    //    return ClientDashboard();
                    // }, ) );
                    isBuddySelected = true;
                    setState(() {});

                    // taskExistingBottomSheet(selectedbuddy!
                    // );
                    if (selectedbuddy != null && isBuddySelected) {
                      String clintId = globalStorage.getClientId();
                      dashBoardBloc.add(
                          GetAllFacilityEvent(clientId: int.parse(clintId)));
                    }

                    // facilityBottomSheet();
                  },
                  child:
                  Custombutton(height: 30.h, text: "Okay", width: 320.w),
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        );
      });
    },
  ).then(
        (value) {
      isBuddySelected = false;
    },
  );
  // .then((v){
  //   //  selectedbuddy = null;
  // } );
}


