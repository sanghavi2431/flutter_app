import 'package:Woloo_Smart_hygiene/core/local/global_storage.dart';
import 'package:Woloo_Smart_hygiene/screens/common_widgets/image_provider.dart';
import 'package:Woloo_Smart_hygiene/screens/issue_list_screen/bloc/issue_list_bloc.dart';
import 'package:Woloo_Smart_hygiene/screens/issue_list_screen/bloc/issue_list_event.dart';
import 'package:Woloo_Smart_hygiene/screens/issue_list_screen/bloc/issue_list_state.dart';
import 'package:Woloo_Smart_hygiene/screens/issue_list_screen/data/model/Issue_list_model.dart';
import 'package:Woloo_Smart_hygiene/utils/app_constants.dart';
import 'package:Woloo_Smart_hygiene/utils/app_images.dart';
import 'package:Woloo_Smart_hygiene/utils/app_textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../utils/app_color.dart';
import 'empty_list_widget.dart';
import 'error_widget.dart';

class IssueListWidget extends StatefulWidget {
  final IssueListBloc issueListBloc;
  final Function onTapItem;

  const IssueListWidget({
    super.key,
    required this.issueListBloc,
    required this.onTapItem,
  });

  @override

  State<IssueListWidget> createState() => _IssueListWidgetState();
}

class _IssueListWidgetState extends State<IssueListWidget> {
  bool pending = false;
  int selectedCard = -1;
  List<IssueListModel> _data = [];
  late int supervisorId;

  GlobalStorage globalStorage = GetIt.instance();
  late IssueListBloc _issueListBloc;

  @override
  void initState() {
    supervisorId = globalStorage.getId();
    _issueListBloc = widget.issueListBloc;
    _issueListBloc.add(GetAllIssues(supervisorId: supervisorId));
    pending = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _issueListBloc,
      listener: (context, state) {
        if (state is IssueListSuccess) {
          EasyLoading.dismiss();

         
        }
      },
      builder: (context, state) {
        if (state is IssueListLoading ) {
          EasyLoading.show(status: MydashboardScreenConstants.LOADING_TOAST.tr());
        } 
        else

        if (state is IssueListError) {
          return CustomErrorWidget(error: state.error.message);
        } 
        else

        if (state is IssueListSuccess  ) {
               _data = state.data;
          EasyLoading.dismiss();
          return _data.isEmpty ?
          EmptyListWidget(
            filter:EmptyWidgetConstants.DATA_NOT_FOUND.tr(),
          )
              :
           RefreshIndicator(
          onRefresh: () {
            return Future.delayed(
              Duration(seconds: 1),
              () {
                _issueListBloc.add(GetAllIssues(supervisorId: supervisorId));
              },
            );
          },
          color: AppColors.buttonColor,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: _data.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (
              BuildContext context,
              int index,
            ) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 7.h),
                child: GestureDetector(
                  onTap: () {
                    widget.onTapItem();
                   
                      selectedCard = index;
                   
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 5.h,
                      horizontal: 10.w,
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 20.w,
                    ),
                    decoration: BoxDecoration(
                      color: selectedCard == index ? AppColors.containerColor : AppColors.white,
                      borderRadius: BorderRadius.circular(25.r),
                        boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Shadow color
                        spreadRadius: 1, // How wide the shadow should spread
                        blurRadius: 10, // The blur effect of the shadow
                        offset:
                            Offset(0, 0), // No offset for shadow on all sides
                      ),
                    ],
                      // border: Border.all(
                      //   color: AppColors.containerBorder,
                      //   width: 1.w,
                      // ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                        _data[index].clusterName ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: true,
                                        style:
                                         AppTextStyle.font18.copyWith(
                                           color: AppColors.janitorNameColor,
                                         )
                                        //  TextStyle(
                                        //   color: AppColors.janitorNameColor,
                                        //   fontSize: 18.sp,
                                        //   fontWeight: FontWeight.w400,
                                        // ),
                                      ),
                                        SizedBox(height: 10.h),
                                  Text(
                                    "${_data[index].facilityName}",
                                    overflow: TextOverflow.visible,
                                    maxLines: 2,
                                    style:
                                      AppTextStyle.font12.copyWith(
                                       color: AppColors.clusterTitleColor,
                                     )
                                    //  TextStyle(
                                    //   color: AppColors.clusterTitleColor,
                                    //   fontSize: 12.sp,
                                    //   fontWeight: FontWeight.w400,
                                    // ),
                                  ),
                            
                                  SizedBox(
                                    height: 10.h,
                                  ),
                            
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15 , vertical: 5 ),
                                      decoration: BoxDecoration(                     
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(25.r),
                                           boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.2), // Shadow color
                                                    spreadRadius: 1, // How wide the shadow should spread
                                                    blurRadius: 10, // The blur effect of the shadow
                                                    offset:
                              Offset(0, 0), // No offset for shadow on all sides
                                                  ),
                                                ],
                                      ),
                                      child: Text(
                                      (_data[index].status ?? '').tr(),
                                      style:
                                       AppTextStyle.font15.copyWith(
                                         color:  pending ? AppColors.redText : AppColors.greenText,
                                       )
                                      //  TextStyle(
                                      //   color: pending ? AppColors.redText : AppColors.greenText,
                                      //   fontSize: 16.sp,
                                      //   fontWeight: FontWeight.w500,
                                      // ),
                                                                      ),
                                    ),
                                     SizedBox(
                                    height: 10.h,
                                  ),
                              ],
                            ),
                          ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
                        //   child: Container(
                        //     height: 50.h,
                        //     width: 50.w,
                        //     decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.darkGreyColor),
                        //     child: Padding(
                        //       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                        //       child:
                        //       CustomImageProvider( image:  AppImages.bed_img,) 
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 5.h,
                          ),
                          child: Container(
                            width: 130.w,
                            height: 90.h,
                            
                            // padding: EdgeInsets.symmetric( vertical: 10 ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.r),
                                color: AppColors.white,


                                   boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.2), // Shadow color
                                                spreadRadius: 1, // How wide the shadow should spread
                                                blurRadius: 10, // The blur effect of the shadow
                                                offset:
                          Offset(0, 0), // No offset for shadow on all sides
                                              ),
                                            ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                 
                              
                                   CircleAvatar(
                                     radius: 30,
                                     backgroundColor:  AppColors.darkGreyColor,

                                     child:
                                     _data[index].profileImage!.isNotEmpty ?

                                     ClipRRect(
                                       borderRadius: BorderRadius.circular(100),


                                       child: CustomImageProvider(
                                        image:"${_data[index].baseUrl}/${_data[index].profileImage!.replaceAll("[", "").replaceAll("]", "").replaceAll('"', '')}",
                                        width: 60,
                                        height: 60,
                                        ),
                                     )
                                     :

                                     const Icon(
                                       Icons.person_2_outlined,

                                       color: AppColors.buttonColor,
                                     ),
                                   ),
                                SizedBox(height: 5.h), 
                                Text(
                                " ${_data[index].janitorName}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style:
                                   AppTextStyle.font12.copyWith(
                                     color: AppColors.clusterTitleColor,
                                   )
                                  //  TextStyle(
                                  //   color: AppColors.clusterTitleColor,
                                  //   fontSize: 12.sp,
                                  //   fontWeight: FontWeight.w400,
                                  // ),
                                ),
                            
                            
                              
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
          // const EmptyListWidget();
        }
        return  SizedBox();
       
      },
    );
  }
}
