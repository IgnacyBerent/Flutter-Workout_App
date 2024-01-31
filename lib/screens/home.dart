import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'package:workout_app/firestore/auth.dart';
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
      padding: const EdgeInsets.fromLTRB(20, 120, 20, 20),
      child: Center(
        child: Column(
          children: [
            GradientText(
              'Welcome to HIT app!',
              style: const TextStyle(
                fontSize: 20.0,
              ),
              colors: [
                Theme.of(context).colorScheme.onPrimaryContainer,
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary
              ],
            ),
            const Text('Version 1.2.1', style: TextStyle(fontSize: 12)),
            SizedBox(
              height: 250,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  BlendMode.modulate,
                ),
                child: const Image(
                  image: AssetImage(
                    'assets/AppIconAlpha.png',
                  ),
                ),
              ),
            ),
            const Spacer(),
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
            ),
          ],
        ),
      ),
    );
  }
}
