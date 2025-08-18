import 'package:flutter/material.dart';
import 'package:pick_pay/manager/cart_manager.dart';
import 'package:pick_pay/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController discountController = TextEditingController();

  String? selectedCountry;
  List<String> countries = ['Pakistan', 'India', 'USA', 'UK', 'Canada'];

  String selectedShipping = 'Standard';
  List<String> shippingMethods = ['Standard', 'Express'];

  String selectedPayment = 'Cash on Delivery';
  List<String> paymentMethods = ['Credit/Debit Card', 'Cash on Delivery'];

  bool saveInfo = false;
  bool _pressed = false; // For animated button

  final Color primaryBlue = const Color(0xFF2e4cb6);

  @override
  void initState() {
    super.initState();
    _loadSavedInfo();
  }

  Future<void> _loadSavedInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      emailController.text = prefs.getString('email') ?? '';
      firstNameController.text = prefs.getString('firstName') ?? '';
      lastNameController.text = prefs.getString('lastName') ?? '';
      addressController.text = prefs.getString('address') ?? '';
      landmarkController.text = prefs.getString('landmark') ?? '';
      cityController.text = prefs.getString('city') ?? '';
      postalCodeController.text = prefs.getString('postalCode') ?? '';
      phoneController.text = prefs.getString('phone') ?? '';
      selectedCountry = prefs.getString('country');
      saveInfo = prefs.getBool('saveInfo') ?? false;
    });
  }

  Future<void> _saveInfo() async {
    if (!saveInfo) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', emailController.text);
    prefs.setString('firstName', firstNameController.text);
    prefs.setString('lastName', lastNameController.text);
    prefs.setString('address', addressController.text);
    prefs.setString('landmark', landmarkController.text);
    prefs.setString('city', cityController.text);
    prefs.setString('postalCode', postalCodeController.text);
    prefs.setString('phone', phoneController.text);
    if (selectedCountry != null) {
      prefs.setString('country', selectedCountry!);
    }
    prefs.setBool('saveInfo', saveInfo);
  }

  double getShippingCost() {
    return selectedShipping == 'Standard' ? 0.0 : 10.0;
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: primaryBlue,
          width: 2,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Checkout",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: CartManager.instance.cartItemsNotifier,
          builder: (context, cartItems, _) {
            if (cartItems.isEmpty) {
              return const Center(
                  child: Text(
                    "Your cart is empty",
                    style: TextStyle(fontSize: 18),
                  ));
            }

            double subtotal = CartManager.instance.getTotal();
            double shipping = getShippingCost();
            double total = subtotal + shipping;

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 80), // space for button
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Image.asset(
                              'assets/logo.png',
                              height: 180,
                              width: 180,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        _sectionTitle("Order Summary"),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 2))
                            ],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              return ListTile(
                                leading: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.image,
                                      size: 40, color: Colors.grey),
                                ),
                                title: Text(
                                  item['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  item['category'] ?? 'Category',
                                  style:
                                  TextStyle(color: Colors.grey.shade600),
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Rs. ${item['price'].toStringAsFixed(0)}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: primaryBlue),
                                    ),
                                    const SizedBox(height: 4),
                                    Text("Qty: ${item['quantity']}"),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        _sectionTitle("Contact Email"),
                        TextField(
                          controller: emailController,
                          decoration: _inputDecoration('Email'),
                        ),

                        _sectionTitle("Delivery Address"),
                        DropdownButtonFormField<String>(
                          value: selectedCountry,
                          hint: const Text('Select Country'),
                          items: countries.map((country) {
                            return DropdownMenuItem<String>(
                              value: country,
                              child: Text(country),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCountry = value;
                            });
                          },
                          decoration: _inputDecoration('Country'),
                          dropdownColor: Colors.white,
                          style: const TextStyle(color: Colors.black87),
                          iconEnabledColor: primaryBlue,
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: firstNameController,
                          decoration: _inputDecoration('First Name'),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: lastNameController,
                          decoration: _inputDecoration('Last Name'),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: addressController,
                          decoration: _inputDecoration('Address'),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: landmarkController,
                          decoration: _inputDecoration('Nearest Landmark'),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: cityController,
                          decoration: _inputDecoration('City'),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: postalCodeController,
                          decoration: _inputDecoration('Postal Code'),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: phoneController,
                          decoration: _inputDecoration('Phone Number'),
                        ),
                        CheckboxListTile(
                          activeColor: primaryBlue,
                          checkColor: Colors.white,
                          value: saveInfo,
                          onChanged: (bool? value) {
                            setState(() {
                              saveInfo = value ?? false;
                            });
                          },
                          title:
                          const Text('Save this information for next time'),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),

                        _sectionTitle("Shipping Method"),
                        ...shippingMethods.map((method) {
                          return RadioListTile<String>(
                            activeColor: primaryBlue,
                            value: method,
                            groupValue: selectedShipping,
                            onChanged: (value) {
                              setState(() {
                                selectedShipping = value!;
                              });
                            },
                            title: Text(method),
                          );
                        }),

                        _sectionTitle("Payment Method"),
                        ...paymentMethods.map((method) {
                          return RadioListTile<String>(
                            activeColor: primaryBlue,
                            value: method,
                            groupValue: selectedPayment,
                            onChanged: (value) {
                              setState(() {
                                selectedPayment = value!;
                              });
                            },
                            title: Text(method),
                          );
                        }),

                        _sectionTitle("Discount & Summary"),
                        TextField(
                          controller: discountController,
                          decoration: _inputDecoration('Discount Code'),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 2))
                            ],
                          ),
                          child: Column(
                            children: [
                              _summaryRow("Subtotal", subtotal),
                              const Divider(),
                              _summaryRow("Shipping", shipping),
                              const Divider(),
                              _summaryRow("Total", total, isTotal: true),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100), // extra space for button
                      ],
                    ),
                  ),
                ),

                // Fixed Animated Pay Now Button
                Positioned(
                  bottom: 16,
                  left: 18,
                  right: 18,
                  child: GestureDetector(
                    onTapDown: (_) => setState(() => _pressed = true),
                    onTapUp: (_) => setState(() => _pressed = false),
                    onTapCancel: () => setState(() => _pressed = false),
                    onTap: () async {
                      await _saveInfo();
                      CartManager.instance.cartItemsNotifier.value = [];
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Payment successful!")),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const HomeScreen()),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 50),
                      decoration: BoxDecoration(
                        color: primaryBlue,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: _pressed
                            ? [
                          BoxShadow(
                            color: const Color(0xFFF7C803),
                            blurRadius: 12,
                            spreadRadius: 2,
                          )
                        ]
                            : [],
                      ),
                      child: const Center(
                        child: Text(
                          "Pay Now",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _summaryRow(String label, double value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              fontSize: isTotal ? 16 : 14),
        ),
        Text(
          "Rs. ${value.toStringAsFixed(0)}",
          style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? Colors.black : Colors.black87),
        ),
      ],
    );
  }
}
