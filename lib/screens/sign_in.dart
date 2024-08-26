import 'dart:developer';

import 'package:auscy/data.dart';
import 'package:auscy/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toast/toast.dart';

class SignInScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  SignInScreen({super.key});

  Future<User?> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Sign-In')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              user = await _signInWithGoogle();
            } catch (e) {
              log(e.toString());
            }

            if (user != null) {
              log('Signed in as ${user!.displayName}');
              log('Email: ${user!.email}');
              log('UID: ${user!.uid}');

              usersDB.doc(user!.uid).set({
                'email': user!.email,
                'name': user!.displayName,
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Signed in as ${user!.displayName}'),
                  showCloseIcon: true,
                  behavior: SnackBarBehavior.floating,
                ),
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            } else {
              log('Failed to sign in');
              ToastContext().init(context);
              Toast.show(
                'Failed to sign in',
                duration: 3,
                gravity: Toast.bottom,
              );
            }
          },
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
