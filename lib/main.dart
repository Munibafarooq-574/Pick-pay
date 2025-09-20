import 'package:flutter/material.dart';
import 'package:pick_pay/providers/preferences_provider.dart';
import 'package:pick_pay/providers/user_provider.dart';
import 'package:pick_pay/screens/get_started.dart';
import 'package:pick_pay/screens/home_screen.dart';
import 'package:pick_pay/screens/login_screen.dart';
import 'package:pick_pay/screens/signup_screen.dart';
import 'package:provider/provider.dart';
import 'manager/wishlist_manager.dart'; // Ensure this import is correct
import 'screens/logo_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userProvider = UserProvider();
  // 🔥 Load saved user info from SharedPreferences
  await userProvider.loadUserFromPrefs();

  // Create or use the singleton instance of WishlistManager
  final wishlistManager = WishlistManager.instance; // Use the singleton instance

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PreferencesProvider()),
        ChangeNotifierProvider<UserProvider>.value(value: userProvider),
        ChangeNotifierProvider<WishlistManager>.value(value: wishlistManager), // Use the declared instance
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pick&Pay',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LogoScreen(),
        '/getStarted': (context) => const GetStartedScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/LoginScreen': (context) => const LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}