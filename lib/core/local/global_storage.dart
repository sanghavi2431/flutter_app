import 'package:get_storage/get_storage.dart';

class GlobalStorage {
  final GetStorage _box;
  const GlobalStorage(
    this._box,
  );

  final String _tokenKey = 'accessToken';
  final String _idKey = 'accessId';
  final String _roleIdKey = 'accessRoleId';
  final String _supervisorNameKey = 'accessSupervisorName';
  final String _mobileNumberKey = 'accessMobileNumber';
  final String _locationKey = 'accessLocation';
  final String _latitudeKey = 'accessLatitude';
  final String _longitudeKey = 'accessLongitude';
  final String _currentTimeKey = 'accessCurrentTime';
  final String _currentDateKey = 'accessDate';
  final String _currentoutTimeKey = 'accessOutTime';
  final String _currentoutDateKey = 'accessOutDateTime';
  final String _profileKey = 'profileKey';
  final String _profileImgKey = 'profileImgKey';
  final String _profileshiftKey = 'profileShiftKey';
  final String _cityKey = 'cityKey';
  final String _addressKey = 'addressKey';
  final String _pincodeKey = 'pincodeKey';
   final String _clientIdKey = 'clientIdKey';
   final String _clientmobileNo = 'clientmobileNo';
   final String _planId = 'planId';
   final String _clientToken = 'clientToken';
   final String _paymentId = 'paymentId';
   final String _facilityRef = 'facilityRef';
   final String _onboarding = 'onboarding';
    final String _password = 'password';
     final String _email = 'email';
  
  /// Save Token
  void saveToken({required String accessToken}) {
    if (accessToken.isEmpty) {
      throw 'Access Token is empty';
    }
    _box.write(_tokenKey, accessToken);
  }

  String getToken() {
    String? token = _box.read(_tokenKey);
    return token ?? '';
  }

  void removeToken() {
   

    _box.remove(_tokenKey);
  }

  void saveClientToken({required String accessToken}) {
    if (accessToken.isEmpty) {
      throw 'Access Token is empty';
    }
    _box.write(_clientToken, accessToken);
  }
  String getClientToken() {
    String? token = _box.read(_clientToken);
    return token ?? '';
  }
  
  void removeClientToken() {
    _box.remove(_clientToken);
  }


  void saveProfile({required String profileName }) {
    if (profileName.isEmpty) {
      throw 'Access Token is empty';
    }
    _box.write(_profileKey, profileName);
  }

    void saveProfileImg({required String profileimg }) {
    if (profileimg.isEmpty) {
      throw 'Access Token is empty';
    }
    _box.write(_profileImgKey, profileimg);
  }

    void saveShift({required String shift }) {
    if (shift.isEmpty) {
      throw 'Access Token is empty';
    }
    _box.write(_profileshiftKey, shift);
  }

  String getProfileName() {
    String? name = _box.read(_profileKey);
    return name ?? '';
  }
    String getProfileImage() {
    String? img = _box.read(_profileImgKey);
    return img ?? '';
  }
    String getShift() {
    String? img = _box.read(_profileshiftKey);
    return img ?? '';
  }

  void removeProfile() {
  
    _box.remove(_profileKey);
  }

    void removeProfileImg() {

    _box.remove(_profileImgKey);
  }

    void removeShift() {

    _box.remove(_profileshiftKey);
  }


  void saveJanitorId({required int accessId}) {
    _box.write(_idKey, accessId);
  }

  int getId() {
    int id = _box.read(_idKey);
    return id;
  }

  void removeList() {
    _box.remove(_idKey);

  }

  void saveCheckIn({required bool isCheckedIn}) {
    _box.write("isCheckedIn", isCheckedIn);
  }

  bool isCheckedIn() {
    return _box.read("isCheckedIn") ?? false;
  }

  void removeCheckValue() {
    _box.remove("isCheckedIn");
  }
  //
  // void saveShowList({required bool showList}) {
  //   _box.write("showList", showList);
  // }
  //
  // bool getShowList() {
  //   return _box.read("showList") ?? false;
  // }
  //
  // void removeShowList() {
  //   _box.remove("showList");
  // }

