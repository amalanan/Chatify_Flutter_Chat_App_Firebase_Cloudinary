import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../data/models/auth/user.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _db = GetIt.instance<DatabaseService>();
  final NavigationService _nav = GetIt.instance<NavigationService>();

  UserModel? user;

  AuthenticationProvider() {
    _listenToAuthChanges();
  }

  bool _isappReady = false;

  void setAppReady() {
    _isappReady = true;
  }

  void _listenToAuthChanges() {
    _auth.authStateChanges().listen((firebaseUser) async {
      if (!_isappReady) return;

      if (firebaseUser != null) {
        try {
          await _db.updateUserLastSeen(firebaseUser.uid);

          final snapshot = await _db.getUser(firebaseUser.uid);
          final data = snapshot.data() as Map<String, dynamic>;

          user = UserModel.fromJson(data, firebaseUser.uid);

          _nav.navigateAndClear('/home');
          notifyListeners();
        } catch (e) {
          print("Auth listener error: $e");
        }
      } else {
        user = null;

        _nav.navigateAndClear('/login');
        notifyListeners();
      }
    });
    // _auth.authStateChanges().listen((firebaseUser) async {
    //   if (firebaseUser != null) {
    //     try {
    //       // 🔥 update last active
    //       await _db.updateUserLastSeen(firebaseUser.uid);
    //
    //       // 🔥 fetch user data
    //       final snapshot = await _db.getUser(firebaseUser.uid);
    //
    //       final data = snapshot.data() as Map<String, dynamic>;
    //
    //       user = ChatUser.fromJson(data, firebaseUser.uid);
    //
    //       _nav.navigateAndClear('/home');
    //
    //       notifyListeners();
    //     } catch (e) {
    //       print("Auth listener error: $e");
    //     }
    //   } else {
    //     user = null;
    //     _nav.navigateAndClear('/login');
    //     notifyListeners();
    //   }
    // });
  }

  // ================= LOGIN =================

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print("Login error: $e");
    }
  }

  // ================= REGISTER =================

  Future<String?> register(String email, String password, String name) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user!.uid;

      // 🔥 create user in Firestore immediately
      await _db.createUser(uid: uid, email: email, name: name);

      return uid;
    } catch (e) {
      print("Register error: $e");
      return null;
    }
  }

  // ================= LOGOUT =================

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Logout error: $e");
    }
  }
}
