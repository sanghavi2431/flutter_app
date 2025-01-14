


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_constants.dart';
import '../../common_widgets/button_widget.dart';
import '../../common_widgets/list_widget.dart';
import '../../reassign_janitor_screen/view/reassign_janitor_screen.dart';
import '../data/model/Facility_list_model.dart';

class IotForFacility extends StatefulWidget {
    final TextEditingController controller;
  final String janitorId;
  final Function onTapItem;
  final bool isCheckedSelectAll;
  final Function onChecked;
  final Function onSetData;
  final String? clusterId;
  final String? type;
    List<bool> checkList;
    bool? selectAll;
   IotForFacility(
    {super.key,
     required this.controller,
      required this.onTapItem,
      required this.janitorId,
      this.isCheckedSelectAll = false,
      required this.onChecked,
      required this.onSetData,
      required this.checkList,
      this.clusterId,
      this.type,
      this.selectAll
  });

  @override
  State<IotForFacility> createState() => _IotForFacilityState();
}

class _IotForFacilityState extends State<IotForFacility> {
   List<String> selectedIds = [];
  String allocationId = "";
  int _selectedIndex = 0;
  List<FacilityListModel> _facilityListModel = [];
    final TextEditingController _searchController = TextEditingController();
  bool cancelButtonTap = true;
  bool yesButtonTap = false;
  bool selectAll = false;
  bool isDisabled = false;
  List<bool> _checkList = [];
    var key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return       Expanded(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    spreadRadius: 1, // How wide the shadow should spread
                    blurRadius: 10, // The blur effect of the shadow
                    offset: Offset(0, 0), // No offset for shadow on all sides
                  ),
                ],
              ),
              child: Center(
                child: TextField(
                  controller: _searchController,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 10.0),
                      hintText: MyFacilityListConstants.SEARCH.tr(),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          // Perform the search here
                        },
                      ),
                      border: InputBorder.none

                    //  OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(
                    //     10.r,
                    //   ),
                    // ),
                  ),
                ),
              ),
            ),
          ),
                    Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  child: Text(
                    MydashboardScreenConstants.FACILITY.tr(),
                    style: TextStyle(
                      color: AppColors.titleColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectAll = !selectAll;
                        print(
                            "_facilityListModel---->${_facilityListModel.length}");
                        if (selectAll) {
                          for (var i = 0; i < _facilityListModel.length; i++) {
                            if (!selectedIds
                                .contains(_facilityListModel[i].id.toString())) {
                              selectedIds
                                  .add(_facilityListModel[i].id.toString());
                            }
                            _checkList[i] = true;
                          }
                          print("add---->$selectedIds");
                        } else {
                          for (int i = 0; i < _facilityListModel.length; i++) {
                            _checkList[i] = false;
                          }
                          //_selectedProductIds.removeWhere((element) => element == data.tasks?[index].taskId);
                          selectedIds = [];
                          print("remove---->$selectedIds");
                        }
      
                        setState(() {});
                      });
                    },
                    child: Row(
                      children: [
                        Text(MyFacilityListConstants.SELECT_ALL.tr()),
                        Container(
                          width: 15.w,
                          height: 15.h,
                          decoration: BoxDecoration(
                            color: selectAll
                                ? AppColors.buttonColor
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(3.r),
                            border: Border.all(
                                color: selectAll
                                    ? Colors.transparent
                                    : AppColors.checkboxGreyBorder),
                          ),
                          child: !selectAll
                              ? null
                              : const Center(
                                  child: Icon(
                                    Icons.check,
                                    size: 15,
                                    color: AppColors.black,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          Expanded(
              child: ListWidget(
                  key: key,
                  controller: _searchController,
                  janitorId: widget.janitorId ?? '',
                  clusterId: widget.clusterId ?? '',
                  type: "IOT",
                  onTapItem: () {},
                  onChecked: (bool selected, FacilityListModel listObject,
                      List<FacilityListModel> list) {
                    if (mounted) {
                      setState(() {
                        _facilityListModel = list;
                        if ( widget.selectAll!) {
                           widget.selectAll = false;
                        }
                      });
                      if (selected) {
                        if (!selectedIds.contains(listObject.id)) {
                          selectedIds.add(listObject.id.toString());
                        }
                        print("add---->$selectedIds");
                      } else {
                        //_selectedProductIds.removeWhere((element) => element == data.tasks?[index].taskId);
                        selectedIds.removeWhere(
                          (element) => element == listObject.id,
                        );
                        print("remove---->$selectedIds");
                      }
                      bool flag = true;
                      for (var i = 0; i < _facilityListModel.length; i++) {
                        if (!_checkList[i]) {
                          flag = false;
                          break;
                        }
                      }
                      if (flag)  widget.selectAll = true;
                      setState(() {});
                    }
                  },
                  isCheckedSelectAll:  widget.selectAll!,
                  onSetData: (List<FacilityListModel> list) {
                    if (mounted) {
                      setState(() {
                        _facilityListModel = list;
                        for (int i = 0; i < list.length; i++) {
                          _checkList.add(false);
                        }
                      });
                    }
                  },
                  checkList: _checkList
                  
                  ),
            ),
                Padding(
              padding: EdgeInsets.symmetric(
                vertical: 20.h,
                horizontal: 20.w,
              ),
              child: GestureDetector(
                onTap: () async {
                  if (selectedIds.isNotEmpty) {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ReassignJanitorScreen(
                          isFromCluster: true,
                          clusterId: widget.clusterId,
                          janitorId: widget.janitorId ?? '',
                          allocationId: allocationId,
                          selectedIds: selectedIds,
                        ),
                      ),
                    );
                    setState(() => key = GlobalKey());
                  }
                },
                child: ButtonWidget(
                  enabled: selectedIds.isNotEmpty ? true : false,
                  text: MyFacilityListConstants.ASSIGN.tr(),
                ),
              ),
            ),
        ],
      
      ),
    );
      
  }
}