import 'package:auscy/data/theme.dart';
import 'package:auscy/res/res.dart';
import 'package:deepgram_speech_to_text/deepgram_speech_to_text.dart';

late Box box;
late Deepgram deepgram;
late GenerativeModel gemini;

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
  gemini = GenerativeModel(
    model: "gemini-1.5-flash-latest",
    apiKey: dotenv.env['GEMINI_API_KEY']!,
    generationConfig: GenerationConfig(
      temperature: .7,
    ),
  );
  deepgram = Deepgram(
    dotenv.env['DEEPGRAM_API_KEY']!,
    baseQueryParams: {
      'model': 'nova-2-conversationalai',
      // 'detect_language': true,
      'filler_words': false,
      'punctuate': true,
    },
  );

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
