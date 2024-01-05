import 'package:flutter/material.dart';
import 'package:workout_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workout_app/widgets/widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout App',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 240, 168, 14),
          brightness: Brightness.dark,
          surface: const Color.fromARGB(255, 24, 8, 29),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 9, 8, 10),
        cardTheme: CardTheme().copyWith(
            color: Theme.of(context).colorScheme.onSecondaryContainer),
      ),
      home: const WidgetTree(),
    );
  }
}
