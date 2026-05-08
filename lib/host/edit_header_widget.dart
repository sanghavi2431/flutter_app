import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../b2b_store/address_change_bottomsheet.dart';

class EditHeader extends StatelessWidget {
  const EditHeader({
    super.key,
    required this.label,
  });
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        const Spacer(),
        const EditButton(),
      ],
    );
  }
}