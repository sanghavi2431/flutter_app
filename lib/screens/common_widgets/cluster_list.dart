import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/screens/cluster_screen/bloc/cluster_list_bloc.dart';
import 'package:woloo_smart_hygiene/screens/cluster_screen/bloc/cluster_list_event.dart';
import 'package:woloo_smart_hygiene/screens/cluster_screen/data/model/cluster_model.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';

import '../../utils/app_color.dart';
import '../cluster_screen/bloc/cluster_list_state.dart';
import 'empty_list_widget.dart';
import 'error_widget.dart';

class ClusterListWidget extends StatefulWidget {
  final TextEditingController controller;
     Function searchResult;
  final Function onTapItem;
   ClusterListWidget({
    super.key,
    required this.controller,
    required this.onTapItem,
    required this.searchResult
  });

  @override
  State<ClusterListWidget> createState() => _ClusterListWidgetState();
}

class _ClusterListWidgetState extends State<ClusterListWidget> {
  int selectedCard = -1;
  final ClusterListBloc _clusterListBloc = ClusterListBloc();
  List<ClusterModel> _search = [];
  List<ClusterModel> _data = [];

  @override
  void initState() {
    _clusterListBloc.add(const GetAllClusters());
    widget.controller.addListener(() {
       

        if (widget.controller.text.isEmpty) {
          _search = _data;
          return;
        }

        _search = _data
            .where((element) =>
                element.clusterName
                    ?.toLowerCase()
                    .contains(widget.controller.text.toLowerCase()) ??
                false)
            .toList();
           widget.searchResult(_search);
      });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: _clusterListBloc,
        listener: (context, state) {
          if (state is ClusterListSuccess) {
            EasyLoading.dismiss();

         
               _data = state.data;
               _search = _data;
          }
        },
        builder: (context, state) {
          if (state is ClusterListLoading  ) {
            EasyLoading.show(
                status: MydashboardScreenConstants.LOADING_TOAST.tr());
          }
         else
          if (state is ClusterListError) {
            EasyLoading.dismiss();
            return CustomErrorWidget(error: state.error.message);
          }
            else

          if (state is ClusterListSuccess  ) {
          
             
            EasyLoading.dismiss();
            return 
              RefreshIndicator(
            onRefresh: () {
              return Future.delayed(
                const Duration(seconds: 1),
                () {
                  _clusterListBloc.add(const GetAllClusters());
                },
              );
            },
            color: AppColors.buttonColor,
            child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
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
                        widget.onTapItem(_search[index]);
                    
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
                          color: selectedCard == index
                              ? AppColors.containerColor
                              : AppColors.white,
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
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                      horizontal: 5.w,
                                      vertical: 2.h,
                                    ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              _search[index].clusterName ?? '',
                                              style:
                                              AppTextStyle.font14bold.copyWith(
                                                color: AppColors.clusterTitleColor,
                                              )
                                            // TextStyle(
                                            //   color: AppColors.clusterTitleColor,
                                            //   fontSize: 18.sp,
                                            //   fontWeight: FontWeight.w400,
                                            // ),
                                          ),
                                      
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                      
                                          Text(
                                              _search[index].pincode  == null ? "-" :
                                      
                                              _search[index].pincode.toString(),
                                              style:
                                              AppTextStyle.font14.copyWith(
                                                color: AppColors.clusterTitleColor,
                                              )
                                            // TextStyle(
                                            //   color: AppColors.clusterTitleColor,
                                            //   fontSize: 18.sp,
                                            //   fontWeight: FontWeight.w400,
                                            // ),
                                          ),
                                        ],
                                      ),
                                    ),



                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        children: [
                                          Center(
                                            child: SizedBox(
                                              height: 35.w,
                                              child: const Center(
                                                child: VerticalDivider(
                                                  color: AppColors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              Container(
                                                 padding
                                           : const EdgeInsets.symmetric( horizontal: 8, vertical: 5),
                                                 decoration: BoxDecoration(
                                                   color: const Color(0xff76E16D),
                                                   borderRadius: BorderRadius.circular(25.r),

                                           ),

                                                child:  Text("Total Tasks: ${_search[index].totalTasks.toString()}"),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Container(
                                                padding
                                                    : const EdgeInsets.symmetric( horizontal: 8, vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xffE9AAAA),
                                                  borderRadius: BorderRadius.circular(25.r),
                                                ),

                                                child:  Text("Pending Tasks:  ${_search[index].pendingTasks.toString()}"),
                                              )
                                            ],
                                           ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
            
           // const EmptyListWidget();
          }
          return
           const EmptyListWidget(
             filter: "",
           );
         
        }
        );
  }
}
