import 'package:woloo_smart_hygiene/screens/common_widgets/empty_list_widget.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/leading_button.dart';
import 'package:woloo_smart_hygiene/screens/report_issue_screen/data/model/cluster_dropdown_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_color.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_textstyle.dart';
import '../common_widgets/dropdown_dialogue.dart';
import '../common_widgets/error_widget.dart';
import '../report_issue_screen/bloc/report_issue_bloc.dart';
import '../report_issue_screen/bloc/report_issue_event.dart';
import '../report_issue_screen/bloc/report_issue_state.dart';
import '../report_issue_screen/data/model/facility_dropdown_model.dart';
import 'bloc/assign_bloc.dart';
import 'bloc/assign_event.dart';
import 'bloc/assign_state.dart';
import 'data/janitor_list_model.dart';
import 'janitor_slot.dart';

class AssignScreen extends StatefulWidget {
  final int? id;
   final String? taskName;
   final String?  status;
   final int? estimatedTime;
  const AssignScreen({super.key, this.id, this.taskName, this.status, required this.estimatedTime});

  @override
  State<AssignScreen> createState() => _AssignScreenState();
}

class _AssignScreenState extends State<AssignScreen> {
    ReportIssueBloc reportIssueBloc = ReportIssueBloc();
    List<ClusterDropdownModel> clusterNames = [];
    List<FacilityDropdownModel> facilityNames = [];
    int? facilityId;
     AssignBloc assignBloc = AssignBloc() ;
     List<JanitorListModel>  janitorList = [];

