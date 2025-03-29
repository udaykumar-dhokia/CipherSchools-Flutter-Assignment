import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cipherx_expense_tracker/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;

  User? get user => _user;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // User canceled the sign-in

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Google credentials
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Get the user's UID
      String uid = userCredential.user!.uid;

      // Check if the user already exists in Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        // If the user does not exist, store their data in Firestore
        await _firestore.collection('users').doc(uid).set({
          'name': userCredential.user!.displayName ?? "Anonymous",
          'email': userCredential.user!.email ?? "No Email",
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      _setUserData(context);
      Navigator.pushReplacementNamed(context, '/homepage');
    } catch (e) {
      print(e.toString());
      throw e; // Re-throw the error to handle it in the UI
    }
  }

  Future<void> loginWithEmailPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _setUserData(context);
      Navigator.pushReplacementNamed(context, '/homepage');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> registerWithEmailPassword(
    BuildContext context,
    String email,
    String password,
    String name, // Added name parameter
  ) async {
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Get the user's UID
      String uid = userCredential.user!.uid;

      // Store user data in Firestore
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'password':
            password, // Storing password is not recommended; use hashing if necessary
        'createdAt': FieldValue.serverTimestamp(),
      });

      _setUserData(context);
      Navigator.pushReplacementNamed(context, '/homepage');
    } catch (e) {
      print(e.toString());
      throw e; // Re-throw the error to handle it in the UI
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      Provider.of<UserProvider>(context, listen: false).setAnonymous();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print(e.toString());
    }
  }

  void _setUserData(BuildContext context) {
    final user = _auth.currentUser;
    if (user != null) {
      Provider.of<UserProvider>(context, listen: false).setUser(
        user.uid,
        user.displayName ?? "Anonymous",
        user.email ?? "No Email",
      );
    }
  }
}
