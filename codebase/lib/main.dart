import 'package:cipherx_expense_tracker/firebase_options.dart';
import 'package:cipherx_expense_tracker/providers/auth_provider.dart';
import 'package:cipherx_expense_tracker/providers/user_provider.dart';
import 'package:cipherx_expense_tracker/views/auth/login_screen.dart';
import 'package:cipherx_expense_tracker/views/auth/signup_screen.dart';
import 'package:cipherx_expense_tracker/views/splash/splash_screen.dart';
import 'package:cipherx_expense_tracker/views/splash/welcome_screen.dart';
import 'package:cipherx_expense_tracker/widgets/bottomnavigation_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
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
        "/login": (context) => const LoginScreen(),
        "/signup": (context) => const SignupScreen(),
        "/homepage": (context) => const BottomnavigationWidget(),
      },
    );
  }
}
