import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'chat_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  await Supabase.initialize(
    url: 'https://bcmyfqnqvdcutsxgcuoa.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJjbXlmcW5xdmRjdXRzeGdjdW9hIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzkxNTI2NDYsImV4cCI6MTk5NDcyODY0Nn0.ljaHIp1qeLRZUNCkLHFBVbSqO20fLktvA-AyQ2d8l14',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGPT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        fontFamily: "Poppins",
      ),
      home: const ChatScreen(),
    );
  }
}
