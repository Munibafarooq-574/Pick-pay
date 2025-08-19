class WishlistManager {
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
    if (!wishlist.any((p) =>
    p['name'] == product['name'] &&
        p['type'] == product['type'])) {
      wishlist.add({
        'name': product['name'],
        'type': product['type'],
        'price': product['price'],
        'imageUrl': product['imageUrl'],
        'category': category, // <-- Added category here
      });
      _wishlists[category] = wishlist;
    }
  }

  // Remove product from wishlist
  void removeFromWishlist(String category, Map<String, dynamic> product) {
    final wishlist = _wishlists[category] ?? [];
    wishlist.removeWhere((p) =>
    p['name'] == product['name'] &&
        p['type'] == product['type']);
    _wishlists[category] = wishlist;
  }
}
