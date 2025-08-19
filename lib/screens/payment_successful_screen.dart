import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pick_pay/providers/user_provider.dart';
import 'package:pick_pay/screens/home_screen.dart';

class PaymentSuccessfulScreen extends StatefulWidget {
  final List<Map<String, dynamic>> purchasedProducts;
  final Map<String, dynamic> addressDetails;
  final String shippingMethod;
  final String paymentMethod;

  const PaymentSuccessfulScreen({
    super.key,
    required this.purchasedProducts,
    required this.addressDetails,
    required this.shippingMethod,
    required this.paymentMethod,
  });

  @override
  State<PaymentSuccessfulScreen> createState() => _PaymentSuccessfulScreenState();
}

class _PaymentSuccessfulScreenState extends State<PaymentSuccessfulScreen> {
  bool _backPressed = false;

  @override
  void initState() {
    super.initState();
    _saveOrders();
  }

  void _saveOrders() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Add the entire order at once, including all products
    userProvider.addOrder({
      'items': widget.purchasedProducts,
      'status': 'completed',
      'date': DateTime.now().toIso8601String(),
      'address': userProvider.user?.address ?? widget.addressDetails['addressLine1'] ?? "Unknown address",
      'name': userProvider.user?.username ?? "Unknown User",
      'email': userProvider.user?.email ?? 'unknown', // <-- change here
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF2e4cb6);

    double totalAmount = widget.purchasedProducts.fold(
        0, (sum, item) => sum + (item['price'] * item['quantity']));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Payment Successful",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 100,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Payment Successful!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Thank you for your purchase. Your order has been successfully placed and will be processed soon.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // ---------- Order Summary ----------
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Order Summary",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          const Text(
                            "Products",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...widget.purchasedProducts.map((product) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${product['name']} x${product['quantity']}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "Rs. ${product['price'] * product['quantity']}",
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Rs. $totalAmount",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ---------- Shipping Address ----------
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Shipping Address",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          Text("${widget.addressDetails['name']}", style: const TextStyle(fontSize: 16)),
                          Text("${widget.addressDetails['addressLine1']}", style: const TextStyle(fontSize: 16)),
                          if (widget.addressDetails['addressLine2'] != null &&
                              widget.addressDetails['addressLine2'].isNotEmpty)
                            Text("${widget.addressDetails['addressLine2']}", style: const TextStyle(fontSize: 16)),
                          Text("${widget.addressDetails['city']}, ${widget.addressDetails['state']} ${widget.addressDetails['postalCode']}", style: const TextStyle(fontSize: 16)),
                          Text("${widget.addressDetails['country']}", style: const TextStyle(fontSize: 16)),
                          Text("Phone: ${widget.addressDetails['phone']}", style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ---------- Shipping & Payment ----------
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Shipping & Payment",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Shipping Method", style: TextStyle(fontSize: 16)),
                              Text(widget.shippingMethod, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Payment Method", style: TextStyle(fontSize: 16)),
                              Text(widget.paymentMethod, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ---------- Logo ----------
                    SizedBox(
                      height: 180,
                      width: 180,
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.store,
                            size: 80,
                            color: Colors.grey,
                          ); // fallback icon
                        },
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // ---------- Back to Home Button ----------
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: GestureDetector(
                onTapDown: (_) => setState(() => _backPressed = true),
                onTapUp: (_) {
                  setState(() => _backPressed = false);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                  );
                },
                onTapCancel: () => setState(() => _backPressed = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: _backPressed
                        ? [
                      const BoxShadow(
                        color: Color(0xFFF7C803),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                        : [],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Back to Home",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
