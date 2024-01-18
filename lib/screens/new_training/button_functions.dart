import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/firestore/firestore.dart';
import 'package:workout_app/providers/training_data_provider.dart';

final FireStoreClass _db = FireStoreClass();

Future<void> showPreviusResults({
  required BuildContext context,
  required WidgetRef ref,
  required String uid,
  required String exerciseName,
}) async {
  final trainingData = ref.read(selectedDataProvider);
  final date = trainingData.date;
  final split = trainingData.split;
  final lastExericeResults = await _db.getLastExerciseResults(
    date: date,
    split: split,
    name: exerciseName,
    uid: uid,
  );

  if (!context.mounted) {
    return;
  }
  if (lastExericeResults.weight == 0.0) {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
          title: Text('Previous results:'),
          content: Text('No previous results found')),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Previous results:'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Weight: ${lastExericeResults.weight}'),
            Text('Reps: ${lastExericeResults.reps}'),
            Text('Bonus Reps: ${lastExericeResults.bonusReps}'),
            Text('One-Rep Max:')
          ],
        ),
      ),
    );
  }
}

void showOneRepMax({
  required BuildContext context,
  required double lift,
  required int reps,
}) {
  double result = lift * (1 + (reps / 30));
  showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text('One-Rep Max:'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(result.toStringAsFixed(1)),
              ],
            ),
          )));
}
