import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'orders_information_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String _selectedFilter = 'History';

  // Dummy orders for the History section
  final List<Map<String, dynamic>> _dummyOrders = [
    {
      'id': 'ORD0012323454345',
      'email': 'muniba@example.com',
      'name': 'Muniba',
      'status': 'completed',
      'date': '2025-07-15T10:00:00Z',
      'address': '123 Main St, City',
      'shippingMethod': 'Standard Delivery',
      'shippingCost': 500,
      'paymentMethod': 'Credit Card',
      'discount': 10.0,
      'items': [
        {'name': 'Matte Foundation', 'quantity': 2, 'price': 1500},
        {'name': 'Volumizing Mascara', 'quantity': 1, 'price': 900},
      ],
    },
    {
      'id': 'ORD00243565478654',
      'email': 'muniba@example.com',
      'name': 'Muniba farooq',
      'status': 'completed',
      'date': '2025-06-20T14:30:00Z',
      'address': 'service road E-9 /E-8, Islamabad',
      'shippingMethod': 'Express Delivery',
      'shippingCost': 1000,
      'paymentMethod': 'Cash on delivery',
      'discount': 15.0,
      'items': [
        {'name': 'Gold Necklace', 'quantity': 3, 'price': 5000},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final orders = userProvider.orders;
    final userName = userProvider.user?.username ?? 'Unknown User';
    final userEmail = userProvider.user?.email ?? 'user@example.com';

    // Combine provider orders with dummy orders for History section
    final filteredOrders = _selectedFilter == 'History'
        ? [
      ..._dummyOrders,
      ...orders
          .where((order) => order['email'] == userEmail)
          .where((order) => order['status'] == 'completed')
          .toList()
    ]
        : orders
        .where((order) => order['email'] == userEmail)
        .where((order) => order['status'] == 'ongoing')
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text("My Orders",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 🔹 Filter Chips
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text("History"),
                  selected: _selectedFilter == "History",
                  selectedColor: const Color(0XFF2e4cb6),
                  labelStyle: TextStyle(
                    color: _selectedFilter == "History"
                        ? Colors.white
                        : Colors.black,
                  ),
                  onSelected: (_) => setState(() => _selectedFilter = "History"),
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text("Ongoing"),
                  selected: _selectedFilter == "Ongoing",
                  selectedColor: const Color(0XFF2e4cb6),
                  labelStyle: TextStyle(
                    color: _selectedFilter == "Ongoing"
                        ? Colors.white
                        : Colors.black,
                  ),
                  onSelected: (_) => setState(() => _selectedFilter = "Ongoing"),
                ),
              ],
            ),
          ),

          Expanded(
            child: filteredOrders.isEmpty
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined,
                    size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const Text("No orders available",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            )
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                final items = (order['items'] is List)
                    ? List<Map<String, dynamic>>.from(order['items'])
                    : <Map<String, dynamic>>[];

                return Dismissible(
                  key: Key(order['id'] ?? index.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete Order"),
                          content: const Text(
                              "Are you sure you want to delete this order?"),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(true),
                              child: const Text("Delete",
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    // Only allow deletion of provider orders, not dummy orders
                    final originalIndex = userProvider.orders
                        .indexWhere((o) => o['id'] == order['id']);
                    if (originalIndex != -1) {
                      userProvider.removeOrder(originalIndex);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Order deleted")),
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: 'https://via.placeholder.com/60',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order No: ${order['id'] ?? 'Unknown'}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order['name'] ?? userName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        order['items'] != null
                            ? "Total quantity: ${(order['items'] as List).fold(0, (sum, item) => sum + ((item['quantity'] ?? 1) as num).toInt())}"
                            : 'No items',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            order['date'] != null
                                ? DateFormat('MMM d, yyyy').format(
                                DateTime.parse(order['date']))
                                : 'Unknown date',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: order['status'] == 'ongoing'
                                  ? Colors.orange[100]
                                  : Colors.green[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              order['status'] == 'ongoing'
                                  ? "Ongoing"
                                  : "Completed",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: order['status'] == 'ongoing'
                                    ? Colors.orange[800]
                                    : Colors.green[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrderDetailsScreen(
                              items: items,
                              date: order['date'] ??
                                  DateTime.now().toIso8601String(),
                              address:
                              order['address'] ?? "Unknown address",
                              orderId: order['id'] ?? 'Unknown',
                              shippingMethod:
                              order['shippingMethod'] ?? "Standard Delivery",
                              shippingCost:
                              (order['shippingCost'] ?? 0.0).toDouble(),
                              paymentMethod:
                              order['paymentMethod'] ?? "Cash on Delivery",
                              discount: order['discount'],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}