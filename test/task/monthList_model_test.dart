import 'package:Woloo_Smart_hygiene/screens/attendance_history_screen/data/model/Month_list_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MonthListModel', () {
    test('fromJson initializes correctly from JSON', () {
      final json = {
        'month': 'January',
        'year': '2025',
      };

      final model = MonthListModel.fromJson(json);

      expect(model.month, 'January');
      expect(model.year, '2025');
    });

    test('toJson converts object to correct JSON map', () {
      final model = MonthListModel(
        month: 'February',
        year: '2024',
      );

      final json = model.toJson();

      expect(json['month'], 'February');
      expect(json['year'], '2024');
    });

    test('Handles null values gracefully', () {
      final json = {
        'month': null,
        'year': null,
      };

      final model = MonthListModel.fromJson(json);

      expect(model.month, null);
      expect(model.year, null);

      final toJson = model.toJson();
      expect(toJson['month'], null);
      expect(toJson['year'], null);
    });
  });
}
