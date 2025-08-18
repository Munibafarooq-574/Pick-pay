import 'package:flutter/material.dart';
import 'package:pick_pay/screens/shoes_screen.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'accessories_screen.dart';
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
      "name": "Sports Shoes",
      "category": "Shoes",
      "price": 2500,
      //"image": "assets/sports_shoes.png"
    },
    {
      "name": "Formal Shirt",
      "category": "Clothing",
      "price": 1800,
      //"image": "assets/products/formal_shirt.png"
    },
    {
      "name": "Handbag",
      "category": "Accessories",
      "price": 2200,
      //"image": "assets/products/handbag.png"
    },
    {
      "name": "Smart Watch",
      "category": "Electronics",
      "price": 6000,
      //"image": "assets/products/smart_watch.png"
    },
    {
      "name": "Casual Shoes",
      "category": "Shoes",
      "price": 2800,
      //"image": "assets/products/casual_shoes.png"
    },
  ];

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 🔹 Helper to get initials from full name
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

    final filteredProducts = _products
        .where((item) =>
        item["name"].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header with greeting + profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side: Logo + greeting in a row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo fully to the left
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 0.1),

                      // Greeting & Username stacked vertically, slightly lower
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 33), // pushes "Hello" lower
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

                  // Right side: notifications + avatar
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



              const SizedBox(height: 20),

              // 🔹 Search + Filter
              Row(
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
                      // Add your filter logic here, e.g., show a dialog or navigate to a filter screen
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

              const SizedBox(height: 25),

              // 🔹 Categories (chips style)
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

              // 🔹 Product Grid
              const Text("Popular Products",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              const SizedBox(height: 12),

              Expanded(
                child: GridView.builder(
                  itemCount: filteredProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return _buildProductCard(
                      product["name"],
                      product["category"],
                      product["price"],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // 🔹 Modern Floating Bottom Navigation
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

  // 🔹 Category Chip
  Widget _buildCategoryChip(String title) {
    return GestureDetector(
      onTap: () {
        // Navigate based on category
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
        child: Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
      ),
    );
  }


  // 🔹 Product Card
  Widget _buildProductCard(String name, String category, int price) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 6, offset: const Offset(0, 4))
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
                  color: Colors.grey.shade200,
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
                ),
                child: const Icon(Icons.image, size: 60, color: Colors.grey),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(0, 2))
                      ]),
                  child: const Icon(Icons.favorite_border,
                      color: Colors.red, size: 18),
                ),
              )
            ],
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(category,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Rs. $price",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2e4cb6))),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2e4cb6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.add,
                          color: Colors.white, size: 18),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
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

  // Add this method to show a simple filter dialog
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
                    _products.sort((a, b) => a["price"].compareTo(b["price"]));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Sort by Price: High to Low"),
                onTap: () {
                  setState(() {
                    _products.sort((a, b) => b["price"].compareTo(a["price"]));
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