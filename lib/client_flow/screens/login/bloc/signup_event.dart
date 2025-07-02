


import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();
}


class CreateClientEvent extends SignupEvent {
  final String mobileNumber;
  final String name;
  final String email;
  final String password;
  final String address;
  final String city;
  final String pincode;
  const CreateClientEvent({
    required this.mobileNumber,
    required this.email,
    required this.name,
    required this.password,
    required this.address,
    required this.city,
    required this.pincode,

  });

  @override
  List<Object?> get props => [
    mobileNumber,
    email,
    name,
    password
    ];
}


class Signup extends SignupEvent {
  final String? mobileNumber;
  final String? name;
  final String? email;
  final String? password;
  final int clientTypeId;
  final String? address;
  final String? city;
  final String? pincode;
  final int? userId;

  const Signup({
     this.mobileNumber,
     this.email,
     this.name,
     this.password,
    required this.clientTypeId,
     this.address,
     this.city,
     this.pincode,
     this.userId
  });

  @override
  List<Object?> get props => [
    mobileNumber,
    email,
    name,
    password,
    clientTypeId,
    address,
    city,
    pincode,
    userId
  ];
}



class Login extends SignupEvent {
  final String mobileNo;
  // final String password;
  const Login({ 
    required this.mobileNo, 
  //  required this.password
   
   });

  @override
  List<Object?> get props => [
    mobileNo,
    // password
    ];
}



class VerifyOtpEvent extends SignupEvent {
  final String otp;
  // final String requestId;

  // final String password;
  const VerifyOtpEvent({ 
    required this.otp, 
    // required this.requestId
  //  required this.password
   
   });

  @override
  List<Object?> get props => [
    otp,
    // requestId
    // password
    ];
}

class ExpiryEvent extends SignupEvent {
  final int clientId;
  final int  days;
  const ExpiryEvent({ required this.clientId,  required this.days});

  @override
  List<Object?> get props => [
    clientId,
    days
    ];
}


