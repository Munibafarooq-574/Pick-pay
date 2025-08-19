import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // for json encode/decode
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  // ---------- Orders ----------
  List<Map<String, dynamic>> _orders = [];
  List<Map<String, dynamic>> get orders => _orders;

  void addOrder(Map<String, dynamic> order) {
    final fixedOrder = {
      ...order,
      'id': '#ORD${DateTime.now().millisecondsSinceEpoch}', // unique ID
      'items': (order['items'] is List) ? order['items'] : <Map<String, dynamic>>[],
      'status': 'ongoing', // ✅ default status
      'date': order['date'] ?? DateTime.now().toIso8601String(),
    };

    _orders.add(fixedOrder);
    notifyListeners();
    _saveOrdersToPrefs();
  }



  Future<void> _saveOrdersToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("orders", jsonEncode(_orders));
  }

  Future<void> _loadOrdersFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("orders")) {
      final data = prefs.getString("orders");
      if (data != null) {
        _orders = List<Map<String, dynamic>>.from(jsonDecode(data));
        notifyListeners();
      }
    }
  }

  // ---------- User Methods ----------
  Future<void> setUser({
    required String username,
    required String email,
    File? profileImage,
  }) async {
    _user = User(username: username, email: email, profileImage: profileImage);
    notifyListeners();
    await _saveToPrefs();
  }

  Future<void> updateUser({
    String? username,
    String? email,
    File? profileImage,
    bool clearProfileImage = false,
  }) async {
    if (_user == null) return;

    if (username != null) _user!.username = username;
    if (email != null) _user!.email = email;

    if (clearProfileImage) {
      _user!.profileImage = null;
    } else if (profileImage != null) {
      _user!.profileImage = profileImage;
    }

    notifyListeners();
    await _saveToPrefs();
  }

  Future<void> saveCheckoutInfo({
    String? email,
    String? firstName,
    String? lastName,
    String? address,
    String? landmark,
    String? city,
    String? postalCode,
    String? phone,
    String? country,
  }) async {
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
    await _saveToPrefs();
  }

  Future<void> clearUser() async {
    _user = null;
    _orders = [];
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ---------- SharedPreferences Helpers ----------
  Future<void> _saveToPrefs() async {
    if (_user == null) return;
    final prefs = await SharedPreferences.getInstance();
    final data = _user!.toMap();
    for (final entry in data.entries) {
      if (entry.value != null) {
        await prefs.setString(entry.key, entry.value.toString());
      }
    }
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('email')) return;

    _user = User.fromMap({
      'username': prefs.getString('username'),
      'email': prefs.getString('email'),
      'firstName': prefs.getString('firstName'),
      'lastName': prefs.getString('lastName'),
      'address': prefs.getString('address'),
      'landmark': prefs.getString('landmark'),
      'city': prefs.getString('city'),
      'postalCode': prefs.getString('postalCode'),
      'phone': prefs.getString('phone'),
      'country': prefs.getString('country'),
    });

    await _loadOrdersFromPrefs(); // ⬅️ Load orders on app start
    notifyListeners();
  }

  // Remove a specific order by index
  void removeOrder(int index) {
    if (index >= 0 && index < _orders.length) {
      _orders.removeAt(index);
      notifyListeners();
      _saveOrdersToPrefs(); // Don't forget to persist changes
    }
  }

}
