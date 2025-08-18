import 'dart:io';

class User {
  String username;
  String email;
  File? profileImage;

  // NEW: saved checkout info
  String? firstName;
  String? lastName;
  String? address;
  String? landmark;
  String? city;
  String? postalCode;
  String? phone;
  String? country;

  User({
    required this.username,
    required this.email,
    this.profileImage,
    this.firstName,
    this.lastName,
    this.address,
    this.landmark,
    this.city,
    this.postalCode,
    this.phone,
    this.country,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'profileImagePath': profileImage?.path,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'landmark': landmark,
      'city': city,
      'postalCode': postalCode,
      'phone': phone,
      'country': country,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      profileImage: map['profileImagePath'] != null ? File(map['profileImagePath']) : null,
      firstName: map['firstName'],
      lastName: map['lastName'],
      address: map['address'],
      landmark: map['landmark'],
      city: map['city'],
      postalCode: map['postalCode'],
      phone: map['phone'],
      country: map['country'],
    );
  }
}
