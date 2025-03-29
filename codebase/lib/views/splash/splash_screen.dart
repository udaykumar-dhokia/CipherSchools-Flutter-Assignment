import 'package:cipherx_expense_tracker/core/helpers/auth_helper.dart';
import 'package:cipherx_expense_tracker/core/helpers/connectivity_helper.dart';
import 'package:cipherx_expense_tracker/core/theme/app_colors.dart';
import 'package:cipherx_expense_tracker/views/home/home_screen.dart';
import 'package:cipherx_expense_tracker/views/splash/welcome_screen.dart';
import 'package:cipherx_expense_tracker/widgets/bottomnavigation_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkConnectivityAndNavigate();
  }

  Future<void> _checkConnectivityAndNavigate() async {
    bool isConnected = await isNetworkAvailable();
    if (isConnected) {
      Future.delayed(const Duration(seconds: 2), () {
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if (user != null) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder:
                    (context, animation, secondaryAnimation) =>
                        const AuthHelper(),
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  const begin = 0.0;
                  const end = 1.0;
                  const curve = Curves.easeInOut;

                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  var fadeAnimation = animation.drive(tween);

                  return FadeTransition(opacity: fadeAnimation, child: child);
                },
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder:
                    (context, animation, secondaryAnimation) =>
                        const WelcomeScreen(),
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  const begin = 0.0;
                  const end = 1.0;
                  const curve = Curves.easeInOut;

                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  var fadeAnimation = animation.drive(tween);

                  return FadeTransition(opacity: fadeAnimation, child: child);
                },
              ),
            );
          }
        });
      });
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(
                  "No Internet Connection",
                  style: GoogleFonts.inter(fontSize: 20),
                ),
                content: Text(
                  "Please check your network connection and try again.",
                  style: GoogleFonts.inter(fontSize: 14),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Retry",
                      style: GoogleFonts.inter(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 50,
        color: AppColors.primary,
        child: Column(
          children: [
            Text("by", style: GoogleFonts.inter(color: AppColors.white)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Open Source",
                  style: GoogleFonts.inter(color: AppColors.white),
                ),
                Text(
                  " Community",
                  style: GoogleFonts.inter(color: Color(0xFFF8A401)),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage("assets/logo.png"), width: 70, height: 70),
            Text(
              "CipherX",
              style: GoogleFonts.brunoAceSc(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
