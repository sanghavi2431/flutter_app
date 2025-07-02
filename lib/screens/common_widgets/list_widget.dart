import 'package:woloo_smart_hygiene/core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/screens/choose_facility_screen/bloc/facility_list_bloc.dart';
import 'package:woloo_smart_hygiene/screens/choose_facility_screen/bloc/facility_list_event.dart';
import 'package:woloo_smart_hygiene/screens/choose_facility_screen/bloc/facility_list_state.dart';
import 'package:woloo_smart_hygiene/screens/choose_facility_screen/data/model/facility_list_model.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:woloo_smart_hygiene/utils/date_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../utils/app_color.dart';
import 'empty_list_widget.dart';
import 'error_widget.dart';

class ListWidget extends StatefulWidget {
  final TextEditingController controller;
  final String janitorId;
  final Function onTapItem;
  final bool isCheckedSelectAll;
  final Function onChecked;
  final Function onSetData;
  final String? clusterId;
  final String? type;

  List<bool> checkList;

  ListWidget(
      {super.key,
      required this.controller,
      required this.onTapItem,
      required this.janitorId,
      this.isCheckedSelectAll = false,
      required this.onChecked,
      required this.onSetData,
      required this.checkList,
      this.clusterId,
      this.type
      });

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  int selectedCard = -1;
  late int janitorId;
  List<FacilityListModel> _data = [];
  List<FacilityListModel> _search = [];
  GlobalStorage globalStorage = GetIt.instance();
  final FacilityListBloc _facilityListBloc = FacilityListBloc();
  bool isSelected = false;
  @override
  void initState() {
    _facilityListBloc.add(GetAllFacility(janitorId: widget.janitorId  ));
    widget.controller.addListener(() {
      setState(() {
        if (widget.controller.text.isEmpty) {
          _search = _data;
          return;
        }

        _search = _data
            .where((element) =>
                element.facilityName
                    ?.toLowerCase()
                    .contains(widget.controller.text.toLowerCase()) ??
                false)
            .toList();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _facilityListBloc,
      listener: (context, state) {
        if (state is FacilityListSuccess) {
          EasyLoading.dismiss();

          setState(() {
            _data = state.data.where( (e) => e.requestType ==   widget.type).toList();
            debugPrint("sdfsfsdfs ${ widget.type} ");
            _search = _data;
            widget.onSetData(_data);
            widget.onSetData(_search);
          });
        }
      },
      builder: (context, state) {
        if (state is FacilityListLoading && _search.isEmpty) {
          EasyLoading.show(
              status: MydashboardScreenConstants.LOADING_TOAST.tr());
        }

        if (state is FacilityListError) {
          EasyLoading.dismiss();
          return CustomErrorWidget(error: state.error.message);
        }

        if (state is FacilityListSuccess && (state.data.isEmpty)) {
          EasyLoading.dismiss();
          return  EmptyListWidget(
            filter:  EmptyWidgetConstants.DATA_NOT_FOUND.tr(),
          );
        }

        return RefreshIndicator(
          onRefresh: () {
            return Future.delayed(
              const Duration(seconds: 1),
              () {
                _facilityListBloc
                    .add(GetAllFacility(janitorId: widget.janitorId  ));
              },
            );
          },
          color: AppColors.buttonColor,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: _search.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (
              BuildContext context,
              int index,
            ) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 7.h,
                ),
                child: GestureDetector(
                  onTap: () {
                    try {
                      setState(() {
                        widget.checkList[index] = !widget.checkList[index];
                        widget.onChecked(
                            widget.checkList[index], _search[index], _data);
                      });
                    } catch (e) {
                      debugPrint("onTapppppp$e");
                    }
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
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(25.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues( alpha: 0.2), // Shadow color
                          spreadRadius:
                          1, // How wide the shadow should spread
                          blurRadius:
                          10, // The blur effect of the shadow
                          offset: const Offset(0,
                              0), // No offset for shadow on all sides
                        ),
                      ],

                      // border: Border.all(
                      //   color: widget.checkList[index]
                      //       ? AppColors.buttonColor
                      //       : AppColors.containerBorder,
                      //   width: widget.checkList[index] ? 2.w : 1.w,
                      // ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5.w,
                                        vertical: 5.h,
                                      ),
                                      child: Text(
                                          looping(_search[index]),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                          AppTextStyle.font12bold.copyWith(
                                            color: AppColors.listTitleColor,
                                          )
                                        //  TextStyle(
                                        //   color: AppColors.ListTitleColor,
                                        //   fontSize: 13.sp,
                                        //   fontWeight: FontWeight.w600,
                                        //   letterSpacing: 0.8,
                                        // ),
                                      ),
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5.w,
                                          vertical: 1.h,
                                        ),
                                        child: Text(
                                          "${CustomDateUtils.formatDate(_search[index].startTime ?? '')} - ${CustomDateUtils.formatDate(_search[index].endTime ?? '')}",
                                          style:
                                          AppTextStyle.font10bold.copyWith(
                                            color: AppColors.timeSlotColor,
                                          )
                                          //  TextStyle(
                                          //   color: AppColors.timeSlotColor,
                                          //   fontSize: 12.sp,
                                          //   fontWeight: FontWeight.w400,
                                          // ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),


                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.w,
                                  vertical: 2.h,
                                ),
                                child: Text(
                                  "${MydashboardScreenConstants.DESCRIPTION.tr()}: ${_search[index].description ?? ''}",
                                  style: 
                                  AppTextStyle.font12w5.copyWith(
                                    color: AppColors.listTitleColor,
                                  )
                                  // TextStyle(
                                  //   color: AppColors.ListTitleColor,
                                  //   fontSize: 12.sp,
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
                                  "${MydashboardScreenConstants.LOCATION.tr()}: ${_search[index].locationName ?? ''}",
                                  style:
                                  AppTextStyle.font12.copyWith(
                                     color: AppColors.listTitleColor,
                                  )
                                  //  TextStyle(
                                  //   color: AppColors.ListTitleColor,
                                  //   fontSize: 12.sp,
                                  //   fontWeight: FontWeight.w400,
                                  // ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.person,
                                          color: AppColors.black,
                                          size: 15.sp,
                                          weight: 0.5),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5.w,
                                          vertical: 2.h,
                                        ),
                                        child: Text(
                                          _search[index].janitorName ?? '',
                                          style:
                                          AppTextStyle.font12.copyWith(
                                            color: AppColors.janitorNameColor,
                                          )
                                          //  TextStyle(
                                          //   color: AppColors.janitorNameColor,
                                          //   fontSize: 12.sp,
                                          //   fontWeight: FontWeight.w400,
                                          // ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  widget.checkList[index]
                                      ? Icon(Icons.check_circle,
                                          color: AppColors.acceptButtonColor,
                                          size: 20.sp,
                                          weight: 0.5)
                                      : Container(),
                                ],
                              ),
                            ],
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
      },
    );
  }

  String looping(FacilityListModel taskObject) {
    String tastName = '';
    debugPrint("task------->  ${taskObject.toJson()}");
    if (taskObject.taskStatus != null) {
      for (var i = 0; i < taskObject.taskStatus!.length; i++) {
        tastName += taskObject.taskStatus![i].taskName!;
      }
    }

    return tastName;
  }

  Color getColorByRequestType(String requestType) {
    switch (requestType) {
      case "IOT":
        return AppColors.iotBackgroundColor;
      case "Regular":
        return AppColors.regularButtonColor;
      case "Issue":
        return AppColors.issueButtonColor;
      case "Customer Request":
        return AppColors.acceptButtonColor;
      default:
        return AppColors.white;
    }
  }
}
