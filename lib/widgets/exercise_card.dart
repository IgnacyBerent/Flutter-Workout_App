import 'package:flutter/material.dart';
import 'package:workout_app/models/exercise.dart';

class ExerciseCard extends StatelessWidget {
  const ExerciseCard(this.exercise, {super.key});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              exercise.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            'Weight: ${exercise.weight} kg',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 14,
            ),
          ),
          Text(
            'Reps: ${exercise.reps}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 14,
            ),
          ),
          Text(
            'Bonus Reps: ${exercise.bonusReps}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
