import 'dart:convert';
import 'package:woloo_smart_hygiene/screens/assign_screen/data/janitor_list_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JanitorListModel Tests', () {
    test('fromJson and toJson work correctly', () {
      const jsonData = '''
      {
        "data": [
          {
            "id": 1,
            "name": "John Doe",
            "mobile": "1234567890",
            "city": "New York",
            "address": "123 Main St",
            "status": true,
            "email": "john.doe@example.com",
            "total": 5
          },
          {
            "id": 2,
            "name": "Jane Smith",
            "mobile": "0987654321",
            "city": "Los Angeles",
            "address": "456 Elm St",
            "status": false,
            "email": "jane.smith@example.com",
            "total": 3
          }
        ],
        "total": 2
      }
      ''';

      // Deserialize JSON to model
      final janitorListModel = janitorListModelFromJson(jsonData);

      // Validate the deserialized data
      expect(janitorListModel.total, 2);
      expect(janitorListModel.data?.length, 2);

      final firstDatum = janitorListModel.data?.first;
      expect(firstDatum?.id, 1);
      expect(firstDatum?.name, 'John Doe');
      expect(firstDatum?.mobile, '1234567890');
      expect(firstDatum?.city, 'New York');
      expect(firstDatum?.address, '123 Main St');
      expect(firstDatum?.status, true);
      expect(firstDatum?.email, 'john.doe@example.com');
      expect(firstDatum?.total, 5);

      // Serialize model back to JSON
      final jsonString = janitorListModelToJson(janitorListModel);

      // Validate that the serialized JSON matches the original JSON
      final decodedJson = json.decode(jsonString);
      expect(decodedJson['total'], 2);
      expect(decodedJson['data'][0]['name'], 'John Doe');
      expect(decodedJson['data'][1]['name'], 'Jane Smith');
    });
  });

  group('Datum Tests', () {
    test('fromJson and toJson work correctly', () {
      const datumJson = '''
      {
        "id": 1,
        "name": "John Doe",
        "mobile": "1234567890",
        "city": "New York",
        "address": "123 Main St",
        "status": true,
        "email": "john.doe@example.com",
        "total": 5
      }
      ''';

      // Deserialize JSON to Datum
      final datum = Datum.fromJson(json.decode(datumJson));

      // Validate the deserialized data
      expect(datum.id, 1);
      expect(datum.name, 'John Doe');
      expect(datum.mobile, '1234567890');
      expect(datum.city, 'New York');
      expect(datum.address, '123 Main St');
      expect(datum.status, true);
      expect(datum.email, 'john.doe@example.com');
      expect(datum.total, 5);

      // Serialize Datum back to JSON
      final serializedJson = json.encode(datum.toJson());

      // Validate that the serialized JSON matches the original JSON
      final decodedJson = json.decode(serializedJson);
      expect(decodedJson['name'], 'John Doe');
      expect(decodedJson['mobile'], '1234567890');
      expect(decodedJson['city'], 'New York');
    });
  });
}
