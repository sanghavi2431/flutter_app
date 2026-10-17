import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import '../../../../../../core/local/global_storage.dart';
import 'package:woloo_smart_hygiene/client_flow/screens/dashbaord/data/model/task_model.dart';
import '../../../../../../screens/dashboard/bloc/dashboard_bloc.dart';
import '../../../../../../utils/app_color.dart';
import '../../../../../../utils/app_constants.dart';
import '../../../../../utils/client_images.dart';
import '../../../../../widgets/CustomButton.dart';
import '../../../../../widgets/CustomTextField.dart';
import '../../../bloc/dashboard_bloc.dart';
import '../../../bloc/dashboard_event.dart';
import '../../../bloc/dashboard_state.dart';
import '../../../data/model/facility_dropdown_model.dart';
import '../../../data/model/facility_model.dart';
import '../../../data/model/tasklist_model.dart';
import '../../../model/facility_model.dart';
import '../../../model/facility_type_model.dart';
import '../../../model/get_supervisor_list_model.dart';
import '../../assign_task/view/assign_tasks_screen.dart';
import '../assign_task_admin_card.dart';
import '../assign_task_header.dart';
import 'package:flutter/services.dart';



class _AdminSheetConstants {
  static const double sheetHeight = 630;
  static const double sectionSpacing = 20;
  static const double spacingMedium = 20;

  static const String title = "Choose ";
  static const String subTitle = "Supervisor";
  static const String next = "Next";
}


class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "Choose Supervisor",
      child: AssignTaskHeader(
        title: _AdminSheetConstants.title,
        subTitle: _AdminSheetConstants.subTitle,
        image: ClientImages.setting,
      ),
    );
  }
}

/// -------------------- ADMIN LIST --------------------

class _AdminList extends StatelessWidget {
  final int selectedAdmin;
  final Function(int) onSelect;

  const _AdminList({
    required this.selectedAdmin,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: admin.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onSelect(index),
          child: AssignTaskAdminCard(
            image: admin[index].image!,
            title: admin[index].title!,
            index: index,
            selectedAdmin: selectedAdmin,
          ),
        );
      },
    );
  }
}

/// -------------------- NEXT BUTTON --------------------

class _NextButton extends StatelessWidget {
  final VoidCallback onTap;

