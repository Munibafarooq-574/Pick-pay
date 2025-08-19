// ignore_for_file: unused_local_variable, unnecessary_null_comparison, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pick_pay/screens/payment_successful_screen.dart';
import 'package:provider/provider.dart';
import 'package:pick_pay/manager/cart_manager.dart';
import 'package:pick_pay/providers/user_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  // ---- Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  String? selectedCountry;
  final List<String> countries = ['Pakistan', 'India', 'USA', 'UK', 'Canada'];

  String selectedShipping = 'Standard';
  final List<String> shippingMethods = ['Standard', 'Express'];

  String selectedPayment = 'Cash on Delivery';
  final List<String> paymentMethods = ['Credit/Debit Card', 'Cash on Delivery'];

  bool saveInfo = false;
  bool _pressed = false;
  bool _autofillShown = false;
  final Color primaryBlue = const Color(0xFF2e4cb6);

  // ---- Discount State
  double appliedDiscount = 0.0;
  String? appliedDiscountCode;

  // ---- FocusNodes
  final FocusNode emailFocus = FocusNode();
  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();
  final FocusNode addressFocus = FocusNode();
  final FocusNode landmarkFocus = FocusNode();
  final FocusNode cityFocus = FocusNode();
  final FocusNode postalCodeFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();

  // ---- Autofill dialog (shown once)
  Future<void> _showAutofillDialog() async {
    if (_autofillShown) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    if (user == null) return;

    final bool? shouldAutofill = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Refill saved details?"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user.email != null) Text("Email: ${user.email}"),
              if (user.firstName != null) Text("First Name: ${user.firstName}"),
              if (user.lastName != null) Text("Last Name: ${user.lastName}"),
              if (user.address != null) Text("Address: ${user.address}"),
              if (user.landmark != null) Text("Landmark: ${user.landmark}"),
              if (user.city != null) Text("City: ${user.city}"),
              if (user.postalCode != null) Text("Postal Code: ${user.postalCode}"),
              if (user.phone != null) Text("Phone: ${user.phone}"),
              if (user.country != null) Text("Country: ${user.country}"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );

    _autofillShown = true;

    if (shouldAutofill == true) {
      setState(() {
        emailController.text = user.email;
        firstNameController.text = user.firstName ?? '';
        lastNameController.text = user.lastName ?? '';
        addressController.text = user.address ?? '';
        landmarkController.text = user.landmark ?? '';
        cityController.text = user.city ?? '';
        postalCodeController.text = user.postalCode ?? '';
        phoneController.text = user.phone ?? '';
        selectedCountry = user.country;
      });
    }
  }

  double getShippingCost() => selectedShipping == 'Standard' ? 0.0 : 10.0;

  // ---- InputDecoration with error borders
  InputDecoration _decoration(String label, {bool required = false}) {
    final labelText = required ? '$label *' : label;
    return InputDecoration(
      labelText: labelText,
      filled: true,
      fillColor: Colors.grey.shade100,
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
        borderSide: BorderSide(color: primaryBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(
      title,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
    ),
  );

  Widget _summaryRow(String label, double value, {bool isTotal = false}) => Row(
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

  // ---- Reusable field builders
  Widget _requiredField({
    required TextEditingController controller,
    required String label,
    FocusNode? focusNode,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onTap: _showAutofillDialog,
        decoration: _decoration(label, required: true),
        validator: validator ??
                (v) => (v == null || v.trim().isEmpty) ? 'This field is required' : null,
      ),
    );
  }

  Widget _optionalField({
    required TextEditingController controller,
    required String label,
    FocusNode? focusNode,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onTap: _showAutofillDialog,
        decoration: _decoration(label, required: false),
        validator: validator,
      ),
    );
  }

  void _applyDiscount() {
    if (appliedDiscountCode != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Discount already applied")),
      );
      return;
    }

    final code = discountController.text.trim().toUpperCase();
    if (code == "SAVE100") {
      setState(() {
        appliedDiscount = 100.0;
        appliedDiscountCode = code;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Discount Applied: SAVE100 (-Rs.100)")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid discount code")),
      );
    }
  }

  void _removeDiscount() {
    if (appliedDiscountCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No discount applied")),
      );
      return;
    }
    setState(() {
      appliedDiscount = 0.0;
      appliedDiscountCode = null;
      discountController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Discount removed")),
    );
  }

  @override
  void dispose() {
    emailFocus.dispose();
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    addressFocus.dispose();
    landmarkFocus.dispose();
    cityFocus.dispose();
    postalCodeFocus.dispose();
    phoneFocus.dispose();
    super.dispose();
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
                child: Text("Your cart is empty", style: TextStyle(fontSize: 18)),
              );
            }

            final double subtotal = CartManager.instance.getTotal();
            final double shipping = getShippingCost();
            final double total = subtotal + shipping - appliedDiscount;

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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

                          //-----------Order Summary
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
                            child: ExpansionTile(
                              title: Text(
                                "Your Items (${cartItems.length})",
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              children: cartItems.map((item) {
                                return ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: item['image'] != null
                                        ? Image.network(
                                      item['image'],
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )
                                        : Container(
                                      width: 50,
                                      height: 50,
                                      color: Colors.grey.shade200,
                                      child: const Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                  title: Text(item['name']),
                                  subtitle: Text(
                                    "Qty: ${item['quantity']} • ${item['category'] ?? ''}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  trailing: Text(
                                    "Rs. ${item['price'].toStringAsFixed(0)}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, color: primaryBlue),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // ---------- CONTACT EMAIL
                          _sectionTitle("Contact Email"),
                          _requiredField(
                            controller: emailController,
                            label: 'Email',
                            focusNode: emailFocus,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return "Email is required";
                              }
                              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                              if (!emailRegex.hasMatch(v.trim())) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                          ),

                          // ---------- DELIVERY ADDRESS
                          _sectionTitle("Delivery Address"),
                          DropdownButtonFormField<String>(
                            value: countries.contains(selectedCountry) ? selectedCountry : null,
                            hint: const Text('Select Country'),
                            items: countries
                                .map((country) => DropdownMenuItem<String>(
                              value: country,
                              child: Text(country),
                            ))
                                .toList(),
                            onChanged: (value) => setState(() => selectedCountry = value ?? ''),
                            decoration: _decoration('Country'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Country is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),


                          _requiredField(
                            controller: firstNameController,
                            label: 'First Name',
                            focusNode: firstNameFocus,
                          ),
                          _optionalField(
                            controller: lastNameController,
                            label: 'Last Name',
                            focusNode: lastNameFocus,
                          ),
                          _requiredField(
                            controller: addressController,
                            label: 'Address',
                            focusNode: addressFocus,
                          ),
                          _optionalField(
                            controller: landmarkController,
                            label: 'Nearest Landmark',
                            focusNode: landmarkFocus,
                          ),
                          _requiredField(
                            controller: cityController,
                            label: 'City',
                            focusNode: cityFocus,
                          ),
                          _requiredField(
                            controller: postalCodeController,
                            label: 'Postal Code',
                            focusNode: postalCodeFocus,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                          _requiredField(
                            controller: phoneController,
                            label: 'Contact Number',
                            focusNode: phoneFocus,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),

                          CheckboxListTile(
                            activeColor: primaryBlue,
                            value: saveInfo,
                            onChanged: (val) => setState(() => saveInfo = val ?? false),
                            title: const Text('Save this information for next time'),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),

                          // ---------- SHIPPING METHOD
                          _sectionTitle("Shipping Method"),
                          ...shippingMethods.map((method) {
                            return RadioListTile<String>(
                              activeColor: primaryBlue,
                              value: method,
                              groupValue: selectedShipping,
                              onChanged: (value) => setState(() => selectedShipping = value!),
                              title: Text('$method (Rs. ${method == 'Standard' ? '500' : '1000'})'),
                            );
                          }),

                          // ---------- PAYMENT METHOD
                          _sectionTitle("Payment Method"),
                          ...paymentMethods.map((method) {
                            return RadioListTile<String>(
                              activeColor: primaryBlue,
                              value: method,
                              groupValue: selectedPayment,
                              onChanged: (value) => setState(() => selectedPayment = value!),
                              title: Text(method),
                            );
                          }),

                          // ---------- DISCOUNT
                          _sectionTitle("Discount"),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: discountController,
                                  decoration: _decoration('Discount Code'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0XFF2e4cb6),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: _applyDiscount,
                                child: const Text("Apply"),
                              ),
                              if (appliedDiscountCode != null)
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xfff7c803),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: _removeDiscount,
                                    child: const Text("Remove"),
                                  ),
                                ),
                            ],
                          ),
                          if (appliedDiscountCode != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                "Applied: $appliedDiscountCode (-Rs.${appliedDiscount.toStringAsFixed(0)})",
                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                              ),
                            ),

                          const SizedBox(height: 20),
                          // ---------- SUMMARY
                          _sectionTitle("Summary"),
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
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                _summaryRow("Subtotal", subtotal),
                                const Divider(),
                                _summaryRow(
                                  "Shipping (${selectedShipping == 'Standard' ? 'Standard ' : 'Express '})",
                                  selectedShipping == 'Standard' ? 500.0 : 1000.0,
                                ),
                                const Divider(),
                                _summaryRow("Discount", appliedDiscount > 0 ? -appliedDiscount : 0.0),
                                const Divider(),
                                // Add selected payment method
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Payment Method",
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        selectedPayment,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                _summaryRow("Total", subtotal + (selectedShipping == 'Standard' ? 500.0 : 1000.0) - appliedDiscount, isTotal: true),
                              ],
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),

                // ---------- PAY NOW BUTTON
                Positioned(
                  bottom: 16,
                  left: 18,
                  right: 18,
                  child: GestureDetector(
                    onTapDown: (_) => setState(() => _pressed = true),
                    onTapUp: (_) => setState(() => _pressed = false),
                    onTapCancel: () => setState(() => _pressed = false),
                    onTap: () async {
                      if (!_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please complete required fields')),
                        );
                        return;
                      }

                      if (saveInfo) {
                        Provider.of<UserProvider>(context, listen: false).saveCheckoutInfo(
                          email: emailController.text,
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          address: addressController.text,
                          landmark: landmarkController.text,
                          city: cityController.text,
                          postalCode: postalCodeController.text,
                          phone: phoneController.text,
                          country: selectedCountry,
                        );
                      }

                      CartManager.instance.cartItemsNotifier.value = [];
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Payment successful!")),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentSuccessfulScreen(
                            purchasedProducts: cartItems.map((item) {
                              return {
                                'name': item['name'],
                                'price': item['price'],
                                'quantity': item['quantity'],
                              };
                            }).toList(),
                            addressDetails: {
                              'name': '${firstNameController.text} ${lastNameController.text}',
                              'addressLine1': addressController.text,
                              'addressLine2': landmarkController.text,
                              'city': cityController.text,
                              'state': '', // Add actual state if available
                              'postalCode': postalCodeController.text,
                              'country': selectedCountry ?? 'Pakistan',
                              'phone': phoneController.text,
                            },
                            shippingMethod: 'Standard Shipping', // Replace with actual shipping method if available
                            paymentMethod: 'Credit Card', // Replace with actual payment method if available
                          ),
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                      decoration: BoxDecoration(
                        color: primaryBlue,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: _pressed
                            ? [
                          const BoxShadow(
                            color: Color(0xFFF7C803),
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
}