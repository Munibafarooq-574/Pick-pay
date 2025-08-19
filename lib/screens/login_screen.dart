

// ignore_for_file: unnecessary_cast, unused_local_variable, library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/preferences_provider.dart';
import '../providers/user_provider.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _pressed = false; // Added for animated button state

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        // Simulate authentication (replace with actual API call)
        await Future.delayed(const Duration(seconds: 1)); // Mock delay

        // 🔹 Assume you get backendUser from your API response
        final backendUser = {
          'username': _emailController.text.split('@')[0], // Example
          'email': _emailController.text.trim(),
          'profileImagePath': null, // Example, use actual path if exists
          'firstName': 'Muniba',
          'lastName': 'Farooq',
          'address': 'house 139 block A multi garden B17',
          'landmark': 'Near Park',
          'city': 'Islamabad',
          'postalCode': '74400',
          'phone': '03001234567',
          'country': 'Pakistan',
        };

        final userProvider = Provider.of<UserProvider>(context, listen: false);

        // 1️⃣ Set main user info
        await userProvider.setUser(
          username: backendUser['username'] as String? ?? '',
          email: backendUser['email'] as String? ?? '',
          profileImage: backendUser['profileImagePath'] != null
              ? File(backendUser['profileImagePath'] as String)
              : null,
        );

        // 2️⃣ Save checkout/additional info
        await userProvider.saveCheckoutInfo(
          firstName: backendUser['firstName'],
          lastName: backendUser['lastName'],
          address: backendUser['address'],
          landmark: backendUser['landmark'],
          city: backendUser['city'],
          postalCode: backendUser['postalCode'],
          phone: backendUser['phone'],
          country: backendUser['country'],
        );

        // 3️⃣ Save userId in PreferencesProvider
        final preferencesProvider = Provider.of<PreferencesProvider>(context, listen: false);
        preferencesProvider.userId = userProvider.user!.email;

        // 4️⃣ Navigate to HomeScreen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please correct the errors in the form')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final preferencesProvider = Provider.of<PreferencesProvider>(context);
    const primaryColor = Color(0xFF2e4cb6);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Pick',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2e4cb6),
                          fontFamily: 'Serif',
                        ),
                      ),
                      TextSpan(
                        text: '&',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF7C803),
                          fontFamily: 'Serif',
                        ),
                      ),
                      TextSpan(
                        text: 'Pay',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2e4cb6),
                          fontFamily: 'Serif',
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ready to Get Back to Flow?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                Image.asset(
                  'assets/pick.png',
                  width: 200,
                  height: 200,
                  semanticLabel: 'Pick & Pay cartoon logo',
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Login to Your Account',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email, color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_passwordFocus);
                          },
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            final pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                            if (!RegExp(pattern).hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock, color: Colors.black),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() => _obscurePassword = !_obscurePassword);
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _handleLogin(),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/forget_password');
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 16,
                                color: primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: GestureDetector(
                            onTapDown: _isLoading ? null : (_) => setState(() => _pressed = true),
                            onTapUp: _isLoading ? null : (_) => setState(() => _pressed = false),
                            onTapCancel: _isLoading ? null : () => setState(() => _pressed = false),
                            onTap: _isLoading ? null : () => _handleLogin(),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: _pressed && !_isLoading
                                    ? [
                                  BoxShadow(
                                    color: const Color(0xFFF7C803),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ]
                                    : [],
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Text(
                                'Login',
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                        TextSpan(
                          text: 'Signup',
                          style: TextStyle(
                            fontSize: 15,
                            color: primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}