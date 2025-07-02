




import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_constants.dart';

class LeadingButton extends StatelessWidget {
  const LeadingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
                padding: const EdgeInsets.only(left: 20 ),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: [
                  const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                      size: 12,
                    ),
                      SizedBox(
                        width: 5.w
                        ,
                      ),
                      Text(MyTaskListConstants.BACK.tr(),
                       style: const TextStyle(
                        color: Color(0xff888585),
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                       ),
                      ),
                    ],
                  ),
                ),
              );
  }
}