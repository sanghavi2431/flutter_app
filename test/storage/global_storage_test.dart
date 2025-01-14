import 'package:Woloo_Smart_hygiene/core/local/global_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// import 'package:your_project/global_storage.dart';

class MockPathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String> getApplicationDocumentsPath() async {
    // print(" getApplicationDocumentsPath  ${Directory.systemTemp.path}");
    return Directory.systemTemp.path; // Use a temporary directory for testing
  }
}

void main() {
  late GlobalStorage globalStorage;
  late GetStorage getStorage;

  setUpAll(() async {
    // Mock the path provider
    PathProviderPlatform.instance = MockPathProviderPlatform();
    await GetStorage.init('testStorage'); // Initialize GetStorage
  });

  setUp(() {
    getStorage = GetStorage('testStorage');
    globalStorage = GlobalStorage(getStorage);
  });

  tearDown(() async {
    await getStorage.erase(); // Clear storage after each test
  });

  test('save and get token', () {
    globalStorage.saveToken(accessToken: 'testToken');
     print(" token  ${globalStorage.getToken()}");
    expect(globalStorage.getToken(), 'testToken');
  });

  test('remove token', () {
    globalStorage.saveToken(accessToken: 'testToken');
    globalStorage.removeToken();
    expect(globalStorage.getToken(), '');
  });


  group('Profile Tests', () {
    test('save and get profile name', () {
      globalStorage.saveProfile(profileName: 'Shrirang Jangam');
      expect(globalStorage.getProfileName(), 'Shrirang Jangam');
    });

    test('save profile with empty name throws error', () {
      expect(() => globalStorage.saveProfile(profileName: ''), throwsA('Access Token is empty'));
    });

    test('remove profile name', () {
      globalStorage.saveProfile(profileName: 'Shrirang Jangam');
      globalStorage.removeProfile();
      expect(globalStorage.getProfileName(), '');
    });
  });

  group('Profile Image Tests', () {
    test('save and get profile image', () {
      globalStorage.saveProfileImg(profileimg: 'profile.jpg');
      expect(globalStorage.getProfileImage(), 'profile.jpg');
    });

    test('save profile image with empty string throws error', () {
      expect(() => globalStorage.saveProfileImg(profileimg: ''), throwsA('Access Token is empty'));
    });

    test('remove profile image', () {
      globalStorage.saveProfileImg(profileimg: 'profile.jpg');
      globalStorage.removeProfileImg();
      expect(globalStorage.getProfileImage(), '');
    });
  });

  group('Shift Tests', () {
    test('save and get shift', () {
      globalStorage.saveShift(shift: 'Morning');
      expect(globalStorage.getShift(), 'Morning');
    });

    test('save shift with empty string throws error', () {
      expect(() => globalStorage.saveShift(shift: ''), throwsA('Access Token is empty'));
    });

    test('remove shift', () {
      globalStorage.saveShift(shift: 'Morning');
      globalStorage.removeShift();
      expect(globalStorage.getShift(), '');
    });
  });


   group('Janitor ID Tests', () {
    test('save and get janitor ID', () {
      globalStorage.saveJanitorId(accessId: 126);
      expect(globalStorage.getId(), 126);
    });

    test('get janitor ID without saving should throw error', () {
      expect(() => globalStorage.getId(), throwsA(isA<TypeError>()));
    });

    test('remove janitor ID', () {
      globalStorage.saveJanitorId(accessId: 126);
      globalStorage.removeList();
      expect(() => globalStorage.getId(), throwsA(isA<TypeError>()));
    });
  });

  group('Check-In Tests', () {
    test('save and get check-in status', () {
      globalStorage.saveCheckIn(isCheckedIn: true);
      expect(globalStorage.isCheckedIn(), true);
    });

    test('default check-in status should be false', () {
      expect(globalStorage.isCheckedIn(), false);
    });

    test('remove check-in status', () {
      globalStorage.saveCheckIn(isCheckedIn: true);
      globalStorage.removeCheckValue();
      expect(globalStorage.isCheckedIn(), false);
    });

  });

    group('Role ID Tests', () {
    test('save and get role ID', () {
      globalStorage.saveRoleId(accessRoleId: 1);
      expect(globalStorage.getRoleId(), 1);
    });

    test('get role ID without saving should throw error', () {
      expect(() => globalStorage.getRoleId(), throwsA(isA<TypeError>()));
    });
  });

  group('Supervisor Name Tests', () {
    test('save and get supervisor name', () {
      globalStorage.saveSupervisorName(accessSupervisorName: 'Abhjit malkapure');
      expect(globalStorage.getSupervisorName(), 'Abhjit malkapure');
    });

    test('saving empty supervisor name should throw error', () {
      expect(
          () => globalStorage.saveSupervisorName(accessSupervisorName: ''),
          throwsA('Supervisor Name is empty'));
    });

    test('remove supervisor name', () {
      globalStorage.saveSupervisorName(accessSupervisorName: 'Abhjit malkapure');
      globalStorage.removeSupervisorName();
      expect(globalStorage.getSupervisorName(), '');
    });
  });

  group('Mobile Number Tests', () {
    test('save and get mobile number', () {
      globalStorage.saveMobileNumber(accessMobileNumber: '8097267015');
      expect(globalStorage.getMobileNumber(), '8097267015');
    });

    test('saving empty mobile number should throw error', () {
      expect(
          () => globalStorage.saveMobileNumber(accessMobileNumber: ''),
          throwsA('Mobile Number is empty'));
    });

    test('remove mobile number', () {
      globalStorage.saveMobileNumber(accessMobileNumber: '8097267015');
      globalStorage.removeMobileNumber();
      expect(globalStorage.getMobileNumber(), '');
    });
  });


  
  group('Location Tests', () {
    test('save and get location', () {
      globalStorage.saveLocation(accessLocation: 'Mumbai');
      expect(globalStorage.getLocation(), 'Mumbai');
    });

    test('saving empty location should throw error', () {
      expect(() => globalStorage.saveLocation(accessLocation: ''), throwsA('Location is empty'));
    });

    test('remove location', () {
      globalStorage.saveLocation(accessLocation: 'Mumbai');
      globalStorage.removeLocation();
      expect(globalStorage.getLocation(), '');
    });
  });

  group('Latitude and Longitude Tests', () {
    test('save and get latitude', () {
      globalStorage.saveLattitude(accessLatitude: '40.7128° N');
      expect(globalStorage.getLatitude(), '40.7128° N');
    });

    test('saving empty latitude should throw error', () {
      expect(() => globalStorage.saveLattitude(accessLatitude: ''), throwsA('Latitude is empty'));
    });

    test('remove latitude', () {
      globalStorage.saveLattitude(accessLatitude: '40.7128° N');
      globalStorage.removeLatitude();
      expect(globalStorage.getLatitude(), '');
    });

    test('save and get longitude', () {
      globalStorage.saveLongitude(accessLongitude: '74.0060° W');
      expect(globalStorage.getLongitude(), '74.0060° W');
    });

    test('saving empty longitude should throw error', () {
      expect(() => globalStorage.saveLongitude(accessLongitude: ''), throwsA('Latitude is empty'));
    });

    test('remove longitude', () {
      globalStorage.saveLongitude(accessLongitude: '74.0060° W');
      globalStorage.removeLongitude();
      expect(globalStorage.getLongitude(), '');
    });
  });

  group('Date and Time Tests', () {
    test('save and get current time', () {
      globalStorage.saveTime(accessTime: '10:30 AM');
      expect(globalStorage.getTime(), '10:30 AM');
    });

    test('saving empty current time should throw error', () {
      expect(() => globalStorage.saveTime(accessTime: ''), throwsA('Time is empty'));
    });

    test('remove current time', () {
      globalStorage.saveTime(accessTime: '10:30 AM');
      globalStorage.removeTime();
      expect(globalStorage.getTime(), '');
    });

    test('save and get current date', () {
      globalStorage.saveDate(accessTime: '2025-01-10');
      expect(globalStorage.getDate(), '2025-01-10');
    });

    test('remove current date', () {
      globalStorage.saveDate(accessTime: '2025-01-10');
      globalStorage.removeDate();
      expect(globalStorage.getDate(), '');
    });

    test('save and get out time', () {
      globalStorage.saveOutTime(accessTime: '6:00 PM');
      expect(globalStorage.getOutTime(), '6:00 PM');
    });

    test('remove out time', () {
      globalStorage.saveOutTime(accessTime: '6:00 PM');
      globalStorage.removeOutTime();
      expect(globalStorage.getOutTime(), '');
    });

    test('save and get out date', () {
      globalStorage.saveOutDate(accessTime: '2025-01-10');
      expect(globalStorage.getOutDate(), '2025-01-10');
    });

    test('remove out date', () {
      globalStorage.saveOutDate(accessTime: '2025-01-10');
      globalStorage.removeOutDate();
      expect(globalStorage.getOutDate(), '');
    });
  });





  // Add additional tests here
}
