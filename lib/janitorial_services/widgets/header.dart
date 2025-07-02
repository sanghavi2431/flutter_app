

import 'package:flutter/material.dart';

import '../../utils/app_textstyle.dart';
import '../utils/services_colors.dart';

class Header extends StatelessWidget {
 final  String title;

  const Header({super.key,  required this.title});

  @override
  Widget build(BuildContext context) {
    return    
     Column(
       // mainAxisAlignment: MainAxisAlignment.start
       //,
       crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(title,
           style: AppTextStyle.font20bold,
         ),
         const SizedBox(
           width: 111,
           child: Divider(
             color: ServicesColors.greyColor,
           ),
         )
      ],
     )
    ;
  }
}