

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewImage extends StatelessWidget {
   final File? file;
  const ViewImage({super.key, this.file});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body:
      Center(
        child: Image.file(
          file!,
          width: ScreenUtil().screenWidth,
          fit: BoxFit.cover,
        ),
      ),

    );
  }
}