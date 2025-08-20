import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pick_pay/providers/user_provider.dart';
import 'package:pick_pay/screens/home_screen.dart';

class PaymentSuccessfulScreen extends StatefulWidget {
  final List<Map<String, dynamic>> purchasedProducts;
  final Map<String, dynamic> addressDetails;
  final String shippingMethod;
  final String paymentMethod;
  final double shippingPrice;
  final double discount;
  final double total;

  const PaymentSuccessfulScreen({
    Key? key,
    required this.purchasedProducts,
    required this.addressDetails,
    required this.shippingMethod,
    required this.paymentMethod,
    required this.shippingPrice,
    required this.discount,
    required this.total,
  }) : super(key: key);

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

    userProvider.addOrder({
      'items': widget.purchasedProducts,
      'status': 'completed',
      'date': DateTime.now().toIso8601String(),
      'address': userProvider.user?.address ?? widget.addressDetails['addressLine1'] ?? "Unknown address",
      'latitude': widget.addressDetails['latitude'] ?? null,
      'longitude': widget.addressDetails['longitude'] ?? null,
      'name': userProvider.user?.username ?? widget.addressDetails['name'] ?? "Unknown User",
      'email': userProvider.user?.email ?? widget.addressDetails['email'] ?? 'unknown',
      'shippingMethod': widget.shippingMethod,
      'shippingCost': widget.shippingPrice,
      'paymentMethod': widget.paymentMethod,
      'discount': widget.discount,
      'total': widget.total,
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF2e4cb6);

    double totalAmount = widget.purchasedProducts.fold(
        0, (sum, item) => sum + (item['price'] * item['quantity']));

    // Use widget.shippingPrice directly as it reflects the selected shipping method
    double shippingCost = widget.shippingPrice;

    return Scaffold(
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
                      "Order Placed Successful!",
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
                                "SubTotal",
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

                    // ---------- Payment Summary ----------
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
                            "Payment Summary",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("SubTotal", style: TextStyle(fontSize: 16)),
                              Text("Rs. $totalAmount", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Shipping", style: TextStyle(fontSize: 16)),
                              Text("Rs. ${shippingCost.toStringAsFixed(0)}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          if (widget.discount > 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Discount", style: TextStyle(fontSize: 16)),
                                Text(
                                  "- Rs. ${widget.discount.toStringAsFixed(0)}",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                                ),
                              ],
                            ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Rs. ${(totalAmount + shippingCost - widget.discount).toStringAsFixed(0)}",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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