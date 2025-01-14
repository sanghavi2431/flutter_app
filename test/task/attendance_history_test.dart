import 'package:Woloo_Smart_hygiene/screens/attendance_history_screen/data/model/Attendance_history_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AttendanceHistoryModel', () {
    test('fromJson initializes correctly from JSON', () {
      final json = {
        'check_in': '09:00 AM',
        'check_out': '05:00 PM',
        'day_of_week': 'Monday',
        'date': '2025-01-08',
        'attendance': 'Present',
      };

      final model = AttendanceHistoryModel.fromJson(json);

      expect(model.checkIn, '09:00 AM');
      expect(model.checkOut, '05:00 PM');
      expect(model.dayOfWeek, 'Monday');
      expect(model.date, '2025-01-08');
      expect(model.attendance, 'Present');
    });

    test('toJson converts object to correct JSON map', () {
      final model = AttendanceHistoryModel(
        checkIn: '10:00 AM',
        checkOut: '06:00 PM',
        dayOfWeek: 'Tuesday',
        date: '2025-01-09',
        attendance: 'Absent',
      );

      final json = model.toJson();

      expect(json['check_in'], '10:00 AM');
      expect(json['check_out'], '06:00 PM');
      expect(json['day_of_week'], 'Tuesday');
      expect(json['date'], '2025-01-09');
      expect(json['attendance'], 'Absent');
    });

    test('Handles null values gracefully', () {
      final json = {
        'check_in': null,
        'check_out': null,
        'day_of_week': null,
        'date': null,
        'attendance': null,
      };

      final model = AttendanceHistoryModel.fromJson(json);

      expect(model.checkIn, null);
      expect(model.checkOut, null);
      expect(model.dayOfWeek, null);
      expect(model.date, null);
      expect(model.attendance, null);

      final toJson = model.toJson();
      expect(toJson['check_in'], null);
      expect(toJson['check_out'], null);
      expect(toJson['day_of_week'], null);
      expect(toJson['date'], null);
      expect(toJson['attendance'], null);
    });
  });
}
