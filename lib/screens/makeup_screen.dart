// ignore_for_file: unnecessary_import, avoid_print, sort_child_properties_last, deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For haptic feedback
import 'package:google_fonts/google_fonts.dart'; // For modern typography
import 'package:flutter_iconly/flutter_iconly.dart'; // For custom icons
import 'package:pick_pay/screens/product_list_screen.dart';
import 'package:pick_pay/screens/wishlist_screen.dart'; // Import WishlistScreen
import 'package:shared_preferences/shared_preferences.dart'; // For persistent state
import 'package:provider/provider.dart'; // For state management
import '../manager/wishlist_manager.dart'; // For wishlist state

class MakeUpScreen extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  const MakeUpScreen({super.key, required this.products});

  @override
  State<MakeUpScreen> createState() => _BeautyScreenState();
}

class _BeautyScreenState extends State<MakeUpScreen> with TickerProviderStateMixin {
  // Selected type for each section
  final Map<String, String?> _selectedType = {
    "Face Makeup": null,
    "Lip Makeup": null,
    "Eye Makeup": null,
    "Skin Care": null,
    "Nails": null,
  };

  // Options for each section
  final Map<String, List<String>> _beautyTypes = {
    "Face Makeup": ["Foundation", "Blush", "Concealer", "Highlighter"],
    "Lip Makeup": ["Lipstick", "Lip Gloss", "Lip Liner"],
    "Eye Makeup": ["Eyeliner", "Mascara", "Eyeshadow", "Eyebrow Pencil"],
    "Skin Care": ["Cleanser", "Moisturizer", "Serum", "Sunscreen"],
    "Nails": ["Nail Polish", "Nail Gel", "Nail Stickers"],
  };

  // Category-specific background images (using stable placeholders if needed)
  final Map<String, String> _categoryImages = {
    "Face Makeup": "https://img.drz.lazcdn.com/static/pk/p/8674b36906dcc48fec2f51ae05783f0f.jpg_960x960q80.jpg_.webp",
    "Lip Makeup": "https://encrypted-tbn0.gstatic.com/images?q=tbn9GcSbs3vXbMUZ9EsAkQUauyL-0CjxrRzUVg5DbwcC5xr7R0duxK914qKNY3NhX8VcPInL_Qk&usqp=CAU",
    "Eye Makeup": "https://i.ebayimg.com/images/g/dIgAAOSwqIZkqa~T/s-l1200.jpg",
    "Skin Care": "https://us.oxygenceuticals.com/cdn/shop/files/Ceutisome_CC_Mask_Model.jpg?v=1754288852",
    "Nails": "https://nailzypakistan.com/cdn/shop/files/B1AD7B59-3757-4BAF-9295-3257E59A5F43.jpg?v=1734189914",
  };

