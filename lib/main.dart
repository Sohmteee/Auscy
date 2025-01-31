import 'package:auscy/data/theme.dart';
import 'package:auscy/res/res.dart';

late String apiKey;
late Box box;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  apiKey = dotenv.env['API_KEY']!;

  await Hive.initFlutter();
  await Hive.openBox('userBox');
  box = Hive.box('userBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatRoomProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, _) {
        return MaterialApp(
          title: 'Auscy',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          home: SigninScreen(),
        );
      },
    );
  }
}
