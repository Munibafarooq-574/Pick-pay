// ignore_for_file: deprecated_member_use, unnecessary_import

import 'dart:ui'; // For BackdropFilter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For haptic feedback
import 'package:google_fonts/google_fonts.dart'; // For modern typography
import 'package:flutter_iconly/flutter_iconly.dart'; // For custom icons
import 'package:cached_network_image/cached_network_image.dart'; // For efficient image loading

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
  bool _isHeld = false; // Track hold state
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;

  @override
  void initState() {
    super.initState();
    // Simulate loading for initial display
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _displayedProducts = List.from(widget.products);
        });
      }
    });

    _animationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _colorAnimation1 = ColorTween(
      begin: Colors.blue[200],
      end: Colors.blue[800],
    ).animate(_animationController);
    _colorAnimation2 = ColorTween(
      begin: Colors.blue[800],
      end: Colors.blue[200],
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

    return GestureDetector(
      onLongPress: () {
        setState(() {
          _isHeld = true;
          _animationController.repeat(reverse: true);
        });
      },
      onLongPressEnd: (_) {
        setState(() {
          _isHeld = false;
          _animationController.stop();
        });
      },
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Container(
              decoration: _isHeld
                  ? BoxDecoration(
                gradient: LinearGradient(
                  colors: [_colorAnimation1.value!, _colorAnimation2.value!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              )
                  : BoxDecoration(
                color: isDarkMode ? Colors.grey[900] : Colors.white,
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
            );
          },
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
          color: isDarkMode ? Colors.white70 : Colors.black87,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(IconlyLight.filter),
          color: isDarkMode ? Colors.white70 : Colors.black87,
          onPressed: _showSortOptions,
          tooltip: 'Sort & Filter',
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          color: isDarkMode ? Colors.white70 : Colors.black87,
          onPressed: () {
            HapticFeedback.lightImpact();
            setState(() {
              _isLoading = true;
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                    _displayedProducts = List.from(widget.products);
                    _sortOption = 'Popularity';
                  });
                }
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
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(18),
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
      childAspectRatio: 0.65, // Adjusted for new card height
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
    final name = product['name'] ?? 'Product Name';
    final price = product['price']?.toStringAsFixed(2) ?? '0.00';
    final category = product['type'] ?? 'Unknown'; // Use 'type' as category name (e.g., Sneakers, Heels, Lipstick)

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // Navigate to product detail page (placeholder)
        // Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
      },
      child: Hero(
        tag: 'product_$index',
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black26 : Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder + favorite
              Stack(
                children: [
                  Container(
                    height: 130,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[600] : Colors.grey[200],
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                      child: CachedNetworkImage(
                        imageUrl: product['imageUrl'] ?? 'https://example.com/placeholder.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorWidget: (context, url, error) => const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[700] : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: isDarkMode ? Colors.black26 : Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        color: isPopular ? Colors.red : Colors.grey,
                        size: 18,
                      ),
                    ),
                  ),
                  if (discount > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${discount.toInt()}% Off',
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
              // Details
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rs. $price',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white70 : const Color(0xFF2e4cb6),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('$name added to cart')),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isDarkMode ? Colors.grey[600] : const Color(0xFF2e4cb6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.add, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
                    ? Icon(Icons.check, color: Colors.grey[800])
                    : null,
                onTap: () {
                  _sortProducts('Price: Low to High');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Price: High to Low", style: GoogleFonts.poppins()),
                trailing: _sortOption == 'Price: High to Low'
                    ? Icon(Icons.check, color: Colors.grey[800])
                    : null,
                onTap: () {
                  _sortProducts('Price: High to Low');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Popularity", style: GoogleFonts.poppins()),
                trailing: _sortOption == 'Popularity'
                    ? Icon(Icons.check, color: Colors.grey[800])
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