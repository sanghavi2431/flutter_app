



import 'package:woloo_smart_hygiene/utils/app_images.dart';

import '../../../../utils/app_constants.dart';
import '../../../utils/client_images.dart';

class ChooseFacilityModel {

   
   String? title;
   String? image;

    ChooseFacilityModel({this.image, this.title});
}


 List<ChooseFacilityModel> facility = [
   ChooseFacilityModel(
        image: AppImages.house,
        title: DashboardConst.home
      ),
   ChooseFacilityModel(
        image: AppImages.office,
        title: DashboardConst.office
      ),
   ChooseFacilityModel(
       image: ClientImages.restaunt,
       title: DashboardConst.restraunt
   ),
   ChooseFacilityModel(
       image: ClientImages.menu,
       title: DashboardConst.other
   )
 ];


List<ChooseFacilityModel> admin = [
  ChooseFacilityModel(
      image:  ClientImages.user,
      title: DashboardConst.monitorYourself
  ),
  ChooseFacilityModel(
      image:   ClientImages.supervisorLogo,
      title: DashboardConst.assignSupervisor
  ),

];

List<ChooseFacilityModel> genderList = [
  ChooseFacilityModel(
      image:  ClientImages.woman,
      title: "Female"
  ),
  ChooseFacilityModel(
      image:   ClientImages.man,
      title: "Male"
  ),

];

List<ChooseFacilityModel> cardList = [
  ChooseFacilityModel(
      image: ClientImages.mail,
      title:  "Contact Us"
  ),
  ChooseFacilityModel(
      image:  ClientImages.about,
      title:  "About"
  ),
 ChooseFacilityModel(
      image: ClientImages.term,
      title: "Terms of Use"
  ),
];