  const _NextButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Semantics(
        label: "Next Button",
        child: GestureDetector(
          key: const ValueKey("nextButton"),
          onTap: onTap,
          child: const Custombutton(
            key: ValueKey("adminNextButton"),
            text: _AdminSheetConstants.next,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}

class AdminBottomSheetNew extends StatefulWidget {
  final bool isClientSupervisor;
  final List<TaskDropdownModel>? facilityNames;
  final String? category;
  final FacilityDropdownModel? selectedFacility;
  final String? facilityName;
  final String? locality;
  final int? clusterId;
  final int? selectedIndex;
  final List<FacilityDropdownModel>? facilitydropdownNames;
  final Datum? existingBuddy; // For existing tasks
  final String? faciltyType;
  final TextEditingController facilityController;
  final int roleId;
  final String? loc;
  final String? defaultHostLocation;
  final ClientDashBoardBloc dashBoardBloc;

  const AdminBottomSheetNew({
    super.key,
    required this.isClientSupervisor,
    this.facilityNames,
    this.category,
    this.selectedFacility,
    this.facilityName,
    this.locality,
    this.clusterId,
    this.selectedIndex,
    this.facilitydropdownNames,
    this.existingBuddy,
    this.faciltyType,
    required this.facilityController,
    required this.roleId,
    required this.loc,
    required this.defaultHostLocation,
    required this.dashBoardBloc,
  });

  @override
  State<AdminBottomSheetNew> createState() =>
      _AdminBottomSheetNewState();

}

class _AdminBottomSheetNewState extends State<AdminBottomSheetNew> {
  late bool isAdminSelected;
  late bool isSelfAssign;
  late int selectedAdmin;
  late String erroradminMessage;
  late TextEditingController nameController;
  late TextEditingController mobileController;
  final addSuperVisorKey = GlobalKey<FormState>();
  List<SupervisorData> supervisorList = [];
  String selectedType = '';
  bool hasClientSupervisor = false;
  late bool isMonitor = selectedType == DashboardConst.monitorYourselfOne;
  late bool isExisting = selectedType == DashboardConst.selectExistingOne;
  late bool isAssignNew = selectedType == DashboardConst.assignSupervisorOne;

  @override
  void initState() {
    super.initState();

    selectedAdmin = -1;
    isAdminSelected = true;
    isSelfAssign = false;
    erroradminMessage = '';
    selectedType = '';


    widget.dashBoardBloc.add((const GetSupvisorListEvent(roleId: 2)));


    nameController = TextEditingController();
    mobileController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalStorage globalStorage = GetIt.instance();
    ClientDashBoardBloc bloc = widget.dashBoardBloc;

    return BlocListener<ClientDashBoardBloc, DashboardState>(
      bloc: bloc,
      listener: (context, state) {
        if (state is GetSupervisor) {
          if(EasyLoading.isShow)
          {
            EasyLoading.dismiss();
          }
          supervisorList =
              state.getSupervisorModel?.results?.data ?? [];
          hasClientSupervisor =
              supervisorList.any((e) => e.isClientSupervisor == true);
          if (hasClientSupervisor &&
              selectedType == DashboardConst.monitorYourselfOne) {
            selectedType = '';
          }
          setState(() {});
        }
        if (state is DashboarError)
        {
          if(EasyLoading.isShow)
          {
            EasyLoading.dismiss();
          }

        }
      },
      child:
      Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child:
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: addSuperVisorKey,
              child: Column(
                children: [

                  /// ✅ SCROLLABLE CONTENT
                  Expanded(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        children: [


                          /// HEADER
                          const _Header(),

                          const SizedBox(height: 15),

                          /// RADIO LIST
                          _AdminRadioList(
                            selectedType: selectedType,
                            hasSupervisor: supervisorList.isNotEmpty,
                            hasClientSupervisor: hasClientSupervisor,
                            isClientSupervisor: widget.isClientSupervisor,
                            onChanged: (type) {
                              setState(() {
                                selectedType = type;
                                nameController.clear();
                                mobileController.clear();
                                isMonitor = selectedType == DashboardConst.monitorYourselfOne;
                                isExisting = selectedType == DashboardConst.selectExistingOne;
                                isAssignNew = selectedType == DashboardConst.assignSupervisorOne;

                                if (type ==
                                    DashboardConst.monitorYourselfOne) {
                                  isAdminSelected = true;
                                  isSelfAssign = true;
                                  mobileController.text =
                                      globalStorage.getClientMobileNo();
                                } else {
                                  isAdminSelected = false;
                                  isSelfAssign = false;
                                  nameController.clear();
                                  mobileController.clear();
                                }

                                if (type == DashboardConst.monitorYourselfOne) {
                                  mobileController.text = globalStorage.getClientMobileNo();
                                } else {
                                  nameController.clear();
                                  mobileController.clear();
                                }

                              });
                            },
                          ),

                          /// ERROR
                          if (erroradminMessage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                erroradminMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),

                          const SizedBox(height: 20),

                          /// DROPDOWN (ONLY FOR EXISTING SUPERVISOR)
                          if (selectedType ==
                              DashboardConst.selectExistingOne &&
                              supervisorList.isNotEmpty)
                          /*  DropdownButtonFormField<SupervisorData>(
                  hint: const Text("Select Supervisor"),
                  items: supervisorList.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(
                          "${item.name} (${item.mobile})"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      nameController.text = value.name ?? '';
                      mobileController.text = value.mobile ?? '';
                    }
                  },
                ),*/
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButtonHideUnderline(
                                child:
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // ✅ required (otherwise transparent)
                                    borderRadius: BorderRadius.circular(5), // optional
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<SupervisorData>(
                                      isExpanded: true,


                                      /// ✅ FIX HEIGHT (MAIN FIX)
                                      menuItemStyleData: const MenuItemStyleData(
                                        height: 70,
                                      ),

                                      hint: const Text("Select Supervisor",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 17, fontWeight: FontWeight.w700),),

                                      /// SELECTED VALUE UI
                                      selectedItemBuilder: (context) {
                                        return supervisorList.map((item) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "${item.name} (${item.mobile})",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          );
                                        }).toList();
                                      },

                                      /// DROPDOWN ITEMS
                                      items: supervisorList.map((item) {
                                        return DropdownMenuItem<SupervisorData>(
                                          value: item,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                /// NAME
                                                Text(
                                                  item.isClientSupervisor == true
                                                      ? "${item.name} (You)"
                                                      : (item.name ?? ''),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ),
                                                ),

                                                SizedBox(height: 2,),
                                                /// MOBILE
                                                Text(
                                                  item.mobile ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey,
                                                  ),
                                                ),

                                                const SizedBox(height: 6),

                                                /// DIVIDER
                                                Container(
                                                  height: 1,
                                                  color: Colors.grey.shade300,
                                                ),
                                              ],
                                            ),
                                          ),

                                        );
                                      }).toList(),

                                      onChanged: (value) {
                                        if (value != null) {
                                          nameController.text = value.name ?? '';
                                          mobileController.text = value.mobile ?? '';
                                        }
                                      },

                                      /// DROPDOWN STYLE
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 350,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20), // ✅ radius
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ),),

