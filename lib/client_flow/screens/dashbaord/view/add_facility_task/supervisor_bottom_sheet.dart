import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/local/global_storage.dart';
import '../../../../../screens/common_widgets/image_provider.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../utils/app_textstyle.dart';
import '../../../../utils/client_images.dart';
import '../../../../widgets/CustomButton.dart';
import '../../../../widgets/CustomTextField.dart';
import '../../model/facility_model.dart';
import 'assign_task_supervisor_bottom_sheet.dart';

class AdminBottomSheetSupervisor {
  final BuildContext context;
  final GlobalStorage globalStorage;

  /// STATE VARIABLES (same as before)
  int selectedAdmin;
  bool isAdminSelected;
  bool isSelfAssign;
  String erroradminMessage;

  final TextEditingController nameController;
  final TextEditingController mobileController;

  AdminBottomSheetSupervisor({
    required this.context,
    required this.globalStorage,
    required this.selectedAdmin,
    required this.isAdminSelected,
    required this.isSelfAssign,
    required this.erroradminMessage,
    required this.nameController,
    required this.mobileController,
  });

  void show() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setStatee) {
            return Container(
              height: 680,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(80.0),
                  topRight: Radius.circular(80.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Semantics(
                  label: "Admin Selection",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// HEADER
                      Semantics(
                        label: "Choose Admin",
                        child: header(
                          "Choose ",
                          "Admin",
                          ClientImages.setting,
                        ),
                      ),

                      const SizedBox(height: 70),

                      /// ADMIN LIST
                      _buildAdminList(setStatee),

                      /// ERROR
                      if (erroradminMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            erroradminMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),

                      const SizedBox(height: 24),

                      /// NEXT BUTTON
                      _buildNextButton(setStatee),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((value) {
      isAdminSelected = false;
      isSelfAssign = false;
      erroradminMessage = '';
      selectedAdmin = -1;
    });
  }

  /// =========================
  /// ADMIN LIST
  /// =========================
  Widget _buildAdminList(StateSetter setStatee) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: admin.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            selectedAdmin = index;

            if (admin[index].title == "Monitor \nYourself") {
              isAdminSelected = true;
              isSelfAssign = true;

              mobileController.text =
                  globalStorage.getClientMobileNo();
            } else {
              isSelfAssign = false;
              nameController.clear();
              mobileController.clear();
              isAdminSelected = false;
            }

            setStatee(() {});
          },
          child: adminCard(
            admin[index].image!,
            admin[index].title!,
            index,
            selectedAdmin,
          ),
        );
      },
    );
  }

  /// =========================
  /// NEXT BUTTON
  /// =========================
  Widget _buildNextButton(StateSetter setStatee) {
    return Semantics(
      label: "Next Button",
      child: GestureDetector(
        key: const ValueKey("nextButton"),
        onTap: () {
          if (selectedAdmin == -1) {
            setStatee(() {
              erroradminMessage =
              'Please select a supervisor option';
            });
          } else {
            setStatee(() {
              erroradminMessage = '';
            });
          }

          if (selectedAdmin != -1) {
            SupervisorBottomSheet(context: context,  nameController: nameController, mobileController: mobileController, isAdminSelected: isAdminSelected).show();
          }
        },
        child: const Custombutton(
          key: ValueKey("adminNextButton"),
          text: "Next",
          width: double.infinity,
        ),
      ),
    );
  }
}

Widget header(String title, String subTitle, String image) {
  return Column(
    children: [
      const SizedBox(height: 9),
      Center(child: CustomImageProvider(image: ClientImages.line, width: 70)),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageProvider(image: image, width: 24, height: 24),
          const SizedBox(width: 6),
          Text(semanticsLabel: title, title, style: AppTextStyle.font18bold),
          const SizedBox(width: 4),
          Text(
            semanticsLabel: subTitle,
            subTitle,
            style: AppTextStyle.font18bold.copyWith(
              color: AppColors.backgroundColor,
            ),
          ),
        ],
      ),
    ],
  );
}


