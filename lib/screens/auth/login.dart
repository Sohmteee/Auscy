import 'dart:developer' as dev;

import 'package:auscy/res/res.dart';
import 'package:auscy/screens/auth/phone.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

User? user = FirebaseAuth.instance.currentUser;

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});
  static const route = '/login';

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    var box = Hive.box('userBox');
    var uid = box.get('uid');

    if (uid != null) {
      return const HomeScreen();
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 16.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 1),
              Row(
                children: [
                  AppBoldText(
                    'Sign in',
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              Spacer(flex: 3),
              _buildGoogleSignInButton(),
              16.sH,
              _buildPhoneSignInButton(isDarkMode),
              Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  /// Handles Google Sign-In
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // User canceled

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        var box = Hive.box('userBox');
        box.put('uid', user.uid);

        await usersDB.doc(user.uid).set({
          'email': user.email,
          'name': user.displayName,
          'photoURL': user.photoURL,
          'uid': user.uid,
        }, SetOptions(merge: true));

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    } catch (e) {
      dev.log("Google Sign-In Error: $e");
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(message: "Google Sign-In Failed. Try again."),
      );
    }
  }

  /// Build Google Sign-In Button
  Widget _buildGoogleSignInButton() {
    return ZoomTapAnimation(
      child: ElevatedButton.icon(
        onPressed: _signInWithGoogle,
        icon: SvgPicture.asset(
          'assets/svg/google-icon.svg',
          height: 24.h,
        ),
        label: AppText(
          'Sign in with Google',
          fontSize: 16.sp,
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: Size(double.infinity, 48.h),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          splashFactory: NoSplash.splashFactory,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }

  /// Build Phone Sign-In Button
  Widget _buildPhoneSignInButton(bool isDarkMode) {
    return ZoomTapAnimation(
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PhoneSignInScreen(),
            ),
          );
        },
        icon: Icon(
          Icons.phone,
          color: isDarkMode ? lightColor : darkColor,
          size: 24.sp,
        ),
        label: AppText(
          'Sign in with Phone',
          fontSize: 16.sp,
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: Size(double.infinity, 48.h),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          splashFactory: NoSplash.splashFactory,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }
}
