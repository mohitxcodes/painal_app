import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProviderUser with ChangeNotifier {
  User? _user;
  bool _isAdmin = false;

  User? get user => _user;
  bool get isAdmin => _isAdmin;

  AuthProviderUser() {
    FirebaseAuth.instance.authStateChanges().listen(_authStateChanged);
  }

  Future<void> _authStateChanged(User? user) async {
    _user = user;
    if (_user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_user!.uid)
              .get();
      _isAdmin = doc.exists && doc.data()?['admin'] == true;
    } else {
      _isAdmin = false;
    }
    notifyListeners(); // tell the whole app to update
  }
}
