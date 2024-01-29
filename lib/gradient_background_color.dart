import 'package:flutter/material.dart';

BoxDecoration gradientBackground() {
  return const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Color.fromARGB(255, 6, 0, 20),
        Color.fromARGB(255, 34, 15, 0),
      ],
    ),
  );
}
