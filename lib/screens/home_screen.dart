// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pick_pay/screens/shoes_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart'; // For modern typography
// For custom icons
import 'package:cached_network_image/cached_network_image.dart'; // For efficient image loading
import '../manager/cart_manager.dart';
import '../providers/user_provider.dart';
import 'accessories_screen.dart';
import 'cart_screen.dart';
import 'clothing_screen.dart';
import 'makeup_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _searchQuery = "";
  bool _isFilterVisible = false;

  final List<Map<String, dynamic>> _products = [
    {
      "title": "Trendy Sneakers Sale!",
      "category": "Shoes",
      // "image": "assets/ads/sneakers_ad.png",
    },
    {
      "title": "Elegant Dresses Collection",
      "category": "Clothing",
      // "image": "assets/ads/dresses_ad.png",
    },
    {
      "title": "Stylish Handbags Offer",
      "category": "Accessories",
      // "image": "assets/ads/handbags_ad.png",
    },
    {
      "title": "Glam Makeup Deals",
      "category": "MakeUp",
      // "image": "assets/ads/makeup_ad.png",
    },
    {
      "name": "Sports Shoes",
      "category": "Shoes",
      "price": 2500,
      // "image": "assets/sports_shoes.png"
    },
    {
      "name": "Formal Shirt",
      "category": "Clothing",
      "price": 1800,
      // "image": "assets/products/formal_shirt.png"
    },
    {
      "name": "Handbag",
      "category": "Accessories",
      "price": 2200,
      // "image": "assets/products/handbag.png"
    },
    {
      "name": "Smart Watch",
      "category": "Electronics",
      "price": 6000,
      // "image": "assets/products/smart_watch.png"
    },
    {
      "name": "Casual Shoes",
      "category": "Shoes",
      "price": 2800,
      // "image": "assets/products/casual_shoes.png"
    },
  ];

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      // Cart icon tapped
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const CartScreen(),
        ),
      );
    }
  }

  String getUserInitials(String name) {
    List<String> names = name.split(" ");
    String initials = "";
    for (var n in names) {
      if (n.isNotEmpty) initials += n[0].toUpperCase();
    }
    return initials;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final filteredProducts = _products
        .where((item) =>
    item.containsKey("name") &&
        item["name"].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    final ads = _products.where((item) => item.containsKey("title")).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Fixed Header with Greeting + Profile
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 0.1),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 33),
                          const Text(
                            "Hello,",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "${user?.username ?? 'User'} 👋",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2e4cb6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: const Offset(0, 3))
                          ],
                        ),
                        child: const Icon(Icons.notifications_none,
                            color: Color(0xFF2e4cb6)),
                      ),
                      const SizedBox(width: 12),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFF2e4cb6),
                        child: Text(
                          user != null ? getUserInitials(user.username) : "U",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Fixed Search + Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search for products...",
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFilterVisible = !_isFilterVisible;
                      });
                      _showFilterDialog(context);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2e4cb6),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: const Offset(0, 3))
                        ],
                      ),
                      child: const Icon(Icons.tune, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 🔹 Scrollable Content: Categories to Popular Products
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 Categories
                      const Text("Categories",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildCategoryChip("Clothing"),
                            _buildCategoryChip("Shoes"),
                            _buildCategoryChip("MakeUp"),
                            _buildCategoryChip("Accessories"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // 🔹 Ads Carousel
                      const Text("Special Offers",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 150,
                        child: PageView.builder(
                          itemCount: ads.length,
                          itemBuilder: (context, index) {
                            final ad = ads[index];
                            return _buildAdCard(
                                ad["title"], ad["category"], ad["image"] ?? "");
                          },
                          controller: PageController(viewportFraction: 0.9),
                          padEnds: true,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // 🔹 Popular Products
                      const Text("Popular Products",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredProducts.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65, // Adjusted to match ProductListScreen
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return _buildProductCard(
                            product,
                            index,
                            isDarkMode,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 0),
              _buildNavItem(Icons.shopping_cart, 1),
              _buildNavItem(Icons.person, 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdCard(String title, String category, String image) {
    return GestureDetector(
      onTap: () {
        switch (category) {
          case "Clothing":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ClothingScreen(products: _products),
              ),
            );
            break;
          case "Shoes":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ShoesScreen(products: _products),
              ),
            );
            break;
          case "Accessories":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AccessoriesScreen(products: _products),
              ),
            );
            break;
          case "MakeUp":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MakeUpScreen(products: _products),
              ),
            );
            break;
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                ),
                child: image.isNotEmpty
                    ? Image.asset(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.image,
                    size: 60,
                    color: Colors.grey,
                  ),
                )
                    : const Icon(
                  Icons.image,
                  size: 60,
                  color: Colors.grey,
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        category,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String title) {
    return GestureDetector(
      onTap: () {
        switch (title) {
          case "Clothing":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ClothingScreen(products: _products),
              ),
            );
            break;
          case "Shoes":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ShoesScreen(products: _products),
              ),
            );
            break;
          case "Accessories":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AccessoriesScreen(products: _products),
              ),
            );
            break;
          case "MakeUp":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MakeUpScreen(products: _products),
              ),
            );
            break;
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2e4cb6), Color(0xFF6a7de9)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, int index, bool isDarkMode) {
    final isPopular = product['isPopular'] == true;
    final discount = product['discount'] as double? ?? 0.0;
    final name = product['name'] ?? 'Product Name';
    final price = (product['price'] as num?)?.toDouble().toStringAsFixed(2) ?? '0.00';
    final category = product['category'] ?? 'Unknown';

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // Create a structured product map for the cart
        final cartProduct = {
          'name': name,
          'price': double.tryParse(price) ?? 0.0,
          'type': category,
          'imageUrl': product['image'] ?? 'https://example.com/placeholder.jpg',
        };
        CartManager.instance.addToCart(cartProduct);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$name added to cart')),
        );
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
                        imageUrl: product['image'] ?? 'https://example.com/placeholder.jpg',
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
                            final cartProduct = {
                              'name': name,
                              'price': double.tryParse(price) ?? 0.0,
                              'type': category,
                              'imageUrl': product['image'] ?? 'https://example.com/placeholder.jpg',
                            };
                            CartManager.instance.addToCart(cartProduct);
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

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onNavTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected ? const Color(0xFF2e4cb6) : Colors.grey,
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 4,
            width: isSelected ? 20 : 0,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF2e4cb6) : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          )
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filter Products"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Sort by Price: Low to High"),
                onTap: () {
                  setState(() {
                    _products.sort(
                            (a, b) => a["price"]?.compareTo(b["price"] ?? 0) ?? 0);
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Sort by Price: High to Low"),
                onTap: () {
                  setState(() {
                    _products.sort(
                            (a, b) => b["price"]?.compareTo(a["price"] ?? 0) ?? 0);
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}