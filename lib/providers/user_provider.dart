import 'dart:io';
import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user; // Nullable user for dynamic login/signup

  /// Get current user
  User? get user => _user;

  /// Check if user is logged in
  bool get isLoggedIn => _user != null;

  /// Initialize or update user data
  void setUser({
    required String username,
    required String email,
    File? profileImage,
  }) {
    _user = User(
      username: username,
      email: email,
      profileImage: profileImage,
    );
    notifyListeners();
  }

  /// Update individual fields of the user
  void updateUser({
    String? username,
    String? email,
    File? profileImage,
    bool clearProfileImage = false,
  }) {
    if (_user == null) return; // no user to update

    if (username != null) _user!.username = username;
    if (email != null) _user!.email = email;

    if (clearProfileImage) {
      _user!.profileImage = null;
    } else if (profileImage != null) {
      _user!.profileImage = profileImage;
    }

    notifyListeners();
  }

  void saveCheckoutInfo({
    String? email,
    String? firstName,
    String? lastName,
    String? address,
    String? landmark,
    String? city,
    String? postalCode,
    String? phone,
    String? country,
  }) {
    if (_user == null) return;
    if (email != null) _user!.email = email;
    _user!.firstName = firstName ?? _user!.firstName;
    _user!.lastName = lastName ?? _user!.lastName;
    _user!.address = address ?? _user!.address;
    _user!.landmark = landmark ?? _user!.landmark;
    _user!.city = city ?? _user!.city;
    _user!.postalCode = postalCode ?? _user!.postalCode;
    _user!.phone = phone ?? _user!.phone;
    _user!.country = country ?? _user!.country;

    notifyListeners();
  }

  /// Clear user data on logout
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
