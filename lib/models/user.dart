import 'dart:io';

class User {
  String username;
  String email;
  File? profileImage; // Optional profile image

  User({
    required this.username,
    required this.email,
    this.profileImage,
  });

  /// Convert User to a Map (useful for local storage or API)
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'profileImagePath': profileImage?.path, // store path as string
    };
  }

  /// Create User from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      profileImage: map['profileImagePath'] != null ? File(map['profileImagePath']) : null,
    );
  }
}
