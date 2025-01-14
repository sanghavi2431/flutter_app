import 'package:Woloo_Smart_hygiene/utils/app_textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:Woloo_Smart_hygiene/core/local/global_storage.dart';
import 'package:Woloo_Smart_hygiene/screens/common_widgets/custom_dialogue_widget.dart';
import 'package:Woloo_Smart_hygiene/screens/common_widgets/empty_list_widget.dart';
import 'package:Woloo_Smart_hygiene/screens/common_widgets/error_widget.dart';
import 'package:Woloo_Smart_hygiene/screens/common_widgets/issue_list_widget.dart';
import 'package:Woloo_Smart_hygiene/screens/issue_list_screen/bloc/issue_list_bloc.dart';
import 'package:Woloo_Smart_hygiene/screens/issue_list_screen/bloc/issue_list_event.dart';
import 'package:Woloo_Smart_hygiene/screens/issue_list_screen/bloc/issue_list_state.dart';
import 'package:Woloo_Smart_hygiene/screens/issue_list_screen/data/model/Issue_list_model.dart';
import 'package:Woloo_Smart_hygiene/screens/janitor_details_screen/view/janitor_details.dart';
import 'package:Woloo_Smart_hygiene/screens/report_issue_screen/view/report_issue_form.dart';
import 'package:Woloo_Smart_hygiene/utils/app_color.dart';
import 'package:Woloo_Smart_hygiene/utils/app_constants.dart';

class IssuesList extends StatefulWidget {
  const IssuesList({Key? key}) : super(key: key);

  @override
  State<IssuesList> createState() => _IssuesListState();
}

class _IssuesListState extends State<IssuesList> {
  bool cancelButtonTap = true;
  bool yesButtonTap = false;
  late int supervisorId;
  List<IssueListModel> _data = [];

  GlobalStorage globalStorage = GetIt.instance();
  IssueListBloc issueListBloc = GetIt.instance();

  @override
  void initState() {
    supervisorId = globalStorage.getId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
       backgroundColor:  AppColors.white,
        title: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10.h,
            horizontal: 15.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                MyIssuesListScreenConstants.TITLE_TEXT.tr(),
                style:
                AppTextStyle.font24bold.copyWith(
                  color: AppColors.black,
                )
                //  TextStyle(
                //   fontSize: 24.sp,
                //   fontWeight: FontWeight.w400,
                //   color: AppColors.yellowSplashColor,
                // ),
              ),
              GestureDetector(
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ReportIssueScreen(),
                    ),
                  );

                  issueListBloc.add(GetAllIssues(supervisorId: supervisorId));
                },
                child: Container(
                  height: 32.h,
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    color: AppColors.buttonColor,
                  ),
                  child: Center(
                    child: Text(
                      MyIssuesListScreenConstants.REPORT_ISSUE_BUTTON.tr(),
                      textAlign: TextAlign.center,
                      style:
                      AppTextStyle.font12bold.copyWith(
                         color: AppColors.black,
                      )
                      //  TextStyle(
                      //   fontWeight: FontWeight.w700,
                      //   color: AppColors.black,
                      //   fontSize: 16.sp,
                      // ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20.h,
          ),
          Expanded(
            child: IssueListWidget(
              issueListBloc: issueListBloc,
              onTapItem: () {},
            ),
          ),
        ],
      ),
    );
  }

  openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogueWidget(
          text: MyFacilityListConstants.POPUP_TEXT.tr(),
          onTapSubmit: () {
            setState(() {
              yesButtonTap = true;
              cancelButtonTap = false;
            });
          },
          onTapCancel: () {
            setState(() {
              cancelButtonTap = true;
              yesButtonTap = false;
            });
          },
        );
      },
    );
  }
}
