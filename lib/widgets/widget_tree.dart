import 'package:flutter/material.dart';

import 'package:workout_app/firestore/auth.dart';
import 'package:workout_app/screens/login.dart';
import 'package:workout_app/screens/tabs.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const TabsScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
