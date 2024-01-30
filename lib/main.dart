import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_app/firebase_options.dart';
import 'package:workout_app/widgets/widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
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
        cardTheme: const CardTheme().copyWith(
          color: const Color.fromARGB(255, 5, 1, 14),
          shadowColor: const Color.fromARGB(255, 185, 119, 80),
          elevation: 1,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
            side: BorderSide(
              color: Color.fromARGB(255, 22, 1, 13),
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
        ),
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 182, 135, 5),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            disabledForegroundColor: Colors.blue.withOpacity(0.38),
            disabledBackgroundColor: Colors.blue.withOpacity(0.12),
            backgroundColor: const Color.fromARGB(255, 8, 0, 15),
            shadowColor: const Color.fromARGB(255, 185, 119, 80),
            elevation: 7,
            side: const BorderSide(
                color: Color.fromARGB(255, 22, 1, 13),
                width: 2, //change border width
                style: BorderStyle.solid),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
      home: const WidgetTree(),
    );
  }
}
