import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:frontend/models/UserDTO.dart';
import 'package:frontend/services/hive_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
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

  // Google Sign In
  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // User canceled the sign-in flow
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      // Store user info if it doesn't exist
      User? user = userCredential.user;
      if (user != null) {
        String fullName = user.displayName ?? "Google User";
        List<String> nameParts = fullName.split(" ");
        String firstName = nameParts.isNotEmpty ? nameParts[0] : "Google";
        String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "User";
        
        UserDTO userDTO = UserDTO(
          firstName: firstName,
          lastName: lastName,
        );
        
        await _hiveService.saveUser(user.uid, userDTO);
      }
      
      return userCredential;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In Error: $e")),
      );
      return null;
    }
  }

  // Facebook Sign In
  Future<UserCredential?> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final AuthCredential credential = FacebookAuthProvider.credential(accessToken.token);
        
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        
        // Store user info
        User? user = userCredential.user;
        if (user != null) {
          String fullName = user.displayName ?? "Facebook User";
          List<String> nameParts = fullName.split(" ");
          String firstName = nameParts.isNotEmpty ? nameParts[0] : "Facebook";
          String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "User";
          
          UserDTO userDTO = UserDTO(
            firstName: firstName,
            lastName: lastName,
          );
          
          await _hiveService.saveUser(user.uid, userDTO);
        }
        
        return userCredential;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Facebook Sign-In Canceled")),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Facebook Sign-In Error: $e")),
      );
      return null;
    }
  }

  // Apple Sign In
  Future<UserCredential?> signInWithApple(BuildContext context) async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );
      
      UserCredential userCredential = await _auth.signInWithCredential(oauthCredential);
      
      // Store user info
      User? user = userCredential.user;
      if (user != null) {
        // Apple might not provide name on subsequent logins
        String firstName = credential.givenName ?? "Apple";
        String lastName = credential.familyName ?? "User";
        
        // If Apple didn't provide name, use display name from Firebase if available
        if (firstName == "Apple" && lastName == "User" && user.displayName != null) {
          List<String> nameParts = user.displayName!.split(" ");
          firstName = nameParts.isNotEmpty ? nameParts[0] : firstName;
          lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : lastName;
        }
        
        UserDTO userDTO = UserDTO(
          firstName: firstName,
          lastName: lastName,
        );
        
        await _hiveService.saveUser(user.uid, userDTO);
      }
      
      return userCredential;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Apple Sign-In Error: $e")),
      );
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
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
      case 'account-exists-with-different-credential':
        errorMessage = "An account already exists with the same email but different sign-in credentials.";
        break;
      case 'invalid-credential':
        errorMessage = "The provided credential is invalid.";
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