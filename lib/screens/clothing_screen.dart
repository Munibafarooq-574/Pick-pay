// ignore_for_file: deprecated_member_use, sort_child_properties_last

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:pick_pay/screens/product_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClothingScreen extends StatefulWidget {
  final List<Map<String, dynamic>> products;

  const ClothingScreen({super.key, required this.products});

  @override
  State<ClothingScreen> createState() => _ClothingScreenState();
}

class _ClothingScreenState extends State<ClothingScreen> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _products = [
    {
      "id": 1,
      "name": "Floral Dress",
      "price": 2500.0,
      "imageUrl": "https://rangreza.net/cdn/shop/files/Ready-to-Wear-2Pc-Dress-Batik-Ba01912-Rangreza-6286.webp?v=1711008946&width=1080",
      "section": "Women",
      "type": "Dresses",
      "isPopular": true,
      "discount": 10.0,
    },
    {
      "id": 2,
      "name": "Blue Jeans",
      "price": 1800.0,
      "imageUrl": "https://outfitters.com.pk/cdn/shop/files/F0241508901LOWER.jpg?v=1710930380",
      "section": "Men",
      "type": "Jeans",
      "isPopular": false,
      "discount": 0.0,
    },
    {
      "id": 3,
      "name": "Kids T-Shirt",
      "price": 900.0,
      "imageUrl": "https://tassels.pk/cdn/shop/files/DSC08872.jpg?v=1748284214&width=713",
      "section": "Boys",
      "type": "T-Shirts",
      "isPopular": true,
      "discount": 5.0,
    },
    {
      "id": 4,
      "name": "Girls Skirt",
      "price": 1200.0,
      "imageUrl": "https://avocado.pk/cdn/shop/products/2_ab1f0b9f-44fc-4644-9107-27b3a09eab51.jpg",
      "section": "Girls",
      "type": "Skirts",
      "isPopular": false,
      "discount": 0.0,
    },
    {
      "id": 5,
      "name": "Women's T-Shirt",
      "price": 1500.0,
      "imageUrl": "https://example.com/women_tshirt.jpg",
      "section": "Women",
      "type": "T-Shirts",
      "isPopular": false,
      "discount": 0.0,
    },
    {
      "id": 6,
      "name": "Men's Shirt",
      "price": 2000.0,
      "imageUrl": "https://example.com/men_shirt.jpg",
      "section": "Men",
      "type": "Shirts",
      "isPopular": true,
      "discount": 15.0,
    },
    {
      "id": 7,
      "name": "Boys Shorts",
      "price": 800.0,
      "imageUrl": "https://example.com/boys_shorts.jpg",
      "section": "Boys",
      "type": "Shorts",
      "isPopular": false,
      "discount": 0.0,
    },
    {
      "id": 8,
      "name": "Girls Top",
      "price": 1100.0,
      "imageUrl": "https://example.com/girls_top.jpg",
      "section": "Girls",
      "type": "Tops",
      "isPopular": true,
      "discount": 10.0,
    },
  ];

  final Map<String, String?> _selectedType = {
    "Women": null,
    "Men": null,
    "Boys": null,
    "Girls": null,
  };

  final Map<String, List<String>> _clothingTypes = {
    "Women": ["T-Shirts", "Dresses", "Jeans", "Shirts"],
    "Men": ["T-Shirts", "Shirts", "Jeans", "Jackets"],
    "Boys": ["T-Shirts", "Shirts", "Shorts"],
    "Girls": ["Dresses", "Tops", "Skirts"],
  };

  // Category-specific background images (with fallback asset)
  final Map<String, String> _categoryImages = {
    "Women": "https://rangreza.net/cdn/shop/files/Ready-to-Wear-2Pc-Dress-Batik-Ba01912-Rangreza-6286.webp?v=1711008946&width=1080",
    "Men": "https://avocado.pk/cdn/shop/products/2_ab1f0b9f-44fc-4644-9107-27b3a09eab51.jpg",
    "Boys": "https://outfitters.com.pk/cdn/shop/files/F0241508901LOWER.jpg?v=1710930380",
    "Girls": "https://tassels.pk/cdn/shop/files/DSC08872.jpg?v=1748284214&width=713",
  };

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearchFocused = false;

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

    _gradientAnimationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

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

  Future<void> _loadSelections() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _selectedType.forEach((section, _) {
          _selectedType[section] = prefs.getString('selected_$section');
        });
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading preferences: $e');
      }
    }
  }

  Future<void> _saveSelection(String section, String? type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (type != null) {
        await prefs.setString('selected_$section', type);
      } else {
        await prefs.remove('selected_$section');
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
          child: const Icon(Icons.refresh, color: Colors.black),
          tooltip: 'Reset Selections',
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
                      _buildAppBar(),
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
                              hintText: 'Search clothing...',
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
                                borderSide: const BorderSide(color: Color(0xFF2e4cb6), width: 2),
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
                                  _clothingTypes[section]!
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
        "Clothing",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,

    );
  }

  Widget _buildSearchSuggestions() {
    final suggestions = _clothingTypes.values
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
        child: const Icon(Icons.delete, color: Colors.white),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image is now non-interactive
          Container(
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
          const SizedBox(height: 8),
          // Button handles all interactions
          ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              _showCategoryButtonOptions(section);
            },
            child: Text(
              section,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2e4cb6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(150, 40),
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
            children: _clothingTypes[section]!.map((type) {
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
        .where((product) =>
    product['section'].toString().toLowerCase() == section.toLowerCase() &&
        product['type'].toString().toLowerCase() == type.toLowerCase())
        .toList();

    if (filteredProducts.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductListScreen(products: filteredProducts),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No products found for this selection.')),
      );
    }
  }
}