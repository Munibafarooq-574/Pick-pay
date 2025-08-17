import 'package:flutter/material.dart';
import 'package:pick_pay/providers/preferences_provider.dart';
import 'package:pick_pay/providers/user_provider.dart';
import 'package:pick_pay/screens/get_started.dart';
import 'package:pick_pay/screens/home_screen.dart';
import 'package:pick_pay/screens/login_screen.dart';
import 'package:pick_pay/screens/signup_screen.dart';
import 'package:provider/provider.dart';
import 'screens/logo_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PreferencesProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: MaterialApp(
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
        ),
  );
}
}