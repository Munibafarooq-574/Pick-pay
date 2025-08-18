import 'package:flutter/material.dart';

class CartManager {
  CartManager._privateConstructor();
  static final CartManager instance = CartManager._privateConstructor();

  // Reactive list of cart items
  final ValueNotifier<List<Map<String, dynamic>>> cartItemsNotifier = ValueNotifier([]);

  void addToCart(Map<String, dynamic> product) {
    final currentItems = cartItemsNotifier.value;
    int index = currentItems.indexWhere((item) => item['name'] == product['name']);

    if (index != -1) {
      // Product exists → increment quantity
      currentItems[index]['quantity'] += 1;
      cartItemsNotifier.value = [...currentItems]; // Trigger UI update
    } else {
      // Product not in cart → add with quantity 1
      cartItemsNotifier.value = [
        ...currentItems,
        {
          'name': product['name'] ?? 'Unknown Product',
          'price': product['price'] ?? 0.0,
          'quantity': 1,
          'category': product['type'] ?? 'Unknown',
          'imageUrl': product['imageUrl'] ?? '',
        }
      ];
    }
  }

  void updateQuantity(int index, int quantity) {
    final currentItems = cartItemsNotifier.value;
    if (index >= 0 && index < currentItems.length) {
      if (quantity <= 0) {
        currentItems.removeAt(index);
      } else {
        currentItems[index]['quantity'] = quantity;
      }
      cartItemsNotifier.value = [...currentItems]; // Trigger UI update
    }
  }

  void clearCart() => cartItemsNotifier.value = [];

  double getTotal() {
    return cartItemsNotifier.value.fold(
        0, (sum, item) => sum + (item['price'] * item['quantity']));
  }
}