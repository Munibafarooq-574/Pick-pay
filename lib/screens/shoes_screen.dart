// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For haptic feedback
import 'package:google_fonts/google_fonts.dart'; // For modern typography
import 'package:flutter_iconly/flutter_iconly.dart'; // For custom icons
import 'package:pick_pay/screens/product_list_screen.dart';
import 'package:pick_pay/screens/wishlist_screen.dart'; // Import WishlistScreen
import 'package:shared_preferences/shared_preferences.dart'; // For persistent state

class ShoesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> products;

  const ShoesScreen({super.key, required this.products});

  @override
  State<ShoesScreen> createState() => _ShoesScreenState();
}

class _ShoesScreenState extends State<ShoesScreen> with TickerProviderStateMixin {
  // Selected type for each section
  final Map<String, String?> _selectedType = {
    "Women": null,
    "Men": null,
    "Boys": null,
    "Girls": null,
  };

  // Options for each section
  final Map<String, List<String>> _shoeTypes = {
    "Women": ["Sneakers", "Heels", "Boots", "Sandals"],
    "Men": ["Sneakers", "Formal Shoes", "Boots", "Sandals"],
    "Boys": ["Sneakers", "School Shoes", "Sandals"],
    "Girls": ["Sneakers", "School Shoes", "Sandals"],
  };

  // Category-specific background images
  final Map<String, String> _categoryImages = {
    "Women": "https://www.hushpuppies.com.pk/cdn/shop/files/500x615-2.jpg?v=1749803429&width=500",
    "Men": "https://www.hushpuppies.com.pk/cdn/shop/files/500x615-1.jpg?v=1749803429&width=500",
    "Boys": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH0yohNGGPlArWGqO32aIDEoS3KT6AJL_V7w&s",
    "Girls": "https://encrypted-tbn0.gstatic.com/images?q=tbn9GcRMLM2SWahLkFxALgYrO19p43aD1q3UeQAhvBJXLit5k1TQKs23L65N-zTrI1Kx6W8jkm0&usqp=CAU",
  };

