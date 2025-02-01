import 'package:auscy/res/res.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    background: lightBackgroundColor,
    secondary: lightSecondaryColor,
  ),
  useMaterial3: false,
  fontFamily: 'Quicksand',
  scaffoldBackgroundColor: lightBackgroundColor,
  primaryColor: primaryColor,
  appBarTheme: AppBarTheme(
    backgroundColor: lightBackgroundColor,
    elevation: 0,
    iconTheme: const IconThemeData(
      color: darkColor,
    ),
    titleTextStyle: TextStyle(
      color: darkColor,
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
    ),
  ),
  textTheme: TextTheme(
    bodySmall: TextStyle(
      color: darkColor,
      fontSize: 12.sp,
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    background: darkBackgroundColor,
    secondary: darkSecondaryColor,
  ),
  useMaterial3: false,
  fontFamily: 'Quicksand',
  scaffoldBackgroundColor: darkBackgroundColor,
  primaryColor: primaryColor,
  appBarTheme: AppBarTheme(
    backgroundColor: darkBackgroundColor,
    elevation: 0,
    iconTheme: const IconThemeData(
      color: lightColor,
    ),
    titleTextStyle: TextStyle(
      color: lightColor,
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
    ),
  ),
  textTheme: TextTheme(
    bodySmall: TextStyle(
      color: lightColor,
      fontSize: 12.sp,
    ),
  ),
);
