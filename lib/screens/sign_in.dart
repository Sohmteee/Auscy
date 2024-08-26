import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Sign-In')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            User? user = await _signInWithGoogle();
            if (user != null) {
              print('Signed in as ${user.displayName}');
            }
          },
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}
