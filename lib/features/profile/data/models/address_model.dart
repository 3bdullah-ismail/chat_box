class AddressModel {
  final double latitude;
  final double longitude;
  final String address;
  final String city;

  const AddressModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
  });

  Map<String, dynamic> toMap() => {
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
    'city': city,
  };

  String get displayAddress {
    final parts = <String>[];
    if (address.isNotEmpty) parts.add(address);
    if (city.isNotEmpty && city != address) parts.add(city);
    return parts.join(', ');
  }
}
