


import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/view/home.dart';

import '../../../../b2b_store/ecom.dart';
import '../../../../core/local/global_storage.dart';
import '../../../../hygine_services/view/hygine_landing.dart';
import '../../../../janitorial_services/screens/host_dashboard_screen.dart';
import '../../../../janitorial_services/screens/monitor-iot.dart';
import '../../../../screens/common_widgets/image_provider.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/app_textstyle.dart';
import '../../../utils/client_images.dart';
import '../../subcription/view/clientprofile.dart';
import 'home_dashboard.dart';

class ClientDashboard extends StatefulWidget {
   int? dashIndex;
   ClientDashboard({super.key, this.dashIndex});

  @override
  State<ClientDashboard> createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {
       int _selectedIndex = 0;
      GlobalStorage globalStorage = GetIt.instance();
      int? roleId;
      
     void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


    @override
  void initState() {
    // TODO: implement initState
    super.initState();
     print("dash board index ${widget.dashIndex}");
      
      _onItemTapped(widget.dashIndex!);

            roleId =  globalStorage.getRoleId();

     
  }


       List<Widget> _widgetOptions = <Widget>[
            // Text("Home"),
       

       ];

         List<String> _icons = [
          // ClientImages.home,
     
          
  ];
          List<String> title = [
          // "Home",
     
  ];
          List<String> _iconsinActive = [
          // ClientImages.homeUnseleted,
        
  ];

         void _onTap(int index) {
        
           setState(() => _selectedIndex = index);
      
         }

//         final List<String> _icons = [
//           ClientImages.home,
//           ClientImages.userSelected
//   ];
//          final List<String> title = [
//           "Home",
//           "Profile"
//   ];
//          final List<String> _iconsinActive = [
//           ClientImages.homeUnseleted,
//          ClientImages.userbottom,
//
// //     Icons.search,
//
//   ];

  //        void _onTap(int index) {
  //   setState(() => _selectedIndex = index);
  // }

  @override
  Widget build(BuildContext context) {
    
            roleId == 16 ?
       _widgetOptions = <Widget>[
            // Text("Home"),
          const  EcomScreen(),
           const HomeDashboard(),
        //  const  HygieneServicesScreen(),
           const Clientprofile(),
        const  HostDashboard() 

       ]
       : _widgetOptions = <Widget>[
            // Text("Home"),
          const  EcomScreen(),
           const HomeDashboard(),
        //  const  HygieneServicesScreen(),
           const Clientprofile(),
         ]  ;

            roleId == 16 ? 
         _icons = [
          // ClientImages.home,
          ClientImages.productSelected,
          ClientImages.checklistSelected,
          // ClientImages.services ,
          ClientImages.userSelected,
          ClientImages.hostColor,

  ]  : 
         _icons = [
          // ClientImages.home,
          ClientImages.productSelected,
          ClientImages.checklistSelected,
          // ClientImages.services ,
          ClientImages.userSelected,
         ];
       roleId == 16 ? 
         title = [
          // "Home",
          "Products",
          "TASQ MASTER",
          // "Services",
          "Profile",
        "Host Center" ,
  ]
   : 
         title = [
          // "Home",
          "Products",
          "TASQ MASTER",
          // "Services",
          "Profile",
       
  ]
  ;
      roleId == 16 ?
          _iconsinActive = [
          // ClientImages.homeUnseleted,
          ClientImages.product,
          ClientImages.checklist,
          // ClientImages.services,
          ClientImages.userbottom,
        ClientImages.hostCenter ,
  ]:
          _iconsinActive = [
          // ClientImages.homeUnseleted,
          ClientImages.product,
          ClientImages.checklist,
          // ClientImages.services,
          ClientImages.userbottom,
      
  ]

  ;
    return   Scaffold(
      backgroundColor: AppColors.white,
      // appBar: AppBar(
      //   backgroundColor: AppColors.white,
      // ),
      body:
      Stack(
        children: [
          Center(child: _widgetOptions.elementAt(_selectedIndex)),
              Positioned(
            bottom: 20,
            left: 15,
            right: 15,
            child: Container(
              // width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              height: 68,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                 boxShadow: [
            BoxShadow(
              color: Colors.black.withValues( alpha: 0.2), // Shadow color
              spreadRadius: 1, // How wide the shadow should spread
              blurRadius: 10, // The blur effect of the shadow
              offset: const Offset(0, 5), // Shadow offset, with y-offset for bottom shadow
            ),
          ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(_widgetOptions.length, (index) {
                  final isActive = _selectedIndex == index;
                  return GestureDetector(
                    onTap: () => _onTap(index),
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomImageProvider(
                          width: 30,
                         height: 30,
                          image: isActive ? _icons[index] : _iconsinActive[index] ,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        
                        Text(title[index],
                         style: AppTextStyle.font10bold,
                        )
                      ],
                    )
                    //  Icon(
                    //   _icons[index],
                    //   color: isActive ? Colors.deepPurple : Colors.grey,
                    //   size: isActive ? 30 : 26,
                    // ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar:  
      // BottomNavigationBar(
      //       backgroundColor: AppColors.white,
      //     elevation: 15,
      //     unselectedItemColor:  AppColors.black,
      //     unselectedLabelStyle:  AppTextStyle.font12bold,

      //     items:  <BottomNavigationBarItem>[
        
      //         BottomNavigationBarItem(
      //         icon:  CustomImageProvider(
      //           image:
      //           _selectedIndex == 0 ?
                
      //            ClientImages.home : ClientImages.homeUnseleted,
                 
                 
      //           width: 30,
      //           height: 30,
      //           // color:
      //           // _selectedIndex == 1 ?
      //           // AppColors.buttonBgColor
      //           // : null
      //           // ,
      //         ),
      //         label: 'Home',
      
      //       ),
      //       BottomNavigationBarItem(
      //         icon:  CustomImageProvider(
      //           image: 
      //            _selectedIndex == 1 ? 
      //            ClientImages.userSelected
                
      //           : ClientImages.userbottom,
      //           width: 30,
      //           height: 30,
      //           // color:
      //           // _selectedIndex == 1 ?
      //           // AppColors.buttonBgColor
      //           // : null
                
      //         ),
      //         label: 'Profile',
      
      //       ),
          
      //     ],
      //     currentIndex: _selectedIndex,
      //     selectedItemColor: AppColors.buttonBgColor,
      //     onTap: _onItemTapped,
      //   ),
    );
  }
}


// import 'package:flutter/material.dart';

// class ClientDashboard extends StatefulWidget {
//   const ClientDashboard({super.key});

//   @override
//   State<ClientDashboard> createState() => _ClientDashboardState();
// }

// class _ClientDashboardState extends State<ClientDashboard> {
//   int _selectedIndex = 0;

//   final List<IconData> _icons = [
//     Icons.home,
//     Icons.search,
//     Icons.person,
//   ];

//   final List<String> _titles = [
//     'Home Content',
//     'Search Content',
//     'Profile Content',
//   ];

//   void _onTap(int index) {
//     setState(() => _selectedIndex = index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Dynamic content based on tab
//           Positioned.fill(
//             child: Center(
//               child: Text(
//                 _titles[_selectedIndex],
//                 style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),

//           // Floating Bottom Bar
//           Positioned(
//             bottom: 20,
//             left: 20,
//             right: 20,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               height: 60,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 10,
//                     offset: Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(_icons.length, (index) {
//                   final isActive = _selectedIndex == index;
//                   return GestureDetector(
//                     onTap: () => _onTap(index),
//                     child: Icon(
//                       _icons[index],
//                       color: isActive ? Colors.deepPurple : Colors.grey,
//                       size: isActive ? 30 : 26,
//                     ),
//                   );
//                 }),
//               ),
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: Colors.grey[100],
//     );
//   }
// }
