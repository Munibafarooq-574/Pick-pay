import 'package:flutter/material.dart';
import 'package:pick_pay/providers/preferences_provider.dart';
import 'package:pick_pay/providers/user_provider.dart';
import 'package:pick_pay/screens/get_started.dart';
import 'package:pick_pay/screens/home_screen.dart';
import 'package:pick_pay/screens/login_screen.dart';
import 'package:pick_pay/screens/signup_screen.dart';
import 'package:provider/provider.dart';
import 'screens/logo_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userProvider = UserProvider();
  // 🔥 Load saved user info from SharedPreferences
  await userProvider.loadUserFromPrefs();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PreferencesProvider()),
        // Provide the already-loaded userProvider instance
        ChangeNotifierProvider<UserProvider>.value(value: userProvider),
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
