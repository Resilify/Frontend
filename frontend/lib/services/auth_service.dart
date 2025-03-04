import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/UserDTO.dart';
import 'package:frontend/services/hive_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final HiveService _hiveService = HiveService();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Email & Password Sign Up
  Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Update display name
        await user.updateDisplayName("$firstName $lastName");
        
        // Store user data in Hive
        String uid = user.uid;
        UserDTO userDTO = UserDTO(
          firstName: firstName,
          lastName: lastName,
        );
        await _hiveService.saveUser(uid, userDTO);
        
        return userCredential;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e, context);
      return null;
    }
  }

  // Email & Password Sign In
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e, context);
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    return _auth.signOut();
  }

  // Password Reset
  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset email sent to $email")),
      );
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e, context);
    }
  }

  // Error Handler
  void _handleAuthError(FirebaseAuthException e, BuildContext context) {
    String errorMessage = "An error occurred. Please try again.";
    
    switch (e.code) {
      case 'user-not-found':
        errorMessage = "No user found with this email.";
        break;
      case 'wrong-password':
        errorMessage = "Incorrect password.";
        break;
      case 'email-already-in-use':
        errorMessage = "An account already exists with this email.";
        break;
      case 'invalid-email':
        errorMessage = "Please provide a valid email.";
        break;
      case 'weak-password':
        errorMessage = "The password is too weak.";
        break;
      case 'operation-not-allowed':
        errorMessage = "This sign-in method is not enabled.";
        break;
      case 'user-disabled':
        errorMessage = "This account has been disabled.";
        break;
      case 'too-many-requests':
        errorMessage = "Too many requests. Please try again later.";
        break;
      case 'network-request-failed':
        errorMessage = "Network error. Please check your connection.";
        break;
      default:
        errorMessage = "Error: ${e.message}";
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }
}