  // List of products
  final List<Map<String, dynamic>> _products = [
    // Women products
    {"id": 1, "name": "White Sneakers", "price": 2500.0, "imageUrl": "https://example.com/white_sneakers_women.jpg", "section": "Women", "type": "Sneakers", "isPopular": true, "discount": 10.0},
    {"id": 2, "name": "Black Sneakers", "price": 2300.0, "imageUrl": "https://example.com/black_sneakers_women.jpg", "section": "Women", "type": "Sneakers", "isPopular": false, "discount": 5.0},
    {"id": 3, "name": "Blue Sneakers", "price": 2400.0, "imageUrl": "https://example.com/blue_sneakers_women.jpg", "section": "Women", "type": "Sneakers", "isPopular": true, "discount": 0.0},
    {"id": 4, "name": "Red Sneakers", "price": 2600.0, "imageUrl": "https://example.com/red_sneakers_women.jpg", "section": "Women", "type": "Sneakers", "isPopular": false, "discount": 15.0},
    {"id": 5, "name": "High Heels", "price": 3500.0, "imageUrl": "https://example.com/high_heels_women.jpg", "section": "Women", "type": "Heels", "isPopular": true, "discount": 10.0},
    {"id": 6, "name": "Black Heels", "price": 3200.0, "imageUrl": "https://example.com/black_heels_women.jpg", "section": "Women", "type": "Heels", "isPopular": false, "discount": 5.0},
    {"id": 7, "name": "Red Heels", "price": 3400.0, "imageUrl": "https://example.com/red_heels_women.jpg", "section": "Women", "type": "Heels", "isPopular": true, "discount": 0.0},
    {"id": 8, "name": "Silver Heels", "price": 3600.0, "imageUrl": "https://example.com/silver_heels_women.jpg", "section": "Women", "type": "Heels", "isPopular": false, "discount": 15.0},
    {"id": 9, "name": "Leather Boots", "price": 4000.0, "imageUrl": "https://example.com/leather_boots_women.jpg", "section": "Women", "type": "Boots", "isPopular": true, "discount": 10.0},
    {"id": 10, "name": "Brown Boots", "price": 3800.0, "imageUrl": "https://example.com/brown_boots_women.jpg", "section": "Women", "type": "Boots", "isPopular": false, "discount": 5.0},
    {"id": 11, "name": "Black Sandals", "price": 1800.0, "imageUrl": "https://example.com/black_sandals_women.jpg", "section": "Women", "type": "Sandals", "isPopular": true, "discount": 0.0},
    {"id": 12, "name": "White Sandals", "price": 2000.0, "imageUrl": "https://example.com/white_sandals_women.jpg", "section": "Women", "type": "Sandals", "isPopular": false, "discount": 15.0},
    // Men products
    {"id": 13, "name": "Black Sneakers", "price": 2800.0, "imageUrl": "https://example.com/black_sneakers_men.jpg", "section": "Men", "type": "Sneakers", "isPopular": true, "discount": 10.0},
    {"id": 14, "name": "Grey Sneakers", "price": 2600.0, "imageUrl": "https://example.com/grey_sneakers_men.jpg", "section": "Men", "type": "Sneakers", "isPopular": false, "discount": 5.0},
    {"id": 15, "name": "Blue Sneakers", "price": 2700.0, "imageUrl": "https://example.com/blue_sneakers_men.jpg", "section": "Men", "type": "Sneakers", "isPopular": true, "discount": 0.0},
    {"id": 16, "name": "White Sneakers", "price": 2900.0, "imageUrl": "https://example.com/white_sneakers_men.jpg", "section": "Men", "type": "Sneakers", "isPopular": false, "discount": 15.0},
    {"id": 17, "name": "Black Formal Shoes", "price": 3200.0, "imageUrl": "https://example.com/black_formal_shoes_men.jpg", "section": "Men", "type": "Formal Shoes", "isPopular": true, "discount": 10.0},
    {"id": 18, "name": "Brown Formal Shoes", "price": 3000.0, "imageUrl": "https://example.com/brown_formal_shoes_men.jpg", "section": "Men", "type": "Formal Shoes", "isPopular": false, "discount": 5.0},
    {"id": 19, "name": "Tan Formal Shoes", "price": 3100.0, "imageUrl": "https://example.com/tan_formal_shoes_men.jpg", "section": "Men", "type": "Formal Shoes", "isPopular": true, "discount": 0.0},
    {"id": 20, "name": "Grey Formal Shoes", "price": 3300.0, "imageUrl": "https://example.com/grey_formal_shoes_men.jpg", "section": "Men", "type": "Formal Shoes", "isPopular": false, "discount": 15.0},
    {"id": 21, "name": "Leather Boots", "price": 4200.0, "imageUrl": "https://example.com/leather_boots_men.jpg", "section": "Men", "type": "Boots", "isPopular": true, "discount": 10.0},
    {"id": 22, "name": "Black Boots", "price": 4000.0, "imageUrl": "https://example.com/black_boots_men.jpg", "section": "Men", "type": "Boots", "isPopular": false, "discount": 5.0},
    {"id": 23, "name": "Brown Sandals", "price": 2000.0, "imageUrl": "https://example.com/brown_sandals_men.jpg", "section": "Men", "type": "Sandals", "isPopular": true, "discount": 0.0},
    {"id": 24, "name": "Black Sandals", "price": 2200.0, "imageUrl": "https://example.com/black_sandals_men.jpg", "section": "Men", "type": "Sandals", "isPopular": false, "discount": 15.0},
    // Boys products
    {"id": 25, "name": "Blue Sneakers", "price": 1500.0, "imageUrl": "https://example.com/blue_sneakers_boys.jpg", "section": "Boys", "type": "Sneakers", "isPopular": true, "discount": 10.0},
    {"id": 26, "name": "Red Sneakers", "price": 1400.0, "imageUrl": "https://example.com/red_sneakers_boys.jpg", "section": "Boys", "type": "Sneakers", "isPopular": false, "discount": 5.0},
    {"id": 27, "name": "Black School Shoes", "price": 1200.0, "imageUrl": "https://example.com/black_school_shoes_boys.jpg", "section": "Boys", "type": "School Shoes", "isPopular": true, "discount": 0.0},
    {"id": 28, "name": "Brown School Shoes", "price": 1300.0, "imageUrl": "https://example.com/brown_school_shoes_boys.jpg", "section": "Boys", "type": "School Shoes", "isPopular": false, "discount": 15.0},
    {"id": 29, "name": "Blue Sandals", "price": 1000.0, "imageUrl": "https://example.com/blue_sandals_boys.jpg", "section": "Boys", "type": "Sandals", "isPopular": true, "discount": 10.0},
    {"id": 30, "name": "Green Sandals", "price": 1100.0, "imageUrl": "https://example.com/green_sandals_boys.jpg", "section": "Boys", "type": "Sandals", "isPopular": false, "discount": 5.0},
    // Girls products
    {"id": 31, "name": "Pink Sneakers", "price": 1600.0, "imageUrl": "https://example.com/pink_sneakers_girls.jpg", "section": "Girls", "type": "Sneakers", "isPopular": true, "discount": 10.0},
    {"id": 32, "name": "White Sneakers", "price": 1500.0, "imageUrl": "https://example.com/white_sneakers_girls.jpg", "section": "Girls", "type": "Sneakers", "isPopular": false, "discount": 5.0},
    {"id": 33, "name": "Black School Shoes", "price": 1300.0, "imageUrl": "https://example.com/black_school_shoes_girls.jpg", "section": "Girls", "type": "School Shoes", "isPopular": true, "discount": 0.0},
    {"id": 34, "name": "Pink School Shoes", "price": 1400.0, "imageUrl": "https://example.com/pink_school_shoes_girls.jpg", "section": "Girls", "type": "School Shoes", "isPopular": false, "discount": 15.0},
    {"id": 35, "name": "White Sandals", "price": 1100.0, "imageUrl": "https://example.com/white_sandals_girls.jpg", "section": "Girls", "type": "Sandals", "isPopular": true, "discount": 10.0},
    {"id": 36, "name": "Purple Sandals", "price": 1200.0, "imageUrl": "https://example.com/purple_sandals_girls.jpg", "section": "Girls", "type": "Sandals", "isPopular": false, "discount": 5.0},
  ];

