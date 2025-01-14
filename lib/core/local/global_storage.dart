import 'package:get_storage/get_storage.dart';

class GlobalStorage {
  final GetStorage _box;
  const GlobalStorage(
    this._box,
  );

  final String _tokenKey = 'accessToken';
  final String _idKey = 'accessId';
  final String _roleIdKey = 'accessRoleId';
  final String _fcmTokenKey = 'accessFCMToken';
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
    print("removedtoken");

    _box.remove(_tokenKey);
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
    print("profile");
    _box.remove(_profileKey);
  }

    void removeProfileImg() {
    print("profile");
    _box.remove(_profileImgKey);
  }

    void removeShift() {
    print("profile");
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

}
