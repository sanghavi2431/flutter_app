import 'package:Woloo_Smart_hygiene/utils/app_textstyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Woloo_Smart_hygiene/screens/cluster_screen/data/model/Cluster_model.dart';
import 'package:Woloo_Smart_hygiene/screens/common_widgets/cluster_list.dart';
import 'package:Woloo_Smart_hygiene/screens/janitor_screen/view/janitor_screen.dart';
import 'package:Woloo_Smart_hygiene/utils/app_color.dart';
import 'package:Woloo_Smart_hygiene/utils/app_constants.dart';

class ClusterList extends StatefulWidget {
  const ClusterList({Key? key}) : super(key: key);

  @override
  State<ClusterList> createState() => _ClusterListState();
}

class _ClusterListState extends State<ClusterList> {
  bool cancelButtonTap = true;
  bool yesButtonTap = false;
  int selectedCard = -1;
  final TextEditingController _searchController = TextEditingController();
  ClusterModel _clusterModel = ClusterModel();
  var key = GlobalKey();
  List<ClusterModel> search = [];
  
  @override
  void initState() {
  super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(

        elevation: 0,
        backgroundColor: AppColors.white,
        title: Text(
          MyClusterListScreenConstants.TITLE_TEXT.tr(),
          style: 
         AppTextStyle.font24bold.copyWith(
          color: AppColors.black,
         )  
        ),
        // leading: IconButton(
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
          SizedBox(
            height: 20.h,
          ),
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
                        color: Colors.black.withOpacity(0.2), // S hadow color
                        spreadRadius: 1, // How wide the shadow should spread
                        blurRadius: 10, // The blur effect of the shadow
                        offset:
                            Offset(0, 0), // No offset for shadow on all sides
                      ),
                    ],
                  ),
              child: Center(
                child: 
                TextField(
                  onSubmitted: (s){
                
                    _searchController.clear();
                
                       if(search.length > 1){
                
                       }else
                       if(search.length == 1){
                         Navigator.of(context).push(
                           MaterialPageRoute(
                             builder: (context) => JanitorList(
                               rejected: false,
                               isFromCluster: true,
                               isFromDashboard: false,
                               clusterId: search.first.clusterId.toString(),
                               isFromDashboardAssignment: false,
                             ),
                           ),
                         );
                       }
                  },
                  textInputAction: TextInputAction.search,
                  controller: _searchController,
                   textAlign: TextAlign.start,
                  decoration: InputDecoration(
                     contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 10.0),
                    hintText: MyFacilityListConstants.SEARCH.tr(),
                    hintStyle: AppTextStyle.font14.copyWith(
                      color: AppColors.searchText

                    ),
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                
                        print("result $search");
                      },
                    ),
                    border:  InputBorder.none
                    
                    
                  ),
                ),
              ),
            ),
          ),
            SizedBox(
            height: 10.h,
          ),
          Expanded(
            child: ClusterListWidget(
              key: key,
              controller: _searchController,
              searchResult: (searchValue){
                           if(search.isNotEmpty){
                              search = [];
                           }
                      search.addAll(searchValue) ;
                       setState(() {

                       });
                    //  print("result $search");
                       // ClusterModel list
              },
              onTapItem: (ClusterModel list) async {
                    print("janitor naem  ${list}");
                _searchController.clear();
                await
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => JanitorList(
                      rejected: false,
                      // janitorName: list.janitorName,
                      isFromCluster: true,
                      isFromDashboard: false,
                      clusterId: list.clusterId.toString(),
                      isFromDashboardAssignment: false,
                    ),
                  ),
                );

                setState(() => key = GlobalKey());
              },
            ),
          ),
        ],
      ),
    );
  }
}
