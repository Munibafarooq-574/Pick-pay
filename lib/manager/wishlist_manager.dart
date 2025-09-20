// manager/wishlist_manager.dart
import 'package:flutter/foundation.dart';

class WishlistManager with ChangeNotifier {
  WishlistManager._privateConstructor();
  static final WishlistManager instance = WishlistManager._privateConstructor();

  final Map<String, List<Map<String, dynamic>>> _wishlists = {
    'Clothing': [],
    'Shoes': [],
    'Beauty': [],
    'Accessories': [],
  };

  // Get wishlist for a category
  List<Map<String, dynamic>> getWishlist(String category) {
    return List.unmodifiable(_wishlists[category] ?? []);
  }

  // Add product to wishlist with category info
  void addToWishlist(String category, Map<String, dynamic> product) {
    final wishlist = _wishlists[category] ?? [];
    // Use 'id' for uniqueness if available, fall back to name and type
    final productId = product['id'] as int? ?? 0; // Default to 0 if no id
    if (!wishlist.any((p) => (p['id'] as int?) == productId)) {
      wishlist.add({
        'id': productId,
        'name': product['name'],
        'type': product['type'],
        'price': product['price'],
        'imageUrl': product['imageUrl'],
        'category': category,
      });
      _wishlists[category] = wishlist;
      print('Added to $category wishlist. Current count: ${wishlist.length} - Items: $wishlist');
      notifyListeners(); // Notify listeners of change
    } else {
      print('Duplicate product (id: $productId) not added to $category wishlist. Current count: ${wishlist.length}');
    }
  }

  // Remove product from wishlist
  void removeFromWishlist(String category, Map<String, dynamic> product) {
    final wishlist = _wishlists[category] ?? [];
    final productId = product['id'] as int? ?? 0;
    wishlist.removeWhere((p) => (p['id'] as int?) == productId);
    _wishlists[category] = wishlist;
    print('Removed from $category wishlist. Current count: ${wishlist.length} - Items: $wishlist');
    notifyListeners(); // Notify listeners of change
  }
}