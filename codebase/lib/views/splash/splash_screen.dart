import 'package:cipherx_expense_tracker/core/theme/app_colors.dart';
import 'package:cipherx_expense_tracker/views/splash/welcome_screen.dart';
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
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => const WelcomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
    });
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
