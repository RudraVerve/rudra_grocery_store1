import 'dart:convert';

class AddressData {
  String? name;
  String? city;
  String? pin;
  String? post;
  String? houseName;
  String? landmark;

  AddressData({
    required this.name,
    required this.city,
    required this.pin,
    required this.post,
    required this.houseName,
    required this.landmark,
  });

  AddressData.namedConstructor() {
    // Initialization code
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'city': city,
      'pin': pin,
      'post': post,
      'houseName': houseName,
      'landmark': landmark,
    };
  }

  factory AddressData.fromJson(Map<String, dynamic> json) {
    return AddressData(
      name: json['name'],
      city: json['city'],
      pin: json['pin'],
      post: json['post'],
      houseName: json['houseName'],
      landmark: json['landmark'],
    );
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}