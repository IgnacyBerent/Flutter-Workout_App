import 'package:flutter/material.dart';
import 'package:workout_app/firestore/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrainingsScreen extends StatelessWidget {
  TrainingsScreen({super.key});

  final User? user = Auth().currentUser;

  void _signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(itemBuilder: (context, index) {}),
    );
  }
}
