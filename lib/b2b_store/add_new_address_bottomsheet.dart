import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_bloc.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_event.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_state.dart';
import 'package:woloo_smart_hygiene/b2b_store/cart.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

import '../client_flow/widgets/CustomTextField.dart';
import '../core/local/global_storage.dart';
import 'models/address.dart';

class AddressBottomSheet extends StatefulWidget {
  String? pincode;
  String? state;
  String? city;
  String? appartment;
  String? flatNo;

  AddressBottomSheet(
      {super.key,
      required this.pincode,
      required this.state,
      required this.city,
      this.appartment,
      this.flatNo});

  @override
  State<AddressBottomSheet> createState() => _AddressBottomSheetState();
}

class _AddressBottomSheetState extends State<AddressBottomSheet>
    with SingleTickerProviderStateMixin {
  B2bStoreBloc? b2bStoreBloc;
  final formKey = GlobalKey<FormState>();
  GlobalStorage globalStorage = GetIt.instance();

  // Add FocusNode for city field
  final FocusNode _cityFocusNode = FocusNode();

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _flatNoController = TextEditingController();
  final _stateController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController(); // Maps to postal_code
  final _phoneController = TextEditingController(); // Maps to phone
  final _labelController = TextEditingController(); // Maps to address_name
  late AnimationController _controller;
  bool isDefault = false;
  String fullAddress1 = "";

  @override
  void initState() {
    super.initState();
    b2bStoreBloc = BlocProvider.of<B2bStoreBloc>(context);
    _controller = BottomSheet.createAnimationController(this);
    _pincodeController.text = widget.pincode?.toString() ?? '';
    _stateController.text = widget.state?.toString() ??
        ''; // Assuming fixed for now, consider making this dynamic
    _cityController.text = widget.city?.toString() ??
        ''; // Assuming fixed for now, consider making this dynamic
    _apartmentController.text = widget.appartment ?? '';
    _flatNoController.text = widget.flatNo ?? '';

    // Initialize the controllers with existing values if needed
    _firstNameController.text = ''; // Set default or existing value
    _lastNameController.text = ''; // Set default or existing value
    _phoneController.text = ''; // Set default or existing value
    _labelController.text = ''; // Set default or existing value
  }

  @override
  void dispose() {
    _controller.dispose();
    _cityFocusNode.dispose(); // Dispose the focus node
    // Don't dispose _formKey.currentState, it's managed by the framework
    _firstNameController.dispose();
    _lastNameController.dispose();
    _flatNoController.dispose();
    _stateController.dispose();
    _apartmentController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _phoneController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B2bStoreBloc, B2BStoreState>(
      bloc: b2bStoreBloc, // Use the bloc instance obtained from context
      listener: (context, state) {
        if (state is AddAddressSuccess) {
          Fluttertoast.showToast(
              msg: "Address added successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pop(context);

          if (isDefault) {
            // print("aress dd ${state.addAddressResBody.customer!.addresses!.indexWhere((e)=> e.address1 == fullAddress1)}");
            //  print("dssss");
            var address = Addresses(
              id: state.addAddressResBody.customer!.addresses!.last.id,
              firstName:
                  state.addAddressResBody.customer!.addresses!.last.firstName,
              lastName:
                  state.addAddressResBody.customer!.addresses!.last.lastName,
              address1: state.addAddressResBody.customer!.addresses!.last
                  .address1, // Combined address
              city: state.addAddressResBody.customer!.addresses!.last.city,
              // Map 'phone' from JSON to 'phone_number' in AddressReq
              phone: state.addAddressResBody.customer!.addresses!.last.phone,
              // Map 'postal_code' from JSON to 'pincode' in AddressReq
              postalCode:
                  state.addAddressResBody.customer!.addresses!.last.postalCode,
              province:
                  state.addAddressResBody.customer!.addresses!.last.province,
              // _stateController.text
              //     .trim(), // Assuming fixed for now, consider making this dynamic
              // Map 'address_name' from JSON to 'address_name' in AddressReq
              addressName:
                  state.addAddressResBody.customer!.addresses!.last.addressName,
            );
            // );

            // BlocProvider.of<B2bStoreBloc>(context).add(UpdateAddress(addressesData: address));
            b2bStoreBloc!.add(UpdateAddress(addressesData: address));

            globalStorage.saveAddress(accessAddress: address);
          } else {
            globalStorage.removeAddress();
          }
          // Navigator.pop(context);
        }
      },
      builder: (context, snapshot) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 238, 238, 238),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(40.r))),
            child: Form(
              key: formKey,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 2.h,
                children: [
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_sharp)),
                      SizedBox(width: 10.w),
                      Text("Add New Address", style: AppTextStyle.font14bold),
                    ],
                  ),
                  SizedBox(height: 10.h), // Added spacing
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: CustomTextField(
                          padding: const EdgeInsets.all(0),
                          // focusNode: facilityFocusNode,
                          hintText: "First Name *",
                          controller: _firstNameController,
                          validator: _nameValidator,
                          //  (value,) {
                          //     if (value == null || value.isEmpty) {
                          //       return "City is required";
                          //     }
                          //     return null;
                          //   },
                          keyboardType: TextInputType.streetAddress,
                        ),
                        // SizedBox(
                        //   height: 40.h,
                        //   child: XDecoratedBox(
                        //     padding: 6,
                        //     child:
                        //      XDesignedTextField(
                        //       hintText: "First Name",
                        //       controller: _firstNameController,
                        //       validator: _nameValidator,
                        //       keyboardType: TextInputType.name,
                        //       textCapitalization: TextCapitalization.words,
                        //     ),
                        //   ),
                        // ),
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        flex: 1,
                        child: CustomTextField(
                          padding: const EdgeInsets.all(0),
                          // focusNode: facilityFocusNode,
                          hintText: "Last Name *",
                          controller: _lastNameController,
                          validator: _lastValidator,
                          //  (value,) {
                          //     if (value == null || value.isEmpty) {
                          //       return "City is required";
                          //     }
                          //     return null;
                          //   },
                          keyboardType: TextInputType.streetAddress,
                        ),
                        //  SizedBox(
                        //   height: 40.h,
                        //   child: XDecoratedBox(
                        //     padding: 4,
                        //     child: XDesignedTextField(
                        //       hintText: "Last Name",
                        //       controller: _lastNameController,
                        //       validator: _lastValidator,
                        //       keyboardType: TextInputType.name,
                        //       textCapitalization: TextCapitalization.words,
                        //     ),
                        //   ),
                        // ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    padding: const EdgeInsets.all(0),
                    // focusNode: facilityFocusNode,
                    hintText: "Flat No. *",
                    controller: _flatNoController,
                    validator: _flatValidator,
                    //  (value,) {
                    //     if (value == null || value.isEmpty) {
                    //       return "City is required";
                    //     }
                    //     return null;
                    //   },
                    keyboardType: TextInputType.streetAddress,
                  ),
                  // SizedBox(
                  //   height: 40.h,
                  //   child: XDecoratedBox(
                  //     padding: 4,
                  //     child: XDesignedTextField(
                  //       hintText: "Flat No.",
                  //       controller: _flatNoController,
                  //       validator: _flatValidator,
                  //       keyboardType: TextInputType.streetAddress,
                  //       textCapitalization: TextCapitalization.words,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    padding: const EdgeInsets.all(0),
                    // focusNode: facilityFocusNode,
                    hintText: "Apartment Name/Road/Area *",
                    controller: _apartmentController,
                    validator: _apartmentValidator,
                    //  (value,) {
                    //     if (value == null || value.isEmpty) {
                    //       return "City is required";
                    //     }
                    //     return null;
                    //   },
                    keyboardType: TextInputType.streetAddress,
                  ),

                  // SizedBox(
                  //   height: 40.h,
                  //   child: XDecoratedBox(
                  //     padding: 4,
                  //     child: XDesignedTextField(
                  //       hintText: "Apartment Name/Road/Area",
                  //       controller: _apartmentController,
                  //       validator: _apartmentValidator,
                  //       keyboardType: TextInputType.streetAddress,
                  //       textCapitalization: TextCapitalization.words,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Focus(
                          onFocusChange: (hasFocus) {
                            // Prevent losing focus if the field has content
                            if (!hasFocus && _cityController.text.isNotEmpty) {
                              FocusScope.of(context).requestFocus(FocusNode());
                            }
                          },
                          child: Stack(
                            children: [
                              CustomTextField(
                                padding: const EdgeInsets.all(0),
                                // focusNode: facilityFocusNode,
                                hintText: "City *",
                                controller: _cityController,
                                validator: (
                                  value,
                                ) {
                                  if (value == null || value.isEmpty) {
                                    return "City is required";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.streetAddress,
                              ),
                              //                  SizedBox(
                              //   height: 40.h,
                              //   child: XDecoratedBox(
                              //     padding: 4,
                              //     child: XDesignedTextField(
                              //       hintText: "City",
                              //       controller: _cityController,
                              //       validator:(value,) {
                              //                     if (value == null || value.isEmpty) {
                              //                       return "City is required";
                              //                     }
                              //                     return null;
                              //                   },
                              //       keyboardType: TextInputType.streetAddress,
                              //       textCapitalization: TextCapitalization.words,
                              //     ),
                              //   ),
                              // ),
                              // GooglePlaceAutoCompleteTextField(
                              //   placeType: PlaceType.cities,
                              //   textEditingController: _cityController,
                              //   focusNode: _cityFocusNode,
                              //   googleAPIKey:
                              //       "AIzaSyCkPmUz4UlRdzcKG9gniW9Qfrgzsjhnb_4",
                              //   inputDecoration: InputDecoration(
                              //     contentPadding: EdgeInsets.symmetric(
                              //         horizontal: 10.w, vertical: 12.h),
                              //     hintText: "City",
                              //     hintStyle: TextStyle(
                              //       color: Colors.grey,
                              //       fontSize: 14.sp,
                              //     ),
                              //     border: InputBorder.none,
                              //   ),
                              //   debounceTime: 800,
                              //   countries: const ["in"],
                              //   isLatLngRequired: false,
                              //   getPlaceDetailWithLatLng:
                              //       (Prediction prediction) {},
                              //   itemClick: (Prediction prediction) {
                              //     final parts =
                              //         prediction.description?.split(',') ??
                              //             [];
                              //     if (parts.isNotEmpty) {
                              //       _cityController.text = parts[0].trim();
                              //       if (parts.length > 1) {
                              //         _stateController.text =
                              //             parts[1].trim();
                              //       }
                              //       // Keep focus on city field
                              //       _cityFocusNode.requestFocus();
                              //     }
                              //   },
                              //   itemBuilder: (context, index,
                              //       Prediction prediction) {
                              //     return Container(
                              //       padding: EdgeInsets.symmetric(
                              //           horizontal: 10.w, vertical: 8.h),
                              //       child: Row(
                              //         children: [
                              //           const Icon(Icons.location_on,
                              //               color: Colors.grey),
                              //           SizedBox(width: 8.w),
                              //           Expanded(
                              //             child: Text(
                              //               prediction.description ?? "",
                              //               style:
                              //                   TextStyle(fontSize: 14.sp),
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     );
                              //   },
                              //   validator: (value, p1) {
                              //     if (value == null || value.isEmpty) {
                              //       return "City is required";
                              //     }
                              //     return null;
                              //   },
                              // ),
                              // Transparent overlay to prevent focus loss
                              if (_cityController.text.isNotEmpty)
                                Positioned.fill(
                                  child: GestureDetector(
                                    onTap: () => _cityFocusNode.requestFocus(),
                                    behavior: HitTestBehavior.translucent,
                                    child: Container(color: Colors.transparent),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        flex: 1,
                        child: CustomTextField(
                          padding: const EdgeInsets.all(0),
                          // focusNode: facilityFocusNode,
                          hintText: "State *",
                          controller: _stateController,
                          validator: (
                            value,
                          ) {
                            if (value == null || value.isEmpty) {
                              return "State is required";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.streetAddress,
                        ),
                        // SizedBox(
                        //   height: 40.h,
                        //   child: XDecoratedBox(
                        //     padding: 4,
                        //     child: XDesignedTextField(
                        //       hintText: "State",
                        //       controller: _stateController,
                        //        validator:(value,) {
                        //           if (value == null || value.isEmpty) {
                        //                 return "State is required";
                        //               }
                        //               return null;
                        //             },
                        //       // State will be auto-filled from city selection
                        //     ),
                        //   ),
                        // ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    padding: const EdgeInsets.all(0),
                    // focusNode: facilityFocusNode,
                    hintText: "Pincode *",
                    controller: _pincodeController,
                    validator: _pincodeValidator,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    padding: const EdgeInsets.all(0),
                    // focusNode: facilityFocusNode,
                    hintText: "Phone *",
                    maxLength: 10,
                    controller: _phoneController,
                    validator: _phoneValidator,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    padding: const EdgeInsets.all(0),
                    // focusNode: facilityFocusNode,
                    hintText: "Save as (Home/Office/Others) *",
                    controller: _labelController,
                    validator: _requiredValidator,
                    keyboardType: TextInputType.text,
                  ),
                  // XDesignedTextField(
                  //   hintText: "Save as (Home/Office/Others)",
                  //   controller: _labelController,
                  //   validator: _requiredValidator,
                  //   keyboardType: TextInputType.text,
                  //   textCapitalization: TextCapitalization.words,
                  // ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      XDesignedRadioButton(
                        onSelected: isDefault,
                        onTap: () {
                          isDefault = !isDefault;
                          setState(() {});
                          //  print("adress ${globalStorage.getAddress()} ");
                        },
                      ),
                      SizedBox(width: 15.h),
                      Text(
                        "Make it as Default Address",
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h), // Spacing before button
                  LongLabeledButton(
                    label: "Submit",
                    color: AppColors.buttonYellowColor,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        // Combine address fields for `address_1` as per your JSON structure
                        fullAddress1 = _flatNoController.text.trim();
                        if (_apartmentController.text.trim().isNotEmpty) {
                          fullAddress1 +=
                              ", ${_apartmentController.text.trim()}";
                        }

                        // _b2bStoreBloc.add(
                        final v = AddressReq(
                          first_name: _firstNameController.text.trim(),
                          last_name: _lastNameController.text.trim(),
                          address_1: fullAddress1, // Combined address
                          city: _cityController.text.trim(),
                          // Map 'phone' from JSON to 'phone_number' in AddressReq
                          phone_number: _phoneController.text.trim(),
                          // Map 'postal_code' from JSON to 'pincode' in AddressReq
                          pincode: _pincodeController.text.trim(),
                          province: _stateController.text
                              .trim(), // Assuming fixed for now, consider making this dynamic
                          // Map 'address_name' from JSON to 'address_name' in AddressReq
                          address_name: _labelController.text.trim(),
                        );
                        //logger.w(v);
                        b2bStoreBloc!.add(v);
                        print("dssss $isDefault");

                        //  if (isDefault) {
                        //    print("dssss");
                        //      var address =    Addresses(
                        //   firstName: _firstNameController.text.trim(),
                        //   lastName: _lastNameController.text.trim(),
                        //   address1: fullAddress1, // Combined address
                        //   city: _cityController.text.trim(),
                        //   // Map 'phone' from JSON to 'phone_number' in AddressReq
                        //   phone: _phoneController.text.trim(),
                        //   // Map 'postal_code' from JSON to 'pincode' in AddressReq
                        //   postalCode: _pincodeController.text.trim(),
                        //   province: _stateController.text
                        //       .trim(), // Assuming fixed for now, consider making this dynamic
                        //   // Map 'address_name' from JSON to 'address_name' in AddressReq
                        //   addressName: _labelController.text.trim(),
                        // );
                        // // );

                        //       // BlocProvider.of<B2bStoreBloc>(context).add(UpdateAddress(addressesData: address));
                        //                        b2bStoreBloc!.add(
                        //                          UpdateAddress(addressesData: address)
                        //                         );

                        //            globalStorage.saveAddress(accessAddress: address);

                        //  }else {

                        //     globalStorage.removeAddress();
                        //  }
                      }
                    },
                  ),
                  SizedBox(height: 10.h), // Spacing below button
                  // If the bottom sheet might be covering the keyboard,
                  // add some padding at the bottom.
                  MediaQuery.of(context).viewInsets.bottom != 0
                      ? SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom)
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Save as (Home/ office / others)  is required';
    }
    return null;
  }

  String? _nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'First name is required';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Please enter valid first name';
    }
    return null;
  }

  String? _lastValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Last name is required';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Please enter valid last name';
    }
    return null;
  }

  String? _flatValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Flat no. is required';
    }
    // if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
    //   return 'Please enter valid flat no.';
    // }
    return null;
  }

  String? _apartmentValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Apartment name is required';
    }
    // if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
    //   return 'Please enter valid apartment name';
    // }
    return null;
  }

  //   String? _apartmentValidator(String? value) {
  //   if (value == null || value.trim().isEmpty) {
  //     return 'Apartment name is required';
  //   }
  //   if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
  //     return 'Please enter valid name';
  //   }
  //   return null;
  //  }

  String? _pincodeValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Pincode is required';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Please enter valid 6-digit pincode';
    }
    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Please enter valid 10-digit mobile number';
    }
    return null;
  }

  String? _addressValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (value.trim().length < 5) {
      return 'Address is too short';
    }
    return null;
  }
}

class XDesignedRadioButton extends StatelessWidget {
  const XDesignedRadioButton({
    super.key,
    this.onSelected = false,
    this.onTap,
  });
  final bool onSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(6),
            border: Border.all()),
        child: Center(
          child: Container(
            height: 23,
            width: 23,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(),
                color: onSelected ? Colors.green : null),
          ),
        ),
      ),
    );
  }
}
