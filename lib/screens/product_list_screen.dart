// ignore_for_file: deprecated_member_use

import 'dart:ui'; // For BackdropFilter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For haptic feedback
import 'package:google_fonts/google_fonts.dart'; // For modern typography
import 'package:flutter_iconly/flutter_iconly.dart'; // For custom icons
import 'package:cached_network_image/cached_network_image.dart'; // For efficient image loading
import 'package:shimmer/shimmer.dart'; // For shimmer effect

class ProductListScreen extends StatefulWidget {
  final List<Map<String, dynamic>> products;

  const ProductListScreen({super.key, required this.products});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> with SingleTickerProviderStateMixin {
  late List<Map<String, dynamic>> _displayedProducts;
  bool _isLoading = true;
  String _sortOption = 'Popularity'; // Default sort option

  // Animation controller for background gradient
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;

  @override
  void initState() {
    super.initState();
    // Simulate loading for shimmer effect
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _isLoading = false;
        _displayedProducts = List.from(widget.products);
      });
    });

    _animationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);
    _colorAnimation1 = ColorTween(
      begin: const Color(0xFF2e4cb6),
      end: const Color(0xFF8a4af3),
    ).animate(_animationController);
    _colorAnimation2 = ColorTween(
      begin: const Color(0xFF8a4af3),
      end: const Color(0xFF2e4cb6),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Sort products based on selected option
  void _sortProducts(String option) {
    setState(() {
      _sortOption = option;
      if (option == 'Price: Low to High') {
        _displayedProducts.sort((a, b) => (a['price'] as double).compareTo(b['price'] as double));
      } else if (option == 'Price: High to Low') {
        _displayedProducts.sort((a, b) => (b['price'] as double).compareTo(a['price'] as double));
      } else if (option == 'Popularity') {
        _displayedProducts.sort((a, b) {
          final aPop = a['isPopular'] == true ? 1 : 0;
          final bPop = b['isPopular'] == true ? 1 : 0;
          return bPop.compareTo(aPop);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_colorAnimation1.value!, _colorAnimation2.value!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              _buildAppBar(isDarkMode),
              // Product grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _isLoading ? _buildShimmerGrid() : _buildProductGrid(isDarkMode),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDarkMode) {
    return AppBar(
      title: Text(
        "Products",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: isDarkMode ? Colors.white70 : Colors.white,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(IconlyLight.filter),
          color: isDarkMode ? Colors.white70 : Colors.white,
          onPressed: _showSortOptions,
          tooltip: 'Sort & Filter',
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          color: isDarkMode ? Colors.white70 : Colors.white,
          onPressed: () {
            HapticFeedback.lightImpact();
            setState(() {
              _isLoading = true;
              Future.delayed(const Duration(milliseconds: 1000), () {
                setState(() {
                  _isLoading = false;
                  _displayedProducts = List.from(widget.products);
                  _sortOption = 'Popularity';
                });
              });
            });
          },
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.7,
      children: List.generate(6, (index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProductGrid(bool isDarkMode) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.7,
      children: _displayedProducts.asMap().entries.map((entry) {
        final index = entry.key;
        final product = entry.value;
        return _buildProductCard(product, index, isDarkMode);
      }).toList(),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, int index, bool isDarkMode) {
    final isPopular = product['isPopular'] == true;
    final discount = product['discount'] as double? ?? 0.0;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // Navigate to product detail page (placeholder)
        // Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
      },
      child: Hero(
        tag: 'product_$index',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isDarkMode ? Colors.grey[800]?.withOpacity(0.5) : Colors.white.withOpacity(0.4),
            border: Border.all(
              color: isPopular ? const Color(0xFF2e4cb6).withOpacity(0.8) : Colors.white.withOpacity(0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black54 : Colors.black12,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: CachedNetworkImage(
                          imageUrl: product['imageUrl'] ?? 'https://example.com/placeholder.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(color: Colors.white),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.image_not_supported),
                        ),
                      ),
                      if (isPopular || discount > 0)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isPopular ? Colors.red : Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              isPopular ? 'Popular' : '${discount.toInt()}% Off',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Product details
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'] ?? 'Product Name',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textScaler: const TextScaler.linear(1.0),
                        semanticsLabel: 'Product: ${product['name']}',
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${product['price']?.toStringAsFixed(2) ?? '0.00'}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.white70 : const Color(0xFF2e4cb6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            // Add to cart logic (placeholder)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${product['name']} added to cart')),
                            );
                          },
                          icon: const Icon(IconlyLight.bag, size: 18),
                          label: Text('Add', style: GoogleFonts.poppins()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2e4cb6),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Sort Products",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text("Price: Low to High", style: GoogleFonts.poppins()),
                trailing: _sortOption == 'Price: Low to High'
                    ? const Icon(Icons.check, color: Color(0xFF2e4cb6))
                    : null,
                onTap: () {
                  _sortProducts('Price: Low to High');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Price: High to Low", style: GoogleFonts.poppins()),
                trailing: _sortOption == 'Price: High to Low'
                    ? const Icon(Icons.check, color: Color(0xFF2e4cb6))
                    : null,
                onTap: () {
                  _sortProducts('Price: High to Low');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Popularity", style: GoogleFonts.poppins()),
                trailing: _sortOption == 'Popularity'
                    ? const Icon(Icons.check, color: Color(0xFF2e4cb6))
                    : null,
                onTap: () {
                  _sortProducts('Popularity');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}