 @override
  void initState() {
   
    super.initState();
     reportIssueBloc.add( const GetAllClustersDropdown());
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,

        leadingWidth: 100,
        leading:  const LeadingButton(),
      ),
      body: 
      BlocBuilder(
        bloc: reportIssueBloc,
        builder: (context, state) {
               if (state is GetClustersDropdownLoading) {
            EasyLoading.show(
                status: MydashboardScreenConstants.LOADING_TOAST.tr());
          }
          else
          if (state is GetClustersDropdownError) {
            return CustomErrorWidget(error: state.error.message);
          }
          else
          if (state is GetClustersDropdownSuccess  ) {

            EasyLoading.dismiss();
               clusterNames = state.data;
          //  return const EmptyListWidget();
          }
             else
          if (state is GetFacilityDropdownLoading) {
            EasyLoading.show(
                status: MydashboardScreenConstants.LOADING_TOAST.tr());
          }
           else
          if (state is GetFacilityDropdownError) {
            return CustomErrorWidget(error: state.error.message);
          }
          else
          if (state is GetFacilityDropdownSuccess  ) {

              EasyLoading.dismiss();
             facilityNames = state.data;
         //   return const EmptyListWidget();
          }




           
          return  Padding(
            padding:  EdgeInsets.symmetric( horizontal: 20.w ),
            child: SingleChildScrollView(
            
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.s,
                children: [
                  Text(
                    AssignScreenConstants.SEARCH_JANITOR.tr(),
              style:
              AppTextStyle.font24bold.copyWith(
              color: AppColors.black,
              ),),
                              SizedBox(
                                height: 10.h,
                              ),
              
                             DropDownDialog(
                               hint:   MyReportIssueScreenConstants.CLUSTER_NAME.tr(),
              
                               items: clusterNames,
                               itemAsString: (ClusterDropdownModel item) =>
                                   item.clusterName,
                               onChanged: (ClusterDropdownModel item) {
                                 try {
                                    // reportIssueBloc.add(GetAllTasksDropdown(
                                    //  clusterId: item.clusterId! ?? 0
                                    // ));
                                    facilityNames = [];
                                   reportIssueBloc.add(GetAllFacilityDropdown(
                                       clusterId: item.clusterId ?? 0));
                                  //  reportIssueBloc.add(GetAllJanitorsDropdown(
                                  //      clusterId: item.clusterId ?? 0));
                                 } catch (e) {
                                   debugPrint("dropppppp$e");
                                 }
                               },
                               validator: (value) => value == null
                                   ? MyReportIssueScreenConstants
                                       .CLUSTER_NAME_VALIDATION
                                       .tr()
                                   : null,
                             ),
                  SizedBox(
                    height: 15.h,
                  ),
              
                             DropDownDialog(
                               hint:  MyReportIssueScreenConstants.FACILITY.tr(),
                               // key: Key('${_editMarketModel.city?.label}T4'),
                               // selected: cities.firstWhereOrNull((element) => element.value == _editMarketModel.city?.value),
                               // widgetKey: _keys[2],xx
                               items: facilityNames,
                               itemAsString: (FacilityDropdownModel item) =>
                                   item.facilityName,
              
                               onChanged: (FacilityDropdownModel item) {
              
                                  facilityId = item.id!;
                                 //  print("facilityId --->" + facilityId.toString());
              
                               },
                               validator: (value) => value == null
                                   ? MyReportIssueScreenConstants.FACILITY_VALIDATION
                                       .tr()
                                   : null,
                             ),
              
                             SizedBox(
                             height: 15.h,
                               ),
              
                                        InkWell(
                                     onTap: () async {
                                      assignBloc.add(GetJanitorList( facilityId: facilityId!));
                                     
                                    //   Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const JanitorSlot(),  ) );
              
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8.r),
                                                          color: AppColors.buttonColor,
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(
                                                            horizontal: 40.w,
                                                            vertical: 7.h,
                                                          ),
                                                          child: Text(
                                                            MyFacilityListConstants.SEARCH.tr(),
                                                            textAlign: TextAlign.center,
                                                            style: AppTextStyle.font12w6.copyWith(
                                                                  color: AppColors.black, )
                                                            // TextStyle(
                                                            //   fontSize: 10.sp,
                                                            //   fontWeight: FontWeight.w600,
                                                            //   color: AppColors.black,
                                                            // ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
              
                  BlocBuilder(
                     bloc: assignBloc,
                    builder:  (context, state) {
                        if (state is  JanitorListLoading  ) {
                          EasyLoading.show(
                              status: MydashboardScreenConstants.LOADING_TOAST.tr());
                        }
                         if ( state is GetJanitorListError  ) {
                            CustomErrorWidget(error: state.error.message);
                           
                         }
                         if ( state is GetJanitorListDataSuccess ) {
                           EasyLoading.dismiss();
                               janitorList =    state.data;
                                debugPrint("janitor listtttt $janitorList");
                         }

                          if(janitorList.isEmpty){
                           return Center(child: SizedBox(
                               height: 400.h,
                               child: EmptyListWidget(filter: AssignScreenConstants.SEARCH_JANITOR_TO.tr() )));

                          }
                          else{

                           return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: janitorList.first.data!.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (
                                    BuildContext context,
                                    int index,
                                    ) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 7.h, ),
                                    child: GestureDetector(
                                      onTap: () {
                                        //   widget.onTapItem(_search[index]);

                                        //    selectedCard = index;

                                      },
                                      child: Container(
                                        padding: EdgeInsets.only( top: 5.h , bottom: 15.h, left: 13.w, right: 10.w  ),
                                        // padding: EdgeInsets.symmetric(
                                        //   vertical: 5.h,
                                        //   horizontal: 10.w,
                                        // ),
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 20.w,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.circular(25.r),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues( alpha: 0.2), // Shadow color
                                              spreadRadius: 1, // How wide the shadow should spread
                                              blurRadius: 10, // The blur effect of the shadow
                                              offset:
                                              const Offset(0, 0), // No offset for shadow on all sides
                                            ),
                                          ],

                                          // border: Border.all(
                                          //   color: AppColors.containerBorder,
                                          //   width: 1.w,
                                          // ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 5.h),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:  MediaQuery.of(context).size.width/1.5,
                                                    //ScreenUtil().screenWidth - 137.w,
                                                    child: Row(
                                                      // mainAxisAlignment:
                                                      // MainAxisAlignment.spaceBetween,
                                                      // crossAxisAlignment:
                                                      // CrossAxisAlignment.center,
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(
                                                              horizontal: 0.w,
                                                              vertical: 2.h,
                                                            ),
                                                            child: Text(
                                                                janitorList.first.data![index].name ?? '',
                                                                style: AppTextStyle.font16
                                                                    .copyWith(
                                                                  color: AppColors
                                                                      .janitorNameColor,
                                                                )
                                                              //  TextStyle(
                                                              //   color:
                                                              //       AppColors.janitorNameColor,
                                                              //   fontSize: 18.sp,
                                                              //   fontWeight: FontWeight.w400,
                                                              // ),
                                                            ),
                                                          ),
                                                        ),
                                                        // if () ...[

                                                        // ],
                                                        // if (widget.isFromFacility) ...[
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: 0.w),
                                                          child: InkWell(
                                                            onTap: () {

                                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>   JanitorSlot(
                                                                   id: janitorList.first.data![index].id!,
                                                                  taskName: widget.taskName,
                                                                  templateid: widget.id,
                                                                  status: widget.status,
                                                                  estimatedTime: widget.estimatedTime,
                                                                

                                                                ),   ) );
                                                              // _janitorListBloc.add(
                                                              //     ReassignTask(
                                                              //         id: widget
                                                              //             .allocationId,
                                                              //         janitor_id:
                                                              //             _data[index].id ??
                                                              //                 '',
                                                              //          fromReassign: true
                                                              //                 ));
                                                            },
                                                            child: Container(
                                                              alignment:
                                                              Alignment.centerRight,
                                                              decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    8.r),
                                                                color:
                                                                AppColors.buttonColor,
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal: 8.w,
                                                                  vertical: 8.h,
                                                                ),
                                                                child: Text(
                                                                    MyClusterListScreenConstants
                                                                        .BTN_TEXT
                                                                        .tr(),
                                                                    textAlign:
                                                                    TextAlign.center,
                                                                    style: AppTextStyle
                                                                        .font12
                                                                        .copyWith(
                                                                      color: Colors.black,
                                                                    )
                                                                  //  TextStyle(
                                                                  //   fontSize: 12.sp,
                                                                  //   fontWeight:
                                                                  //       FontWeight.w400,
                                                                  //   color: Colors.black,
                                                                  // ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        // ],
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width/1.6,
                                                    child: const Divider(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 5.w,
                                                      vertical: 2.h,
                                                    ),
                                                    child: Text(
                                                        "Address: ${janitorList.first.data![index].address ?? ''}",
                                                        style: AppTextStyle.font14.copyWith(
                                                          color: AppColors.clusterTitleColor,
                                                        )

                                                      //  TextStyle(
                                                      //   color: AppColors.clusterTitleColor,
                                                      //   fontSize: 14.sp,
                                                      //   fontWeight: FontWeight.w500,
                                                      // ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 5.w,
                                                      vertical: 2.h,
                                                    ),
                                                    child: Text(
                                                        "Mob.no. ${janitorList.first.data![index].mobile ?? ''}",
                                                        style: AppTextStyle.font12.copyWith(
                                                          color: AppColors.clusterTitleColor,
                                                        )
                                                      // TextStyle(
                                                      //   color: AppColors.clusterTitleColor,
                                                      //   fontSize: 12.sp,
                                                      //   fontWeight: FontWeight.w400,
                                                      // ),
                                                    ),
                                                  ),

                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 5.w,
                                                      vertical: 2.h,
                                                    ),
                                                    child: Text(
                                                        "Email : ${janitorList.first.data![index].email ?? ''}",
                                                        style: AppTextStyle.font12.copyWith(
                                                          color: AppColors.clusterTitleColor,
                                                        )
                                                      //  TextStyle(
                                                      //   color: AppColors.clusterTitleColor,
                                                      //   fontSize: 12.sp,
                                                      //   fontWeight: FontWeight.w400,
                                                      // ),
                                                    ),
                                                  ),
                                                  // Row(
                                                  // //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  //       // MainAxisAlignment.spaceAround,
                                                  //   // crossAxisAlignment:
                                                  //   //     CrossAxisAlignment.spaceBetween,
                                                  //   children: [
                                                  //
                                                  //         Container(
                                                  //        padding
                                                  //  : const EdgeInsets.symmetric(  horizontal: 12,  vertical: 5),
                                                  //        decoration: BoxDecoration(
                                                  //          color: AppColors.backgroundColor,
                                                  //          borderRadius: BorderRadius.circular(25.r),
                                                  //
                                                  //  ),
                                                  //
                                                  //       child:  Text(" Gender : ${janitorList[index].gender!.substring(0,1)}"),
                                                  //     ),
                                                  //        const SizedBox(
                                                  //         width: 8,
                                                  //        ),
                                                  //            Container(
                                                  //        padding
                                                  //  : const EdgeInsets.symmetric( horizontal: 12, vertical: 5),
                                                  //        decoration: BoxDecoration(
                                                  //          color:AppColors.backgroundColor,
                                                  //          borderRadius: BorderRadius.circular(25.r),
                                                  //
                                                  //  ),
                                                  //
                                                  //       child:  Text(" Cluster No. : ${janitorList[index].clusterId }"),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  // if (widget.isFromDashboardAssignment &&
                                                  //     _search[index].isPresent == true) ...[
                                                  //   Padding(
                                                  //     padding: EdgeInsets.symmetric(
                                                  //         horizontal: 5.w, vertical: 5.h),
                                                  //     child: InkWell(
                                                  //       onTap: () {
                                                  //         // print("iii${janitorList[index].id} ");
                                                  //         //  print("allocation id ${widget.allocationId} ");
                                                  //         // _janitorListBloc.add(
                                                  //         //   ReassignTask(
                                                  //         //       id: widget.allocationId,
                                                  //         //       janitor_id:
                                                  //         //       _search[index].id ?? '',
                                                  //         //         fromReassign: true
                                                  //         //       ),
                                                  //         // );
                                                  //       },
                                                  //       child: Container(
                                                  //         alignment: Alignment.centerRight,
                                                  //         decoration: BoxDecoration(
                                                  //           borderRadius:
                                                  //               BorderRadius.circular(25.r),
                                                  //           color: AppColors.buttonColor,
                                                  //         ),
                                                  //         child: Padding(
                                                  //           padding: EdgeInsets.symmetric(
                                                  //             horizontal: 16.w,
                                                  //             vertical: 6.h,
                                                  //           ),
                                                  //           child: Text(
                                                  //               MyClusterListScreenConstants
                                                  //                   .BTN_TEXT
                                                  //                   .tr(),
                                                  //               textAlign: TextAlign.center,
                                                  //               style: AppTextStyle.font12
                                                  //                   .copyWith(
                                                  //                 color: Colors.black,
                                                  //               )
                                                  //               // TextStyle(
                                                  //               //   fontSize: 12.sp,
                                                  //               //   fontWeight: FontWeight.w400,
                                                  //               //   color: Colors.black,
                                                  //               // ),
                                                  //               ),
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //   ),

                                                  // ]
                                                ],

                                              ),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(top: 12 ),
                                              //   child: CircleAvatar(
                                              //     radius: 23,
                                              //     backgroundColor: AppColors.darkGreyColor,
                                              //     // height: 40.h,
                                              //     // width: 40.w,
                                              //     // decoration: const BoxDecoration(
                                              //     //     shape: BoxShape.circle,
                                              //     //     color: AppColors.darkGreyColor),
                                              //     child:
                                              //     janitorList[index].profileImage!.isNotEmpty ?
                                              //       ClipRRect(
                                              //         borderRadius: BorderRadius.circular(100),
                                              //         child: CustomImageProvider(
                                              //           image:"${janitorList[index].baseUrl}/${janitorList[index].profileImage!.replaceAll("[", "").replaceAll("]", "").replaceAll('"', '')}",
                                              //         ),
                                              //       )
                                              //     :
                                              //     const Icon(
                                              //       Icons.person_2_outlined,
                                              //
                                              //       color: AppColors.buttonColor,
                                              //     ),
                                              //   ),
                                              // ),

                                            ],
                                          ),

                                        ),

                                      ),
                                    ),

                                  );
                                });

                          }









                  },  )
              
              
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}