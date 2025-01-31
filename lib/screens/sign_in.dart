// import 'dart:developer';

// import 'package:auscy/res/res.dart';

// class SignInScreen extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   SignInScreen({super.key});

//   Future<User?> _signInWithGoogle() async {
//     final GoogleSignInAccount? googleUser = await GoogleSignIn(
//       scopes: ['email', 'profile'],
//       hostedDomain: '',
//     ).signIn();
//     final GoogleSignInAuthentication googleAuth =
//         await googleUser!.authentication;

//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );

//     final UserCredential userCredential =
//         await _auth.signInWithCredential(credential);
//     return userCredential.user;
//   }

//   @override
//   Widget build(BuildContext context) {
//     var box = Hive.box('userBox');
//     var uid = box.get('uid');

//     if (uid != null) {
//       return HomeScreen();
//     }

//     return Scaffold(
//       body: Center(
//         child: TextButton(
//           onPressed: () async {
//             user = await _signInWithGoogle().then((user) {
//               if (user != null) {
//                 box.put('uid', user.uid);

//                 log('Signed in as ${user.displayName}');
//                 log('Email: ${user.email}');
//                 log('UID: ${user.uid}');

//                 usersDB.doc(user.uid).set(
//                   {
//                     'email': user.email,
//                     'name': user.displayName,
//                     'uid': user.uid,
//                   },
//                   SetOptions(merge: true),
//                 ).then((_) {
//                   Navigator.pop(context);
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const HomeScreen(),
//                     ),
//                   );
//                 }).catchError((e) {
//                   log(e.toString());
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: AppBoldText(
//                         'Failed to sign in, try again.',
//                         textAlign: TextAlign.center,
//                       ),
//                       showCloseIcon: true,
//                       closeIconColor: Colors.white,
//                       backgroundColor: Colors.red,
//                       behavior: SnackBarBehavior.floating,
//                     ),
//                   );
//                 });
//               } else {
//                 log('Failed to sign in');
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: AppBoldText(
//                       'Failed to sign in, try again.',
//                       textAlign: TextAlign.center,
//                     ),
//                     showCloseIcon: true,
//                     closeIconColor: Colors.white,
//                     backgroundColor: Colors.red,
//                     behavior: SnackBarBehavior.floating,
//                   ),
//                 );
//               }
//             }).catchError((e) {
//               log(e.toString());
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: AppBoldText(
//                     e.toString().split(']').last,
//                     textAlign: TextAlign.center,
//                   ),
//                   showCloseIcon: true,
//                   closeIconColor: Colors.white,
//                   backgroundColor: primaryColor,
//                   behavior: SnackBarBehavior.floating,
//                 ),
//               );
//             });
//           },
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SvgPicture.asset(
//                 'assets/svg/google-icon.svg',
//                 width: 20.w,
//               ),
//               SizedBox(width: 8.w),
//               const Text('Sign in with Google'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