                          const SizedBox(height: _AdminSheetConstants.sectionSpacing),

                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: const Text(
                              "Add New Supervisor",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: _AdminSheetConstants.sectionSpacing),
                          /// NAME
                          _NameField(controller: nameController , isEnabled: isMonitor || isAssignNew, ),

                          const SizedBox(height: _AdminSheetConstants.spacingMedium , ),

                          /// MOBILE
                          _MobileField(
                              controller: mobileController,
                              isReadOnly: isAdminSelected,
                              isEnabled: isAssignNew
                          ),



                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                      child:
                      _NextButton(
                        onTap: () async {
                          String name = nameController.text.trim();
                          String mobile = mobileController.text.trim();

                          /// 1. RADIO VALIDATION
                          if (selectedType.isEmpty) {
                            setState(() {
                              erroradminMessage = "Please select option";
                            });
                            return;
                          }

                          /// 2. NAME VALIDATION
                          if (name.isEmpty) {
                            setState(() {
                              erroradminMessage = "Please enter name";
                            });
                            return;
                          }

                          /// 3. MOBILE VALIDATION
                          if (mobile.isEmpty) {
                            setState(() {
                              erroradminMessage = "Please enter mobile number";
                            });
                            return;
                          }

                          /// 4. MOBILE LENGTH VALIDATION (optional but recommended)
                          if (mobile.length != 10) {
                            setState(() {
                              erroradminMessage = "Please enter valid 10 digit mobile number";
                            });
                            return;
                          }

                          /// CLEAR ERROR
                          setState(() {
                            erroradminMessage = '';
                          });

                          if (selectedType == DashboardConst.assignSupervisorOne &&
                              mobile.isNotEmpty) {
                            try {
                              EasyLoading.show(
                                  status: "Checking mobile number...");
                              await widget.dashBoardBloc.dashboardService
                                  .checkMobileAvailability(roleId: 2,mobile: mobile);
                            } catch (error) {
                              if (EasyLoading.isShow) {
                                EasyLoading.dismiss();
                              }
                              final errorText = error
                                  .toString()
                                  .replaceFirst("Exception: ", "")
                                  .trim();
                              EasyLoading.showError(errorText);
                              return;
                            }
                            if (EasyLoading.isShow) {
                              EasyLoading.dismiss();
                            }
                          }

                          if (!mounted) {
                            return;
                          }

                          /// NAVIGATION
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AssignTasksScreen(
                                isClientSupervisor: widget.isClientSupervisor,
                                facilityNames: widget.facilityNames,
                                category: widget.category,
                                selectedFacility: widget.selectedFacility,
                                facilityName: widget.facilityName,
                                locality: widget.roleId == 16
                                    ? widget.defaultHostLocation
                                    : widget.loc,
                                clusterId: widget.clusterId,
                                selectedIndex: widget.selectedIndex,
                                facilitydropdownNames: widget.facilitydropdownNames,
                                existingBuddy: widget.existingBuddy,
                                faciltyType: widget.faciltyType,
                                initialSupervisorName: name,
                                initialSupervisorMobile: mobile,
                                initialIsSelfAssign: isSelfAssign,
                                isNewFacilitySetup: true,
                                requiresAddUserForNewSupervisor:
                                selectedType == DashboardConst.assignSupervisorOne,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (supervisorList.isNotEmpty)
                  const SizedBox(height: 20),
                  if (supervisorList.isNotEmpty)
            SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: "Already added a Supervisor, you can Skip this step.\n",
                    ),
                    TextSpan(
                      text: "SKIP",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {

                          final nav = Navigator.of(context);
                          final assignRoute = MaterialPageRoute<void>(
                            builder: (_) => AssignTasksScreen(
                              isClientSupervisor: widget.isClientSupervisor,
                              facilityNames: widget.facilityNames,
                              selectedFacility: widget.selectedFacility,
                              facilityName: widget.facilityName,
                              locality:
                              widget.roleId == 16
                                  ? widget.defaultHostLocation
                                  : widget.loc,
                              clusterId: widget.clusterId,
                              selectedIndex: widget.selectedIndex,
                              facilitydropdownNames: widget.facilitydropdownNames,
                              existingBuddy: widget.existingBuddy,
                              faciltyType:
                             widget.faciltyType,
                            ),
                          );
                          nav.pop();
                          nav.push(assignRoute);

                        },
                    ),
                  ],
                ),
              ),
            ),
          ),



                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

        ),),
    );
  }
}


