import 'package:auscy/res/res.dart';
import 'package:auscy/screens/auth/otp_verification.dart';
import 'package:country_code_picker/country_code_picker.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Sign-In'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CountryCodePicker(
              onChanged: (countryCode) {
                setState(() {
                  _countryCode = countryCode.dialCode!;
                });
              },
              initialSelection: 'NG',
              favorite: ['+234', 'NG'],
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              alignLeft: false,
            ),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final phoneNumber =
                    '$_countryCode${_phoneController.text.trim()}';
                Navigator.pushNamed(
                  context,
                  OtpVerificationScreen.route,
                  arguments: phoneNumber,
                );
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