Widget adminCard(String image, String title, int index ,int selectedAdmin) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 38),
    child: Stack(
      children: [
        Container(
          //  width: 120,
          height: 151,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Shadow color
                spreadRadius: 1, // Spread effect
                blurRadius: 10, // Blur effect
                offset: const Offset(0, 5), // Bottom shadow
              ),
            ],
            border: Border.all(
              color: selectedAdmin == index
                  ? AppColors.backgroundColor
                  : AppColors.white,
            ),
          ),
          child: Row(
            //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 30),
              CustomImageProvider(image: image, width: 106, height: 106),
              const SizedBox(width: 20),
              Text(
                title,
                style: AppTextStyle.font32bold.copyWith(
                  fontSize: 30,
                  color: AppColors.greyBorder,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        selectedAdmin == index
            ? Positioned(
          bottom: 0,
          right: 0,
          // left: 100,
          child: CustomImageProvider(
            image: ClientImages.check,
            width: 29,
            height: 29,
          ),
        )
            : const SizedBox(),
      ],
    ),
  );
}


class SupervisorBottomSheet {
  final BuildContext context;
  final TextEditingController nameController;
  final TextEditingController mobileController;

  final bool isAdminSelected;

  SupervisorBottomSheet({
    required this.context,
    required this.nameController,
    required this.mobileController,
    required this.isAdminSelected,
  });

  final addSuperVisorKey = GlobalKey<FormState>();
  void show() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.7,
              maxChildSize: 0.8,
              builder: (context, scrollController) {
                return Container(
                  height: MediaQuery.of(context).size.height / 1.4,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80.0),
                      topRight: Radius.circular(80.0),
                    ),
                  ),
                  child: Form(
                    key: addSuperVisorKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView(
                        controller: scrollController,
                        children: [

                          /// HEADER
                          _buildHeader(),

                          const SizedBox(height: 70),

                          /// NAME FIELD
                          _buildNameField(),

                          const SizedBox(height: 40),

                          /// MOBILE FIELD
                          _buildMobileField(),

                          SizedBox(
                            height: MediaQuery.of(context).size.height / 3.5,
                          ),

                          /// NEXT BUTTON
                          _buildNextButton(),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    ).then((v) {
      mobileController.clear();
      nameController.clear();
    });
  }

  /// =========================
  /// HEADER
  /// =========================
  Widget _buildHeader() {
    return header(
      "Assign",
      DashboardConst.assignsupervisor,
      ClientImages.avatar,
    );
  }

  /// =========================
  /// NAME FIELD
  /// =========================
  Widget _buildNameField() {
    return CustomTextField(
      padding: const EdgeInsets.all(0),
      controller: nameController,
      hintText: DashboardConst.fullName,
      keyboardType: TextInputType.text,
      validator: validateName,
    );
  }

  /// =========================
  /// MOBILE FIELD
  /// =========================
  Widget _buildMobileField() {
    return CustomTextField(
      padding: const EdgeInsets.all(0),
      readOnly: isAdminSelected,
      controller: mobileController,
      hintText: DashboardConst.number,
      keyboardType: const TextInputType.numberWithOptions(
        signed: true,
        decimal: true,
      ),
      maxLength: 10,
      validator: validateMobile,
    );
  }

  /// =========================
  /// NEXT BUTTON
  /// =========================
  Widget _buildNextButton() {
    return GestureDetector(
      onTap: () {
        if (addSuperVisorKey.currentState!.validate()) {
         // janitorBottomSheet();
        }
      },
      child: const Custombutton(
        text: "Next",
        width: double.infinity,
      ),
    );
  }
}

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return "Name is required";
  }
  if (value.length < 3) {
    return "Name must be at least 3 characters";
  }
  return null;
}

String? validateMobile(String? value) {
  if (value == null || value.isEmpty) {
    return "Mobile number is required";
  }
  if (value.length != 10) {
    return "Enter a valid 10-digit mobile number";
  }
  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return "Mobile number must contain only digits";
  }
  return null;
}