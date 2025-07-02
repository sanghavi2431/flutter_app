

import '../utils/app_strings.dart';

// class Product {
//   final String title;
//   final String subTitle;
//   final String image;
//   final double price;
//   final bool fav;

//   Product({
//     required this.title,
//     required this.subTitle,
//     required this.image,
//     required this.price,
//     this.fav = false,
//   });
// }


//  List<Product>   productList = [
//    Product(title: "Feather Toilet Seat", subTitle: "Seller - Feather Industries", 
//     image: AppImages.item,
//    price: 799,
//     fav: true
//    ),
//   Product(title: "Feather Toilet Seat", subTitle: "Seller - Feather Industries", image: AppImages.item, price: 799,
//     fav: true
//    ),
//   Product(title: "Feather Toilet Seat", subTitle: "Seller - Feather Industries", image: AppImages.item, price: 799,
//     fav: true
//    ),
//   Product(title: "Feather Toilet Seat", subTitle: "Seller - Feather Industries", image: AppImages.item, price: 799,
//     fav: true
//    )

//  ];


 class ServiceModel {
  final String? name;
  final String? icon;
  

  ServiceModel({this.name, this.icon,});
}


 List<ServiceModel> serviceList = [
      
      ServiceModel(name:  ServicesStrings.carCare, icon: 'assets/images/services/insecticide.png'),
      ServiceModel(name:  ServicesStrings.applianceRepair, icon: 'assets/images/services/cleaning.png'),
      ServiceModel(name:  ServicesStrings.pestControl, icon: 'assets/images/services/kitchen.png'),
      ServiceModel(name:  ServicesStrings.homeCare, icon: 'assets/images/services/sofa.png'),
      ServiceModel(name:  ServicesStrings.warrantyServices, icon: 'assets/images/services/service 1.png'),
      ServiceModel(name:  ServicesStrings.bicycleServices, icon: 'assets/images/services/janitor.png'),
      ServiceModel(name:  ServicesStrings.bathroomCleaning, icon: 'assets/images/services/toilet.png'),
      ServiceModel(name:  ServicesStrings.weddingPhotography, icon: 'assets/images/services/electrical.png'),
      ServiceModel(name:  ServicesStrings.weddingPhotography, icon: 'assets/images/services/chef.png'),
   
 ];