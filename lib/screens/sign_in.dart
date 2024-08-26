import 'dart:developer';

import 'package:auscy/data.dart';
import 'package:auscy/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_any_logo/flutter_logo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Sign-In')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              user = await _signInWithGoogle();
              showDialog(
                  context: context,
                  builder: (context) {
                    return const CircularProgressIndicator();
                  });
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
                'uid': user!.uid,
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Signed in as ${user!.displayName}'),
                  showCloseIcon: true,
                  behavior: SnackBarBehavior.floating,
                ),
              );

              Navigator.pushReplacement(
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnyLogo.tech.google.image(
                width: 35.w,
              ),
              // const Text('Sign in with Google'),
            ],
          ),
        ),
      ),
    );
  }
}
