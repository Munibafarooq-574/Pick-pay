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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          "$category Wishlist ❤️",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      body: wishlist.isEmpty
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border,
                size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              "Your Wishlist is Empty!",
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              "Start adding your favorite products now.",
              style: GoogleFonts.poppins(
                  fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
                          fontWeight: FontWeight.w600)),
                  content: Text(
                    "Are you sure you want to remove this product from your wishlist?",
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
              WishlistManager.instance.removeFromWishlist(category, product);
              (context as Element).markNeedsBuild();
            },
            background: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: const Icon(Icons.delete, color: Colors.white, size: 28),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16)),
                    child: CachedNetworkImage(
                      imageUrl: product['imageUrl'] ?? "",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            )),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Product Details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Name
                          Text(
                            product['name'] ?? "Unnamed Product",
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),

                          // Product Price
                          Text(
                            "Rs. ${product['price'] ?? '0'}",
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.green.shade700),
                          ),
                          const SizedBox(height: 6),

                          // Product Section / Category
                          if (product['category'] != null)
                            Text(
                              "Section: ${product['category']}",
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                          const SizedBox(height: 4),

                          // Product Type
                          if (product['type'] != null)
                            Text(
                              "Type: ${product['type']}",
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),

                          const SizedBox(height: 10),
          ],
                      ),
                    ),
                  ),

                  // Add to Cart Button
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        CartManager.instance.addToCart(product);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CartScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2e4cb6), // Changed here
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2e4cb6).withOpacity(0.3), // matching shadow
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 22),
                      ),
                    ),
                  )

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
