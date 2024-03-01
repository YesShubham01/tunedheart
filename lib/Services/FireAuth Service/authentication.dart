import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authenticate {
  // checks if user is logged in
  static bool isLoggedIn() {
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      return false;
    } else {
      return true;
    }
  }

  // fetch uid
  static String getUserUid() {
    FirebaseAuth auth = FirebaseAuth.instance;

    return auth.currentUser?.uid ?? "Error";
  }

  //fetch username
  static String getUserName() {
    FirebaseAuth auth = FirebaseAuth.instance;

    return auth.currentUser?.displayName ?? "Error";
  }

  // sign out
  static sign_out() async {
    await FirebaseAuth.instance.signOut();
  }

  // sign up with email and password
  static Future<bool> signup(String email_, String password_) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email_,
        password: password_,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return false;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  // login
  static Future<bool> login(String email_, String password_) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email_,
        password: password_,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return false;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return false;
      } else {
        return false;
      }
    }
    return true;
  }

  // continue with google
  static Future<bool> continueWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        await auth.signInWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
          print(e);
          return false;
        } else if (e.code == 'invalid-credential') {
          // handle the error here

          print(e);
          return false;
        }
      } catch (e) {
        // handle the error here
        print(e);
        return false;
      }
    }

    // FireStore().createNewUser();

    return true;
  }
}
