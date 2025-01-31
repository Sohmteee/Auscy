import 'dart:developer' as dev;

import 'package:auscy/res/res.dart';
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
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              Spacer(flex: 3),
              Row(
                children: [
                  Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Spacer(flex: 2),
              _buildEmailField(),
              16.sH,
              _buildPasswordField(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      //TODO:  Implement forgot password navigation
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(flex: 1),
              _buildSignInButton(),
              16.sH,
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.black38,
                    ),
                  ),
                  15.sW,
                  Text('OR'),
                  15.sW,
                  Expanded(
                    child: Divider(
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
              16.sH,
              _buildGoogleSignInButton(),
              Spacer(flex: 3),
              // _buildRegisterText(),
              // 10.sH,
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

  /// Handles Email/Password Sign In
  void _login() async {
    if (emailController.text.trim().isEmpty) {
      setState(() {
        _emailError = 'Please provide an email';
      });
      return;
    }

    if (passwordController.text.trim().isEmpty) {
      setState(() {
        _passwordError = 'Please provide a password';
      });
      return;
    }

    Loader.show(context);

    await _auth
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((userCredential) {
      final user = userCredential.user;
      if (user != null) {
        Hive.box('userBox').put('uid', user.uid);

        usersDB.doc(user.uid).set({
          'email': user.email,
          'name': user.displayName,
          'uid': user.uid,
        }, SetOptions(merge: true));

        Loader.hide(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    }).catchError((error) {
      Loader.hide(context);
      dev.log(error.toString());
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
            message: "Sign in failed. Check your credentials."),
      );
    });
  }

  /// Build Email TextField
  Widget _buildEmailField() {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: _emailError,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
      onChanged: (value) {
        setState(() {
          _emailError = AuthValidator.validateEmail(value);
        });
      },
    );
  }

  /// Build Password TextField
  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: _passwordError,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? IconlyLight.hide : IconlyLight.show,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
    );
  }

  /// Build Sign In Button
  Widget _buildSignInButton() {
    return ZoomTapAnimation(
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: Size(double.infinity, 48.h),
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Text(
          'Sign in',
          style: TextStyle(fontSize: 18.sp, color: Colors.white),
        ),
      ),
    );
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
        label: Text(
          'Sign in with Google',
          style: TextStyle(fontSize: 16.sp),
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
