import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _userId = "Anonymous";
  String _userName = "Anonymous";
  String _email = "Anonymous";
  bool _isAuthenticated = false;

  String get userId => _userId;
  String get userName => _userName;
  String get email => _email;
  bool get isAuthenticated => _isAuthenticated;

  void setUser(String userId, String userName, String email) {
    _userId = userId;
    _userName = userName;
    _email = email;
    _isAuthenticated = true;
    notifyListeners();
  }

  void setAnonymous() {
    _userId = "anonymous";
    _userName = "anonymous";
    _email = "anonymous";
    _isAuthenticated = false;
    notifyListeners();
  }

  void handleLogin(String userId, String userName, String email) {
    setUser(userId, userName, email);
  }
}
