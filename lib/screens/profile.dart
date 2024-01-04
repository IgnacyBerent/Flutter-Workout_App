import 'package:flutter/material.dart';
import 'package:workout_app/firestore/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final User? user = Auth().currentUser;

  void _signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [],
      ),
    );
  }
}
