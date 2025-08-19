// screens/wishlist_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../manager/wishlist_manager.dart';
import '../manager/cart_manager.dart';
import '../screens/cart_screen.dart';

class WishlistScreen extends StatelessWidget {
  final String category; // Pass category when opening this screen

  const WishlistScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final wishlist = WishlistManager.instance.getWishlist(category);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$category Wishlist ❤️",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: wishlist.isEmpty
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border,
                size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              "No items in Wishlist",
              style: GoogleFonts.poppins(
                  fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: wishlist.length,
        itemBuilder: (context, index) {
          final product = wishlist[index];
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Remove Item",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal)),
                  content: Text(
                    "Are you sure you want to remove this product from wishlist?",
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: Text("No",
                          style: GoogleFonts.poppins(
                              color: Colors.grey.shade600)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: Text("Yes",
                          style: GoogleFonts.poppins(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (_) {
              WishlistManager.instance
                  .removeFromWishlist(category, product);
              (context as Element).markNeedsBuild();
            },
            background: Container(
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white, size: 28),
            ),
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: product['imageUrl'] ?? "",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade200,
                      width: 60,
                      height: 60,
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade200,
                      width: 60,
                      height: 60,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
                title: Text(
                  product['name'] ?? "Unnamed",
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rs. ${product['price']}",
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.green.shade700),
                    ),
                    const SizedBox(height: 4),
                    if (product['type'] != null)
                      Chip(
                        label: Text(
                          product['type'],
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.white),
                        ),
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                      ),
                  ],
                ),
                trailing: InkWell(
                  onTap: () {
                    CartManager.instance.addToCart(product);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartScreen()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.blueAccent,
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
