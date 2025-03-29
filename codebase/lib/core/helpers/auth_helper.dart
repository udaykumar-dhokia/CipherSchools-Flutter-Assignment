import 'package:cipherx_expense_tracker/core/theme/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cipherx_expense_tracker/providers/user_provider.dart';
import 'package:cipherx_expense_tracker/views/auth/login_screen.dart';
import 'package:cipherx_expense_tracker/widgets/bottomnavigation_widget.dart';
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            User? user = snapshot.data;

            if (user != null) {
              // Access UserProvider
              final userProvider = Provider.of<UserProvider>(
                context,
                listen: false,
              );

              // Check if user data is already in UserProvider
              if (userProvider.userId == "Anonymous" ||
                  userProvider.userId != user.uid) {
                // Fetch user details from Firestore
                return FutureBuilder<DocumentSnapshot>(
                  future:
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Scaffold(
                        backgroundColor: AppColors.white,
                        body: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    } else if (userSnapshot.hasError) {
                      return Center(
                        child: Text('Error: ${userSnapshot.error}'),
                      );
                    } else if (userSnapshot.hasData &&
                        userSnapshot.data != null) {
                      final userData =
                          userSnapshot.data!.data() as Map<String, dynamic>;

                      // Update UserProvider with Firestore data
                      userProvider.setUser(
                        user.uid,
                        userData['name'] ?? "Anonymous",
                        userData['email'] ?? "No Email",
                      );

                      return const BottomnavigationWidget();
                    } else {
                      return const Center(child: Text('User data not found.'));
                    }
                  },
                );
              } else {
                // User data is already in UserProvider
                return const BottomnavigationWidget();
              }
            } else {
              return const LoginScreen();
            }
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Set user as anonymous if no user is logged in
            Provider.of<UserProvider>(context, listen: false).setAnonymous();

            return const LoginScreen();
          }
        },
      ),
    );
  }
}
