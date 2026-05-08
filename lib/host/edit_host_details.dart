class UpdateHostRequest {
  final String? address;
  final String? mobile;
  final String? city;
  final Map<String, int> amenities; // flat amenities
  final String? lat;
  final String? lng;

  UpdateHostRequest({
    this.address,
    this.mobile,
    this.city,
    required this.amenities,
    this.lat,
    this.lng,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (mobile != null && mobile!.isNotEmpty) {
      data['mobile'] = mobile;
    }

    if (address != null && address!.isNotEmpty) {
      data['address'] = address;
    }

    if (city != null && city!.isNotEmpty) {
      data['city'] = city;
    }

    data.addAll(amenities); // <-- FLAT amenities

    if (lat != null) data['lat'] = lat;
    if (lng != null) data['lng'] = lng;

    return data;
  }
}
