import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/firestore/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workout_app/providers/trainings_provider.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen(this.selectPage, {super.key});

  final User? user = Auth().currentUser;
  final Function selectPage;

  void _signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(trainingsProvider.notifier).clear();
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 40),
      child: Center(
        child: Column(
          children: [
            const Text('Welcome to HIT app!', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 150),
            SizedBox(
              height: 70,
              width: 250,
              child: ElevatedButton(
                onPressed: () => selectPage(0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back),
                    Text('Your profile'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 70,
              width: 250,
              child: ElevatedButton(
                onPressed: () => selectPage(2),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Your trainings'),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Want to change an account?"),
                TextButton(
                  onPressed: _signOut,
                  child: const Text('Sign Out'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
