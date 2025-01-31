import 'package:auscy/res/res.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
  ),
  useMaterial3: false,
  fontFamily: 'Quicksand',
  scaffoldBackgroundColor: Colors.white,
  primaryColor: primaryColor,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
    ),
  ),
);
