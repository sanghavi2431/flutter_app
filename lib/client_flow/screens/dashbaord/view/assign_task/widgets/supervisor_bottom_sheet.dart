import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/client_flow/utils/client_images.dart';
import 'package:woloo_smart_hygiene/client_flow/widgets/CustomButton.dart';
import 'package:woloo_smart_hygiene/client_flow/widgets/CustomTextField.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

class SupervisorBottomSheet extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController mobileController;
  final VoidCallback onNext;
  final bool isAdminSelected;
  final String? Function(String?) validateName;
  final String? Function(String?) validateMobile;

  const SupervisorBottomSheet({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.mobileController,
    required this.onNext,
    required this.isAdminSelected,
    required this.validateName,
    required this.validateMobile,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.7,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(80),
              topRight: Radius.circular(80),
            ),
          ),
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                controller: scrollController,
                children: [
                  const SizedBox(height: 30),

                  _header(),

                  const SizedBox(height: 70),

                  CustomTextField(
                    controller: nameController,
                    hintText: DashboardConst.fullName,
                    keyboardType: TextInputType.text,
                    validator: validateName,
                    padding: EdgeInsets.zero,
                  ),

                  const SizedBox(height: 40),

                  CustomTextField(
                    controller: mobileController,
                    hintText: DashboardConst.number,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    maxLength: 10,
                    readOnly: isAdminSelected,
                    validator: validateMobile,
                    padding: EdgeInsets.zero,
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3.5,
                  ),

                  GestureDetector(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pop(context);
                        onNext();
                      }
                    },
                    child: const Custombutton(
                      text: "Next",
                      width: double.infinity,
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _header() {
    return Row(
      children: [
        Image.asset(ClientImages.avatar, height: 48),
        const SizedBox(width: 12),
        RichText(
          text: TextSpan(
            text: "Assign ",
            style: AppTextStyle.font22bold,
            children: [
              TextSpan(
                text: DashboardConst.assignsupervisor,
                style: AppTextStyle.font22bold,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