class _AdminRadioList extends StatelessWidget {
  final String selectedType;
  final Function(String) onChanged;
  final bool hasSupervisor;
  final bool hasClientSupervisor;
  final bool  isClientSupervisor;

  const _AdminRadioList({
    required this.selectedType,
    required this.onChanged,
    required this.hasSupervisor,
    required this.hasClientSupervisor,
    required this.isClientSupervisor,
  });

  @override
  Widget build(BuildContext context) {
    List<ChooseFacilityModel> filteredList = [];

    print("Aarati has client $hasClientSupervisor and is client supervisor $isClientSupervisor");
    for (var item in admin) {
      if (item.title == DashboardConst.selectExistingOne &&
          !hasSupervisor) continue;

      if (item.title == DashboardConst.monitorYourselfOne &&
          (hasClientSupervisor || isClientSupervisor)) continue;



      filteredList.add(item);
    }

    return Column(
      children: filteredList.map((item) {
        return RadioListTile<String>(
          value: item.title!,
          groupValue: selectedType,
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
          title: Text(item.title!),
        );
      }).toList(),
    );
  }
}


class _NameField extends StatelessWidget {
  final TextEditingController controller;
  final bool isEnabled;

  const _NameField({required this.controller ,required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: CustomTextField(
          padding: EdgeInsets.zero,
          controller: controller,
          hintText: DashboardConst.fullName,
          keyboardType: TextInputType.text,
          enabled: isEnabled,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Field cannot be empty or spaces only";
            }
            return null;
          },
        )
    );
  }
}

class _MobileField extends StatelessWidget {
  final TextEditingController controller;
  final bool isReadOnly;
  final bool isEnabled;


  const _MobileField({
    required this.controller,
    required this.isReadOnly,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: CustomTextField(
        padding: EdgeInsets.zero,
        readOnly: isReadOnly,
        controller: controller,
        hintText: DashboardConst.number,

        /// ✅ Only numbers allowed
        keyboardType: TextInputType.number,

        /// ✅ Restrict input
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // no spaces, no special chars
          LengthLimitingTextInputFormatter(10),   // max 10 digits
        ],

        maxLength: 10,
        enabled: isEnabled,

        /// ✅ VALIDATION
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter mobile number";
          }

          /// remove spaces just in case
          String mobile = value.trim();

          if (mobile.length != 10) {
            return "Mobile number must be 10 digits";
          }

          /// ❌ Should not start with 0 or +
          if (mobile.startsWith('0')) {
            return "Mobile number should not start with 0";
          }

          if (mobile.startsWith('+')) {
            return "Mobile number should not start with +";
          }

          /// ❌ Extra safety (though formatter already blocks)
          final regex = RegExp(r'^[1-9][0-9]{9}$');
          if (!regex.hasMatch(mobile)) {
            return "Enter valid mobile number";
          }

          return null;
        },
      ),
    );
  }
}