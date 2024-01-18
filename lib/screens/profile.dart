import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_app/firestore/auth.dart';
import 'package:workout_app/providers/trainings_provider.dart';

class ProfileScreen extends ConsumerWidget {
  ProfileScreen({super.key});

  final User? user = Auth().currentUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(trainingsProvider.notifier).clear();
    });

    return Center(
      child: Column(
        children: [],
      ),
    );
  }
}