  void saveRoleId({required int accessRoleId}) {
    _box.write(_roleIdKey, accessRoleId);
  }

  int getRoleId() {
    int roleId = _box.read(_roleIdKey);
    return roleId;
  }

  void saveSupervisorName({required String accessSupervisorName}) {
    if (accessSupervisorName.isEmpty) {
      throw 'Supervisor Name is empty';
    }
    _box.write(_supervisorNameKey, accessSupervisorName);
  }



  String getSupervisorName() {
    String? supervisorName = _box.read(_supervisorNameKey);
    return supervisorName ?? '';
  }

  void removeSupervisorName() {
    _box.remove(_supervisorNameKey);
  }

  void saveMobileNumber({required String accessMobileNumber}) {
    if (accessMobileNumber.isEmpty) {
      throw 'Mobile Number is empty';
    }
    _box.write(_mobileNumberKey, accessMobileNumber);
  }

  String getMobileNumber() {
    String? mobileNumber = _box.read(_mobileNumberKey);
    return mobileNumber ?? '';
  }

  void removeMobileNumber() {
    _box.remove(_mobileNumberKey);
  }

  void saveLocation({required String accessLocation}) {
    if (accessLocation.isEmpty) {
      throw 'Location is empty';
    }
    _box.write(_locationKey, accessLocation);
  }

  String getLocation() {
    String? location = _box.read(_locationKey);
    return location ?? '';
  }

  void removeLocation() {
    _box.remove(_locationKey);
  }

  void saveLattitude({required String accessLatitude}) {
    if (accessLatitude.isEmpty) {
      throw 'Latitude is empty';
    }
    _box.write(_latitudeKey, accessLatitude);
  }

  String getLatitude() {
    String? latitude = _box.read(_latitudeKey);
    return latitude ?? '';
  }

  void removeLatitude() {
    _box.remove(_latitudeKey);
  }

  void saveLongitude({required String accessLongitude}) {
    if (accessLongitude.isEmpty) {
      throw 'Latitude is empty';
    }
    _box.write(_longitudeKey, accessLongitude);
  }

  String getLongitude() {
    String? longitude = _box.read(_longitudeKey);
    return longitude ?? '';
  }

  void removeLongitude() {
    _box.remove(_longitudeKey);
  }

  void saveTime({required String accessTime}) {
    if (accessTime.isEmpty) {
      throw 'Time is empty';
    }
    _box.write(_currentTimeKey, accessTime);
  }

    void saveDate({required String accessTime}) {
    if (accessTime.isEmpty) {
      throw 'Time is empty';
    }
    _box.write(_currentDateKey, accessTime);
  }
  void saveOutTime({required String accessTime}) {
    if (accessTime.isEmpty) {
      throw 'Time is empty';
    }
    _box.write(_currentoutTimeKey, accessTime);
  }

    void saveOutDate({required String accessTime}) {
    if (accessTime.isEmpty) {
      throw 'Time is empty';
    }
    _box.write(_currentoutDateKey, accessTime);
  }

  String getTime() {
    String? time = _box.read(_currentTimeKey);
    return time ?? '';
 
  }
  
  String getDate() {
    String? time = _box.read(_currentDateKey);
    return time ?? '';
  }

  String getOutTime() {
    String? time = _box.read(_currentoutTimeKey);
    return time ?? '';
  }

    String getOutDate() {
    String? time = _box.read(_currentoutDateKey);
    return time ?? '';
  }




  void removeTime() {
    _box.remove(_currentTimeKey);
  }
   void removeDate() {
    _box.remove(_currentDateKey);
  }


  void removeOutTime() {
    _box.remove(_currentoutTimeKey);
  }
  void removeOutDate() {
    _box.remove(_currentoutDateKey);
  }



