import 'dart:developer';

import 'package:auscy/res/res.dart';
import 'package:pinput/pinput.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  final String phoneNumber;
  final String verificationId;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OTP Verification',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 8),
            Row(
              children: [
                Expanded(
                  child: AppBoldText(
                    'Enter the OTP sent to ${widget.phoneNumber}',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            16.sH,
            Pinput(
              length: 6,
              controller: _otpController,
              autofocus: true,
              onTapOutside: (_) {
                FocusScope.of(context).unfocus();
              },
              keyboardType: TextInputType.number,
              defaultPinTheme: PinTheme(
                width: 45.w,
                height: 45.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                textStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 45.w,
                height: 45.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                textStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              errorPinTheme: PinTheme(
                width: 45.w,
                height: 45.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.red,
                  ),
                ),
                textStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onCompleted: (pin) async {
                await signInWithOTP(widget.verificationId, pin);
              },
              onSubmitted: (pin) async {
                await signInWithOTP(widget.verificationId, pin);
              },
            ),
            Spacer(flex: 8),
          ],
        ),
      ),
    );
  }

  Future<void> signInWithOTP(String verificationId, String otp) async {
    Loader.show(context);
    FirebaseAuth auth = FirebaseAuth.instance;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    try {
      final userCredentials = await auth.signInWithCredential(credential);
      log("User signed in successfully.");
      log('$userCredentials');
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          message: 'User signed in successfully.',
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );

      if (userCredentials.user != null) {
        var box = Hive.box('userBox');
        box.put('uid', userCredentials.user?.uid);

        await usersDB.doc(user!.uid).set({
          'email': user!.email,
          'name': user!.displayName,
          'photoURL': user!.photoURL,
          'uid': user!.uid,
        }, SetOptions(merge: true));

        Loader.hide(context);

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    } catch (e) {
      Loader.hide(context);
      log("Error signing in: $e");
      if (e is FirebaseAuthException) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: e.message!.split('.').first,
          ),
        );
      } else {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: '$e',
          ),
        );
      }
    }
  }
}
