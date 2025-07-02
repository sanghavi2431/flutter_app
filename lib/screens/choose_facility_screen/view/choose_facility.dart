import 'package:woloo_smart_hygiene/screens/choose_facility_screen/view/iot_for_facility.dart';
import 'package:woloo_smart_hygiene/screens/choose_facility_screen/view/regular_for_facility.dart';
import 'package:woloo_smart_hygiene/screens/common_widgets/leading_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:woloo_smart_hygiene/screens/choose_facility_screen/data/model/facility_list_model.dart';
import 'package:woloo_smart_hygiene/screens/choose_facility_screen/data/model/selected_tasks.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';

import '../../../utils/app_textstyle.dart';

class ChooseFacilityList extends StatefulWidget {
  final String? janitorId;
  final String? clusterId;

  const ChooseFacilityList({
    super.key,
    required this.janitorId,
    this.clusterId,
  });

  @override
  State<ChooseFacilityList> createState() => _ChooseFacilityListState();
}

class _ChooseFacilityListState extends State<ChooseFacilityList> {
  final TextEditingController _searchController = TextEditingController();
  bool cancelButtonTap = true;
  bool yesButtonTap = false;
  bool selectAll = false;
  bool isDisabled = false;
  List<String> selectedIds = [];
  String allocationId = "";
  int _selectedIndex = 0;
  List<FacilityListModel> _facilityListModel = [];
  final List<bool> _checkList = [];
  SelectTaskModel selectTaskModel = SelectTaskModel();
  var key = GlobalKey(); // using this to refresh the list widget

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
  }

  List<Widget> _widgetOptions = <Widget>[];
  @override
  void initState() {
    super.initState();

    debugPrint("facility_clusterId---->>>>${widget.clusterId}");
  }

  @override
  Widget build(BuildContext context) {
    _widgetOptions = [
         RegularForFacility(
          selectAll: selectAll,
           key: key,
            controller: _searchController,
            janitorId: widget.janitorId ?? '',
            clusterId: widget.clusterId ?? '',
            type: "Regular",
            onTapItem: () {},
            onChecked: (bool selected, FacilityListModel listObject,
                List<FacilityListModel> list) {
              if (mounted) {
                setState(() {
                  _facilityListModel = list;
                  if (selectAll) {
                    selectAll = false;
                  }
                });
                if (selected) {
                  if (!selectedIds.contains(listObject.id)) {
                    selectedIds.add(listObject.id.toString());
                  }
                  debugPrint("add---->$selectedIds");
                } else {
                  //_selectedProductIds.removeWhere((element) => element == data.tasks?[index].taskId);
                  selectedIds.removeWhere(
                    (element) => element == listObject.id,
                  );
                  debugPrint("remove---->$selectedIds");
                }
                bool flag = true;
                for (var i = 0; i < _facilityListModel.length; i++) {
                  if (!_checkList[i]) {
                    flag = false;
                    break;
                  }
                }
                if (flag) selectAll = true;
                setState(() {});
              }
            },
            isCheckedSelectAll: selectAll,
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
      
       IotForFacility(
        selectAll: selectAll,
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
                  if (selectAll) {
                    selectAll = false;
                  }
                });
                if (selected) {
                  if (!selectedIds.contains(listObject.id)) {
                    selectedIds.add(listObject.id.toString());
                  }
                  debugPrint("add---->$selectedIds");
                } else {
                  //_selectedProductIds.removeWhere((element) => element == data.tasks?[index].taskId);
                  selectedIds.removeWhere(
                    (element) => element == listObject.id,
                  );
                  debugPrint("remove---->$selectedIds");
                }
                bool flag = true;
                for (var i = 0; i < _facilityListModel.length; i++) {
                  if (!_checkList[i]) {
                    flag = false;
                    break;
                  }
                }
                if (flag) selectAll = true;
                setState(() {});
              }
            },
            isCheckedSelectAll: selectAll,
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
        )
  
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
          leadingWidth: 100.w,
          elevation: 0,
          backgroundColor: AppColors.white,
          //title:

          leading: const LeadingButton()
          // IconButton(
          //   color: AppColors.black30,
          //   icon: const Icon(
          //     Icons.arrow_back,
          //     color: Colors.black,
          //     size: 30,
          //   ),
          //   // color: AppColors.black,
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
          ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: Text(MyFacilityScreenConstants.TITLE_TEXT.tr(),
                style: AppTextStyle.font24bold),
          ),
          SizedBox(
            height: 20.h,
          ),


          _widgetOptions.elementAt(_selectedIndex),
      
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.white,
        elevation: 15,
        unselectedItemColor: AppColors.black,
        unselectedLabelStyle: AppTextStyle.font12bold,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.task_outlined,
              size: 30,
            ),
            label: 'Regular Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bus_alert),
            label: 'IOT Task',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.buttonBgColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