  // List of products
  final List<Map<String, dynamic>> _products = [
    // ---------------- FACE MAKEUP ----------------
    // Foundation (4)
    {"id": 1, "name": "Matte Foundation", "price": 1500.0, "imageUrl": "https://example.com/matte_foundation.jpg", "section": "Face Makeup", "type": "Foundation", "isPopular": true, "discount": 10.0},
    {"id": 2, "name": "Dewy Foundation", "price": 1600.0, "imageUrl": "https://example.com/dewy_foundation.jpg", "section": "Face Makeup", "type": "Foundation", "isPopular": false, "discount": 5.0},
    {"id": 3, "name": "Full Coverage Foundation", "price": 1800.0, "imageUrl": "https://example.com/full_coverage_foundation.jpg", "section": "Face Makeup", "type": "Foundation", "isPopular": true, "discount": 15.0},
    {"id": 4, "name": "Lightweight Foundation", "price": 1400.0, "imageUrl": "https://example.com/lightweight_foundation.jpg", "section": "Face Makeup", "type": "Foundation", "isPopular": false, "discount": 0.0},

    // Blush (4)
    {"id": 5, "name": "Cream Blush", "price": 800.0, "imageUrl": "https://example.com/cream_blush.jpg", "section": "Face Makeup", "type": "Blush", "isPopular": false, "discount": 5.0},
    {"id": 6, "name": "Powder Blush", "price": 850.0, "imageUrl": "https://example.com/powder_blush.jpg", "section": "Face Makeup", "type": "Blush", "isPopular": true, "discount": 10.0},
    {"id": 7, "name": "Liquid Blush", "price": 950.0, "imageUrl": "https://example.com/liquid_blush.jpg", "section": "Face Makeup", "type": "Blush", "isPopular": false, "discount": 0.0},
    {"id": 8, "name": "Stick Blush", "price": 900.0, "imageUrl": "https://example.com/stick_blush.jpg", "section": "Face Makeup", "type": "Blush", "isPopular": true, "discount": 15.0},

    // Concealer (4)
    {"id": 9, "name": "Liquid Concealer", "price": 900.0, "imageUrl": "https://example.com/liquid_concealer.jpg", "section": "Face Makeup", "type": "Concealer", "isPopular": true, "discount": 0.0},
    {"id": 10, "name": "Stick Concealer", "price": 850.0, "imageUrl": "https://example.com/stick_concealer.jpg", "section": "Face Makeup", "type": "Concealer", "isPopular": false, "discount": 5.0},
    {"id": 11, "name": "Cream Concealer", "price": 950.0, "imageUrl": "https://example.com/cream_concealer.jpg", "section": "Face Makeup", "type": "Concealer", "isPopular": true, "discount": 10.0},
    {"id": 12, "name": "Color Correcting Concealer", "price": 1000.0, "imageUrl": "https://example.com/color_correct_concealer.jpg", "section": "Face Makeup", "type": "Concealer", "isPopular": false, "discount": 0.0},

    // Highlighter (4)
    {"id": 13, "name": "Shimmer Highlighter", "price": 1200.0, "imageUrl": "https://example.com/shimmer_highlighter.jpg", "section": "Face Makeup", "type": "Highlighter", "isPopular": false, "discount": 15.0},
    {"id": 14, "name": "Powder Highlighter", "price": 1300.0, "imageUrl": "https://example.com/powder_highlighter.jpg", "section": "Face Makeup", "type": "Highlighter", "isPopular": true, "discount": 10.0},
    {"id": 15, "name": "Liquid Highlighter", "price": 1250.0, "imageUrl": "https://example.com/liquid_highlighter.jpg", "section": "Face Makeup", "type": "Highlighter", "isPopular": false, "discount": 5.0},
    {"id": 16, "name": "Stick Highlighter", "price": 1100.0, "imageUrl": "https://example.com/stick_highlighter.jpg", "section": "Face Makeup", "type": "Highlighter", "isPopular": true, "discount": 0.0},

    // ---------------- LIP MAKEUP ----------------
    // Lipstick (4)
    {"id": 17, "name": "Red Lipstick", "price": 1000.0, "imageUrl": "https://example.com/red_lipstick.jpg", "section": "Lip Makeup", "type": "Lipstick", "isPopular": true, "discount": 10.0},
    {"id": 18, "name": "Nude Lipstick", "price": 950.0, "imageUrl": "https://example.com/nude_lipstick.jpg", "section": "Lip Makeup", "type": "Lipstick", "isPopular": false, "discount": 5.0},
    {"id": 19, "name": "Matte Lipstick", "price": 1100.0, "imageUrl": "https://example.com/matte_lipstick.jpg", "section": "Lip Makeup", "type": "Lipstick", "isPopular": true, "discount": 15.0},
    {"id": 20, "name": "Glossy Lipstick", "price": 1200.0, "imageUrl": "https://example.com/glossy_lipstick.jpg", "section": "Lip Makeup", "type": "Lipstick", "isPopular": false, "discount": 0.0},

    // Lip Gloss (4)
    {"id": 21, "name": "Glossy Lip Gloss", "price": 700.0, "imageUrl": "https://example.com/glossy_lip_gloss.jpg", "section": "Lip Makeup", "type": "Lip Gloss", "isPopular": false, "discount": 5.0},
    {"id": 22, "name": "Shimmer Lip Gloss", "price": 750.0, "imageUrl": "https://example.com/shimmer_lip_gloss.jpg", "section": "Lip Makeup", "type": "Lip Gloss", "isPopular": true, "discount": 10.0},
    {"id": 23, "name": "Tinted Lip Gloss", "price": 800.0, "imageUrl": "https://example.com/tinted_lip_gloss.jpg", "section": "Lip Makeup", "type": "Lip Gloss", "isPopular": false, "discount": 0.0},
    {"id": 24, "name": "Hydrating Lip Gloss", "price": 850.0, "imageUrl": "https://example.com/hydrating_lip_gloss.jpg", "section": "Lip Makeup", "type": "Lip Gloss", "isPopular": true, "discount": 15.0},

    // Lip Liner (4)
    {"id": 25, "name": "Pink Lip Liner", "price": 600.0, "imageUrl": "https://example.com/pink_lip_liner.jpg", "section": "Lip Makeup", "type": "Lip Liner", "isPopular": true, "discount": 0.0},
    {"id": 26, "name": "Red Lip Liner", "price": 650.0, "imageUrl": "https://example.com/red_lip_liner.jpg", "section": "Lip Makeup", "type": "Lip Liner", "isPopular": false, "discount": 5.0},
    {"id": 27, "name": "Brown Lip Liner", "price": 700.0, "imageUrl": "https://example.com/brown_lip_liner.jpg", "section": "Lip Makeup", "type": "Lip Liner", "isPopular": true, "discount": 10.0},
    {"id": 28, "name": "Nude Lip Liner", "price": 680.0, "imageUrl": "https://example.com/nude_lip_liner.jpg", "section": "Lip Makeup", "type": "Lip Liner", "isPopular": false, "discount": 15.0},

    // ---------------- EYE MAKEUP ----------------
    // Eyeliner (4)
    {"id": 29, "name": "Black Eyeliner", "price": 800.0, "imageUrl": "https://example.com/black_eyeliner.jpg", "section": "Eye Makeup", "type": "Eyeliner", "isPopular": true, "discount": 10.0},
    {"id": 30, "name": "Brown Eyeliner", "price": 850.0, "imageUrl": "https://example.com/brown_eyeliner.jpg", "section": "Eye Makeup", "type": "Eyeliner", "isPopular": false, "discount": 0.0},
    {"id": 31, "name": "Blue Eyeliner", "price": 900.0, "imageUrl": "https://example.com/blue_eyeliner.jpg", "section": "Eye Makeup", "type": "Eyeliner", "isPopular": true, "discount": 5.0},
    {"id": 32, "name": "Liquid Eyeliner", "price": 950.0, "imageUrl": "https://example.com/liquid_eyeliner.jpg", "section": "Eye Makeup", "type": "Eyeliner", "isPopular": false, "discount": 15.0},

    // Mascara (4)
    {"id": 33, "name": "Volumizing Mascara", "price": 900.0, "imageUrl": "https://example.com/volumizing_mascara.jpg", "section": "Eye Makeup", "type": "Mascara", "isPopular": false, "discount": 5.0},
    {"id": 34, "name": "Lengthening Mascara", "price": 950.0, "imageUrl": "https://example.com/lengthening_mascara.jpg", "section": "Eye Makeup", "type": "Mascara", "isPopular": true, "discount": 10.0},
    {"id": 35, "name": "Waterproof Mascara", "price": 1000.0, "imageUrl": "https://example.com/waterproof_mascara.jpg", "section": "Eye Makeup", "type": "Mascara", "isPopular": false, "discount": 0.0},
    {"id": 36, "name": "Curling Mascara", "price": 1050.0, "imageUrl": "https://example.com/curling_mascara.jpg", "section": "Eye Makeup", "type": "Mascara", "isPopular": true, "discount": 15.0},

    // Eyeshadow (4)
    {"id": 37, "name": "Smokey Eyeshadow", "price": 1100.0, "imageUrl": "https://example.com/smokey_eyeshadow.jpg", "section": "Eye Makeup", "type": "Eyeshadow", "isPopular": true, "discount": 0.0},
    {"id": 38, "name": "Glitter Eyeshadow", "price": 1150.0, "imageUrl": "https://example.com/glitter_eyeshadow.jpg", "section": "Eye Makeup", "type": "Eyeshadow", "isPopular": false, "discount": 5.0},
    {"id": 39, "name": "Matte Eyeshadow", "price": 1200.0, "imageUrl": "https://example.com/matte_eyeshadow.jpg", "section": "Eye Makeup", "type": "Eyeshadow", "isPopular": true, "discount": 15.0},
    {"id": 40, "name": "Neutral Eyeshadow", "price": 1250.0, "imageUrl": "https://example.com/neutral_eyeshadow.jpg", "section": "Eye Makeup", "type": "Eyeshadow", "isPopular": false, "discount": 10.0},

    // Eyebrow Pencil (4)
    {"id": 41, "name": "Brown Eyebrow Pencil", "price": 700.0, "imageUrl": "https://example.com/brown_eyebrow_pencil.jpg", "section": "Eye Makeup", "type": "Eyebrow Pencil", "isPopular": false, "discount": 15.0},
    {"id": 42, "name": "Black Eyebrow Pencil", "price": 750.0, "imageUrl": "https://example.com/black_eyebrow_pencil.jpg", "section": "Eye Makeup", "type": "Eyebrow Pencil", "isPopular": true, "discount": 10.0},
    {"id": 43, "name": "Blonde Eyebrow Pencil", "price": 720.0, "imageUrl": "https://example.com/blonde_eyebrow_pencil.jpg", "section": "Eye Makeup", "type": "Eyebrow Pencil", "isPopular": false, "discount": 0.0},
    {"id": 44, "name": "Grey Eyebrow Pencil", "price": 770.0, "imageUrl": "https://example.com/grey_eyebrow_pencil.jpg", "section": "Eye Makeup", "type": "Eyebrow Pencil", "isPopular": true, "discount": 5.0},

    // ---------------- SKIN CARE ----------------
    // Cleanser (4)
    {"id": 45, "name": "Foam Cleanser", "price": 1200.0, "imageUrl": "https://example.com/foam_cleanser.jpg", "section": "Skin Care", "type": "Cleanser", "isPopular": true, "discount": 10.0},
    {"id": 46, "name": "Gel Cleanser", "price": 1250.0, "imageUrl": "https://example.com/gel_cleanser.jpg", "section": "Skin Care", "type": "Cleanser", "isPopular": false, "discount": 5.0},
    {"id": 47, "name": "Cream Cleanser", "price": 1300.0, "imageUrl": "https://example.com/cream_cleanser.jpg", "section": "Skin Care", "type": "Cleanser", "isPopular": true, "discount": 15.0},
    {"id": 48, "name": "Oil Cleanser", "price": 1350.0, "imageUrl": "https://example.com/oil_cleanser.jpg", "section": "Skin Care", "type": "Cleanser", "isPopular": false, "discount": 0.0},

    // Moisturizer (4)
    {"id": 49, "name": "Hydrating Moisturizer", "price": 1500.0, "imageUrl": "https://example.com/hydrating_moisturizer.jpg", "section": "Skin Care", "type": "Moisturizer", "isPopular": false, "discount": 5.0},
    {"id": 50, "name": "Gel Moisturizer", "price": 1550.0, "imageUrl": "https://example.com/gel_moisturizer.jpg", "section": "Skin Care", "type": "Moisturizer", "isPopular": true, "discount": 10.0},
    {"id": 51, "name": "Cream Moisturizer", "price": 1600.0, "imageUrl": "https://example.com/cream_moisturizer.jpg", "section": "Skin Care", "type": "Moisturizer", "isPopular": false, "discount": 0.0},
    {"id": 52, "name": "Lightweight Moisturizer", "price": 1650.0, "imageUrl": "https://example.com/lightweight_moisturizer.jpg", "section": "Skin Care", "type": "Moisturizer", "isPopular": true, "discount": 15.0},

    // Serum (4)
    {"id": 53, "name": "Vitamin C Serum", "price": 2000.0, "imageUrl": "https://example.com/vitamin_c_serum.jpg", "section": "Skin Care", "type": "Serum", "isPopular": true, "discount": 0.0},
    {"id": 54, "name": "Hyaluronic Acid Serum", "price": 2100.0, "imageUrl": "https://example.com/hyaluronic_acid_serum.jpg", "section": "Skin Care", "type": "Serum", "isPopular": false, "discount": 10.0},
    {"id": 55, "name": "Retinol Serum", "price": 2200.0, "imageUrl": "https://example.com/retinol_serum.jpg", "section": "Skin Care", "type": "Serum", "isPopular": true, "discount": 15.0},
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
      print('Error loading selections: $e');
    });
    print('Initial selections: $_selectedType'); // Debug initial state

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
          _selectedType[section] = prefs.getString('selected_beauty_$section');
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
        await prefs.setString('selected_beauty_$section', type);
      } else {
        await prefs.remove('selected_beauty_$section');
      }
    } catch (e) {
      print('Error saving selection: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: WishlistManager.instance, // Provide WishlistManager instance
      child: Scaffold(
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
                                hintText: 'Search beauty products...',
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
                                    _beautyTypes[section]!
                                        .any((type) => type.toLowerCase().contains(_searchQuery)))
                                    .map((section) {
                                  return _buildSectionCard(section);
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Consumer<WishlistManager>(
      builder: (context, wishlistManager, child) {
        final wishlistCount = wishlistManager.getWishlist('Beauty').length;
        print('Beauty wishlist count updated: $wishlistCount'); // Debug log—remove later if you want

        return AppBar(
          title: Text(
            "Beauty",
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
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.black),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WishlistScreen(category: 'Beauty'),
                      ),
                    );
                    setState(() {}); // Fallback refresh on return
                  },
                  tooltip: 'Wishlist',
                ),
                if (wishlistCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$wishlistCount',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchSuggestions() {
    final suggestions = _beautyTypes.values
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
            children: _beautyTypes[section]!.map((type) {
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
            mainCategory: 'Beauty', // Pass the main category
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