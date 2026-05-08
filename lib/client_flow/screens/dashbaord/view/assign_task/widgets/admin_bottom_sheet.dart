import 'package:flutter/material.dart';
import 'package:woloo_smart_hygiene/client_flow/utils/client_images.dart';
import 'package:woloo_smart_hygiene/client_flow/widgets/CustomButton.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';
import 'package:woloo_smart_hygiene/utils/app_constants.dart';
import 'package:woloo_smart_hygiene/utils/app_images.dart';

class AdminBottomSheet extends StatefulWidget {
  final List<dynamic> admin;
  final TextEditingController nameController;
  final TextEditingController mobileController;
  final VoidCallback openSupervisorSheet;

  const AdminBottomSheet({
    super.key,
    required this.admin,
    required this.nameController,
    required this.mobileController,
    required this.openSupervisorSheet,
  });

  @override
  State<AdminBottomSheet> createState() => _AdminBottomSheetState();
}

class _AdminBottomSheetState extends State<AdminBottomSheet> {
  int selectedAdmin = -1;
  bool isSelfAssign = false;
  bool isAdminSelected = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 680,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(80),
          topRight: Radius.circular(80),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),

          _header(),

          const SizedBox(height: 70),

          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.admin.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAdmin = index;

                    if (widget.admin[index].title == "Monitor \nYourself") {
                      isSelfAssign = true;
                      isAdminSelected = true;
                    } else {
                      isSelfAssign = false;
                      isAdminSelected = false;
                      widget.nameController.clear();
                      widget.mobileController.clear();
                    }

                    errorMessage = '';
                  });
                },
                child: _adminCard(
                  widget.admin[index].image!,
                  widget.admin[index].title!,
                  selectedAdmin == index,
                ),
              );
            },
          ),

          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),

          const SizedBox(height: 24),

          GestureDetector(
            onTap: () {
              if (selectedAdmin == -1) {
                setState(() {
                  errorMessage = 'Please select a supervisor option';
                });
                return;
              }

              Navigator.pop(context);
              widget.openSupervisorSheet();
            },
            child: const Custombutton(
              text: "Next",
              width: double.infinity,
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Image.asset(ClientImages.setting, height: 48),
        const SizedBox(width: 12),
        RichText(
          text: TextSpan(
            text: "Choose ",
            style: AppTextStyle.font22bold,
            children: [
              TextSpan(
                text: "Admin",
                style: AppTextStyle.font22bold,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _adminCard(String image, String title, bool selected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: selected ? AppColors.backgroundColor : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppColors.backgroundColor : AppColors.greyBorderProfile,
        ),
      ),
      child: Row(
        children: [
          Image.asset(image, height: 40),
          const SizedBox(width: 20),
          Text(title, style: AppTextStyle.font16w6),
        ],
      ),
    );
  }
}
