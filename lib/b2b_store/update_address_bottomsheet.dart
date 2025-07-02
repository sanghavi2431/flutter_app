import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_bloc.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_event.dart';
import 'package:woloo_smart_hygiene/b2b_store/bloc/b2b_store_state.dart';
import 'package:woloo_smart_hygiene/b2b_store/cart.dart';
import 'package:woloo_smart_hygiene/b2b_store/models/address.dart';
import 'package:woloo_smart_hygiene/utils/app_color.dart';
import 'package:woloo_smart_hygiene/utils/app_textstyle.dart';

class UpdateAddressBottomSheet extends StatefulWidget {
  const UpdateAddressBottomSheet({super.key, this.adress});
  final Addresses? adress;
  @override
  State<UpdateAddressBottomSheet> createState() =>
      _UpdateAddressBottomSheetState();
}

class _UpdateAddressBottomSheetState extends State<UpdateAddressBottomSheet>
    with SingleTickerProviderStateMixin {
  final B2bStoreBloc _b2bStoreBloc = B2bStoreBloc();
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _flatNoController = TextEditingController();
  final _localityController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _labelController = TextEditingController();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BottomSheet.createAnimationController(this);
    if (widget.adress != null) {
      onInit();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _formKey.currentState?.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _flatNoController.dispose();
    _localityController.dispose();
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
        bloc: _b2bStoreBloc,
        listener: (context, state) {
          if (state is AddAddressSuccess) {
            Fluttertoast.showToast(
                msg: "Address Edit successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.lightBlue,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.pop(context);
          }
        },
        builder: (context, snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 238, 238, 238),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(40.r))),
            child: Form(
              key: _formKey,
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
                      Text("Update Address", style: AppTextStyle.font14bold),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: XDecoratedBox(
                          padding: 4,
                          child: XDesignedTextField(
                            hintText: "First Name",
                            controller: _firstNameController,
                            validator: _nameValidator,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: XDecoratedBox(
                          padding: 4,
                          child: XDesignedTextField(
                            hintText: "Last Name",
                            controller: _lastNameController,
                            validator: _nameValidator,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                          ),
                        ),
                      ),
                    ],
                  ),
                  XDecoratedBox(
                    padding: 4,
                    child: XDesignedTextField(
                      hintText: "Address",
                      controller: _flatNoController,
                      validator: _addressValidator,
                      keyboardType: TextInputType.streetAddress,
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: XDecoratedBox(
                          padding: 4,
                          child: XDesignedTextField(
                            hintText: "City",
                            controller: _cityController,
                            validator: _requiredValidator,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: XDecoratedBox(
                          padding: 4,
                          child: XDesignedTextField(
                            hintText: "State",
                            controller: _localityController,
                            validator: _requiredValidator,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                          ),
                        ),
                      ),
                    ],
                  ),
                  XDecoratedBox(
                    padding: 4,
                    child: XDesignedTextField(
                      hintText: "Pincode",
                      controller: _pincodeController,
                      validator: _pincodeValidator,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  XDecoratedBox(
                    padding: 4,
                    child: XDesignedTextField(
                      hintText: "Phone",
                      controller: _phoneController,
                      validator: _phoneValidator,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  XDecoratedBox(
                    padding: 4,
                    child: XDesignedTextField(
                      hintText: "Save as (Home/Office/Others)",
                      controller: _labelController,
                      validator: _requiredValidator,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  LongLabeledButton(
                    label: "Submit",
                    color: AppColors.buttonYellowColor,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        String fullAddress1 = _flatNoController.text.trim();

                        // if (_apartmentController.text.trim().isNotEmpty) {
                        //   fullAddress1 +=
                        //       ", ${_apartmentController.text.trim()}";
                        // }

                        _b2bStoreBloc.add(
                          UpdateAddressReq(
                            addressId: widget.adress!.id!,
                            addressReqBody: AddressReqBody(
                              address1: fullAddress1,
                              addressName: _labelController.text.trim(),
                              city: _cityController.text.trim(),
                              firstName: _firstNameController.text.trim(),
                              lastName: _lastNameController.text.trim(),
                              phone: _phoneController.text.trim(),
                              postalCode: _pincodeController.text.trim(),
                              province: _localityController.text.trim(),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 10.h),
                  MediaQuery.of(context).viewInsets.bottom != 0
                      ? SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom)
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          );
        });
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Please enter valid name';
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

  void onInit() {
    _firstNameController.text = widget.adress!.firstName ?? "";
    _lastNameController.text = widget.adress!.lastName ?? "";

    _flatNoController.text = widget.adress!.address1 ?? "";
    _localityController.text = widget.adress!.province ?? "";
    _apartmentController.text = widget.adress!.address1 ?? "";

    _cityController.text = widget.adress!.city ?? "";
    _pincodeController.text = widget.adress!.postalCode ?? "";
    _phoneController.text = widget.adress!.phone ?? "";
    _labelController.text = widget.adress!.addressName ?? "";
  }
}
