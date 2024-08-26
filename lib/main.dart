import 'package:auscy/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';

late String apiKey;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  /* await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); */

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  apiKey = dotenv.env['API_KEY']!;

  await Hive.initFlutter();
  await Hive.openBox('chats');
  await Hive.openBox('messages');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (context, _) {
      return MaterialApp(
        title: 'Auscy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.grey,
          fontFamily: "Poppins",
        ),
        home: const HomeScreen(),
      );
    });
  }
}
