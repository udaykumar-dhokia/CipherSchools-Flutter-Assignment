import 'package:cipherx_expense_tracker/views/splash/splash_screen.dart';
import 'package:cipherx_expense_tracker/views/splash/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        "/welcome": (context) => const WelcomeScreen(),
      },
    );
  }
}
