import 'package:flutter/cupertino.dart';

import '../../../../../widgets/CustomButton.dart';

class NextButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String? text;

  const NextButtonWidget({
    super.key,
    required this.onTap,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Custombutton(
        text: text ?? "Next",
        width: double.infinity,
      ),
    );
  }
}