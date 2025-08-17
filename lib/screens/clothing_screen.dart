// ignore_for_file: deprecated_member_use, sort_child_properties_last

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For haptic feedback
import 'package:google_fonts/google_fonts.dart'; // For modern typography
import 'package:flutter_iconly/flutter_iconly.dart'; // For custom icons
import 'package:pick_pay/screens/product_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For persistent state
import 'package:shimmer/shimmer.dart'; // For shimmer effect

class ClothingScreen extends StatefulWidget {
  final List<Map<String, dynamic>> products;

  const ClothingScreen({super.key, required this.products});

  @override
  State<ClothingScreen> createState() => _ClothingScreenState();
}

class _ClothingScreenState extends State<ClothingScreen> with TickerProviderStateMixin {
  // Selected type for each section
  final Map<String, String?> _selectedType = {
    "Women": null,
    "Men": null,
    "Boys": null,
    "Girls": null,
  };

  // Options for each section
  final Map<String, List<String>> _clothingTypes = {
    "Women": ["T-Shirts", "Dresses", "Jeans", "Shirts"],
    "Men": ["T-Shirts", "Shirts", "Jeans", "Jackets"],
    "Boys": ["T-Shirts", "Shirts", "Shorts"],
    "Girls": ["Dresses", "Tops", "Skirts"],
  };

  // Icons for sections (changed to nullable IconData to allow null)
  final Map<String, IconData?> _sectionIcons = {
    "Women": null,
    "Men": null,
    "Boys": null,
    "Girls": null,
  };

  // Category-specific background images (with fallback asset)
  final Map<String, String> _categoryImages = {
    "Women": "https://rangreza.net/cdn/shop/files/Ready-to-Wear-2Pc-Dress-Batik-Ba01912-Rangreza-6286.webp?v=1711008946&width=1080",
    "Men": "https://avocado.pk/cdn/shop/products/2_ab1f0b9f-44fc-4644-9107-27b3a09eab51.jpg",
    "Boys": "https://outfitters.com.pk/cdn/shop/files/F0241508901LOWER.jpg?v=1710930380",
    "Girls": "https://tassels.pk/cdn/shop/files/DSC08872.jpg?v=1748284214&width=713",
  };

  // Search controller
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearchFocused = false;

  // Animation controllers
  late AnimationController _gradientAnimationController;
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    _loadSelections().catchError((e) {
      print('Error loading selections: $e');
    });

    // Gradient animation controller
    _gradientAnimationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);
    _colorAnimation1 = ColorTween(
      begin: const Color(0xFF2e4cb6),
      end: const Color(0xFF8a4af3),
    ).animate(_gradientAnimationController);
    _colorAnimation2 = ColorTween(
      begin: const Color(0xFF8a4af3),
      end: const Color(0xFF2e4cb6),
    ).animate(_gradientAnimationController);

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
          _selectedType[section] = prefs.getString('selected_$section');
        });
      });
    } catch (e) {
      print('Error loading preferences: $e');
    }
  }

  // Save selections to SharedPreferences
  Future<void> _saveSelection(String section, String? type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (type != null) {
        await prefs.setString('selected_$section', type);
      } else {
        await prefs.remove('selected_$section');
      }
    } catch (e) {
      print('Error saving selection: $e');
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
          color: Colors.white, // Set to white background
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
                              hintText: 'Search clothing...',
                              hintStyle: GoogleFonts.poppins(color: Colors.grey[600]), // Grey color for hint text
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
                                borderSide: BorderSide(color: Colors.grey[400]!, width: 1), // Boundary with grey
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
                            int crossAxisCount = (width / 250).floor().clamp(1, 2); // Adjusted for larger cards
                            double childWidth = (width - (crossAxisCount - 1) * 16) / crossAxisCount;
                            double childHeight = childWidth * 1.3; // Adjusted aspect ratio for larger size

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
      actions: [
        IconButton(
          icon: const Icon(IconlyLight.filter),
          color: Colors.black,
          onPressed: () {
            _showSortOptions();
          },
          tooltip: 'Sort & Filter',
        ),
      ],
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
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          _showTypeSelection(section);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: section,
              child: Container(
                height: 437, // Increased height for larger image display
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(_categoryImages[section]!),
                    fit: BoxFit.cover, // Ensures the full image is visible
                    opacity: 1.0,
                    onError: (exception, stackTrace) {
                      print('Image load error for $section: $exception');
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
            ElevatedButton(
              onPressed: () {
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
                minimumSize: const Size(150, 40), // Adjusted button size
              ),
            ),
          ],
        ),
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

  void _showTypeSelection(String section) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      transitionAnimationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      )..forward(),
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (_, controller) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: ListView(
                controller: controller,
                children: [
                  Text(
                    "Select $section Type",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  // Product preview carousel with error handling
                  SizedBox(
                    height: 10, // Increased height to match larger image
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.products
                          .where((p) => p['section'] == section)
                          .length,
                      itemBuilder: (context, index) {
                        final product = widget.products
                            .where((p) => p['section'] == section)
                            .toList()[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              product['imageUrl'] ?? 'https://via.placeholder.com/200',
                              width: 500, // Increased width to match larger size
                              height: 500, // Increased height to match larger size
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print('Image error for product: $error');
                                return const Icon(Icons.image_not_supported, size: 50);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _clothingTypes[section]!.map((type) {
                      final isSelected = _selectedType[section] == type;
                      return ChoiceChip(
                        label: Text(
                          type,
                          style: GoogleFonts.poppins(
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: const Color(0xFF2e4cb6),
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? Colors.transparent : Colors.grey[300]!,
                          ),
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            HapticFeedback.lightImpact();
                            setState(() {
                              _selectedType[section] = type;
                              _saveSelection(section, type);
                            });
                            Navigator.pop(context);
                            _navigateToProducts(section, type);
                          }
                        },
                        avatar: isSelected
                            ? const Icon(Icons.check_circle, color: Colors.white, size: 18)
                            : null,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
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
                "Sort & Filter",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: const Text("Price: Low to High"),
                onTap: () {
                  // Implement sorting logic
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Price: High to Low"),
                onTap: () {
                  // Implement sorting logic
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Popularity"),
                onTap: () {
                  // Implement sorting logic
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToProducts(String section, String type) {
    final filteredProducts = widget.products
        .where((product) => product['section'] == section && product['type'] == type)
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