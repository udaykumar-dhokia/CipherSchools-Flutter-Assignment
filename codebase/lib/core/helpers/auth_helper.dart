import 'package:cipherx_expense_tracker/providers/user_provider.dart';
import 'package:cipherx_expense_tracker/views/auth/login_screen.dart';
import 'package:cipherx_expense_tracker/views/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthHelper extends StatefulWidget {
  const AuthHelper({super.key});

  @override
  State<AuthHelper> createState() => _AuthHelperState();
}

class _AuthHelperState extends State<AuthHelper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            User? user = snapshot.data;

            Provider.of<UserProvider>(context, listen: false).setUser(
              user?.uid ?? "Anonymous",
              user?.displayName ?? "Anonymous",
            );

            return HomeScreen();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Provider.of<UserProvider>(context, listen: false).setAnonymous();

            return LoginScreen();
          }
        },
      ),
    );
  }
}