  // Search controller
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearchFocused = false;

  // Animation controllers
  late AnimationController _gradientAnimationController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    _loadSelections().catchError((e) {
      if (kDebugMode) {
        print('Error loading selections: $e');
      }
    });

    // Gradient animation controller
    _gradientAnimationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    // FAB animation controller
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();
    _fabScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _gradientAnimationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  // Load saved selections from SharedPreferences
  Future<void> _loadSelections() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _selectedType.forEach((section, _) {
          _selectedType[section] = prefs.getString('selected_shoe_$section');
        });
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading preferences: $e');
      }
    }
  }

  // Save selections to SharedPreferences
  Future<void> _saveSelection(String section, String? type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (type != null) {
        await prefs.setString('selected_shoe_$section', type);
      } else {
        await prefs.remove('selected_shoe_$section');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving selection: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnimation,
        child: FloatingActionButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            setState(() {
              _selectedType.updateAll((key, value) => null);
              _selectedType.forEach((section, _) => _saveSelection(section, null));
            });
          },
          backgroundColor: Colors.white,
          tooltip: 'Reset Selections',
          child: const Icon(Icons.refresh, color: Colors.black),
        ),
      ),
      body: AnimatedContainer(
        duration: const Duration(seconds: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // App bar
                      _buildAppBar(),
                      // Search bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Focus(
                          onFocusChange: (hasFocus) {
                            setState(() {
                              _isSearchFocused = hasFocus;
                            });
                          },
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search shoes...',
                              hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                              prefixIcon: const Icon(IconlyLight.search, color: Colors.grey),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                  });
                                },
                              )
                                  : null,
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: _isSearchFocused
                                      ? const Color(0xFF2e4cb6)
                                      : Colors.grey[400]!,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                const BorderSide(color: Color(0xFF2e4cb6), width: 2),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value.toLowerCase();
                              });
                            },
                          ),
                        ),
                      ),
                      // Search suggestions
                      if (_isSearchFocused && _searchQuery.isNotEmpty)
                        _buildSearchSuggestions(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double width = constraints.maxWidth;
                            int crossAxisCount = (width / 250).floor().clamp(1, 2);
                            double childWidth = (width - (crossAxisCount - 1) * 16) / crossAxisCount;
                            double childHeight = childWidth * 1.3;

                            return GridView.count(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              physics: const NeverScrollableScrollPhysics(),
                              childAspectRatio: childWidth / childHeight,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(8.0),
                              children: _selectedType.keys
                                  .where((section) =>
                              section.toLowerCase().contains(_searchQuery) ||
                                  _shoeTypes[section]!
                                      .any((type) => type.toLowerCase().contains(_searchQuery)))
                                  .map((section) {
                                return _buildSectionCard(section);
                              }).toList(),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        "Shoes",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.black),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WishlistScreen(category: 'Shoes'),
                ),
            );
          },
          tooltip: 'Wishlist',
        ),
      ],
    );
  }

  Widget _buildSearchSuggestions() {
    final suggestions = _shoeTypes.values
        .expand((types) => types)
        .where((type) => type.toLowerCase().contains(_searchQuery))
        .toList();
    return Container(
      constraints: const BoxConstraints(maxHeight: 150),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.black12)],
      ),
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(suggestions[index], style: GoogleFonts.poppins()),
            onTap: () {
              setState(() {
                _searchController.text = suggestions[index];
                _searchQuery = suggestions[index].toLowerCase();
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionCard(String section) {
    return Dismissible(
      key: Key(section),
      direction: _selectedType[section] != null ? DismissDirection.horizontal : DismissDirection.none,
      onDismissed: (direction) {
        HapticFeedback.mediumImpact();
        setState(() {
          _selectedType[section] = null;
          _saveSelection(section, null);
        });
      },
      background: Container(
        color: Colors.red.withOpacity(0.3),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image is now non-interactive
          Hero(
            tag: section,
            child: Container(
              height: 437,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(_categoryImages[section]!),
                  fit: BoxFit.cover,
                  opacity: 1.0,
                  onError: (exception, stackTrace) {
                    if (kDebugMode) {
                      print('Image load error for $section: $exception');
                    }
                  },
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Button handles all interactions
          ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              _showCategoryButtonOptions(section);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2e4cb6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(150, 40),
            ),
            child: Text(
              section,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoryButtonOptions(String section) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _shoeTypes[section]!.map((type) {
              return ListTile(
                title: Text(type, style: GoogleFonts.poppins()),
                onTap: () {
                  setState(() {
                    _selectedType[section] = type;
                    _saveSelection(section, type);
                  });
                  Navigator.pop(context);
                  _navigateToProducts(section, type);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _navigateToProducts(String section, String type) {
    final filteredProducts = _products
        .where((product) => product['section'] == section && product['type'] == type)
        .toList();
    if (filteredProducts.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductListScreen(
            products: filteredProducts,
            mainCategory: 'Shoes', // ✅ Pass the main category
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No products found for this selection.')),
      );
    }
  }
}