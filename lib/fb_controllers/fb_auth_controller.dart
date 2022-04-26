import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/helpers.dart';

typedef UserAuthStatus = void Function({required bool loggedIn});

class FirebaseAuthController with Helpers {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> signIn(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        if (userCredential.user!.emailVerified) {
          return true;
        } else {
          await signOut();
          showSnackBar(
              context: context,
              message: "Verify email to login into the app!",
              error: true);
          return false;
        }
      }
      return false;
    } on FirebaseAuthException catch (exception) {
      _controlException(context, exception);
    } catch (exception) {
      print("Exception : $exception");
    }
    return false;
  }

  Future<bool> createAccount(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      userCredential.user?.sendEmailVerification();
      return true;
    } on FirebaseAuthException catch (exception) {
      _controlException(context, exception);
    } catch (exception) {
      //
    }
    return false;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  bool loggedIn() => (_firebaseAuth.currentUser != null);

  // or instead of using .currentUser above :
  StreamSubscription<User?> checkUserStatus(UserAuthStatus userAuthStatus) {
    return _firebaseAuth.authStateChanges().listen((event) {
      userAuthStatus(loggedIn: (event != null));
    });
  }

  void _controlException(
      BuildContext context, FirebaseAuthException exception) {
    showSnackBar(
        context: context, message: exception.message ?? "Error!", error: true);
    switch (exception.code) {
      case "invalid-email":
        break;
      case "user-disabled":
        break;
      case "user-not-found":
        break;
      case "wrong-password":
        break;
    }
  }
}
