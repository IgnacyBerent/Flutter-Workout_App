import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/models/exercise.dart';
import 'package:workout_app/providers/edit_exercises_provider.dart';
import 'package:workout_app/screens/edit_training/edit_training.dart';
import 'package:workout_app/firestore/firestore.dart';
import 'package:workout_app/firestore/auth.dart';

class TrainingCard extends ConsumerWidget {
  TrainingCard({super.key, required this.split, required this.date});

  final String split;
  final String date;
  final user = Auth().currentUser;
  final FireStoreClass _db = FireStoreClass();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 80,
        child: InkWell(
          onTap: () async {
            List<Exercise> exercises =
                await _db.getExercises(uid: user!.uid, date: date);
            ref.read(editExercisesProvider.notifier).load(exercises);
            if (!context.mounted) {
              return;
            }
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => EditTrainingScreen(
                  split: split,
                  date: date,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: Theme.of(context).colorScheme.onSecondary,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  split,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
