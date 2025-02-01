import 'dart:developer';

import 'package:auscy/res/res.dart';
import 'package:auscy/screens/auth/otp_verification.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class PhoneSignInScreen extends StatefulWidget {
  const PhoneSignInScreen({super.key});
  static const route = '/phone-signin';

  @override
  State<PhoneSignInScreen> createState() => _PhoneSignInScreenState();
}

class _PhoneSignInScreenState extends State<PhoneSignInScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _countryCode = '+234';

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Sign-In'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              onTapOutside: (_) {
                FocusScope.of(context).unfocus();
              },
              onChanged: (value) {
                setState(() {});
              },
              style: TextStyle(
                color: isDarkMode ? lightColor : darkColor,
              ),
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: isDarkMode ? lightColor : darkColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: primaryColor,
                    width: 2.sp,
                  ),
                ),
                prefixIcon: CountryCodePicker(
                  onChanged: (countryCode) {
                    setState(() {
                      _countryCode = countryCode.dialCode!;
                    });
                  },
                  showDropDownButton: true,
                  initialSelection: 'NG',
                  favorite: ['+234', 'NG'],
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                  searchDecoration: InputDecoration(
                    hintStyle: TextStyle(
                      color: isDarkMode ? lightColor : darkColor,
                    ),
                  ),
                  barrierColor: Colors.transparent,
                  textStyle: TextStyle(
                    color: isDarkMode ? lightColor : darkColor,
                  ),
                ),
              ),
            ),
            Spacer(),
            if (_phoneController.text.trim().length > 4)
              ZoomTapAnimation(
                child: ElevatedButton(
                  onPressed: () {
                    final phoneNumber =
                        '$_countryCode${_phoneController.text.trim()}';
                    verifyPhoneNumber(context, phoneNumber);
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    minimumSize: Size(double.infinity, 48.h),
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.black,
                    splashFactory: NoSplash.splashFactory,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: lightColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> verifyPhoneNumber(
      BuildContext context, String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        log("Phone number automatically verified and user signed in.");
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(message: "Phone number verified."),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        log("Verification failed: ${e.message}");
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(message: "Verification failed. Try again."),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              phoneNumber: phoneNumber,
              verificationId: verificationId,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        log("Timeout. Verification ID: $verificationId");
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(message: "Verification timeout. Try again."),
        );
      },
    );
  }
}