  void saveCity({required String accessCity}) {
    if (accessCity.isEmpty) {
      throw 'City is empty';
    }
    _box.write(_cityKey, accessCity);
  }
  String getCity() {
    String? city = _box.read(_cityKey);
    return city ?? '';
  }
  void removeCity() {
    _box.remove(_cityKey);
  }
  void saveAddress({required String accessAddress}) {
    if (accessAddress.isEmpty) {
      throw 'Address is empty';
    }
    _box.write(_addressKey, accessAddress);
  }
  String getAddress() {
    String? address = _box.read(_addressKey);
    return address ?? '';
  }
  void removeAddress() {
    _box.remove(_addressKey);
  }
  void savePincode({required String accessPincode}) {
    if (accessPincode.isEmpty) {
      throw 'Pincode is empty';
    }
    _box.write(_pincodeKey, accessPincode);
  }
  String getPincode() {
    String? pincode = _box.read(_pincodeKey);
    return pincode ?? '';
  }
  void removePincode() {
    _box.remove(_pincodeKey);
  } 
  
void saveClientId({required String accessClientId}) {
    if (accessClientId.isEmpty) {
      throw 'Client Id is empty';
    }
    _box.write(_clientIdKey, accessClientId);
  }
  String getClientId() {
    String? clientId = _box.read(_clientIdKey);
    return clientId ?? '';
  }
  void removeClientId() {
    _box.remove(_clientIdKey);
  }

  void saveClientMobileNo({required String accessClientMobileNo}) {
    if (accessClientMobileNo.isEmpty) {
      throw 'Client Mobile No is empty';
    }
    _box.write(_clientmobileNo, accessClientMobileNo);
  }
  String getClientMobileNo() {
    String? clientMobileNo = _box.read(_clientmobileNo);
    return clientMobileNo ?? '';
  }
  void removeClientMobileNo() {
    _box.remove(_clientmobileNo);
  }

  void savePlanId({required String accessPlanId}) {
      print("accessPlanId ${accessPlanId.isEmpty}");
    if (accessPlanId.isEmpty) {
      throw 'Client Mobile No is empty';
    }
    _box.write(_planId, accessPlanId);
  }
  String getPlanId() {
    String? planId = _box.read(_planId);
    return planId ?? '';
  }
  void removePlanId() {
    _box.remove(_planId);
  }

  void savePaymentId({required String accessPayemntId}) {
      print("accessPlanId ${accessPayemntId.isEmpty}");
    if (accessPayemntId.isEmpty) {
      throw 'Client Mobile No is empty';
    }
    _box.write(_paymentId, accessPayemntId);
  }

  String getPaymentId() {
    String? paymentId = _box.read(_paymentId);
    return paymentId ?? '';
  }

  void removePaymentId() {
    _box.remove(_paymentId);
  }

 

  void saveFacilityRef({required String accessFacilityRef}) {
      
    if (accessFacilityRef.isEmpty) {
      throw 'Client Mobile No is empty';
    }
    _box.write(_facilityRef, accessFacilityRef);
  }
  String getFacilityRef() {
    String? facilityRef = _box.read(_facilityRef);
    return facilityRef ?? '';
  }
  void removeFacilityRef() {
    _box.remove(_facilityRef);
  }

  void saveOnboarding({required bool isOnboard}) {
    _box.write(_onboarding, isOnboard);
  }
  bool isOnboard() {
    return _box.read(_onboarding) ?? false;
  }
  void removeOnboarding() {
    _box.remove(_onboarding);
  }


  void savePassword({required String password}) {
     if (password.isEmpty) {
      throw 'Client Mobile No is empty';
    }
    _box.write(_password, password);
  }
   String getPassword() {
    return _box.read(_password);
  }
  void removePassword() {
    _box.remove(_password);
  }

   void saveEmail({required String email}) {
     if (email.isEmpty) {
      throw 'Client Mobile No is empty';
    }
    _box.write(_email, email);
  }
   String getEmail() {
    return _box.read(_email) ;
  }
  void removeEmail() {
    _box.remove(_email);
  }






   
  void removeAll() {
    _box.remove(_tokenKey);
    _box.remove(_idKey);
    _box.remove(_roleIdKey);
    _box.remove(_supervisorNameKey);
    _box.remove(_mobileNumberKey);
    _box.remove(_locationKey);
    _box.remove(_latitudeKey);
    _box.remove(_longitudeKey);
    _box.remove(_currentTimeKey);
    _box.remove(_currentDateKey);
    _box.remove(_currentoutTimeKey);
    _box.remove(_currentoutDateKey);
  }
 

}
