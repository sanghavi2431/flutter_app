import '../client_flow/screens/dashbaord/view/widget/amenities_map.dart';

final Map<String, String> amenityKeys = {
  "is_safe_space": "YES",
  "is_covid_free": "YES",
  "is_clean_and_hygiene": "YES",
  "is_sanitary_pads_available": "YES",
  "is_makeup_room_available": "NO",
  "is_coffee_available": "NO",
  "is_sanitizer_available": "YES",
  "is_feeding_room": "NO",
  "is_wheelchair_accessible": "YES",
  "is_washroom": "Indian",
  "is_premium": "NO",
  "is_franchise": "YES",
  "segregated": "YES",
  "restaurant":"Restaurant"
};

/*final restaurantPayload = {
  "label": "Restaurant",
  "value": "1",
};*/

Map<String, int> buildAmenitiesPayload(Set<String> selectedAmenities) {
  final Map<String, int> payload = {};

  for (final key in amenityMap.keys) {
    payload[key] = selectedAmenities.contains(key) ? 1 : 0;
  }

  return payload;
}


